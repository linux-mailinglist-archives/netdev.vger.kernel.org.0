Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21164A8D6C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354282AbiBCUad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:30:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354157AbiBCUaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F4D8B835A5;
        Thu,  3 Feb 2022 20:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DBAC340E8;
        Thu,  3 Feb 2022 20:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920208;
        bh=IbpWskCq2JHkLWQanpF+VpG9Upo9c0eksO/WL2vpMrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjiOCi6w5z9z26OcJP2Z6Rs9I5VsdRXHKwHo9XF+Gqumf524upJdIElDITiDoKrSV
         BlA1Za9teESGmviQoQ5qqO0x0KLdsuEaUxQWLz47YZQH8Eomdti15h+0NqAw93H4+x
         JZ2w5UKYMfm6lwm0qddPM/cc+JLPbtagmlqyFNqdQpRBcocn004xMod8MFRiyzVDHF
         nOAM6olrJiCkQ/Ezs+xSGSHjzEyXAK+Pxkc5mdTl7s6lgSMfRrAGprWiEQqEuHmtSP
         K/Cn/92mgJn78b6uY6IlHWe9Z/L6APKBVKdyOL5pVoifkK7ltNCnZZT3zAMQXd6nDj
         vhoPm+bTA4w4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 13/52] sunrpc: Fix potential race conditions in rpc_sysfs_xprt_state_change()
Date:   Thu,  3 Feb 2022 15:29:07 -0500
Message-Id: <20220203202947.2304-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 1a48db3fef499f615b56093947ec4b0d3d8e3021 ]

We need to use test_and_set_bit() when changing xprt state flags to
avoid potentially getting xps->xps_nactive out of sync.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sysfs.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 77e7d011c1ab1..8f309bcdf84fe 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -309,25 +309,28 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 		goto release_tasks;
 	}
 	if (offline) {
-		set_bit(XPRT_OFFLINE, &xprt->state);
-		spin_lock(&xps->xps_lock);
-		xps->xps_nactive--;
-		spin_unlock(&xps->xps_lock);
+		if (!test_and_set_bit(XPRT_OFFLINE, &xprt->state)) {
+			spin_lock(&xps->xps_lock);
+			xps->xps_nactive--;
+			spin_unlock(&xps->xps_lock);
+		}
 	} else if (online) {
-		clear_bit(XPRT_OFFLINE, &xprt->state);
-		spin_lock(&xps->xps_lock);
-		xps->xps_nactive++;
-		spin_unlock(&xps->xps_lock);
+		if (test_and_clear_bit(XPRT_OFFLINE, &xprt->state)) {
+			spin_lock(&xps->xps_lock);
+			xps->xps_nactive++;
+			spin_unlock(&xps->xps_lock);
+		}
 	} else if (remove) {
 		if (test_bit(XPRT_OFFLINE, &xprt->state)) {
-			set_bit(XPRT_REMOVE, &xprt->state);
-			xprt_force_disconnect(xprt);
-			if (test_bit(XPRT_CONNECTED, &xprt->state)) {
-				if (!xprt->sending.qlen &&
-				    !xprt->pending.qlen &&
-				    !xprt->backlog.qlen &&
-				    !atomic_long_read(&xprt->queuelen))
-					rpc_xprt_switch_remove_xprt(xps, xprt);
+			if (!test_and_set_bit(XPRT_REMOVE, &xprt->state)) {
+				xprt_force_disconnect(xprt);
+				if (test_bit(XPRT_CONNECTED, &xprt->state)) {
+					if (!xprt->sending.qlen &&
+					    !xprt->pending.qlen &&
+					    !xprt->backlog.qlen &&
+					    !atomic_long_read(&xprt->queuelen))
+						rpc_xprt_switch_remove_xprt(xps, xprt);
+				}
 			}
 		} else {
 			count = -EINVAL;
-- 
2.34.1

