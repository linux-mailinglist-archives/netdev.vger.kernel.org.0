Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C538F226D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbfKFXQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:16:57 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45825 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfKFXQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:16:57 -0500
Received: by mail-pg1-f193.google.com with SMTP id w11so144161pga.12;
        Wed, 06 Nov 2019 15:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PEEwQUwm/mtCk8pRNL9DiIeL71bqH+DtmpEDVuEb4+U=;
        b=neaEdK/p5ar2I/xlFi4UuC6GILTW3Ks2guXTHYrzRYhhB5GJHWuYAmHteeS9QtXB38
         vpLKCrRcrgDtne+sUmpqEZdWMZsLWa5Ssry3hRvPt+l5AUgBe8AMaGUA2siXrzL8Tt84
         1eEY/yBnhOu6s1Y2lrffcUanSuXEiTYu3WyAp+so6Q1eXsx3jz708LQ6Mdq1uvSN8Vo7
         JJGPN6spp11oAjv6GnrPV+rZqhqQj9G6EdHNJEhFT0mtH6Yql9JJ7SVvWG6TjRr7Umk6
         c3P7nc+lnjR33OrTvZC29nfkOE2IsU3Xy0BVcshSmyKnj79HzS1hNJh1d56jWAFEUuZj
         ixbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PEEwQUwm/mtCk8pRNL9DiIeL71bqH+DtmpEDVuEb4+U=;
        b=RtgEvvQzJx/qMUL7ErGFfiO/PdxyuxaAuUBzXCZ5IplwODu5OCiLXB0h5/OPQjT/ZF
         uygXFgUMycmZDBBcjgY9TxY0RDtgwdiOIMSVLaLF4cbOdXQnBlLZMP5Vz3ysFIs13ckw
         3bJkqsZ4xQl1pYfGqq1G06bkbgRRD6uVp/u7tFx3Ib7zmMgFO8ZXWQr4w5+wXDpUHOtS
         WbundO8wIkqSYqx+5NiaXzkKLZZNk/IUhD5ypkLnIurQpynz6FHyVaxXjrPqFP9wsz4R
         MpzLQ9fMgNM9u83liXKkkDFQd5bS4MlKeAJn8kTRY0Aq2FOG0YKpmnyDb8onOtWDp+RW
         x1LQ==
X-Gm-Message-State: APjAAAXLc6ZlaGD5CX85kVpYmOCkdRSZQ3by+r2lLh4QJpIYtuEmaaGz
        5k09WM3WoKBnx2OQb9Zf8Lo=
X-Google-Smtp-Source: APXvYqy2/Y5pxVKOfsNfYmz4miHXZKCw3E8Ru4bwJEpq+vIruTB5jjvQyXI8vZKkp+EORx5jL/IDYA==
X-Received: by 2002:a17:90a:cd03:: with SMTP id d3mr506186pju.137.1573082214787;
        Wed, 06 Nov 2019 15:16:54 -0800 (PST)
Received: from aw-bldr-10.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d139sm49075pfd.162.2019.11.06.15.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 15:16:54 -0800 (PST)
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH] ath10k: Fix qmi init error handling
Date:   Wed,  6 Nov 2019 15:16:50 -0800
Message-Id: <20191106231650.1580-1-jeffrey.l.hugo@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ath10k_qmi_init() fails, the error handling does not free the irq
resources, which causes an issue if we EPROBE_DEFER as we'll attempt to
(re-)register irqs which are already registered.

Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index fc15a0037f0e..f2a0b7aaad3b 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1729,7 +1729,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	ret = ath10k_qmi_init(ar, msa_size);
 	if (ret) {
 		ath10k_warn(ar, "failed to register wlfw qmi client: %d\n", ret);
-		goto err_core_destroy;
+		goto err_free_irq;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
-- 
2.17.1

