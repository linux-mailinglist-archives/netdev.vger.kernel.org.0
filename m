Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D143ACCBA
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhFRNwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbhFRNwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:52:35 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6BFC061574;
        Fri, 18 Jun 2021 06:50:26 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id b37so14087357ljr.13;
        Fri, 18 Jun 2021 06:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PF1lwVLZjO0TaZRIPSE+RYDa9z8BPF1tUWPYliWRKnc=;
        b=HNXfeSlEg8BXH11sQ4vpGj1n8hXO2g66OnPe8iX33KoxwRFq3Xw2r4ZMhqDyQUNttq
         55BcvKOnz8mw9DYDTCzab4t3h3LOi//dCYSbUst9nWsRkVxGIaPdV+7sLC4j/n+vXovo
         B4oa9Rq34Q/FqSz/S9AtSl2rlUj8CTkk87aULV5oZ+p8j0CgkhP7ZQ5LDFQ8GbazkpxT
         Hjx/U0d6o3tDfH6RsitHSwfIUaocAZrSCijVmUmNXvzkXOxiW6tmQiwPfjKgyLbM0YST
         +nN0JMwjrHlCaDBg3j8YhqR3Ti2KDaddq1o+Wmo8ZVwbieTCtlnSetjOzF1McbrbnAzg
         TIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PF1lwVLZjO0TaZRIPSE+RYDa9z8BPF1tUWPYliWRKnc=;
        b=sLJKmsIXmsNsSnLhCvG4BxTIDHgrvb+kzYh/AsT/S+fEt/iQrOddTyWE8UxJNrTiPx
         k/U8N8vgc+v/FwVsN3A12SCFYhpjOMKUUSXjpFTKpEoztzCoBIA6BEb/vfmWBEy1wXzD
         cjD1J3tho4t7nZmt2s7XcGjSo8rj32S8Qi2mcWMb4JCRdZR/mFhNiRVuHr0GD3iyVjht
         GlEXenQoGUAMMfduU0EDao0HawZjVddHUNw/EOoyiEjEndpAVkWRbxJHgvgTCbOPVtB1
         5pLRydToeywTcoq49lC0UjnKZHOElotRxliAsTL4rTeb3aqtsYEqii98fQM93mUHKKS2
         l3Vw==
X-Gm-Message-State: AOAM533+92PPalG8p4sxsZlCKHmFs7GVk2zNPiCm2wRcxHqqrcOlmvtU
        Fo/IS/YGvC2xoBvequn40KY=
X-Google-Smtp-Source: ABdhPJxrJ9TDOw/Wl4DcvgjPxkQjBduGj9Lc2qQ214ODXqD3Tm33ax8AK4edkHfd/5Z3WlnEQR+5Ig==
X-Received: by 2002:a2e:580e:: with SMTP id m14mr9599947ljb.197.1624024224596;
        Fri, 18 Jun 2021 06:50:24 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id r9sm918112lfm.158.2021.06.18.06.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:50:23 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     reksio@newterm.pl, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: ethernet: fix potential use-after-free in ec_bhf_remove
Date:   Fri, 18 Jun 2021 16:49:02 +0300
Message-Id: <20210618134902.9793-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

static void ec_bhf_remove(struct pci_dev *dev)
{
...
	struct ec_bhf_priv *priv = netdev_priv(net_dev);

	unregister_netdev(net_dev);
	free_netdev(net_dev);

	pci_iounmap(dev, priv->dma_io);
	pci_iounmap(dev, priv->io);
...
}

priv is netdev private data, but it is used
after free_netdev(). It can cause use-after-free when accessing priv
pointer. So, fix it by moving free_netdev() after pci_iounmap()
calls.

Fixes: 6af55ff52b02 ("Driver for Beckhoff CX5020 EtherCAT master module.")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/ec_bhf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index 46b0dbab8aad..7c992172933b 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -576,10 +576,12 @@ static void ec_bhf_remove(struct pci_dev *dev)
 	struct ec_bhf_priv *priv = netdev_priv(net_dev);
 
 	unregister_netdev(net_dev);
-	free_netdev(net_dev);
 
 	pci_iounmap(dev, priv->dma_io);
 	pci_iounmap(dev, priv->io);
+
+	free_netdev(net_dev);
+
 	pci_release_regions(dev);
 	pci_clear_master(dev);
 	pci_disable_device(dev);
-- 
2.32.0

