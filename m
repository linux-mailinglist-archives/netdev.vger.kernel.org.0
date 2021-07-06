Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFF53BD5D6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241823AbhGFMZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236973AbhGFLft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8DCD61C67;
        Tue,  6 Jul 2021 11:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570695;
        bh=39gpyIivHJFOU7uLtvdFVi/kaUVGioQxAgNGDj3CG5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQE8TVjY83gacYwi2BIxzJ4bUKXN8y+oYvi21XytYSSCLI4kVUUBUjL3cnk9Kakrn
         CwpMCkE19I6R/WfE9ULphEkbTIYY6vHjrfh/8OJU2U/UZkdMSVqGRit+oFMWUO5TAI
         qcon0NShyua9EgMrXpQjvvd7akrYmFmkZc+owWjokAPEQb/6meO86gGe5ET2f3bD0T
         NyQBktTyiWe1BFtVIa+Qja/MkHnWrpVRFLCE5DPbIaf2+jHdkWvtqEkHIXUhW1ih06
         9Ir0XTAqSR4vaAS8qUdrsG8670r9+1zrQaYgcDvssTcNRMzHQu1r6R4UbRnHQedqYw
         oIltyPSONl9fA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     gushengxian <gushengxian@yulong.com>,
        gushengxian <13145886936@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 133/137] flow_offload: action should not be NULL when it is referenced
Date:   Tue,  6 Jul 2021 07:21:59 -0400
Message-Id: <20210706112203.2062605-133-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 123b1e9ea304..161b90979038 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -312,12 +312,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
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

