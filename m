Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE1E630002
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKRWZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiKRWYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:24:44 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A1E23BD0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668810283; x=1700346283;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dkYMcSk6bhf+Uon07eLUjp1VcVopdvFCOSN5/g1AflE=;
  b=eQaXJDSxZbsHs6oRnFfggGyrqKfdRnl6Xb23HRWA6NbDjhkxb2/7TSmE
   h2zkD1WbZksy+k5riXGIjSHutFhDFgpjKgTeu+Rwyq8Wd4ybmCkLStfUH
   sy/18Vobjjn9rGz93GdHSvqYlqFSiy70JINU7wLAqOZrvBn+EdVL6VnCF
   u5RtBouVn+wIOJcaleN8RI/Bs7K/CCK4+izP4FjmbjUKRfKLMNKVj+mZh
   d5bYrkI4aMEmpxtf6tdWNbt3D3TS8DWnB+WvGnUR1bFUVuvhjUnpvC24B
   qVfddaMAwLDV0vUkIdpb+ABJvo/lvy9JlUpMaeczWp8Jm0pVeKll89kya
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375394910"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="375394910"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 14:24:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="634580303"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="634580303"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 18 Nov 2022 14:24:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-11-18 (iavf)
Date:   Fri, 18 Nov 2022 14:24:35 -0800
Message-Id: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
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

This series contains updates to iavf driver only.

Ivan Vecera resolves issues related to reset by adding back call to
netif_tx_stop_all_queues() and adding calls to dev_close() to ensure
device is properly closed during reset.

Stefan Assmann removes waiting for setting of MAC address as this breaks
ARP.

Slawomir adds setting of __IAVF_IN_REMOVE_TASK bit to prevent deadlock
between remove and shutdown.

The following are changes since commit 2360f9b8c4e81d242d4cbf99d630a2fffa681fab:
  net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Ivan Vecera (2):
  iavf: Fix a crash during reset task
  iavf: Do not restart Tx queues after reset task failure

Slawomir Laba (1):
  iavf: Fix race condition between iavf_shutdown and iavf_remove

Stefan Assmann (1):
  iavf: remove INITIAL_MAC_SET to allow gARP to work properly

 drivers/net/ethernet/intel/iavf/iavf.h      |  1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c | 41 ++++++++++++---------
 2 files changed, 23 insertions(+), 19 deletions(-)

-- 
2.35.1

