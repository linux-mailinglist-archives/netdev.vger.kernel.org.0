Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B5A12BA2B
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfL0SQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbfL0SQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:16:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9231A208C4;
        Fri, 27 Dec 2019 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470569;
        bh=9PSO96laJwfTFN/udnzL7oFhHLs7x63cDkU5jvLE2Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AruFGMELk/ZI7voBbow4wpdh9hr9CtFCqY/IMgPRtatu6qZFt8AMH/CE0Deco7j/0
         z2wLewTJiF9K7+cnZ5lhU64a/yYYX9vatcYqZ2V/I6GteWTFAmBLhsMaXdA+3AZ/Ia
         Rplq1KbLT5v3zy6gnbOI52szzcbHKaSPK/n8tSOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 16/25] rfkill: Fix incorrect check to avoid NULL pointer dereference
Date:   Fri, 27 Dec 2019 13:15:40 -0500
Message-Id: <20191227181549.8040-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181549.8040-1-sashal@kernel.org>
References: <20191227181549.8040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 6fc232db9e8cd50b9b83534de9cd91ace711b2d7 ]

In rfkill_register, the struct rfkill pointer is first derefernced
and then checked for NULL. This patch removes the BUG_ON and returns
an error to the caller in case rfkill is NULL.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Link: https://lore.kernel.org/r/20191215153409.21696-1-pakki001@umn.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index cf5b69ab1829..ad927a6ca2a1 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -941,10 +941,13 @@ static void rfkill_sync_work(struct work_struct *work)
 int __must_check rfkill_register(struct rfkill *rfkill)
 {
 	static unsigned long rfkill_no;
-	struct device *dev = &rfkill->dev;
+	struct device *dev;
 	int error;
 
-	BUG_ON(!rfkill);
+	if (!rfkill)
+		return -EINVAL;
+
+	dev = &rfkill->dev;
 
 	mutex_lock(&rfkill_global_mutex);
 
-- 
2.20.1

