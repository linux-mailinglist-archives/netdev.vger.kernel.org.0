Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1020A32F7E4
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 03:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhCFCn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 21:43:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCFCnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 21:43:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D416C65009;
        Sat,  6 Mar 2021 02:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614998593;
        bh=QEGhZvWDK3sIuELZbC4WXJnxQA/3FZVx9U2Ot57K2Is=;
        h=From:To:Cc:Subject:Date:From;
        b=hT8Wp3/FICvFNUaD5PLgFoRSKrECLYXjNYMWJR+/bsNGqS6fq1hG5qlN4jiQWo7Oj
         kqaTHRToM8vCS6dGMB7OHc6wtn2Lbw9kK9f+bly40yNmCHkIEqHvSVBnc6pencuVTY
         Hbe8/dOHq6vVjqIYYropnNmZQMvID11Qqv0z3Fop4zBmL2+rM63r+fuW1o2env4vLd
         Q1AO71xuYcTTJ8dLoykEpNgQmUIsPWYBHqUN3oTBZb1SBdxR0wx/I6JeJcbq6K3j2p
         6XjhFxTfFuN5hjHuY0VOxobVKL9Yt1OZyHLGM+jBFAT0pMYIiuUmumL33uGGy/L0M8
         DEdFhNOv76w2A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC] devlink: health: add remediation type
Date:   Fri,  5 Mar 2021 18:42:20 -0800
Message-Id: <20210306024220.251721-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently devlink health does not give user any clear information
of what kind of remediation ->recover callback will perform. This
makes it difficult to understand the impact of enabling auto-
-remediation, and the severity of the error itself.

To allow users to make more informed decision, as well as stretch
the applicability of devlink health beyond what can be fixed by
resetting things - add a new remediation type attribute.

Note that we only allow one remediation type per reporter, this
is intentional. devlink health is not built for mixing issues
of different severity into one reporter since it only maintains
one dump, of the first event and a single error counter.
Nudging vendors towards categorizing issues beyond coarse
groups is an added bonus.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h        |  2 ++
 include/uapi/linux/devlink.h | 30 ++++++++++++++++++++++++++++++
 net/core/devlink.c           |  7 +++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 853420db5d32..70b5fd6a8c0d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -664,6 +664,7 @@ enum devlink_health_reporter_state {
 /**
  * struct devlink_health_reporter_ops - Reporter operations
  * @name: reporter name
+ * remedy: severity of the remediation required
  * @recover: callback to recover from reported error
  *           if priv_ctx is NULL, run a full recover
  * @dump: callback to dump an object
@@ -674,6 +675,7 @@ enum devlink_health_reporter_state {
 
 struct devlink_health_reporter_ops {
 	char *name;
+	enum devlink_health_reporter_remedy remedy;
 	int (*recover)(struct devlink_health_reporter *reporter,
 		       void *priv_ctx, struct netlink_ext_ack *extack);
 	int (*dump)(struct devlink_health_reporter *reporter,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index f6008b2fa60f..bd490c5536b1 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -534,6 +534,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
 
 	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
+
+	DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,	/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
@@ -608,4 +611,31 @@ enum devlink_port_fn_opstate {
 	DEVLINK_PORT_FN_OPSTATE_ATTACHED,
 };
 
+/**
+ * enum devlink_health_reporter_remedy - severity of remediation procedure
+ * @DLH_REMEDY_NONE: transient error, no remediation required
+ * @DLH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
+ *			will be reset
+ * @DLH_REMEDY_RESET: full device reset, will result in temporary unavailability
+ *			of the device, device configuration should not be lost
+ * @DLH_REMEDY_REINIT: device will be reinitialized and configuration lost
+ * @DLH_REMEDY_POWER_CYCLE: device requires a power cycle to recover
+ * @DLH_REMEDY_REIMAGE: device needs to be reflashed
+ * @DLH_REMEDY_BAD_PART: indication of failing hardware, device needs to be
+ *			replaced
+ *
+ * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
+ * by the severity of the required remediation, and indicates the remediation
+ * type to the user if it can't be applied automatically (e.g. "reimage").
+ */
+enum devlink_health_reporter_remedy {
+	DLH_REMEDY_NONE = 1,
+	DLH_REMEDY_COMP_RESET,
+	DLH_REMEDY_RESET,
+	DLH_REMEDY_REINIT,
+	DLH_REMEDY_POWER_CYCLE,
+	DLH_REMEDY_REIMAGE,
+	DLH_REMEDY_BAD_PART,
+};
+
 #endif /* _UAPI_LINUX_DEVLINK_H_ */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..73eb665070b9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6095,7 +6095,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
 {
 	struct devlink_health_reporter *reporter;
 
-	if (WARN_ON(graceful_period && !ops->recover))
+	if (WARN_ON(graceful_period && !ops->recover) ||
+	    WARN_ON(!ops->remedy))
 		return ERR_PTR(-EINVAL);
 
 	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
@@ -6263,7 +6264,9 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	if (!reporter_attr)
 		goto genlmsg_cancel;
 	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
-			   reporter->ops->name))
+			   reporter->ops->name) ||
+	    nla_put_u32(msg, DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,
+			reporter->ops->remedy))
 		goto reporter_nest_cancel;
 	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
 		       reporter->health_state))
-- 
2.26.2

