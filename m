Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E02510A89
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 22:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354987AbiDZUgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 16:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354989AbiDZUgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 16:36:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A324A1A8163
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 13:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651005177; x=1682541177;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BZIYgtRmRKIca7gBbmoGmSi5mNzRY/K7j1aLuEc1aTE=;
  b=mGP4fjzPheJxAqUF1cETa+kmOiEzIGIWJluCg1HFpkWvW7AJNTyGwwd+
   Bzls5R1MAkVwUybu425mHulO1lIn2Ri6SquaMVhEWBHn6dxc0jfvSB0Ta
   WHoOsXsZxZz12bjVkStt33qfJD8R0vlNR6AdLoBW2yn16Dcnq9Q8/srOd
   WxMxx8HSpOKEayFZ4ArX8VfTUEVxHz1JGytDHEkzixXAlwuCspWIpHk7J
   2t+GpR8dzm7yCRgye/g24ndCr2AytkatI1qahaZqkW/A+Qk8nEeUJMkRI
   HlkNUHzYmerI4m77LvRHQNcZ4ple7YM4aZZLaofqxP1aM/lVWS53BgXwC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="253090820"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="253090820"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:32:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="617174546"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2022 13:32:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-04-26
Date:   Tue, 26 Apr 2022 13:30:14 -0700
Message-Id: <20220426203018.3790378-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Ivan Vecera removes races related to VF message processing by changing
mutex_trylock() call to mutex_lock() and moving additional operations
to occur under mutex.

Petr Oros increases wait time after firmware flash as current time is
not sufficient.

Jake resolves a use-after-free issue for mailbox snapshot.

The following are changes since commit acb16b395c3f3d7502443e0c799c2b42df645642:
  virtio_net: fix wrong buf address calculation when using xdp
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Ivan Vecera (2):
  ice: Fix incorrect locking in ice_vc_process_vf_msg()
  ice: Protect vf_state check by cfg_lock in ice_vc_process_vf_msg()

Jacob Keller (1):
  ice: fix use-after-free when deinitializing mailbox snapshot

Petr Oros (1):
  ice: wait 5 s for EMP reset after firmware flash

 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +++
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 27 +++++++------------
 3 files changed, 13 insertions(+), 19 deletions(-)

-- 
2.31.1

