Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C1E5BD77A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiISWeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiISWel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:34:41 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F5FE4D
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663626878; x=1695162878;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nQk+I4HmR7Swo5m4GBbEkaJKat60HN/hfUcT5ZCccVs=;
  b=CTZBVcKvnoZGDsJLmHxgJH4EhWczm4MWKFYnMiJRvtmHDkzGCpcMm0K9
   ukFl6+OM0Qn8GMS+fwFUxZjR+c7moxewl5bnOEHlofjXgBmx0X/Ry+8DO
   UgzfRHAM+iG7QdTZBkY+VOcOpzgjDjmpO40u9lDrkwunKZMaw3GWf2Jub
   BuXlAfKF1F9oM+oynoFK0lFcc6PmcyRcDySCEl+E1IkAw2PK0Yw30ftH6
   UiLC6EBJetLbAzHq29pVGT3yynEB5WU+sl+OKKeHlEf807P/HeR0w/V/S
   N1PBJABi/WnpO8PuAyJt4yEyUjvphfMDGrH3bFTEZManNoKTsOSqlv9MU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298265229"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="298265229"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 15:34:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="651855346"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Sep 2022 15:34:37 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-09-19 (iavf, i40e)
Date:   Mon, 19 Sep 2022 15:34:24 -0700
Message-Id: <20220919223428.572091-1-anthony.l.nguyen@intel.com>
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

This series contains updates to iavf and i40e drivers.

Norbert adds checking of buffer size for Rx buffer checks in iavf.

Michal corrects setting of max MTU in iavf to account for MTU data provided
by PF, fixes i40e to set VF max MTU, and resolves lack of rate limiting
when value was less than divisor for i40e.

The following are changes since commit 96628951869c0dedf0377adca01c8675172d8639:
  tcp: Use WARN_ON_ONCE() in tcp_read_skb()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Michal Jaron (3):
  iavf: Fix set max MTU size with port VLAN and jumbo frames
  i40e: Fix VF set max MTU size
  i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Norbert Zulinski (1):
  iavf: Fix bad page state

 drivers/net/ethernet/intel/i40e/i40e_main.c   | 32 +++++++++++++++----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 20 ++++++++++++
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  4 +--
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  7 ++--
 4 files changed, 53 insertions(+), 10 deletions(-)

-- 
2.35.1

