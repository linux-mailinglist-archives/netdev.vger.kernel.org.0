Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8570420596B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387511AbgFWRgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbgFWRgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 13:36:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CBA7207D0;
        Tue, 23 Jun 2020 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933770;
        bh=Ek0ULgVy39jBD8SSkFxugE25V40WPVHosBEnKWbkujI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BESqwDwCp+OcAN5fOS4tl1YtgtT2B8FDNKq+FpOPaSK2s75D6aDe3uVrLsrtIgKUs
         UmTWRENHQDUb6UQWiMYycHGErPr/PS0ZB0vVXhmvZEN0/Lk8NftBnVXT0FP6Afo8a1
         yChghWW2uOKl/Qpd8W/GaaJm/fqbE4iQdAh+oHVE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/24] test_objagg: Fix potential memory leak in error handling
Date:   Tue, 23 Jun 2020 13:35:44 -0400
Message-Id: <20200623173559.1355728-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173559.1355728-1-sashal@kernel.org>
References: <20200623173559.1355728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit a6379f0ad6375a707e915518ecd5c2270afcd395 ]

In case of failure of check_expect_hints_stats(), the resources
allocated by objagg_hints_get should be freed. The patch fixes
this issue.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_objagg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_objagg.c b/lib/test_objagg.c
index 72c1abfa154dc..da137939a4100 100644
--- a/lib/test_objagg.c
+++ b/lib/test_objagg.c
@@ -979,10 +979,10 @@ static int test_hints_case(const struct hints_case *hints_case)
 err_world2_obj_get:
 	for (i--; i >= 0; i--)
 		world_obj_put(&world2, objagg, hints_case->key_ids[i]);
-	objagg_hints_put(hints);
-	objagg_destroy(objagg2);
 	i = hints_case->key_ids_count;
+	objagg_destroy(objagg2);
 err_check_expect_hints_stats:
+	objagg_hints_put(hints);
 err_hints_get:
 err_check_expect_stats:
 err_world_obj_get:
-- 
2.25.1

