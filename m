Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE23CA8ACE
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbfIDQAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732771AbfIDQAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C30A22CF7;
        Wed,  4 Sep 2019 16:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612837;
        bh=6fqBZnqQpxCIse9H8W99MnTop6fF0NhNRxtQG6Zy2QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhvmkZFYG3SF62MAt8Em+jEaRVcKpJPKxAXjTkJqnVdg2uJozp2cqOC3hd9HEgcI8
         6AhQnkTYGzc9mwEPvjHOzMMvvzrZyPaRbHr85CV8zSyHyO6LtdUuQjouOarNiJDq8y
         mbvnd7XlfaWRkfFMwD1ESowf6UItz7Y5WcKMTl3w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/52] qed: Add cleanup in qed_slowpath_start()
Date:   Wed,  4 Sep 2019 11:59:36 -0400
Message-Id: <20190904160004.3671-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit de0e4fd2f07ce3bbdb69dfb8d9426b7227451b69 ]

If qed_mcp_send_drv_version() fails, no cleanup is executed, leading to
memory leaks. To fix this issue, introduce the label 'err4' to perform the
cleanup work before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index cf3b0e3dc350c..637687b766ff0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1150,7 +1150,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 					      &drv_version);
 		if (rc) {
 			DP_NOTICE(cdev, "Failed sending drv version command\n");
-			return rc;
+			goto err4;
 		}
 	}
 
@@ -1158,6 +1158,8 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 
 	return 0;
 
+err4:
+	qed_ll2_dealloc_if(cdev);
 err3:
 	qed_hw_stop(cdev);
 err2:
-- 
2.20.1

