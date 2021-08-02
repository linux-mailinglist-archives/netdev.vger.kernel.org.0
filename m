Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4862D3DCED8
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 05:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhHBDCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 23:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhHBDCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 23:02:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772EEC06175F
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 20:02:38 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u2so9790360plg.10
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 20:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zOyWY+kv0WJok6q4xeAI/88h1OH1WzR/S1RYQ6maVgc=;
        b=W4vWxsL+d0+XLyRQbVyxsnHiDY9GAfCSoyZarVI0nEMHTQEwU0WJJ7pjdI3n0hVOTC
         13SafyIiSMhFcsnn2zbPyEgVafaIYeQdBQVmadlwI1CkAbtArPgnXSVsusjv7P4qiU7s
         v04IzTtRYcO0AAz+yOSWtyReESrsgTMpMYs3dm08OlouhszkyxmGwNmR1RGBUB0uQl6U
         SVLfueZNLwrEWGumKaoLbnW4YpA449DGsvQskzUkB0Yj7s2pG3Wof2bDRa4sZ1+EZezj
         VuYGzCTZhPuhlcwI2dyTtaC5dH+rjfYvzmMv+wGtkGAUpNleUTsRtEWuzBsxxyaktLoa
         d5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zOyWY+kv0WJok6q4xeAI/88h1OH1WzR/S1RYQ6maVgc=;
        b=S6pqheF/sjhWcqaGP/mMqQeGo2rrKxG/RIznr8z4naLRqM5lbrDe+iGcsPQI3vHMdl
         emWpwVbnC8tdY8WGa3BtJrxzeQ3VAp5N6eBVkLL10nj6i5ghZ5cuav4ZY9omj2wmm96F
         g0V7v2fxXPRM0/NEnkZZ8Bw02bWWrojCYFWo56eqgZPDwbMTo1/EW5RTnRz3G6+HBeDM
         FkVYQdkaWVMqFJjfwLWg1Uu30RP653+tXNEMe3NkJ2kK8lpFrmu2TgdK8ZM+iM4p9REh
         4Hzl+q3S8b4XhhX7xIfuP7ClS2eYVFpIZZkI1vCPTDNznuRXbpC5XpIPS4/tndSuwD7O
         Zi6w==
X-Gm-Message-State: AOAM531AM2R6iCvhGdJl34cDvIkIFVAckhKNRVPnGc0cZOQ4gUnCkWQh
        cgsJ2m9+RkSM6DmaEiStsX1Ny4JO7XyH+g==
X-Google-Smtp-Source: ABdhPJx7hD2jIgMyQGUW+PxQ8mKJNfPCN8Mo2y6zxn6Z/inOcDSXVE2m8ZD+HfP7S/GGzNtRFVBaYA==
X-Received: by 2002:a17:90b:2286:: with SMTP id kx6mr15368265pjb.11.1627873357905;
        Sun, 01 Aug 2021 20:02:37 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b15sm10284602pgm.15.2021.08.01.20.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Aug 2021 20:02:37 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next] ip/bond: add lacp active support
Date:   Mon,  2 Aug 2021 11:02:20 +0800
Message-Id: <20210802030220.841726-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802030220.841726-1-liuhangbin@gmail.com>
References: <20210802030220.841726-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lacp_active specifies whether to send LACPDU frames periodically.
If set on, the LACPDU frames are sent along with the configured lacp_rate
setting. If set off, the LACPDU frames acts as "speak when spoken to".

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/if_link.h |  1 +
 ip/iplink_bond.c             | 26 +++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5195ed93..a60dbb96 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -853,6 +853,7 @@ enum {
 	IFLA_BOND_AD_ACTOR_SYSTEM,
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
+	IFLA_BOND_AD_LACP_ACTIVE,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index d45845bd..a3ca7ec9 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -74,6 +74,12 @@ static const char *xmit_hash_policy_tbl[] = {
 	NULL,
 };
 
+static const char *lacp_active_tbl[] = {
+	"off",
+	"on",
+	NULL,
+};
+
 static const char *lacp_rate_tbl[] = {
 	"slow",
 	"fast",
@@ -138,6 +144,7 @@ static void print_explain(FILE *f)
 		"                [ lp_interval LP_INTERVAL ]\n"
 		"                [ packets_per_slave PACKETS_PER_SLAVE ]\n"
 		"                [ tlb_dynamic_lb TLB_DYNAMIC_LB ]\n"
+		"                [ lacp_active LACP_ACTIVE]\n"
 		"                [ lacp_rate LACP_RATE ]\n"
 		"                [ ad_select AD_SELECT ]\n"
 		"                [ ad_user_port_key PORTKEY ]\n"
@@ -150,6 +157,7 @@ static void print_explain(FILE *f)
 		"PRIMARY_RESELECT := always|better|failure\n"
 		"FAIL_OVER_MAC := none|active|follow\n"
 		"XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlan+srcmac\n"
+		"LACP_ACTIVE := off|on\n"
 		"LACP_RATE := slow|fast\n"
 		"AD_SELECT := stable|bandwidth|count\n"
 	);
@@ -165,7 +173,7 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 {
 	__u8 mode, use_carrier, primary_reselect, fail_over_mac;
 	__u8 xmit_hash_policy, num_peer_notif, all_slaves_active;
-	__u8 lacp_rate, ad_select, tlb_dynamic_lb;
+	__u8 lacp_active, lacp_rate, ad_select, tlb_dynamic_lb;
 	__u16 ad_user_port_key, ad_actor_sys_prio;
 	__u32 miimon, updelay, downdelay, peer_notify_delay, arp_interval, arp_validate;
 	__u32 arp_all_targets, resend_igmp, min_links, lp_interval;
@@ -316,6 +324,13 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 
 			addattr32(n, 1024, IFLA_BOND_PACKETS_PER_SLAVE,
 				  packets_per_slave);
+		} else if (matches(*argv, "lacp_active") == 0) {
+			NEXT_ARG();
+			if (get_index(lacp_active_tbl, *argv) < 0)
+				invarg("invalid lacp_active", *argv);
+
+			lacp_active = get_index(lacp_active_tbl, *argv);
+			addattr8(n, 1024, IFLA_BOND_AD_LACP_ACTIVE, lacp_active);
 		} else if (matches(*argv, "lacp_rate") == 0) {
 			NEXT_ARG();
 			if (get_index(lacp_rate_tbl, *argv) < 0)
@@ -561,6 +576,15 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "packets_per_slave %u ",
 			   rta_getattr_u32(tb[IFLA_BOND_PACKETS_PER_SLAVE]));
 
+	if (tb[IFLA_BOND_AD_LACP_ACTIVE]) {
+		const char *lacp_active = get_name(lacp_active_tbl,
+						   rta_getattr_u8(tb[IFLA_BOND_AD_LACP_ACTIVE]));
+		print_string(PRINT_ANY,
+			     "ad_lacp_active",
+			     "lacp_active %s ",
+			     lacp_active);
+	}
+
 	if (tb[IFLA_BOND_AD_LACP_RATE]) {
 		const char *lacp_rate = get_name(lacp_rate_tbl,
 						 rta_getattr_u8(tb[IFLA_BOND_AD_LACP_RATE]));
-- 
2.31.1

