Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B6D366437
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 06:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhDUD64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 23:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbhDUD6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 23:58:50 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4B0C06174A;
        Tue, 20 Apr 2021 20:57:49 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id 66so20483643vsk.9;
        Tue, 20 Apr 2021 20:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E8CAy2FOK5MP3YhjQcRTqJ8/XAR13yrlpgrtJ1kyYpw=;
        b=XHhQIN1lvZ4138+FUR8wl1tywnXMlqlZa1xROykbs4jcqY0YZWfgoKQEz4WeRDxMJT
         ebX5wqmz/mmtPqOyG8qJf680wOLzZQLMgzIOHlUam3rDdV5NOtrtO0DFVXwRoE7z7n9h
         75+cldGA8B0vpPVZFuOdSPX/qHB0vorj7ZgPwkYkD39/OW2rF42AhKFCR2YFXIw5erwz
         ckDAn1ZiDyMhpWeC2nb0askuCmLU5ueBDFfodc1dvgAmJ4YADLv8lyv2pkL9rGpse9UL
         FCDyfe44aw8H1uAh/iwVaGg8ivEd7AJ82URhsYgNwG3QrYINWl8DfCXfpP43Lu4/njEN
         cGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E8CAy2FOK5MP3YhjQcRTqJ8/XAR13yrlpgrtJ1kyYpw=;
        b=GnkVEXBITBWfXy17ZtAbPT9u9HmP6djpkiOic/e7h/GZCkqEy8DJoaAxueer3aDgpw
         Z2fe6GsaYEBjq/Zrs/sKdyQJhZutqC7HK3LbNrF1EvagEOB/X31Jdh8NLuJYx/0AMV3C
         mucG5VJaT+1G2bSP1qzT+C0t0iJlWLSi2UBKyblyMCCXOElqz9FshNmZKCvFQRnmY1ps
         zEf388QKqbnI5ciQ5+Sb5+1sX+tWFNFc/+1pRnH3h/lh/4SJIF9jrKjajdbyvka5D2Yu
         qHg14tSAm+aB+5VPG7E2xvXWn+vYoNXH9EadFSXfJVX6HbcXiEH0pb43h36pinH/AyJC
         EBfw==
X-Gm-Message-State: AOAM531eb6+lYfKkEEzTJVv4ik++590fyO3saeqtO0KV/d0NbWDjx8qR
        k/e1iS23dtkj4yELH6pu/vk=
X-Google-Smtp-Source: ABdhPJw88bup3a30wXpbOE9m1dlVtHV4iQdDEaZ5lwRKjjDFqk008wuxoqLHYrs9Pc/RmqKhSTrTTQ==
X-Received: by 2002:a67:1e04:: with SMTP id e4mr23338871vse.52.1618977468911;
        Tue, 20 Apr 2021 20:57:48 -0700 (PDT)
Received: from localhost.localdomain ([87.101.93.188])
        by smtp.gmail.com with ESMTPSA id p8sm158389vsg.26.2021.04.20.20.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 20:57:48 -0700 (PDT)
From:   Jarvis Jiang <jarvis.w.jiang@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, loic.poulain@linaro.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarvis Jiang <jarvis.w.jiang@gmail.com>
Subject: [PATCH v1] net: Qcom WWAN control driver: fix the rx_budget was eaten incorrectly
Date:   Tue, 20 Apr 2021 20:56:16 -0700
Message-Id: <20210421035616.14540-1-jarvis.w.jiang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mhi_wwan_rx_budget_dec() should check the value of mhiwwan->rx_budget
before the decrement, not the value after decrement.

When mhiwwan->rx_budget = 1, mhi_wwan_rx_budget_dec() will always return
false, which will cause the mhi_wwan_ctrl_refill_work() not to queue rx
buffers to transfer ring any more, and rx will be stuck.

This patch was tested with Ubuntu 20.04 X86_64 PC as host

Signed-off-by: Jarvis Jiang <jarvis.w.jiang@gmail.com>
---
 drivers/net/wwan/mhi_wwan_ctrl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
index 11475ade4be5..721edf5a238f 100644
--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -56,12 +56,12 @@ static bool mhi_wwan_rx_budget_dec(struct mhi_wwan_dev *mhiwwan)
 
 	spin_lock(&mhiwwan->rx_lock);
 
-	if (mhiwwan->rx_budget)
-		mhiwwan->rx_budget--;
-
 	if (mhiwwan->rx_budget && test_bit(MHI_WWAN_RX_REFILL, &mhiwwan->flags))
 		ret = true;
 
+	if (mhiwwan->rx_budget)
+		mhiwwan->rx_budget--;
+
 	spin_unlock(&mhiwwan->rx_lock);
 
 	return ret;
-- 
2.25.1

