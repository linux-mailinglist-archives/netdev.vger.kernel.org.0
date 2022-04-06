Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C935E4F5C5C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiDFLiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiDFLge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871F630F9EE;
        Wed,  6 Apr 2022 01:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F0C60C54;
        Wed,  6 Apr 2022 08:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17A5C385B9;
        Wed,  6 Apr 2022 08:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233585;
        bh=+bDXqNV2UF2eXw1j1MXzMDZjPZtFy+Iw3iF9fgsGHiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVxnShPJ/ptHG3a8MpEGL8LVkOkFfWJ4nrnGuPB1AzZGnB/wAZKI3IQv0GzP+xyPo
         qVBk4cezX0Hu9+taA1qvGzAJ7RZj1tecTTfLTsgdoWnYLi5/s9ZPhhzY5Q4l+pIary
         XSVa3wOUBxX/k+NCI4SSWn4BTkJag9gbWLt75JkofbKMSCrb4VMYTcq/lFIz/4ixD6
         E2aOnc4sklzGGwbqILAfPwKGaVcFAhBnljjRfd2YnQE/wbcDMh1BYI5h3qjYnOkvTK
         DlwnXFUF+Vsa42e1U2jDZFm+d4x0Bn+bE75tIGhWwhxDKCPNUFnUhEqmKmChpMtQUr
         WHwo/cTiTyXlA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 08/17] RDMA/core: Delete IPsec flow action logic from the core
Date:   Wed,  6 Apr 2022 11:25:43 +0300
Message-Id: <a638e376314a2eb1c66f597c0bbeeab2e5de7faf.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The removal of mlx5 flow steering logic, left the kernel without any RDMA
drivers that implements flow action callbacks supplied by RDMA/core. Any
user access to them caused to EOPNOTSUPP error, which can be achieved by
simply removing ioctl implementation.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/device.c              |   2 -
 .../core/uverbs_std_types_flow_action.c       | 383 +-----------------
 include/rdma/ib_verbs.h                       |   8 -
 3 files changed, 1 insertion(+), 392 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a311df07b1bd..4deb60a3b43f 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2613,7 +2613,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, create_counters);
 	SET_DEVICE_OP(dev_ops, create_cq);
 	SET_DEVICE_OP(dev_ops, create_flow);
-	SET_DEVICE_OP(dev_ops, create_flow_action_esp);
 	SET_DEVICE_OP(dev_ops, create_qp);
 	SET_DEVICE_OP(dev_ops, create_rwq_ind_table);
 	SET_DEVICE_OP(dev_ops, create_srq);
@@ -2676,7 +2675,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, modify_ah);
 	SET_DEVICE_OP(dev_ops, modify_cq);
 	SET_DEVICE_OP(dev_ops, modify_device);
-	SET_DEVICE_OP(dev_ops, modify_flow_action_esp);
 	SET_DEVICE_OP(dev_ops, modify_hw_stat);
 	SET_DEVICE_OP(dev_ops, modify_port);
 	SET_DEVICE_OP(dev_ops, modify_qp);
diff --git a/drivers/infiniband/core/uverbs_std_types_flow_action.c b/drivers/infiniband/core/uverbs_std_types_flow_action.c
index d42ed7ff223e..0ddcf6da66c4 100644
--- a/drivers/infiniband/core/uverbs_std_types_flow_action.c
+++ b/drivers/infiniband/core/uverbs_std_types_flow_action.c
@@ -46,385 +46,6 @@ static int uverbs_free_flow_action(struct ib_uobject *uobject,
 	return action->device->ops.destroy_flow_action(action);
 }
 
-static u64 esp_flags_uverbs_to_verbs(struct uverbs_attr_bundle *attrs,
-				     u32 flags, bool is_modify)
-{
-	u64 verbs_flags = flags;
-
-	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_ESN))
-		verbs_flags |= IB_FLOW_ACTION_ESP_FLAGS_ESN_TRIGGERED;
-
-	if (is_modify && uverbs_attr_is_valid(attrs,
-					      UVERBS_ATTR_FLOW_ACTION_ESP_ATTRS))
-		verbs_flags |= IB_FLOW_ACTION_ESP_FLAGS_MOD_ESP_ATTRS;
-
-	return verbs_flags;
-};
-
-static int validate_flow_action_esp_keymat_aes_gcm(struct ib_flow_action_attrs_esp_keymats *keymat)
-{
-	struct ib_uverbs_flow_action_esp_keymat_aes_gcm *aes_gcm =
-		&keymat->keymat.aes_gcm;
-
-	if (aes_gcm->iv_algo > IB_UVERBS_FLOW_ACTION_IV_ALGO_SEQ)
-		return -EOPNOTSUPP;
-
-	if (aes_gcm->key_len != 32 &&
-	    aes_gcm->key_len != 24 &&
-	    aes_gcm->key_len != 16)
-		return -EINVAL;
-
-	if (aes_gcm->icv_len != 16 &&
-	    aes_gcm->icv_len != 8 &&
-	    aes_gcm->icv_len != 12)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int (* const flow_action_esp_keymat_validate[])(struct ib_flow_action_attrs_esp_keymats *keymat) = {
-	[IB_UVERBS_FLOW_ACTION_ESP_KEYMAT_AES_GCM] = validate_flow_action_esp_keymat_aes_gcm,
-};
-
-static int flow_action_esp_replay_none(struct ib_flow_action_attrs_esp_replays *replay,
-				       bool is_modify)
-{
-	/* This is used in order to modify an esp flow action with an enabled
-	 * replay protection to a disabled one. This is only supported via
-	 * modify, as in create verb we can simply drop the REPLAY attribute and
-	 * achieve the same thing.
-	 */
-	return is_modify ? 0 : -EINVAL;
-}
-
-static int flow_action_esp_replay_def_ok(struct ib_flow_action_attrs_esp_replays *replay,
-					 bool is_modify)
-{
-	/* Some replay protections could always be enabled without validating
-	 * anything.
-	 */
-	return 0;
-}
-
-static int (* const flow_action_esp_replay_validate[])(struct ib_flow_action_attrs_esp_replays *replay,
-						       bool is_modify) = {
-	[IB_UVERBS_FLOW_ACTION_ESP_REPLAY_NONE] = flow_action_esp_replay_none,
-	[IB_UVERBS_FLOW_ACTION_ESP_REPLAY_BMP] = flow_action_esp_replay_def_ok,
-};
-
-static int parse_esp_ip(enum ib_flow_spec_type proto,
-			const void __user *val_ptr,
-			size_t len, union ib_flow_spec *out)
-{
-	int ret;
-	const struct ib_uverbs_flow_ipv4_filter ipv4 = {
-		.src_ip = cpu_to_be32(0xffffffffUL),
-		.dst_ip = cpu_to_be32(0xffffffffUL),
-		.proto = 0xff,
-		.tos = 0xff,
-		.ttl = 0xff,
-		.flags = 0xff,
-	};
-	const struct ib_uverbs_flow_ipv6_filter ipv6 = {
-		.src_ip = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
-			   0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
-		.dst_ip = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
-			   0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
-		.flow_label = cpu_to_be32(0xffffffffUL),
-		.next_hdr = 0xff,
-		.traffic_class = 0xff,
-		.hop_limit = 0xff,
-	};
-	union {
-		struct ib_uverbs_flow_ipv4_filter ipv4;
-		struct ib_uverbs_flow_ipv6_filter ipv6;
-	} user_val = {};
-	const void *user_pmask;
-	size_t val_len;
-
-	/* If the flow IPv4/IPv6 flow specifications are extended, the mask
-	 * should be changed as well.
-	 */
-	BUILD_BUG_ON(offsetof(struct ib_uverbs_flow_ipv4_filter, flags) +
-		     sizeof(ipv4.flags) != sizeof(ipv4));
-	BUILD_BUG_ON(offsetof(struct ib_uverbs_flow_ipv6_filter, reserved) +
-		     sizeof(ipv6.reserved) != sizeof(ipv6));
-
-	switch (proto) {
-	case IB_FLOW_SPEC_IPV4:
-		if (len > sizeof(user_val.ipv4) &&
-		    !ib_is_buffer_cleared(val_ptr + sizeof(user_val.ipv4),
-					  len - sizeof(user_val.ipv4)))
-			return -EOPNOTSUPP;
-
-		val_len = min_t(size_t, len, sizeof(user_val.ipv4));
-		ret = copy_from_user(&user_val.ipv4, val_ptr,
-				     val_len);
-		if (ret)
-			return -EFAULT;
-
-		user_pmask = &ipv4;
-		break;
-	case IB_FLOW_SPEC_IPV6:
-		if (len > sizeof(user_val.ipv6) &&
-		    !ib_is_buffer_cleared(val_ptr + sizeof(user_val.ipv6),
-					  len - sizeof(user_val.ipv6)))
-			return -EOPNOTSUPP;
-
-		val_len = min_t(size_t, len, sizeof(user_val.ipv6));
-		ret = copy_from_user(&user_val.ipv6, val_ptr,
-				     val_len);
-		if (ret)
-			return -EFAULT;
-
-		user_pmask = &ipv6;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return ib_uverbs_kern_spec_to_ib_spec_filter(proto, user_pmask,
-						     &user_val,
-						     val_len, out);
-}
-
-static int flow_action_esp_get_encap(struct ib_flow_spec_list *out,
-				     struct uverbs_attr_bundle *attrs)
-{
-	struct ib_uverbs_flow_action_esp_encap uverbs_encap;
-	int ret;
-
-	ret = uverbs_copy_from(&uverbs_encap, attrs,
-			       UVERBS_ATTR_FLOW_ACTION_ESP_ENCAP);
-	if (ret)
-		return ret;
-
-	/* We currently support only one encap */
-	if (uverbs_encap.next_ptr)
-		return -EOPNOTSUPP;
-
-	if (uverbs_encap.type != IB_FLOW_SPEC_IPV4 &&
-	    uverbs_encap.type != IB_FLOW_SPEC_IPV6)
-		return -EOPNOTSUPP;
-
-	return parse_esp_ip(uverbs_encap.type,
-			    u64_to_user_ptr(uverbs_encap.val_ptr),
-			    uverbs_encap.len,
-			    &out->spec);
-}
-
-struct ib_flow_action_esp_attr {
-	struct	ib_flow_action_attrs_esp		hdr;
-	struct	ib_flow_action_attrs_esp_keymats	keymat;
-	struct	ib_flow_action_attrs_esp_replays	replay;
-	/* We currently support only one spec */
-	struct	ib_flow_spec_list			encap;
-};
-
-#define ESP_LAST_SUPPORTED_FLAG		IB_UVERBS_FLOW_ACTION_ESP_FLAGS_ESN_NEW_WINDOW
-static int parse_flow_action_esp(struct ib_device *ib_dev,
-				 struct uverbs_attr_bundle *attrs,
-				 struct ib_flow_action_esp_attr *esp_attr,
-				 bool is_modify)
-{
-	struct ib_uverbs_flow_action_esp uverbs_esp = {};
-	int ret;
-
-	/* Optional param, if it doesn't exist, we get -ENOENT and skip it */
-	ret = uverbs_copy_from(&esp_attr->hdr.esn, attrs,
-			       UVERBS_ATTR_FLOW_ACTION_ESP_ESN);
-	if (IS_UVERBS_COPY_ERR(ret))
-		return ret;
-
-	/* This can be called from FLOW_ACTION_ESP_MODIFY where
-	 * UVERBS_ATTR_FLOW_ACTION_ESP_ATTRS is optional
-	 */
-	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_ATTRS)) {
-		ret = uverbs_copy_from_or_zero(&uverbs_esp, attrs,
-					       UVERBS_ATTR_FLOW_ACTION_ESP_ATTRS);
-		if (ret)
-			return ret;
-
-		if (uverbs_esp.flags & ~((ESP_LAST_SUPPORTED_FLAG << 1) - 1))
-			return -EOPNOTSUPP;
-
-		esp_attr->hdr.spi = uverbs_esp.spi;
-		esp_attr->hdr.seq = uverbs_esp.seq;
-		esp_attr->hdr.tfc_pad = uverbs_esp.tfc_pad;
-		esp_attr->hdr.hard_limit_pkts = uverbs_esp.hard_limit_pkts;
-	}
-	esp_attr->hdr.flags = esp_flags_uverbs_to_verbs(attrs, uverbs_esp.flags,
-							is_modify);
-
-	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_KEYMAT)) {
-		esp_attr->keymat.protocol =
-			uverbs_attr_get_enum_id(attrs,
-						UVERBS_ATTR_FLOW_ACTION_ESP_KEYMAT);
-		ret = uverbs_copy_from_or_zero(&esp_attr->keymat.keymat,
-					       attrs,
-					       UVERBS_ATTR_FLOW_ACTION_ESP_KEYMAT);
-		if (ret)
-			return ret;
-
-		ret = flow_action_esp_keymat_validate[esp_attr->keymat.protocol](&esp_attr->keymat);
-		if (ret)
-			return ret;
-
-		esp_attr->hdr.keymat = &esp_attr->keymat;
-	}
-
-	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_REPLAY)) {
-		esp_attr->replay.protocol =
-			uverbs_attr_get_enum_id(attrs,
-						UVERBS_ATTR_FLOW_ACTION_ESP_REPLAY);
-
-		ret = uverbs_copy_from_or_zero(&esp_attr->replay.replay,
-					       attrs,
-					       UVERBS_ATTR_FLOW_ACTION_ESP_REPLAY);
-		if (ret)
-			return ret;
-
-		ret = flow_action_esp_replay_validate[esp_attr->replay.protocol](&esp_attr->replay,
-										 is_modify);
-		if (ret)
-			return ret;
-
-		esp_attr->hdr.replay = &esp_attr->replay;
-	}
-
-	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_ENCAP)) {
-		ret = flow_action_esp_get_encap(&esp_attr->encap, attrs);
-		if (ret)
-			return ret;
-
-		esp_attr->hdr.encap = &esp_attr->encap;
-	}
-
-	return 0;
-}
-
-static int UVERBS_HANDLER(UVERBS_METHOD_FLOW_ACTION_ESP_CREATE)(
-	struct uverbs_attr_bundle *attrs)
-{
-	struct ib_uobject *uobj = uverbs_attr_get_uobject(
-		attrs, UVERBS_ATTR_CREATE_FLOW_ACTION_ESP_HANDLE);
-	struct ib_device *ib_dev = attrs->context->device;
-	int				  ret;
-	struct ib_flow_action		  *action;
-	struct ib_flow_action_esp_attr	  esp_attr = {};
-
-	if (!ib_dev->ops.create_flow_action_esp)
-		return -EOPNOTSUPP;
-
-	ret = parse_flow_action_esp(ib_dev, attrs, &esp_attr, false);
-	if (ret)
-		return ret;
-
-	/* No need to check as this attribute is marked as MANDATORY */
-	action = ib_dev->ops.create_flow_action_esp(ib_dev, &esp_attr.hdr,
-						    attrs);
-	if (IS_ERR(action))
-		return PTR_ERR(action);
-
-	uverbs_flow_action_fill_action(action, uobj, ib_dev,
-				       IB_FLOW_ACTION_ESP);
-
-	return 0;
-}
-
-static int UVERBS_HANDLER(UVERBS_METHOD_FLOW_ACTION_ESP_MODIFY)(
-	struct uverbs_attr_bundle *attrs)
-{
-	struct ib_uobject *uobj = uverbs_attr_get_uobject(
-		attrs, UVERBS_ATTR_MODIFY_FLOW_ACTION_ESP_HANDLE);
-	struct ib_flow_action *action = uobj->object;
-	int				  ret;
-	struct ib_flow_action_esp_attr	  esp_attr = {};
-
-	if (!action->device->ops.modify_flow_action_esp)
-		return -EOPNOTSUPP;
-
-	ret = parse_flow_action_esp(action->device, attrs, &esp_attr, true);
-	if (ret)
-		return ret;
-
-	if (action->type != IB_FLOW_ACTION_ESP)
-		return -EINVAL;
-
-	return action->device->ops.modify_flow_action_esp(action,
-							  &esp_attr.hdr,
-							  attrs);
-}
-
-static const struct uverbs_attr_spec uverbs_flow_action_esp_keymat[] = {
-	[IB_UVERBS_FLOW_ACTION_ESP_KEYMAT_AES_GCM] = {
-		.type = UVERBS_ATTR_TYPE_PTR_IN,
-		UVERBS_ATTR_STRUCT(
-			struct ib_uverbs_flow_action_esp_keymat_aes_gcm,
-			aes_key),
-	},
-};
-
-static const struct uverbs_attr_spec uverbs_flow_action_esp_replay[] = {
-	[IB_UVERBS_FLOW_ACTION_ESP_REPLAY_NONE] = {
-		.type = UVERBS_ATTR_TYPE_PTR_IN,
-		UVERBS_ATTR_NO_DATA(),
-	},
-	[IB_UVERBS_FLOW_ACTION_ESP_REPLAY_BMP] = {
-		.type = UVERBS_ATTR_TYPE_PTR_IN,
-		UVERBS_ATTR_STRUCT(struct ib_uverbs_flow_action_esp_replay_bmp,
-				   size),
-	},
-};
-
-DECLARE_UVERBS_NAMED_METHOD(
-	UVERBS_METHOD_FLOW_ACTION_ESP_CREATE,
-	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_FLOW_ACTION_ESP_HANDLE,
-			UVERBS_OBJECT_FLOW_ACTION,
-			UVERBS_ACCESS_NEW,
-			UA_MANDATORY),
-	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_FLOW_ACTION_ESP_ATTRS,
-			   UVERBS_ATTR_STRUCT(struct ib_uverbs_flow_action_esp,
-					      hard_limit_pkts),
-			   UA_MANDATORY),
-	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_FLOW_ACTION_ESP_ESN,
-			   UVERBS_ATTR_TYPE(__u32),
-			   UA_OPTIONAL),
-	UVERBS_ATTR_ENUM_IN(UVERBS_ATTR_FLOW_ACTION_ESP_KEYMAT,
-			    uverbs_flow_action_esp_keymat,
-			    UA_MANDATORY),
-	UVERBS_ATTR_ENUM_IN(UVERBS_ATTR_FLOW_ACTION_ESP_REPLAY,
-			    uverbs_flow_action_esp_replay,
-			    UA_OPTIONAL),
-	UVERBS_ATTR_PTR_IN(
-		UVERBS_ATTR_FLOW_ACTION_ESP_ENCAP,
-		UVERBS_ATTR_TYPE(struct ib_uverbs_flow_action_esp_encap),
-		UA_OPTIONAL));
-
-DECLARE_UVERBS_NAMED_METHOD(
-	UVERBS_METHOD_FLOW_ACTION_ESP_MODIFY,
-	UVERBS_ATTR_IDR(UVERBS_ATTR_MODIFY_FLOW_ACTION_ESP_HANDLE,
-			UVERBS_OBJECT_FLOW_ACTION,
-			UVERBS_ACCESS_WRITE,
-			UA_MANDATORY),
-	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_FLOW_ACTION_ESP_ATTRS,
-			   UVERBS_ATTR_STRUCT(struct ib_uverbs_flow_action_esp,
-					      hard_limit_pkts),
-			   UA_OPTIONAL),
-	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_FLOW_ACTION_ESP_ESN,
-			   UVERBS_ATTR_TYPE(__u32),
-			   UA_OPTIONAL),
-	UVERBS_ATTR_ENUM_IN(UVERBS_ATTR_FLOW_ACTION_ESP_KEYMAT,
-			    uverbs_flow_action_esp_keymat,
-			    UA_OPTIONAL),
-	UVERBS_ATTR_ENUM_IN(UVERBS_ATTR_FLOW_ACTION_ESP_REPLAY,
-			    uverbs_flow_action_esp_replay,
-			    UA_OPTIONAL),
-	UVERBS_ATTR_PTR_IN(
-		UVERBS_ATTR_FLOW_ACTION_ESP_ENCAP,
-		UVERBS_ATTR_TYPE(struct ib_uverbs_flow_action_esp_encap),
-		UA_OPTIONAL));
-
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	UVERBS_METHOD_FLOW_ACTION_DESTROY,
 	UVERBS_ATTR_IDR(UVERBS_ATTR_DESTROY_FLOW_ACTION_HANDLE,
@@ -435,9 +56,7 @@ DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 DECLARE_UVERBS_NAMED_OBJECT(
 	UVERBS_OBJECT_FLOW_ACTION,
 	UVERBS_TYPE_ALLOC_IDR(uverbs_free_flow_action),
-	&UVERBS_METHOD(UVERBS_METHOD_FLOW_ACTION_ESP_CREATE),
-	&UVERBS_METHOD(UVERBS_METHOD_FLOW_ACTION_DESTROY),
-	&UVERBS_METHOD(UVERBS_METHOD_FLOW_ACTION_ESP_MODIFY));
+	&UVERBS_METHOD(UVERBS_METHOD_FLOW_ACTION_DESTROY));
 
 const struct uapi_definition uverbs_def_obj_flow_action[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ada4a5226dbd..f9b99c41965f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2529,15 +2529,7 @@ struct ib_device_ops {
 				       struct ib_flow_attr *flow_attr,
 				       struct ib_udata *udata);
 	int (*destroy_flow)(struct ib_flow *flow_id);
-	struct ib_flow_action *(*create_flow_action_esp)(
-		struct ib_device *device,
-		const struct ib_flow_action_attrs_esp *attr,
-		struct uverbs_attr_bundle *attrs);
 	int (*destroy_flow_action)(struct ib_flow_action *action);
-	int (*modify_flow_action_esp)(
-		struct ib_flow_action *action,
-		const struct ib_flow_action_attrs_esp *attr,
-		struct uverbs_attr_bundle *attrs);
 	int (*set_vf_link_state)(struct ib_device *device, int vf, u32 port,
 				 int state);
 	int (*get_vf_config)(struct ib_device *device, int vf, u32 port,
-- 
2.35.1

