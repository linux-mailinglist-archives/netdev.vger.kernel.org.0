Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C43636380
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbiKWP1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbiKWP0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:26:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9699CF6A;
        Wed, 23 Nov 2022 07:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669217173; x=1700753173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TKg6z9yXyQb61xdfgwCuiBPWIQ4ZM4P9nYWrl7wtjag=;
  b=UkiNFf7vjhhQTmCuJb6H51yWY35/W5842L5+8JvHE1ND3CSvhHBtDNjd
   C76VOtgU3sWDxRu3Nc/UbavNzcHTNedT72L7h/HHVJ4rLVg7YCs0vU84r
   LRUF4iFMaarV9a9qpd9GaxDkeafOO6KJwh1TsUcP6d0oUFA5oK77zyv0H
   hCwVq+RlH89bDRMhLUOz3dV8Y8uFznulQUBgMWZv9H9f/p6Mlm/27Tpz9
   +XA+uCD3zPuKejU0vzGSo7SZvPLhj4gEBLbfJaDtSNYB4aB/k+xe2G12C
   58Vc0xhzcaBxwKM2hTTwFHug+oltomStmBNA2nd9bvH5E5r1b1IwVyO0a
   A==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="184877216"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 08:26:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 08:26:01 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 08:25:58 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 3/4] net: microchip: sparx5: Support for displaying a list of keysets
Date:   Wed, 23 Nov 2022 16:25:44 +0100
Message-ID: <20221123152545.1997266-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123152545.1997266-1-steen.hegelund@microchip.com>
References: <20221123152545.1997266-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will display a list of keyset in case the type_id field in the VCAP
rule has been wildcarded.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/vcap/vcap_api_debugfs.c         | 98 +++++++++++--------
 .../microchip/vcap/vcap_api_debugfs_kunit.c   | 20 +++-
 2 files changed, 74 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index d9c7ca988b76..5df00e940333 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -192,22 +192,22 @@ static bool vcap_verify_keystream_keyset(struct vcap_control *vctrl,
 	vcap_iter_init(&iter, vcap->sw_width, tgt, typefld->offset);
 	vcap_decode_field(keystream, &iter, typefld->width, (u8 *)&value);
 
-	return (value == info->type_id);
+	return (value & mask) == (info->type_id & mask);
 }
 
 /* Verify that the typegroup information, subword count, keyset and type id
- * are in sync and correct, return the keyset
+ * are in sync and correct, return the list of matching keysets
  */
-static enum
-vcap_keyfield_set vcap_find_keystream_keyset(struct vcap_control *vctrl,
-					     enum vcap_type vt,
-					     u32 *keystream,
-					     u32 *mskstream,
-					     bool mask, int sw_max)
+static int
+vcap_find_keystream_keysets(struct vcap_control *vctrl,
+			    enum vcap_type vt,
+			    u32 *keystream,
+			    u32 *mskstream,
+			    bool mask, int sw_max,
+			    struct vcap_keyset_list *kslist)
 {
 	const struct vcap_set *keyfield_set;
 	int sw_count, idx;
-	bool res;
 
 	sw_count = vcap_find_keystream_typegroup_sw(vctrl, vt, keystream, mask,
 						    sw_max);
@@ -219,11 +219,12 @@ vcap_keyfield_set vcap_find_keystream_keyset(struct vcap_control *vctrl,
 		if (keyfield_set[idx].sw_per_item != sw_count)
 			continue;
 
-		res = vcap_verify_keystream_keyset(vctrl, vt, keystream,
-						   mskstream, idx);
-		if (res)
-			return idx;
+		if (vcap_verify_keystream_keyset(vctrl, vt, keystream,
+						 mskstream, idx))
+			vcap_keyset_list_add(kslist, idx);
 	}
+	if (kslist->cnt > 0)
+		return 0;
 	return -EINVAL;
 }
 
@@ -296,13 +297,14 @@ vcap_find_actionstream_actionset(struct vcap_control *vctrl,
 	return -EINVAL;
 }
 
-/* Read key data from a VCAP address and discover if there is a rule keyset
+/* Read key data from a VCAP address and discover if there are any rule keysets
  * here
  */
-static int vcap_addr_keyset(struct vcap_control *vctrl,
-			    struct net_device *ndev,
-			    struct vcap_admin *admin,
-			    int addr)
+static int vcap_addr_keysets(struct vcap_control *vctrl,
+			     struct net_device *ndev,
+			     struct vcap_admin *admin,
+			     int addr,
+			     struct vcap_keyset_list *kslist)
 {
 	enum vcap_type vt = admin->vtype;
 	int keyset_sw_regs, idx;
@@ -320,9 +322,10 @@ static int vcap_addr_keyset(struct vcap_control *vctrl,
 	}
 	if (key == 0 && mask == 0)
 		return -EINVAL;
-	/* Decode and locate the keyset */
-	return vcap_find_keystream_keyset(vctrl, vt, admin->cache.keystream,
-					  admin->cache.maskstream, false, 0);
+	/* Decode and locate the keysets */
+	return vcap_find_keystream_keysets(vctrl, vt, admin->cache.keystream,
+					   admin->cache.maskstream, false, 0,
+					   kslist);
 }
 
 static int vcap_read_rule(struct vcap_rule_internal *ri)
@@ -471,9 +474,11 @@ static int vcap_debugfs_show_rule_keyset(struct vcap_rule_internal *ri,
 	struct vcap_control *vctrl = ri->vctrl;
 	struct vcap_stream_iter kiter, miter;
 	struct vcap_admin *admin = ri->admin;
+	enum vcap_keyfield_set keysets[10];
 	const struct vcap_field *keyfield;
 	enum vcap_type vt = admin->vtype;
 	const struct vcap_typegroup *tgt;
+	struct vcap_keyset_list matches;
 	enum vcap_keyfield_set keyset;
 	int idx, res, keyfield_count;
 	u32 *maskstream;
@@ -483,16 +488,22 @@ static int vcap_debugfs_show_rule_keyset(struct vcap_rule_internal *ri,
 
 	keystream = admin->cache.keystream;
 	maskstream = admin->cache.maskstream;
-	res = vcap_find_keystream_keyset(vctrl, vt, keystream, maskstream,
-					 false, 0);
+	matches.keysets = keysets;
+	matches.cnt = 0;
+	matches.max = ARRAY_SIZE(keysets);
+	res = vcap_find_keystream_keysets(vctrl, vt, keystream, maskstream,
+					  false, 0, &matches);
 	if (res < 0) {
-		pr_err("%s:%d: could not find valid keyset: %d\n",
+		pr_err("%s:%d: could not find valid keysets: %d\n",
 		       __func__, __LINE__, res);
 		return -EINVAL;
 	}
-	keyset = res;
-	out->prf(out->dst, "  keyset: %s\n",
-		 vcap_keyset_name(vctrl, ri->data.keyset));
+	keyset = matches.keysets[0];
+	out->prf(out->dst, "  keysets:");
+	for (idx = 0; idx < matches.cnt; ++idx)
+		out->prf(out->dst, " %s",
+			 vcap_keyset_name(vctrl, matches.keysets[idx]));
+	out->prf(out->dst, "\n");
 	out->prf(out->dst, "  keyset_sw: %d\n", ri->keyset_sw);
 	out->prf(out->dst, "  keyset_sw_regs: %d\n", ri->keyset_sw_regs);
 	keyfield_count = vcap_keyfield_count(vctrl, vt, keyset);
@@ -647,11 +658,12 @@ static int vcap_show_admin_raw(struct vcap_control *vctrl,
 			       struct vcap_admin *admin,
 			       struct vcap_output_print *out)
 {
+	enum vcap_keyfield_set keysets[10];
 	enum vcap_type vt = admin->vtype;
+	struct vcap_keyset_list kslist;
 	struct vcap_rule_internal *ri;
 	const struct vcap_set *info;
-	int keyset;
-	int addr;
+	int addr, idx;
 	int ret;
 
 	if (list_empty(&admin->rules))
@@ -664,24 +676,32 @@ static int vcap_show_admin_raw(struct vcap_control *vctrl,
 	ri = list_first_entry(&admin->rules, struct vcap_rule_internal, list);
 
 	/* Go from higher to lower addresses searching for a keyset */
+	kslist.keysets = keysets;
+	kslist.max = ARRAY_SIZE(keysets);
 	for (addr = admin->last_valid_addr; addr >= admin->first_valid_addr;
 	     --addr) {
-		keyset = vcap_addr_keyset(vctrl, ri->ndev, admin,  addr);
-		if (keyset < 0)
+		kslist.cnt = 0;
+		ret = vcap_addr_keysets(vctrl, ri->ndev, admin, addr, &kslist);
+		if (ret < 0)
 			continue;
-		info = vcap_keyfieldset(vctrl, vt, keyset);
+		info = vcap_keyfieldset(vctrl, vt, kslist.keysets[0]);
 		if (!info)
 			continue;
-		if (addr % info->sw_per_item)
+		if (addr % info->sw_per_item) {
 			pr_info("addr: %d X%d error rule, keyset: %s\n",
 				addr,
 				info->sw_per_item,
-				vcap_keyset_name(vctrl, keyset));
-		else
-			out->prf(out->dst, "  addr: %d, X%d rule, keyset: %s\n",
-			   addr,
-			   info->sw_per_item,
-			   vcap_keyset_name(vctrl, keyset));
+				vcap_keyset_name(vctrl, kslist.keysets[0]));
+		} else {
+			out->prf(out->dst, "  addr: %d, X%d rule, keysets:",
+				 addr,
+				 info->sw_per_item);
+			for (idx = 0; idx < kslist.cnt; ++idx)
+				out->prf(out->dst, " %s",
+					 vcap_keyset_name(vctrl,
+							  kslist.keysets[idx]));
+			out->prf(out->dst, "\n");
+		}
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
index ed455dad3a14..cf594668d5d9 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
@@ -316,24 +316,34 @@ static void vcap_api_addr_keyset_test(struct kunit *test)
 			.actionstream = actdata,
 		},
 	};
+	enum vcap_keyfield_set keysets[10];
+	struct vcap_keyset_list matches;
 	int ret, idx, addr;
 
 	vcap_test_api_init(&admin);
 
 	/* Go from higher to lower addresses searching for a keyset */
+	matches.keysets = keysets;
+	matches.cnt = 0;
+	matches.max = ARRAY_SIZE(keysets);
 	for (idx = ARRAY_SIZE(keydata) - 1, addr = 799; idx > 0;
 	     --idx, --addr) {
 		admin.cache.keystream = &keydata[idx];
 		admin.cache.maskstream = &mskdata[idx];
-		ret = vcap_addr_keyset(&test_vctrl, &test_netdev, &admin, addr);
+		ret = vcap_addr_keysets(&test_vctrl, &test_netdev, &admin,
+					addr, &matches);
 		KUNIT_EXPECT_EQ(test, -EINVAL, ret);
 	}
 
 	/* Finally we hit the start of the rule */
 	admin.cache.keystream = &keydata[idx];
 	admin.cache.maskstream = &mskdata[idx];
-	ret = vcap_addr_keyset(&test_vctrl, &test_netdev, &admin,  addr);
-	KUNIT_EXPECT_EQ(test, VCAP_KFS_MAC_ETYPE, ret);
+	matches.cnt = 0;
+	ret = vcap_addr_keysets(&test_vctrl, &test_netdev, &admin,
+				addr, &matches);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, matches.cnt, 1);
+	KUNIT_EXPECT_EQ(test, matches.keysets[0], VCAP_KFS_MAC_ETYPE);
 }
 
 static void vcap_api_show_admin_raw_test(struct kunit *test)
@@ -362,7 +372,7 @@ static void vcap_api_show_admin_raw_test(struct kunit *test)
 		.prf = (void *)test_prf,
 	};
 	const char *test_expected =
-		"  addr: 786, X6 rule, keyset: VCAP_KFS_MAC_ETYPE\n";
+		"  addr: 786, X6 rule, keysets: VCAP_KFS_MAC_ETYPE\n";
 	int ret;
 
 	vcap_test_api_init(&admin);
@@ -442,7 +452,7 @@ static const char * const test_admin_expect[] = {
 	"  chain_id: 0\n",
 	"  user: 0\n",
 	"  priority: 0\n",
-	"  keyset: VCAP_KFS_MAC_ETYPE\n",
+	"  keysets: VCAP_KFS_MAC_ETYPE\n",
 	"  keyset_sw: 6\n",
 	"  keyset_sw_regs: 2\n",
 	"    ETYPE_LEN_IS: W1: 1/1\n",
-- 
2.38.1

