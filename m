Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA80663CA98
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 22:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbiK2VqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 16:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236480AbiK2VqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 16:46:18 -0500
X-Greylist: delayed 486 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 13:46:14 PST
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0F32B26E;
        Tue, 29 Nov 2022 13:46:14 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 9A255504F77;
        Wed, 30 Nov 2022 00:33:44 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 9A255504F77
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1669757628; bh=rl2oD8De2g6JuveaqQb0mOi0dI1h/XlPYWrM4DF4e0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHq+uKwpNNUye6WWt+8jkX4KUAaft98LXNaL+mXgEgXaI6g72Xf2fzHEPm0gW8SYU
         w4lPUvdxpGIK/MWhoIkENpa9JvlUlz5yrKQjCPAOW3fmilmKyM9m8vIUUwmLZtqLcU
         bVt562Zll3HSmNT26FVGFImfT4UMaVF85XY/XHIg=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org,
        Michal Michalik <michal.michalik@intel.com>
Subject: [RFC PATCH v4 1/4] dpll: add dpll_attr/dpll_pin_attr helper classes
Date:   Wed, 30 Nov 2022 00:37:21 +0300
Message-Id: <20221129213724.10119-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221129213724.10119-1-vfedorenko@novek.ru>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Classes designed for easy exchange of dpll configuration values
between dpll_netlink, dpll_core and drivers implementing dpll
subsystem.

``dpll_attr`` is designed to store/pass/validate attributes related to
dpll device. ``dpll_pin_attr`` designed for same reason but for
dpll_pin object related values.

All possible attributes for dpll objects are stored in hermetic class
with access only with API functions.

Each attribute is validated on corresponding set function.
If value was not set before, the call to get attribute value either
returns error or unspecified value, depending on the attribute.
The one might also check validaity of any attribute.

Co-developed-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 drivers/dpll/dpll_attr.c     | 278 +++++++++++++++++++++
 drivers/dpll/dpll_pin_attr.c | 456 +++++++++++++++++++++++++++++++++++
 include/linux/dpll_attr.h    | 433 +++++++++++++++++++++++++++++++++
 3 files changed, 1167 insertions(+)
 create mode 100644 drivers/dpll/dpll_attr.c
 create mode 100644 drivers/dpll/dpll_pin_attr.c
 create mode 100644 include/linux/dpll_attr.h

diff --git a/drivers/dpll/dpll_attr.c b/drivers/dpll/dpll_attr.c
new file mode 100644
index 000000000000..9cf957978ff5
--- /dev/null
+++ b/drivers/dpll/dpll_attr.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  dpll_attr.c - dpll attributes handling helper class.
+ *
+ *  Copyright (c) 2022, Intel Corporation.
+ */
+
+#include <linux/dpll.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+
+struct dpll_attr {
+	unsigned long valid_mask;
+	enum dpll_lock_status lock_status;
+	s32 temp;
+	u32 source_pin_idx;
+	enum dpll_mode mode;
+	unsigned long mode_supported_mask;
+	unsigned int netifindex;
+};
+
+static const int MAX_BITS = BITS_PER_TYPE(unsigned long);
+
+struct dpll_attr *dpll_attr_alloc(void)
+{
+	return kzalloc(sizeof(struct dpll_attr), GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(dpll_attr_alloc);
+
+void dpll_attr_free(struct dpll_attr *attr)
+{
+	kfree(attr);
+}
+EXPORT_SYMBOL_GPL(dpll_attr_free);
+
+void dpll_attr_clear(struct dpll_attr *attr)
+{
+	memset(attr, 0, sizeof(*attr));
+}
+EXPORT_SYMBOL_GPL(dpll_attr_clear);
+
+bool dpll_attr_valid(enum dplla attr_id, const struct dpll_attr *attr)
+{
+	if (!attr)
+		return false;
+	if (attr_id > 0 && attr_id < BITS_PER_LONG)
+		return test_bit(attr_id, &attr->valid_mask);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_valid);
+
+int
+dpll_attr_copy(struct dpll_attr *dst, const struct dpll_attr *src)
+{
+	if (!src || !dst)
+		return -EFAULT;
+	memcpy(dst, src, sizeof(*dst));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_copy);
+
+static inline bool dpll_lock_status_valid(enum dpll_lock_status status)
+{
+	if (status >= DPLL_LOCK_STATUS_UNSPEC &&
+	    status <= DPLL_LOCK_STATUS_MAX)
+		return true;
+
+	return false;
+}
+
+int dpll_attr_lock_status_set(struct dpll_attr *attr,
+			      enum dpll_lock_status status)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_lock_status_valid(status))
+		return -EINVAL;
+
+	attr->lock_status = status;
+	set_bit(DPLLA_LOCK_STATUS, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_lock_status_set);
+
+enum dpll_lock_status dpll_attr_lock_status_get(const struct dpll_attr *attr)
+{
+	if (!dpll_attr_valid(DPLLA_LOCK_STATUS, attr))
+		return DPLL_LOCK_STATUS_UNSPEC;
+
+	return attr->lock_status;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_lock_status_get);
+
+int dpll_attr_temp_set(struct dpll_attr *attr, s32 temp)
+{
+	if (!attr)
+		return -EFAULT;
+
+	attr->temp = temp;
+	set_bit(DPLLA_TEMP, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_temp_set);
+
+int dpll_attr_temp_get(const struct dpll_attr *attr, s32 *temp)
+{
+	if (!attr || !temp)
+		return -EFAULT;
+	if (!dpll_attr_valid(DPLLA_TEMP, attr))
+		return -EINVAL;
+
+	*temp = attr->temp;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_temp_get);
+
+int dpll_attr_source_idx_set(struct dpll_attr *attr, u32 source_idx)
+{
+	if (!attr)
+		return -EFAULT;
+
+	attr->source_pin_idx = source_idx;
+	set_bit(DPLLA_SOURCE_PIN_IDX, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_source_idx_set);
+
+int dpll_attr_source_idx_get(const struct dpll_attr *attr, u32 *source_idx)
+{
+	if (!attr || !source_idx)
+		return -EFAULT;
+	if (!dpll_attr_valid(DPLLA_SOURCE_PIN_IDX, attr))
+		return -EINVAL;
+
+	*source_idx = attr->source_pin_idx;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_source_idx_get);
+
+static inline bool dpll_mode_valid(enum dpll_mode mode)
+{
+	if (mode >= DPLL_MODE_UNSPEC &&
+	    mode <= DPLL_MODE_MAX)
+		return true;
+
+	return false;
+}
+
+int dpll_attr_mode_set(struct dpll_attr *attr, enum dpll_mode mode)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_mode_valid(mode))
+		return -EINVAL;
+
+	attr->mode = mode;
+	set_bit(DPLLA_MODE, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_mode_set);
+
+enum dpll_mode dpll_attr_mode_get(const struct dpll_attr *attr)
+{
+	if (!attr || !dpll_attr_valid(DPLLA_MODE, attr))
+		return DPLL_MODE_UNSPEC;
+
+	return attr->mode;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_mode_get);
+
+int dpll_attr_mode_supported_set(struct dpll_attr *attr, enum dpll_mode mode)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_mode_valid(mode))
+		return -EINVAL;
+
+	set_bit(mode, &attr->mode_supported_mask);
+	set_bit(DPLLA_MODE_SUPPORTED, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_mode_supported_set);
+
+bool dpll_attr_mode_supported(const struct dpll_attr *attr,
+			      enum dpll_mode mode)
+{
+	if (!dpll_mode_valid(mode))
+		return false;
+	if (!dpll_attr_valid(DPLLA_MODE_SUPPORTED, attr))
+		return false;
+
+	return test_bit(mode, &attr->mode_supported_mask);
+}
+EXPORT_SYMBOL_GPL(dpll_attr_mode_supported);
+
+int dpll_attr_netifindex_set(struct dpll_attr *attr, unsigned int netifindex)
+{
+	if (!attr)
+		return -EFAULT;
+
+	attr->netifindex = netifindex;
+	set_bit(DPLLA_NETIFINDEX, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_netifindex_set);
+
+int dpll_attr_netifindex_get(const struct dpll_attr *attr,
+			     unsigned int *netifindex)
+{
+	if (!dpll_attr_valid(DPLLA_NETIFINDEX, attr))
+		return -EINVAL;
+
+	*netifindex = attr->netifindex;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_netifindex_get);
+
+static bool dpll_attr_changed(const enum dplla attr_id,
+			      struct dpll_attr *new,
+			      struct dpll_attr *old)
+{
+	if (dpll_attr_valid(attr_id, new)) {
+		if (dpll_attr_valid(attr_id, old)) {
+			switch (attr_id) {
+			case DPLLA_MODE:
+				if (new->mode != old->mode)
+					return true;
+				break;
+			case DPLLA_SOURCE_PIN_IDX:
+				if (new->source_pin_idx != old->source_pin_idx)
+					return true;
+				break;
+			default:
+				return false;
+			}
+		} else {
+			return true;
+		}
+	}
+
+	return false;
+}
+
+int dpll_attr_delta(struct dpll_attr *delta, struct dpll_attr *new,
+		    struct dpll_attr *old)
+{
+	int ret = -EINVAL;
+
+	if (!delta || !new || !old)
+		return -EFAULT;
+
+	dpll_attr_clear(delta);
+
+	if (dpll_attr_changed(DPLLA_MODE, new, old)) {
+		ret = dpll_attr_mode_set(delta, new->mode);
+		if (ret)
+			return ret;
+	}
+	if (dpll_attr_changed(DPLLA_SOURCE_PIN_IDX, new, old)) {
+		ret = dpll_attr_source_idx_set(delta, new->source_pin_idx);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_attr_delta);
diff --git a/drivers/dpll/dpll_pin_attr.c b/drivers/dpll/dpll_pin_attr.c
new file mode 100644
index 000000000000..bf57476228af
--- /dev/null
+++ b/drivers/dpll/dpll_pin_attr.c
@@ -0,0 +1,456 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  dpll_pin_attr.c - Pin attribute handling helper class.
+ *
+ *  Copyright (c) 2022, Intel Corporation.
+ */
+
+#include <linux/dpll.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+
+struct dpll_pin_attr {
+	unsigned long valid_mask;
+	enum dpll_pin_type type;
+	unsigned long types_supported_mask;
+	enum dpll_pin_signal_type signal_type;
+	unsigned long signal_types_supported_mask;
+	u32 custom_freq;
+	unsigned long state_mask;
+	unsigned long state_supported_mask;
+	u32 prio;
+	unsigned int netifindex;
+};
+
+static const int MAX_BITS = BITS_PER_TYPE(unsigned long);
+
+struct dpll_pin_attr *dpll_pin_attr_alloc(void)
+{
+	return kzalloc(sizeof(struct dpll_pin_attr), GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_alloc);
+
+void dpll_pin_attr_free(struct dpll_pin_attr *attr)
+{
+	kfree(attr);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_free);
+
+void dpll_pin_attr_clear(struct dpll_pin_attr *attr)
+{
+	memset(attr, 0, sizeof(*attr));
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_clear);
+
+bool dpll_pin_attr_valid(enum dplla attr_id, const struct dpll_pin_attr *attr)
+{
+	if (!attr)
+		return false;
+	if (attr_id > 0 && attr_id < BITS_PER_LONG)
+		return test_bit(attr_id, &attr->valid_mask);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_valid);
+
+int
+dpll_pin_attr_copy(struct dpll_pin_attr *dst, const struct dpll_pin_attr *src)
+{
+	if (!src || !dst)
+		return -EFAULT;
+	memcpy(dst, src, sizeof(*dst));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_copy);
+
+static inline bool dpll_pin_type_valid(enum dpll_pin_type type)
+{
+	if (type >= DPLL_PIN_TYPE_UNSPEC && type <= DPLL_PIN_TYPE_MAX)
+		return true;
+
+	return false;
+}
+
+int dpll_pin_attr_type_set(struct dpll_pin_attr *attr, enum dpll_pin_type type)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_pin_type_valid(type))
+		return -EINVAL;
+
+	attr->type = type;
+	set_bit(DPLLA_PIN_TYPE, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_type_set);
+
+enum dpll_pin_type dpll_pin_attr_type_get(const struct dpll_pin_attr *attr)
+{
+	if (!dpll_pin_attr_valid(DPLLA_PIN_TYPE, attr))
+		return DPLL_PIN_TYPE_UNSPEC;
+
+	return attr->type;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_type_get);
+
+int dpll_pin_attr_type_supported_set(struct dpll_pin_attr *attr,
+				     enum dpll_pin_type type)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_pin_type_valid(type))
+		return -EINVAL;
+
+	set_bit(type, &attr->types_supported_mask);
+	set_bit(DPLLA_PIN_TYPE_SUPPORTED, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_type_supported_set);
+
+bool dpll_pin_attr_type_supported(const struct dpll_pin_attr *attr,
+				     enum dpll_pin_type type)
+{
+	if (!dpll_pin_type_valid(type))
+		return false;
+	if (!dpll_pin_attr_valid(DPLLA_PIN_TYPE_SUPPORTED, attr))
+		return false;
+
+	return test_bit(type, &attr->types_supported_mask);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_type_supported);
+
+static inline bool dpll_pin_signal_type_valid(enum dpll_pin_signal_type type)
+{
+	if (type >= DPLL_PIN_SIGNAL_TYPE_UNSPEC &&
+	    type <= DPLL_PIN_SIGNAL_TYPE_MAX)
+		return true;
+
+	return false;
+}
+
+int dpll_pin_attr_signal_type_set(struct dpll_pin_attr *attr,
+				  enum dpll_pin_signal_type type)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_pin_signal_type_valid(type))
+		return -EINVAL;
+
+	attr->signal_type = type;
+	set_bit(DPLLA_PIN_SIGNAL_TYPE, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_signal_type_set);
+
+enum dpll_pin_signal_type
+dpll_pin_attr_signal_type_get(const struct dpll_pin_attr *attr)
+{
+	if (!dpll_pin_attr_valid(DPLLA_PIN_SIGNAL_TYPE, attr))
+		return DPLL_PIN_SIGNAL_TYPE_UNSPEC;
+
+	return attr->signal_type;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_signal_type_get);
+
+int dpll_pin_attr_signal_type_supported_set(struct dpll_pin_attr *attr,
+					    enum dpll_pin_signal_type type)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_pin_signal_type_valid(type))
+		return -EINVAL;
+
+	set_bit(type, &attr->signal_types_supported_mask);
+	set_bit(DPLLA_PIN_SIGNAL_TYPE_SUPPORTED, &attr->valid_mask);
+
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_signal_type_supported_set);
+
+bool dpll_pin_attr_signal_type_supported(const struct dpll_pin_attr *attr,
+					    enum dpll_pin_signal_type type)
+{
+	if (!dpll_pin_signal_type_valid(type))
+		return false;
+	if (!dpll_pin_attr_valid(DPLLA_PIN_SIGNAL_TYPE_SUPPORTED, attr))
+		return false;
+
+	return test_bit(type, &attr->signal_types_supported_mask);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_signal_type_supported);
+
+int dpll_pin_attr_custom_freq_set(struct dpll_pin_attr *attr, u32 freq)
+{
+	if (!attr)
+		return -EFAULT;
+
+	attr->custom_freq = freq;
+	set_bit(DPLLA_PIN_CUSTOM_FREQ, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_custom_freq_set);
+
+int dpll_pin_attr_custom_freq_get(const struct dpll_pin_attr *attr, u32 *freq)
+{
+	if (!attr || !freq)
+		return -EFAULT;
+	if (!test_bit(DPLLA_PIN_CUSTOM_FREQ, &attr->valid_mask))
+		return -EINVAL;
+
+	*freq = attr->custom_freq;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_custom_freq_get);
+
+static inline bool dpll_pin_state_valid(enum dpll_pin_state state)
+{
+	if (state >= DPLL_PIN_STATE_UNSPEC &&
+	    state <= DPLL_PIN_STATE_MAX)
+		return true;
+
+	return false;
+}
+
+int dpll_pin_attr_state_set(struct dpll_pin_attr *attr,
+			    enum dpll_pin_state state)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_pin_state_valid(state))
+		return -EINVAL;
+	if (state == DPLL_PIN_STATE_CONNECTED) {
+		if (test_bit(DPLL_PIN_STATE_DISCONNECTED, &attr->state_mask))
+			return -EINVAL;
+	} else if (state == DPLL_PIN_STATE_DISCONNECTED) {
+		if (test_bit(DPLL_PIN_STATE_CONNECTED, &attr->state_mask))
+			return -EINVAL;
+	}
+
+	set_bit(state, &attr->state_mask);
+	set_bit(DPLLA_PIN_STATE, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_state_set);
+
+bool dpll_pin_attr_state_enabled(const struct dpll_pin_attr *attr,
+				 enum dpll_pin_state state)
+{
+	if (!dpll_pin_state_valid(state))
+		return false;
+	if (!dpll_pin_attr_valid(DPLLA_PIN_STATE, attr))
+		return false;
+
+	return test_bit(state, &attr->state_mask);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_state_enabled);
+
+int dpll_pin_attr_state_supported_set(struct dpll_pin_attr *attr,
+				      enum dpll_pin_state state)
+{
+	if (!attr)
+		return -EFAULT;
+	if (!dpll_pin_state_valid(state))
+		return -EINVAL;
+
+	set_bit(state, &attr->state_supported_mask);
+	set_bit(DPLLA_PIN_STATE_SUPPORTED, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_state_supported_set);
+
+bool dpll_pin_attr_state_supported(const struct dpll_pin_attr *attr,
+				   enum dpll_pin_state state)
+{
+	if (!dpll_pin_state_valid(state))
+		return false;
+	if (!dpll_pin_attr_valid(DPLLA_PIN_STATE_SUPPORTED, attr))
+		return false;
+
+	return test_bit(state, &attr->state_supported_mask);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_state_supported);
+
+int dpll_pin_attr_prio_set(struct dpll_pin_attr *attr, u32 prio)
+{
+	if (!attr)
+		return -EFAULT;
+	if (prio > PIN_PRIO_LOWEST)
+		return -EINVAL;
+
+	attr->prio = prio;
+	set_bit(DPLLA_PIN_PRIO, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_prio_set);
+
+int dpll_pin_attr_prio_get(const struct dpll_pin_attr *attr, u32 *prio)
+{
+	if (!attr || !prio)
+		return -EFAULT;
+	if (!dpll_pin_attr_valid(DPLLA_PIN_PRIO, attr))
+		return -EINVAL;
+
+	*prio = attr->prio;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_prio_get);
+
+int dpll_pin_attr_netifindex_set(struct dpll_pin_attr *attr, unsigned int netifindex)
+{
+	if (!attr)
+		return -EFAULT;
+
+	attr->netifindex = netifindex;
+	set_bit(DPLLA_PIN_NETIFINDEX, &attr->valid_mask);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_netifindex_set);
+
+int dpll_pin_attr_netifindex_get(const struct dpll_pin_attr *attr,
+				 unsigned int *netifindex)
+{
+	if (!dpll_pin_attr_valid(DPLLA_PIN_NETIFINDEX, attr))
+		return -EINVAL;
+
+	*netifindex = attr->netifindex;
+	return true;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_netifindex_get);
+
+static bool dpll_pin_attr_changed(const enum dplla attr_id,
+				  struct dpll_pin_attr *new,
+				  struct dpll_pin_attr *old)
+{
+	if (dpll_pin_attr_valid(attr_id, new)) {
+		if (dpll_pin_attr_valid(attr_id, old)) {
+			switch (attr_id) {
+			case DPLLA_PIN_TYPE:
+				if (new->type != old->type)
+					return true;
+				break;
+			case DPLLA_PIN_SIGNAL_TYPE:
+				if (new->signal_type != old->signal_type)
+					return true;
+				break;
+			case DPLLA_PIN_CUSTOM_FREQ:
+				if (new->custom_freq != old->custom_freq)
+					return true;
+				break;
+			case DPLLA_PIN_STATE:
+				if (new->state_mask != old->state_mask)
+					return true;
+				break;
+			case DPLLA_PIN_PRIO:
+				if (new->prio != old->prio)
+					return true;
+				break;
+			default:
+				return false;
+			}
+		} else {
+			return true;
+		}
+	}
+
+	return false;
+}
+
+int dpll_pin_attr_delta(struct dpll_pin_attr *delta, struct dpll_pin_attr *new,
+			struct dpll_pin_attr *old)
+{
+	int ret = -EINVAL;
+
+	if (!delta || !new || !old)
+		return -EFAULT;
+
+	dpll_pin_attr_clear(delta);
+
+	if (dpll_pin_attr_changed(DPLLA_PIN_TYPE, new, old)) {
+		ret = dpll_pin_attr_type_set(delta, new->type);
+		if (ret)
+			return ret;
+	}
+	if (dpll_pin_attr_changed(DPLLA_PIN_SIGNAL_TYPE, new, old)) {
+		ret = dpll_pin_attr_signal_type_set(delta, new->signal_type);
+		if (ret)
+			return ret;
+	}
+	if (dpll_pin_attr_changed(DPLLA_PIN_CUSTOM_FREQ, new, old)) {
+		ret = dpll_pin_attr_custom_freq_set(delta, new->custom_freq);
+		if (ret)
+			return ret;
+	}
+	if (dpll_pin_attr_changed(DPLLA_PIN_STATE, new, old)) {
+		enum dpll_pin_state i;
+
+		for (i = DPLL_PIN_STATE_UNSPEC + 1;
+		     i <= DPLL_PIN_STATE_MAX; i++)
+			if (test_bit(i, &new->state_mask)) {
+				ret = dpll_pin_attr_state_set(delta, i);
+				if (ret)
+					return ret;
+			}
+	}
+	if (dpll_pin_attr_changed(DPLLA_PIN_PRIO, new, old)) {
+		ret = dpll_pin_attr_prio_set(delta, new->prio);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_delta);
+
+int dpll_pin_attr_prep_common(struct dpll_pin_attr *common,
+			      const struct dpll_pin_attr *reference)
+{
+	if (!common || !reference)
+		return -EFAULT;
+	dpll_pin_attr_clear(common);
+	if (dpll_pin_attr_valid(DPLLA_PIN_TYPE, reference)) {
+		common->type = reference->type;
+		set_bit(DPLLA_PIN_TYPE, &common->valid_mask);
+	}
+	if (dpll_pin_attr_valid(DPLLA_PIN_SIGNAL_TYPE, reference)) {
+		common->signal_type = reference->signal_type;
+		set_bit(DPLLA_PIN_SIGNAL_TYPE, &common->valid_mask);
+	}
+	if (dpll_pin_attr_valid(DPLLA_PIN_CUSTOM_FREQ, reference)) {
+		common->custom_freq = reference->custom_freq;
+		set_bit(DPLLA_PIN_CUSTOM_FREQ, &common->valid_mask);
+	}
+	if (dpll_pin_attr_valid(DPLLA_PIN_STATE, reference)) {
+		common->state_mask = reference->state_mask;
+		set_bit(DPLLA_PIN_STATE, &common->valid_mask);
+	}
+	return common->valid_mask ? PIN_ATTR_CHANGE : 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_prep_common);
+
+
+int dpll_pin_attr_prep_exclusive(struct dpll_pin_attr *exclusive,
+				 const struct dpll_pin_attr *reference)
+{
+	if (!exclusive || !reference)
+		return -EFAULT;
+	dpll_pin_attr_clear(exclusive);
+	if (dpll_pin_attr_valid(DPLLA_PIN_PRIO, reference)) {
+		exclusive->prio = reference->prio;
+		set_bit(DPLLA_PIN_PRIO, &exclusive->valid_mask);
+	}
+	return exclusive->valid_mask ? PIN_ATTR_CHANGE : 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_attr_prep_exclusive);
+
diff --git a/include/linux/dpll_attr.h b/include/linux/dpll_attr.h
new file mode 100644
index 000000000000..fe5e2188ca0b
--- /dev/null
+++ b/include/linux/dpll_attr.h
@@ -0,0 +1,433 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  dpll_attr.h - Header for attribute handling helper class.
+ *
+ *  Copyright (c) 2022, Intel Corporation.
+ */
+
+#ifndef __DPLL_ATTR_H__
+#define __DPLL_ATTR_H__
+
+#include <linux/types.h>
+
+struct dpll_attr;
+struct dpll_pin_attr;
+
+#define PIN_PRIO_HIGHEST	0
+#define PIN_PRIO_LOWEST		0xff
+#define PIN_ATTR_CHANGE		1
+
+/**
+ * dpll_attr_alloc - allocate a dpll attributes struct
+ *
+ * Return: pointer if succeeded, NULL otherwise.
+ */
+struct dpll_attr *dpll_attr_alloc(void);
+
+/**
+ * dpll_attr_free - frees a dpll attributes struct
+ * @attr: structure with dpll attributes
+ */
+void dpll_attr_free(struct dpll_attr *attr);
+
+/**
+ * dpll_attr_clear - clears a dpll attributes struct
+ * @attr: structure with dpll attributes
+ */
+void dpll_attr_clear(struct dpll_attr *attr);
+
+/**
+ * dpll_attr_valid - checks if a attribute is valid
+ * @attr_id: attribute to be checked
+ * @attr: structure with dpll attributes
+ *
+ * Checks if the attribute has been set before and if stored value is valid.
+ * Return: true if valid, false otherwise.
+ */
+bool dpll_attr_valid(enum dplla attr_id, const struct dpll_attr *attr);
+
+/**
+ * dpll_attr_copy - create a copy of the dpll attributes structure
+ * @dst: destination structure with dpll attributes
+ * @src: source structure with dpll attributes
+ *
+ * Memory needs to be allocated before calling this function.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int
+dpll_attr_copy(struct dpll_attr *dst, const struct dpll_attr *src);
+
+/**
+ * dpll_attr_lock_status_set - set the lock status in the attributes
+ * @attr: structure with dpll attributes
+ * @status: dpll lock status to be set
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_lock_status_set(struct dpll_attr *attr,
+			      enum dpll_lock_status status);
+
+/**
+ * dpll_attr_lock_status_get - get the lock status from the attributes
+ * @attr: structure with dpll attributes
+ *
+ * Return: dpll lock status
+ */
+enum dpll_lock_status
+dpll_attr_lock_status_get(const struct dpll_attr *attr);
+
+/**
+ * dpll_attr_temp_set - set the temperature in the attributes
+ * @attr: structure with dpll attributes
+ * @temp: temperature to be set
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_temp_set(struct dpll_attr *attr, s32 temp);
+
+/**
+ * dpll_attr_temp_get - get the temperature from the attributes
+ * @attr: structure with dpll attributes
+ * @temp: temperature (out)
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_temp_get(const struct dpll_attr *attr, s32 *temp);
+
+/**
+ * dpll_attr_source_idx_set - set the source id in the attributes
+ * @attr: structure with dpll attributes
+ * @source_idx: source id to be set
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_source_idx_set(struct dpll_attr *attr, u32 source_idx);
+
+/**
+ * dpll_attr_source_idx_get - get the source id from the attributes
+ * @attr: structure with dpll attributes
+ * @source_idx: source id (out)
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_source_idx_get(const struct dpll_attr *attr, u32 *source_idx);
+
+/**
+ * dpll_attr_mode_set - set the dpll mode in the attributes
+ * @attr: structure with dpll attributes
+ * @mode: dpll mode to be set
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_mode_set(struct dpll_attr *attr, enum dpll_mode mode);
+
+/**
+ * dpll_attr_mode_get - get the dpll mode from the attributes
+ * @attr: structure with dpll attributes
+ *
+ * Return: dpll mode.
+ */
+enum dpll_mode dpll_attr_mode_get(const struct dpll_attr *attr);
+
+/**
+ * dpll_attr_mode_set - set the dpll supported mode in the attributes
+ * @attr: structure with dpll attributes
+ * @mode: dpll mode to be set in supported modes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_mode_supported_set(struct dpll_attr *attr, enum dpll_mode mode);
+
+/**
+ * dpll_attr_mode_supported - check if the dpll mode is supported
+ * @attr: structure with dpll attributes
+ * @mode: dpll mode to be checked
+ *
+ * Return: true if mode supported, false otherwise.
+ */
+bool dpll_attr_mode_supported(const struct dpll_attr *attr,
+			      enum dpll_mode mode);
+
+/**
+ * dpll_attr_netifindex_set - set the netifindex in the attributes
+ * @attr: structure with dpll attributes
+ * @netifindex: parameter to be set in attributes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_netifindex_set(struct dpll_attr *attr, unsigned int netifindex);
+
+/**
+ * dpll_attr_netifindex_get - get the netifindex from the attributes
+ * @attr: structure with dpll attributes
+ * @netifindex: retrieved parameter
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_netifindex_get(const struct dpll_attr *attr,
+			     unsigned int *netifindex);
+
+/**
+ * dpll_attr_delta - calculate the difference between two dpll attribute sets
+ * @delta: structure with delta of dpll attributes
+ * @new: structure with new dpll attributes
+ * @old: structure with old dpll attributes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_attr_delta(struct dpll_attr *delta, struct dpll_attr *new,
+		    struct dpll_attr *old);
+
+/**
+ * dpll_pin_attr_alloc - allocate a dpll pin attributes struct
+ *
+ * Return: pointer if succeeded, NULL otherwise.
+ */
+struct dpll_pin_attr *dpll_pin_attr_alloc(void);
+
+/**
+ * dpll_pin_attr_free - frees a dpll pin attributes struct
+ * @attr: structure with dpll pin attributes
+ */
+void dpll_pin_attr_free(struct dpll_pin_attr *attr);
+
+/**
+ * dpll_pin_attr_clear - clears a dpll pin attributes struct
+ * @attr: structure with dpll attributes
+ */
+void dpll_pin_attr_clear(struct dpll_pin_attr *attr);
+
+/**
+ * dpll_pin_attr_valid - checks if a pin attribute is valid
+ * @attr_id: attribute to be checked
+ * @attr: structure with dpll pin attributes
+ *
+ * Checks if the attribute has been set before and if stored value is valid.
+ * Return: true if valid, false otherwise.
+ */
+bool dpll_pin_attr_valid(enum dplla attr_id, const struct dpll_pin_attr *attr);
+
+/**
+ * dpll_pin_attr_copy - create a copy of the dpll pin attributes structure
+ * @dst: destination structure with dpll pin attributes
+ * @src: source structure with dpll pin attributes
+ *
+ * Memory needs to be allocated before calling this function.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int
+dpll_pin_attr_copy(struct dpll_pin_attr *dst, const struct dpll_pin_attr *src);
+
+/**
+ * dpll_pin_attr_type_set - set the pin type in the attributes
+ * @attr: structure with dpll pin attributes
+ * @type: parameter to be set in attributes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_type_set(struct dpll_pin_attr *attr, enum dpll_pin_type type);
+
+/**
+ * dpll_pin_attr_type_get - get the pin type from the attributes
+ * @attr: structure with dpll pin attributes
+ *
+ * Return: dpll pin type.
+ */
+enum dpll_pin_type dpll_pin_attr_type_get(const struct dpll_pin_attr *attr);
+
+/**
+ * dpll_pin_attr_type_supported_set - set the dpll pin supported type in the
+ * attributes
+ * @attr: structure with dpll attributes
+ * @type: pin type to be set in supported modes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_type_supported_set(struct dpll_pin_attr *attr,
+				     enum dpll_pin_type type);
+
+/**
+ * dpll_pin_attr_type_supported - check if the pin type is supported
+ * @attr: structure with dpll attributes
+ * @type: dpll mode to be checked
+ *
+ * Return: true if type supported, false otherwise.
+ */
+bool dpll_pin_attr_type_supported(const struct dpll_pin_attr *attr,
+				     enum dpll_pin_type type);
+
+/**
+ * dpll_pin_attr_signal_type_set - set the pin signal type in the attributes
+ * @attr: structure with dpll attributes
+ * @type: pin signal type to be set in supported modes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_signal_type_set(struct dpll_pin_attr *attr,
+				  enum dpll_pin_signal_type type);
+
+/**
+ * dpll_pin_attr_signal_type_get - get the pin signal type from the attributes
+ * @attr: structure with dpll pin attributes
+ *
+ * Return: pin signal type.
+ */
+enum dpll_pin_signal_type
+dpll_pin_attr_signal_type_get(const struct dpll_pin_attr *attr);
+
+/**
+ * dpll_pin_attr_signal_type_supported_set - set the dpll pin supported signal
+ * type in the attributes
+ * @attr: structure with dpll attributes
+ * @type: pin signal type to be set in supported types
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_signal_type_supported_set(struct dpll_pin_attr *attr,
+					    enum dpll_pin_signal_type type);
+
+/**
+ * dpll_pin_attr_signal_type_supported - check if the pin signal type is
+ * supported
+ * @attr: structure with dpll attributes
+ * @type: pin signal type to be checked
+ *
+ * Return: true if type supported, false otherwise.
+ */
+bool dpll_pin_attr_signal_type_supported(const struct dpll_pin_attr *attr,
+					    enum dpll_pin_signal_type type);
+
+/**
+ * dpll_pin_attr_custom_freq_set - set the custom frequency in the attributes
+ * @attr: structure with dpll pin attributes
+ * @freq: parameter to be set in attributes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_custom_freq_set(struct dpll_pin_attr *attr, u32 freq);
+
+/**
+ * dpll_pin_attr_custom_freq_get - get the pin type from the attributes
+ * @attr: structure with dpll pin attributes
+ * @freq: parameter to be retrieved
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_custom_freq_get(const struct dpll_pin_attr *attr, u32 *freq);
+
+/**
+ * dpll_pin_attr_state_set - set the pin state the attributes
+ * @attr: structure with dpll pin attributes
+ * @state: parameter to be set in attributes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_state_set(struct dpll_pin_attr *attr,
+			    enum dpll_pin_state state);
+
+/**
+ * dpll_pin_attr_state_enabled - check if state is enabled
+ * @attr: structure with dpll pin attributes
+ * @state: parameter to be checked in attributes
+ *
+ * Return: true if enabled, false otherwise.
+ */
+bool dpll_pin_attr_state_enabled(const struct dpll_pin_attr *attr,
+				 enum dpll_pin_state state);
+
+/**
+ * dpll_pin_attr_state_supported_set - set the supported pin state in the
+ * attributes
+ * @attr: structure with dpll attributes
+ * @state: pin state to be set in supported types
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_state_supported_set(struct dpll_pin_attr *attr,
+				      enum dpll_pin_state state);
+
+/**
+ * dpll_pin_attr_state_supported - check if the pin state is supported
+ * @attr: structure with dpll attributes
+ * @state: pin signal type to be checked
+ *
+ * Return: true if state supported, false otherwise.
+ */
+bool dpll_pin_attr_state_supported(const struct dpll_pin_attr *attr,
+				   enum dpll_pin_state state);
+
+/**
+ * dpll_pin_attr_prio_set - set the pin priority in the attributes
+ * @attr: structure with dpll pin attributes
+ * @prio: parameter to be set in attributes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_prio_set(struct dpll_pin_attr *attr, u32 prio);
+
+/**
+ * dpll_pin_attr_prio_get - get the pin priority from the attributes
+ * @attr: structure with dpll pin attributes
+ * @prio: parameter to be retrieved
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_prio_get(const struct dpll_pin_attr *attr, u32 *prio);
+
+/**
+ * dpll_pin_attr_netifindex_set - set the pin netifindex in the attributes
+ * @attr: structure with dpll pin attributes
+ * @netifindex: parameter to be set in attributes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_netifindex_set(struct dpll_pin_attr *attr,
+				 unsigned int netifindex);
+
+/**
+ * dpll_pin_attr_netifindex_get - get the pin netifindex from the attributes
+ * @attr: structure with dpll pin attributes
+ * @netifindex: parameter to be retrieved
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_netifindex_get(const struct dpll_pin_attr *attr,
+				 unsigned int *netifindex);
+
+/**
+ * dpll_attr_delta - calculate the difference between two dpll pin attribute sets
+ * @delta: structure with delta of dpll pin attributes
+ * @new: structure with new dpll pin attributes
+ * @old: structure with old dpll pin attributes
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_delta(struct dpll_pin_attr *delta, struct dpll_pin_attr *new,
+			struct dpll_pin_attr *old);
+
+/**
+ * dpll_pin_attr_prep_common - calculate the common dpll pin attributes
+ * @common: structure with common dpll pin attributes
+ * @reference: referenced structure with dpll pin attributes
+ *
+ * Some of the pin attributes applies to all DPLLs and other are exclusive.
+ * This function calculates if any of the common pin attributes are set.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_prep_common(struct dpll_pin_attr *common,
+			      const struct dpll_pin_attr *reference);
+
+/**
+ * dpll_pin_attr_prep_exclusive - calculate the exclusive dpll pin attributes
+ * @exclusive: structure with common dpll pin attributes
+ * @reference: referenced structure with dpll pin attributes
+ *
+ * Some of the pin attributes applies to all DPLLs and other are exclusive.
+ * This function calculates if any of the exclusive pin attributes are set.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_attr_prep_exclusive(struct dpll_pin_attr *exclusive,
+				 const struct dpll_pin_attr *reference);
+
+
+#endif /* __DPLL_ATTR_H__ */
-- 
2.27.0

