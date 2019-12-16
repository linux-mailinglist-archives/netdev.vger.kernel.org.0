Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7871216FE
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbfLPSdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:33:12 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34787 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730720AbfLPSdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:33:01 -0500
Received: by mail-pg1-f193.google.com with SMTP id r11so4199497pgf.1
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 10:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LsjRazNxwIjB/kfHtlv+QoNeEmV3wJwVhLTpn5ed/GQ=;
        b=EPNmuv7MqNfortefo8XxuPcLZY3v2+0pE/+qs5Mn/GhZSLiGYUEIFwOATXAMBhey5i
         evD1gcEeThnipE0cQo9oRKVuW70omJvIx4KGpA+ONYBCnaayq7479PtwTiK8fkQd9PJp
         jXXnQczA3ti83FYCWD7QEfUngm2rHMWv3dj0nz4B5fYnwVA2FhEQA5kQXsvZPTj65Zpq
         W4d6W2uJkoTEJDk4HWbJ3J89oMQwwpfoBnsuSos7jCnUphCmRT2XJDKGYAlDyApOzjHy
         zx0KYeSXpgtcgoy0tJWJ6OZa0xqM3icfHeXZLiRB3vfkEhC0TzBI/R7nPp4RYRIcGvyz
         5J3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LsjRazNxwIjB/kfHtlv+QoNeEmV3wJwVhLTpn5ed/GQ=;
        b=E/NSBA6eaYQR7FUrcOzVLvuSRsZtanVpmpgMWfZIeE5dyKYzyw0ZVggR079RvCPnQw
         xtWGJ3/faMnJm0ZW/SR1HUAxr/DoC1NHr/Yeqe33c9/He1DobXLlRePcI31LDCLdTqmX
         W1IHMs2qS89fjO1ReCNP1dI7eSwsGaRa9Prn6yMsB0ozMD97smAfKuXWl632EPntD15J
         MOFxTeXJXQ5ROqIe9RDgYfDnO743HyVdsPvZXjs8khSSvmVRtECLEeEORXeAA2m7mvFj
         f55+glXpZlT9wbj+FXN1T3jyne7vBDSWJhqNnluFbSWQ2y5X2d4LTtL/722GAZ+VtFZp
         gPXQ==
X-Gm-Message-State: APjAAAW/2oxAsFlBUKndVCSyKVH69qH72qvdmCRVf3gsvbBFvy7KNTvM
        Ssvoy9+kKsscB7priHrULRoYVhZ6
X-Google-Smtp-Source: APXvYqywyd+9sNBYjD8oNqLxF1Md9OVBnbnTKmYuQP3g7+J+J1BRsdzZYnneQ8i6drfpJFAw5/qcJg==
X-Received: by 2002:a63:d62:: with SMTP id 34mr20598440pgn.268.1576521180321;
        Mon, 16 Dec 2019 10:33:00 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d65sm23400738pfa.159.2019.12.16.10.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:32:59 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 1/3] net: axienet: Propagate registration errors during probe.
Date:   Mon, 16 Dec 2019 10:32:54 -0800
Message-Id: <42ed0fb7ef99101d6fd8b799bccb6e2d746939c2.1576520432.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576520432.git.richardcochran@gmail.com>
References: <cover.1576520432.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function, axienet_mdio_setup(), calls of_mdiobus_register() which
might return EDEFER_PROBE.  However, this error is not propagated to
the driver's probe method, and so deferred registration cannot happen.
This patch fixes the issue by handling the error code properly.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 20746b801959..53644abe52da 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1835,9 +1835,10 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 
 		ret = axienet_mdio_setup(lp);
-		if (ret)
-			dev_warn(&pdev->dev,
-				 "error registering MDIO bus: %d\n", ret);
+		if (ret) {
+			dev_err(&pdev->dev, "error registering MDIO bus\n");
+			goto free_netdev;
+		}
 	}
 
 	lp->phylink_config.dev = &ndev->dev;
-- 
2.20.1

