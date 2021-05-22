Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5600138D2BE
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 03:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhEVBOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 21:14:45 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:44386 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230293AbhEVBOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 21:14:44 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 98FE63CB64;
        Fri, 21 May 2021 18:13:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 98FE63CB64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1621645998;
        bh=wPZLx3MQrAZArrUbmLngfB+9yd6dimqsMD8FD5CdPys=;
        h=From:To:Cc:Subject:Date:From;
        b=XD3KO1Mx7Xd2KMtuLcnMGnA/S6FcG1sMEw9jrTTAS5JvTp5xNhMcOOze416kgHhjQ
         /b+ilUVx2uXMVyylogsUSD0fbCPDoKKFfEOXVU3suFszJjP79lhszDNeHVrRnmuPcu
         Y3XH54xhnOcPSdVTDoSLkhKDO1YlIqKuq+bT72zQ=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, bhelgaas@google.com
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH] pci: Add ACS quirk for Broadcom NIC.
Date:   Fri, 21 May 2021 21:13:17 -0400
Message-Id: <1621645997-16251-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

Some Broadcom NICs such as the BCM57414 do not advertise PCI-ACS
capability. All functions on such devices are placed under the same
IOMMU group. Attaching a single PF to a userspace application like
OVS-DPDK using VFIO is not possible, since not all functions in the
IOMMU group are bound to VFIO.

Since peer-to-peer transactions are not possible between PFs on these
devices, it is safe to treat them as fully isolated even though the ACS
capability is not advertised. Fix this issue by adding a PCI quirk for
this chip.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dcb229de1acb..cb1628e222df 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4753,6 +4753,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_AMPERE, 0xE00A, pci_quirk_xgene_acs },
 	{ PCI_VENDOR_ID_AMPERE, 0xE00B, pci_quirk_xgene_acs },
 	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
+	/* Broadcom multi-function device */
+	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
-- 
2.18.1

