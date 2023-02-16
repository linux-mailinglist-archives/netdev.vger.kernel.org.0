Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C880699A07
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBPQ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPQ32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:28 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0154C3F2
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:24 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4bdeb1bbeafso25670997b3.4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z2b/pa7BPsxyCxV9qMNryAua+HU599nYF7p3XmEUu+4=;
        b=UQ/GAf+EPG+O25AxuHkJbSINz/fynjGHdYguQ0IG5MfLwEBNFGMjMvg9CiBEUIGdgY
         7V+vSbCObULqW9uXjAu9dBsgH/CfKTGeom6D7Hz5zMPsFQFai8f4/Gv/jKCyB6ozuL78
         mJKZEcDABwLDV73U4KkgNwYBDjO9bMa5LrRN/Xj7CDLfzpk18snbGUf+hUDPggA1LXgl
         xkaCmuqdBckVV2ek2HUsHDMg4dzCtN1+aDE8CfU2llA77wvENiA6agun7sF1CbBQS7NQ
         8CJdZI9s3QQbNpPDa0PdKPfaBZK2/RV0rmnkhq8YJr2pR6IexRg5BbyqIHq892tCG24S
         X/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z2b/pa7BPsxyCxV9qMNryAua+HU599nYF7p3XmEUu+4=;
        b=ORrI/i9c14UDbaPjBKpfJIOel8C+7NDia9JirsvgA2+3Z/RAp6vketj1fm97ak9uWv
         XblQS6Pa6faBUjEekXlxtiSk5uvAabXebgY82ZsaFNBJw1gp8IViieMDpR3F5iuz3sau
         pj4anhJWp2t+GfIeQ6tofayTSM0iLuHRW25TeB6w7InviUnsuLY0n9SwwM3S5+LfNwLj
         +PKKm+76HcqHe8wxezbVvAKnJig9l6cG1Dy8rE1fMi1nQcnc+fz9uHguj60x241foU4S
         FJUEU1AQeO6BGd19noUUPfLrQWowbPoX7Ea0++Haa5+z7d9dSQEV/3T72YfKI1C6PDZB
         9wSw==
X-Gm-Message-State: AO0yUKWOyrX0Z+ItCM/hWDje+O5+SdP8Yp8hgzXuzdQShDYxnSF6fYMp
        mZTDF8R2ryRipF3ZBFA76J7o2YRFhmxXsA==
X-Google-Smtp-Source: AK7set/OvLrRIdGwlWcIuG2mOT/RQPMwiytjMB4LsxFagDTne5nNc2uFnN2L++PRYxS+HVpvPHXcaU3kSL8yQg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:10f:b0:855:fa17:4f5f with SMTP
 id o15-20020a056902010f00b00855fa174f5fmr88ybh.1.1676564963202; Thu, 16 Feb
 2023 08:29:23 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:40 +0000
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230216162842.1633734-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-7-edumazet@google.com>
Subject: [PATCH net-next 6/8] ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

This is a generic drop reason for any error detected
in ndisc_parse_options().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h |  3 +++
 net/ipv6/ndisc.c         | 27 ++++++++++-----------------
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index ef3f65d135d375920e88759890947ed0f6e87e10..239a5c0ea83eb6053df55f1ea113f3005ec050b0 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -76,6 +76,7 @@
 	FN(IPV6_NDISC_FRAG)		\
 	FN(IPV6_NDISC_HOP_LIMIT)	\
 	FN(IPV6_NDISC_BAD_CODE)		\
+	FN(IPV6_NDISC_BAD_OPTIONS)	\
 	FNe(MAX)
 
 /**
@@ -330,6 +331,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_IPV6_NDISC_HOP_LIMIT,
 	/** @SKB_DROP_REASON_IPV6_NDISC_BAD_CODE: invalid NDISC icmp6 code. */
 	SKB_DROP_REASON_IPV6_NDISC_BAD_CODE,
+	/** @SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS: invalid NDISC options. */
+	SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index e9776aa6f1675e35273df16e40745779b91d117e..b47e845d66eb8533e2334915fe6f05bed6f84764 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -819,10 +819,8 @@ static enum skb_drop_reason ndisc_recv_ns(struct sk_buff *skb)
 		return reason;
 	}
 
-	if (!ndisc_parse_options(dev, msg->opt, ndoptlen, &ndopts)) {
-		ND_PRINTK(2, warn, "NS: invalid ND options\n");
-		return reason;
-	}
+	if (!ndisc_parse_options(dev, msg->opt, ndoptlen, &ndopts))
+		return SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS;
 
 	if (ndopts.nd_opts_src_lladdr) {
 		lladdr = ndisc_opt_addr_data(ndopts.nd_opts_src_lladdr, dev);
@@ -1026,10 +1024,9 @@ static enum skb_drop_reason ndisc_recv_na(struct sk_buff *skb)
 	    idev->cnf.drop_unsolicited_na)
 		return reason;
 
-	if (!ndisc_parse_options(dev, msg->opt, ndoptlen, &ndopts)) {
-		ND_PRINTK(2, warn, "NS: invalid ND option\n");
-		return reason;
-	}
+	if (!ndisc_parse_options(dev, msg->opt, ndoptlen, &ndopts))
+		return SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS;
+
 	if (ndopts.nd_opts_tgt_lladdr) {
 		lladdr = ndisc_opt_addr_data(ndopts.nd_opts_tgt_lladdr, dev);
 		if (!lladdr) {
@@ -1159,10 +1156,8 @@ static enum skb_drop_reason ndisc_recv_rs(struct sk_buff *skb)
 		goto out;
 
 	/* Parse ND options */
-	if (!ndisc_parse_options(skb->dev, rs_msg->opt, ndoptlen, &ndopts)) {
-		ND_PRINTK(2, notice, "NS: invalid ND option, ignored\n");
-		goto out;
-	}
+	if (!ndisc_parse_options(skb->dev, rs_msg->opt, ndoptlen, &ndopts))
+		return SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS;
 
 	if (ndopts.nd_opts_src_lladdr) {
 		lladdr = ndisc_opt_addr_data(ndopts.nd_opts_src_lladdr,
@@ -1280,10 +1275,8 @@ static enum skb_drop_reason ndisc_router_discovery(struct sk_buff *skb)
 		return reason;
 	}
 
-	if (!ndisc_parse_options(skb->dev, opt, optlen, &ndopts)) {
-		ND_PRINTK(2, warn, "RA: invalid ND options\n");
-		return reason;
-	}
+	if (!ndisc_parse_options(skb->dev, opt, optlen, &ndopts))
+		return SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS;
 
 	if (!ipv6_accept_ra(in6_dev)) {
 		ND_PRINTK(2, info,
@@ -1627,7 +1620,7 @@ static enum skb_drop_reason ndisc_redirect_rcv(struct sk_buff *skb)
 	}
 
 	if (!ndisc_parse_options(skb->dev, msg->opt, ndoptlen, &ndopts))
-		return reason;
+		return SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS;
 
 	if (!ndopts.nd_opts_rh) {
 		ip6_redirect_no_header(skb, dev_net(skb->dev),
-- 
2.39.1.581.gbfd45094c4-goog

