Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A494A8E32
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355283AbiBCUfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354098AbiBCUdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:33:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BCDC061793;
        Thu,  3 Feb 2022 12:33:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52A1A61A04;
        Thu,  3 Feb 2022 20:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940DEC340EF;
        Thu,  3 Feb 2022 20:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920387;
        bh=0y/IZM+9R7R9WIPYSINAAR4GixoHnxscFamQq446Yng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzvcUENgy1RX49AMRjkBaQ58+LAQ2sGsNadUiVU5bUonneUmXpU0UxJZvvHE/+a8r
         i8+I/mHssKMCjNZ2cNPP3u+o8eGVY7wtP5EcW3FA0ZAMfTTigsaYj5eZkvdTQs9vuq
         r80P6vZWKtPzol+0HD96jIXa3omTaFhkkz8qZ9ffphO30yU2SAHFSddI74obXVPCiY
         VrZw4M7rFNIbNGC1vYJp58KxtwcAdmyMxa/Qw/p+8T1q4kTNjinzlEE3Dxf074drqb
         RslYz4ihLKDoyV4qL4LzyB0ihbKW7zK5qAFcFT2IuFjh118YGwv9FAQtsr8IjpbiU1
         Ja0WVwKf6Faug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/41] sunrpc: Fix potential race conditions in rpc_sysfs_xprt_state_change()
Date:   Thu,  3 Feb 2022 15:32:17 -0500
Message-Id: <20220203203245.3007-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
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
index 379cf0e4d965b..326a31422a3c1 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -305,25 +305,28 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
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

