Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7A96EA03F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjDTXwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTXwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:52:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598221FF1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034768; x=1713570768;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=21Xj744rjVg5kdqC9rQRRk2B5+qc+LTJElQTGw/ARwQ=;
  b=c0WaU2lagQqECa/ZmEECISnCNCRyT9Kyu0UHjWt60hmR2A+o6nffv6zM
   atpDk7wnTGljG6xL1WBZnGXFBUbpIEnOvwfMLG5solN18iXnXC69sEoBz
   +WViT54WYiGWFVsRPBa5TDDEOdn8H+I/9jF6YscNhCV4PZC6YVUYyLLj2
   tRrVDSdksNGAWtzvFRzmDgE3KM/36+TEPHd6yV8gEQszROvZsAvJ4mwUQ
   V2UL3G0jS72vwaIdefagUdo04rsRUex5TsdYXz8Ld2FbftaIES6PokrEn
   Zd6cPz5tchGSMSmQyAkiW6Q6+OJuQq04k7xriUKI2gLVxYu/SB2aFj36W
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326203120"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326203120"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:52:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="803527222"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="803527222"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2023 16:52:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, jdamato@fastly.com
Subject: [PATCH net 0/2][pull request] ixgbe: Multiple RSS bugfixes
Date:   Thu, 20 Apr 2023 16:49:58 -0700
Message-Id: <20230420235000.2971509-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

Joe Damato says:

This series fixes two bugs I stumbled on with ixgbe:

1. The flow hash cannot be set manually with ethool at all. Patch 1/2
addresses this by fixing what appears to be a small bug in set_rxfh in
ixgbe. See the commit message for more details.

2. Once the above patch is applied and the flow hash can be set,
resetting the flow hash to default fails if the number of queues is
greater than the number of queues supported by RSS. Other drivers (like
i40e) will reset the flowhash to use the maximum number of queues
supported by RSS even if the queue count configured is larger. In other
words: some queues will not have packets distributed to them by the RSS
hash if the queue count is too large. Patch 2/2 allows the user to reset
ixgbe to default and the flowhash is set correctly to either the
maximum number of queues supported by RSS or the configured queue count,
whichever is smaller.

I believe this is correct and it mimics the behavior of i40e;
`ethtool -X $iface default` should probably always succeed even if all the
queues cannot be utilized. See the commit message for more details and
examples.

I tested these on an ixgbe system I have access to and they appear to
work as intended, but I would appreciate a review by the experts on this
list :)

Thanks,
Joe

The following are changes since commit 927cdea5d2095287ddd5246e5aa68eb5d68db2be:
  net: bridge: switchdev: don't notify FDB entries with "master dynamic"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Joe Damato (2):
  ixgbe: Allow flow hash to be set via ethtool
  ixgbe: Enable setting RSS table to default values

 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

-- 
2.38.1

