Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DF64DCDB1
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiCQSiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbiCQSiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:38:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B7F11437E;
        Thu, 17 Mar 2022 11:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647542256; x=1679078256;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3Qy5Jfak+WfSH4cvrk8j+KOknstRSeTtdDojbU/Stvc=;
  b=YwNcpYl7Lv6qmMO9KkAnF0fClq3wMX7JpjZ1BPiSlaeQsP37uQDQGdSr
   w+U+dw2sIVEPcNw3+u3k7LaBCKKDAXp4YDPGqTXuluNI2Pe0TvzCPQ2nB
   c9zsyrKfaa7CGL/UC8LtiX5JBFl8CDNTo3gH1yjWN2rGR8rj2lfGV/s2U
   WJr0QdHYyCNpP/P4/UdpEhThrvGeorP6R3UNi1p9kacHvq5T9oQKXaSwS
   rxFGAEjvW08FChJXFhYlEnlWzwwefk9Qf9rBpTbPw7w6ftGfsCKvJCdVQ
   Js4aCb6fMj86qCfA9U62mpUqT7d5oiYojuff6b1I+I5hPXXp9ZN4JoNGm
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="343386024"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="343386024"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 11:37:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="558057172"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 17 Mar 2022 11:37:33 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 0/3] ice: xsk: various fixes
Date:   Thu, 17 Mar 2022 19:36:26 +0100
Message-Id: <20220317183629.340350-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We were solving issues around AF_XDP busy poll's not-so-usual scenarios,
such as very big busy poll budgets applied to very small HW rings. This
set carries the things that were found during that work that apply to
net tree.

One thing that was fixed for all in-tree ZC drivers was missing on ice
side all the time - it's about syncing RCU before destroying XDP
resources. Next one fixes the bit that is checked in ice_xsk_wakeup and
third one avoids false setting of DD bits on Tx descriptors.

Thanks!

Maciej Fijalkowski (3):
  ice: synchronize_rcu() when terminating rings
  ice: xsk: fix VSI state check in ice_xsk_wakeup()
  ice: clear cmd_type_offset_bsz for TX rings

 drivers/net/ethernet/intel/ice/ice.h      | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 6 ++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.27.0

