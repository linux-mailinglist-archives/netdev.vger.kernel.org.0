Return-Path: <netdev+bounces-855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 424D76FB065
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 744A71C2095F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449A9360;
	Mon,  8 May 2023 12:43:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5A2193
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:43:28 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A952BC
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 05:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683549806; x=1715085806;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=genUvGslq8O9Ufc9ajFGJBrpIC8lDTI4RYuNmnnyQiQ=;
  b=U79MCq/rEvKe/6GvXcNYQ/ZM3+CKF6JLuqjtk0mZrI97mRmhTJX7jxlj
   ClHNSqjwzPV3/8KjHYcOGrCxcgliWhwrcem0J3MDVOFdi2Wt/H6xrPDg1
   bsELTJFjKNVC6KqhAuaXrrl2ZKTz309lNQ7kgdfjdlNWiQVO6Gxsz1FLy
   Nr0SkREwAVxLYR0qcAByyostZJ2gkMZiLdIj0TCCitsXMMKSi0to7Hi3z
   sMY64N7rTGCe21Dih/hnZn1zr/NbsIuBQHgm2IZSYlkPaglHAHzxBhWpB
   TAgUdLLqAm61jIK+Gl6QH+B4eiWx2GmE61Q7eiVoDgihyqPmNZHt+ljdm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="349665068"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="349665068"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 05:43:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="676047858"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="676047858"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2023 05:43:23 -0700
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: intel-wired-lan@osuosl.org
Cc: netdev@vger.kernel.org,
	michal.swiatkowski@intel.com,
	shiraz.saleem@intel.com,
	jacob.e.keller@intel.com,
	sridhar.samudrala@intel.com,
	jesse.brandeburg@intel.com,
	aleksander.lobakin@intel.com,
	lukasz.czapnik@intel.com,
	simon.horman@corigine.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net-next v4 0/8] ice: support dynamic interrupt allocation
Date: Mon,  8 May 2023 14:43:13 +0200
Message-Id: <20230508124321.2927867-1-piotr.raczynski@intel.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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

Change history:
v1 -> v2:
- ice: refactor VF control VSI interrupt handling
  - move ice_get_vf_ctrl_vsi to ice_lib.c (ice_vf_lib.c depends on
    CONFIG_PCI_IOV)
v2 -> v3:
- ice: refactor VF control VSI interrupt handling
  - revert v2 change and add no-op function in case of CONFIG_PCI_IOV=n
- ice: add dynamic interrupt allocation
  - fix commit message
v3 -> v4:
- ice: add individual interrupt allocation
  - don't use devm alloc/free for q_vectors
- ice: track interrupt vectors with xarray
  - just return NULL instead of goto if interrupt allocation failed
- ice: add dynamic interrupt allocation
  - exit if released irq entry was not found in the tracker

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
 drivers/net/ethernet/intel/ice/ice_base.c    |  41 +-
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
 16 files changed, 560 insertions(+), 620 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_irq.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_irq.h

-- 
2.38.1


