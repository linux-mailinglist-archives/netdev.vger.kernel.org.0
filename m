Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B44C215954
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgGFO0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729316AbgGFO0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:26:45 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E16CC061755;
        Mon,  6 Jul 2020 07:26:45 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e4so45644945ljn.4;
        Mon, 06 Jul 2020 07:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I9zWyh5IRnPtslhUp0gx5s8P6pChDI6lXjljvVorqz0=;
        b=GLyPYVQLzWgfduWMlQwvKC2vOrQsfzPP/5SXEwthVMiu5k3fPmEsJrCiqTb8eM+BPp
         DoYp5u2favnc83oPc+/qTFhvTr+bw9WiRkhXYzjU7wU9TQImWzt/etIBwBzJws44pBcE
         z/TVLO9eBVqJ265t2FUQoEUeMf/HiXYKVD9/jcvEEMNVjczeI1gy8u5soi2wRGl4XE5p
         GD0Y9qJG0Nh6dtsNozVtsYLsFwDwIVHFhaKkagyndIi5y9Emfrecy1ISdcKxVBnlQPkl
         m1HoxL55rkMH3eKues5DYexJZpFPvkTIxkz2OvvUaCqMX266nB2rXysZ4fBKTOMPpBK6
         7TEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I9zWyh5IRnPtslhUp0gx5s8P6pChDI6lXjljvVorqz0=;
        b=Nmh70qxO39MBSYO2btURnLx8YNBVNLWES5WwdF6ISGcSsrariBoYZ4EaNF7tbHUT6j
         6v4KTSBDZZlOnI5p4t0p3OOj3XCMgltoUJxoTGFQIvZ798gZrKMiIw10f67EdSVq53+7
         LnixgYi6eRKcrIRU6i9ZAvZ/N34mEXIzCoO8lsdDmwKdEMgckVXaaFFztkt2d3eghkwZ
         0NdncVhbeCQg4uV1T+j5CH6fW9eC4cAiM8u+LnnkMtx3Yi6OBk9DfV7GvkpL11BprIea
         +J6MhHe7xt9bef4R/eS9PX771jcbPrBWC/Ol3vnw4Na6BQ5lHQQVdss7X30J1Z/fQ5Bz
         fL6Q==
X-Gm-Message-State: AOAM533ryezyeYsJDQDDbsPiqu7+kYdiG422RspRUt/TQSSBaHen46fZ
        EcE2PlUlyFPSOXcv4FOo/YP5Jp2g
X-Google-Smtp-Source: ABdhPJwjld0HsWrGlQS8J4OCk+h8FlvHfwPR9qYPBxe55ZfMFg2DOBZnF5QB+LUekRj1jCJL2d2MEQ==
X-Received: by 2002:a05:651c:c5:: with SMTP id 5mr3194693ljr.9.1594045603550;
        Mon, 06 Jul 2020 07:26:43 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id m14sm11744638lfp.18.2020.07.06.07.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:26:43 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH  5/5] net: fec: replace snprintf() with strlcpy() in fec_ptp_init()
Date:   Mon,  6 Jul 2020 17:26:16 +0300
Message-Id: <20200706142616.25192-6-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200706142616.25192-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to use snprintf() on a constant string, nor using magic
constant in the fixed code was a good idea.

Signed-off-by: Sergey Organov <sorganov@gmail.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 4152cae..a0c1f44 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -582,7 +582,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	int ret;
 
 	fep->ptp_caps.owner = THIS_MODULE;
-	snprintf(fep->ptp_caps.name, 16, "fec ptp");
+	strlcpy(fep->ptp_caps.name, "fec ptp", sizeof(fep->ptp_caps.name));
 
 	fep->ptp_caps.max_adj = 250000000;
 	fep->ptp_caps.n_alarm = 0;
-- 
2.10.0.1.g57b01a3

