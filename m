Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A218432E45
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 08:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhJSG3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbhJSG3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 02:29:02 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDFFC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 23:26:49 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u8-20020a05600c440800b0030d90076dabso1283096wmn.1
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 23:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T3GJaGUMRU1cUcoEx8S8pRg7CxWQBhMFdydRT7Nj9P0=;
        b=DvMUK73nVtN8p4hmizLqdXAhdXx06s6iVfuUir2/t6AJi4USmbBCRKqxdGQ0oEkCP2
         /gEloT8BrbgBy/TkS3d4Nmm3jbUTi8NB9o5+pbXXz5cC5NFDINUURogOVvzUQdp/FYKc
         WiJS6MrA13+5tH2+e8HebZblNf41lDXF2G9H21T5I8caegQhLWnG7eLZx6SGxOYwml/s
         HwVJfl8cP0QoTx7Ny7WSK4U398HoYzXNOrlg4t3ODlZu+ZjUDg6zz+vhy5cuBH+0dKCL
         dmQtBA/kdbbZV/fl0bG3I7k3grsBi0MXko9Dx2i24XcOMjJpa5gZdGn9ypBmPYFLiOSj
         xFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T3GJaGUMRU1cUcoEx8S8pRg7CxWQBhMFdydRT7Nj9P0=;
        b=GcnjrWV2FAouyORTtanvFaD+emAmU7B1h1GdzxnYFoCa8RC1AA6VjCUl9EITArrkif
         YHfjV1SXUgM+5jXshL/8LUVkCUCFwPi2pFCpmPUDkMlLvJNDX5FJtwBZCWc0qyJfYWGi
         3QfH4F+qxOIwRkEfv5aSz4FK9jCLpVEEwnsfrn1S9cMqtL8qmja3HomHEggi+Q/0yo+U
         wZJm7vZ1PrX1oOjSVYoJ61qjkQxAnIqAh5c98ual3I3vrMTOor//w97JMyd8RvrjOrqK
         ux7bqcJeHSDZccTq109JUh24TPfBDmjhl5cc2/ajJd9dWDp10fe6BX2EBcqgvwfkVEFi
         9wIg==
X-Gm-Message-State: AOAM5330W4Z/zzdFN/whF11OlApJdbGQyce6AOvhgipndq1EJ6dzYpQ6
        6MFpqkJBvR93mMF6OrMKqKVo0Yckzs8uXw==
X-Google-Smtp-Source: ABdhPJzran8eQR0cC9bzcQ9SGzbLTYgrsCS+3IKm1p05qltsR458UthsYbEYNMVP2o99pI2wYwe09A==
X-Received: by 2002:a1c:7918:: with SMTP id l24mr3859096wme.137.1634624808272;
        Mon, 18 Oct 2021 23:26:48 -0700 (PDT)
Received: from localhost (tor-exit-15.zbau.f3netze.de. [185.220.100.242])
        by smtp.gmail.com with ESMTPSA id y8sm1261287wmi.43.2021.10.18.23.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 23:26:47 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: qed_ptp: fix redundant check of rc and against -EINVAL
Date:   Tue, 19 Oct 2021 00:26:41 -0600
Message-Id: <492df79e1ae204ec455973e22002ca2c62c41d1e.1634621525.git.sakiwit@gmail.com>
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
avoid repeating the same operation.

With this change, we could also use constant 0 for return.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
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
