Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA0A573FAB
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbiGMWhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiGMWhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:37:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001FC1A05E;
        Wed, 13 Jul 2022 15:37:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so6087794pjo.3;
        Wed, 13 Jul 2022 15:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rvr6j7UaN5VGV3LHJmM0Oblok56ZT0nZGaQ8H5yP6gw=;
        b=Rm0206f99+w1M+mGu0u9cVXiL+6v3ihAKTO2hLWewJEPTV05yzvBRDM4MivAZybcqm
         d0GIOQRRZXtTVS0ULdgPWxBb+dnQAAZd+OHGK59wARzRG2fZ011+luiJvx66qbRaMhep
         5Jia1ApeP0wStf+PSrkMXy/8sk4I5zkoVb9ByICN7Y3yq8KADngctr7pqszuV1kflDtE
         i/zaDNJKOguLxTXnU61UxcCjqhMlj/yx3d4OzWAFSyUxi88p0l+iUFlsGaBRHlgVCzo1
         rwrWMopHSBXoN0qx2J5WAzm06d1wgHW9V5UrRtJ79JziDDp4EJBa/2tF7hGr3f5RirL2
         nbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rvr6j7UaN5VGV3LHJmM0Oblok56ZT0nZGaQ8H5yP6gw=;
        b=mQ0QCaTs+SY7yPyR78kE3In8vS3ex3T3hj34F5PvSE+g+uI0IdoOEQiVy375oVlS3K
         s8Behszs653gkvcX6SVxaTO8rcdqms1SrifXcryokf9EmNWSij+rqrI8ktrbgaHYfTPq
         4tj5+sTY0ebeVsPZIrQvuCsV/s8jbtk9fxCtrEqGknB0Qav+PUdKSemwyOHS9Me6tL4u
         yP/QxOaQNHghsNQDNxnZDiVl6INBAt0a51cvNIIAJPATKsLgMVdPbiSR0isSMvFUcYc/
         N6RMhbchBGbIL0EgS+1jASo/8bhP8NTVL28c9ukAsDWgCiU31KvmDlJHEyVUjLzi5HBb
         P/Mg==
X-Gm-Message-State: AJIora9xVsoZ5Jmc8cNOw4C8w8Hk8QMCuhm4ekpBP6/SwOzg7kPrsH/y
        movvcH1IssS0GiamLsxefJSPD2SHvMotVahK2Uw=
X-Google-Smtp-Source: AGRyM1tarPjS2nwCeO8onebtNzgGuyQHvSxyhTgZwZ9ueFo+KkFH8uh2miT/JhMGMzdfnyY1qxMe6w==
X-Received: by 2002:a17:903:2d1:b0:168:e83e:dab0 with SMTP id s17-20020a17090302d100b00168e83edab0mr5209716plk.118.1657751837389;
        Wed, 13 Jul 2022 15:37:17 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id b18-20020aa78ed2000000b00525302fe9c4sm38639pfr.190.2022.07.13.15.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 15:37:16 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com, jhpark1013@gmail.com
Subject: [PATCH v2 net-next 2/3] net: ipv6: new accept_untracked_na option to accept na only if in-network
Date:   Wed, 13 Jul 2022 15:37:18 -0700
Message-Id: <56d57be31141c12e9034cfa7570f2012528ca884.1657750543.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1657750543.git.jhpark1013@gmail.com>
References: <cover.1657750543.git.jhpark1013@gmail.com>
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
in the same subnet as an address configured on the interface that
received the neighbor advertisement. This is similar to the arp_accept
configuration for ipv4.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
Suggested-by: Roopa Prabhu <roopa@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 51 +++++++++++++++-----------
 net/ipv6/addrconf.c                    |  2 +-
 net/ipv6/ndisc.c                       | 29 ++++++++++++---
 3 files changed, 55 insertions(+), 27 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 5c017fc1e24d..722ec4f491db 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2483,27 +2483,36 @@ drop_unsolicited_na - BOOLEAN
 
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
-
-	By default this is turned off.
+accept_untracked_na - INTEGER
+	Define behavior for accepting neighbor advertisements from devices that
+	are absent in the neighbor cache:
+
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
+	  source IP address is in the same subnet as an address configured on
+	  the interface that received the neighbor advertisement.
 
 enhanced_dad - BOOLEAN
 	Include a nonce option in the IPv6 neighbor solicitation messages used for
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
index cd84cbdac0a2..98453693e400 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -967,6 +967,25 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		in6_dev_put(idev);
 }
 
+static int accept_untracked_na(struct net_device *dev, struct in6_addr *saddr)
+{
+	struct inet6_dev *idev = __in6_dev_get(dev);
+
+	switch (idev->cnf.accept_untracked_na) {
+	case 0: /* Don't accept untracked na (absent in neighbor cache) */
+		return 0;
+	case 1: /* Create new entries from na if currently untracked */
+		return 1;
+	case 2: /* Create new entries from untracked na only if saddr is in the
+		 * same subnet as an address configured on the interface that
+		 * received the na
+		 */
+		return !!ipv6_chk_prefix(saddr, dev);
+	default:
+		return 0;
+	}
+}
+
 static void ndisc_recv_na(struct sk_buff *skb)
 {
 	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
@@ -1061,11 +1080,11 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	 * Note that we don't do a (daddr == all-routers-mcast) check.
 	 */
 	new_state = msg->icmph.icmp6_solicited ? NUD_REACHABLE : NUD_STALE;
-	if (!neigh && lladdr &&
-	    idev && idev->cnf.forwarding &&
-	    idev->cnf.accept_untracked_na) {
-		neigh = neigh_create(&nd_tbl, &msg->target, dev);
-		new_state = NUD_STALE;
+	if (!neigh && lladdr && idev && idev->cnf.forwarding) {
+		if (accept_untracked_na(dev, saddr)) {
+			neigh = neigh_create(&nd_tbl, &msg->target, dev);
+			new_state = NUD_STALE;
+		}
 	}
 
 	if (neigh && !IS_ERR(neigh)) {
-- 
2.30.2

