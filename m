Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4854C4B8FBB
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbiBPRy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:54:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbiBPRy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:54:27 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C2325BD64
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:54:15 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso7181092pjg.0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8SHJLuV4zLjy32ezYei5WUPkDFEPwVswbW0SFXhjfXM=;
        b=njMOQfOTlSSBBXsxT5VQZqeksEgGHOITuxq0K0pb9wi8W5Av6hp3Hrz9XipX92up1W
         LX8wMYxbR1xRc2e1/TU8KkSnhckGs8avGXSeHxwmqlZkisIyKnsdMyrULIGLkF+Z9JWc
         EN06ATsfDjPB63WrY4hzlyfqbvxUVjC1wJiAlydcyHyuih7MnUTXkaG2TB3Nl3tP1JEG
         R5oBxHWy2/RkQDQU5rgymIYMpA14S64AKtwxUxlZSd1L0EoC7mFoaUQ1NGZjMIsJ04Rh
         nN1d+rFhhYfSCzNoCSbrfMV6arzeQnzixZ3AEXYS5AVWkRHmB8P9CtxARuxYw+QkZO5B
         JKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8SHJLuV4zLjy32ezYei5WUPkDFEPwVswbW0SFXhjfXM=;
        b=zYcgtgE/n5EdU7FLgjPwZYDehURrQ9K/XsMMChsiAgejR8oP2GvrLBUDedKkWXnQMT
         2y6u1UpI4a/xatRaUEnV2zXy+yyfK2Uw5kTYrz5F+FUbxZ/O2xglz65uLjpWXqDk6KsD
         doG33SCvi1cnZdnJR51ANO4k8uFkz8wlEiEC1NDnYAiAPvIlUCtYueEwvGEbk5FK5ZUg
         wrecNKenOHdKwscKAbdVzR89RLhMks97ythuSY1vRO4lt06DWQ8FKdng/b5XYL37bIGu
         3rJZbtEDhuZKge9STm+lrluLgSF0giQQ8YfmfxDc5m38BVal2vESVL5AvJ+XBzlmtKa1
         uSNg==
X-Gm-Message-State: AOAM533Od1aSUTH07gcwEFV6+30cb0SLIjzyuMLXU6P+RNK4ohVF84mN
        x4Hzx6HZG8mSLaS8cSKPMZ0=
X-Google-Smtp-Source: ABdhPJyvrsjihWBANEaHDxdjtPZue6a1e+v+iM+w+dSuGqUfu9JE1Xsc2mZXvayGWh8c3NjxE3z4pA==
X-Received: by 2002:a17:90a:fe07:b0:1b7:bb99:c848 with SMTP id ck7-20020a17090afe0700b001b7bb99c848mr3138774pjb.98.1645034054802;
        Wed, 16 Feb 2022 09:54:14 -0800 (PST)
Received: from mhl-ubstemp.lan ([115.187.43.205])
        by smtp.gmail.com with ESMTPSA id 13sm43585601pfm.161.2022.02.16.09.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 09:54:14 -0800 (PST)
From:   Mobashshera Rasool <mobash.rasool.linux@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Mobashshera Rasool <mobash.rasool.linux@gmail.com>,
        equinox@opensourcerouting.org, razor@blackwall.org,
        sharpd@cumulusnetworks.com, mrasool@vmware.com,
        mobash.rasool@gmail.com, saritap@vmware.com, abnr@vmware.com,
        nsaigomathi@vmware.com
Subject: [PATCH] net: ip6mr: add support for passing full packet on wrong mif
Date:   Wed, 16 Feb 2022 17:53:51 +0000
Message-Id: <20220216175351.2217-1-mobash.rasool.linux@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for MRT6MSG_WRMIFWHOLE which is used to pass
full packet and real vif id when the incoming interface is wrong.
While the RP and FHR are setting up state we need to be sending the
registers encapsulated with all the data inside otherwise we lose it.
The RP then decapsulates it and forwards it to the interested parties.
Currently with WRONGMIF we can only be sending empty register packets
and will lose that data.
This behaviour can be enabled by using MRT_PIM with
val == MRT6MSG_WRMIFWHOLE. This doesn't prevent MRT6MSG_WRONGMIF from
happening, it happens in addition to it, also it is controlled by the same
throttling parameters as WRONGMIF (i.e. 1 packet per 3 seconds currently).
Both messages are generated to keep backwards compatibily and avoid
breaking someone who was enabling MRT_PIM with val == 4, since any
positive val is accepted and treated the same.

Signed-off-by: Mobashshera Rasool <mobash.rasool.linux@gmail.com>
---
 include/uapi/linux/mroute6.h |  1 +
 net/ipv6/ip6mr.c             | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h
index a1fd6173e2db..1d90c21a6251 100644
--- a/include/uapi/linux/mroute6.h
+++ b/include/uapi/linux/mroute6.h
@@ -134,6 +134,7 @@ struct mrt6msg {
 #define MRT6MSG_NOCACHE		1
 #define MRT6MSG_WRONGMIF	2
 #define MRT6MSG_WHOLEPKT	3		/* used for use level encap */
+#define MRT6MSG_WRMIFWHOLE	4		/* For PIM Register and assert processing */
 	__u8		im6_mbz;		/* must be zero		   */
 	__u8		im6_msgtype;		/* what type of message    */
 	__u16		im6_mif;		/* mif rec'd on		   */
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 0ebaaec3faf9..a9775c830194 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1040,7 +1040,7 @@ static int ip6mr_cache_report(struct mr_table *mrt, struct sk_buff *pkt,
 	int ret;
 
 #ifdef CONFIG_IPV6_PIMSM_V2
-	if (assert == MRT6MSG_WHOLEPKT)
+	if (assert == MRT6MSG_WHOLEPKT || assert == MRT6MSG_WRMIFWHOLE)
 		skb = skb_realloc_headroom(pkt, -skb_network_offset(pkt)
 						+sizeof(*msg));
 	else
@@ -1056,7 +1056,7 @@ static int ip6mr_cache_report(struct mr_table *mrt, struct sk_buff *pkt,
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 #ifdef CONFIG_IPV6_PIMSM_V2
-	if (assert == MRT6MSG_WHOLEPKT) {
+	if (assert == MRT6MSG_WHOLEPKT || assert == MRT6MSG_WRMIFWHOLE) {
 		/* Ugly, but we have no choice with this interface.
 		   Duplicate old header, fix length etc.
 		   And all this only to mangle msg->im6_msgtype and
@@ -1068,8 +1068,11 @@ static int ip6mr_cache_report(struct mr_table *mrt, struct sk_buff *pkt,
 		skb_reset_transport_header(skb);
 		msg = (struct mrt6msg *)skb_transport_header(skb);
 		msg->im6_mbz = 0;
-		msg->im6_msgtype = MRT6MSG_WHOLEPKT;
-		msg->im6_mif = mrt->mroute_reg_vif_num;
+		msg->im6_msgtype = assert;
+		if (assert == MRT6MSG_WRMIFWHOLE)
+			msg->im6_mif = mifi;
+		else
+			msg->im6_mif = mrt->mroute_reg_vif_num;
 		msg->im6_pad = 0;
 		msg->im6_src = ipv6_hdr(pkt)->saddr;
 		msg->im6_dst = ipv6_hdr(pkt)->daddr;
@@ -1650,6 +1653,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 	mifi_t mifi;
 	struct net *net = sock_net(sk);
 	struct mr_table *mrt;
+	bool do_wrmifwhole;
 
 	if (sk->sk_type != SOCK_RAW ||
 	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
@@ -1763,12 +1767,15 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			return -EINVAL;
 		if (copy_from_sockptr(&v, optval, sizeof(v)))
 			return -EFAULT;
+
+		do_wrmifwhole = (v == MRT6MSG_WRMIFWHOLE);
 		v = !!v;
 		rtnl_lock();
 		ret = 0;
 		if (v != mrt->mroute_do_pim) {
 			mrt->mroute_do_pim = v;
 			mrt->mroute_do_assert = v;
+			mrt->mroute_do_wrvifwhole = do_wrmifwhole;
 		}
 		rtnl_unlock();
 		return ret;
@@ -2144,6 +2151,9 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 			       MFC_ASSERT_THRESH)) {
 			c->_c.mfc_un.res.last_assert = jiffies;
 			ip6mr_cache_report(mrt, skb, true_vifi, MRT6MSG_WRONGMIF);
+			if (mrt->mroute_do_wrvifwhole)
+				ip6mr_cache_report(mrt, skb, true_vifi,
+						   MRT6MSG_WRMIFWHOLE);
 		}
 		goto dont_forward;
 	}
-- 
2.25.1

