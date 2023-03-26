Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B026C92A9
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 07:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjCZFm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 01:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCZFm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 01:42:26 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDD5449C;
        Sat, 25 Mar 2023 22:42:24 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-17683b570b8so6034143fac.13;
        Sat, 25 Mar 2023 22:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679809344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jH04qlqfc5qBZQ1rXFayew5ai68aCN4IVs+pY06TudM=;
        b=jce2BQZ4MjDiuRhthqYApKhiu+noOV1VnPDF4JVwB7MYEJ3+KPUcPBcSECou7kcWnS
         tb6JdW9lY7evJ2UNTwcdeXkGoAaHUL6ieOMWB+0YDrpEeX37I4IRlDl3D2DnzdiyKJFm
         T3ZZVFY23cvFxtZNG578sTxA8ikU5/O3ozglbidCtoPkknOal9mISE5NT5elGx2EKNoO
         idktaojTJq6DGO81hAJUDGlM2fTa3f3Q4pNm7KpWjYPBTHmg90tvxmVP/Yp8oO6XSH9x
         W54BC6+g+koeuaaZChObNfTaKIdZKdFVnlzuVi5TvC9jn7AzV5fliKVKhl4UkXrqBAlE
         v0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679809344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jH04qlqfc5qBZQ1rXFayew5ai68aCN4IVs+pY06TudM=;
        b=aQb4marxQt8UguTOwp7KcAlcKkhyLlu9miuDCB6DDahSsk4AOVFuiRVVO5/fMG38im
         H12NRSRuy5ceBYbR1ke+SGSiVCAv7E9khDs5k1kLQPwcEg3Lna+SkJoEUZfGjdEbDqrJ
         2J3xOY90UJKDdNwh+X+MwPGrfGyXE6QgorRPNXYoNF2ovt5LyESgY7MTWlfewTGbRybZ
         aAgmyB+PXW2R9oXTeOuJTX6O2KxbqwucW0aAWhBAGJeGxCZ4Ul8QjGyIrc0f2JA6THfX
         0oy0tnKZ1sn04WO9NpIfKXdQUHJGgnyi2r9GED8xtMkiREicQUoOnLzITZ7HkcAcj1LG
         yo+w==
X-Gm-Message-State: AAQBX9dHyJmIZ/+Rgtxy+7HG3NG26X84qUphqqBdOqdQJGul6DxnJqtw
        jP5d3X6wG/aU0+NZ9kmeSzw=
X-Google-Smtp-Source: AK7set8aRIJrMsuvoemf+QWRsC6nOiEI9SwNJgvbHSMXJe7iIbTZ03qgZxChoRma/qP2sSUe6TGc1Q==
X-Received: by 2002:a05:6870:210f:b0:17a:cc85:5b1e with SMTP id f15-20020a056870210f00b0017acc855b1emr5249207oae.3.1679809344303;
        Sat, 25 Mar 2023 22:42:24 -0700 (PDT)
Received: from chcpu13.cse.ust.hk (191host119.mobilenet.cse.ust.hk. [143.89.191.119])
        by smtp.gmail.com with ESMTPSA id w14-20020a056870b38e00b001723f29f6e2sm8820827oap.37.2023.03.25.22.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 22:42:23 -0700 (PDT)
From:   Wei Chen <harperchen1110@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH v2] rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_reg()
Date:   Sun, 26 Mar 2023 05:42:17 +0000
Message-Id: <20230326054217.93492-1-harperchen1110@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user or user-provided data buffer is
invalid, rtl_debugfs_set_write_reg should return negative error code instead
of a positive value count.

Fix this bug by returning correct error code. Moreover, the check of buffer
against null is removed since it will be handled by copy_from_user.

Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
---
Changes in v2:
 - Add fixes commit tag
 - Correct the subject prefix

 drivers/net/wireless/realtek/rtlwifi/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 0b1bc04cb6ad..3e7f9b4f1f19 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -278,8 +278,8 @@ static ssize_t rtl_debugfs_set_write_reg(struct file *filp,
 
 	tmp_len = (count > sizeof(tmp) - 1 ? sizeof(tmp) - 1 : count);
 
-	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
-		return count;
+	if (copy_from_user(tmp, buffer, tmp_len))
+		return -EFAULT;
 
 	tmp[tmp_len] = '\0';
 
@@ -287,7 +287,7 @@ static ssize_t rtl_debugfs_set_write_reg(struct file *filp,
 	num = sscanf(tmp, "%x %x %x", &addr, &val, &len);
 
 	if (num !=  3)
-		return count;
+		return -EINVAL;
 
 	switch (len) {
 	case 1:
-- 
2.25.1

