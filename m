Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3575B437084
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 05:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhJVDkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 23:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbhJVDkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 23:40:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC890C061766
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 20:38:02 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id g5so1819539plg.1
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 20:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XFHyBWIo8Rmp9KJl/2Jpr5MB6MTwQ9dvAVnHETi6YR8=;
        b=YA9ArQQ80eIhITwATJ4Y1wc9Ip4yhMnZ2IsDcpRMAuXKmy93uWijrnrBNIrx/7v16e
         INnAv0lIgcVGgD39Ujiahb+Lj0DnIVHeiXhx0avH2Dd9HdOw8zPm3ZFWjsIEXgBFOyOP
         1m/PsBHCNH/BMt3nPMQ4NftuYXLm4LqnjqxZxdoLuBqIW78Jy+2RsHY2HEHAZaaa8Wtu
         l/c3Sxgyjzk9hAMFHtQnIKq0uBUWbz6PICo9IdfAzAhQmBc8WnAn5gsCrcETDOCSGbbH
         p0fwZy3wFG1SBycyDHHnR+k5w4SHeDXWvoST817utFgQvC0eawVaCm29T17wWOOWh30/
         zUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XFHyBWIo8Rmp9KJl/2Jpr5MB6MTwQ9dvAVnHETi6YR8=;
        b=jA1+uwLLWQRV0yAxEHMyd1ypGcApk9wf9az9YUgB4Q/QywbVI2X/yaWdgLg63bqQ/0
         8JbDylPrX98y/KraPfzB9PSUIDYo0wy23uemOL5ET9DrFT5c43+a1qCWepM+j555YNLA
         fOMTgAyG9woRVYjyWvP4NkoHWI1kcqmNPekQq3RjjoYUw2I7YR4Kg0+CRpo1GxzvwpNU
         yvXJPWKHaxwPBZlzsB9BUVIunDpUK/fSaV4lFxJfAAnI3Jg8LnknPG73foXB4lrLlp8/
         yDxVOdcaRYsxXCJyev1U967ghXiggPHwa12/3D73xBHaYqBVRYX8FzNIe47IhHkjR6YU
         Os7A==
X-Gm-Message-State: AOAM533aEuVX+gSNmietp2/wHdRh1l93oSpMaGswRljIX2bw4+JmYfkn
        /Wuk90QQvymi/tYEXvTriHwxOWHylKDdDA==
X-Google-Smtp-Source: ABdhPJySGUQlTlQ9puq2uUXxih5E/8vxT2mLVD3OmsBkzt5bSEbVvUyy3BjUwXB8FYOkbOUHuxxxrA==
X-Received: by 2002:a17:902:6b48:b0:13f:903c:bc2e with SMTP id g8-20020a1709026b4800b0013f903cbc2emr8943886plt.68.1634873882389;
        Thu, 21 Oct 2021 20:38:02 -0700 (PDT)
Received: from localhost ([23.129.64.158])
        by smtp.gmail.com with ESMTPSA id c9sm6536016pgq.58.2021.10.21.20.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 20:38:01 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/2] net: qed_dev: fix redundant check of rc and against -EINVAL
Date:   Thu, 21 Oct 2021 21:37:41 -0600
Message-Id: <e7289c4e6a57f9a98a8f3fac1d5c7c181cbe8319.1634847661.git.sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1634847661.git.sakiwit@gmail.com>
References: <cover.1634847661.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

We should first check rc alone and then check it against -EINVAL to
avoid repeating the same operation multiple times.

We should also remove the check of !rc in this expression since it is
always true:

	(!rc && !resc_lock_params.b_granted)

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
v2:
(1) Fix missing else branch. I'm very sorry.
(2) Add text for !rc removal in the changelog.
(3) Put two lines of qed_mcp_resc_unlock() call into one.
    Thank you, Mr. Horman!
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 31 +++++++++++++----------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 18f3bf7c4dfe..4ae9867b2535 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3987,26 +3987,29 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 				       QED_RESC_LOCK_RESC_ALLOC, false);
 
 	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &resc_lock_params);
-	if (rc && rc != -EINVAL) {
-		return rc;
-	} else if (rc == -EINVAL) {
+	if (rc) {
+		if (rc != -EINVAL)
+			return rc;
 		DP_INFO(p_hwfn,
 			"Skip the max values setting of the soft resources since the resource lock is not supported by the MFW\n");
-	} else if (!rc && !resc_lock_params.b_granted) {
-		DP_NOTICE(p_hwfn,
-			  "Failed to acquire the resource lock for the resource allocation commands\n");
-		return -EBUSY;
 	} else {
-		rc = qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
-		if (rc && rc != -EINVAL) {
+		if (!resc_lock_params.b_granted) {
 			DP_NOTICE(p_hwfn,
-				  "Failed to set the max values of the soft resources\n");
-			goto unlock_and_exit;
-		} else if (rc == -EINVAL) {
+				  "Failed to acquire the resource lock for the resource allocation commands\n");
+			return -EBUSY;
+		}
+
+		rc = qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
+		if (rc) {
+			if (rc != -EINVAL) {
+				DP_NOTICE(p_hwfn,
+					  "Failed to set the max values of the soft resources\n");
+				goto unlock_and_exit;
+			}
+
 			DP_INFO(p_hwfn,
 				"Skip the max values setting of the soft resources since it is not supported by the MFW\n");
-			rc = qed_mcp_resc_unlock(p_hwfn, p_ptt,
-						 &resc_unlock_params);
+			rc = qed_mcp_resc_unlock(p_hwfn, p_ptt, &resc_unlock_params);
 			if (rc)
 				DP_INFO(p_hwfn,
 					"Failed to release the resource lock for the resource allocation commands\n");
