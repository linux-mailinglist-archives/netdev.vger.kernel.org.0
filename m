Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E57439CC8
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhJYRGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234325AbhJYRDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53C21610A0;
        Mon, 25 Oct 2021 17:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181277;
        bh=9qMXlfZqIo59QSdmSROBVrX5SdX9h4muHUHHOQggr1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skhw1Gobte3QTAZ4f+cZNSLAZ/NYnhh73zezNgNdWdutD9InN82kZdAI59BbciQeS
         zcKOzcWrCnijqDfaFlnJJzFxIcZiCZmfUMzXsXi75+Zu+yuwBwiyvPw0GOAv8Dx/eS
         0RYGwIVMHaMZXnY9GhlHNoU5ZUoSrzf/E7/ujmOUllj9NEXChfcpI3GLEIiEqFKy5c
         wmaejGEPis49VKjAN/4dltycP4clLm0TYCwGqZYAiZmdpeGWCTFbnaXxBgaxR5zvOn
         ibYCxAadR5OVpIcv/tqod+NoQIrwdAGzsPnKB62P/unUUK2zZfchF4VBV9VWcRyvcY
         65l0TD92BCTqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Ekman <erik@kryo.se>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, ecree.xilinx@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/7] sfc: Don't use netif_info before net_device setup
Date:   Mon, 25 Oct 2021 13:01:00 -0400
Message-Id: <20211025170103.1394651-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170103.1394651-1-sashal@kernel.org>
References: <20211025170103.1394651-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erik Ekman <erik@kryo.se>

[ Upstream commit bf6abf345dfa77786aca554bc58c64bd428ecb1d ]

Use pci_info instead to avoid unnamed/uninitialized noise:

[197088.688729] sfc 0000:01:00.0: Solarflare NIC detected
[197088.690333] sfc 0000:01:00.0: Part Number : SFN5122F
[197088.729061] sfc 0000:01:00.0 (unnamed net_device) (uninitialized): no SR-IOV VFs probed
[197088.729071] sfc 0000:01:00.0 (unnamed net_device) (uninitialized): no PTP support

Inspired by fa44821a4ddd ("sfc: don't use netif_info et al before
net_device is registered") from Heiner Kallweit.

Signed-off-by: Erik Ekman <erik@kryo.se>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ptp.c         | 4 ++--
 drivers/net/ethernet/sfc/siena_sriov.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index d47151dbe804..c0a810f74034 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -651,7 +651,7 @@ static int efx_ptp_get_attributes(struct efx_nic *efx)
 	} else if (rc == -EINVAL) {
 		fmt = MC_CMD_PTP_OUT_GET_ATTRIBUTES_SECONDS_NANOSECONDS;
 	} else if (rc == -EPERM) {
-		netif_info(efx, probe, efx->net_dev, "no PTP support\n");
+		pci_info(efx->pci_dev, "no PTP support\n");
 		return rc;
 	} else {
 		efx_mcdi_display_error(efx, MC_CMD_PTP, sizeof(inbuf),
@@ -827,7 +827,7 @@ static int efx_ptp_disable(struct efx_nic *efx)
 	 * should only have been called during probe.
 	 */
 	if (rc == -ENOSYS || rc == -EPERM)
-		netif_info(efx, probe, efx->net_dev, "no PTP support\n");
+		pci_info(efx->pci_dev, "no PTP support\n");
 	else if (rc)
 		efx_mcdi_display_error(efx, MC_CMD_PTP,
 				       MC_CMD_PTP_IN_DISABLE_LEN,
diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
index da7b94f34604..30d58f72725d 100644
--- a/drivers/net/ethernet/sfc/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena_sriov.c
@@ -1059,7 +1059,7 @@ void efx_siena_sriov_probe(struct efx_nic *efx)
 		return;
 
 	if (efx_siena_sriov_cmd(efx, false, &efx->vi_scale, &count)) {
-		netif_info(efx, probe, efx->net_dev, "no SR-IOV VFs probed\n");
+		pci_info(efx->pci_dev, "no SR-IOV VFs probed\n");
 		return;
 	}
 	if (count > 0 && count > max_vfs)
-- 
2.33.0

