Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3204C3AEC7C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhFUPf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:35:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbhFUPfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 11:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624289587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+bR7bYaEo8zByXEw+jeVIKBzdRiV6FJDTVIUTMRfRY=;
        b=ELikmlTa4dU57g4FOaEJ6Ntcvvm11SqP59o3HV9IFgZ6DHmP9zV4yrgdS2Ysn3cqVfHlAv
        zGXBJ+ZrWKyecCzI3Z3q9HPkMrxwFlxhfJJF/RBvNL3yK19G4Hm8wE3O4kVrYp1hBJZxjM
        86jgxlTcxQUCDrcJ752FN/yM6LuaB6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-ZJq0OLvKM0edF4MR2jn7ug-1; Mon, 21 Jun 2021 11:33:06 -0400
X-MC-Unique: ZJq0OLvKM0edF4MR2jn7ug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27DD9100CF6E;
        Mon, 21 Jun 2021 15:33:02 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-119.ams2.redhat.com [10.36.112.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BA4618B42;
        Mon, 21 Jun 2021 15:33:00 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ihuguet@redhat.com, ivecera@redhat.com
Subject: [PATCH 3/4] sfc: explain that "attached" VFs only refer to Xen
Date:   Mon, 21 Jun 2021 17:32:37 +0200
Message-Id: <20210621153238.13147-3-ihuguet@redhat.com>
In-Reply-To: <20210621153238.13147-1-ihuguet@redhat.com>
References: <20210621153238.13147-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During SRIOV disabling it is checked wether any VF is currently attached
to a guest, using pci_vfs_assigned function. However, this check only
works with VFs attached with Xen, not with vfio/KVM. Added comments
clarifying this point.

Also, replaced manual check of PCI_DEV_FLAGS_ASSIGNED flag and used the
helper function pci_is_dev_assigned instead.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 3 ++-
 drivers/net/ethernet/sfc/ef10_sriov.c | 7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c3f35da1b82a..bea961013f7c 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1070,7 +1070,8 @@ static int efx_ef10_probe_vf(struct efx_nic *efx)
 
 	/* If the parent PF has no VF data structure, it doesn't know about this
 	 * VF so fail probe.  The VF needs to be re-created.  This can happen
-	 * if the PF driver is unloaded while the VF is assigned to a guest.
+	 * if the PF driver was unloaded while any VF was assigned to a guest
+	 * (using Xen, only).
 	 */
 	pci_dev_pf = efx->pci_dev->physfn;
 	if (pci_dev_pf) {
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 84041cd587d7..f8f8fbe51ef8 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -122,8 +122,7 @@ static void efx_ef10_sriov_free_vf_vports(struct efx_nic *efx)
 		struct ef10_vf *vf = nic_data->vf + i;
 
 		/* If VF is assigned, do not free the vport  */
-		if (vf->pci_dev &&
-		    vf->pci_dev->dev_flags & PCI_DEV_FLAGS_ASSIGNED)
+		if (vf->pci_dev && pci_is_dev_assigned(vf->pci_dev))
 			continue;
 
 		if (vf->vport_assigned) {
@@ -449,7 +448,9 @@ void efx_ef10_sriov_fini(struct efx_nic *efx)
 	int rc;
 
 	if (!nic_data->vf) {
-		/* Remove any un-assigned orphaned VFs */
+		/* Remove any un-assigned orphaned VFs. This can happen if the PF driver
+		 * was unloaded while any VF was assigned to a guest (using Xen, only).
+		 */
 		if (pci_num_vf(efx->pci_dev) && !pci_vfs_assigned(efx->pci_dev))
 			pci_disable_sriov(efx->pci_dev);
 		return;
-- 
2.31.1

