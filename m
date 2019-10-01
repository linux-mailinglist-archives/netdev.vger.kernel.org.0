Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFC7C3D58
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbfJAQlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730733AbfJAQlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F32205C9;
        Tue,  1 Oct 2019 16:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948076;
        bh=o8YQWDq9izhWPzGb6JCcR7h6l1EMb//vReFY9UK3M6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcGQTTahDSfpTnSq8sL5U2NJjxymvre8GZoZxG2+erfKLYyfH8TTlado07qtvIdVS
         QyWXdSdR9fIqA7Jt+NIfwUnSqTeNpSYbDqTfKgLZspA6Cuqa4CtqWKtGLyfEI/1xOH
         nOfJijDTDn6d8KiAqysNL2B+Voajbk7iDh4izpek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 66/71] nfp: abm: fix memory leak in nfp_abm_u32_knode_replace
Date:   Tue,  1 Oct 2019 12:39:16 -0400
Message-Id: <20191001163922.14735-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 78beef629fd95be4ed853b2d37b832f766bd96ca ]

In nfp_abm_u32_knode_replace if the allocation for match fails it should
go to the error handling instead of returning. Updated other gotos to
have correct errno returned, too.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/abm/cls.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 23ebddfb95325..9f8a1f69c0c4c 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -176,8 +176,10 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 	u8 mask, val;
 	int err;
 
-	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
+	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack)) {
+		err = -EOPNOTSUPP;
 		goto err_delete;
+	}
 
 	tos_off = proto == htons(ETH_P_IP) ? 16 : 20;
 
@@ -198,14 +200,18 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 		if ((iter->val & cmask) == (val & cmask) &&
 		    iter->band != knode->res->classid) {
 			NL_SET_ERR_MSG_MOD(extack, "conflict with already offloaded filter");
+			err = -EOPNOTSUPP;
 			goto err_delete;
 		}
 	}
 
 	if (!match) {
 		match = kzalloc(sizeof(*match), GFP_KERNEL);
-		if (!match)
-			return -ENOMEM;
+		if (!match) {
+			err = -ENOMEM;
+			goto err_delete;
+		}
+
 		list_add(&match->list, &alink->dscp_map);
 	}
 	match->handle = knode->handle;
@@ -221,7 +227,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 
 err_delete:
 	nfp_abm_u32_knode_delete(alink, knode);
-	return -EOPNOTSUPP;
+	return err;
 }
 
 static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
-- 
2.20.1

