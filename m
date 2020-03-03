Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5C9176AA4
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgCCCZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:25:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:54186 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgCCCZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:25:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:25:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="233605682"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 18:25:07 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 0/6] PCI: Implement function to read Device Serial Number
Date:   Mon,  2 Mar 2020 18:24:59 -0800
Message-Id: <20200303022506.1792776-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
References: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several drivers read the Device Serial Number from the PCIe extended
configuration space. Each of these drivers implements a similar approach to
finding the position and then extracting the 8 bytes of data.

Implement a new helper function, pci_get_dsn, which can be used to extract
this data into an 8 byte array.

Modify the bnxt_en, qedf, ice, ixgbe and nfp drivers to use this new
function.

The intent for this is to reduce duplicate code across the various drivers,
and make it easier to write future code that wants to read the DSN. In
particular the ice driver will be using the DSN as its serial number when
implementing the DEVLINK_CMD_INFO_GET.

The new implementation in v2 significantly simplifies some of the callers
which just want to print the value out in MSB order. By returning things as
a u64 in CPU Endian order, the "%016llX" printf format specifier can be used
to correctly format the value.

Per patch changes since v1
  PCI: Introduce pci_get_dsn
  * Update commit message based on feedback from Bjorn Helgaas
  * Modify the function to return a u64 (zero on no capability)
  * This new implementation ensures that the first dword is the lower 32
    bits and the second dword is the upper 32 bits.

  bnxt_en: Use pci_get_dsn()
  * Use the u64 return value from pci_get_dsn()
  * Copy it into the dsn[] array by using put_unaligned_le64
  * Fix a pre-existing typo in the netdev_info error message

  scsi: qedf: Use pci_get_dsn()
  * Use the u64 return value from pci_get_dsn()
  * simplify the snprintf to use "%016llX"
  * remove the unused 'i' variable

  ice: Use pci_get_dsn()
  * Use the u64 return value from pci_get_dsn()
  * simplify the snprintf to use "%016llX"

  ixgbe: Use pci_get_dsn()
  * Use the u64 return value from pci_get_dsn()
  * simplify the snprintf to use "%016llX"

  nfp: Use pci_get_dsn()
  * Added in v2

Jacob Keller (6):
  PCI: Introduce pci_get_dsn
  bnxt_en: Use pci_get_dsn()
  scsi: qedf: Use pci_get_dsn()
  ice: Use pci_get_dsn()
  ixgbe: Use pci_get_dsn()
  nfp: Use pci_get_dsn()

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 14 +++-----
 drivers/net/ethernet/intel/ice/ice_main.c     | 30 ++++++----------
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 18 ++++------
 .../netronome/nfp/nfpcore/nfp6000_pcie.c      | 24 +++++--------
 drivers/pci/pci.c                             | 34 +++++++++++++++++++
 drivers/scsi/qedf/qedf_main.c                 | 19 ++++-------
 include/linux/pci.h                           |  5 +++
 7 files changed, 76 insertions(+), 68 deletions(-)

-- 
2.25.0.368.g28a2d05eebfb
