Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E785F55B3C4
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiFZTZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiFZTZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:25:02 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9279A2B1
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 12:25:00 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 7A19F50060B;
        Sun, 26 Jun 2022 22:23:23 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 7A19F50060B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656271405; bh=rBRuqeuCWrwaoDF+DCGBVSthnsJxQTlEB/gXRaNfRnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIVjcJJFt0nahGf7aI/6dB1PP4SeGdoxWzkThWQwQwAzX6qhSCCA67853uVKkuyhs
         9qY/AjbFgC5/nGDADwkNvCOI+fO8anjlfIU3FFHhErJZfcFTNfK8Mj9v2ksDsJO6PY
         tB07R+l4cWRyalzo1voZtrKU9+qdhTr6+8ynvLNY=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: [RFC PATCH v2 2/3] dpll: add netlink events
Date:   Sun, 26 Jun 2022 22:24:43 +0300
Message-Id: <20220626192444.29321-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220626192444.29321-1-vfedorenko@novek.ru>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/dpll/dpll_core.c    |   2 +
 drivers/dpll/dpll_netlink.c | 141 ++++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h |   7 ++
 3 files changed, 150 insertions(+)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index dc0330e3687d..387644aa910e 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -97,6 +97,8 @@ struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int sources_c
 	mutex_unlock(&dpll_device_xa_lock);
 	dpll->priv = priv;
 
+	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
+
 	return dpll;
 
 error:
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index e15106f30377..4b1684fcf41e 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -48,6 +48,8 @@ struct param {
 	int dpll_source_type;
 	int dpll_output_id;
 	int dpll_output_type;
+	int dpll_status;
+	const char *dpll_name;
 };
 
 struct dpll_dump_ctx {
@@ -239,6 +241,8 @@ static int dpll_genl_cmd_set_source(struct param *p)
 	ret = dpll->ops->set_source_type(dpll, src_id, type);
 	mutex_unlock(&dpll->lock);
 
+	dpll_notify_source_change(dpll->id, src_id, type);
+
 	return ret;
 }
 
@@ -262,6 +266,8 @@ static int dpll_genl_cmd_set_output(struct param *p)
 	ret = dpll->ops->set_source_type(dpll, out_id, type);
 	mutex_unlock(&dpll->lock);
 
+	dpll_notify_source_change(dpll->id, out_id, type);
+
 	return ret;
 }
 
@@ -438,6 +444,141 @@ static struct genl_family dpll_gnl_family __ro_after_init = {
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
+static cb_t event_cb[] = {
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
+	genlmsg_multicast(&dpll_gnl_family, msg, 0, 1, GFP_KERNEL);
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
+	struct param p = { .dpll_id = dpll_id, .dpll_name = name };
+
+	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);
+}
+
+int dpll_notify_device_delete(int dpll_id)
+{
+	struct param p = { .dpll_id = dpll_id };
+
+	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
+}
+
+int dpll_notify_status_locked(int dpll_id)
+{
+	struct param p = { .dpll_id = dpll_id, .dpll_status = 1 };
+
+	return dpll_send_event(DPLL_EVENT_STATUS_LOCKED, &p);
+}
+
+int dpll_notify_status_unlocked(int dpll_id)
+{
+	struct param p = { .dpll_id = dpll_id, .dpll_status = 0 };
+
+	return dpll_send_event(DPLL_EVENT_STATUS_UNLOCKED, &p);
+}
+
+int dpll_notify_source_change(int dpll_id, int source_id, int source_type)
+{
+	struct param p =  { .dpll_id = dpll_id, .dpll_source_id = source_id,
+						.dpll_source_type = source_type };
+
+	return dpll_send_event(DPLL_EVENT_SOURCE_CHANGE, &p);
+}
+
+int dpll_notify_output_change(int dpll_id, int output_id, int output_type)
+{
+	struct param p =  { .dpll_id = dpll_id, .dpll_output_id = output_id,
+						.dpll_output_type = output_type };
+
+	return dpll_send_event(DPLL_EVENT_OUTPUT_CHANGE, &p);
+}
+
 int __init dpll_netlink_init(void)
 {
 	return genl_register_family(&dpll_gnl_family);
diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
index e2d100f59dd6..0dc81320f982 100644
--- a/drivers/dpll/dpll_netlink.h
+++ b/drivers/dpll/dpll_netlink.h
@@ -3,5 +3,12 @@
  *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
  */
 
+int dpll_notify_device_create(int dpll_id, const char *name);
+int dpll_notify_device_delete(int dpll_id);
+int dpll_notify_status_locked(int dpll_id);
+int dpll_notify_status_unlocked(int dpll_id);
+int dpll_notify_source_change(int dpll_id, int source_id, int source_type);
+int dpll_notify_output_change(int dpll_id, int output_id, int output_type);
+
 int __init dpll_netlink_init(void);
 void dpll_netlink_finish(void);
-- 
2.27.0

