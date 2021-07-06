Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D663BCEA3
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhGFL0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234166AbhGFLXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531F561CD1;
        Tue,  6 Jul 2021 11:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570296;
        bh=+Lx/Ybu2Aq/kX7lL1Obv6xgjVcG9zJEyTOFHv8wmvHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6ULEqWpnUQkFlAx1oclnFU6+ATTgcmo5Nx7pZ00Oba5o+YWc/hXPcgYQfYuknDQ1
         BkO+H6SjQ3FXwhsDlS0hurBkmw9O1d4DkjYWGESghGcG1SmdH8CPIJzqDMW4rzDjUp
         hISM6oPHOMyAeRr8/rqHycBztkaRqWdbZ5f0SxyhqLI5BrNlbnad+6H7Std3loMZCL
         AFNrsvc7m9JJAf1yj4zzW+UdJrGu+YnUKVdpGI3Ye+JjtkvZJSQtIq3xLKkkYtampJ
         ODjjB3/tDziO0akjPAcJ3kd4eZrevE98fI7VrkTYIIhea6afsfIHbR6sGFRqdZONCo
         via3rep2Ept6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     gushengxian <gushengxian@yulong.com>,
        gushengxian <13145886936@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 184/189] flow_offload: action should not be NULL when it is referenced
Date:   Tue,  6 Jul 2021 07:14:04 -0400
Message-Id: <20210706111409.2058071-184-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

[ Upstream commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a ]

"action" should not be NULL when it is referenced.

Signed-off-by: gushengxian <13145886936@163.com>
Signed-off-by: gushengxian <gushengxian@yulong.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_offload.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index dc5c1e69cd9f..69c9eabf8325 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -319,12 +319,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
 	if (flow_offload_has_one_action(action))
 		return true;
 
-	flow_action_for_each(i, action_entry, action) {
-		if (i && action_entry->hw_stats != last_hw_stats) {
-			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
-			return false;
+	if (action) {
+		flow_action_for_each(i, action_entry, action) {
+			if (i && action_entry->hw_stats != last_hw_stats) {
+				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
+				return false;
+			}
+			last_hw_stats = action_entry->hw_stats;
 		}
-		last_hw_stats = action_entry->hw_stats;
 	}
 	return true;
 }
-- 
2.30.2

