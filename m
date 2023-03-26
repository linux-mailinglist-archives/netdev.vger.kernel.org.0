Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D226C970F
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjCZRBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjCZRBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:01:03 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB5D6582
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:01:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id ew6so26537106edb.7
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679850060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=668o2k4Nn1fxnXh54mywli34jSX4IoNNpKzsc6h/awQ=;
        b=Xoa5KgJ08Zo4I18MXAfK4jZv6x2ycI0dUMCvDutflAM4KBUxE1fPfGXfIEqLzv25KT
         uVNNeCBbbgvUtKd0OwA7tOBLajKVIqqXYm+3eDrFJbNTFrJApH37BAw+hFEQ0LvO9Af5
         YEqb8iqvDUKQwRlLpHvnmG73p7snY/uBkg6zpbF7kBtR8ihS22kqDZ4iCZArrB1kKJPR
         7+R7R4DsCFP5jb18h0TgEy6waXzgU3F+XtdLy+J21tTr/9ZPoXvoUUF5ZvPZRM0xPCMj
         40mr4sXgEDWxmpDBr0qJNnAJRSAU/fhI/Lys/hYhfg8hDuWANE6/yFyHBNdDffPvOsSY
         dzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=668o2k4Nn1fxnXh54mywli34jSX4IoNNpKzsc6h/awQ=;
        b=YeD5eDP7oBD49sUN1Nsb/T7srXvChdUl0ugIVLpT5+VE6kqEie+qDAUmLNXWpCP96J
         /SEknSgdoQatbSKTCZjxQa+UoaWedMZZk9Yhd2Modi/daTc/foQwAyJA8FwnHXHYBR7b
         /wZEsnVt2q/RQU19PGxsTI1E9iRKH0ugIeEtJN66Ggeh9GChEJEu2M3PwGunUIWlQOhm
         33rYlhwqpYGfNO0whQ32kM6IRU61NSWUOzzzjOOjHiIO5JvVN4mBL6qY6My7e2n6k9yD
         XKjKo/0bM6F2heA85pJcRy90YGREhUYbUohMrcs05WFyqN51NEmahP7T1xADGkbBqzDN
         3NxQ==
X-Gm-Message-State: AAQBX9drUgQBC+1sU2EIFtXjObrSjd1ERRS5XCODqNX9TqoROE5EgLk3
        4CclP0J0ITj62jmlvACVuK73aKmPn+JMTPT+X+E=
X-Google-Smtp-Source: AKy350aDM78BliaPSmIQXAF7QZlXug3YwSHicTayVwm1NuE+noFc+cwTmnEeawHX7ilYH8pc1DnafA==
X-Received: by 2002:a17:906:ca0c:b0:930:1914:88fe with SMTP id jt12-20020a170906ca0c00b00930191488femr9309271ejb.68.1679850059899;
        Sun, 26 Mar 2023 10:00:59 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c24-20020a50d658000000b00501d5432f2fsm8837945edj.60.2023.03.26.10.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:00:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org, arkadiusz.kubalewski@intel.com,
        vadim.fedorenko@linux.dev, vadfed@meta.com
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, pabeni@redhat.com,
        poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [patch dpll-rfc 4/7] dpll: allow to call pin register multiple times
Date:   Sun, 26 Mar 2023 19:00:49 +0200
Message-Id: <20230326170052.2065791-5-jiri@resnulli.us>
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

Some devices allow to control a single dpll pin instance over multiple
channels. In case of mlx5 for example, one dpll pin could be controlled
over multiple PFs that reside on a single ASIC. These are equal.
Allow each to register/unregister dpll pin. Use the first ops and
priv always as the is no difference in between those and the rest.
Replace the existing reference counting by the list of registrations as
they serve the same purpose.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/dpll/dpll_core.c                  | 212 +++++++++++++++-------
 drivers/dpll/dpll_core.h                  |  13 +-
 drivers/dpll/dpll_netlink.c               |  69 ++++---
 drivers/net/ethernet/intel/ice/ice_dpll.c |  18 +-
 include/linux/dpll.h                      |   8 +-
 5 files changed, 220 insertions(+), 100 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 2f788d2349fe..dfff3e07fe43 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -73,6 +73,19 @@ dpll_device_get_by_name(const char *bus_name, const char *device_name)
 	return ret;
 }
 
+static struct dpll_pin_registration *
+dpll_pin_registration_find(struct dpll_pin_ref *ref,
+			   const struct dpll_pin_ops *ops, void *priv)
+{
+	struct dpll_pin_registration *reg;
+
+	list_for_each_entry(reg, &ref->registration_list, list) {
+		if (reg->ops == ops && reg->priv == priv)
+			return reg;
+	}
+	return NULL;
+}
+
 /**
  * dpll_xa_ref_pin_add - add pin reference to a given xarray
  * @xa_pins: dpll_pin_ref xarray holding pins
@@ -80,8 +93,8 @@ dpll_device_get_by_name(const char *bus_name, const char *device_name)
  * @ops: ops for a pin
  * @priv: pointer to private data of owner
  *
- * Allocate and create reference of a pin or increase refcount on existing pin
- * reference on given xarray.
+ * Allocate and create reference of a pin and enlist a registration
+ * structure storing ops and priv pointers of a caller registant.
  *
  * Return:
  * * 0 on success
@@ -91,31 +104,48 @@ static int
 dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
 		    const struct dpll_pin_ops *ops, void *priv)
 {
+	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
+	bool ref_exists = false;
 	unsigned long i;
 	u32 idx;
 	int ret;
 
 	xa_for_each(xa_pins, i, ref) {
-		if (ref->pin == pin) {
-			refcount_inc(&ref->refcount);
-			return 0;
+		if (ref->pin != pin)
+			continue;
+		reg = dpll_pin_registration_find(ref, ops, priv);
+		if (reg)
+			return -EEXIST;
+		ref_exists = true;
+		break;
+	}
+
+	if (!ref_exists) {
+		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+		if (!ref)
+			return -ENOMEM;
+		ref->pin = pin;
+		INIT_LIST_HEAD(&ref->registration_list);
+		ret = xa_alloc(xa_pins, &idx, ref, xa_limit_16b, GFP_KERNEL);
+		if (ret) {
+			kfree(ref);
+			return ret;
 		}
 	}
 
-	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
-	if (!ref)
+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
+	if (!reg) {
+		if (!ref_exists)
+			kfree(ref);
 		return -ENOMEM;
-	ref->pin = pin;
-	ref->ops = ops;
-	ref->priv = priv;
-	ret = xa_alloc(xa_pins, &idx, ref, xa_limit_16b, GFP_KERNEL);
-	if (!ret)
-		refcount_set(&ref->refcount, 1);
-	else
-		kfree(ref);
+	}
+	reg->ops = ops;
+	reg->priv = priv;
 
-	return ret;
+	list_add_tail(&reg->list, &ref->registration_list);
+
+	return 0;
 }
 
 /**
@@ -124,25 +154,31 @@ dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
  * @pin: pointer to a pin
  *
  * Decrement refcount of existing pin reference on given xarray.
- * If all references are dropped, delete the reference and free its memory.
+ * If all registrations are lifted delete the reference and free its memory.
  *
  * Return:
  * * 0 on success
  * * -EINVAL if reference to a pin was not found
  */
-static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin)
+static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin,
+			       const struct dpll_pin_ops *ops, void *priv)
 {
+	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
 	unsigned long i;
 
 	xa_for_each(xa_pins, i, ref) {
-		if (ref->pin == pin) {
-			if (refcount_dec_and_test(&ref->refcount)) {
-				xa_erase(xa_pins, i);
-				kfree(ref);
-			}
-			return 0;
-		}
+		if (ref->pin != pin)
+			continue;
+		reg = dpll_pin_registration_find(ref, ops, priv);
+		if (WARN_ON(!reg))
+			return -EINVAL;
+		list_del(&reg->list);
+		kfree(reg);
+		xa_erase(xa_pins, i);
+		WARN_ON(!list_empty(&ref->registration_list));
+		kfree(ref);
+		return 0;
 	}
 
 	return -EINVAL;
@@ -191,30 +227,48 @@ static int
 dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
 		     const struct dpll_pin_ops *ops, void *priv)
 {
+	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
+	bool ref_exists = false;
 	unsigned long i;
 	u32 idx;
 	int ret;
 
 	xa_for_each(xa_dplls, i, ref) {
-		if (ref->dpll == dpll) {
-			refcount_inc(&ref->refcount);
-			return 0;
+		if (ref->dpll != dpll)
+			continue;
+		reg = dpll_pin_registration_find(ref, ops, priv);
+		if (reg)
+			return -EEXIST;
+		ref_exists = true;
+		break;
+	}
+
+	if (!ref_exists) {
+		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+		if (!ref)
+			return -ENOMEM;
+		ref->dpll = dpll;
+		INIT_LIST_HEAD(&ref->registration_list);
+		ret = xa_alloc(xa_dplls, &idx, ref, xa_limit_16b, GFP_KERNEL);
+		if (ret) {
+			kfree(ref);
+			return ret;
 		}
 	}
-	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
-	if (!ref)
+
+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
+	if (!reg) {
+		if (!ref_exists)
+			kfree(ref);
 		return -ENOMEM;
-	ref->dpll = dpll;
-	ref->ops = ops;
-	ref->priv = priv;
-	ret = xa_alloc(xa_dplls, &idx, ref, xa_limit_16b, GFP_KERNEL);
-	if (!ret)
-		refcount_set(&ref->refcount, 1);
-	else
-		kfree(ref);
+	}
+	reg->ops = ops;
+	reg->priv = priv;
 
-	return ret;
+	list_add_tail(&reg->list, &ref->registration_list);
+
+	return 0;
 }
 
 /**
@@ -226,19 +280,25 @@ dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
  * If all references are dropped, delete the reference and free its memory.
  */
 static void
-dpll_xa_ref_dpll_del(struct xarray *xa_dplls, struct dpll_device *dpll)
+dpll_xa_ref_dpll_del(struct xarray *xa_dplls, struct dpll_device *dpll,
+		     const struct dpll_pin_ops *ops, void *priv)
 {
+	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
 	unsigned long i;
 
 	xa_for_each(xa_dplls, i, ref) {
-		if (ref->dpll == dpll) {
-			if (refcount_dec_and_test(&ref->refcount)) {
-				xa_erase(xa_dplls, i);
-				kfree(ref);
-			}
-			break;
-		}
+		if (ref->dpll != dpll)
+			continue;
+		reg = dpll_pin_registration_find(ref, ops, priv);
+		if (WARN_ON(!reg))
+			return;
+		list_del(&reg->list);
+		kfree(reg);
+		xa_erase(xa_dplls, i);
+		WARN_ON(!list_empty(&ref->registration_list));
+		kfree(ref);
+		return;
 	}
 }
 
@@ -639,7 +699,7 @@ __dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
 	return ret;
 
 ref_pin_del:
-	dpll_xa_ref_pin_del(&dpll->pin_refs, pin);
+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
 rclk_free:
 	kfree(pin->rclk_dev_name);
 	return ret;
@@ -681,27 +741,31 @@ int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
 EXPORT_SYMBOL_GPL(dpll_pin_register);
 
 static void
-__dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin)
+__dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
+		      const struct dpll_pin_ops *ops, void *priv)
 {
-	dpll_xa_ref_pin_del(&dpll->pin_refs, pin);
-	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll);
+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
+	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv);
 }
 
 /**
  * dpll_pin_unregister - deregister dpll pin from dpll device
  * @dpll: registered dpll pointer
  * @pin: pointer to a pin
+ * @ops: ops for a dpll pin ops
+ * @priv: pointer to private information of owner
  *
  * Note: It does not free the memory
  */
-int dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin)
+int dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
+			const struct dpll_pin_ops *ops, void *priv)
 {
 	if (WARN_ON(xa_empty(&dpll->pin_refs)))
 		return -ENOENT;
 
 	mutex_lock(&dpll_device_xa_lock);
 	mutex_lock(&dpll_pin_xa_lock);
-	__dpll_pin_unregister(dpll, pin);
+	__dpll_pin_unregister(dpll, pin, ops, priv);
 	mutex_unlock(&dpll_pin_xa_lock);
 	mutex_unlock(&dpll_device_xa_lock);
 
@@ -763,12 +827,12 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 	xa_for_each(&parent->dpll_refs, i, ref) {
 		if (i < stop) {
 			mutex_lock(&dpll_device_xa_lock);
-			__dpll_pin_unregister(ref->dpll, pin);
+			__dpll_pin_unregister(ref->dpll, pin, ops, priv);
 			mutex_unlock(&dpll_device_xa_lock);
 		}
 	}
 	refcount_dec(&pin->refcount);
-	dpll_xa_ref_pin_del(&pin->parent_refs, parent);
+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv);
 unlock:
 	mutex_unlock(&dpll_pin_xa_lock);
 	return ret;
@@ -779,20 +843,23 @@ EXPORT_SYMBOL_GPL(dpll_pin_on_pin_register);
  * dpll_pin_on_pin_unregister - deregister dpll pin from a parent pin
  * @parent: pointer to a parent pin
  * @pin: pointer to a pin
+ * @ops: ops for a dpll pin
+ * @priv: pointer to private information of owner
  *
  * Note: It does not free the memory
  */
-void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin)
+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
+				const struct dpll_pin_ops *ops, void *priv)
 {
 	struct dpll_pin_ref *ref;
 	unsigned long i;
 
 	mutex_lock(&dpll_device_xa_lock);
 	mutex_lock(&dpll_pin_xa_lock);
-	dpll_xa_ref_pin_del(&pin->parent_refs, parent);
+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv);
 	refcount_dec(&pin->refcount);
 	xa_for_each(&pin->dpll_refs, i, ref) {
-		__dpll_pin_unregister(ref->dpll, pin);
+		__dpll_pin_unregister(ref->dpll, pin, ops, priv);
 		dpll_pin_parent_notify(ref->dpll, pin, parent,
 				       DPLL_A_PIN_IDX);
 	}
@@ -859,6 +926,17 @@ const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll)
 	return reg->ops;
 }
 
+static struct dpll_pin_registration *
+dpll_pin_registration_first(struct dpll_pin_ref *ref)
+{
+	struct dpll_pin_registration *reg;
+
+	reg = list_first_entry_or_null(&ref->registration_list,
+				       struct dpll_pin_registration, list);
+	WARN_ON(!reg);
+	return reg;
+}
+
 /**
  * dpll_pin_on_dpll_priv - get the dpll device private owner data
  * @dpll:	registered dpll pointer
@@ -869,13 +947,14 @@ const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll)
 void *dpll_pin_on_dpll_priv(const struct dpll_device *dpll,
 			    const struct dpll_pin *pin)
 {
+	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
 
 	ref = dpll_xa_ref_pin_find((struct xarray *)&dpll->pin_refs, pin);
 	if (!ref)
 		return NULL;
-
-	return ref->priv;
+	reg = dpll_pin_registration_first(ref);
+	return reg->priv;
 }
 EXPORT_SYMBOL_GPL(dpll_pin_on_dpll_priv);
 
@@ -889,16 +968,25 @@ EXPORT_SYMBOL_GPL(dpll_pin_on_dpll_priv);
 void *dpll_pin_on_pin_priv(const struct dpll_pin *parent,
 			   const struct dpll_pin *pin)
 {
+	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
 
 	ref = dpll_xa_ref_pin_find((struct xarray *)&pin->parent_refs, parent);
 	if (!ref)
 		return NULL;
-
-	return ref->priv;
+	reg = dpll_pin_registration_first(ref);
+	return reg->priv;
 }
 EXPORT_SYMBOL_GPL(dpll_pin_on_pin_priv);
 
+const struct dpll_pin_ops *dpll_pin_ops(struct dpll_pin_ref *ref)
+{
+	struct dpll_pin_registration *reg;
+
+	reg = dpll_pin_registration_first(ref);
+	return reg->ops;
+}
+
 static int __init dpll_init(void)
 {
 	int ret;
diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
index 636dd4c6710e..2ab2d9e0a3cd 100644
--- a/drivers/dpll/dpll_core.h
+++ b/drivers/dpll/dpll_core.h
@@ -73,27 +73,30 @@ struct dpll_pin {
 	refcount_t refcount;
 };
 
+struct dpll_pin_registration {
+	struct list_head list;
+	const struct dpll_pin_ops *ops;
+	void *priv;
+};
+
 /**
  * struct dpll_pin_ref - structure for referencing either dpll or pins
  * @dpll:		pointer to a dpll
  * @pin:		pointer to a pin
- * @ops:		ops for a dpll pin
- * @priv:		pointer to private information of owner
  **/
 struct dpll_pin_ref {
 	union {
 		struct dpll_device *dpll;
 		struct dpll_pin *pin;
 	};
-	struct dpll_pin_ops *ops;
-	void *priv;
-	refcount_t refcount;
+	struct list_head registration_list;
 };
 
 const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll);
 struct dpll_device *dpll_device_get_by_id(int id);
 struct dpll_device *dpll_device_get_by_name(const char *bus_name,
 					    const char *dev_name);
+const struct dpll_pin_ops *dpll_pin_ops(struct dpll_pin_ref *ref);
 struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, u32 idx);
 struct dpll_pin_ref *
 dpll_xa_ref_pin_find(struct xarray *xa_refs, const struct dpll_pin *pin);
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 41e2f8a90aeb..125dc3c7e643 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -103,11 +103,12 @@ dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_pin *pin,
 		      struct dpll_pin_ref *ref,
 		      struct netlink_ext_ack *extack)
 {
+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
 	u32 prio;
 
-	if (!ref->ops->prio_get)
+	if (!ops->prio_get)
 		return -EOPNOTSUPP;
-	if (ref->ops->prio_get(pin, ref->dpll, &prio, extack))
+	if (ops->prio_get(pin, ref->dpll, &prio, extack))
 		return -EFAULT;
 	if (nla_put_u32(msg, DPLL_A_PIN_PRIO, prio))
 		return -EMSGSIZE;
@@ -120,11 +121,12 @@ dpll_msg_add_pin_on_dpll_state(struct sk_buff *msg, const struct dpll_pin *pin,
 			       struct dpll_pin_ref *ref,
 			       struct netlink_ext_ack *extack)
 {
+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
 	enum dpll_pin_state state;
 
-	if (!ref->ops->state_on_dpll_get)
+	if (!ops->state_on_dpll_get)
 		return -EOPNOTSUPP;
-	if (ref->ops->state_on_dpll_get(pin, ref->dpll, &state, extack))
+	if (ops->state_on_dpll_get(pin, ref->dpll, &state, extack))
 		return -EFAULT;
 	if (nla_put_u8(msg, DPLL_A_PIN_STATE, state))
 		return -EMSGSIZE;
@@ -137,11 +139,12 @@ dpll_msg_add_pin_direction(struct sk_buff *msg, const struct dpll_pin *pin,
 			   struct dpll_pin_ref *ref,
 			   struct netlink_ext_ack *extack)
 {
+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
 	enum dpll_pin_direction direction;
 
-	if (!ref->ops->direction_get)
+	if (!ops->direction_get)
 		return -EOPNOTSUPP;
-	if (ref->ops->direction_get(pin, ref->dpll, &direction, extack))
+	if (ops->direction_get(pin, ref->dpll, &direction, extack))
 		return -EFAULT;
 	if (nla_put_u8(msg, DPLL_A_PIN_DIRECTION, direction))
 		return -EMSGSIZE;
@@ -154,12 +157,13 @@ dpll_msg_add_pin_freq(struct sk_buff *msg, const struct dpll_pin *pin,
 		      struct dpll_pin_ref *ref, struct netlink_ext_ack *extack,
 		      bool dump_any_freq)
 {
+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
 	enum dpll_pin_freq_supp fs;
 	u32 freq;
 
-	if (!ref->ops->frequency_get)
+	if (!ops->frequency_get)
 		return -EOPNOTSUPP;
-	if (ref->ops->frequency_get(pin, ref->dpll, &freq, extack))
+	if (ops->frequency_get(pin, ref->dpll, &freq, extack))
 		return -EFAULT;
 	if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY, freq))
 		return -EMSGSIZE;
@@ -196,10 +200,12 @@ dpll_msg_add_pin_parents(struct sk_buff *msg, struct dpll_pin *pin,
 	int ret;
 
 	xa_for_each(&pin->parent_refs, index, ref_parent) {
-		if (WARN_ON(!ref_parent->ops->state_on_pin_get))
+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref_parent);
+
+		if (WARN_ON(!ops->state_on_pin_get))
 			return -EFAULT;
-		ret = ref_parent->ops->state_on_pin_get(pin, ref_parent->pin,
-							&state, extack);
+		ret = ops->state_on_pin_get(pin, ref_parent->pin,
+					    &state, extack);
 		if (ret)
 			return -EFAULT;
 		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
@@ -235,10 +241,11 @@ dpll_msg_add_pins_on_pin(struct sk_buff *msg, struct dpll_pin *pin,
 	int ret;
 
 	xa_for_each(&pin->parent_refs, index, ref) {
-		if (WARN_ON(!ref->ops->state_on_pin_get))
+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+
+		if (WARN_ON(!ops->state_on_pin_get))
 			return -EFAULT;
-		ret = ref->ops->state_on_pin_get(pin, ref->pin, &state,
-						 extack);
+		ret = ops->state_on_pin_get(pin, ref->pin, &state, extack);
 		if (ret)
 			return -EFAULT;
 		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
@@ -452,7 +459,9 @@ dpll_pin_freq_set(struct dpll_pin *pin, struct nlattr *a,
 		return -EINVAL;
 
 	xa_for_each(&pin->dpll_refs, i, ref) {
-		ret = ref->ops->frequency_set(pin, ref->dpll, freq, extack);
+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+
+		ret = ops->frequency_set(pin, ref->dpll, freq, extack);
 		if (ret)
 			return -EFAULT;
 		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_FREQUENCY);
@@ -466,6 +475,7 @@ dpll_pin_on_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
 			  u32 parent_idx, enum dpll_pin_state state,
 			  struct netlink_ext_ack *extack)
 {
+	const struct dpll_pin_ops *ops;
 	struct dpll_pin_ref *ref;
 	struct dpll_pin *parent;
 
@@ -477,9 +487,10 @@ dpll_pin_on_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
 	ref = dpll_xa_ref_pin_find(&pin->parent_refs, parent);
 	if (!ref)
 		return -EINVAL;
-	if (!ref->ops || !ref->ops->state_on_pin_set)
+	ops = dpll_pin_ops(ref);
+	if (!ops->state_on_pin_set)
 		return -EOPNOTSUPP;
-	if (ref->ops->state_on_pin_set(pin, parent, state, extack))
+	if (ops->state_on_pin_set(pin, parent, state, extack))
 		return -EFAULT;
 	dpll_pin_parent_notify(dpll, pin, parent, DPLL_A_PIN_STATE);
 
@@ -491,6 +502,7 @@ dpll_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
 		   enum dpll_pin_state state,
 		   struct netlink_ext_ack *extack)
 {
+	const struct dpll_pin_ops *ops;
 	struct dpll_pin_ref *ref;
 
 	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))
@@ -498,9 +510,10 @@ dpll_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
 	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
 	if (!ref)
 		return -EFAULT;
-	if (!ref->ops || !ref->ops->state_on_dpll_set)
+	ops = dpll_pin_ops(ref);
+	if (!ops->state_on_dpll_set)
 		return -EOPNOTSUPP;
-	if (ref->ops->state_on_dpll_set(pin, ref->dpll, state, extack))
+	if (ops->state_on_dpll_set(pin, ref->dpll, state, extack))
 		return -EINVAL;
 	dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_STATE);
 
@@ -511,6 +524,7 @@ static int
 dpll_pin_prio_set(struct dpll_device *dpll, struct dpll_pin *pin,
 		  struct nlattr *prio_attr, struct netlink_ext_ack *extack)
 {
+	const struct dpll_pin_ops *ops;
 	struct dpll_pin_ref *ref;
 	u32 prio = nla_get_u8(prio_attr);
 
@@ -519,9 +533,10 @@ dpll_pin_prio_set(struct dpll_device *dpll, struct dpll_pin *pin,
 	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
 	if (!ref)
 		return -EFAULT;
-	if (!ref->ops || !ref->ops->prio_set)
+	ops = dpll_pin_ops(ref);
+	if (!ops->prio_set)
 		return -EOPNOTSUPP;
-	if (ref->ops->prio_set(pin, dpll, prio, extack))
+	if (ops->prio_set(pin, dpll, prio, extack))
 		return -EINVAL;
 	dpll_pin_notify(dpll, pin, DPLL_A_PIN_PRIO);
 
@@ -540,7 +555,9 @@ dpll_pin_direction_set(struct dpll_pin *pin, struct nlattr *a,
 		return -EOPNOTSUPP;
 
 	xa_for_each(&pin->dpll_refs, i, ref) {
-		if (ref->ops->direction_set(pin, ref->dpll, direction, extack))
+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+
+		if (ops->direction_set(pin, ref->dpll, direction, extack))
 			return -EFAULT;
 		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_DIRECTION);
 	}
@@ -920,13 +937,15 @@ dpll_event_device_change(struct sk_buff *msg, struct dpll_device *dpll,
 		break;
 	case DPLL_A_PIN_STATE:
 		if (parent) {
+			const struct dpll_pin_ops *ops;
+
 			ref = dpll_xa_ref_pin_find(&pin->parent_refs, parent);
 			if (!ref)
 				return -EFAULT;
-			if (!ref->ops || !ref->ops->state_on_pin_get)
+			ops = dpll_pin_ops(ref);
+			if (!ops->state_on_pin_get)
 				return -EOPNOTSUPP;
-			ret = ref->ops->state_on_pin_get(pin, parent, &state,
-							 NULL);
+			ret = ops->state_on_pin_get(pin, parent, &state, NULL);
 			if (ret)
 				return ret;
 			if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 532ad7314f49..d39292ad102f 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -1194,7 +1194,8 @@ ice_dpll_release_rclk_pin(struct ice_pf *pf)
 		parent = pf->dplls.inputs[rclk->parent_idx[i]].pin;
 		if (!parent)
 			continue;
-		dpll_pin_on_pin_unregister(parent, rclk->pin);
+		dpll_pin_on_pin_unregister(parent, rclk->pin,
+					   &ice_dpll_rclk_ops, pf);
 	}
 	dpll_pin_put(rclk->pin);
 	rclk->pin = NULL;
@@ -1202,6 +1203,7 @@ ice_dpll_release_rclk_pin(struct ice_pf *pf)
 
 /**
  * ice_dpll_release_pins - release pin's from dplls registered in subsystem
+ * @pf: board private structure
  * @dpll_eec: dpll_eec dpll pointer
  * @dpll_pps: dpll_pps dpll pointer
  * @pins: pointer to pins array
@@ -1215,7 +1217,7 @@ ice_dpll_release_rclk_pin(struct ice_pf *pf)
  * * positive - number of errors encounterd on pin's deregistration.
  */
 static int
-ice_dpll_release_pins(struct dpll_device *dpll_eec,
+ice_dpll_release_pins(struct ice_pf *pf, struct dpll_device *dpll_eec,
 		      struct dpll_device *dpll_pps, struct ice_dpll_pin *pins,
 		      int count, bool cgu)
 {
@@ -1226,12 +1228,16 @@ ice_dpll_release_pins(struct dpll_device *dpll_eec,
 
 		if (p && !IS_ERR_OR_NULL(p->pin)) {
 			if (cgu && dpll_eec) {
-				ret = dpll_pin_unregister(dpll_eec, p->pin);
+				ret = dpll_pin_unregister(dpll_eec, p->pin,
+							  &ice_dpll_source_ops,
+							  pf);
 				if (ret)
 					err++;
 			}
 			if (cgu && dpll_pps) {
-				ret = dpll_pin_unregister(dpll_pps, p->pin);
+				ret = dpll_pin_unregister(dpll_pps, p->pin,
+							  &ice_dpll_source_ops,
+							  pf);
 				if (ret)
 					err++;
 			}
@@ -1532,7 +1538,7 @@ static void ice_dpll_release_all(struct ice_pf *pf, bool cgu)
 
 	mutex_lock(&pf->dplls.lock);
 	ice_dpll_release_rclk_pin(pf);
-	ret = ice_dpll_release_pins(de->dpll, dp->dpll, d->inputs,
+	ret = ice_dpll_release_pins(pf, de->dpll, dp->dpll, d->inputs,
 				    d->num_inputs, cgu);
 	mutex_unlock(&pf->dplls.lock);
 	if (ret)
@@ -1540,7 +1546,7 @@ static void ice_dpll_release_all(struct ice_pf *pf, bool cgu)
 			 "source pins release dplls err=%d\n", ret);
 	if (cgu) {
 		mutex_lock(&pf->dplls.lock);
-		ret = ice_dpll_release_pins(de->dpll, dp->dpll, d->outputs,
+		ret = ice_dpll_release_pins(pf, de->dpll, dp->dpll, d->outputs,
 					    d->num_outputs, cgu);
 		mutex_unlock(&pf->dplls.lock);
 		if (ret)
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 09863d66a44c..be5717e1da99 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -211,6 +211,8 @@ int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
  * dpll_pin_unregister - deregister pin from a dpll device
  * @dpll: pointer to dpll object to deregister pin from
  * @pin: pointer to allocated pin object being deregistered from dpll
+ * @ops: ops for a dpll pin ops
+ * @priv: pointer to private information of owner
  *
  * Deregister previously registered pin object from a dpll device.
  *
@@ -219,7 +221,8 @@ int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
  * * -ENXIO - given pin was not registered with this dpll device,
  * * -EINVAL - pin pointer is not valid.
  */
-int dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin);
+int dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
+			const struct dpll_pin_ops *ops, void *priv);
 
 /**
  * dpll_pin_put - drop reference to a pin acquired with dpll_pin_get
@@ -268,7 +271,8 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
  * * -ENOMEM - failed to allocate memory,
  * * -EEXIST - pin already registered with this parent pin,
  */
-void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin);
+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
+				const struct dpll_pin_ops *ops, void *priv);
 
 /**
  * dpll_device_notify - notify on dpll device change
-- 
2.39.0

