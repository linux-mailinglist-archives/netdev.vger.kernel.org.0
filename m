Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E392437085
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 05:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhJVDka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 23:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhJVDk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 23:40:29 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A917C061766
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 20:38:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n11so1804073plf.4
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 20:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Of3YKnTRn3u5CzD9gCv9m7aLwU5JnT9H9fbc3LybAE4=;
        b=PkqabWrTHhq+7m6FJ5Ng8hLr95mK27cSPVz+yxXKrJHPcCzZW3CKdtI4VdYNhLMSEw
         A3vtil+Lz7lsTAaynEIi8nl84D2ymC335wjjK8hbPbAbp7nhJhE0dUk825o7hMVeAjAV
         pildVo5fDPwHO4Vgrx2RjrertX6aVp4YbRNvqraDpDfaA4hlHLqalhksQHYI8mPNoWEI
         Pz+di38M4TeckMg2Mqa4YP3Wi63ERGsi/Sep2I16UH/RFqhRqvCXvdzvO1iu8DInoD72
         i+G5pq2lp+YtMV9ikCoX97BTsZW2fGgy2pxxgPF8sasG4QdRvjbYIkbLS5Z7JsWSclWZ
         +Uqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Of3YKnTRn3u5CzD9gCv9m7aLwU5JnT9H9fbc3LybAE4=;
        b=ZFe3wPpYe46h555qvDhCoqDKReiXpaPvE1U1ox0MtgjsUgLx+X6lgI0GIwfEvY+Pai
         F4tTgg0G2rYIPOeLBdjnF9XoenPhT6SHkfwx3j62F4mKumRWOxY5mRmAdseugJhS0yT0
         80IBWLRXR3CEG0Co332ZQuFigUlOBtDQTOVveVF2YZi8+rgANDe1MDOwC8bJ+DDA+pXI
         GYmMDJ8NL+2BT0lcFqht9cdzQ+otSyFJNZrdJuhfp0PFg36iLlq8yxTT96lb3FBykTJ6
         tO/cgpZ/NQPtqNP3k+BPJ/15/913MGYLzEbjmgxZFLc6n73MTl5LoqCoIvoL5CqKcimG
         7XEA==
X-Gm-Message-State: AOAM5318JPaPog7Ina7dq366Zuef/bUEWy8k9bfxAiPhvKd4dqHs8MAS
        FuLmtiwsUkJ85PrP/nSpehU=
X-Google-Smtp-Source: ABdhPJykuDKVo2+mz++PRu4qjMpynCW98JUkR3TP93e0PRBF0lxaUhEc/7IrkXfTq2Z3QC2UGXF/Og==
X-Received: by 2002:a17:90b:3a85:: with SMTP id om5mr11627761pjb.115.1634873892063;
        Thu, 21 Oct 2021 20:38:12 -0700 (PDT)
Received: from localhost ([23.129.64.158])
        by smtp.gmail.com with ESMTPSA id n14sm6573703pgd.68.2021.10.21.20.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 20:38:11 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/2] net: qed_ptp: fix redundant check of rc and against -EINVAL
Date:   Thu, 21 Oct 2021 21:37:42 -0600
Message-Id: <927234fe6f6d9d50b9803e57bb370f97342ae2f0.1634847661.git.sakiwit@gmail.com>
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
avoid repeating the same operation.

We should also remove the check of !rc in (!rc && !params.b_granted)
since it is always true.

With this change, we could also use constant 0 for return.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
---
v2:
(1) Add text for !rc removal in the changelog.
(2) Add Reviewed-by tag of Mr. Simon Horman.
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
index 2c62d732e5c2..c927ff409109 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -52,9 +52,9 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	qed_mcp_resc_lock_default_init(&params, NULL, resource, true);
 
 	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &params);
-	if (rc && rc != -EINVAL) {
-		return rc;
-	} else if (rc == -EINVAL) {
+	if (rc) {
+		if (rc != -EINVAL)
+			return rc;
 		/* MFW doesn't support resource locking, first PF on the port
 		 * has lock ownership.
 		 */
@@ -63,12 +63,14 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 		DP_INFO(p_hwfn, "PF doesn't have lock ownership\n");
 		return -EBUSY;
-	} else if (!rc && !params.b_granted) {
+	}
+
+	if (!params.b_granted) {
 		DP_INFO(p_hwfn, "Failed to acquire ptp resource lock\n");
 		return -EBUSY;
 	}
 
-	return rc;
+	return 0;
 }
 
 static int qed_ptp_res_unlock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
