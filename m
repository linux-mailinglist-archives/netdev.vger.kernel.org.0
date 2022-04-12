Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12D54FE354
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbiDLOBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiDLOBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:01:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72B05C669
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A1C1B81E80
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75134C385A9;
        Tue, 12 Apr 2022 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649771936;
        bh=zMkEg32KnDcFv+Srq+fXn/V5ksJss3sMBSytko16YuE=;
        h=From:To:Cc:Subject:Date:From;
        b=kXJSSXpC6mkNGl8FLhqLKzNSGdmu8QlNcQPAd+6dkErWU4ySiHxtB3DXQ76/FTmxK
         VmGTPpXR9cHBfbjoYCRf14Hl3Ayjd5UjaT5MhuPNSnfKdvkFLoM77FY4tBKYvNKhFO
         kr8UIuECvoTHAjYJ0AWN+1rpt/fLWAH2hP3//6rdFIVe2cuErCoGB6/38nrBTxukmW
         UNOuzOk4ZYyMDV+8d7PrjyW+TiLJCNXkdO6lAWdUqIy5RqDvgvzwzQCPOehcPnMrxp
         TZkQHyoCySItrVQeebvlwDBn6FySk339gqRD2Yke7tzy3zQF7Koe9wgh6muxWce8Yb
         XDiOcZH/N9hdA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tun: annotate access to queue->trans_start
Date:   Tue, 12 Apr 2022 15:58:52 +0200
Message-Id: <20220412135852.466386-1-atenart@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
introduced a new helper, txq_trans_cond_update, to update
queue->trans_start using WRITE_ONCE. One snippet in drivers/net/tun.c
was missed, as it was introduced roughly at the same time.

Fixes: 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 276a0e42ca8e..dbe4c0a4be2c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1124,7 +1124,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* NETIF_F_LLTX requires to do our own update of trans_start */
 	queue = netdev_get_tx_queue(dev, txq);
-	queue->trans_start = jiffies;
+	txq_trans_cond_update(queue);
 
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
-- 
2.35.1

