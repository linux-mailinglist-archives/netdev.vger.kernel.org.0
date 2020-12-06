Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8AB2D0711
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 21:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgLFULX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 15:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbgLFULW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 15:11:22 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7192C0613D0;
        Sun,  6 Dec 2020 12:10:42 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id lb18so3605648pjb.5;
        Sun, 06 Dec 2020 12:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYFrpSzggTewyuDDpq2534UTmRK88ibp9VGJZsjw6YQ=;
        b=dqxQuKG05rzMFQ6s97c9hCXa/gYpjCkspUbT4s8VqHatPwGIBehoto2SrnaZ+0eFOp
         E5YxRXRgt4fm3+yh4e6hYR1EnLfqiJvDGFZzuWxbov5eUbgz9pqC3RoCzViMiBOwbjNe
         JiPDh2dWOePCnSv2XeUssajbQ9wW4O6uUgGEkNCIPiWFseN8EnQIbhQ2BRvyWq13BadJ
         +yJgBwGL2FVaTRIoYc0B3CqZozpFEjtZWsKz7HFH79RvbfuPJVoTnbusp+QcoqG3uhia
         a0V9pxvKIZr1YRyzoE0vi8pUMhdHrNWqVAO4jave+Qt4F1LLjE66SuhnP8u12dLZQLBK
         GwKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYFrpSzggTewyuDDpq2534UTmRK88ibp9VGJZsjw6YQ=;
        b=b8WEIyR5DFy5/RqqEtfKYKpJv/XjL6h1bVioxZDU3zJK3PvGIcDj0unfbuTyQr9tdA
         EnXabaerlCg0Sxx4kX3deYIbiqSOxmhsWHLBD4iCDPETUu5XhR3pdloNajNhKNvAWhzR
         xq/2aU3jPMnAznQpwTCbPiA3+MATcm9tPCSeN5zDJsSD3a6dIRM3mH/szmWI0KkMuxf7
         W9rgzg+8wbazXk5dxcMRNJ6cO/gG0E0z3Ruf5RMFb5tlLfNAcu9L2try/0bsvB9KijzM
         ukarNEqD95hH32/8C7wJTuoW52Y44hSTXwytvOHWWCSogZfFWIOMAKjxIp5+0s2hoM1b
         JRGA==
X-Gm-Message-State: AOAM532bNfO7VnUqUrLtSZRP/unTs9rcwHlY9SsqDkk2ufPyUHyKdyQz
        TWsr2Pl6QMrNCEe21WMx6DQx/pV+PILARIas
X-Google-Smtp-Source: ABdhPJz/gfzHDtFsSUOTU3BeW3EUnFL8sMRicfRNBJ7REjfLB1mxujyffMqTtwR6aPHLsPsWk9xaUg==
X-Received: by 2002:a17:90a:b110:: with SMTP id z16mr7234190pjq.167.1607285442127;
        Sun, 06 Dec 2020 12:10:42 -0800 (PST)
Received: from localhost.localdomain ([124.253.53.149])
        by smtp.googlemail.com with ESMTPSA id y6sm21188295pjl.0.2020.12.06.12.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 12:10:41 -0800 (PST)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, kuba@kernel.org, netdev@vger.kernel.org,
        bjorn@helgaas.com, linux-pci@vger.kernel.org
Cc:     Puranjay Mohan <puranjay12@gmail.com>
Subject: [PATCH] drivers: broadcom: save return value of pci_find_capability() in u8
Date:   Mon,  7 Dec 2020 01:40:33 +0530
Message-Id: <20201206201033.21823-1-puranjay12@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Callers of pci_find_capability() should save the return value in u8.
change the type of pcix_cap from int to u8, to match the specification.

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 1000c894064f..f1781d2dce0b 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -3268,7 +3268,7 @@ struct tg3 {
 
 	int				pci_fn;
 	int				msi_cap;
-	int				pcix_cap;
+	u8				pcix_cap;
 	int				pcie_readrq;
 
 	struct mii_bus			*mdio_bus;
-- 
2.27.0

