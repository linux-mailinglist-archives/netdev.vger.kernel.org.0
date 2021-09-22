Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE8641469A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhIVKkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234734AbhIVKki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 06:40:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FF16124A;
        Wed, 22 Sep 2021 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632307148;
        bh=/gc7+wOTA0t/zZJ425FFjXn+DjYzc8eMUW6GifvrrhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnnkUJn0WU39rcKQfn/jPed6FTY7mF3iRgRKZsitvrugUkayo382ItD0I9O7Y7lME
         g9JN6FPXLQXmVPK5g3Jp9vIrpSm5LFZ+DYI5yMH7xvVVphqJQ3HvVIiDRsxK9ueQOR
         sXUFS0y4tR7caLpFZulhbVd8CMK+4OZ+i89iTl8tWjA+G94saKvinTp0MEbV+0ZOvE
         UzJTon0x5dPZsV7s6OQAGxiCNyj1VJ4xi22Ktgkeu+BUkHllCXONviGs/CDpPi22HU
         /VhzaEFw8e/k2QfrtXjkjLhqQ1AMRO2aL7+kZVHygJyRNZSHs2sqKBzkHoC+BM05if
         x7r15FL+ZxSSw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 3/7] vfio/pci_core: Make the region->release() function optional
Date:   Wed, 22 Sep 2021 13:38:52 +0300
Message-Id: <a01c7bb01ac4b1930a428fa8a8cae89bb1c4327a.1632305919.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632305919.git.leonro@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Make the region->release() function optional as in some cases there is
nothing to do by driver as part of it.

This is needed for coming patch from this series once we add
mlx5_vfio_cpi driver to support live migration but we don't need a
migration release function.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 68198e0f2a63..3ddc3adb24de 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -341,7 +341,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	vdev->virq_disabled = false;
 
 	for (i = 0; i < vdev->num_regions; i++)
-		vdev->region[i].ops->release(vdev, &vdev->region[i]);
+		if (vdev->region[i].ops->release)
+			vdev->region[i].ops->release(vdev, &vdev->region[i]);
 
 	vdev->num_regions = 0;
 	kfree(vdev->region);
-- 
2.31.1

