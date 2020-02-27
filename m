Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC88B172B79
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgB0Wgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:36:41 -0500
Received: from mga18.intel.com ([134.134.136.126]:49955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729808AbgB0Wgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 17:36:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 14:36:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="238568395"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 27 Feb 2020 14:36:40 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 0/5] pci: implement function to read Device Serial Number
Date:   Thu, 27 Feb 2020 14:36:29 -0800
Message-Id: <20200227223635.1021197-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
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

Modify the bnxt_en, qedf, ice, and ixgbe driver to use this new function.

I left the implementation in the netronome nfp driver alone because they
appear to extract parts of the DSN into separate locations and the
transformation was not as obvious.

The intent for this is to reduce duplicate code across the various drivers,
and make it easier to write future code that wants to read the DSN. In
particular the ice driver will be using the DSN as its serial number when
implementing the DEVLINK_CMD_INFO_GET.

I'm not entirely sure what tree these patches should go through, since it
includes a core PCI change, as well as changes for both networking drivers
and a scsi driver.

Jacob Keller (5):
  pci: introduce pci_get_dsn
  bnxt_en: use pci_get_dsn
  scsi: qedf: use pci_get_dsn
  ice: use pci_get_dsn
  ixgbe: use pci_get_dsn

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 14 +++-----
 drivers/net/ethernet/intel/ice/ice_main.c     | 32 ++++++++----------
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 16 ++++-----
 drivers/pci/pci.c                             | 33 +++++++++++++++++++
 drivers/scsi/qedf/qedf_main.c                 | 16 ++++-----
 include/linux/pci.h                           |  5 +++
 6 files changed, 68 insertions(+), 48 deletions(-)

-- 
2.25.0.368.g28a2d05eebfb

