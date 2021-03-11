Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A10F336AA4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCKD01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:26:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhCKD0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 22:26:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22E7D64FC9;
        Thu, 11 Mar 2021 03:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615433177;
        bh=c68gw+qPQpsb6OkRTN6dewkYJxoVacZSeWgUNGpNM5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=SyWuyMaOzQnnEj2uSBDlQmzFLj0iGzLflYyyW+BoNjr55Z4e+4OSI2cnS55hqRblz
         oZOTJfViYrgCHf2gegVP3X74wtNS7I9b+F9vVgIWfGmgm3AEdXi/4MFqpo9aAUvt29
         9kadAoAuHUWlpcIiO4txMnwjZzl+kUadb+7ycD2m4HzQjF/lsvU8/FA9Xy1CIEhfVy
         n7RgjVVJG6Epzsuo/dPP9KV8rCi7ACbq+NomVuYsf7uCcFbXM5/krrqz3V6SGrVF6h
         EqzepchTqdXmC67l4pUqsGaAqAzyRP1RcRLw0T54rTHJHu4z917XHYOBfu8ABQSxAs
         QEHjmRccDUCkA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next v2 2/3] devlink: health: add remediation type
Date:   Wed, 10 Mar 2021 19:26:12 -0800
Message-Id: <20210311032613.1533100-2-kuba@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311032613.1533100-1-kuba@kernel.org>
References: <20210311032613.1533100-1-kuba@kernel.org>
Reply-To: f242ed68-d31b-527d-562f-c5a35123861a@intel.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently devlink health does not give user any clear information
of what kind of remediation ->recover callback will perform. This
makes it difficult to understand the impact of enabling auto-
-remediation, and the severity of the error itself.

To allow users to make more informed decision add a new remediation
type attribute.

Note that we only allow one remediation type per reporter, this
is intentional. devlink health is not built for mixing issues
of different severity into one reporter since it only maintains
one dump, of the first event and a single error counter.
Nudging vendors towards categorizing issues beyond coarse
groups is an added bonus.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h        |  2 ++
 include/uapi/linux/devlink.h | 25 +++++++++++++++++++++++++
 net/core/devlink.c           |  7 ++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index b424328af658..72b37769761f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -659,6 +659,7 @@ struct devlink_health_reporter;
 /**
  * struct devlink_health_reporter_ops - Reporter operations
  * @name: reporter name
+ * remedy: severity of the remediation required
  * @recover: callback to recover from reported error
  *           if priv_ctx is NULL, run a full recover
  * @dump: callback to dump an object
@@ -669,6 +670,7 @@ struct devlink_health_reporter;
 
 struct devlink_health_reporter_ops {
 	char *name;
+	enum devlink_health_remedy remedy;
 	int (*recover)(struct devlink_health_reporter *reporter,
 		       void *priv_ctx, struct netlink_ext_ack *extack);
 	int (*dump)(struct devlink_health_reporter *reporter,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 41a6ea3b2256..8cd1508b525b 100644
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
@@ -620,4 +623,26 @@ enum devlink_health_state {
 	DL_HEALTH_STATE_ERROR,
 };
 
+/**
+ * enum devlink_health_reporter_remedy - severity of remediation procedure
+ * @DL_HEALTH_REMEDY_NONE: transient error, no remediation required
+ * @DL_HEALTH_REMEDY_KICK: device stalled, processing will be re-triggered
+ * @DL_HEALTH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
+ *			will be reset
+ * @DL_HEALTH_REMEDY_RESET: full device reset, will result in temporary
+ *			unavailability of the device, device configuration
+ *			should not be lost
+ * @DL_HEALTH_REMEDY_REINIT: device will be reinitialized and configuration lost
+ *
+ * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
+ * by the severity of the remediation.
+ */
+enum devlink_health_remedy {
+	DL_HEALTH_REMEDY_NONE = 1,
+	DL_HEALTH_REMEDY_KICK,
+	DL_HEALTH_REMEDY_COMP_RESET,
+	DL_HEALTH_REMEDY_RESET,
+	DL_HEALTH_REMEDY_REINIT,
+};
+
 #endif /* _UAPI_LINUX_DEVLINK_H_ */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8e4e4bd7bb36..09d77d43ff63 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6095,7 +6095,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
 {
 	struct devlink_health_reporter *reporter;
 
-	if (WARN_ON(graceful_period && !ops->recover))
+	if (WARN_ON(graceful_period && !ops->recover) ||
+	    WARN_ON(ops->recover && !ops->remedy))
 		return ERR_PTR(-EINVAL);
 
 	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
@@ -6265,6 +6266,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
 			   reporter->ops->name))
 		goto reporter_nest_cancel;
+	if (reporter->ops->remedy &&
+	    nla_put_u32(msg, DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,
+			reporter->ops->remedy))
+		goto reporter_nest_cancel;
 	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
 		       reporter->health_state))
 		goto reporter_nest_cancel;
-- 
2.29.2

