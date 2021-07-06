Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFE83BD306
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbhGFLrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237238AbhGFLgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBC961D68;
        Tue,  6 Jul 2021 11:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570781;
        bh=w8YEFTuOkoOdhIW81lnpQfyHItpjRcFHe94pxFGMIjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpU5xwsvp4Vx70Zg+HrK2v7ARkwL37QPIQrex8UfFb2snH8S83vY+YP+mkQV7eIUr
         fRlDzeU4m6PiAuLjzREqpoDgOu29OpKxDmxzAK54nrq3ZgMtm0/RD7CMN5mM2qcp4x
         juOgmyhwjtet38GiZT2WT1X2YEzJWVKA2GKgelG2KX9NEhbgzGXpslocjhEQ10t9LP
         8RXnw6bQ8NFGBtxnPJA2h7COrWMvRSgQoJHGOVqdN5my0Ejgn0YvmRoY66sl1Hc6YW
         3PsqrEr/ZQlV5NafgJg7nbYjbkN76efljMQmrsqNnIfXB++h+49hun7+Kf86iN4mKJ
         ZtikEbo5QdFgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 62/74] sfc: error code if SRIOV cannot be disabled
Date:   Tue,  6 Jul 2021 07:24:50 -0400
Message-Id: <20210706112502.2064236-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 1ebe4feb8b442884f5a28d2437040096723dd1ea ]

If SRIOV cannot be disabled during device removal or module unloading,
return error code so it can be logged properly in the calling function.

Note that this can only happen if any VF is currently attached to a
guest using Xen, but not with vfio/KVM. Despite that in that case the
VFs won't work properly with PF removed and/or the module unloaded, I
have let it as is because I don't know what side effects may have
changing it, and also it seems to be the same that other drivers are
doing in this situation.

In the case of being called during SRIOV reconfiguration, the behavior
hasn't changed because the function is called with force=false.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10_sriov.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 695e3508b4d8..e7c6aa29d323 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -403,12 +403,17 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
 	return rc;
 }
 
+/* Disable SRIOV and remove VFs
+ * If some VFs are attached to a guest (using Xen, only) nothing is
+ * done if force=false, and vports are freed if force=true (for the non
+ * attachedc ones, only) but SRIOV is not disabled and VFs are not
+ * removed in either case.
+ */
 static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 {
 	struct pci_dev *dev = efx->pci_dev;
-	unsigned int vfs_assigned = 0;
-
-	vfs_assigned = pci_vfs_assigned(dev);
+	unsigned int vfs_assigned = pci_vfs_assigned(dev);
+	int rc = 0;
 
 	if (vfs_assigned && !force) {
 		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
@@ -418,10 +423,12 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 
 	if (!vfs_assigned)
 		pci_disable_sriov(dev);
+	else
+		rc = -EBUSY;
 
 	efx_ef10_sriov_free_vf_vswitching(efx);
 	efx->vf_count = 0;
-	return 0;
+	return rc;
 }
 
 int efx_ef10_sriov_configure(struct efx_nic *efx, int num_vfs)
-- 
2.30.2

