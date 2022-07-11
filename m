Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EBC57097D
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 19:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiGKRvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 13:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiGKRvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 13:51:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8A477A5D;
        Mon, 11 Jul 2022 10:51:19 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a15so5482056pjs.0;
        Mon, 11 Jul 2022 10:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hT5O4b/xtjj0nqx+Ih2gE+TubJQ0wi3YFJCk1WxbPgE=;
        b=nySU2uIuk976j5mjoMSiA42jR5UkiNkD+KgtHll1YHJcLBQuhLoeof+mp4wIDBYqFc
         NUULX553vmeH6m9Be1kUxR/QQLfzeO2rT7/7YH5NQFlsR79kNjAbX6l9OTQH51I3gndx
         3Zg1XgTQbeYDsywJF2MB6uX+C0md373XFDKWGkwfI209DhV8rhE1vd+thEKKKFv1Uidr
         /eTJPLVhCQrqW4Yp2+OS+6815AWPRpQjUlMkNazGaDlfdlbiQERjVn+l8R3Eo/W8NF8p
         7PLVK72oqjWVwgXEFRH8lPnlhnA4fjA41SbNTaxqIM6SpWY5dJbi1Rxc9sSlzrGQx86l
         vVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hT5O4b/xtjj0nqx+Ih2gE+TubJQ0wi3YFJCk1WxbPgE=;
        b=qKloQkkkDjNOlGzFUrs0IXGi2QiMcEqqMPYGVr/Nt+PvSmVVrKRpRXrOAmtX1lqy4I
         1qoQPh2DFykcYoo560IFscyTZA6vqSUnmCBq+o3PhYFLbEHTX9hFQW+aDI7LseLo6nmd
         jqPt6T+mMisLcgpiAX74ZiKvS/010XBxuPa4xxrUo1rWmrSFzptqk3dcfoc/KA824PCv
         t3W0XlCIlwFBDsPT8nN6dFWyvOaAduzwdYwm4XkEiu3WaZ9UWGPXmqkNK/sHFJxfv9qJ
         XkJ4wZ8ydki9d3WaD0LNeSKqbCtmsJyP6341GQt62bemg/NSDS4/WKHGTIKrFEQ6KSO6
         mt0w==
X-Gm-Message-State: AJIora+z5kfUWPk40et8KX8+xwRy8qlYYIewGO7zFY4jnW5FdA44i/NF
        N3RK26uMKHO9GOb01j6v1QK7nlYgVh5wELdBcA0=
X-Google-Smtp-Source: AGRyM1uH0D9a1Nd0iFMGN0N/p3tYR6aHkvve+XK/rxBiU3O6VIZR/ZXnbL04EdO5tQ4Lyt4tfCVDuw==
X-Received: by 2002:a17:903:120c:b0:167:8847:21f2 with SMTP id l12-20020a170903120c00b00167884721f2mr19483187plh.11.1657561878582;
        Mon, 11 Jul 2022 10:51:18 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id h14-20020a056a00000e00b0051bbe085f16sm5041737pfk.104.2022.07.11.10.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 10:51:18 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, linux-kernel@vger.kernel.org, aajith@arista.com,
        roopa@nvidia.com, aroulin@nvidia.com, sbrivio@redhat.com,
        jhpark1013@gmail.com
Subject: [PATCH net-next 2/3] net: ipv6: new accept_untracked_na option to accept na only if in-network
Date:   Mon, 11 Jul 2022 13:51:17 -0400
Message-Id: <b6e5bba1086cb078dd9808f7fbb2fe22e86c162d.1657556229.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1657556229.git.jhpark1013@gmail.com>
References: <cover.1657556229.git.jhpark1013@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a third knob, '2', which extends the
accept_untracked_na option to learn a neighbor only if the src ip is
in the same subnet of addresses configured on the interfaces. This is
similar to the arp_accept configuration for ipv4.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
Suggested-by: Roopa Prabhu <roopa@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 50 +++++++++++++++-----------
 net/ipv6/addrconf.c                    |  2 +-
 net/ipv6/ndisc.c                       | 29 ++++++++++++---
 3 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 599373601a2b..2ee32224cae8 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2482,27 +2482,36 @@ drop_unsolicited_na - BOOLEAN
 
 	By default this is turned off.
 
-accept_untracked_na - BOOLEAN
-	Add a new neighbour cache entry in STALE state for routers on receiving a
-	neighbour advertisement (either solicited or unsolicited) with target
-	link-layer address option specified if no neighbour entry is already
-	present for the advertised IPv6 address. Without this knob, NAs received
-	for untracked addresses (absent in neighbour cache) are silently ignored.
-
-	This is as per router-side behaviour documented in RFC9131.
-
-	This has lower precedence than drop_unsolicited_na.
-
-	This will optimize the return path for the initial off-link communication
-	that is initiated by a directly connected host, by ensuring that
-	the first-hop router which turns on this setting doesn't have to
-	buffer the initial return packets to do neighbour-solicitation.
-	The prerequisite is that the host is configured to send
-	unsolicited neighbour advertisements on interface bringup.
-	This setting should be used in conjunction with the ndisc_notify setting
-	on the host to satisfy this prerequisite.
+accept_untracked_na - INTEGER
+	Define behavior for accepting neighbor advertisements from devices that
+	are absent in the neighbor cache:
 
-	By default this is turned off.
+	- 0 - (default) Do not accept unsolicited and untracked neighbor
+	  advertisements.
+
+	- 1 - Add a new neighbor cache entry in STALE state for routers on
+	  receiving a neighbor advertisement (either solicited or unsolicited)
+	  with target link-layer address option specified if no neighbor entry
+	  is already present for the advertised IPv6 address. Without this knob,
+	  NAs received for untracked addresses (absent in neighbor cache) are
+	  silently ignored.
+
+	  This is as per router-side behavior documented in RFC9131.
+
+	  This has lower precedence than drop_unsolicited_na.
+
+	  This will optimize the return path for the initial off-link
+	  communication that is initiated by a directly connected host, by
+	  ensuring that the first-hop router which turns on this setting doesn't
+	  have to buffer the initial return packets to do neighbor-solicitation.
+	  The prerequisite is that the host is configured to send unsolicited
+	  neighbor advertisements on interface bringup. This setting should be
+	  used in conjunction with the ndisc_notify setting on the host to
+	  satisfy this prerequisite.
+
+	- 2 - Extend option (1) to add a new neighbor cache entry only if the
+	  source IP is in the same subnet as the configured address on the
+	  received interface.
 
 enhanced_dad - BOOLEAN
 	Include a nonce option in the IPv6 neighbor solicitation messages used for
@@ -2984,4 +2993,3 @@ max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
 	Default: 10
-
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 88becb037eb6..6ed807b6c647 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7042,7 +7042,7 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.accept_untracked_na,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec,
 		.extra1		= (void *)SYSCTL_ZERO,
 		.extra2		= (void *)SYSCTL_ONE,
 	},
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index cd84cbdac0a2..57b0b1c9123a 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -967,6 +967,26 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		in6_dev_put(idev);
 }
 
+static int accept_untracked_na(struct net_device *dev, struct in6_addr *saddr)
+{
+	struct inet6_dev *idev = __in6_dev_get(dev);
+
+	switch (idev->cnf.accept_untracked_na) {
+	case 0: /* don't accept untracked (absent in neighbor cache) */
+		return 0;
+	case 1: /* create new entries if entry currently untracked */
+		return 1;
+	case 2: /*
+		 * create new entries from untracked only if saddr is in the
+		 * same subnet as an address configured on the incoming
+		 * interface
+		 */
+		return ipv6_chk_prefix(saddr, dev) ? 1 : 0;
+	default:
+		return 0;
+	}
+}
+
 static void ndisc_recv_na(struct sk_buff *skb)
 {
 	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
@@ -1062,10 +1082,11 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	 */
 	new_state = msg->icmph.icmp6_solicited ? NUD_REACHABLE : NUD_STALE;
 	if (!neigh && lladdr &&
-	    idev && idev->cnf.forwarding &&
-	    idev->cnf.accept_untracked_na) {
-		neigh = neigh_create(&nd_tbl, &msg->target, dev);
-		new_state = NUD_STALE;
+	    idev && idev->cnf.forwarding) {
+		if (accept_untracked_na(dev, saddr)) {
+			neigh = neigh_create(&nd_tbl, &msg->target, dev);
+			new_state = NUD_STALE;
+		}
 	}
 
 	if (neigh && !IS_ERR(neigh)) {
-- 
2.30.2

