Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E3717293F
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgB0UH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:07:57 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54621 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbgB0UH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 15:07:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id z12so796519wmi.4
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vIQsQk+EUHwRTqH4dNucAbOQNevrI2BA1Idy72ybenY=;
        b=oLWjuFjLWbJYb2b0UrzBM/LJzsUrutTigAoaJgb24gEo702hg4atahTlc+vVM/SgEk
         hsCFfmhxatCg1ZUAOsCyZqcAUAx/w4nD2oeZazfwRC+XkMMcLrF56qnvrMnF9OqgdfPp
         jlCFPge8EW+5n1uNInJIIl0bIbh7o3VUGV1uaX+ATHz84jJn4f4G/9kBLBl3u+RLiLJO
         xEbCETbliPAMHf2sMtrnp+bczNASNVaATCYdid7j/zWW3fADRhwvjSC4uMy8jmgmqxCk
         /7Oov6xI4W6kQYYzMxz26TNeTY5pw0+6E1HGrMzTOy04oGXKHXagwwHZ5tJ9tmySZ1MR
         4uLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vIQsQk+EUHwRTqH4dNucAbOQNevrI2BA1Idy72ybenY=;
        b=BfMq9Qqh/eZiOEf9oRISeQOwe/sshUNUSoEpWHAUSjfoMa5fy8iazwMgZ9Yqf+ocEq
         IXJxwPs7DiDbpO6IA4/I2iKV56l11Q2ewG7cOxIOyDtH9vnpSwYfkIiNTsF9IV20SJ83
         dPAIGsXK5OI4ic0M0D0F23dNhBS4TRC5PnQD0RwakjHjDlSpbrAfted4y8IdnA2UX+wY
         X55t0pnnujb6XraHX+LZKiJBrfRbT8foJf0l9vKnPXEAEyYnXUSUGmLCgdqjI9lzbvwF
         wtRfT50cOJiya4g9+KO6zC5wD0YgsvcJAFQpBAnqW4vB/uUAMXczyn8CuEW6EtXN7BxI
         psDw==
X-Gm-Message-State: APjAAAX6f7GjFDz5qwyN3h8xQzVL8GF0MIjTQ57t37DBODZjg3lgNyyh
        IxGomZzSOqht8ZWqFt5c1mVxOU5agjo=
X-Google-Smtp-Source: APXvYqwrCTltIJtJ3VUPGrdrToAzMy5PfSy9W7b9h3A5QX/s3XdTCT9cMF2PDqY7+uPdptLYya0uYQ==
X-Received: by 2002:a05:600c:2154:: with SMTP id v20mr407166wml.175.1582834074536;
        Thu, 27 Feb 2020 12:07:54 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a62sm9238549wmh.33.2020.02.27.12.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 12:07:54 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net] mlxsw: pci: Wait longer before accessing the device after reset
Date:   Thu, 27 Feb 2020 21:07:53 +0100
Message-Id: <20200227200753.22235-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

During initialization the driver issues a reset to the device and waits
for 100ms before checking if the firmware is ready. The waiting is
necessary because before that the device is irresponsive and the first
read can result in a completion timeout.

While 100ms is sufficient for Spectrum-1 and Spectrum-2, it is
insufficient for Spectrum-3.

Fix this by increasing the timeout to 200ms.

Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index e0d7d2d9a0c8..43fa8c85b5d9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -28,7 +28,7 @@
 #define MLXSW_PCI_SW_RESET			0xF0010
 #define MLXSW_PCI_SW_RESET_RST_BIT		BIT(0)
 #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
-#define MLXSW_PCI_SW_RESET_WAIT_MSECS		100
+#define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
 #define MLXSW_PCI_FW_READY			0xA1844
 #define MLXSW_PCI_FW_READY_MASK			0xFFFF
 #define MLXSW_PCI_FW_READY_MAGIC		0x5E
-- 
2.21.1

