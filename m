Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F236621595E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgGFO1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgGFO0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:26:42 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52046C061755;
        Mon,  6 Jul 2020 07:26:42 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q7so32362007ljm.1;
        Mon, 06 Jul 2020 07:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LoW8u3CJbGnQcSN5oUo2pqe9I9oHO/HcdF24ejHJjeM=;
        b=Yg1OYRQSfl8v6osshPWY+WVwi59YSSbzCFF666u1Z195pNZbvy/GUr4IWsy4pqyGwP
         ILr6bbsolt0IXrVbLzqtMLRyG/RNeMLe/30rRLo0WF7GePwy9kLmMjHeR3j8chHUTG9I
         Z3Io6lYq51PXUfnvi9UxyGBIUuWd1qKnWMiVDPBqD/VOr8ovqPcgYRI+AFZn0wfDtgNj
         3oV2/8JtK81TRuOSzhHzvox8WdECtCXzfu+FT1Y3N95VFF4nwoR2C3I/zHIr/RSR7agf
         K3piCBZQw1Cs/TTpIv6qQiKCUDX5jgRvgltKSAinI+qqhiIPfKWTXmol5YBVSKFPxuVh
         5eqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LoW8u3CJbGnQcSN5oUo2pqe9I9oHO/HcdF24ejHJjeM=;
        b=r9noNW//Rds3qrWvOyyv5WNMDo5YMk81na/cLhzPD2jHa9ZQtHnUzPhKkACBGr4ftB
         NqihdrI22nNb08U39njlFG6UffOGWeVHvkBVoLyVfdZ/ORGK6yXxawgHJSfUNXdCTkJ8
         Y8hCiNgqe8OxQOHsQGXKY2AeS1qkQETm1Uu/rYM2UmGfTw+84pKz0gp/vET9Xhm5nhnx
         zZOcDtJO6dBnLm2H594oE/TuldmuOBWytFfC86Lk+SXFsaWxT6pAJrWcL3YUyqFpuBzK
         rinWP4X5+DgZ35aef6n4x4sLW7ZzUMPjr8MMHeE7p4de3CrYadue6h+PyKaFTPy8B4LU
         ho4w==
X-Gm-Message-State: AOAM5315XHWim+keK9yJdWZmiDmjGv/VldWaM8jfipZBRsZNQexRmZoM
        R3U4/KnK94EEQxilVW4tFPUC6q+8
X-Google-Smtp-Source: ABdhPJzYxNACpvF7XyLDUIwU0QYMnL6QZ+LN7M//DxgSNuxPiB3qa6TBK7Ye+P/Zhk2WP/ajC2yDYA==
X-Received: by 2002:a2e:954c:: with SMTP id t12mr27080619ljh.287.1594045600549;
        Mon, 06 Jul 2020 07:26:40 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id m14sm11744638lfp.18.2020.07.06.07.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:26:40 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH  2/5] net: fec: enable to use PPS feature without time stamping
Date:   Mon,  6 Jul 2020 17:26:13 +0300
Message-Id: <20200706142616.25192-3-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200706142616.25192-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PPS feature could be useful even when hardware time stamping
of network packets is not in use, so remove offending check
for this condition from fec_ptp_enable_pps().

Signed-off-by: Sergey Organov <sorganov@gmail.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index f8a592c..4a12086 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -103,11 +103,6 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 	u64 ns;
 	val = 0;
 
-	if (!(fep->hwts_tx_en || fep->hwts_rx_en)) {
-		dev_err(&fep->pdev->dev, "No ptp stack is running\n");
-		return -EINVAL;
-	}
-
 	if (fep->pps_enable == enable)
 		return 0;
 
-- 
2.10.0.1.g57b01a3

