Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0C96C970B
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjCZRBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjCZRBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:01:00 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA4C55B5
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:00:58 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ek18so26611390edb.6
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679850057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKvFgxFIOMcDomywgSDCrBRk0DXR5IUKz0LkYeOJtEs=;
        b=MqBkz9hDpJOSQidWrDvkJ50SCXAxGgp4KQaQ8as68UNv7r+sVy0Myx3RJ+JxS0ZWFy
         d8khfP7wEFyCx6DgShheqjpj9LRa9Q13baKFmGHjR4zUweb3OGaOGDkCAcQh6HNr+wX/
         RPb14hkVRBOBwu+T950blOnTIkRPr5iA/Rp7TW2pM6Cmpju9g45PBpixLZRILCqB7/r2
         uKDtc5sdPNJGCdk8qpxLT5V8RruB8MmKQ5kKvQvVa6fceDFUeV5+eedTl1YvmjlwZp3z
         Lgw7EVZx7lmKtKDBcBmWpLEPaOHh4ny5qzSs8YMxkUXgOdXQ7aLV2O1IYaTMWTvilQ9i
         cVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jKvFgxFIOMcDomywgSDCrBRk0DXR5IUKz0LkYeOJtEs=;
        b=ek2ScDQ4Zz1dLORUsfDNTIe1Ncl+5SpVlDxFJBhvUpNxWyi4lZeI/4BW7oHGB37cZd
         LdDGej2SufmvbDXxXnSNdftysD+btnB+xGi9f7pryvplGwP3/0AZa6HTFh+PSCw62TzI
         4Cf21tUUuPe11lZwztnp3b0qRZcPg5sXcGa2rEEjQFmVxUhA4Q2JVabuxbnv3ElISY2Q
         bgwPe3ztbBqSJjQnGm1rLiRNevbu/rk8VTYpVaFGGDAKRxwHYHtP5Lj+Ok9QpV7GTEsU
         vqHTRAjmVY5FaWE8gDtl+kJoDjnkoMOIVnHHGkfqesbo2kwGO4LIc3vPNrqO/xX6Kl5X
         wkJw==
X-Gm-Message-State: AAQBX9cFFgMknV0VZh9KlsUtDM2tLKLVoB9saYS4/kGw3dG5+klJXx7P
        Xz3oBK1D8RlPwlOulR1vF404xkitJkIRY8uvdRQ=
X-Google-Smtp-Source: AKy350ZMSZEbVP7WntRh5N3QsB8+wW7gLpCzIK+IPhpkhbpXX0IYxYElgvFFPYGnqMCfRuH4dytvuw==
X-Received: by 2002:a17:906:5fd9:b0:930:d17b:959b with SMTP id k25-20020a1709065fd900b00930d17b959bmr10024477ejv.22.1679850056882;
        Sun, 26 Mar 2023 10:00:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w17-20020a170906b19100b0093fa8c2e877sm1996762ejy.80.2023.03.26.10.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:00:56 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org, arkadiusz.kubalewski@intel.com,
        vadim.fedorenko@linux.dev, vadfed@meta.com
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, pabeni@redhat.com,
        poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [patch dpll-rfc 2/7] dpll: allow to call device register multiple times
Date:   Sun, 26 Mar 2023 19:00:47 +0200
Message-Id: <20230326170052.2065791-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230326170052.2065791-1-jiri@resnulli.us>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230326170052.2065791-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Some devices allow to control a single dpll instance over multiple
channels. In case of mlx5 for example, one dpll could be controlled over
multiple PFs that reside on a single ASIC. These are equal. Allow each
to register/unregister dpll device. Use the first ops and priv always
as the is no difference in between those and the rest.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/dpll/dpll_core.c                  | 85 +++++++++++++++++++++--
 drivers/dpll/dpll_core.h                  | 11 ++-
 drivers/dpll/dpll_netlink.c               | 29 ++++----
 drivers/net/ethernet/intel/ice/ice_dpll.c |  4 +-
 drivers/ptp/ptp_ocp.c                     |  2 +-
 include/linux/dpll.h                      |  5 +-
 6 files changed, 113 insertions(+), 23 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 7f8442b73fd8..6e50216a636a 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -293,6 +293,7 @@ dpll_device_alloc(const u64 clock_id, u32 dev_driver_id,
 	if (!dpll)
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&dpll->refcount, 1);
+	INIT_LIST_HEAD(&dpll->registration_list);
 	dpll->dev.class = &dpll_class;
 	dpll->dev_driver_id = dev_driver_id;
 	dpll->clock_id = clock_id;
@@ -366,12 +367,26 @@ void dpll_device_put(struct dpll_device *dpll)
 		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
 		xa_destroy(&dpll->pin_refs);
 		xa_erase(&dpll_device_xa, dpll->id);
+		WARN_ON(!list_empty(&dpll->registration_list));
 		kfree(dpll);
 	}
 	mutex_unlock(&dpll_device_xa_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_device_put);
 
+static struct dpll_device_registration *
+dpll_device_registration_find(struct dpll_device *dpll,
+			      const struct dpll_device_ops *ops, void *priv)
+{
+	struct dpll_device_registration *reg;
+
+	list_for_each_entry(reg, &dpll->registration_list, list) {
+		if (reg->ops == ops && reg->priv == priv)
+			return reg;
+	}
+	return NULL;
+}
+
 /**
  * dpll_device_register - register the dpll device in the subsystem
  * @dpll: pointer to a dpll
@@ -389,19 +404,39 @@ int dpll_device_register(struct dpll_device *dpll,
 			 const struct dpll_device_ops *ops, void *priv,
 			 struct device *owner)
 {
+	struct dpll_device_registration *reg;
+	bool first_registration = false;
+
 	if (WARN_ON(!ops || !owner))
 		return -EINVAL;
+
 	mutex_lock(&dpll_device_xa_lock);
-	if (ASSERT_DPLL_NOT_REGISTERED(dpll)) {
+	reg = dpll_device_registration_find(dpll, ops, priv);
+	if (reg) {
 		mutex_unlock(&dpll_device_xa_lock);
 		return -EEXIST;
 	}
+
+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
+	if (!reg) {
+		mutex_unlock(&dpll_device_xa_lock);
+		return -ENOMEM;
+	}
+	reg->ops = ops;
+	reg->priv = priv;
+
 	dpll->dev.bus = owner->bus;
 	dpll->parent = owner;
-	dpll->ops = ops;
 	dev_set_name(&dpll->dev, "%s_%d", dev_name(owner),
 		     dpll->dev_driver_id);
-	dpll->priv = priv;
+
+	first_registration = list_empty(&dpll->registration_list);
+	list_add_tail(&reg->list, &dpll->registration_list);
+	if (!first_registration) {
+		mutex_unlock(&dpll_device_xa_lock);
+		return 0;
+	}
+
 	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
 	mutex_unlock(&dpll_device_xa_lock);
 	dpll_notify_device_create(dpll);
@@ -413,14 +448,32 @@ EXPORT_SYMBOL_GPL(dpll_device_register);
 /**
  * dpll_device_unregister - deregister dpll device
  * @dpll: registered dpll pointer
+ * @ops: ops for a dpll device
+ * @priv: pointer to private information of owner
  *
  * Deregister device, make it unavailable for userspace.
  * Note: It does not free the memory
  */
-void dpll_device_unregister(struct dpll_device *dpll)
+void dpll_device_unregister(struct dpll_device *dpll,
+			    const struct dpll_device_ops *ops, void *priv)
 {
+	struct dpll_device_registration *reg;
+
 	mutex_lock(&dpll_device_xa_lock);
 	ASSERT_DPLL_REGISTERED(dpll);
+
+	reg = dpll_device_registration_find(dpll, ops, priv);
+	if (WARN_ON(!reg)) {
+		mutex_unlock(&dpll_device_xa_lock);
+		return;
+	}
+	list_del(&reg->list);
+	kfree(reg);
+
+	if (!list_empty(&dpll->registration_list)) {
+		mutex_unlock(&dpll_device_xa_lock);
+		return;
+	}
 	xa_clear_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
 	mutex_unlock(&dpll_device_xa_lock);
 	dpll_notify_device_delete(dpll);
@@ -760,6 +813,17 @@ struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, u32 idx)
 	return NULL;
 }
 
+static struct dpll_device_registration *
+dpll_device_registration_first(struct dpll_device *dpll)
+{
+	struct dpll_device_registration *reg;
+
+	reg = list_first_entry_or_null((struct list_head *) &dpll->registration_list,
+				       struct dpll_device_registration, list);
+	WARN_ON(!reg);
+	return reg;
+}
+
 /**
  * dpll_priv - get the dpll device private owner data
  * @dpll:	registered dpll pointer
@@ -768,10 +832,21 @@ struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, u32 idx)
  */
 void *dpll_priv(const struct dpll_device *dpll)
 {
-	return dpll->priv;
+	struct dpll_device_registration *reg;
+
+	reg = dpll_device_registration_first((struct dpll_device *) dpll);
+	return reg->priv;
 }
 EXPORT_SYMBOL_GPL(dpll_priv);
 
+const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll)
+{
+	struct dpll_device_registration *reg;
+
+	reg = dpll_device_registration_first(dpll);
+	return reg->ops;
+}
+
 /**
  * dpll_pin_on_dpll_priv - get the dpll device private owner data
  * @dpll:	registered dpll pointer
diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
index 876b6ac6f3a0..21ba31621b44 100644
--- a/drivers/dpll/dpll_core.h
+++ b/drivers/dpll/dpll_core.h
@@ -7,11 +7,18 @@
 #define __DPLL_CORE_H__
 
 #include <linux/dpll.h>
+#include <linux/list.h>
 #include <linux/refcount.h>
 #include "dpll_netlink.h"
 
 #define DPLL_REGISTERED		XA_MARK_1
 
+struct dpll_device_registration {
+	struct list_head list;
+	const struct dpll_device_ops *ops;
+	void *priv;
+};
+
 /**
  * struct dpll_device - structure for a DPLL device
  * @id:			unique id number for each device
@@ -34,9 +41,8 @@ struct dpll_device {
 	struct device dev;
 	struct device *parent;
 	struct module *module;
-	struct dpll_device_ops *ops;
 	enum dpll_type type;
-	void *priv;
+	struct list_head registration_list;
 	struct xarray pin_refs;
 	u64 clock_id;
 	unsigned long mode_supported_mask;
@@ -84,6 +90,7 @@ struct dpll_pin_ref {
 	refcount_t refcount;
 };
 
+const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll);
 struct dpll_device *dpll_device_get_by_id(int id);
 struct dpll_device *dpll_device_get_by_name(const char *bus_name,
 					    const char *dev_name);
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index d2c699015215..430c009d0a71 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -18,7 +18,7 @@ static u32 dpll_pin_freq_value[] = {
 };
 
 static int
-dpll_msg_add_dev_handle(struct sk_buff *msg, const struct dpll_device *dpll)
+dpll_msg_add_dev_handle(struct sk_buff *msg, struct dpll_device *dpll)
 {
 	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
 		return -EMSGSIZE;
@@ -31,14 +31,15 @@ dpll_msg_add_dev_handle(struct sk_buff *msg, const struct dpll_device *dpll)
 }
 
 static int
-dpll_msg_add_mode(struct sk_buff *msg, const struct dpll_device *dpll,
+dpll_msg_add_mode(struct sk_buff *msg, struct dpll_device *dpll,
 		  struct netlink_ext_ack *extack)
 {
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
 	enum dpll_mode mode;
 
-	if (WARN_ON(!dpll->ops->mode_get))
+	if (WARN_ON(!ops->mode_get))
 		return -EOPNOTSUPP;
-	if (dpll->ops->mode_get(dpll, &mode, extack))
+	if (ops->mode_get(dpll, &mode, extack))
 		return -EFAULT;
 	if (nla_put_u8(msg, DPLL_A_MODE, mode))
 		return -EMSGSIZE;
@@ -50,11 +51,12 @@ static int
 dpll_msg_add_source_pin_idx(struct sk_buff *msg, struct dpll_device *dpll,
 			    struct netlink_ext_ack *extack)
 {
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
 	u32 source_pin_idx;
 
-	if (!dpll->ops->source_pin_idx_get)
+	if (!ops->source_pin_idx_get)
 		return 0;
-	if (dpll->ops->source_pin_idx_get(dpll, &source_pin_idx, extack))
+	if (ops->source_pin_idx_get(dpll, &source_pin_idx, extack))
 		return -EFAULT;
 	if (nla_put_u32(msg, DPLL_A_SOURCE_PIN_IDX, source_pin_idx))
 		return -EMSGSIZE;
@@ -66,11 +68,12 @@ static int
 dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_device *dpll,
 			 struct netlink_ext_ack *extack)
 {
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
 	enum dpll_lock_status status;
 
-	if (WARN_ON(!dpll->ops->lock_status_get))
+	if (WARN_ON(!ops->lock_status_get))
 		return -EOPNOTSUPP;
-	if (dpll->ops->lock_status_get(dpll, &status, extack))
+	if (ops->lock_status_get(dpll, &status, extack))
 		return -EFAULT;
 	if (nla_put_u8(msg, DPLL_A_LOCK_STATUS, status))
 		return -EMSGSIZE;
@@ -82,11 +85,12 @@ static int
 dpll_msg_add_temp(struct sk_buff *msg, struct dpll_device *dpll,
 		  struct netlink_ext_ack *extack)
 {
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
 	s32 temp;
 
-	if (!dpll->ops->temp_get)
+	if (!ops->temp_get)
 		return -EOPNOTSUPP;
-	if (dpll->ops->temp_get(dpll, &temp, extack))
+	if (ops->temp_get(dpll, &temp, extack))
 		return -EFAULT;
 	if (nla_put_s32(msg, DPLL_A_TEMP, temp))
 		return -EMSGSIZE;
@@ -686,6 +690,7 @@ int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 static int
 dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
 {
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
 	struct nlattr *attr;
 	enum dpll_mode mode;
 	int rem, ret = 0;
@@ -696,9 +701,9 @@ dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
 		case DPLL_A_MODE:
 			mode = nla_get_u8(attr);
 
-			if (!dpll->ops || !dpll->ops->mode_set)
+			if (!ops->mode_set)
 				return -EOPNOTSUPP;
-			ret = dpll->ops->mode_set(dpll, mode, info->extack);
+			ret = ops->mode_set(dpll, mode, info->extack);
 			if (ret)
 				return ret;
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 87572ecc21e4..532ad7314f49 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -1551,7 +1551,7 @@ static void ice_dpll_release_all(struct ice_pf *pf, bool cgu)
 	if (dp->dpll) {
 		mutex_lock(&pf->dplls.lock);
 		if (cgu)
-			dpll_device_unregister(dp->dpll);
+			dpll_device_unregister(dp->dpll, &ice_dpll_ops, pf);
 		dpll_device_put(dp->dpll);
 		mutex_unlock(&pf->dplls.lock);
 		dev_dbg(ice_pf_to_dev(pf), "PPS dpll removed\n");
@@ -1560,7 +1560,7 @@ static void ice_dpll_release_all(struct ice_pf *pf, bool cgu)
 	if (de->dpll) {
 		mutex_lock(&pf->dplls.lock);
 		if (cgu)
-			dpll_device_unregister(de->dpll);
+			dpll_device_unregister(de->dpll, &ice_dpll_ops, pf);
 		dpll_device_put(de->dpll);
 		mutex_unlock(&pf->dplls.lock);
 		dev_dbg(ice_pf_to_dev(pf), "EEC dpll removed\n");
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index cc840d0e3265..5e7fceae2a6a 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4431,7 +4431,7 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(bp);
 
-	dpll_device_unregister(bp->dpll);
+	dpll_device_unregister(bp->dpll, &dpll_ops, bp);
 	dpll_device_put(bp->dpll);
 	devlink_unregister(devlink);
 	ptp_ocp_detach(bp);
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 496358df83a9..09863d66a44c 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -130,11 +130,14 @@ int dpll_device_register(struct dpll_device *dpll,
 /**
  * dpll_device_unregister - deregister registered dpll
  * @dpll: pointer to dpll
+ * @ops: ops for a dpll device
+ * @priv: pointer to private information of owner
  *
  * Unregister the dpll from the subsystem, make it unavailable for netlink
  * API users.
  */
-void dpll_device_unregister(struct dpll_device *dpll);
+void dpll_device_unregister(struct dpll_device *dpll,
+			    const struct dpll_device_ops *ops, void *priv);
 
 /**
  * dpll_priv - get dpll private data
-- 
2.39.0

