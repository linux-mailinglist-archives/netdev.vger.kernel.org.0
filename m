Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D40B296B6B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460789AbgJWIvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:51:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:21778 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460780AbgJWIvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 04:51:24 -0400
IronPort-SDR: r39RP5t1aU5kun1+XBHyYYIVi9E4H8t+sReYuwpj+OYLdh575+r+pIJrX49IPD6X0HwmO1r3Xk
 +tmAMXm41H5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="229282346"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="229282346"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 01:51:18 -0700
IronPort-SDR: e5D8J8ANtiZrUIeI9fZG06QikJYcgjQ3jENW3lLQFxOBu19EV2cXl41p5xrbLTQarINd7bYqth
 M+nti4oQj3WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="523436244"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by fmsmga006.fm.intel.com with ESMTP; 23 Oct 2020 01:51:15 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, trix@redhat.com, lgoncalv@redhat.com,
        yilun.xu@intel.com, hao.wu@intel.com
Subject: [RFC PATCH 0/6] Add the netdev support for Intel PAC N3000 FPGA
Date:   Fri, 23 Oct 2020 16:45:39 +0800
Message-Id: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds the driver for FPGA DFL (Device Feature List)
Ether Group private feature. It also adds the driver for the retimer
chips on the Intel MAX 10 BMC (Board Management Controller). These
devices are the networking components on Intel PAC N3000.

Patch #1 provides the document which gives a overview of the hardware
and basic driver design.

Patch #2 & #3 export some APIs to fetch necessary networking
information in DFL framework. These information will be used in the 
retimer driver and Ether Group driver.

Patch #4 implements the retimer driver.

Patch #5 implements the Ether Group driver for 25G.

Patch #6 adds 10G support for the Ether Group driver.


Xu Yilun (6):
  docs: networking: add the document for DFL Ether Group driver
  fpga: dfl: export network configuration info for DFL based FPGA
  fpga: dfl: add an API to get the base device for dfl device
  ethernet: m10-retimer: add support for retimers on Intel MAX 10 BMC
  ethernet: dfl-eth-group: add DFL eth group private feature driver
  ethernet: dfl-eth-group: add support for the 10G configurations

 .../ABI/testing/sysfs-class-net-dfl-eth-group      |  19 +
 .../networking/device_drivers/ethernet/index.rst   |   1 +
 .../ethernet/intel/dfl-eth-group.rst               | 102 ++++
 drivers/fpga/dfl-fme-main.c                        |  10 +-
 drivers/fpga/dfl-n3000-nios.c                      |  11 +-
 drivers/fpga/dfl.c                                 |  30 +
 drivers/fpga/dfl.h                                 |  12 +
 drivers/mfd/intel-m10-bmc.c                        |  18 +
 drivers/net/ethernet/intel/Kconfig                 |  30 +
 drivers/net/ethernet/intel/Makefile                |   4 +
 drivers/net/ethernet/intel/dfl-eth-group-10g.c     | 544 ++++++++++++++++++
 drivers/net/ethernet/intel/dfl-eth-group-25g.c     | 525 +++++++++++++++++
 drivers/net/ethernet/intel/dfl-eth-group-main.c    | 635 +++++++++++++++++++++
 drivers/net/ethernet/intel/dfl-eth-group.h         |  84 +++
 drivers/net/ethernet/intel/intel-m10-bmc-retimer.c | 231 ++++++++
 include/linux/dfl.h                                |   3 +
 include/linux/mfd/intel-m10-bmc.h                  |  16 +
 17 files changed, 2265 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-dfl-eth-group
 create mode 100644 Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst
 create mode 100644 drivers/net/ethernet/intel/dfl-eth-group-10g.c
 create mode 100644 drivers/net/ethernet/intel/dfl-eth-group-25g.c
 create mode 100644 drivers/net/ethernet/intel/dfl-eth-group-main.c
 create mode 100644 drivers/net/ethernet/intel/dfl-eth-group.h
 create mode 100644 drivers/net/ethernet/intel/intel-m10-bmc-retimer.c

-- 
2.7.4

