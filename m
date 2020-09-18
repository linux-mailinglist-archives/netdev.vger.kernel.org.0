Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1505926F25F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgIRC6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727743AbgIRCGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D08442388E;
        Fri, 18 Sep 2020 02:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394778;
        bh=KlyB1V7trltBZqapT92xp/ft/alNfcd/5PzlcK1on1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRlTA8PPxt9Pepq6SkToBjum3szvkM4m9BAqdI0TsLjilzAj94tXPmQ0k1KGH66Eb
         gzBrNKvPfse/MQgdTfs9jJF+M3lm4grnJu9DVEaGtwqsCzceEKZk2xZwlOszgOzNE8
         e0Mfprh9pQ9JNbIodXMZ/CJdyEDMQdOn5PHGfJjQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aya Levin <ayal@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 252/330] devlink: Fix reporter's recovery condition
Date:   Thu, 17 Sep 2020 21:59:52 -0400
Message-Id: <20200918020110.2063155-252-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit bea0c5c942d3b4e9fb6ed45f6a7de74c6b112437 ]

Devlink health core conditions the reporter's recovery with the
expiration of the grace period. This is not relevant for the first
recovery. Explicitly demand that the grace period will only apply to
recoveries other than the first.

Fixes: c8e1da0bf923 ("devlink: Add health report functionality")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5667cae57072f..26c8993a17ae0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4823,6 +4823,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 {
 	enum devlink_health_reporter_state prev_health_state;
 	struct devlink *devlink = reporter->devlink;
+	unsigned long recover_ts_threshold;
 
 	/* write a log message of the current error */
 	WARN_ON(!msg);
@@ -4832,10 +4833,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
 
 	/* abort if the previous error wasn't recovered */
+	recover_ts_threshold = reporter->last_recovery_ts +
+			       msecs_to_jiffies(reporter->graceful_period);
 	if (reporter->auto_recover &&
 	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
-	     jiffies - reporter->last_recovery_ts <
-	     msecs_to_jiffies(reporter->graceful_period))) {
+	     (reporter->last_recovery_ts && reporter->recovery_count &&
+	      time_is_after_jiffies(recover_ts_threshold)))) {
 		trace_devlink_health_recover_aborted(devlink,
 						     reporter->ops->name,
 						     reporter->health_state,
-- 
2.25.1

