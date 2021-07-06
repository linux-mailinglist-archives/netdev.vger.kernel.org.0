Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF783BD3BA
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238720AbhGFL7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233428AbhGFLic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B29D261F8D;
        Tue,  6 Jul 2021 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625571002;
        bh=uLUw8OTPvn3Z7B8rlQ4zmTiYrO0OQVX2defuZ4AO5tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1RTSkpBq+aQ1gJzLbWj3PtYnLf3qmhFu4apxDUCSNat5Z3rE1DatLJcmzcR3lgbw
         Kaze40qJjaAq8rBlwUhbnYkd7xkf86uF4jrDnAmM+oT0/GSfIyKP1jMGueFWPEYjth
         Kh/juoK6Vtkq/H5S7p1dRNy0OT0/ikZJpFsyjw6Xtupn0sK0zCsp9pnUCukGg5ir+k
         Qi4V4pQwhHQc0IlwFZ9WlUhggyI5Src7WGzkL23iLZxaSNhaJk1idpcrjQNXwH9TwA
         Ly7BbghZ2BiEgqwAN8vlfXj54iZqYKfNvRQebhZm3Q8dN6Y0zroajAmqGu18PJTLX3
         Udhacj6Z2vZ8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 25/31] sfc: error code if SRIOV cannot be disabled
Date:   Tue,  6 Jul 2021 07:29:25 -0400
Message-Id: <20210706112931.2066397-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
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
index b3c27331b374..8fce0c819a4b 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -378,12 +378,17 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
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
@@ -393,10 +398,12 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 
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

