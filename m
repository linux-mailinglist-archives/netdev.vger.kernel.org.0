Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C58D432E46
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 08:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhJSG3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhJSG3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 02:29:08 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E557C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 23:26:56 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o24so3377783wms.0
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 23:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QIJSC3yJ+j+xGb3nbulYCDNwXu8i/S4uRwQ3RzYL4aA=;
        b=cr/K6ksQTDcyNpzngSb0y7WXOFgje/c0oVfi75EYSPOzOKeBpSVUiUqQJK49Lslm1P
         p94MpthP59I4hTIeaGPetClccpJPw3WRvlEbLWusfG6Ua1IUcClJJRYI4mZirLDc3qOA
         zJCn9C4SvmTKRhj+Q+PVPG2GELsVu5lARQC9LN1cbiYrz+VPdtaLJY//ygJL4KWCcw/l
         A+OSqH2IMPsz5eVrnxLjx+1rhfWRFz6ERDNh6cJj5gZB+wsgruy25Sw556Ku/NxX6deq
         0JivIKfoE5P0URot1zVqDbTn2JIuYmqVjfeDJiiEDvAG6JKfbE6Ls+UHhwnsixJL3bcw
         Y9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QIJSC3yJ+j+xGb3nbulYCDNwXu8i/S4uRwQ3RzYL4aA=;
        b=AlhVn5m7ayKn+8h18B40G23MHbuUEWlXJnwHW3nv4ciFXU6vYxAGP7XDTeuqdlmTyr
         PkuaPJxtyHuXTU6NTyud15iGuoIe+agtpcmHbx9pk7bPYcRB7lJJMKOtxohGd378RL+Z
         wJku2SuKcpvdLnP3+UUv5gSRHjvnpoSUmpOUCn2SMt7bAKl7fTEW8fcj3+kfuaWk7iuc
         +33vnte2GR2WIUP73v+F7bbfPMBWR3xIK4Lt4usYcdxZNrWqJ4/JoUEE1qvMGZbmwT8L
         tlkHtj7JorgS4w/zjhp7WHQqpLQBaRezbme7p59YKOjkQlWm1cF51oDEwgMSm9lbQLqU
         5M2g==
X-Gm-Message-State: AOAM533poTE9LpP6yHgD3Ct7lEYNTy7yeazZ4fcT8zssXW2jOLw/8bx7
        nN+U3NOal6xgs+x4jJ4b6lY=
X-Google-Smtp-Source: ABdhPJxNTgaJxNi+NYbu1ooEu0hA6tfhIuiJSjtpQaD2WFX8GMnbLpQJIeWc+Xc8D4Px8UE8j5QvTA==
X-Received: by 2002:a1c:44c:: with SMTP id 73mr3877874wme.45.1634624815012;
        Mon, 18 Oct 2021 23:26:55 -0700 (PDT)
Received: from localhost (tor-exit-15.zbau.f3netze.de. [185.220.100.242])
        by smtp.gmail.com with ESMTPSA id p11sm1630118wmi.0.2021.10.18.23.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 23:26:54 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: qed_dev: fix redundant check of rc and against -EINVAL
Date:   Tue, 19 Oct 2021 00:26:42 -0600
Message-Id: <b187bc8a2a12e20dd54bce71f7de0f8e7c45f249.1634621525.git.sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1634621525.git.sakiwit@gmail.com>
References: <cover.1634621525.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

We should first check rc alone and then check it against -EINVAL to
avoid repeating the same operation multiple times.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 35 +++++++++++++----------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 18f3bf7c4dfe..fe8bdb4523b5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3987,30 +3987,35 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 				       QED_RESC_LOCK_RESC_ALLOC, false);
 
 	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &resc_lock_params);
-	if (rc && rc != -EINVAL) {
-		return rc;
-	} else if (rc == -EINVAL) {
+	if (rc) {
+		if (rc != -EINVAL)
+			return rc;
+
 		DP_INFO(p_hwfn,
 			"Skip the max values setting of the soft resources since the resource lock is not supported by the MFW\n");
-	} else if (!rc && !resc_lock_params.b_granted) {
+	}
+
+	if (!resc_lock_params.b_granted) {
 		DP_NOTICE(p_hwfn,
 			  "Failed to acquire the resource lock for the resource allocation commands\n");
 		return -EBUSY;
-	} else {
-		rc = qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
-		if (rc && rc != -EINVAL) {
+	}
+
+	rc = qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
+	if (rc) {
+		if (rc != -EINVAL) {
 			DP_NOTICE(p_hwfn,
 				  "Failed to set the max values of the soft resources\n");
 			goto unlock_and_exit;
-		} else if (rc == -EINVAL) {
-			DP_INFO(p_hwfn,
-				"Skip the max values setting of the soft resources since it is not supported by the MFW\n");
-			rc = qed_mcp_resc_unlock(p_hwfn, p_ptt,
-						 &resc_unlock_params);
-			if (rc)
-				DP_INFO(p_hwfn,
-					"Failed to release the resource lock for the resource allocation commands\n");
 		}
+
+		DP_INFO(p_hwfn,
+			"Skip the max values setting of the soft resources since it is not supported by the MFW\n");
+		rc = qed_mcp_resc_unlock(p_hwfn, p_ptt,
+					 &resc_unlock_params);
+		if (rc)
+			DP_INFO(p_hwfn,
+				"Failed to release the resource lock for the resource allocation commands\n");
 	}
 
 	rc = qed_hw_set_resc_info(p_hwfn);
