Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5937F6CA0A5
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjC0J6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbjC0J6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:58:11 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Mar 2023 02:58:04 PDT
Received: from tretyak2.mcst.ru (tretyak2.mcst.ru [212.5.119.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087C549EC;
        Mon, 27 Mar 2023 02:58:03 -0700 (PDT)
Received: from tretyak2.mcst.ru (localhost [127.0.0.1])
        by tretyak2.mcst.ru (Postfix) with ESMTP id 72344102376;
        Mon, 27 Mar 2023 12:42:22 +0300 (MSK)
Received: from frog.lab.sun.mcst.ru (frog.lab.sun.mcst.ru [172.16.4.50])
        by tretyak2.mcst.ru (Postfix) with ESMTP id 6CCD110238E;
        Mon, 27 Mar 2023 12:41:27 +0300 (MSK)
Received: from artemiev-i.lab.sun.mcst.ru (avior-1 [192.168.53.223])
        by frog.lab.sun.mcst.ru (8.13.4/8.12.11) with ESMTP id 32R9fQFV020930;
        Mon, 27 Mar 2023 12:41:26 +0300
From:   Igor Artemiev <Igor.A.Artemiev@mcst.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [lvc-project] [PATCH] netfilter: nfnetlink: NULL-check skb->dev in __build_packet_message()
Date:   Mon, 27 Mar 2023 12:41:16 +0300
Message-Id: <20230327094116.1763201-1-Igor.A.Artemiev@mcst.ru>
X-Mailer: git-send-email 2.39.0.152.ga5737674b6
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.39/RELEASE,
         bases: 20111107 #2745587, check: 20230327 notchecked
X-AV-Checked: ClamAV using ClamSMTP
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After having been compared to NULL value at nfnetlink_log.c:560,
pointer 'skb->dev' is dereferenced at nfnetlink_log.c:576.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d97eb280cb2e..2711509eb9a5 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -572,7 +572,7 @@ __build_packet_message(struct nfnl_log_net *log,
 		}
 	}
 
-	if (indev && skb_mac_header_was_set(skb)) {
+	if (indev && skb->dev && skb_mac_header_was_set(skb)) {
 		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
 		    nla_put_be16(inst->skb, NFULA_HWLEN,
 				 htons(skb->dev->hard_header_len)))
-- 
2.30.2

