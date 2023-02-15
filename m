Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE2697E0A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBOOJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBOOJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:09:54 -0500
X-Greylist: delayed 1327 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Feb 2023 06:09:52 PST
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96452D14D;
        Wed, 15 Feb 2023 06:09:51 -0800 (PST)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 31FDlD5K003217
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Feb 2023 14:47:14 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next 1/3] seg6: factor out End lookup nexthop processing to a dedicated function
Date:   Wed, 15 Feb 2023 14:46:57 +0100
Message-Id: <20230215134659.7613-2-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
References: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The End nexthop lookup/input operations are moved into a new helper
function named input_action_end_finish(). This avoids duplicating the
code needed to compute the nexthop in the different flavors of the End
behavior.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 487f8e98deaa..765e89a24bc2 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -364,6 +364,14 @@ static void seg6_next_csid_advance_arg(struct in6_addr *addr,
 	memset(&addr->s6_addr[16 - fnc_octects], 0x00, fnc_octects);
 }
 
+static int input_action_end_finish(struct sk_buff *skb,
+				   struct seg6_local_lwt *slwt)
+{
+	seg6_lookup_nexthop(skb, NULL, 0);
+
+	return dst_input(skb);
+}
+
 static int input_action_end_core(struct sk_buff *skb,
 				 struct seg6_local_lwt *slwt)
 {
@@ -375,9 +383,7 @@ static int input_action_end_core(struct sk_buff *skb,
 
 	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
 
-	seg6_lookup_nexthop(skb, NULL, 0);
-
-	return dst_input(skb);
+	return input_action_end_finish(skb, slwt);
 
 drop:
 	kfree_skb(skb);
@@ -395,9 +401,7 @@ static int end_next_csid_core(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	/* update DA */
 	seg6_next_csid_advance_arg(daddr, finfo);
 
-	seg6_lookup_nexthop(skb, NULL, 0);
-
-	return dst_input(skb);
+	return input_action_end_finish(skb, slwt);
 }
 
 static bool seg6_next_csid_enabled(__u32 fops)
-- 
2.20.1

