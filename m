Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8759F660913
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbjAFV7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjAFV7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:59:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B8A6B5F0;
        Fri,  6 Jan 2023 13:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673042356; x=1704578356;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FTUwp6vti/6MjCft69xiR34bTAXHpf/OAp2V3llnAHs=;
  b=D1tQDPo9TrhOYvZa93zi7L81VmQS9VqWkH6CGSaWBfGStkJpwd1u6ecF
   TchpRB6A3AKwqgIxqWBIBlPbsdTw4o1LHEspKokxyCZ7fbhmJs5qVzlpU
   1YNZGOyZHBITUfnqC+9Vfmczekl9PB89RbWs4tC77F6YjSR1tPYefy/xL
   eHggPprNBhIacdKcj3By/z0NwhapEPlWKFsKiJS0fixvs0Po6hjsC9xjk
   Px/5NLVLCnWyyCoSmACWYSUPUebYJvxdsHPlsRmgqFJ5ohGoO51VGhLbz
   /tvo3XPcyaAS7VdMpL5zZNVd676wsRioB3GwUJ6euR3C0MUMYyHg84HY3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="387030696"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="387030696"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 13:59:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763652873"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="763652873"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.60])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jan 2023 13:59:15 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 0/7] Remove three Sun net drivers
Date:   Fri,  6 Jan 2023 14:00:13 -0800
Message-Id: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series removes the Sun Cassini, LDOM vswitch and sunvnet drivers.

In a recent patch series that touched these drivers [1], it was suggested
that these drivers should be removed completely. git logs suggest that
there hasn't been any significant feature addition, improvement or fixes
to user-visible bugs in a while. A web search didn't indicate any recent
discussions or any evidence that there are users out there who care about
these drivers.

The idea behind putting out this series is to either establish that these
drivers are used and should be maintained, or remove them.

While the bulk of the code removal is in the networking s, and so
multiple subsystem lists are cc'd. Here's a quick breakdown:

  - patches 1/7 and 5/7 remove the drivers (netdev)
  - patch 2/7 removes Sun device IDs from pci_ids.h (linux-pci)
  - patch 3/7 changes ppc6xx_defconfig (linuxppc)
  - patch 4/7 changes MIPS mtx1_defconfig (linux-mips)
  - patch 6/7 removes the event tracing header sunvnet.h (linux-trace)
  - patch 7/7 changes sparc64_defconfig (sparclinux)

This series was compile tested as follows:

make O=b1 ARCH=mips CROSS_COMPILE=mips64-linux-gnu- defconfig
make -j$(nproc) O=b1 ARCH=mips CROSS_COMPILE=mips64-linux-gnu- all

make O=b2 ARCH=sparc64 CROSS_COMPILE=sparc64-linux-gnu- defconfig
make -j$(nproc) O=b2 ARCH=sparc64 CROSS_COMPILE=sparc64-linux-gnu- all

make O=b3 ARCH=powerpc CROSS_COMPILE=ppc64-linux-gnu- ppc6xx_defconfig
make -j$(nproc) O=b3 ARCH=powerpc CROSS_COMPILE=ppc64-linux-gnu- all

[1] https://lore.kernel.org/netdev/99629223-ac1b-0f82-50b8-ea307b3b0197@intel.com/T/#t

Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Anirudh Venkataramanan (7):
  ethernet: Remove the Sun Cassini driver
  PCI: Remove PCI IDs used by the Sun Cassini driver
  powerpc: configs: Remove reference to CONFIG_CASSINI
  mips: configs: Remove reference to CONFIG_CASSINI
  ethernet: Remove the Sun LDOM vswitch and sunvnet drivers
  sunvnet: Remove event tracing file
  sparc: configs: Remove references to CONFIG_SUNVNET and CONFIG_LDMVSW

 arch/mips/configs/mtx1_defconfig          |    1 -
 arch/powerpc/configs/ppc6xx_defconfig     |    1 -
 arch/sparc/configs/sparc64_defconfig      |    2 -
 drivers/net/ethernet/sun/Kconfig          |   35 -
 drivers/net/ethernet/sun/Makefile         |    4 -
 drivers/net/ethernet/sun/cassini.c        | 5215 ---------------------
 drivers/net/ethernet/sun/cassini.h        | 2900 ------------
 drivers/net/ethernet/sun/ldmvsw.c         |  476 --
 drivers/net/ethernet/sun/sunvnet.c        |  567 ---
 drivers/net/ethernet/sun/sunvnet_common.c | 1813 -------
 drivers/net/ethernet/sun/sunvnet_common.h |  157 -
 include/linux/pci_ids.h                   |    2 -
 include/trace/events/sunvnet.h            |  140 -
 13 files changed, 11313 deletions(-)
 delete mode 100644 drivers/net/ethernet/sun/cassini.c
 delete mode 100644 drivers/net/ethernet/sun/cassini.h
 delete mode 100644 drivers/net/ethernet/sun/ldmvsw.c
 delete mode 100644 drivers/net/ethernet/sun/sunvnet.c
 delete mode 100644 drivers/net/ethernet/sun/sunvnet_common.c
 delete mode 100644 drivers/net/ethernet/sun/sunvnet_common.h
 delete mode 100644 include/trace/events/sunvnet.h


base-commit: 6bd4755c7c499dbcef46eaaeafa1a319da583b29
-- 
2.37.2

