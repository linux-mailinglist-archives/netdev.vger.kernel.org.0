Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED355FE6CC
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 04:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJNCF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 22:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJNCFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 22:05:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E83118C411;
        Thu, 13 Oct 2022 19:05:52 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so6620015pjs.0;
        Thu, 13 Oct 2022 19:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c8322atv62tEbkL85+mZmId4t2HkHpXWBmOWIZmHHKQ=;
        b=Cc7JU9HXA+772G/+ua4nvw3QiVXgSueeEMfZ6iovpja8xdMGbEGPbrkZolZ/MRFcPb
         Aasi8lDuwKwZS41+zerWUkzANCnzobhfGdtaCJO+bdGqCRbpJ9nL5vvUJYgYE3R2vnbg
         T7R8ZQ/jyQPT04iI9g5SOcIMU9m32RcHEdbNoF/jTyG1zgWPECvox9R8X6K7X/4nxCnA
         EKOzpZlRoHVJSoiP65R4YYSPfdu8jbjEmgZ4w4s83wCGQNh9ggbNUpKLrxOMESobhOO5
         XQjK9dkb+kirTXcYL98LWMsodpksl5QiKmB+Mdj6YUv3UJsnS1gBy6PEuYubkacoONI8
         BoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c8322atv62tEbkL85+mZmId4t2HkHpXWBmOWIZmHHKQ=;
        b=cjMlSjCd8VMhOv3w9B8GjIbDEXDJJUIOCMYQSEO4ExHkbE7H/sveyJpjjD4NDRIW6c
         sfL2+LYt1fVGkMg4o01flBSsX+8iDyrJyWsE41TSGeYJCti5gO/Vb/LEQrW3w//RbgT1
         6wxqRv8TDEQk6a9j0CsLEFgHzVw+R1BWOxiFuyCaEJqGekxk1SamDVkP/KiXyu3YSVT/
         JTBheVcv34GpBNtUifoI0vEP4f0JAalIJZFaUL3wVpI/vxHDHkvEfneZQf/8Zg2uKL4a
         EC7zK7InsosDVCPIGYNHSe8yV5KQFzsK/HcqJcSOtLRkj1iMQBxKTCelfx1zpeXPkejJ
         evZA==
X-Gm-Message-State: ACrzQf17BPOH13pNN8U83qmAG0hshEXNDTmDUNChcrkdkmc4UBVBXuYa
        t8s31T16pGocSua9kD0zWpM=
X-Google-Smtp-Source: AMsMyM7khLiq0I1JfGqVKyWARrvSFv8q7D3nfGQyKgCGthaf/7m/mWl11Br422vBZ3oOl8PNJftRTw==
X-Received: by 2002:a17:902:da91:b0:181:a0e6:5116 with SMTP id j17-20020a170902da9100b00181a0e65116mr2908309plx.57.1665713151092;
        Thu, 13 Oct 2022 19:05:51 -0700 (PDT)
Received: from localhost.localdomain ([43.128.11.181])
        by smtp.gmail.com with ESMTPSA id y24-20020aa79438000000b0056281da3bcbsm368804pfo.149.2022.10.13.19.05.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Oct 2022 19:05:50 -0700 (PDT)
From:   Xiaobo Liu <cppcoffee@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaobo Liu <cppcoffee@gmail.com>
Subject: [PATCH] net/atm: fix proc_mpc_write incorrect return value
Date:   Fri, 14 Oct 2022 10:05:40 +0800
Message-Id: <20221014020540.32114-1-cppcoffee@gmail.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Then the input contains '\0' or '\n', proc_mpc_write has read them,
so the return value needs +1.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>
---
 net/atm/mpoa_proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 829db9eba..aaf64b953 100755
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -219,11 +219,12 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 	if (!page)
 		return -ENOMEM;
 
-	for (p = page, len = 0; len < nbytes; p++, len++) {
+	for (p = page, len = 0; len < nbytes; p++) {
 		if (get_user(*p, buff++)) {
 			free_page((unsigned long)page);
 			return -EFAULT;
 		}
+		len += 1;
 		if (*p == '\0' || *p == '\n')
 			break;
 	}
-- 
2.21.0 (Apple Git-122.2)

