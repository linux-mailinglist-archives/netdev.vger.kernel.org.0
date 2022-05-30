Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0723537538
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiE3HVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 03:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiE3HVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 03:21:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B61559F
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:21:51 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n18so9572520plg.5
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j8P0iEB00asY/ksDW28rSeKUmzlLil8aNaDaxvgQHos=;
        b=XHzMBL+nd6oGRW7Vh1SDBWQJUSFrMFGlXU/ZGMgBETHs+03Q1S2sARlDvlPZfdALtm
         tVRcOBMkmgWatlP5+2ZlaDkE8nkAv0q0tv1uU6D/4s+2AhS5Nx7HToGSYG96cgCwL01W
         u3u0jmxphUcKFmd/t2Ez7JNLeKHHiIGauGM625SxGMBTP3h2PssyUQWa9XpDhPO8/GyX
         lc+un9KqJYspIY054PzbXbNElu5ffEQ3T4hy85+D265pPxQCXr7kHB+FSqre6iMiSnrk
         PEI2K7EYlwL8L5fBUKtya4CDOd4rm/+uMe4ujWcq1SQ44hTmoxczD+kGKl23xCsAXKed
         JyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j8P0iEB00asY/ksDW28rSeKUmzlLil8aNaDaxvgQHos=;
        b=OhAFbHG6NOzfmYYyetv+zDqNLamtBogOX8xUQezRxI39YlVHvj28BepfqEZhtbKq1Y
         aaUcpfA8t7zwJuBRFKG9pm9SgvL+r3FfMYotmmxIjpS9SmsFvAiVEWMFDNYunYQ+BMi5
         UoI9Ri3nAuXnJ1i+i1FtXXkQKiCgKKfdq9FDXYBr1Uo33GX/YvCfCmmcCbPMKjj2p5Mf
         tGalpiNy/Xq9T+8s5j71llnEPqnlhJ49IwJy/AfKU8iyvs9QuRynZ5dSPNXJoSNCxpCA
         eqRkwAy5TfyIMAI0KKcgydDYrhXy9ENOPsjFkrSKcffBckbxMw/lmPh/xalzAH93Pzwq
         StpQ==
X-Gm-Message-State: AOAM530KGwUuThzCJu0ZegNKShWxu5l/mOkd48P1V5tkeKg5aB3V1yoW
        5Vcdqb4gig7IIoYLEano20rNa2bQ53BaJUD0
X-Google-Smtp-Source: ABdhPJyzJNe/x/uSBRM7HZWYvJqV+WwKoWp/D4nb6ga3IStVSwvypcPjvCeKdJmH8hICxxz3mXBQiQ==
X-Received: by 2002:a17:902:bb89:b0:161:ffec:a1b3 with SMTP id m9-20020a170902bb8900b00161ffeca1b3mr45241549pls.141.1653895310802;
        Mon, 30 May 2022 00:21:50 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3-20020a056a00150300b00518e1251197sm8397095pfu.148.2022.05.30.00.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 00:21:50 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] bonding: guard ns_targets by CONFIG_IPV6
Date:   Mon, 30 May 2022 15:21:42 +0800
Message-Id: <20220530072142.44809-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guard ns_targets in struct bond_params by CONFIG_IPV6, which could save
256 bytes if IPv6 not configed. Also add this protection for function
bond_is_ip6_target_ok() and bond_get_targets_ip6().

Remove the IS_ENABLED() check for bond_opts[] as this will make
BOND_OPT_NS_TARGETS uninitialized if CONFIG_IPV6 not enabled. Add
a dummy bond_option_ns_ip6_targets_set() for this situation.

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c    |  2 ++
 drivers/net/bonding/bond_options.c | 10 ++++++----
 include/net/bonding.h              |  6 ++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3b7baaeae82c..f85372adf042 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6159,7 +6159,9 @@ static int bond_check_params(struct bond_params *params)
 		strscpy_pad(params->primary, primary, sizeof(params->primary));
 
 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
+#if IS_ENABLED(CONFIG_IPV6)
 	memset(params->ns_targets, 0, sizeof(struct in6_addr) * BOND_MAX_NS_TARGETS);
+#endif
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 64f7db2627ce..a8a0c5a22517 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -34,10 +34,8 @@ static int bond_option_arp_ip_target_add(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
-#if IS_ENABLED(CONFIG_IPV6)
 static int bond_option_ns_ip6_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
-#endif
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
 static int bond_option_arp_all_targets_set(struct bonding *bond,
@@ -299,7 +297,6 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_arp_ip_targets_set
 	},
-#if IS_ENABLED(CONFIG_IPV6)
 	[BOND_OPT_NS_TARGETS] = {
 		.id = BOND_OPT_NS_TARGETS,
 		.name = "ns_ip6_target",
@@ -307,7 +304,6 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_ns_ip6_targets_set
 	},
-#endif
 	[BOND_OPT_DOWNDELAY] = {
 		.id = BOND_OPT_DOWNDELAY,
 		.name = "downdelay",
@@ -1254,6 +1250,12 @@ static int bond_option_ns_ip6_targets_set(struct bonding *bond,
 
 	return 0;
 }
+#else
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval)
+{
+	return 0;
+}
 #endif
 
 static int bond_option_arp_validate_set(struct bonding *bond,
diff --git a/include/net/bonding.h b/include/net/bonding.h
index b14f4c0b4e9e..cb904d356e31 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -149,7 +149,9 @@ struct bond_params {
 	struct reciprocal_value reciprocal_packets_per_slave;
 	u16 ad_actor_sys_prio;
 	u16 ad_user_port_key;
+#if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr ns_targets[BOND_MAX_NS_TARGETS];
+#endif
 
 	/* 2 bytes of padding : see ether_addr_equal_64bits() */
 	u8 ad_actor_system[ETH_ALEN + 2];
@@ -503,12 +505,14 @@ static inline int bond_is_ip_target_ok(__be32 addr)
 	return !ipv4_is_lbcast(addr) && !ipv4_is_zeronet(addr);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static inline int bond_is_ip6_target_ok(struct in6_addr *addr)
 {
 	return !ipv6_addr_any(addr) &&
 	       !ipv6_addr_loopback(addr) &&
 	       !ipv6_addr_is_multicast(addr);
 }
+#endif
 
 /* Get the oldest arp which we've received on this slave for bond's
  * arp_targets.
@@ -746,6 +750,7 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 	return -1;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
 {
 	int i;
@@ -758,6 +763,7 @@ static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr
 
 	return -1;
 }
+#endif
 
 /* exported from bond_main.c */
 extern unsigned int bond_net_id;
-- 
2.35.1

