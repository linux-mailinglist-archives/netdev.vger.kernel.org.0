Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6423960449A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJSMIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbiJSMHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:07:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD7FD38D3;
        Wed, 19 Oct 2022 04:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666179856; x=1697715856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EV0wX0oZnLRss/1ZD+AJ+a7rtHQp28ezbxSGGoMuK/8=;
  b=UzjG4kDYmk949FgXXhVuv/iiK4QkiCdM/s3x805V+v8Ob7OwOmzuJuzp
   U6Mux9gOFwFS91WBXQaIuDSaOIoJ5s1HKxFNO8xk8ZPAjJVsckyOeHB4C
   rw3RgXvjhDRkvXcWRnJSRJ1SiRlos6AwGtYM8I3/dXsmgdgUWDbB3glVp
   RKhhyt+DEpTCJWj2GGw8IR5Jdh1kHL7tm3+6mvFjTwpEbZiHimnvHtP+s
   sUjdPMs1mogYt5QyqfZ3T85XxQQUH6Ax67ZOZD8Dn6sEaQw+CUVQRGnB0
   P8CcFGu3q6MjF2aMGGyywlW8BW6NnR6sgR6ui4dX/G2hur4BC5Fy5oJFf
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="182926254"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 04:42:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 04:42:44 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 04:42:41 -0700
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
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v2 7/9] net: microchip: sparx5: Writing rules to the IS2 VCAP
Date:   Wed, 19 Oct 2022 13:42:13 +0200
Message-ID: <20221019114215.620969-8-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221019114215.620969-1-steen.hegelund@microchip.com>
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds rule encoding functionality to the VCAP API.

A rule consists of keys and actions in separate cache sections.

The maximum size of the keyset or actionset determines the size of the
rule.

The VCAP hardware need to be able to distinguish different rule sizes from
each other, and for that purpose some extra typegroup bits are added to the
rule when it is encoded.

The API provides a bit stream iterator that allows highlevel encoding
functionality to add key and action value bits independent of typegroup
bits.

This is handled by letting the concrete VCAP model provide the typegroup
table for the different rule sizes.
After the key and action values have been added to the encoding bit streams
the typegroup bits are set to their correct values just before the rule is
written to the VCAP hardware.

The key and action offsets provided in the VCAP model are the offset before
adding the typegroup bits.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 424 +++++++++++++++++-
 1 file changed, 423 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 7f5ec072681c..06290fd27cc1 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -34,6 +34,139 @@ struct vcap_rule_move {
 	int count; /* blocksize of addresses to move */
 };
 
+/* Bit iterator for the VCAP cache streams */
+struct vcap_stream_iter {
+	u32 offset; /* bit offset from the stream start */
+	u32 sw_width; /* subword width in bits */
+	u32 regs_per_sw; /* registers per subword */
+	u32 reg_idx; /* current register index */
+	u32 reg_bitpos; /* bit offset in current register */
+	const struct vcap_typegroup *tg; /* current typegroup */
+};
+
+static void vcap_iter_set(struct vcap_stream_iter *itr, int sw_width,
+			  const struct vcap_typegroup *tg, u32 offset)
+{
+	memset(itr, 0, sizeof(*itr));
+	itr->offset = offset;
+	itr->sw_width = sw_width;
+	itr->regs_per_sw = DIV_ROUND_UP(sw_width, 32);
+	itr->tg = tg;
+}
+
+static void vcap_iter_skip_tg(struct vcap_stream_iter *itr)
+{
+	/* Compensate the field offset for preceding typegroups */
+	while (itr->tg->width && itr->offset >= itr->tg->offset) {
+		itr->offset += itr->tg->width;
+		itr->tg++; /* next typegroup */
+	}
+}
+
+static void vcap_iter_update(struct vcap_stream_iter *itr)
+{
+	int sw_idx, sw_bitpos;
+
+	/* Calculate the subword index and bitposition for current bit */
+	sw_idx = itr->offset / itr->sw_width;
+	sw_bitpos = itr->offset % itr->sw_width;
+	/* Calculate the register index and bitposition for current bit */
+	itr->reg_idx = (sw_idx * itr->regs_per_sw) + (sw_bitpos / 32);
+	itr->reg_bitpos = sw_bitpos % 32;
+}
+
+static void vcap_iter_init(struct vcap_stream_iter *itr, int sw_width,
+			   const struct vcap_typegroup *tg, u32 offset)
+{
+	vcap_iter_set(itr, sw_width, tg, offset);
+	vcap_iter_skip_tg(itr);
+	vcap_iter_update(itr);
+}
+
+static void vcap_iter_next(struct vcap_stream_iter *itr)
+{
+	itr->offset++;
+	vcap_iter_skip_tg(itr);
+	vcap_iter_update(itr);
+}
+
+static void vcap_set_bit(u32 *stream, struct vcap_stream_iter *itr, bool value)
+{
+	u32 mask = BIT(itr->reg_bitpos);
+	u32 *p = &stream[itr->reg_idx];
+
+	if (value)
+		*p |= mask;
+	else
+		*p &= ~mask;
+}
+
+static void vcap_encode_bit(u32 *stream, struct vcap_stream_iter *itr, bool val)
+{
+	/* When intersected by a type group field, stream the type group bits
+	 * before continuing with the value bit
+	 */
+	while (itr->tg->width &&
+	       itr->offset >= itr->tg->offset &&
+	       itr->offset < itr->tg->offset + itr->tg->width) {
+		int tg_bitpos = itr->tg->offset - itr->offset;
+
+		vcap_set_bit(stream, itr, (itr->tg->value >> tg_bitpos) & 0x1);
+		itr->offset++;
+		vcap_iter_update(itr);
+	}
+	vcap_set_bit(stream, itr, val);
+}
+
+static void vcap_encode_field(u32 *stream, struct vcap_stream_iter *itr,
+			      int width, const u8 *value)
+{
+	int idx;
+
+	/* Loop over the field value bits and add the value bits one by one to
+	 * the output stream.
+	 */
+	for (idx = 0; idx < width; idx++) {
+		u8 bidx = idx & GENMASK(2, 0);
+
+		/* Encode one field value bit */
+		vcap_encode_bit(stream, itr, (value[idx / 8] >> bidx) & 0x1);
+		vcap_iter_next(itr);
+	}
+}
+
+static void vcap_encode_typegroups(u32 *stream, int sw_width,
+				   const struct vcap_typegroup *tg,
+				   bool mask)
+{
+	struct vcap_stream_iter iter;
+	int idx;
+
+	/* Mask bits must be set to zeros (inverted later when writing to the
+	 * mask cache register), so that the mask typegroup bits consist of
+	 * match-1 or match-0, or both
+	 */
+	vcap_iter_set(&iter, sw_width, tg, 0);
+	while (iter.tg->width) {
+		/* Set position to current typegroup bit */
+		iter.offset = iter.tg->offset;
+		vcap_iter_update(&iter);
+		for (idx = 0; idx < iter.tg->width; idx++) {
+			/* Iterate over current typegroup bits. Mask typegroup
+			 * bits are always set
+			 */
+			if (mask)
+				vcap_set_bit(stream, &iter, 0x1);
+			else
+				vcap_set_bit(stream, &iter,
+					     (iter.tg->value >> idx) & 0x1);
+			iter.offset++;
+			vcap_iter_update(&iter);
+		}
+		iter.tg++; /* next typegroup */
+	}
+}
+
 /* Return the list of keyfields for the keyset */
 static const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
 					       enum vcap_type vt,
@@ -61,6 +194,158 @@ static const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
 	return kset;
 }
 
+/* Return the typegroup table for the matching keyset (using subword size) */
+static const struct vcap_typegroup *
+vcap_keyfield_typegroup(struct vcap_control *vctrl,
+			enum vcap_type vt, enum vcap_keyfield_set keyset)
+{
+	const struct vcap_set *kset = vcap_keyfieldset(vctrl, vt, keyset);
+
+	/* Check that the keyset is valid */
+	if (!kset)
+		return NULL;
+	return vctrl->vcaps[vt].keyfield_set_typegroups[kset->sw_per_item];
+}
+
+/* Return the number of keyfields in the keyset */
+static int vcap_keyfield_count(struct vcap_control *vctrl,
+			       enum vcap_type vt, enum vcap_keyfield_set keyset)
+{
+	/* Check that the keyset exists in the vcap keyset list */
+	if (keyset >= vctrl->vcaps[vt].keyfield_set_size)
+		return 0;
+	return vctrl->vcaps[vt].keyfield_set_map_size[keyset];
+}
+
+static void vcap_encode_keyfield(struct vcap_rule_internal *ri,
+				 const struct vcap_client_keyfield *kf,
+				 const struct vcap_field *rf,
+				 const struct vcap_typegroup *tgt)
+{
+	int sw_width = ri->vctrl->vcaps[ri->admin->vtype].sw_width;
+	struct vcap_cache_data *cache = &ri->admin->cache;
+	struct vcap_stream_iter iter;
+	const u8 *value, *mask;
+
+	/* Encode the fields for the key and the mask in their respective
+	 * streams, respecting the subword width.
+	 */
+	switch (kf->ctrl.type) {
+	case VCAP_FIELD_BIT:
+		value = &kf->data.u1.value;
+		mask = &kf->data.u1.mask;
+		break;
+	case VCAP_FIELD_U32:
+		value = (const u8 *)&kf->data.u32.value;
+		mask = (const u8 *)&kf->data.u32.mask;
+		break;
+	case VCAP_FIELD_U48:
+		value = kf->data.u48.value;
+		mask = kf->data.u48.mask;
+		break;
+	case VCAP_FIELD_U56:
+		value = kf->data.u56.value;
+		mask = kf->data.u56.mask;
+		break;
+	case VCAP_FIELD_U64:
+		value = kf->data.u64.value;
+		mask = kf->data.u64.mask;
+		break;
+	case VCAP_FIELD_U72:
+		value = kf->data.u72.value;
+		mask = kf->data.u72.mask;
+		break;
+	case VCAP_FIELD_U112:
+		value = kf->data.u112.value;
+		mask = kf->data.u112.mask;
+		break;
+	case VCAP_FIELD_U128:
+		value = kf->data.u128.value;
+		mask = kf->data.u128.mask;
+		break;
+	}
+	vcap_iter_init(&iter, sw_width, tgt, rf->offset);
+	vcap_encode_field(cache->keystream, &iter, rf->width, value);
+	vcap_iter_init(&iter, sw_width, tgt, rf->offset);
+	vcap_encode_field(cache->maskstream, &iter, rf->width, mask);
+}
+
+static void vcap_encode_keyfield_typegroups(struct vcap_control *vctrl,
+					    struct vcap_rule_internal *ri,
+					    const struct vcap_typegroup *tgt)
+{
+	int sw_width = vctrl->vcaps[ri->admin->vtype].sw_width;
+	struct vcap_cache_data *cache = &ri->admin->cache;
+
+	/* Encode the typegroup bits for the key and the mask in their streams,
+	 * respecting the subword width.
+	 */
+	vcap_encode_typegroups(cache->keystream, sw_width, tgt, false);
+	vcap_encode_typegroups(cache->maskstream, sw_width, tgt, true);
+}
+
+static int vcap_encode_rule_keyset(struct vcap_rule_internal *ri)
+{
+	const struct vcap_client_keyfield *ckf;
+	const struct vcap_typegroup *tg_table;
+	const struct vcap_field *kf_table;
+	int keyset_size;
+
+	/* Get a valid set of fields for the specific keyset */
+	kf_table = vcap_keyfields(ri->vctrl, ri->admin->vtype, ri->data.keyset);
+	if (!kf_table) {
+		pr_err("%s:%d: no fields available for this keyset: %d\n",
+		       __func__, __LINE__, ri->data.keyset);
+		return -EINVAL;
+	}
+	/* Get a valid typegroup for the specific keyset */
+	tg_table = vcap_keyfield_typegroup(ri->vctrl, ri->admin->vtype,
+					   ri->data.keyset);
+	if (!tg_table) {
+		pr_err("%s:%d: no typegroups available for this keyset: %d\n",
+		       __func__, __LINE__, ri->data.keyset);
+		return -EINVAL;
+	}
+	/* Get a valid size for the specific keyset */
+	keyset_size = vcap_keyfield_count(ri->vctrl, ri->admin->vtype,
+					  ri->data.keyset);
+	if (keyset_size == 0) {
+		pr_err("%s:%d: zero field count for this keyset: %d\n",
+		       __func__, __LINE__, ri->data.keyset);
+		return -EINVAL;
+	}
+	/* Iterate over the keyfields (key, mask) in the rule
+	 * and encode these bits
+	 */
+	if (list_empty(&ri->data.keyfields)) {
+		pr_err("%s:%d: no keyfields in the rule\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+	list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list) {
+		/* Check that the client entry exists in the keyset */
+		if (ckf->ctrl.key >= keyset_size) {
+			pr_err("%s:%d: key %d is not in vcap\n",
+			       __func__, __LINE__, ckf->ctrl.key);
+			return -EINVAL;
+		}
+		vcap_encode_keyfield(ri, ckf, &kf_table[ckf->ctrl.key], tg_table);
+	}
+	/* Add typegroup bits to the key/mask bitstreams */
+	vcap_encode_keyfield_typegroups(ri->vctrl, ri, tg_table);
+	return 0;
+}
+
+/* Return the list of actionfields for the actionset */
+static const struct vcap_field *
+vcap_actionfields(struct vcap_control *vctrl,
+		  enum vcap_type vt, enum vcap_actionfield_set actionset)
+{
+	/* Check that the actionset exists in the vcap actionset list */
+	if (actionset >= vctrl->vcaps[vt].actionfield_set_size)
+		return NULL;
+	return vctrl->vcaps[vt].actionfield_set_map[actionset];
+}
+
 static const struct vcap_set *
 vcap_actionfieldset(struct vcap_control *vctrl,
 		    enum vcap_type vt, enum vcap_actionfield_set actionset)
@@ -76,9 +361,146 @@ vcap_actionfieldset(struct vcap_control *vctrl,
 	return aset;
 }
 
+/* Return the typegroup table for the matching actionset (using subword size) */
+static const struct vcap_typegroup *
+vcap_actionfield_typegroup(struct vcap_control *vctrl,
+			   enum vcap_type vt, enum vcap_actionfield_set actionset)
+{
+	const struct vcap_set *aset = vcap_actionfieldset(vctrl, vt, actionset);
+
+	/* Check that the actionset is valid */
+	if (!aset)
+		return NULL;
+	return vctrl->vcaps[vt].actionfield_set_typegroups[aset->sw_per_item];
+}
+
+/* Return the number of actionfields in the actionset */
+static int vcap_actionfield_count(struct vcap_control *vctrl,
+				  enum vcap_type vt,
+				  enum vcap_actionfield_set actionset)
+{
+	/* Check that the actionset exists in the vcap actionset list */
+	if (actionset >= vctrl->vcaps[vt].actionfield_set_size)
+		return 0;
+	return vctrl->vcaps[vt].actionfield_set_map_size[actionset];
+}
+
+static void vcap_encode_actionfield(struct vcap_rule_internal *ri,
+				    const struct vcap_client_actionfield *af,
+				    const struct vcap_field *rf,
+				    const struct vcap_typegroup *tgt)
+{
+	int act_width = ri->vctrl->vcaps[ri->admin->vtype].act_width;
+
+	struct vcap_cache_data *cache = &ri->admin->cache;
+	struct vcap_stream_iter iter;
+	const u8 *value;
+
+	/* Encode the action field in the stream, respecting the subword width */
+	switch (af->ctrl.type) {
+	case VCAP_FIELD_BIT:
+		value = &af->data.u1.value;
+		break;
+	case VCAP_FIELD_U32:
+		value = (const u8 *)&af->data.u32.value;
+		break;
+	case VCAP_FIELD_U48:
+		value = af->data.u48.value;
+		break;
+	case VCAP_FIELD_U56:
+		value = af->data.u56.value;
+		break;
+	case VCAP_FIELD_U64:
+		value = af->data.u64.value;
+		break;
+	case VCAP_FIELD_U72:
+		value = af->data.u72.value;
+		break;
+	case VCAP_FIELD_U112:
+		value = af->data.u112.value;
+		break;
+	case VCAP_FIELD_U128:
+		value = af->data.u128.value;
+		break;
+	}
+	vcap_iter_init(&iter, act_width, tgt, rf->offset);
+	vcap_encode_field(cache->actionstream, &iter, rf->width, value);
+}
+
+static void vcap_encode_actionfield_typegroups(struct vcap_rule_internal *ri,
+					       const struct vcap_typegroup *tgt)
+{
+	int sw_width = ri->vctrl->vcaps[ri->admin->vtype].act_width;
+	struct vcap_cache_data *cache = &ri->admin->cache;
+
+	/* Encode the typegroup bits for the actionstream respecting the subword
+	 * width.
+	 */
+	vcap_encode_typegroups(cache->actionstream, sw_width, tgt, false);
+}
+
+static int vcap_encode_rule_actionset(struct vcap_rule_internal *ri)
+{
+	const struct vcap_client_actionfield *caf;
+	const struct vcap_typegroup *tg_table;
+	const struct vcap_field *af_table;
+	int actionset_size;
+
+	/* Get a valid set of actionset fields for the specific actionset */
+	af_table = vcap_actionfields(ri->vctrl, ri->admin->vtype,
+				     ri->data.actionset);
+	if (!af_table) {
+		pr_err("%s:%d: no fields available for this actionset: %d\n",
+		       __func__, __LINE__, ri->data.actionset);
+		return -EINVAL;
+	}
+	/* Get a valid typegroup for the specific actionset */
+	tg_table = vcap_actionfield_typegroup(ri->vctrl, ri->admin->vtype,
+					      ri->data.actionset);
+	if (!tg_table) {
+		pr_err("%s:%d: no typegroups available for this actionset: %d\n",
+		       __func__, __LINE__, ri->data.actionset);
+		return -EINVAL;
+	}
+	/* Get a valid actionset size for the specific actionset */
+	actionset_size = vcap_actionfield_count(ri->vctrl, ri->admin->vtype,
+						ri->data.actionset);
+	if (actionset_size == 0) {
+		pr_err("%s:%d: zero field count for this actionset: %d\n",
+		       __func__, __LINE__, ri->data.actionset);
+		return -EINVAL;
+	}
+	/* Iterate over the actionfields in the rule
+	 * and encode these bits
+	 */
+	if (list_empty(&ri->data.actionfields))
+		pr_warn("%s:%d: no actionfields in the rule\n",
+			__func__, __LINE__);
+	list_for_each_entry(caf, &ri->data.actionfields, ctrl.list) {
+		/* Check that the client action exists in the actionset */
+		if (caf->ctrl.action >= actionset_size) {
+			pr_err("%s:%d: action %d is not in vcap\n",
+			       __func__, __LINE__, caf->ctrl.action);
+			return -EINVAL;
+		}
+		vcap_encode_actionfield(ri, caf, &af_table[caf->ctrl.action],
+					tg_table);
+	}
+	/* Add typegroup bits to the entry bitstreams */
+	vcap_encode_actionfield_typegroups(ri, tg_table);
+	return 0;
+}
+
 static int vcap_encode_rule(struct vcap_rule_internal *ri)
 {
-	/* Encoding of keyset and actionsets will be added later */
+	int err;
+
+	err = vcap_encode_rule_keyset(ri);
+	if (err)
+		return err;
+	err = vcap_encode_rule_actionset(ri);
+	if (err)
+		return err;
 	return 0;
 }
 
-- 
2.38.1

