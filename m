Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A15659C431
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbiHVQdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiHVQdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:33:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDD43E76D;
        Mon, 22 Aug 2022 09:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661185986; x=1692721986;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LT3WstRBNQjtgXcYNOA/Nkw1IiFjkiJmHvMjWUTY8dg=;
  b=CW3b45WpISyjKOQOgmizfsT02BsNh9yMoNMu0oe7CLT0EX17Lm974LPP
   nBYIfRQqokaGjPWr52rBAs4HSdT8aQl4Y8EHak6vt594Ooz5z+aNq/LNb
   j1VS4rVl2BDv/0oDElf8Ds2z4D4zC6f3lanKJXWkNSCHLFd8YHQ4KB3NI
   f51GXhi2+kID8OdhrGb1GGpZmCtjoSs+ZgXqcpqr/J1oBphF/iaVUSbd/
   MntTlcxrzLSN18NtyvFKoVRqV6yQwnF+hpHaExLDrYd3xinaHZQ3MALON
   IKhectxgqEDQdMn0m28XhvssmOiKJi+3JXqqs7TtPOflu3nkiEDLY/KCe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="273847474"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="273847474"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 09:33:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="559813664"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 22 Aug 2022 09:33:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net 0/2][pull request] ice: xsk: reduced queue count fixes
Date:   Mon, 22 Aug 2022 09:32:55 -0700
Message-Id: <20220822163257.2382487-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
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

Maciej Fijalkowski says:

this small series is supposed to fix the issues around AF_XDP usage with
reduced queue count on interface. Due to the XDP rings setup, some
configurations can result in sockets not seeing traffic flowing. More
about this in description of patch 2.

The following are changes since commit f1e941dbf80a9b8bab0bffbc4cbe41cc7f4c6fb6:
  nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Maciej Fijalkowski (2):
  ice: xsk: prohibit usage of non-balanced queue id
  ice: xsk: use Rx ring's XDP ring when picking NAPI context

 drivers/net/ethernet/intel/ice/ice.h      | 36 +++++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_lib.c  |  4 +--
 drivers/net/ethernet/intel/ice/ice_main.c | 25 +++++++++++-----
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 18 ++++++++----
 4 files changed, 54 insertions(+), 29 deletions(-)

-- 
2.35.1

