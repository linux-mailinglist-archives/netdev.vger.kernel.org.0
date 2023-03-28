Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992076CB58A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjC1Eve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC1Evc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:51:32 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 925091FEE
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=F6/gY
        iJKTm03ttAH0+vczYrnbzDIBF9mCfRUIpCo0fw=; b=ARuduvwjCxdNqEBz45puB
        q9YR/bRM4nKNOqDdFq19fykkdBi00Adyne82aOEwnokiiGMlmCfvw20p9aGRDpJV
        QmuMUpdjQ4IX9oKhQUfIl+p+Fa0p/2hq6gUAXOoaCk0GyKrlaoPmTIpKPH/VyDnC
        CugKgkpvMDstH3zUhEIHPY=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by zwqz-smtp-mta-g3-1 (Coremail) with SMTP id _____wDXt1H+cSJkuCy1Ag--.57399S2;
        Tue, 28 Mar 2023 12:50:08 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, windhl@126.com, netdev@vger.kernel.org
Subject: [PATCH] rionet: Fix refcounting bugs
Date:   Tue, 28 Mar 2023 12:50:06 +0800
Message-Id: <20230328045006.2482327-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDXt1H+cSJkuCy1Ag--.57399S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF15KrW3Xr15ZFy7GF1xKrg_yoW8XF13pF
        4jyFZIyr4vyr4fAayxA3y8Zrn5Aa109ryfK34fXa4avw15ArWq9w12ka42vrW5Jan5Ja4F
        9w4jk343Ca9IqrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEMa07UUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi5QFAF1pD96uZewAAsU
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rionet_start_xmit(), we should put the refcount_inc()
before we add *skb* into the queue, otherwise it may cause
the consumer to prematurely call refcount_dec().
Besides, before the next rionet_queue_tx_msg() when we
meet the 'RIONET_MAC_MATCH', we should also call
refcount_inc() before the skb is added into the queue.

Fixes: 7c4a6106d645 ("rapidio/rionet: fix multicast packet transmit logic")
Signed-off-by: Liang He <windhl@126.com>
---
 drivers/net/rionet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index fbcb9d05da64..72ccbb1aaf11 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -195,17 +195,19 @@ static netdev_tx_t rionet_start_xmit(struct sk_buff *skb,
 		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES(rnet->mport->sys_size);
 				i++)
 			if (nets[rnet->mport->id].active[i]) {
-				rionet_queue_tx_msg(skb, ndev,
-					nets[rnet->mport->id].active[i]);
 				if (count)
 					refcount_inc(&skb->users);
 				count++;
+				rionet_queue_tx_msg(skb, ndev,
+					nets[rnet->mport->id].active[i]);
 			}
 	} else if (RIONET_MAC_MATCH(eth->h_dest)) {
 		destid = RIONET_GET_DESTID(eth->h_dest);
-		if (nets[rnet->mport->id].active[destid])
+		if (nets[rnet->mport->id].active[destid]) {
+			refcount_inc(&skb->users);
 			rionet_queue_tx_msg(skb, ndev,
 					nets[rnet->mport->id].active[destid]);
+		}
 		else {
 			/*
 			 * If the target device was removed from the list of
-- 
2.25.1

