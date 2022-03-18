Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256724DE282
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbiCRU3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiCRU3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:29:01 -0400
X-Greylist: delayed 336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Mar 2022 13:27:40 PDT
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84204252782
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:27:40 -0700 (PDT)
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 1A60C2016A7E;
        Fri, 18 Mar 2022 21:22:01 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 1A60C2016A7E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1647634921;
        bh=Xf6L5/j5szpD/D1cQgtGeozRy58IU4zeivpTylyPFbo=;
        h=From:To:Cc:Subject:Date:From;
        b=q2szK11BF92AbHigyu/b3wQ89VubeKgO0dYeLF2eG9hwzH//4qYn/s/yAy6IbrLhp
         7/lt4N7/dx4fUE26/GGsfBwqKiINj4mRwiUr9h/VWkeNEFUr5RaV22HrBibmt12wC+
         TI8WcapheBp4tk1DUgn1tqJ5L2IfWNllwoq0nXEqMayWnT6qKOaxTQfpXoFZbyd9wr
         lOSx67KgGRr79GtmsWVDc28W75agotP2UOPFTu2KFmBfaU3AhiWCqzC51IOZwtbSeo
         OtvOIaU+qImpOIYwtZa/MXWzcx39NXqhIedyGNpK81fTk38PkuiHJPxMDRELaftwX6
         Li3TkS7i+FX9Q==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com,
        Justin Iurman <justin.iurman@uliege.be>
Subject: [RFC net] Discuss seg6 potential wrong behavior
Date:   Fri, 18 Mar 2022 21:21:38 +0100
Message-Id: <20220318202138.37161-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This thread aims to discuss a potential wrong behavior regarding seg6
(as well as rpl). I'm curious to know if there is a specific reason for
discarding the packet when seg6 is not enabled on an interface and when
segments_left == 0. Indeed, reading RFC8754, I'm not sure this is the
right thing to do. I think it would be more correct to process the next
header in the packet. It does not make any sense to prevent further
processing when the SRv6 node has literally nothing to do in that
specific case. For that, we need to postpone the check of accept_seg6.
And, in order to avoid a breach, we also check for accept_seg6 before
decapsulation when segments_left == 0. Any comments on this?

Also, I'm not sure why accept_seg6 is set the current way. Are we not
suppose to prioritize devconf_all? If "all" is set to 1, then it is
enabled for all interfaces. Therefore, having an OR condition looks more
correct. Right now, we need to set both "all" and the interface to 1 so
that seg6 is enabled on this specific interface. Looks odd, thoughts?

Note: this patch could also be applied to rpl, in the same way.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/exthdrs.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 77e34aec7e82..a47c05ac504e 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -374,13 +374,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 	idev = __in6_dev_get(skb->dev);
 
 	accept_seg6 = net->ipv6.devconf_all->seg6_enabled;
-	if (accept_seg6 > idev->cnf.seg6_enabled)
-		accept_seg6 = idev->cnf.seg6_enabled;
-
-	if (!accept_seg6) {
-		kfree_skb(skb);
-		return -1;
-	}
+	accept_seg6 |= idev->cnf.seg6_enabled;
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
 	if (!seg6_hmac_validate_skb(skb)) {
@@ -392,6 +386,11 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 looped_back:
 	if (hdr->segments_left == 0) {
 		if (hdr->nexthdr == NEXTHDR_IPV6 || hdr->nexthdr == NEXTHDR_IPV4) {
+			if (!accept_seg6) {
+				kfree_skb(skb);
+				return -1;
+			}
+
 			int offset = (hdr->hdrlen + 1) << 3;
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
@@ -431,6 +430,11 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 		return -1;
 	}
 
+	if (!accept_seg6) {
+		kfree_skb(skb);
+		return -1;
+	}
+
 	if (skb_cloned(skb)) {
 		if (pskb_expand_head(skb, 0, 0, GFP_ATOMIC)) {
 			__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
-- 
2.25.1

