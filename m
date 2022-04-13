Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6214FFC24
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiDMRNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbiDMRNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:13:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5106C1F4
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649869866; x=1681405866;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+HZbK8T73cSNuFsFEgSLuqupd4m1F0Vgxp0voO2hrrk=;
  b=Pm/mJGupo3oELaBOfO2JUKRqE2ERJAe+JP461dAigi2FX7qN1VsfLaSh
   APzH4ak2gnzWx+Ybxa4z23dLERqw93jkQkHhvV+bENDIXL1eKXPIMTgHD
   ReMpcdhneoZn/L3r9X3QWPnSKuxecM6ZGMSKN+RyW13YBd9ZzqQELU8Ko
   n0PoVB6OtyAD15BAj6ya9x4wjBsYfm2FBffxkjLo8Ts7jbvrIyruGbEsO
   Ei5QN0Qtbjne8IxijY2zUbDvWU9EF/KdU+mC/BIFWvdTgEAJJ7H1ZIwl1
   IfP8bUs9mmOAQqvxpBzQNaREk7l/M+4ChOFOduc6cGoyz9wUzwCI6sMcY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="349158018"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="349158018"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 10:11:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573360507"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 10:11:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-04-13
Date:   Wed, 13 Apr 2022 10:08:10 -0700
Message-Id: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
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

This series contains updates to igc and e1000e drivers.

Sasha removes waiting for hardware semaphore as it could cause an
infinite loop and changes usleep_range() calls done under atomic
context to udelay() for igc. For e1000e, he changes some variables from
u16 to u32 to prevent possible overflow of values.

Vinicius disables PTM when going to suspend as it is causing hang issues
on some platforms for igc.

The following are changes since commit ef27324e2cb7bb24542d6cb2571740eefe6b00dc:
  nfc: nci: add flush_workqueue to prevent uaf
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Sasha Neftin (3):
  igc: Fix infinite loop in release_swfw_sync
  igc: Fix BUG: scheduling while atomic
  e1000e: Fix possible overflow in LTR decoding

Vinicius Costa Gomes (1):
  igc: Fix suspending when PTM is active

 drivers/net/ethernet/intel/e1000e/ich8lan.c |  4 ++--
 drivers/net/ethernet/intel/igc/igc_i225.c   | 11 +++++++++--
 drivers/net/ethernet/intel/igc/igc_phy.c    |  4 ++--
 drivers/net/ethernet/intel/igc/igc_ptp.c    | 15 ++++++++++++++-
 4 files changed, 27 insertions(+), 7 deletions(-)

-- 
2.31.1

