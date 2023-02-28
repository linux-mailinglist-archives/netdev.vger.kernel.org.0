Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667516A5D72
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjB1Qsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjB1Qsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:48:37 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51AE6EAE;
        Tue, 28 Feb 2023 08:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677602886; x=1709138886;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WRHLtls8wXHkKG0wPUdAzJHiEECJD6P2u5mrgkq32og=;
  b=GIITSovHGRKPNNTtFu04OQGPMroln0wHW/qqp0zCw8RKm17eppp+CFws
   /PUYx1LkfG9HzeeORUnfDR2tB0YnNvcsKjlmd14wsubbFTadTjxdS7klW
   n9oTsrlgL7i41IbRyNU/A/K9xeXlMmTy0OYlHv7BMZ6gJv8uWL21EvvBD
   icJ+BV2gcU7tlii29k/2gyfhtaBBsiOXwQFzoX5TjPuuTTEtHfHF+7jdi
   SaK0GFNAczUaWQbkh0/rKSVg/0JeN1s8xl4Cbdtcxfz3v5LaZoV4aNw2v
   FThPn5cmwovc4gLUJYnb07o152pMgB0iYdhnmie0jWGd+/5Gbs6tGEKlF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="317986827"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="317986827"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 08:48:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="624107465"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="624107465"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 28 Feb 2023 08:48:03 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 07A41369ED;
        Tue, 28 Feb 2023 16:48:01 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] iavf: fix double-broken HW hash report
Date:   Tue, 28 Feb 2023 17:46:11 +0100
Message-Id: <20230228164613.1360409-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, passing HW hash from descriptors to skb is broken two times.
The first bug effectively disables hash from being filled at all, unless
%NETIF_F_RXHASH is *disabled* via Ethtool. The second incorrectly says
that IPv6 UDP packets are L3, which also triggers CPU hashing when
needed (the networking core treats only L4 HW hash as "true").
The very same problems were fixed in i40e and ice, but not in iavf,
although each of the original commits bugged at least two drivers.
It's never too late (I hope), so fix iavf this time.

Alexander Lobakin (2):
  iavf: fix inverted Rx hash condition leading to disabled hash
  iavf: fix non-tunneled IPv6 UDP packet type and hashing

 drivers/net/ethernet/intel/iavf/iavf_common.c | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---
To Tony: this is very trivial and tested for a while already, I hope it
could hit one of the first couple RCs :p
-- 
2.39.2

