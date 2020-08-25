Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7914F251AD1
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgHYOas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgHYOar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 10:30:47 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0B0C061574;
        Tue, 25 Aug 2020 07:30:46 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y3so12927420wrl.4;
        Tue, 25 Aug 2020 07:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S+6VLNo7jVsZMs96k3TAyrUWwYE2zYV0Z+aJV/lR5gQ=;
        b=g2MtYo/faVMcap4ysEZrl6A4Ung7mIbCAJzz7IoQg2X+KEOtDexjY0CKf8Abg88vvG
         Geq/Va9NTnsEEKdGFIwf1DmOJfz6rl8Tygzl3Gu+Bxfcsowzu0HwX+ESKQqjHlcJDi8T
         Jj7JyQce28dmgusLiUOufnJ4427xUcxw7in3DxCrzYllOrlU2+EUFmVQB/+7WiuWtHi9
         PIHRvDaAJfRuJ9xc7/m2djZ/BXv7lSgr2pleVUt8xCjDacc12/Pe8l32pRLqOYFpmvLq
         8Yo7E4+XE4yGU7lQpUesfKdJX1a4ihCgD580a6TarIKkbHFAJ2hfq94o7hxbENgd9Cfb
         Z1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S+6VLNo7jVsZMs96k3TAyrUWwYE2zYV0Z+aJV/lR5gQ=;
        b=KH7L8Dni9E3f8Qx02qPatPI7K2I+Adt4Srw8xsNsrkWNyYkgChsNPBeGy6kVLaylMZ
         PISnt2nqEV5nLa3I0euyks+yRDWZhca81qHiNwzAPv6ELIgPEIWWlXUOVJKNYifQGP4C
         gCJXQsmZ95zfu4NuwkOAteQtmyWQ3xjfnyn80zEd1oYnAwtyEUQsFvb3KGxlskzUULI7
         1PlRXjRBWHHHgub8vx9yV7Ku3OAcLhCeihsxeVs+K6KHnYAJeOcCsAlUwdA6lWaAWB7A
         mE4O5Elmyh3nskw4DE9GE1QuNlCd/r6uznpPltNftzVAns+Ix3A5pqYQ0P9FLpkVdXRB
         p6HQ==
X-Gm-Message-State: AOAM531XXDQJmGQtUaRGJUZDrEJxVZnh3cMvXiCADomaQjB5Irv9oBmq
        gIVSjdJfKrxczX2m0/DhbWo=
X-Google-Smtp-Source: ABdhPJxRIor0FRGt3Lk2eyf4YUKwzH2RveG1kfqYaMMOrZft0AIIOd3ZMew9upHyFc92y9jUmCye9Q==
X-Received: by 2002:adf:e6cc:: with SMTP id y12mr10863958wrm.391.1598365845380;
        Tue, 25 Aug 2020 07:30:45 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id j11sm30078337wrq.69.2020.08.25.07.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 07:30:44 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath11k: return error if firmware request fails
Date:   Tue, 25 Aug 2020 15:30:39 +0100
Message-Id: <20200825143040.233619-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ath11k_qmi_prepare_bdf_download(), ath11k_core_firmware_request() is
called, but the returned pointer is not checked for errors. Rather the
variable ret (which will always be zero) is checked by mistake. Fix
this and replace the various gotos with simple returns for clarity.

While we are at it, move the call to memset, as variable bd is not used
on all code paths.

Fixes: 7b57b2ddec21 ("ath11k: create a common function to request all firmware files")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 91134510364c..b906b50ee57e 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1868,16 +1868,16 @@ ath11k_qmi_prepare_bdf_download(struct ath11k_base *ab, int type,
 	const struct firmware *fw_entry;
 	struct ath11k_board_data bd;
 	u32 fw_size;
-	int ret = 0;
-
-	memset(&bd, 0, sizeof(bd));
+	int ret;
 
 	switch (type) {
 	case ATH11K_QMI_FILE_TYPE_BDF_GOLDEN:
+		memset(&bd, 0, sizeof(bd));
+
 		ret = ath11k_core_fetch_bdf(ab, &bd);
 		if (ret) {
 			ath11k_warn(ab, "qmi failed to load BDF\n");
-			goto out;
+			return ret;
 		}
 
 		fw_size = min_t(u32, ab->hw_params.fw.board_size, bd.len);
@@ -1886,10 +1886,11 @@ ath11k_qmi_prepare_bdf_download(struct ath11k_base *ab, int type,
 		break;
 	case ATH11K_QMI_FILE_TYPE_CALDATA:
 		fw_entry = ath11k_core_firmware_request(ab, ATH11K_DEFAULT_CAL_FILE);
-		if (ret) {
+		if (IS_ERR(fw_entry)) {
+			ret = PTR_ERR(fw_entry);
 			ath11k_warn(ab, "failed to load %s: %d\n",
 				    ATH11K_DEFAULT_CAL_FILE, ret);
-			goto out;
+			return ret;
 		}
 
 		fw_size = min_t(u32, ab->hw_params.fw.board_size,
@@ -1901,14 +1902,11 @@ ath11k_qmi_prepare_bdf_download(struct ath11k_base *ab, int type,
 		release_firmware(fw_entry);
 		break;
 	default:
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	req->total_size = fw_size;
-
-out:
-	return ret;
+	return 0;
 }
 
 static int ath11k_qmi_load_bdf_fixed_addr(struct ath11k_base *ab)
-- 
2.28.0

