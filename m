Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B481E336AAB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCKD03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhCKD0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 22:26:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B34BE64FCC;
        Thu, 11 Mar 2021 03:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615433178;
        bh=Nqfuf8iNSzg9GNwxT+jhFRRMPbs5xnVjaEsqiYuZFEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=ipV/dIP2Eo4cwOnCnBY1MuUP4td8K69xLYIS2eqT5Dvb8/+f8+2utzD7pixnf98nD
         VnatlybbjpP51IAWEQMtrGWWBp3cALEFjhk205Kgn9EdjZDD3ltXii8+aQZ8bgfEHc
         /8qOLp60IelRqvZbuGqBY5yRdBYaLJ4Rsi7M3w/woMxzMVP97o3JNJYN/A1XwiT0Iq
         nLs9K+XK2jC7ltzhbS0RNCm1EgnM+OID0wMXFvNjXMIV1IuEGjTM926i6KDfgwof7X
         KLCC9RxXRcSQs2WjUjgJcIXZBmTkVa572a1yo8RC/yLLq+T+OMPArZgtzYwEpmwjCA
         Rdo1+tHW+uhsA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next v2 3/3] devlink: add more failure modes
Date:   Wed, 10 Mar 2021 19:26:13 -0800
Message-Id: <20210311032613.1533100-3-kuba@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311032613.1533100-1-kuba@kernel.org>
References: <20210311032613.1533100-1-kuba@kernel.org>
Reply-To: f242ed68-d31b-527d-562f-c5a35123861a@intel.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Pending vendors adding the right reporters. <<

Extend the applicability of devlink health reporters
beyond what can be locally remedied. Add failure modes
which require re-flashing the NVM image or HW changes.

The expectation is that driver will call
devlink_health_reporter_state_update() to put hardware
health reporters into bad state.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/devlink.h | 7 +++++++
 net/core/devlink.c           | 3 +--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 8cd1508b525b..f623bbc63489 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -617,10 +617,17 @@ enum devlink_port_fn_opstate {
  * @DL_HEALTH_STATE_ERROR: error state, running health reporter's recovery
  *			may fix the issue, otherwise user needs to try
  *			power cycling or other forms of reset
+ * @DL_HEALTH_STATE_BAD_IMAGE: device's non-volatile memory needs
+ *			to be re-written, usually due to block corruption
+ * @DL_HEALTH_STATE_BAD_HW: hardware errors detected, device, host
+ *			or the connection between the two may be at fault
  */
 enum devlink_health_state {
 	DL_HEALTH_STATE_HEALTHY,
 	DL_HEALTH_STATE_ERROR,
+
+	DL_HEALTH_STATE_BAD_IMAGE,
+	DL_HEALTH_STATE_BAD_HW,
 };
 
 /**
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 09d77d43ff63..4a9fa6288a4a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6527,8 +6527,7 @@ void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 				     enum devlink_health_state state)
 {
-	if (WARN_ON(state != DL_HEALTH_STATE_HEALTHY &&
-		    state != DL_HEALTH_STATE_ERROR))
+	if (WARN_ON(state > DL_HEALTH_STATE_BAD_HW))
 		return;
 
 	if (reporter->health_state == state)
-- 
2.29.2

