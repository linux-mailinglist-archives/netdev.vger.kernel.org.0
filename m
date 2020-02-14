Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFD515F336
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgBNPxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:53:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbgBNPxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A387F24684;
        Fri, 14 Feb 2020 15:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695603;
        bh=8uG1pKmllG6vODb9BHuyO83kQ55D5RpViPviNkzTLOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+8Zl94HCHqp8B1zo1/LlsxYwRpPtk0LISeDxsFgWy9+nn0CWljM5vx83AN7pYql1
         3UR6EYdhxXSRbK3VahORgwCrrPSFZgi/YUsLzDms6xFh1inN1MjZjNT8gdqYykOX7q
         F9V+vjAMUM1Shztzav+03w74TvnELcMOOQVsCfB8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 207/542] Revert "nfp: abm: fix memory leak in nfp_abm_u32_knode_replace"
Date:   Fri, 14 Feb 2020 10:43:19 -0500
Message-Id: <20200214154854.6746-207-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 1d1997db870f4058676439ef7014390ba9e24eb2 ]

This reverts commit 78beef629fd9 ("nfp: abm: fix memory leak in
nfp_abm_u32_knode_replace").

The quoted commit does not fix anything and resulted in a bogus
CVE-2019-19076.

If match is NULL then it is known there is no matching entry in
list, hence, calling nfp_abm_u32_knode_delete() is pointless.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/abm/cls.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 9f8a1f69c0c4c..23ebddfb95325 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -176,10 +176,8 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 	u8 mask, val;
 	int err;
 
-	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack)) {
-		err = -EOPNOTSUPP;
+	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
 		goto err_delete;
-	}
 
 	tos_off = proto == htons(ETH_P_IP) ? 16 : 20;
 
@@ -200,18 +198,14 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 		if ((iter->val & cmask) == (val & cmask) &&
 		    iter->band != knode->res->classid) {
 			NL_SET_ERR_MSG_MOD(extack, "conflict with already offloaded filter");
-			err = -EOPNOTSUPP;
 			goto err_delete;
 		}
 	}
 
 	if (!match) {
 		match = kzalloc(sizeof(*match), GFP_KERNEL);
-		if (!match) {
-			err = -ENOMEM;
-			goto err_delete;
-		}
-
+		if (!match)
+			return -ENOMEM;
 		list_add(&match->list, &alink->dscp_map);
 	}
 	match->handle = knode->handle;
@@ -227,7 +221,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 
 err_delete:
 	nfp_abm_u32_knode_delete(alink, knode);
-	return err;
+	return -EOPNOTSUPP;
 }
 
 static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
-- 
2.20.1

