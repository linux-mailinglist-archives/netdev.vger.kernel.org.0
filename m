Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1461A43417C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 00:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhJSWmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 18:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJSWmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 18:42:46 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AACC061746
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 15:40:32 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o24so7415517wms.0
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 15:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d9wXTaAe8EZKUW9RoLamxl/gBzPnIjD8BEMLKwjF/+s=;
        b=Dv20iBPZdh24X6XR+0eFfH0JEwtZTNuZ3ZPlJbmppMhERHlI7RIY2VwuwoHxGIoNjs
         G7IsDZHlTlNNryQz7VT1AFQdt0kPpCJ5wOjqCH44TeqnqXn5kN+s/dlHaIj/+xUALFF/
         /eYcF5nOJOtkFbUqtGCK3ZZm6h9assN8dAY1bfSoknVzieW4GnaxnFe98QSTxPtm3RRK
         bd+Anmoh4gKHKTQdx49iYF1lMZswRhr6nk7bUuAf7jcZapyTqOa3NtgMM3OpFhIPQ/P2
         YqS2I9F+Ap3AU4thNA5KclHaxmphwDDfAuMfNKlbC7UgYRx0OA1heGhswrF7Er0STuHF
         bmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d9wXTaAe8EZKUW9RoLamxl/gBzPnIjD8BEMLKwjF/+s=;
        b=5QZW1SZhyJF2juYrkOwhN8yexiJFfnerNX1iq4EBbibnxoeUDIGd+l/dLOMtAXLbyx
         kGt9VC4VU0JMOAoKi2sWiIgpXeWKJaqskovn7nDZMhhQ6objJAwZ0joaLoW01nljQf/g
         xobn57mM8cS4JGTptTl3URGdz5jGEM81RCDRXk++j7NKeQyDCts88AsA7W49U+quxkmO
         ExsolOIfRZsaQQl9krm+x3g28V1oG5UBNtwY5+FE/+E2yVL84V2rNUbUpm4JYolHhSrj
         UiU15oYH3mzDB0gbw9Et8zTQ7syEfCf/0gTlXBRh/oY/FCp/6TAQOS6thCVbV+lwqUba
         IIBw==
X-Gm-Message-State: AOAM531sgwTM4LjxV9g9tvVxxmuCO6CbTmeRPRgh2v4iBbfmwogJ9+o8
        wRXuakwvcvWz/IlHB16f+JJKqQ==
X-Google-Smtp-Source: ABdhPJzR0VcaWXGjlK01vmVG/NTFxbT2aPTmdm0HAvIq51grfa7UYVwo9DC2EUUFaM70oYEP2eyCUw==
X-Received: by 2002:adf:bbc2:: with SMTP id z2mr48382667wrg.359.1634683230721;
        Tue, 19 Oct 2021 15:40:30 -0700 (PDT)
Received: from kerfuffle.. ([2a02:168:9619:0:e47f:e8d:2259:ad13])
        by smtp.gmail.com with ESMTPSA id r5sm3270300wmh.28.2021.10.19.15.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 15:40:30 -0700 (PDT)
From:   Erik Ekman <erik@kryo.se>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Erik Ekman <erik@kryo.se>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sfc: Don't use netif_info before net_device setup
Date:   Wed, 20 Oct 2021 00:40:16 +0200
Message-Id: <20211019224016.26530-1-erik@kryo.se>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use pci_info instead to avoid unnamed/uninitialized noise:

[197088.688729] sfc 0000:01:00.0: Solarflare NIC detected
[197088.690333] sfc 0000:01:00.0: Part Number : SFN5122F
[197088.729061] sfc 0000:01:00.0 (unnamed net_device) (uninitialized): no SR-IOV VFs probed
[197088.729071] sfc 0000:01:00.0 (unnamed net_device) (uninitialized): no PTP support

Inspired by fa44821a4ddd ("sfc: don't use netif_info et al before
net_device is registered") from Heiner Kallweit.

Signed-off-by: Erik Ekman <erik@kryo.se>
---
 drivers/net/ethernet/sfc/ptp.c         | 4 ++--
 drivers/net/ethernet/sfc/siena_sriov.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index a39c5143b386..797e51802ccb 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -648,7 +648,7 @@ static int efx_ptp_get_attributes(struct efx_nic *efx)
 	} else if (rc == -EINVAL) {
 		fmt = MC_CMD_PTP_OUT_GET_ATTRIBUTES_SECONDS_NANOSECONDS;
 	} else if (rc == -EPERM) {
-		netif_info(efx, probe, efx->net_dev, "no PTP support\n");
+		pci_info(efx->pci_dev, "no PTP support\n");
 		return rc;
 	} else {
 		efx_mcdi_display_error(efx, MC_CMD_PTP, sizeof(inbuf),
@@ -824,7 +824,7 @@ static int efx_ptp_disable(struct efx_nic *efx)
 	 * should only have been called during probe.
 	 */
 	if (rc == -ENOSYS || rc == -EPERM)
-		netif_info(efx, probe, efx->net_dev, "no PTP support\n");
+		pci_info(efx->pci_dev, "no PTP support\n");
 	else if (rc)
 		efx_mcdi_display_error(efx, MC_CMD_PTP,
 				       MC_CMD_PTP_IN_DISABLE_LEN,
diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
index 83dcfcae3d4b..441e7f3e5375 100644
--- a/drivers/net/ethernet/sfc/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena_sriov.c
@@ -1057,7 +1057,7 @@ void efx_siena_sriov_probe(struct efx_nic *efx)
 		return;
 
 	if (efx_siena_sriov_cmd(efx, false, &efx->vi_scale, &count)) {
-		netif_info(efx, probe, efx->net_dev, "no SR-IOV VFs probed\n");
+		pci_info(efx->pci_dev, "no SR-IOV VFs probed\n");
 		return;
 	}
 	if (count > 0 && count > max_vfs)
-- 
2.31.1

