Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B02C5B27CD
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 22:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIHUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIHUhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 16:37:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEA61017F3
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 13:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662669429; x=1694205429;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vpo7YJGKuU9yvnL/ac0om6IvVZfgqh1MUDLNHbTcjfg=;
  b=HGHhb9f/rVHCcywu+Rm3yuiuvNRNsZAL6qxn0IGuDW9XpN09vWzLlZcy
   L60Xxo2Va0fAeu1yNfiC/tvkfIX78VbBMO7o4ik4QTFengQNO0k6TUdmS
   OrDzU6EEpjZRQ2XKIqrd1BF/Kxwg42G34eyaZmIEf2FoRpfrmzn1npvKT
   vgeMjw3nTYRKohqPvtYA19ZswDgORGZYGyZFF/AWtDrvZ8NaroMDpqzYs
   NB7MU31eS7bgJeBI4qRR7iOZKuYx6uvdY5aSZNUHb/5g5SwEOam1lw1V+
   ukRVpurOxBwWYF2XxrDGKU5LMObpyJz0pNwX2om/kGgrJa7dcdt58md87
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="294900340"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="294900340"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 13:37:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="943509272"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 08 Sep 2022 13:37:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-09-08 (ice, iavf)
Date:   Thu,  8 Sep 2022 13:36:57 -0700
Message-Id: <20220908203701.2089562-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers.

Dave removes extra unplug of auxiliary bus on reset which caused a
scheduling while atomic to be reported for ice.

Ding Hui defers setting of queues for TCs to ensure valid configuration
and restores old config if invalid for ice.

Sylwester fixes a check of setting MAC address to occur after result is
received from PF for iavf driver.

Brett changes check of ring tail to use software cached value as not all
devices have access to register tail for iavf driver.

The following are changes since commit 26b1224903b3fb66e8aa564868d0d57648c32b15:
  Merge tag 'net-6.0-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (1):
  iavf: Fix cached head and tail value for iavf_get_tx_pending

Dave Ertman (1):
  ice: Don't double unplug aux on peer initiated reset

Ding Hui (1):
  ice: Fix crash by keep old cfg when update TCs more than queues

Sylwester Dziedziuch (1):
  iavf: Fix change VF's mac address

 drivers/net/ethernet/intel/iavf/iavf_main.c |  9 ++---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c |  5 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c    | 42 +++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_main.c   |  2 -
 4 files changed, 33 insertions(+), 25 deletions(-)

-- 
2.35.1

