Return-Path: <netdev+bounces-3062-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 875A170552C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83FDD1C20E37
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5ECC107B8;
	Tue, 16 May 2023 17:44:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E5F847F
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:44:03 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A652A93D5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684259041; x=1715795041;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=msJmHJBmEUbSeDrONXqWR/Nk6BI5mtoJ6YBSIhdIFzQ=;
  b=XT+unMVQoEowqamrt48HuN0Dmj+fwFJQVZ4ZbjQIOZQ0314jExcLLeJl
   Ak3Z1Uqy2yJkrtN0Uyc1hllspM1adVPHZOvf/HlXlTqMN87K4DEKdRNft
   VZUYV0uwkaalw/q93+0OaI2+UWF6b15RR7rBVj1xxDX5neVwFN4Huij09
   u/6U3hRgW0/w8hoFCXHLJYga1PdPXh++vFDP5bYAtYs08HA1qAbhZxEf6
   j5dSJjzO1FNdtIKjHN0soc0taHMnt5szJcTEKb7uAvo+OE6yymR7MEO2w
   ayDPKqt1diAcWzpfjo5kftWqD4Rod/pU0Kf862rm5ngIger2PXyLgkEqu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="353831914"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="353831914"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 10:44:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="875733034"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="875733034"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2023 10:44:00 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>,
	piotr.raczynski@intel.com
Subject: [PATCH net-next v2 0/8][pull request] ice: support dynamic interrupt allocation
Date: Tue, 16 May 2023 10:40:13 -0700
Message-Id: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Piotr Raczynski says:

This patchset reimplements MSIX interrupt allocation logic to allow dynamic
interrupt allocation after MSIX has been initially enabled. This allows
current and future features to allocate and free interrupts as needed and
will help to drastically decrease number of initially preallocated
interrupts (even down to the API hard limit of 1). Although this patchset
does not change behavior in terms of actual number of allocated interrupts
during probe, it will be subject to change.

First few patches prepares to introduce dynamic allocation by moving
interrupt allocation code to separate file and update allocation API used
in the driver to the currently preferred one.

Due to the current contract between ice and irdma driver which is directly
accessing msix entries allocated by ice driver, even after moving away from
older pci_enable_msix_range function, still keep msix_entries array for
irdma use.

Next patches refactors and removes redundant code from SRIOV related logic
as it also make it easier to move away from static allocation scheme.

Last patches actually enables dynamic allocation of MSIX interrupts. First,
introduce functions to allocate and free interrupts individually. This sets
ground for the rest of the changes even if that patch still allocates the
interrupts from the preallocated pool. Since this patch starts to keep
interrupt details in ice_q_vector structure we can get rid of functions
that calculates base vector number and register offset for the interrupt
as it is equal to the interrupt index. Only keep separate register offset
functions for the VF VSIs.

Next, replace homegrown interrupt tracker with much simpler xarray based
approach. As new API always allocate interrupts one by one, also track
interrupts in the same manner.

Lastly, extend the interrupt tracker to deal both with preallocated and
dynamically allocated vectors and use pci_msix_alloc_irq_at and
pci_msix_free_irq functions. Since not all architecture supports dynamic
allocation, check it before trying to allocate a new interrupt.

As previously mentioned, this patchset does not change number of initially
allocated interrupts during init phase but now it can and will likely be
changed.

Patch 1-3 -> move code around and use newer API
Patch 4-5 -> refactor and remove redundant SRIOV code
Patch 6   -> allocate every interrupt individually
Patch 7   -> replace homegrown interrupt tracker with xarray
Patch 8   -> allow dynamic interrupt allocation
---
v2:
Patch 4
 - simplify ice_vsi_setup_vector_base and account for num_avail_sw_msix
Patch 8
 - prevent q_vector leak in case vf ctrl VSI error

v1: https://lore.kernel.org/netdev/20230509170048.2235678-1-anthony.l.nguyen@intel.com/

The following are changes since commit e641577eb6e82cbb89dde7cfc44ef2541c42278c:
  Merge branch 'spdx-conversion-for-bonding-8390-and-i825xx-drivers'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Piotr Raczynski (8):
  ice: move interrupt related code to separate file
  ice: use pci_irq_vector helper function
  ice: use preferred MSIX allocation api
  ice: refactor VF control VSI interrupt handling
  ice: remove redundant SRIOV code
  ice: add individual interrupt allocation
  ice: track interrupt vectors with xarray
  ice: add dynamic interrupt allocation

 drivers/net/ethernet/intel/ice/Makefile      |   1 +
 drivers/net/ethernet/intel/ice/ice.h         |  24 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c    |   5 +-
 drivers/net/ethernet/intel/ice/ice_base.c    |  50 ++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_idc.c     |  54 ++-
 drivers/net/ethernet/intel/ice/ice_irq.c     | 378 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_irq.h     |  25 ++
 drivers/net/ethernet/intel/ice/ice_lib.c     | 288 +-------------
 drivers/net/ethernet/intel/ice/ice_lib.h     |   5 -
 drivers/net/ethernet/intel/ice/ice_main.c    | 268 ++-----------
 drivers/net/ethernet/intel/ice/ice_ptp.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c   |  43 +--
 drivers/net/ethernet/intel/ice/ice_vf_lib.c  |  32 ++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h  |   7 +
 drivers/net/ethernet/intel/ice/ice_xsk.c     |   5 +-
 16 files changed, 569 insertions(+), 620 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_irq.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_irq.h

-- 
2.38.1


