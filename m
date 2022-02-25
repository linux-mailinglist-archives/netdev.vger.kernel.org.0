Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CEB4C4F11
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiBYTqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiBYTqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:46:46 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D9C210468
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818371; x=1677354371;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zKGvQwqq4U84iieeoS0ccqOF9Ta7p7asCU1OpQHS4ZI=;
  b=nS/WLZMNJR6+3SZOyuKEYVsmw5HNmRqSPuPDutySqTqg0+3BBhiu7boY
   d+mZzs11AGBDJM0+d09BINybWRAlimKam4+JDrG9ms0ApylZ5lJQuamRs
   awhG83CZVnBMGWhlgK7eKyH7lyyIu8m0525NjlB3VTh6W488L7fUnkBlP
   hlbI1cyW2/IUQcqibNJ0QnQ3glzR18bBwWSY0FWkcR6IwdUOEHoz6tFgS
   R8nCHYeYu9yl2hd5/YwwKreJfVSnlQ+FcBMFq47Xj1hY5LqPZ4Ot2nNES
   1fCx8osD5KjslWibvDpELKapad33/Rqk/q/DvIucHq8mlu49kb73bxW1t
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="339004853"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="339004853"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:46:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="707972167"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 25 Feb 2022 11:46:10 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/8][pull request] Intel Wired LAN Driver Updates 2022-02-25
Date:   Fri, 25 Feb 2022 11:46:06 -0800
Message-Id: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Slawomir fixes stability issues that can be seen when stressing the
driver using a large number of VFs with a multitude of operations.
Among the fixes are reworking mutexes to provide more effective locking,
ensuring initialization is complete before teardown, preventing
operations which could race while removing the driver, stopping certain
tasks from being queued when the device is down, and adding a missing
mutex unlock.

The following are changes since commit e01b042e580f1fbf4fd8da467442451da00c7a90:
  net: stmmac: fix return value of __setup handler
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Slawomir Laba (8):
  iavf: Rework mutexes for better synchronisation
  iavf: Add waiting so the port is initialized in remove
  iavf: Fix init state closure on remove
  iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
  iavf: Fix race in init state
  iavf: Fix deadlock in iavf_reset_task
  iavf: Fix missing check for running netdev
  iavf: Fix __IAVF_RESETTING state usage

 drivers/net/ethernet/intel/iavf/iavf.h        |   6 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 159 ++++++++++++------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  24 +--
 3 files changed, 114 insertions(+), 75 deletions(-)

-- 
2.31.1

