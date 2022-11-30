Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9468C63D838
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiK3OcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiK3Obs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:31:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3425813B5;
        Wed, 30 Nov 2022 06:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669818701; x=1701354701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wfgkYC2+D96LLsyr5OYoqUz3rX0TKXFMd3DtRgI0ZRQ=;
  b=RltsXWhdv19ZxME3belk7WXgiiswOFsqbaF+AkYEZImtxGI3nq2lrNPb
   uP9WjOfzUO6RsgYrkzSUsF/2/0IMjA67rorKBZiRZdeDdvlhMEX/L2mA0
   EP5OP6kaT7vAJzc17rrLdI2e6DoY8gjNuEsvWG7fgj+U0Daw5/YK8gtCn
   sY7xNNUE+ZMWgQtmsLeQMW9yYWSVySDOFU1UHSGHLbP4a+iIMmzqYxgrd
   /ZYvju9lCw0gBQSIOg6zOd8zX4kZV5ZMt+n4r3HTwNggV9H4fg/Teqjsz
   HHx5QeBZEDEBdAeMLklC5mCqeDJtp5URBGYs+S2x5QqVSy71kfTfGTYmY
   w==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191153036"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 07:30:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 07:30:31 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 07:30:29 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/4] net: microchip: vcap: Add vcap_get_rule
Date:   Wed, 30 Nov 2022 15:35:22 +0100
Message-ID: <20221130143525.934906-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130143525.934906-1-horatiu.vultur@microchip.com>
References: <20221130143525.934906-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add function vcap_get_rule which returns a rule based on the internal
rule id.
The entire functionality of reading and decoding the rule from the VCAP
was inside vcap_api_debugfs file. So move the entire implementation in
vcap_api as this is used also by vcap_get_rule.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 772 ++++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h |   2 +
 .../microchip/vcap/vcap_api_debugfs.c         | 492 ++---------
 .../microchip/vcap/vcap_api_private.h         |  14 +
 4 files changed, 848 insertions(+), 432 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index f2435d7ab515f..27128313f15f1 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -169,6 +169,227 @@ static void vcap_encode_typegroups(u32 *stream, int sw_width,
 	}
 }
 
+static bool vcap_bitarray_zero(int width, u8 *value)
+{
+	int bytes = DIV_ROUND_UP(width, BITS_PER_BYTE);
+	u8 total = 0, bmask = 0xff;
+	int rwidth = width;
+	int idx;
+
+	for (idx = 0; idx < bytes; ++idx, rwidth -= BITS_PER_BYTE) {
+		if (rwidth && rwidth < BITS_PER_BYTE)
+			bmask = (1 << rwidth) - 1;
+		total += value[idx] & bmask;
+	}
+	return total == 0;
+}
+
+static bool vcap_get_bit(u32 *stream, struct vcap_stream_iter *itr)
+{
+	u32 mask = BIT(itr->reg_bitpos);
+	u32 *p = &stream[itr->reg_idx];
+
+	return !!(*p & mask);
+}
+
+static void vcap_decode_field(u32 *stream, struct vcap_stream_iter *itr,
+			      int width, u8 *value)
+{
+	int idx;
+
+	/* Loop over the field value bits and get the field bits and
+	 * set them in the output value byte array
+	 */
+	for (idx = 0; idx < width; idx++) {
+		u8 bidx = idx & 0x7;
+
+		/* Decode one field value bit */
+		if (vcap_get_bit(stream, itr))
+			*value |= 1 << bidx;
+		vcap_iter_next(itr);
+		if (bidx == 7)
+			value++;
+	}
+}
+
+/* Verify that the type id in the stream matches the type id of the keyset */
+static bool vcap_verify_keystream_keyset(struct vcap_control *vctrl,
+					 enum vcap_type vt,
+					 u32 *keystream,
+					 u32 *mskstream,
+					 enum vcap_keyfield_set keyset)
+{
+	const struct vcap_info *vcap = &vctrl->vcaps[vt];
+	const struct vcap_field *typefld;
+	const struct vcap_typegroup *tgt;
+	const struct vcap_field *fields;
+	struct vcap_stream_iter iter;
+	const struct vcap_set *info;
+	u32 value = 0;
+	u32 mask = 0;
+
+	if (vcap_keyfield_count(vctrl, vt, keyset) == 0)
+		return false;
+
+	info = vcap_keyfieldset(vctrl, vt, keyset);
+	/* Check that the keyset is valid */
+	if (!info)
+		return false;
+
+	/* a type_id of value -1 means that there is no type field */
+	if (info->type_id == (u8)-1)
+		return true;
+
+	/* Get a valid typegroup for the specific keyset */
+	tgt = vcap_keyfield_typegroup(vctrl, vt, keyset);
+	if (!tgt)
+		return false;
+
+	fields = vcap_keyfields(vctrl, vt, keyset);
+	if (!fields)
+		return false;
+
+	typefld = &fields[VCAP_KF_TYPE];
+	vcap_iter_init(&iter, vcap->sw_width, tgt, typefld->offset);
+	vcap_decode_field(mskstream, &iter, typefld->width, (u8 *)&mask);
+	/* no type info if there are no mask bits */
+	if (vcap_bitarray_zero(typefld->width, (u8 *)&mask))
+		return false;
+
+	/* Get the value of the type field in the stream and compare to the
+	 * one define in the vcap keyset
+	 */
+	vcap_iter_init(&iter, vcap->sw_width, tgt, typefld->offset);
+	vcap_decode_field(keystream, &iter, typefld->width, (u8 *)&value);
+
+	return (value & mask) == (info->type_id & mask);
+}
+
+/* Verify that the typegroup bits have the correct values */
+static int vcap_verify_typegroups(u32 *stream, int sw_width,
+				  const struct vcap_typegroup *tgt, bool mask,
+				  int sw_max)
+{
+	struct vcap_stream_iter iter;
+	int sw_cnt, idx;
+
+	vcap_iter_set(&iter, sw_width, tgt, 0);
+	sw_cnt = 0;
+	while (iter.tg->width) {
+		u32 value = 0;
+		u32 tg_value = iter.tg->value;
+
+		if (mask)
+			tg_value = (1 << iter.tg->width) - 1;
+		/* Set position to current typegroup bit */
+		iter.offset = iter.tg->offset;
+		vcap_iter_update(&iter);
+		for (idx = 0; idx < iter.tg->width; idx++) {
+			/* Decode one typegroup bit */
+			if (vcap_get_bit(stream, &iter))
+				value |= 1 << idx;
+			iter.offset++;
+			vcap_iter_update(&iter);
+		}
+		if (value != tg_value)
+			return -EINVAL;
+		iter.tg++; /* next typegroup */
+		sw_cnt++;
+		/* Stop checking more typegroups */
+		if (sw_max && sw_cnt >= sw_max)
+			break;
+	}
+	return 0;
+}
+
+/* Find the subword width of the key typegroup that matches the stream data */
+static int vcap_find_keystream_typegroup_sw(struct vcap_control *vctrl,
+					    enum vcap_type vt, u32 *stream,
+					    bool mask, int sw_max)
+{
+	const struct vcap_typegroup **tgt;
+	int sw_idx, res;
+
+	tgt = vctrl->vcaps[vt].keyfield_set_typegroups;
+	/* Try the longest subword match first */
+	for (sw_idx = vctrl->vcaps[vt].sw_count; sw_idx >= 0; sw_idx--) {
+		if (!tgt[sw_idx])
+			continue;
+
+		res = vcap_verify_typegroups(stream, vctrl->vcaps[vt].sw_width,
+					     tgt[sw_idx], mask, sw_max);
+		if (res == 0)
+			return sw_idx;
+	}
+	return -EINVAL;
+}
+
+/* Verify that the typegroup information, subword count, keyset and type id
+ * are in sync and correct, return the list of matchin keysets
+ */
+int
+vcap_find_keystream_keysets(struct vcap_control *vctrl,
+			    enum vcap_type vt,
+			    u32 *keystream,
+			    u32 *mskstream,
+			    bool mask, int sw_max,
+			    struct vcap_keyset_list *kslist)
+{
+	const struct vcap_set *keyfield_set;
+	int sw_count, idx;
+
+	sw_count = vcap_find_keystream_typegroup_sw(vctrl, vt, keystream, mask,
+						    sw_max);
+	if (sw_count < 0)
+		return sw_count;
+
+	keyfield_set = vctrl->vcaps[vt].keyfield_set;
+	for (idx = 0; idx < vctrl->vcaps[vt].keyfield_set_size; ++idx) {
+		if (keyfield_set[idx].sw_per_item != sw_count)
+			continue;
+
+		if (vcap_verify_keystream_keyset(vctrl, vt, keystream,
+						 mskstream, idx))
+			vcap_keyset_list_add(kslist, idx);
+	}
+	if (kslist->cnt > 0)
+		return 0;
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(vcap_find_keystream_keysets);
+
+/* Read key data from a VCAP address and discover if there are any rule keysets
+ * here
+ */
+int vcap_addr_keysets(struct vcap_control *vctrl,
+		      struct net_device *ndev,
+		      struct vcap_admin *admin,
+		      int addr,
+		      struct vcap_keyset_list *kslist)
+{
+	enum vcap_type vt = admin->vtype;
+	int keyset_sw_regs, idx;
+	u32 key = 0, mask = 0;
+
+	/* Read the cache at the specified address */
+	keyset_sw_regs = DIV_ROUND_UP(vctrl->vcaps[vt].sw_width, 32);
+	vctrl->ops->update(ndev, admin, VCAP_CMD_READ, VCAP_SEL_ALL, addr);
+	vctrl->ops->cache_read(ndev, admin, VCAP_SEL_ENTRY, 0,
+			       keyset_sw_regs);
+	/* Skip uninitialized key/mask entries */
+	for (idx = 0; idx < keyset_sw_regs; ++idx) {
+		key |= ~admin->cache.keystream[idx];
+		mask |= admin->cache.maskstream[idx];
+	}
+	if (key == 0 && mask == 0)
+		return -EINVAL;
+	/* Decode and locate the keysets */
+	return vcap_find_keystream_keysets(vctrl, vt, admin->cache.keystream,
+					   admin->cache.maskstream, false, 0,
+					   kslist);
+}
+EXPORT_SYMBOL_GPL(vcap_addr_keysets);
+
 /* Return the list of keyfields for the keyset */
 const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
 					enum vcap_type vt,
@@ -618,6 +839,517 @@ struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri)
 	return duprule;
 }
 
+static void vcap_apply_width(u8 *dst, int width, int bytes)
+{
+	u8 bmask;
+	int idx;
+
+	for (idx = 0; idx < bytes; idx++) {
+		if (width > 0)
+			if (width < 8)
+				bmask = (1 << width) - 1;
+			else
+				bmask = ~0;
+		else
+			bmask = 0;
+		dst[idx] &= bmask;
+		width -= 8;
+	}
+}
+
+static void vcap_copy_from_w32be(u8 *dst, u8 *src, int size, int width)
+{
+	int idx, ridx, wstart, nidx;
+	int tail_bytes = (((size + 4) >> 2) << 2) - size;
+
+	for (idx = 0, ridx = size - 1; idx < size; ++idx, --ridx) {
+		wstart = (idx >> 2) << 2;
+		nidx = wstart + 3 - (idx & 0x3);
+		if (nidx >= size)
+			nidx -= tail_bytes;
+		dst[nidx] = src[ridx];
+	}
+
+	vcap_apply_width(dst, width, size);
+}
+
+static void vcap_copy_action_bit_field(struct vcap_u1_action *field, u8 *value)
+{
+	field->value = (*value) & 0x1;
+}
+
+static void vcap_copy_limited_actionfield(u8 *dstvalue, u8 *srcvalue,
+					  int width, int bytes)
+{
+	memcpy(dstvalue, srcvalue, bytes);
+	vcap_apply_width(dstvalue, width, bytes);
+}
+
+static void vcap_copy_to_client_actionfield(struct vcap_rule_internal *ri,
+					    struct vcap_client_actionfield *field,
+					    u8 *value, u16 width)
+{
+	int field_size = actionfield_size_table[field->ctrl.type];
+
+	if (ri->admin->w32be) {
+		switch (field->ctrl.type) {
+		case VCAP_FIELD_BIT:
+			vcap_copy_action_bit_field(&field->data.u1, value);
+			break;
+		case VCAP_FIELD_U32:
+			vcap_copy_limited_actionfield((u8 *)&field->data.u32.value,
+						      value,
+						      width, field_size);
+			break;
+		case VCAP_FIELD_U48:
+			vcap_copy_from_w32be(field->data.u48.value, value,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U56:
+			vcap_copy_from_w32be(field->data.u56.value, value,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U64:
+			vcap_copy_from_w32be(field->data.u64.value, value,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U72:
+			vcap_copy_from_w32be(field->data.u72.value, value,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U112:
+			vcap_copy_from_w32be(field->data.u112.value, value,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U128:
+			vcap_copy_from_w32be(field->data.u128.value, value,
+					     field_size, width);
+			break;
+		};
+	} else {
+		switch (field->ctrl.type) {
+		case VCAP_FIELD_BIT:
+			vcap_copy_action_bit_field(&field->data.u1, value);
+			break;
+		case VCAP_FIELD_U32:
+			vcap_copy_limited_actionfield((u8 *)&field->data.u32.value,
+						      value,
+						      width, field_size);
+			break;
+		case VCAP_FIELD_U48:
+			vcap_copy_limited_actionfield(field->data.u48.value,
+						      value,
+						      width, field_size);
+			break;
+		case VCAP_FIELD_U56:
+			vcap_copy_limited_actionfield(field->data.u56.value,
+						      value,
+						      width, field_size);
+			break;
+		case VCAP_FIELD_U64:
+			vcap_copy_limited_actionfield(field->data.u64.value,
+						      value,
+						      width, field_size);
+			break;
+		case VCAP_FIELD_U72:
+			vcap_copy_limited_actionfield(field->data.u72.value,
+						      value,
+						      width, field_size);
+			break;
+		case VCAP_FIELD_U112:
+			vcap_copy_limited_actionfield(field->data.u112.value,
+						      value,
+						      width, field_size);
+			break;
+		case VCAP_FIELD_U128:
+			vcap_copy_limited_actionfield(field->data.u128.value,
+						      value,
+						      width, field_size);
+			break;
+		};
+	}
+}
+
+static void vcap_copy_key_bit_field(struct vcap_u1_key *field,
+				    u8 *value, u8 *mask)
+{
+	field->value = (*value) & 0x1;
+	field->mask = (*mask) & 0x1;
+}
+
+static void vcap_copy_limited_keyfield(u8 *dstvalue, u8 *dstmask,
+				       u8 *srcvalue, u8 *srcmask,
+				       int width, int bytes)
+{
+	memcpy(dstvalue, srcvalue, bytes);
+	vcap_apply_width(dstvalue, width, bytes);
+	memcpy(dstmask, srcmask, bytes);
+	vcap_apply_width(dstmask, width, bytes);
+}
+
+static void vcap_copy_to_client_keyfield(struct vcap_rule_internal *ri,
+					 struct vcap_client_keyfield *field,
+					 u8 *value, u8 *mask, u16 width)
+{
+	int field_size = keyfield_size_table[field->ctrl.type] / 2;
+
+	if (ri->admin->w32be) {
+		switch (field->ctrl.type) {
+		case VCAP_FIELD_BIT:
+			vcap_copy_key_bit_field(&field->data.u1, value, mask);
+			break;
+		case VCAP_FIELD_U32:
+			vcap_copy_limited_keyfield((u8 *)&field->data.u32.value,
+						   (u8 *)&field->data.u32.mask,
+						   value, mask,
+						   width, field_size);
+			break;
+		case VCAP_FIELD_U48:
+			vcap_copy_from_w32be(field->data.u48.value, value,
+					     field_size, width);
+			vcap_copy_from_w32be(field->data.u48.mask,  mask,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U56:
+			vcap_copy_from_w32be(field->data.u56.value, value,
+					     field_size, width);
+			vcap_copy_from_w32be(field->data.u56.mask,  mask,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U64:
+			vcap_copy_from_w32be(field->data.u64.value, value,
+					     field_size, width);
+			vcap_copy_from_w32be(field->data.u64.mask,  mask,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U72:
+			vcap_copy_from_w32be(field->data.u72.value, value,
+					     field_size, width);
+			vcap_copy_from_w32be(field->data.u72.mask,  mask,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U112:
+			vcap_copy_from_w32be(field->data.u112.value, value,
+					     field_size, width);
+			vcap_copy_from_w32be(field->data.u112.mask,  mask,
+					     field_size, width);
+			break;
+		case VCAP_FIELD_U128:
+			vcap_copy_from_w32be(field->data.u128.value, value,
+					     field_size, width);
+			vcap_copy_from_w32be(field->data.u128.mask,  mask,
+					     field_size, width);
+			break;
+		};
+	} else {
+		switch (field->ctrl.type) {
+		case VCAP_FIELD_BIT:
+			vcap_copy_key_bit_field(&field->data.u1, value, mask);
+			break;
+		case VCAP_FIELD_U32:
+			vcap_copy_limited_keyfield((u8 *)&field->data.u32.value,
+						   (u8 *)&field->data.u32.mask,
+						   value, mask,
+						   width, field_size);
+			break;
+		case VCAP_FIELD_U48:
+			vcap_copy_limited_keyfield(field->data.u48.value,
+						   field->data.u48.mask,
+						   value, mask,
+						   width, field_size);
+			break;
+		case VCAP_FIELD_U56:
+			vcap_copy_limited_keyfield(field->data.u56.value,
+						   field->data.u56.mask,
+						   value, mask,
+						   width, field_size);
+			break;
+		case VCAP_FIELD_U64:
+			vcap_copy_limited_keyfield(field->data.u64.value,
+						   field->data.u64.mask,
+						   value, mask,
+						   width, field_size);
+			break;
+		case VCAP_FIELD_U72:
+			vcap_copy_limited_keyfield(field->data.u72.value,
+						   field->data.u72.mask,
+						   value, mask,
+						   width, field_size);
+			break;
+		case VCAP_FIELD_U112:
+			vcap_copy_limited_keyfield(field->data.u112.value,
+						   field->data.u112.mask,
+						   value, mask,
+						   width, field_size);
+			break;
+		case VCAP_FIELD_U128:
+			vcap_copy_limited_keyfield(field->data.u128.value,
+						   field->data.u128.mask,
+						   value, mask,
+						   width, field_size);
+			break;
+		};
+	}
+}
+
+static void vcap_rule_alloc_keyfield(struct vcap_rule_internal *ri,
+				     const struct vcap_field *keyfield,
+				     enum vcap_key_field key,
+				     u8 *value, u8 *mask)
+{
+	struct vcap_client_keyfield *field;
+
+	field = kzalloc(sizeof(*field), GFP_KERNEL);
+	if (!field)
+		return;
+	INIT_LIST_HEAD(&field->ctrl.list);
+	field->ctrl.key = key;
+	field->ctrl.type = keyfield->type;
+	vcap_copy_to_client_keyfield(ri, field, value, mask, keyfield->width);
+	list_add_tail(&field->ctrl.list, &ri->data.keyfields);
+}
+
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
+/* Store action value in an element in a list for the client */
+static void vcap_rule_alloc_actionfield(struct vcap_rule_internal *ri,
+					const struct vcap_field *actionfield,
+					enum vcap_action_field action,
+					u8 *value)
+{
+	struct vcap_client_actionfield *field;
+
+	field = kzalloc(sizeof(*field), GFP_KERNEL);
+	if (!field)
+		return;
+	INIT_LIST_HEAD(&field->ctrl.list);
+	field->ctrl.action = action;
+	field->ctrl.type = actionfield->type;
+	vcap_copy_to_client_actionfield(ri, field, value, actionfield->width);
+	list_add_tail(&field->ctrl.list, &ri->data.actionfields);
+}
+
+static int vcap_decode_actionset(struct vcap_rule_internal *ri)
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
+
+	actstream = admin->cache.actionstream;
+	res = vcap_find_actionstream_actionset(vctrl, vt, actstream, 0);
+	if (res < 0) {
+		pr_err("%s:%d: could not find valid actionset: %d\n",
+		       __func__, __LINE__, res);
+		return -EINVAL;
+	}
+	actionset = res;
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
+		if (vcap_bitarray_zero(actionfield[idx].width, value))
+			continue;
+		vcap_rule_alloc_actionfield(ri, &actionfield[idx], idx, value);
+		/* Later the action id will also be checked */
+	}
+	return vcap_set_rule_set_actionset((struct vcap_rule *)ri, actionset);
+}
+
+static int vcap_decode_keyset(struct vcap_rule_internal *ri)
+{
+	struct vcap_control *vctrl = ri->vctrl;
+	struct vcap_stream_iter kiter, miter;
+	struct vcap_admin *admin = ri->admin;
+	enum vcap_keyfield_set keysets[10];
+	const struct vcap_field *keyfield;
+	enum vcap_type vt = admin->vtype;
+	const struct vcap_typegroup *tgt;
+	struct vcap_keyset_list matches;
+	enum vcap_keyfield_set keyset;
+	int idx, res, keyfield_count;
+	u32 *maskstream;
+	u32 *keystream;
+	u8 value[16];
+	u8 mask[16];
+
+	keystream = admin->cache.keystream;
+	maskstream = admin->cache.maskstream;
+	matches.keysets = keysets;
+	matches.cnt = 0;
+	matches.max = ARRAY_SIZE(keysets);
+	res = vcap_find_keystream_keysets(vctrl, vt, keystream, maskstream,
+					  false, 0, &matches);
+	if (res < 0) {
+		pr_err("%s:%d: could not find valid keysets: %d\n",
+		       __func__, __LINE__, res);
+		return -EINVAL;
+	}
+	keyset = matches.keysets[0];
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
+		vcap_rule_alloc_keyfield(ri, &keyfield[idx], idx, value, mask);
+	}
+	return vcap_set_rule_set_keyset((struct vcap_rule *)ri, keyset);
+}
+
+/* Read VCAP content into the VCAP cache */
+static int vcap_read_rule(struct vcap_rule_internal *ri)
+{
+	struct vcap_admin *admin = ri->admin;
+	int sw_idx, ent_idx = 0, act_idx = 0;
+	u32 addr = ri->addr;
+
+	if (!ri->size || !ri->keyset_sw_regs || !ri->actionset_sw_regs) {
+		pr_err("%s:%d: rule is empty\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+	vcap_erase_cache(ri);
+	/* Use the values in the streams to read the VCAP cache */
+	for (sw_idx = 0; sw_idx < ri->size; sw_idx++, addr++) {
+		ri->vctrl->ops->update(ri->ndev, admin, VCAP_CMD_READ,
+				       VCAP_SEL_ALL, addr);
+		ri->vctrl->ops->cache_read(ri->ndev, admin,
+					   VCAP_SEL_ENTRY, ent_idx,
+					   ri->keyset_sw_regs);
+		ri->vctrl->ops->cache_read(ri->ndev, admin,
+					   VCAP_SEL_ACTION, act_idx,
+					   ri->actionset_sw_regs);
+		if (sw_idx == 0)
+			ri->vctrl->ops->cache_read(ri->ndev, admin,
+						   VCAP_SEL_COUNTER,
+						   ri->counter_id, 0);
+		ent_idx += ri->keyset_sw_regs;
+		act_idx += ri->actionset_sw_regs;
+	}
+	return 0;
+}
+
 /* Write VCAP cache content to the VCAP HW instance */
 static int vcap_write_rule(struct vcap_rule_internal *ri)
 {
@@ -1183,6 +1915,46 @@ void vcap_free_rule(struct vcap_rule *rule)
 }
 EXPORT_SYMBOL_GPL(vcap_free_rule);
 
+struct vcap_rule *vcap_get_rule(struct vcap_control *vctrl, u32 id)
+{
+	struct vcap_rule_internal *elem;
+	struct vcap_rule_internal *ri;
+	int err;
+
+	ri = NULL;
+
+	err = vcap_api_check(vctrl);
+	if (err)
+		return ERR_PTR(err);
+	elem = vcap_lookup_rule(vctrl, id);
+	if (!elem)
+		return NULL;
+	mutex_lock(&elem->admin->lock);
+	ri = vcap_dup_rule(elem);
+	if (IS_ERR(ri))
+		goto unlock;
+	err = vcap_read_rule(ri);
+	if (err) {
+		ri = ERR_PTR(err);
+		goto unlock;
+	}
+	err = vcap_decode_keyset(ri);
+	if (err) {
+		ri = ERR_PTR(err);
+		goto unlock;
+	}
+	err = vcap_decode_actionset(ri);
+	if (err) {
+		ri = ERR_PTR(err);
+		goto unlock;
+	}
+
+unlock:
+	mutex_unlock(&elem->admin->lock);
+	return (struct vcap_rule *)ri;
+}
+EXPORT_SYMBOL_GPL(vcap_get_rule);
+
 /* Return the alignment offset for a new rule address */
 static int vcap_valid_rule_move(struct vcap_rule_internal *el, int offset)
 {
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 93a0fcb12a819..a354dcd741e22 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -170,6 +170,8 @@ int vcap_add_rule(struct vcap_rule *rule);
 int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id);
 /* Make a full copy of an existing rule with a new rule id */
 struct vcap_rule *vcap_copy_rule(struct vcap_rule *rule);
+/* Get rule from a VCAP instance */
+struct vcap_rule *vcap_get_rule(struct vcap_control *vctrl, u32 id);
 
 /* Update the keyset for the rule */
 int vcap_set_rule_set_keyset(struct vcap_rule *rule,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index 5df00e9403338..8c635d1e77b92 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -18,355 +18,15 @@ struct vcap_port_debugfs_info {
 	struct net_device *ndev;
 };
 
-static bool vcap_bitarray_zero(int width, u8 *value)
-{
-	int bytes = DIV_ROUND_UP(width, BITS_PER_BYTE);
-	u8 total = 0, bmask = 0xff;
-	int rwidth = width;
-	int idx;
-
-	for (idx = 0; idx < bytes; ++idx, rwidth -= BITS_PER_BYTE) {
-		if (rwidth && rwidth < BITS_PER_BYTE)
-			bmask = (1 << rwidth) - 1;
-		total += value[idx] & bmask;
-	}
-	return total == 0;
-}
-
-static bool vcap_get_bit(u32 *stream, struct vcap_stream_iter *itr)
-{
-	u32 mask = BIT(itr->reg_bitpos);
-	u32 *p = &stream[itr->reg_idx];
-
-	return !!(*p & mask);
-}
-
-static void vcap_decode_field(u32 *stream, struct vcap_stream_iter *itr,
-			      int width, u8 *value)
-{
-	int idx;
-
-	/* Loop over the field value bits and get the field bits and
-	 * set them in the output value byte array
-	 */
-	for (idx = 0; idx < width; idx++) {
-		u8 bidx = idx & 0x7;
-
-		/* Decode one field value bit */
-		if (vcap_get_bit(stream, itr))
-			*value |= 1 << bidx;
-		vcap_iter_next(itr);
-		if (bidx == 7)
-			value++;
-	}
-}
-
-/* Verify that the typegroup bits have the correct values */
-static int vcap_verify_typegroups(u32 *stream, int sw_width,
-				  const struct vcap_typegroup *tgt, bool mask,
-				  int sw_max)
-{
-	struct vcap_stream_iter iter;
-	int sw_cnt, idx;
-
-	vcap_iter_set(&iter, sw_width, tgt, 0);
-	sw_cnt = 0;
-	while (iter.tg->width) {
-		u32 value = 0;
-		u32 tg_value = iter.tg->value;
-
-		if (mask)
-			tg_value = (1 << iter.tg->width) - 1;
-		/* Set position to current typegroup bit */
-		iter.offset = iter.tg->offset;
-		vcap_iter_update(&iter);
-		for (idx = 0; idx < iter.tg->width; idx++) {
-			/* Decode one typegroup bit */
-			if (vcap_get_bit(stream, &iter))
-				value |= 1 << idx;
-			iter.offset++;
-			vcap_iter_update(&iter);
-		}
-		if (value != tg_value)
-			return -EINVAL;
-		iter.tg++; /* next typegroup */
-		sw_cnt++;
-		/* Stop checking more typegroups */
-		if (sw_max && sw_cnt >= sw_max)
-			break;
-	}
-	return 0;
-}
-
-/* Find the subword width of the key typegroup that matches the stream data */
-static int vcap_find_keystream_typegroup_sw(struct vcap_control *vctrl,
-					    enum vcap_type vt, u32 *stream,
-					    bool mask, int sw_max)
-{
-	const struct vcap_typegroup **tgt;
-	int sw_idx, res;
-
-	tgt = vctrl->vcaps[vt].keyfield_set_typegroups;
-	/* Try the longest subword match first */
-	for (sw_idx = vctrl->vcaps[vt].sw_count; sw_idx >= 0; sw_idx--) {
-		if (!tgt[sw_idx])
-			continue;
-
-		res = vcap_verify_typegroups(stream, vctrl->vcaps[vt].sw_width,
-					     tgt[sw_idx], mask, sw_max);
-		if (res == 0)
-			return sw_idx;
-	}
-	return -EINVAL;
-}
-
-/* Find the subword width of the action typegroup that matches the stream data
- */
-static int vcap_find_actionstream_typegroup_sw(struct vcap_control *vctrl,
-					       enum vcap_type vt, u32 *stream,
-					       int sw_max)
-{
-	const struct vcap_typegroup **tgt;
-	int sw_idx, res;
-
-	tgt = vctrl->vcaps[vt].actionfield_set_typegroups;
-	/* Try the longest subword match first */
-	for (sw_idx = vctrl->vcaps[vt].sw_count; sw_idx >= 0; sw_idx--) {
-		if (!tgt[sw_idx])
-			continue;
-		res = vcap_verify_typegroups(stream, vctrl->vcaps[vt].act_width,
-					     tgt[sw_idx], false, sw_max);
-		if (res == 0)
-			return sw_idx;
-	}
-	return -EINVAL;
-}
-
-/* Verify that the type id in the stream matches the type id of the keyset */
-static bool vcap_verify_keystream_keyset(struct vcap_control *vctrl,
-					 enum vcap_type vt,
-					 u32 *keystream,
-					 u32 *mskstream,
-					 enum vcap_keyfield_set keyset)
-{
-	const struct vcap_info *vcap = &vctrl->vcaps[vt];
-	const struct vcap_field *typefld;
-	const struct vcap_typegroup *tgt;
-	const struct vcap_field *fields;
-	struct vcap_stream_iter iter;
-	const struct vcap_set *info;
-	u32 value = 0;
-	u32 mask = 0;
-
-	if (vcap_keyfield_count(vctrl, vt, keyset) == 0)
-		return false;
-
-	info = vcap_keyfieldset(vctrl, vt, keyset);
-	/* Check that the keyset is valid */
-	if (!info)
-		return false;
-
-	/* a type_id of value -1 means that there is no type field */
-	if (info->type_id == (u8)-1)
-		return true;
-
-	/* Get a valid typegroup for the specific keyset */
-	tgt = vcap_keyfield_typegroup(vctrl, vt, keyset);
-	if (!tgt)
-		return false;
-
-	fields = vcap_keyfields(vctrl, vt, keyset);
-	if (!fields)
-		return false;
-
-	typefld = &fields[VCAP_KF_TYPE];
-	vcap_iter_init(&iter, vcap->sw_width, tgt, typefld->offset);
-	vcap_decode_field(mskstream, &iter, typefld->width, (u8 *)&mask);
-	/* no type info if there are no mask bits */
-	if (vcap_bitarray_zero(typefld->width, (u8 *)&mask))
-		return false;
-
-	/* Get the value of the type field in the stream and compare to the
-	 * one define in the vcap keyset
-	 */
-	vcap_iter_init(&iter, vcap->sw_width, tgt, typefld->offset);
-	vcap_decode_field(keystream, &iter, typefld->width, (u8 *)&value);
-
-	return (value & mask) == (info->type_id & mask);
-}
-
-/* Verify that the typegroup information, subword count, keyset and type id
- * are in sync and correct, return the list of matching keysets
- */
-static int
-vcap_find_keystream_keysets(struct vcap_control *vctrl,
-			    enum vcap_type vt,
-			    u32 *keystream,
-			    u32 *mskstream,
-			    bool mask, int sw_max,
-			    struct vcap_keyset_list *kslist)
-{
-	const struct vcap_set *keyfield_set;
-	int sw_count, idx;
-
-	sw_count = vcap_find_keystream_typegroup_sw(vctrl, vt, keystream, mask,
-						    sw_max);
-	if (sw_count < 0)
-		return sw_count;
-
-	keyfield_set = vctrl->vcaps[vt].keyfield_set;
-	for (idx = 0; idx < vctrl->vcaps[vt].keyfield_set_size; ++idx) {
-		if (keyfield_set[idx].sw_per_item != sw_count)
-			continue;
-
-		if (vcap_verify_keystream_keyset(vctrl, vt, keystream,
-						 mskstream, idx))
-			vcap_keyset_list_add(kslist, idx);
-	}
-	if (kslist->cnt > 0)
-		return 0;
-	return -EINVAL;
-}
-
-/* Read key data from a VCAP address and discover if there is a rule keyset
- * here
- */
-static bool
-vcap_verify_actionstream_actionset(struct vcap_control *vctrl,
-				   enum vcap_type vt,
-				   u32 *actionstream,
-				   enum vcap_actionfield_set actionset)
-{
-	const struct vcap_typegroup *tgt;
-	const struct vcap_field *fields;
-	const struct vcap_set *info;
-
-	if (vcap_actionfield_count(vctrl, vt, actionset) == 0)
-		return false;
-
-	info = vcap_actionfieldset(vctrl, vt, actionset);
-	/* Check that the actionset is valid */
-	if (!info)
-		return false;
-
-	/* a type_id of value -1 means that there is no type field */
-	if (info->type_id == (u8)-1)
-		return true;
-
-	/* Get a valid typegroup for the specific actionset */
-	tgt = vcap_actionfield_typegroup(vctrl, vt, actionset);
-	if (!tgt)
-		return false;
-
-	fields = vcap_actionfields(vctrl, vt, actionset);
-	if (!fields)
-		return false;
-
-	/* Later this will be expanded with a check of the type id */
-	return true;
-}
-
-/* Verify that the typegroup information, subword count, actionset and type id
- * are in sync and correct, return the actionset
- */
-static enum vcap_actionfield_set
-vcap_find_actionstream_actionset(struct vcap_control *vctrl,
-				 enum vcap_type vt,
-				 u32 *stream,
-				 int sw_max)
-{
-	const struct vcap_set *actionfield_set;
-	int sw_count, idx;
-	bool res;
-
-	sw_count = vcap_find_actionstream_typegroup_sw(vctrl, vt, stream,
-						       sw_max);
-	if (sw_count < 0)
-		return sw_count;
-
-	actionfield_set = vctrl->vcaps[vt].actionfield_set;
-	for (idx = 0; idx < vctrl->vcaps[vt].actionfield_set_size; ++idx) {
-		if (actionfield_set[idx].sw_per_item != sw_count)
-			continue;
-
-		res = vcap_verify_actionstream_actionset(vctrl, vt,
-							 stream, idx);
-		if (res)
-			return idx;
-	}
-	return -EINVAL;
-}
-
-/* Read key data from a VCAP address and discover if there are any rule keysets
- * here
- */
-static int vcap_addr_keysets(struct vcap_control *vctrl,
-			     struct net_device *ndev,
-			     struct vcap_admin *admin,
-			     int addr,
-			     struct vcap_keyset_list *kslist)
-{
-	enum vcap_type vt = admin->vtype;
-	int keyset_sw_regs, idx;
-	u32 key = 0, mask = 0;
-
-	/* Read the cache at the specified address */
-	keyset_sw_regs = DIV_ROUND_UP(vctrl->vcaps[vt].sw_width, 32);
-	vctrl->ops->update(ndev, admin, VCAP_CMD_READ, VCAP_SEL_ALL, addr);
-	vctrl->ops->cache_read(ndev, admin, VCAP_SEL_ENTRY, 0,
-			       keyset_sw_regs);
-	/* Skip uninitialized key/mask entries */
-	for (idx = 0; idx < keyset_sw_regs; ++idx) {
-		key |= ~admin->cache.keystream[idx];
-		mask |= admin->cache.maskstream[idx];
-	}
-	if (key == 0 && mask == 0)
-		return -EINVAL;
-	/* Decode and locate the keysets */
-	return vcap_find_keystream_keysets(vctrl, vt, admin->cache.keystream,
-					   admin->cache.maskstream, false, 0,
-					   kslist);
-}
-
-static int vcap_read_rule(struct vcap_rule_internal *ri)
-{
-	struct vcap_admin *admin = ri->admin;
-	int sw_idx, ent_idx = 0, act_idx = 0;
-	u32 addr = ri->addr;
-
-	if (!ri->size || !ri->keyset_sw_regs || !ri->actionset_sw_regs) {
-		pr_err("%s:%d: rule is empty\n", __func__, __LINE__);
-		return -EINVAL;
-	}
-	vcap_erase_cache(ri);
-	/* Use the values in the streams to read the VCAP cache */
-	for (sw_idx = 0; sw_idx < ri->size; sw_idx++, addr++) {
-		ri->vctrl->ops->update(ri->ndev, admin, VCAP_CMD_READ,
-				       VCAP_SEL_ALL, addr);
-		ri->vctrl->ops->cache_read(ri->ndev, admin,
-					   VCAP_SEL_ENTRY, ent_idx,
-					   ri->keyset_sw_regs);
-		ri->vctrl->ops->cache_read(ri->ndev, admin,
-					   VCAP_SEL_ACTION, act_idx,
-					   ri->actionset_sw_regs);
-		if (sw_idx == 0)
-			ri->vctrl->ops->cache_read(ri->ndev, admin,
-						   VCAP_SEL_COUNTER,
-						   ri->counter_id, 0);
-		ent_idx += ri->keyset_sw_regs;
-		act_idx += ri->actionset_sw_regs;
-	}
-	return 0;
-}
-
 /* Dump the keyfields value and mask values */
 static void vcap_debugfs_show_rule_keyfield(struct vcap_control *vctrl,
 					    struct vcap_output_print *out,
 					    enum vcap_key_field key,
 					    const struct vcap_field *keyfield,
-					    u8 *value, u8 *mask)
+					    struct vcap_client_keyfield_data *data)
 {
 	bool hex = false;
+	u8 *value, *mask;
 	int idx, bytes;
 
 	out->prf(out->dst, "    %s: W%d: ", vcap_keyfield_name(vctrl, key),
@@ -374,40 +34,62 @@ static void vcap_debugfs_show_rule_keyfield(struct vcap_control *vctrl,
 
 	switch (keyfield[key].type) {
 	case VCAP_FIELD_BIT:
-		out->prf(out->dst, "%d/%d", value[0], mask[0]);
+		out->prf(out->dst, "%d/%d", data->u1.value, data->u1.mask);
 		break;
 	case VCAP_FIELD_U32:
+		value = (u8 *)(&data->u32.value);
+		mask = (u8 *)(&data->u32.mask);
+
 		if (key == VCAP_KF_L3_IP4_SIP || key == VCAP_KF_L3_IP4_DIP) {
-			out->prf(out->dst, "%pI4h/%pI4h", value, mask);
+			out->prf(out->dst, "%pI4h/%pI4h", &data->u32.value,
+				 &data->u32.mask);
 		} else if (key == VCAP_KF_ETYPE ||
 			   key == VCAP_KF_IF_IGR_PORT_MASK) {
 			hex = true;
 		} else {
 			u32 fmsk = (1 << keyfield[key].width) - 1;
-			u32 val = *(u32 *)value;
-			u32 msk = *(u32 *)mask;
 
-			out->prf(out->dst, "%u/%u", val & fmsk, msk & fmsk);
+			out->prf(out->dst, "%u/%u", data->u32.value & fmsk,
+				 data->u32.mask & fmsk);
 		}
 		break;
 	case VCAP_FIELD_U48:
+		value = data->u48.value;
+		mask = data->u48.mask;
 		if (key == VCAP_KF_L2_SMAC || key == VCAP_KF_L2_DMAC)
-			out->prf(out->dst, "%pMR/%pMR", value, mask);
+			out->prf(out->dst, "%pMR/%pMR", data->u48.value,
+				 data->u48.mask);
 		else
 			hex = true;
 		break;
 	case VCAP_FIELD_U56:
+		value = data->u56.value;
+		mask = data->u56.mask;
+		hex = true;
+		break;
 	case VCAP_FIELD_U64:
+		value = data->u64.value;
+		mask = data->u64.mask;
+		hex = true;
+		break;
 	case VCAP_FIELD_U72:
+		value = data->u72.value;
+		mask = data->u72.mask;
+		hex = true;
+		break;
 	case VCAP_FIELD_U112:
+		value = data->u112.value;
+		mask = data->u112.mask;
 		hex = true;
 		break;
 	case VCAP_FIELD_U128:
 		if (key == VCAP_KF_L3_IP6_SIP || key == VCAP_KF_L3_IP6_DIP) {
 			u8 nvalue[16], nmask[16];
 
-			vcap_netbytes_copy(nvalue, value, sizeof(nvalue));
-			vcap_netbytes_copy(nmask, mask, sizeof(nmask));
+			vcap_netbytes_copy(nvalue, data->u128.value,
+					   sizeof(nvalue));
+			vcap_netbytes_copy(nmask, data->u128.mask,
+					   sizeof(nmask));
 			out->prf(out->dst, "%pI6/%pI6", nvalue, nmask);
 		} else {
 			hex = true;
@@ -472,19 +154,15 @@ static int vcap_debugfs_show_rule_keyset(struct vcap_rule_internal *ri,
 					 struct vcap_output_print *out)
 {
 	struct vcap_control *vctrl = ri->vctrl;
-	struct vcap_stream_iter kiter, miter;
 	struct vcap_admin *admin = ri->admin;
 	enum vcap_keyfield_set keysets[10];
 	const struct vcap_field *keyfield;
 	enum vcap_type vt = admin->vtype;
-	const struct vcap_typegroup *tgt;
+	struct vcap_client_keyfield *ckf;
 	struct vcap_keyset_list matches;
-	enum vcap_keyfield_set keyset;
-	int idx, res, keyfield_count;
 	u32 *maskstream;
 	u32 *keystream;
-	u8 value[16];
-	u8 mask[16];
+	int res;
 
 	keystream = admin->cache.keystream;
 	maskstream = admin->cache.maskstream;
@@ -498,39 +176,20 @@ static int vcap_debugfs_show_rule_keyset(struct vcap_rule_internal *ri,
 		       __func__, __LINE__, res);
 		return -EINVAL;
 	}
-	keyset = matches.keysets[0];
 	out->prf(out->dst, "  keysets:");
-	for (idx = 0; idx < matches.cnt; ++idx)
+	for (int idx = 0; idx < matches.cnt; ++idx)
 		out->prf(out->dst, " %s",
 			 vcap_keyset_name(vctrl, matches.keysets[idx]));
 	out->prf(out->dst, "\n");
 	out->prf(out->dst, "  keyset_sw: %d\n", ri->keyset_sw);
 	out->prf(out->dst, "  keyset_sw_regs: %d\n", ri->keyset_sw_regs);
-	keyfield_count = vcap_keyfield_count(vctrl, vt, keyset);
-	keyfield = vcap_keyfields(vctrl, vt, keyset);
-	tgt = vcap_keyfield_typegroup(vctrl, vt, keyset);
-	/* Start decoding the streams */
-	for (idx = 0; idx < keyfield_count; ++idx) {
-		if (keyfield[idx].width <= 0)
-			continue;
-		/* First get the mask */
-		memset(mask, 0, DIV_ROUND_UP(keyfield[idx].width, 8));
-		vcap_iter_init(&miter, vctrl->vcaps[vt].sw_width, tgt,
-			       keyfield[idx].offset);
-		vcap_decode_field(maskstream, &miter, keyfield[idx].width,
-				  mask);
-		/* Skip if no mask bits are set */
-		if (vcap_bitarray_zero(keyfield[idx].width, mask))
-			continue;
-		/* Get the key */
-		memset(value, 0, DIV_ROUND_UP(keyfield[idx].width, 8));
-		vcap_iter_init(&kiter, vctrl->vcaps[vt].sw_width, tgt,
-			       keyfield[idx].offset);
-		vcap_decode_field(keystream, &kiter, keyfield[idx].width,
-				  value);
-		vcap_debugfs_show_rule_keyfield(vctrl, out, idx, keyfield,
-						value, mask);
+
+	list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list) {
+		keyfield = vcap_keyfields(vctrl, admin->vtype, ri->data.keyset);
+		vcap_debugfs_show_rule_keyfield(vctrl, out, ckf->ctrl.key,
+						keyfield, &ckf->data);
 	}
+
 	return 0;
 }
 
@@ -540,48 +199,21 @@ static int vcap_debugfs_show_rule_actionset(struct vcap_rule_internal *ri,
 	struct vcap_control *vctrl = ri->vctrl;
 	struct vcap_admin *admin = ri->admin;
 	const struct vcap_field *actionfield;
-	enum vcap_actionfield_set actionset;
-	enum vcap_type vt = admin->vtype;
-	const struct vcap_typegroup *tgt;
-	struct vcap_stream_iter iter;
-	int idx, res, actfield_count;
-	u32 *actstream;
-	u8 value[16];
-	bool no_bits;
-
-	actstream = admin->cache.actionstream;
-	res = vcap_find_actionstream_actionset(vctrl, vt, actstream, 0);
-	if (res < 0) {
-		pr_err("%s:%d: could not find valid actionset: %d\n",
-		       __func__, __LINE__, res);
-		return -EINVAL;
-	}
-	actionset = res;
+	struct vcap_client_actionfield *caf;
+
 	out->prf(out->dst, "  actionset: %s\n",
 		 vcap_actionset_name(vctrl, ri->data.actionset));
 	out->prf(out->dst, "  actionset_sw: %d\n", ri->actionset_sw);
 	out->prf(out->dst, "  actionset_sw_regs: %d\n", ri->actionset_sw_regs);
-	actfield_count = vcap_actionfield_count(vctrl, vt, actionset);
-	actionfield = vcap_actionfields(vctrl, vt, actionset);
-	tgt = vcap_actionfield_typegroup(vctrl, vt, actionset);
-	/* Start decoding the stream */
-	for (idx = 0; idx < actfield_count; ++idx) {
-		if (actionfield[idx].width <= 0)
-			continue;
-		/* Get the action */
-		memset(value, 0, DIV_ROUND_UP(actionfield[idx].width, 8));
-		vcap_iter_init(&iter, vctrl->vcaps[vt].act_width, tgt,
-			       actionfield[idx].offset);
-		vcap_decode_field(actstream, &iter, actionfield[idx].width,
-				  value);
-		/* Skip if no bits are set */
-		no_bits = vcap_bitarray_zero(actionfield[idx].width, value);
-		if (no_bits)
-			continue;
-		/* Later the action id will also be checked */
-		vcap_debugfs_show_rule_actionfield(vctrl, out, idx, actionfield,
-						   value);
+
+	list_for_each_entry(caf, &ri->data.actionfields, ctrl.list) {
+		actionfield = vcap_actionfields(vctrl, admin->vtype,
+						ri->data.actionset);
+		vcap_debugfs_show_rule_actionfield(vctrl, out, caf->ctrl.action,
+						   actionfield,
+						   &caf->data.u1.value);
 	}
+
 	return 0;
 }
 
@@ -632,25 +264,21 @@ static int vcap_show_admin(struct vcap_control *vctrl,
 			   struct vcap_admin *admin,
 			   struct vcap_output_print *out)
 {
-	struct vcap_rule_internal *elem, *ri;
+	struct vcap_rule_internal *elem;
+	struct vcap_rule *vrule;
 	int ret = 0;
 
 	vcap_show_admin_info(vctrl, admin, out);
-	mutex_lock(&admin->lock);
 	list_for_each_entry(elem, &admin->rules, list) {
-		ri = vcap_dup_rule(elem);
-		if (IS_ERR(ri))
-			goto free_rule;
-		/* Read data from VCAP */
-		ret = vcap_read_rule(ri);
-		if (ret)
-			goto free_rule;
+		vrule = vcap_get_rule(vctrl, elem->data.id);
+		if (IS_ERR(vrule)) {
+			ret = PTR_ERR(vrule);
+			break;
+		}
 		out->prf(out->dst, "\n");
-		vcap_show_admin_rule(vctrl, admin, out, ri);
-free_rule:
-		vcap_free_rule((struct vcap_rule *)ri);
+		vcap_show_admin_rule(vctrl, admin, out, to_intrule(vrule));
+		vcap_free_rule(vrule);
 	}
-	mutex_unlock(&admin->lock);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
index 9ac1b1d55f22e..4fd21da976799 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
@@ -96,4 +96,18 @@ const char *vcap_actionset_name(struct vcap_control *vctrl,
 const char *vcap_actionfield_name(struct vcap_control *vctrl,
 				  enum vcap_action_field action);
 
+/* Read key data from a VCAP address and discover if there are any rule keysets
+ * here
+ */
+int vcap_addr_keysets(struct vcap_control *vctrl, struct net_device *ndev,
+		      struct vcap_admin *admin, int addr,
+		      struct vcap_keyset_list *kslist);
+
+/* Verify that the typegroup information, subword count, keyset and type id
+ * are in sync and correct, return the list of matchin keysets
+ */
+int vcap_find_keystream_keysets(struct vcap_control *vctrl, enum vcap_type vt,
+				u32 *keystream, u32 *mskstream, bool mask,
+				int sw_max, struct vcap_keyset_list *kslist);
+
 #endif /* __VCAP_API_PRIVATE__ */
-- 
2.38.0

