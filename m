Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F6E487410
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 09:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345755AbiAGIVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 03:21:38 -0500
Received: from m12-12.163.com ([220.181.12.12]:6663 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345731AbiAGIVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 03:21:34 -0500
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2022 03:21:34 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=rnx5v
        6+tGtKGsPAevHZRaDDvAT6O9esxBMhr7mxS15U=; b=cjpqjjlyNuwk/rG24BL7a
        SS3GxrovVWVbP0WN3vftXskqI6OeM/jndo6FG8BiefhtRdZOzbohW7Gg07KF1PRu
        FTECWXolr1GiolHUUrmfHZnzjyEoHRMPESjjcq/ls5B5MOCkl6SwD8N5WzNAUl0F
        NrUMiQDTX8yOSy7b9aT4YE=
Received: from localhost.localdomain (unknown [115.227.228.231])
        by smtp8 (Coremail) with SMTP id DMCowAAXXytp9NdhF2PZGg--.35977S2;
        Fri, 07 Jan 2022 16:06:02 +0800 (CST)
From:   ooppublic@163.com
To:     davem@davemloft.net
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        caixf <ooppublic@163.com>
Subject: [PATCH] net: fix fragments have the disallowed options
Date:   Fri,  7 Jan 2022 16:05:59 +0800
Message-Id: <20220107080559.122713-1-ooppublic@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowAAXXytp9NdhF2PZGg--.35977S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF17CFyxWr1xZr1rGryxuFg_yoWDtwc_u3
        sY9r15J3yUJwn2yw4rZFs5Wr95tr4S9Fn3Gry2vFZ7tw4DXrZ5XFykAF93Ary3GF43CryU
        ZFZ7tryxGa1avjkaLaAFLSUrUUUU8b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5j1v3UUUUU==
X-Originating-IP: [115.227.228.231]
X-CM-SenderInfo: xrrs13peoluqqrwthudrp/1tbiDQqBZFQHZKZS4gAAsD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: caixf <ooppublic@163.com>

When in function ip_do_fragment() enter fsat path,
if skb have opthons, all fragments will have the same options.

Just guarantee the second fragment not have the disallowed options.

Signed-off-by: caixf <ooppublic@163.com>
---
 net/ipv4/ip_output.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9bca57ef8b83..ce178b5eb848 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -826,15 +826,16 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		/* Everything is OK. Generate! */
 		ip_fraglist_init(skb, iph, hlen, &iter);
 
-		if (iter.frag)
-			ip_options_fragment(iter.frag);
-
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
 			if (iter.frag) {
+				bool first_frag = (iter.offset == 0);
+
 				IPCB(iter.frag)->flags = IPCB(skb)->flags;
 				ip_fraglist_prepare(skb, &iter);
+				if (first_frag)
+					ip_options_fragment(iter.frag);
 			}
 
 			skb->tstamp = tstamp;
-- 
2.34.1


