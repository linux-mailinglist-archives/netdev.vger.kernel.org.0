Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2746BD726
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCPRdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCPRde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:33:34 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C518A14E8B
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678988012; x=1710524012;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bqdwdC7CnAJWlleRWdCclVxB8eqPIKnr6lxD1avStpY=;
  b=f08FhnN7SPYbFwkEXV2lXXgxCtjOmciceppiMjggb9U1/yFl+dNudDHW
   juEqmPOEit5XdnVmxuHfFXNllDSjl6mUQmQaRtQPZhIuxaRqbFCoCSqZj
   2ij42UoByCOeDq1MKIjb5N4Rrnj7mHlTqXWAGci6BO1cM3C6XMUvyl8n/
   3hi0HPHg5ZVQ51sybCQtxKHn4QZa65A0OjjAburEa6PXb7x4M2jaQXr5o
   /9RF2nwnqf3WO8M3UG3iRYuBHSKTKNMfeNBwuYKuXQnqVjTqLLUrWq/98
   zCwaIOE1Srt0npOHHLyKhQ8x5rYKYBiTMp4TrUwbi3+ELZSAzUZjdEvls
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="402948279"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="402948279"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 10:33:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="679982470"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679982470"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 10:33:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2023-03-16 (igb, igbvf, igc)
Date:   Thu, 16 Mar 2023 10:31:39 -0700
Message-Id: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb, igbvf, and igc drivers.

Lin Ma removes rtnl_lock() when disabling SRIOV on remove which was
causing deadlock on igb.

Akihiko Odaki delays enabling of SRIOV on igb to prevent early messages
that could get ignored and clears MAC address when PF returns nack on
reset; indicating no MAC address was assigned for igbvf.

Gaosheng Cui frees IRQs in error path for igbvf.

Akashi Takahiro fixes logic on checking TAPRIO gate support for igc.

The following are changes since commit cd356010ce4c69ac7e1a40586112df24d22c6a4b:
  net: phy: mscc: fix deadlock in phy_ethtool_{get,set}_wol()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

AKASHI Takahiro (1):
  igc: fix the validation logic for taprio's gate list

Akihiko Odaki (2):
  igb: Enable SR-IOV after reinit
  igbvf: Regard vf reset nack as success

Gaosheng Cui (1):
  intel/igbvf: free irq on the error path in igbvf_request_msix()

Lin Ma (1):
  igb: revert rtnl_lock() that causes deadlock

 drivers/net/ethernet/intel/igb/igb_main.c | 137 +++++++++-------------
 drivers/net/ethernet/intel/igbvf/netdev.c |   8 +-
 drivers/net/ethernet/intel/igbvf/vf.c     |  13 +-
 drivers/net/ethernet/intel/igc/igc_main.c |  20 ++--
 4 files changed, 84 insertions(+), 94 deletions(-)

-- 
2.38.1

