Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50D523E809
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 09:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHGHgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 03:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHGHgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 03:36:41 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E940C061574;
        Fri,  7 Aug 2020 00:36:40 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id di22so565534edb.12;
        Fri, 07 Aug 2020 00:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XAJh7Wq8xWsRktQCsitdvt6nrYWh3BFqhkIdPITapOk=;
        b=Bp4YEUczP7DzA4HV0jyvpqnsF+PA6c5Xx0grNUX0zMe6PEyJeSMEficxoE8Ldq5TnD
         TV9bIR9Sn6zPLI49uU49oVNdPgtd5+Nm64IasIgfC9zu+SrhvXXiCIQBhCRiJ8IfFohj
         TQCG+QxFo7jW9dZ1gVaLYBmre7lZLoCClI4aZRvuZ9jnOF2EqcVEY3JKDvH0SJFekMsf
         c6a+8s15I/zttdYfbAmkAKQOCuee074YZ7wlTlTduZ1Lk89p265yF7+hapjzr7Lm6GOl
         eWPKbTCHbuWEFDTERWv+5MlW5LQsohBo2xmBLLyXd2KY2X/SD4Ahcd+ZiJ7H61GeA1TE
         befg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XAJh7Wq8xWsRktQCsitdvt6nrYWh3BFqhkIdPITapOk=;
        b=i7G41d/P1uq/ZwBeUJqgXwnqiKUV0sl/JnMow8EBgJJLYbHPLT/4DUBcz8j9iWvKoV
         DZ96aUMLyn8HC/KKxFG+59lrOq0V2rpUAT2M7Dft1tshuDOc0/HXVpsZqmaFjQ+CGVCK
         /IAcZ8jBuRbdpRF8NkPuSFpbezlA4udcXni1/pQDQgQOsXrn6trClP3lMBOSwPru8u4P
         P84m1xUDa1hnWps/obgUEwuuPaJzI9rf/uTWSYpKvU6PfS71kWLBBS0UoB+9F3lYHG8Z
         5RyJ2u12SKfIbhZIUK3giNRbalI1s5T/yW3BH+qGZylU35DqLvSOek2n2aS1jHLNvGsn
         aEMg==
X-Gm-Message-State: AOAM531P8T5A9Hgz/pjNIsMsPhlPRTAZefIiqMJ+NimqZcG+QFLKQ4gT
        0ZGw8ehX7RyGp38ARdiVRS0=
X-Google-Smtp-Source: ABdhPJzATNqR4z/wNtCRVMOxoBeUTjuVlfMcPCA5ZKPbHrsmH8NImzeV6dZAVIwYfFjJBGoGYTm7EA==
X-Received: by 2002:a50:a2e6:: with SMTP id 93mr7314520edm.147.1596785799210;
        Fri, 07 Aug 2020 00:36:39 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id o25sm694060ejm.34.2020.08.07.00.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 00:36:37 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, EJ Hsu <ejh@nvidia.com>
Subject: [PATCH net] r8152: Use MAC address from correct device tree node
Date:   Fri,  7 Aug 2020 09:36:32 +0200
Message-Id: <20200807073632.63057-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Query the USB device's device tree node when looking for a MAC address.
The struct device embedded into the struct net_device does not have a
device tree node attached at all.

The reason why this went unnoticed is because the system where this was
tested was one of the few development units that had its OTP programmed,
as opposed to production systems where the MAC address is stored in a
separate EEPROM and is passed via device tree by the firmware.

Reported-by: EJ Hsu <ejh@nvidia.com>
Fixes: acb6d3771a03 ("r8152: Use MAC address from device tree if available")
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 7d39f998535d..2b02fefd094d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1504,7 +1504,7 @@ static int determine_ethernet_addr(struct r8152 *tp, struct sockaddr *sa)
 
 	sa->sa_family = dev->type;
 
-	ret = eth_platform_get_mac_address(&dev->dev, sa->sa_data);
+	ret = eth_platform_get_mac_address(&tp->udev->dev, sa->sa_data);
 	if (ret < 0) {
 		if (tp->version == RTL_VER_01) {
 			ret = pla_ocp_read(tp, PLA_IDR, 8, sa->sa_data);
-- 
2.27.0

