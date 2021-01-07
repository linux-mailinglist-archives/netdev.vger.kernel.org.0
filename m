Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610982ECA64
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 07:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbhAGGM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 01:12:27 -0500
Received: from mga05.intel.com ([192.55.52.43]:34343 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbhAGGM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 01:12:27 -0500
IronPort-SDR: +Agtplak3Jo8BgOSjmdWKg4MQXjI6J2LkrsXKZncUeXa7VBDmWgcCQRJk3MRW2T/SMbJcrPc0B
 F0LF0TArJRQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="262152096"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="262152096"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 22:12:00 -0800
IronPort-SDR: 0ST6VFwYx4fKIReO4Gz8b6HB1E6wyxCtdLwaB6Zg01qJb7YYA3LhPr5EJDx56FnH90aCIV15eU
 KRURRJaybmlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="462932407"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jan 2021 22:11:57 -0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     andrew@lunn.ch, arnd@arndb.de, lee.jones@linaro.org,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, yilun.xu@intel.com,
        hao.wu@intel.com, matthew.gerlach@intel.com,
        russell.h.weight@intel.com
Subject: [RESEND PATCH 0/2] Add retimer interfaces support for Intel MAX 10 BMC
Date:   Thu,  7 Jan 2021 14:07:06 +0800
Message-Id: <1609999628-12748-1-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I resend this patchset to loop in networking developers for comments. This
is the previous thread. I'll fix other comments when I have a v2.

https://lore.kernel.org/lkml/X%2FV9hvXYlUOT9U2n@kroah.com/


The patchset is for the retimers connected to Intel MAX 10 BMC on Intel
PAC (Programmable Acceleration Card) N3000 Card. The network part of the
N3000 card is like the following:

                       +----------------------------------------+
                       |                  FPGA                  |
  +----+   +-------+   +-----------+  +----------+  +-----------+   +----------+
  |QSFP|---|retimer|---|Line Side  |--|User logic|--|Host Side  |---|XL710     |
  +----+   +-------+   |Ether Group|  |          |  |Ether Group|   |Ethernet  |
                       |(PHY + MAC)|  |wiring &  |  |(MAC + PHY)|   |Controller|
                       +-----------+  |offloading|  +-----------+   +----------+
                       |              +----------+              |
                       |                                        |
                       +----------------------------------------+

I had sent some RFC patches to expose the Line Side Ether Group + retimer +
QSFP as a netdev, and got some comments from netdev Maintainers.

https://lore.kernel.org/netdev/1603442745-13085-2-git-send-email-yilun.xu@intel.com/

The blocking issues I have is that physically the QSFP & retimer is
managed by the BMC and host could only get the retimer link states. This
is not enough to support some necessary netdev ops.  E.g. host cannot
realize the type/speed of the SFP by "ethtool -m", then users could not
configure the various layers accordingly.

This means the existing net tool can not work with it, so this patch just
expose the link states as custom sysfs attrs.


This patchset supports the ethernet retimers (C827) for the Intel PAC
(Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.

The 2 retimer chips connect to the Intel MAX 10 BMC on the card. They are
managed by the BMC firmware. Host could query their link states and
firmware version information via retimer interfaces (Shared registers) on
the BMC. The driver creates sysfs interfaces for users to query these
information.

The Intel OPAE (Open Programmable Acceleration Engine) lib provides tools
to read these attributes.

This is the source of the OPAE lib.

https://github.com/OPAE/opae-sdk/

Generally it facilitate the development on all the DFL (Device Feature
List) based FPGA Cards, including the management of static region &
dynamic region reprogramming, accelerators accessing and the board
specific peripherals.


Xu Yilun (2):
  mfd: intel-m10-bmc: specify the retimer sub devices
  misc: add support for retimers interfaces on Intel MAX 10 BMC

 .../ABI/testing/sysfs-driver-intel-m10-bmc-retimer |  32 +++++
 drivers/mfd/intel-m10-bmc.c                        |  19 ++-
 drivers/misc/Kconfig                               |  10 ++
 drivers/misc/Makefile                              |   1 +
 drivers/misc/intel-m10-bmc-retimer.c               | 158 +++++++++++++++++++++
 include/linux/mfd/intel-m10-bmc.h                  |   7 +
 6 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-intel-m10-bmc-retimer
 create mode 100644 drivers/misc/intel-m10-bmc-retimer.c

-- 
2.7.4

