Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701495F9683
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 03:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiJJBSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 21:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiJJBSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 21:18:33 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B5E2F3AE;
        Sun,  9 Oct 2022 18:18:22 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C53AB504DEE;
        Mon, 10 Oct 2022 04:14:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C53AB504DEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665364493; bh=yyAnr5alMdz0gJxmpa4bCIpZ4JyGR+qBnxDUsvKCa1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfJ1hvA4Em3njJ+ZS30qRiu7WgldU6rMvFMSucfkBiDFDvxonJbi1sZDoOunumu3K
         idCk0arSvws7TUNz+FQDLuAZVG19nsNhQ4oxog6hCFZ1QTZGLngYAqvlAx7+tGrZ5K
         h9W0fpsod38QYGavzOvieOztE9CRnswGZlMPRt+o=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: [RFC PATCH v3 2/6] dpll: add netlink events
Date:   Mon, 10 Oct 2022 04:18:00 +0300
Message-Id: <20221010011804.23716-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221010011804.23716-1-vfedorenko@novek.ru>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
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

From: Vadim Fedorenko <vadfed@fb.com>

Add netlink interface to enable notification of users about
events in DPLL framework. Part of this interface should be
used by drivers directly, i.e. lock status changes.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/dpll/dpll_core.c    |   3 +
 drivers/dpll/dpll_netlink.c | 151 ++++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h |   3 +
 include/linux/dpll.h        |   5 ++
 4 files changed, 162 insertions(+)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 7fdee145e82c..732165b77e38 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -115,6 +115,8 @@ struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *n
 	mutex_unlock(&dpll_device_xa_lock);
 	dpll->priv = priv;
 
+	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
+
 	return dpll;
 
 error:
@@ -150,6 +152,7 @@ void dpll_device_unregister(struct dpll_device *dpll)
 
 	mutex_lock(&dpll_device_xa_lock);
 	xa_erase(&dpll_device_xa, dpll->id);
+	dpll_notify_device_delete(dpll->id);
 	mutex_unlock(&dpll_device_xa_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_device_unregister);
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 31966e0eec3a..6dc92b5b712e 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -47,6 +47,9 @@ struct param {
 	int dpll_source_type;
 	int dpll_output_id;
 	int dpll_output_type;
+	int dpll_status;
+	int dpll_event_group;
+	const char *dpll_name;
 };
 
 struct dpll_dump_ctx {
@@ -240,6 +243,9 @@ static int dpll_genl_cmd_set_source(struct sk_buff *skb, struct genl_info *info)
 	ret = dpll->ops->set_source_type(dpll, src_id, type);
 	mutex_unlock(&dpll->lock);
 
+	if (!ret)
+		dpll_notify_source_change(dpll->id, src_id, type);
+
 	return ret;
 }
 
@@ -263,6 +269,9 @@ static int dpll_genl_cmd_set_output(struct sk_buff *skb, struct genl_info *info)
 	ret = dpll->ops->set_output_type(dpll, out_id, type);
 	mutex_unlock(&dpll->lock);
 
+	if (!ret)
+		dpll_notify_output_change(dpll->id, out_id, type);
+
 	return ret;
 }
 
@@ -401,6 +410,148 @@ static struct genl_family dpll_gnl_family __ro_after_init = {
 	.pre_doit	= dpll_pre_doit,
 };
 
+static int dpll_event_device_create(struct param *p)
+{
+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
+	    nla_put_string(p->msg, DPLLA_DEVICE_NAME, p->dpll_name))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_event_device_delete(struct param *p)
+{
+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_event_status(struct param *p)
+{
+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
+		nla_put_u32(p->msg, DPLLA_LOCK_STATUS, p->dpll_status))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_event_source_change(struct param *p)
+{
+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
+	    nla_put_u32(p->msg, DPLLA_SOURCE_ID, p->dpll_source_id) ||
+		nla_put_u32(p->msg, DPLLA_SOURCE_TYPE, p->dpll_source_type))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_event_output_change(struct param *p)
+{
+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
+	    nla_put_u32(p->msg, DPLLA_OUTPUT_ID, p->dpll_output_id) ||
+		nla_put_u32(p->msg, DPLLA_OUTPUT_TYPE, p->dpll_output_type))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static const cb_t event_cb[] = {
+	[DPLL_EVENT_DEVICE_CREATE]	= dpll_event_device_create,
+	[DPLL_EVENT_DEVICE_DELETE]	= dpll_event_device_delete,
+	[DPLL_EVENT_STATUS_LOCKED]	= dpll_event_status,
+	[DPLL_EVENT_STATUS_UNLOCKED]	= dpll_event_status,
+	[DPLL_EVENT_SOURCE_CHANGE]	= dpll_event_source_change,
+	[DPLL_EVENT_OUTPUT_CHANGE]	= dpll_event_output_change,
+};
+/*
+ * Generic netlink DPLL event encoding
+ */
+static int dpll_send_event(enum dpll_genl_event event,
+				   struct param *p)
+{
+	struct sk_buff *msg;
+	int ret = -EMSGSIZE;
+	void *hdr;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	p->msg = msg;
+
+	hdr = genlmsg_put(msg, 0, 0, &dpll_gnl_family, 0, event);
+	if (!hdr)
+		goto out_free_msg;
+
+	ret = event_cb[event](p);
+	if (ret)
+		goto out_cancel_msg;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast(&dpll_gnl_family, msg, 0, p->dpll_event_group, GFP_KERNEL);
+
+	return 0;
+
+out_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+out_free_msg:
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+int dpll_notify_device_create(int dpll_id, const char *name)
+{
+	struct param p = { .dpll_id = dpll_id, .dpll_name = name,
+			   .dpll_event_group = 0 };
+
+	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);
+}
+
+int dpll_notify_device_delete(int dpll_id)
+{
+	struct param p = { .dpll_id = dpll_id, .dpll_event_group = 0 };
+
+	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
+}
+
+int dpll_notify_status_locked(int dpll_id)
+{
+	struct param p = { .dpll_id = dpll_id, .dpll_status = 1,
+			   .dpll_event_group = 3 };
+
+	return dpll_send_event(DPLL_EVENT_STATUS_LOCKED, &p);
+}
+EXPORT_SYMBOL_GPL(dpll_notify_status_locked);
+
+int dpll_notify_status_unlocked(int dpll_id)
+{
+	struct param p = { .dpll_id = dpll_id, .dpll_status = 0,
+			   .dpll_event_group = 3 };
+
+	return dpll_send_event(DPLL_EVENT_STATUS_UNLOCKED, &p);
+}
+EXPORT_SYMBOL_GPL(dpll_notify_status_unlocked);
+
+int dpll_notify_source_change(int dpll_id, int source_id, int source_type)
+{
+	struct param p =  { .dpll_id = dpll_id, .dpll_source_id = source_id,
+			    .dpll_source_type = source_type, .dpll_event_group = 1 };
+
+	return dpll_send_event(DPLL_EVENT_SOURCE_CHANGE, &p);
+}
+EXPORT_SYMBOL_GPL(dpll_notify_source_change);
+
+int dpll_notify_output_change(int dpll_id, int output_id, int output_type)
+{
+	struct param p =  { .dpll_id = dpll_id, .dpll_output_id = output_id,
+			    .dpll_output_type = output_type, .dpll_event_group = 2 };
+
+	return dpll_send_event(DPLL_EVENT_OUTPUT_CHANGE, &p);
+}
+EXPORT_SYMBOL_GPL(dpll_notify_output_change);
+
 int __init dpll_netlink_init(void)
 {
 	return genl_register_family(&dpll_gnl_family);
diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
index e2d100f59dd6..5c1d1072e818 100644
--- a/drivers/dpll/dpll_netlink.h
+++ b/drivers/dpll/dpll_netlink.h
@@ -3,5 +3,8 @@
  *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
  */
 
+int dpll_notify_device_create(int dpll_id, const char *name);
+int dpll_notify_device_delete(int dpll_id);
+
 int __init dpll_netlink_init(void);
 void dpll_netlink_finish(void);
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 9d49b19d03d9..32558965cd41 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -26,4 +26,9 @@ void dpll_device_register(struct dpll_device *dpll);
 void dpll_device_unregister(struct dpll_device *dpll);
 void dpll_device_free(struct dpll_device *dpll);
 void *dpll_priv(struct dpll_device *dpll);
+
+int dpll_notify_status_locked(int dpll_id);
+int dpll_notify_status_unlocked(int dpll_id);
+int dpll_notify_source_change(int dpll_id, int source_id, int source_type);
+int dpll_notify_output_change(int dpll_id, int output_id, int output_type);
 #endif
-- 
2.27.0

