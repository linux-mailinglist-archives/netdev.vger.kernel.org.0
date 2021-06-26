Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E953C3B4E71
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 14:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhFZMO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 08:14:28 -0400
Received: from m12-12.163.com ([220.181.12.12]:41747 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhFZMO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 08:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=tImSK
        /F39bvmRrrsa16KUI/wi6srsYxbkDnedrKfqkE=; b=cRVjAVyIrrXDY/RoAwomI
        emgzkBBTUup6mMHLPMa60aPYYwRmfUJ2jpSkbXA1rY3NctTOcLKphTYv83Lz3Xo6
        EhYoBAVW9ZIskepD430WHnZx3xO7mzw/D4S7cdFudJx6gXpSWuFxbq7om4H+14GI
        qkQo16Nfjneb1h7TloiCq4=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowAB3DivcFddgBaeYLw--.7765S2;
        Sat, 26 Jun 2021 19:56:13 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>,
        gushengxian <13145886936@163.com>
Subject: [PATCH] flow_offload: action should not be NULL when it is referenced
Date:   Sat, 26 Jun 2021 04:56:06 -0700
Message-Id: <20210626115606.1243151-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowAB3DivcFddgBaeYLw--.7765S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7XFW5Wr1kuw1ktFW8tFWkZwb_yoW8JryrpF
        ZrCry7CrZ7WryfCrZ3Za4IyrWUZrZxJr45tFWjq34fC343Kan5KFWkKry8Z34UJrW5ua4Y
        vasxuFyrJ3y5AaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jyMKXUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiXB29g1Xl0GGcWQAAs7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

"action" should not be NULL when it is referenced.

Signed-off-by: gushengxian <13145886936@163.com>
Signed-off-by: gushengxian <gushengxian@yulong.com>
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
2.25.1


