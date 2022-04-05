Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48874F3FF7
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384794AbiDEUFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457745AbiDEQjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:39:47 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EF6D7631;
        Tue,  5 Apr 2022 09:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649176668; x=1680712668;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0XdaCmbgNbaa3xchsuSOZO9UgEXIgUm89IngezaXfP4=;
  b=Lsd4mn+xBYy6ZS6V0nGwJy0SisMRDMGWI+hm5Gm1+z9fmGBZEHwPZD/b
   2nWKf1XEMMB5ZOhbCVzb9khD2WkTl9La4fFJL2Lq/MkP4yff7Mc42kFYm
   Bip9ODnYqC3x09oykCv/ZcAu0NATpzmpcyNr1PpSSN+BOEzvtLUe5vl6g
   E2ZX+zuhu9MEz1HnDcZeiLbuSs1aMz/bXnYKclZ6ttfJ0hy/5aRNwqO8D
   2AYtiwJFwlR+OTFGb7bz571IdeVJIa/3znMzrA53ZpGy7jVXvMdGkIVw9
   4i4uH3zJDOknn01abAAOZBvoszqnZRdXPhuV8leLZONMedmsIlhS0levl
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="321492685"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="321492685"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 09:37:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="722116663"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 Apr 2022 09:37:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-04-05
Date:   Tue,  5 Apr 2022 09:38:00 -0700
Message-Id: <20220405163803.63815-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski says:

We were solving issues around AF_XDP busy poll's not-so-usual scenarios,
such as very big busy poll budgets applied to very small HW rings. This
set carries the things that were found during that work that apply to
net tree.

One thing that was fixed for all in-tree ZC drivers was missing on ice
side all the time - it's about syncing RCU before destroying XDP
resources. Next one fixes the bit that is checked in ice_xsk_wakeup and
third one avoids false setting of DD bits on Tx descriptors.

The following are changes since commit 1158f79f82d437093aeed87d57df0548bdd68146:
  ipv6: Fix stats accounting in ip6_pkt_drop
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Maciej Fijalkowski (3):
  ice: synchronize_rcu() when terminating rings
  ice: xsk: fix VSI state check in ice_xsk_wakeup()
  ice: clear cmd_type_offset_bsz for TX rings

 drivers/net/ethernet/intel/ice/ice.h      | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 6 ++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.31.1

