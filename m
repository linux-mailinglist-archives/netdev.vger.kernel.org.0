Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C8C3092DB
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhA3JFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbhA3Evg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 23:51:36 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6328EC0613D6;
        Fri, 29 Jan 2021 20:49:43 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id md11so6839677pjb.0;
        Fri, 29 Jan 2021 20:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W4ElXu2pfKkjYu5Tw1aWk15MrTDF5YFDL7qh1XByBdU=;
        b=ulPePdt06VqbRP2Ujk8YwZYWD5dPcMsw0esI2Kr6hHl3kPuXd0V04B5AbW06/iUh2y
         3X14k0FOC0gg9t8YTtoKOSq2e6ThnCsNEJ70mbaVC4gCQiUVYwsN7L+r29r0PVtPylXX
         o5JmE2gfJEG/K7qIyZesI2m/3vTR2RfJgCEkwyrCPgL2Yqi7W89kuV/BYkTWMQqESrRp
         MwADubfTtYYyqt0V7GOQLATuKMkGmP2nWnCHnKfqFaMH3WHwj8GhPuoIx0V54p1tIZcj
         5VGSqtyEqOd1GtazFyUH/Q9B7UVd7sWkoSfMrMHqxW8KG3XazWx/2vabz7LtN4o144mc
         bhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W4ElXu2pfKkjYu5Tw1aWk15MrTDF5YFDL7qh1XByBdU=;
        b=Eh+jvgKrGwpeLrGcHp6gU9kkTPw6wLshjjgoUqH70PkgLmU84MLj3ipRzS/pY7QRZ1
         ROhAZvFE7KnPLQT5rtY8kcpf9PCq3XzpqYVmiOCtlylwmw3xNDyQlcJLELxHlP8XRVty
         +WwKMCp7rqxoKQ/YmSzY8M9OMCsJWO/GsaYSL2CFQyRMARyavpIFl74ylt7i+1he5Ltu
         2i1GU8aFgZgYynvQR0n6Ip0AjDcOtl8/4yXm5NhgB5N28plni9zC5xBdvNFkJzTr73zp
         Hm9ntsdHn/JD3/q3AcI6FzIMjmp2nZLL9O29Ri79irLdjFtYyDeAypAYa9GK8a7Ir8Bi
         SopA==
X-Gm-Message-State: AOAM530k7bII9NQrtrMo842jK47BRQq9MV8Gv2VOvXNZN5+J6CGqoIZM
        7uNjrIZ2z8rjZQe2rUckE+M=
X-Google-Smtp-Source: ABdhPJz9rqRji737ivUghrqzFXycVYcDmyKV5BXhRQHvkmQmsOZi5IkJYmQS7gIvAzb9hG43ivNAbw==
X-Received: by 2002:a17:902:854b:b029:e1:1d90:f299 with SMTP id d11-20020a170902854bb02900e11d90f299mr7130144plo.15.1611982182581;
        Fri, 29 Jan 2021 20:49:42 -0800 (PST)
Received: from localhost ([2402:3a80:11ea:a43c:a2a4:c5ff:fe20:7222])
        by smtp.gmail.com with ESMTPSA id z201sm5385249pfc.157.2021.01.29.20.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 20:49:41 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     memxor@gmail.com, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: qlge/qlge_ethtool.c: Switch from strlcpy to strscpy
Date:   Sat, 30 Jan 2021 10:18:28 +0530
Message-Id: <20210130044828.121248-1-memxor@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strlcpy is marked as deprecated in Documentation/process/deprecated.rst,
and there is no functional difference when the caller expects truncation
(when not checking the return value). strscpy is relatively better as it
also avoids scanning the whole source string.

This silences the related checkpatch warnings from:
5dbdb2d87c29 ("checkpatch: prefer strscpy to strlcpy")

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 drivers/staging/qlge/qlge_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index a28f0254c..635d3338f 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -417,15 +417,15 @@ static void ql_get_drvinfo(struct net_device *ndev,
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
 
-	strlcpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, qlge_driver_version,
+	strscpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, qlge_driver_version,
 		sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "v%d.%d.%d",
 		 (qdev->fw_rev_id & 0x00ff0000) >> 16,
 		 (qdev->fw_rev_id & 0x0000ff00) >> 8,
 		 (qdev->fw_rev_id & 0x000000ff));
-	strlcpy(drvinfo->bus_info, pci_name(qdev->pdev),
+	strscpy(drvinfo->bus_info, pci_name(qdev->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
-- 
2.29.2

