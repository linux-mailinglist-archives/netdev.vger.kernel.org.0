Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60ACF620646
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 02:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiKHBnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 20:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiKHBnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 20:43:51 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3B1D65B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 17:43:49 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36810cfa61fso123246187b3.6
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 17:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TYfH/+Zkw25YFITTM18H4f306RS4EX9Gac1ggwmK9CE=;
        b=R58I9qPClS1sENu1BkfTGtFmb84yI50gCZSLmlaT5/Sc8n4Z8thbj0x1Pd1WSrvgMI
         loQHzhjMdHA/l+5sbdEs6pRiYd5SpG9k3xMOw1oF8tzGLJRoE9h4EJwJZs061tMnVRXj
         jWPOFwMmpMRf+k5jIX8AbPwSCbNq0WV2P5MxeScbkgjzRd7LNvq48J+BrC4ubH8rH9nf
         XwSBWdMUsn1NQ3dRR3SKGo8cfCybGKw1alM2um2ctH2nceq+Y2k2FG6i9wzGQ/iJlvoV
         AtKkbk2VPgq1ZRgJrOsolzMhkEQ0rBZJDY4Uys9GD8YRtQToFBn5fqk4Yzk2LvuR+7+t
         N2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TYfH/+Zkw25YFITTM18H4f306RS4EX9Gac1ggwmK9CE=;
        b=ZxuEpsA5Kz0hRIfYZELji9TnICOKs1V5YyxPIEZ8AK5q5pGpSf7rg7QQg1Bj/7eevW
         QcRCTUNXk5l/+NPixsvM9lrMqbGUzoVN02YN7Zvzkj+BaP6zDmEJKBQq/rUVSBuqOftu
         OHrSlJovCK1UfXtjdUzgMjPIN25ekMhY5XOF6tkhreu9zDUOzxhMqDqS0eDZr+f8ahAv
         5vLPTjl/MhfgMCe4hc68J7smImXJwzMO6t3BXVXvomqGiUt148TqlJiXgQGj5O5ksDM2
         KPxd3wzAuOwvNdpD8CJFZUZrA/+WVHtwHsYDqbidtDtVnDF4bTKF4hK7YoumUrvByZ7L
         4t6Q==
X-Gm-Message-State: ANoB5pmHQ+LTDFlOOCZY2tIWNRBGW9PTpGVs6/PdbPxEV4NuCqgwQpW2
        JpfjePc9pmGOEKTG7glgEsgbpCELmaV4twDEG3ww36zRL2s2mLUkOmrrqZ+eJeyZkuUvFhIqzuj
        JlzOXYTx1V4lDa8FlTXTGXZTGLrtE1mznmvME8DRSQ5loKTuwOZr+6h6XTq4X+B96TrvBxTCyGq
        K0vw==
X-Google-Smtp-Source: AA0mqf6KKXqo9nUz4Z25xltQGUXbpngit0Qrw+jkSK2YAfC6OM6v7YhdiDLf/jj+O2qXBKVnsEhq2tTomdaiTVnG5PQ=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a25:642:0:b0:6d3:b9d7:ea1b with SMTP
 id 63-20020a250642000000b006d3b9d7ea1bmr570021ybg.639.1667871828712; Mon, 07
 Nov 2022 17:43:48 -0800 (PST)
Date:   Tue,  8 Nov 2022 01:43:32 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221108014332.206517-1-benedictwong@google.com>
Subject: [PATCH ipsec] Fix XFRM-I support for nested ESP tunnels
From:   Benedict Wong <benedictwong@google.com>
To:     netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for nested IPsec tunnels by ensuring that
XFRM-I verifies existing policies before decapsulating a subsequent
policies. Addtionally, this clears the secpath entries after policies
are verified, ensuring that previous tunnels with no-longer-valid
do not pollute subsequent policy checks.

This is necessary especially for nested tunnels, as the IP addresses,
protocol and ports may all change, thus not matching the previous
policies. In order to ensure that packets match the relevant inbound
templates, the xfrm_policy_check should be done before handing off to
the inner XFRM protocol to decrypt and decapsulate.

Notably, raw ESP/AH packets did not perform policy checks inherently,
whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
checks after calling xfrm_input handling in the respective encapsulation
layer.

Test: Verified with additional Android Kernel Unit tests
Signed-off-by: Benedict Wong <benedictwong@google.com>
---
 net/xfrm/xfrm_interface.c | 54 ++++++++++++++++++++++++++++++++++++---
 net/xfrm/xfrm_policy.c    |  5 +++-
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 5113fa0fbcee..0c41ed112081 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -207,6 +207,52 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->mark = 0;
 }
 
+static int xfrmi_input(struct sk_buff *skb, int nexthdr, __be32 spi,
+		       int encap_type, unsigned short family)
+{
+	struct sec_path *sp;
+
+	sp = skb_sec_path(skb);
+	if (sp && (sp->len || sp->olen) &&
+	    !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family))
+		goto discard;
+
+	XFRM_SPI_SKB_CB(skb)->family = family;
+	if (family == AF_INET) {
+		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
+		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = NULL;
+	} else {
+		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
+		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
+	}
+
+	return xfrm_input(skb, nexthdr, spi, encap_type);
+discard:
+	kfree_skb(skb);
+	return 0;
+}
+
+static int xfrmi4_rcv(struct sk_buff *skb)
+{
+	return xfrmi_input(skb, ip_hdr(skb)->protocol, 0, 0, AF_INET);
+}
+
+static int xfrmi6_rcv(struct sk_buff *skb)
+{
+	return xfrmi_input(skb, skb_network_header(skb)[IP6CB(skb)->nhoff],
+			   0, 0, AF_INET6);
+}
+
+static int xfrmi4_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
+{
+	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET);
+}
+
+static int xfrmi6_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
+{
+	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET6);
+}
+
 static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 {
 	const struct xfrm_mode *inner_mode;
@@ -774,8 +820,8 @@ static struct pernet_operations xfrmi_net_ops = {
 };
 
 static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
-	.handler	=	xfrm6_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi6_rcv,
+	.input_handler	=	xfrmi6_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -825,8 +871,8 @@ static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 #endif
 
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
-	.handler	=	xfrm4_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi4_rcv,
+	.input_handler	=	xfrmi4_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
 	.priority	=	10,
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..04f66f6d5729 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3516,7 +3516,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	int xerr_idx = -1;
 	const struct xfrm_if_cb *ifcb;
 	struct sec_path *sp;
-	struct xfrm_if *xi;
+	struct xfrm_if *xi = NULL;
 	u32 if_id = 0;
 
 	rcu_read_lock();
@@ -3667,6 +3667,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
+		if (xi)
+			secpath_reset(skb);
+
 		xfrm_pols_put(pols, npols);
 		return 1;
 	}
-- 
2.38.1.431.g37b22c650d-goog

