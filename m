Return-Path: <netdev+bounces-9596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F5D5729FD8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BFE2281983
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743EC1F166;
	Fri,  9 Jun 2023 16:15:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6835217757
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:15:31 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5C30CD
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686327329; x=1717863329;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OrL7aB8LmUrNfMrokIaEPFmgmiDoe7gqvjSP6HMc+nA=;
  b=OZKsyQKt83S+ybJIr6VeGF3D8KDnZ5ko0hvmKD9O5O7fDgL8azXhiia7
   jvDPtjXceN8yDrwBpe3X0OGkOgbWj+wa3G6QciLqAxLve45hTY2XBaK4k
   DfKXC5+JVRBU1v6Yw0KX51CRlimXJXbQFZjJhi7LYbORfEeAUPA/Tj5jW
   9nJOqOagqaf+rliXZAkbjNkfQQ7iE8c9nWae5/tQJZzopWkNgEp7BlV1F
   n/+/sNHhey5sjw/4vRsmcMtlf3Jf28NTn+dnPsi90DQ7q31SEc2ZaoAkx
   BJQvbUprSGi/xv0QyJSlayFa+5w19Wy/P98RU2oxuMUo+ALnjF9Ppk3i9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="423511374"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="423511374"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:15:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="884645652"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="884645652"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 09 Jun 2023 09:15:28 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net v2 0/3][pull request] Intel Wired LAN Driver Updates 2023-06-09 (igc, igb)
Date: Fri,  9 Jun 2023 09:10:55 -0700
Message-Id: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series contains updates to igc and igb drivers.

Husaini clears Tx rings when interface is brought down for igc.

Vinicius disables PTM and PCI busmaster when removing igc driver.

Alex adds error check and path for NVM read error on igb.
---
v2:
Patch 1
 - Changes to commit message
 - Disable TX Queue ring during ndo_stop()

v1: https://lore.kernel.org/netdev/20230509170935.2237051-1-anthony.l.nguyen@intel.com/

The following are changes since commit 04c55383fa5689357bcdd2c8036725a55ed632bc:
  net/sched: cls_u32: Fix reference counter leak leading to overflow
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Aleksandr Loktionov (1):
  igb: fix nvm.ops.read() error handling

Muhammad Husaini Zulkifli (1):
  igc: Clean the TX buffer and TX descriptor ring

Vinicius Costa Gomes (1):
  igc: Fix possible system crash when loading module

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 +++-
 drivers/net/ethernet/intel/igc/igc_main.c    | 12 +++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

-- 
2.38.1


