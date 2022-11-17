Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E30962E700
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240991AbiKQVc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240988AbiKQVcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:32:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44ADD62044;
        Thu, 17 Nov 2022 13:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668720710; x=1700256710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=STxNqM+4qrqYNu3huHW3xV0bO3ESmYNB4UHcoEa4SUY=;
  b=BSEnvUS1M4YnpCYMcubPc7V2Fd7GtqSZCyiwlVaUXNuJnPwubSsBqIIm
   ZO5pyG8HI4ZWsFRxiVKAFqxhWQbZixIn1/77VD1Xf2etlZCuRxAO8Bcfp
   39XukEwpIcymFMDQrf9EmVegVRS433CvXh7EKEMj7C0IVo31P0Jui1JiO
   fdKVREKuJT6ge8O38m190QlN2et8QGAeDeJxG4vnceDUbch0STDNwb9NP
   TqgvwD6CKIFQIYAnvvFQfWYtAT0rP8M2MoAXaHSblxO5DbZaiyUIKHVJq
   x4JVj3+3pWekpoR/tkiNsZElKtALx43UMYgAfI+YdMGDac31pvwOFuJwl
   w==;
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="123980076"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 14:31:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 14:31:44 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 17 Nov 2022 14:31:40 -0700
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
Subject: [PATCH net-next v2 6/8] net: microchip: sparx5: Add VCAP debugFS key/action support for the VCAP API
Date:   Thu, 17 Nov 2022 22:31:12 +0100
Message-ID: <20221117213114.699375-7-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221117213114.699375-1-steen.hegelund@microchip.com>
References: <20221117213114.699375-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This add support for displaying the keys and actions in a rule.
The keys and action display format will be determined by the size and the
type of the key or action. The longer keys will typically be displayed as a
hexadecimal byte array.

The actionset is not decoded in full as the Sparx5 IS2 only has one
supported action, so this will be added later with other VCAP types.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    |  12 +-
 .../microchip/vcap/vcap_api_debugfs.c         | 315 +++++++++++++++++-
 .../microchip/vcap/vcap_api_private.h         |  16 +
 3 files changed, 333 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 3da714e9639c..3415605350c9 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -316,7 +316,7 @@ static int vcap_encode_rule_keyset(struct vcap_rule_internal *ri)
 }
 
 /* Return the list of actionfields for the actionset */
-static const struct vcap_field *
+const struct vcap_field *
 vcap_actionfields(struct vcap_control *vctrl,
 		  enum vcap_type vt, enum vcap_actionfield_set actionset)
 {
@@ -326,7 +326,7 @@ vcap_actionfields(struct vcap_control *vctrl,
 	return vctrl->vcaps[vt].actionfield_set_map[actionset];
 }
 
-static const struct vcap_set *
+const struct vcap_set *
 vcap_actionfieldset(struct vcap_control *vctrl,
 		    enum vcap_type vt, enum vcap_actionfield_set actionset)
 {
@@ -342,7 +342,7 @@ vcap_actionfieldset(struct vcap_control *vctrl,
 }
 
 /* Return the typegroup table for the matching actionset (using subword size) */
-static const struct vcap_typegroup *
+const struct vcap_typegroup *
 vcap_actionfield_typegroup(struct vcap_control *vctrl,
 			   enum vcap_type vt, enum vcap_actionfield_set actionset)
 {
@@ -355,9 +355,9 @@ vcap_actionfield_typegroup(struct vcap_control *vctrl,
 }
 
 /* Return the number of actionfields in the actionset */
-static int vcap_actionfield_count(struct vcap_control *vctrl,
-				  enum vcap_type vt,
-				  enum vcap_actionfield_set actionset)
+int vcap_actionfield_count(struct vcap_control *vctrl,
+			   enum vcap_type vt,
+			   enum vcap_actionfield_set actionset)
 {
 	/* Check that the actionset exists in the vcap actionset list */
 	if (actionset >= vctrl->vcaps[vt].actionfield_set_size)
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index b4bc32a08f2c..981c4ed6ad7d 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -120,6 +120,28 @@ static int vcap_find_keystream_typegroup_sw(struct vcap_control *vctrl,
 	return -EINVAL;
 }
 
+/* Find the subword width of the action typegroup that matches the stream data
+ */
+static int vcap_find_actionstream_typegroup_sw(struct vcap_control *vctrl,
+					       enum vcap_type vt, u32 *stream,
+					       int sw_max)
+{
+	const struct vcap_typegroup **tgt;
+	int sw_idx, res;
+
+	tgt = vctrl->vcaps[vt].actionfield_set_typegroups;
+	/* Try the longest subword match first */
+	for (sw_idx = vctrl->vcaps[vt].sw_count; sw_idx >= 0; sw_idx--) {
+		if (!tgt[sw_idx])
+			continue;
+		res = vcap_verify_typegroups(stream, vctrl->vcaps[vt].act_width,
+					     tgt[sw_idx], false, sw_max);
+		if (res == 0)
+			return sw_idx;
+	}
+	return -EINVAL;
+}
+
 /* Verify that the type id in the stream matches the type id of the keyset */
 static bool vcap_verify_keystream_keyset(struct vcap_control *vctrl,
 					 enum vcap_type vt,
@@ -205,6 +227,75 @@ vcap_keyfield_set vcap_find_keystream_keyset(struct vcap_control *vctrl,
 	return -EINVAL;
 }
 
+/* Read key data from a VCAP address and discover if there is a rule keyset
+ * here
+ */
+static bool
+vcap_verify_actionstream_actionset(struct vcap_control *vctrl,
+				   enum vcap_type vt,
+				   u32 *actionstream,
+				   enum vcap_actionfield_set actionset)
+{
+	const struct vcap_typegroup *tgt;
+	const struct vcap_field *fields;
+	const struct vcap_set *info;
+
+	if (vcap_actionfield_count(vctrl, vt, actionset) == 0)
+		return false;
+
+	info = vcap_actionfieldset(vctrl, vt, actionset);
+	/* Check that the actionset is valid */
+	if (!info)
+		return false;
+
+	/* a type_id of value -1 means that there is no type field */
+	if (info->type_id == (u8)-1)
+		return true;
+
+	/* Get a valid typegroup for the specific actionset */
+	tgt = vcap_actionfield_typegroup(vctrl, vt, actionset);
+	if (!tgt)
+		return false;
+
+	fields = vcap_actionfields(vctrl, vt, actionset);
+	if (!fields)
+		return false;
+
+	/* Later this will be expanded with a check of the type id */
+	return true;
+}
+
+/* Verify that the typegroup information, subword count, actionset and type id
+ * are in sync and correct, return the actionset
+ */
+static enum vcap_actionfield_set
+vcap_find_actionstream_actionset(struct vcap_control *vctrl,
+				 enum vcap_type vt,
+				 u32 *stream,
+				 int sw_max)
+{
+	const struct vcap_set *actionfield_set;
+	int sw_count, idx;
+	bool res;
+
+	sw_count = vcap_find_actionstream_typegroup_sw(vctrl, vt, stream,
+						       sw_max);
+	if (sw_count < 0)
+		return sw_count;
+
+	actionfield_set = vctrl->vcaps[vt].actionfield_set;
+	for (idx = 0; idx < vctrl->vcaps[vt].actionfield_set_size; ++idx) {
+		if (actionfield_set[idx].sw_per_item != sw_count)
+			continue;
+
+		res = vcap_verify_actionstream_actionset(vctrl, vt,
+							 stream, idx);
+		if (res)
+			return idx;
+	}
+	return -EINVAL;
+}
+
 /* Read key data from a VCAP address and discover if there is a rule keyset
  * here
  */
@@ -265,6 +356,224 @@ static int vcap_read_rule(struct vcap_rule_internal *ri)
 	return 0;
 }
 
+/* Dump the keyfields value and mask values */
+static void vcap_debugfs_show_rule_keyfield(struct vcap_control *vctrl,
+					    struct vcap_output_print *out,
+					    enum vcap_key_field key,
+					    const struct vcap_field *keyfield,
+					    u8 *value, u8 *mask)
+{
+	bool hex = false;
+	int idx, bytes;
+
+	out->prf(out->dst, "    %s: W%d: ", vcap_keyfield_name(vctrl, key),
+		 keyfield[key].width);
+
+	switch (keyfield[key].type) {
+	case VCAP_FIELD_BIT:
+		out->prf(out->dst, "%d/%d", value[0], mask[0]);
+		break;
+	case VCAP_FIELD_U32:
+		if (key == VCAP_KF_L3_IP4_SIP || key == VCAP_KF_L3_IP4_DIP) {
+			out->prf(out->dst, "%pI4h/%pI4h", value, mask);
+		} else if (key == VCAP_KF_ETYPE ||
+			   key == VCAP_KF_IF_IGR_PORT_MASK) {
+			hex = true;
+		} else {
+			u32 fmsk = (1 << keyfield[key].width) - 1;
+			u32 val = *(u32 *)value;
+			u32 msk = *(u32 *)mask;
+
+			out->prf(out->dst, "%u/%u", val & fmsk, msk & fmsk);
+		}
+		break;
+	case VCAP_FIELD_U48:
+		if (key == VCAP_KF_L2_SMAC || key == VCAP_KF_L2_DMAC)
+			out->prf(out->dst, "%pMR/%pMR", value, mask);
+		else
+			hex = true;
+		break;
+	case VCAP_FIELD_U56:
+	case VCAP_FIELD_U64:
+	case VCAP_FIELD_U72:
+	case VCAP_FIELD_U112:
+		hex = true;
+		break;
+	case VCAP_FIELD_U128:
+		if (key == VCAP_KF_L3_IP6_SIP || key == VCAP_KF_L3_IP6_DIP) {
+			u8 nvalue[16], nmask[16];
+
+			vcap_netbytes_copy(nvalue, value, sizeof(nvalue));
+			vcap_netbytes_copy(nmask, mask, sizeof(nmask));
+			out->prf(out->dst, "%pI6/%pI6", nvalue, nmask);
+		} else {
+			hex = true;
+		}
+		break;
+	}
+	if (hex) {
+		bytes = DIV_ROUND_UP(keyfield[key].width, BITS_PER_BYTE);
+		out->prf(out->dst, "0x");
+		for (idx = 0; idx < bytes; ++idx)
+			out->prf(out->dst, "%02x", value[bytes - idx - 1]);
+		out->prf(out->dst, "/0x");
+		for (idx = 0; idx < bytes; ++idx)
+			out->prf(out->dst, "%02x", mask[bytes - idx - 1]);
+	}
+	out->prf(out->dst, "\n");
+}
+
+static void
+vcap_debugfs_show_rule_actionfield(struct vcap_control *vctrl,
+				   struct vcap_output_print *out,
+				   enum vcap_action_field action,
+				   const struct vcap_field *actionfield,
+				   u8 *value)
+{
+	bool hex = false;
+	int idx, bytes;
+	u32 fmsk, val;
+
+	out->prf(out->dst, "    %s: W%d: ",
+		 vcap_actionfield_name(vctrl, action),
+		 actionfield[action].width);
+
+	switch (actionfield[action].type) {
+	case VCAP_FIELD_BIT:
+		out->prf(out->dst, "%d", value[0]);
+		break;
+	case VCAP_FIELD_U32:
+		fmsk = (1 << actionfield[action].width) - 1;
+		val = *(u32 *)value;
+		out->prf(out->dst, "%u", val & fmsk);
+		break;
+	case VCAP_FIELD_U48:
+	case VCAP_FIELD_U56:
+	case VCAP_FIELD_U64:
+	case VCAP_FIELD_U72:
+	case VCAP_FIELD_U112:
+	case VCAP_FIELD_U128:
+		hex = true;
+		break;
+	}
+	if (hex) {
+		bytes = DIV_ROUND_UP(actionfield[action].width, BITS_PER_BYTE);
+		out->prf(out->dst, "0x");
+		for (idx = 0; idx < bytes; ++idx)
+			out->prf(out->dst, "%02x", value[bytes - idx - 1]);
+	}
+	out->prf(out->dst, "\n");
+}
+
+static int vcap_debugfs_show_rule_keyset(struct vcap_rule_internal *ri,
+					 struct vcap_output_print *out)
+{
+	struct vcap_control *vctrl = ri->vctrl;
+	struct vcap_stream_iter kiter, miter;
+	struct vcap_admin *admin = ri->admin;
+	const struct vcap_field *keyfield;
+	enum vcap_type vt = admin->vtype;
+	const struct vcap_typegroup *tgt;
+	enum vcap_keyfield_set keyset;
+	int idx, res, keyfield_count;
+	u32 *maskstream;
+	u32 *keystream;
+	u8 value[16];
+	u8 mask[16];
+
+	keystream = admin->cache.keystream;
+	maskstream = admin->cache.maskstream;
+	res = vcap_find_keystream_keyset(vctrl, vt, keystream, maskstream,
+					 false, 0);
+	if (res < 0) {
+		pr_err("%s:%d: could not find valid keyset: %d\n",
+		       __func__, __LINE__, res);
+		return -EINVAL;
+	}
+	keyset = res;
+	out->prf(out->dst, "  keyset: %s\n",
+		 vcap_keyset_name(vctrl, ri->data.keyset));
+	out->prf(out->dst, "  keyset_sw: %d\n", ri->keyset_sw);
+	out->prf(out->dst, "  keyset_sw_regs: %d\n", ri->keyset_sw_regs);
+	keyfield_count = vcap_keyfield_count(vctrl, vt, keyset);
+	keyfield = vcap_keyfields(vctrl, vt, keyset);
+	tgt = vcap_keyfield_typegroup(vctrl, vt, keyset);
+	/* Start decoding the streams */
+	for (idx = 0; idx < keyfield_count; ++idx) {
+		if (keyfield[idx].width <= 0)
+			continue;
+		/* First get the mask */
+		memset(mask, 0, DIV_ROUND_UP(keyfield[idx].width, 8));
+		vcap_iter_init(&miter, vctrl->vcaps[vt].sw_width, tgt,
+			       keyfield[idx].offset);
+		vcap_decode_field(maskstream, &miter, keyfield[idx].width,
+				  mask);
+		/* Skip if no mask bits are set */
+		if (vcap_bitarray_zero(keyfield[idx].width, mask))
+			continue;
+		/* Get the key */
+		memset(value, 0, DIV_ROUND_UP(keyfield[idx].width, 8));
+		vcap_iter_init(&kiter, vctrl->vcaps[vt].sw_width, tgt,
+			       keyfield[idx].offset);
+		vcap_decode_field(keystream, &kiter, keyfield[idx].width,
+				  value);
+		vcap_debugfs_show_rule_keyfield(vctrl, out, idx, keyfield,
+						value, mask);
+	}
+	return 0;
+}
+
+static int vcap_debugfs_show_rule_actionset(struct vcap_rule_internal *ri,
+					    struct vcap_output_print *out)
+{
+	struct vcap_control *vctrl = ri->vctrl;
+	struct vcap_admin *admin = ri->admin;
+	const struct vcap_field *actionfield;
+	enum vcap_actionfield_set actionset;
+	enum vcap_type vt = admin->vtype;
+	const struct vcap_typegroup *tgt;
+	struct vcap_stream_iter iter;
+	int idx, res, actfield_count;
+	u32 *actstream;
+	u8 value[16];
+	bool no_bits;
+
+	actstream = admin->cache.actionstream;
+	res = vcap_find_actionstream_actionset(vctrl, vt, actstream, 0);
+	if (res < 0) {
+		pr_err("%s:%d: could not find valid actionset: %d\n",
+		       __func__, __LINE__, res);
+		return -EINVAL;
+	}
+	actionset = res;
+	out->prf(out->dst, "  actionset: %s\n",
+		 vcap_actionset_name(vctrl, ri->data.actionset));
+	out->prf(out->dst, "  actionset_sw: %d\n", ri->actionset_sw);
+	out->prf(out->dst, "  actionset_sw_regs: %d\n", ri->actionset_sw_regs);
+	actfield_count = vcap_actionfield_count(vctrl, vt, actionset);
+	actionfield = vcap_actionfields(vctrl, vt, actionset);
+	tgt = vcap_actionfield_typegroup(vctrl, vt, actionset);
+	/* Start decoding the stream */
+	for (idx = 0; idx < actfield_count; ++idx) {
+		if (actionfield[idx].width <= 0)
+			continue;
+		/* Get the action */
+		memset(value, 0, DIV_ROUND_UP(actionfield[idx].width, 8));
+		vcap_iter_init(&iter, vctrl->vcaps[vt].act_width, tgt,
+			       actionfield[idx].offset);
+		vcap_decode_field(actstream, &iter, actionfield[idx].width,
+				  value);
+		/* Skip if no bits are set */
+		no_bits = vcap_bitarray_zero(actionfield[idx].width, value);
+		if (no_bits)
+			continue;
+		/* Later the action id will also be checked */
+		vcap_debugfs_show_rule_actionfield(vctrl, out, idx, actionfield,
+						   value);
+	}
+	return 0;
+}
+
 static void vcap_show_admin_rule(struct vcap_control *vctrl,
 				 struct vcap_admin *admin,
 				 struct vcap_output_print *out,
@@ -279,10 +588,8 @@ static void vcap_show_admin_rule(struct vcap_control *vctrl,
 	out->prf(out->dst, "  chain_id: %d\n", ri->data.vcap_chain_id);
 	out->prf(out->dst, "  user: %d\n", ri->data.user);
 	out->prf(out->dst, "  priority: %d\n", ri->data.priority);
-	out->prf(out->dst, "  keyset: %s\n",
-		 vcap_keyset_name(vctrl, ri->data.keyset));
-	out->prf(out->dst, "  actionset: %s\n",
-		 vcap_actionset_name(vctrl, ri->data.actionset));
+	vcap_debugfs_show_rule_keyset(ri, out);
+	vcap_debugfs_show_rule_actionset(ri, out);
 }
 
 static void vcap_show_admin_info(struct vcap_control *vctrl,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
index 57309de463d7..18a9a0cd9606 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
@@ -77,6 +77,22 @@ const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
 
 /* Actionset and actionfield functionality */
 
+/* Return the actionset information for the actionset */
+const struct vcap_set *
+vcap_actionfieldset(struct vcap_control *vctrl,
+		    enum vcap_type vt, enum vcap_actionfield_set actionset);
+/* Return the number of actionfields in the actionset */
+int vcap_actionfield_count(struct vcap_control *vctrl,
+			   enum vcap_type vt,
+			   enum vcap_actionfield_set actionset);
+/* Return the typegroup table for the matching actionset (using subword size) */
+const struct vcap_typegroup *
+vcap_actionfield_typegroup(struct vcap_control *vctrl, enum vcap_type vt,
+			   enum vcap_actionfield_set actionset);
+/* Return the list of actionfields for the actionset */
+const struct vcap_field *
+vcap_actionfields(struct vcap_control *vctrl,
+		  enum vcap_type vt, enum vcap_actionfield_set actionset);
 /* Map actionset id to a string with the actionset name */
 const char *vcap_actionset_name(struct vcap_control *vctrl,
 				enum vcap_actionfield_set actionset);
-- 
2.38.1

