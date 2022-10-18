Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67A1602032
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiJRBJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiJRBJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:09:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94935BAF
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666055345; x=1697591345;
  h=from:to:cc:subject:date:message-id;
  bh=0D9zTvrp8loy1p/wd/7ypz6za/bgpsN3QKuD9hC9aM4=;
  b=Jdc9F7sTqHC9+rimZKaZHwLHE4wqAkWtpSmncEWVVJTQ78h1FNHzuReS
   KlVRrBIyDAb2LigloBPh7sYDBQJ3QLe8sfSyvjGUzcjr4r77CpehAqUEB
   aj1TXDRgcNec8TO1WesWgcPPiG+FEayhKeXNKkSojUSb9VPb1RhTC4QhE
   Vg8wwFGz3QhtZ8LBp7TObqRivn2cpsJn+zvxV1kTBfWGh6yoxksNrlhXm
   0PpO/tAnqdNXU3AWnJVq6acqvZtkN+NKkt2ezEoi/tL3D+IYH/noPYBcN
   wAiluBZ24suYZGK/AbAGpppxv66EDiJ6a5wmA7OkY6aBUgE7lX9TCTseJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="392264152"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="392264152"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 18:09:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="717704389"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="717704389"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Oct 2022 18:09:01 -0700
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, aravindhan.gunasekaran@intel.com,
        richardcochran@gmail.com, gal@nvidia.com, saeed@kernel.org,
        leon@kernel.org, michael.chan@broadcom.com, andy@greyhouse.net,
        muhammad.husaini.zulkifli@intel.com, vinicius.gomes@intel.com
Subject: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Date:   Tue, 18 Oct 2022 09:07:28 +0800
Message-Id: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.5 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HW TX timestamps created by the NIC via socket options can be
requested using the current network timestamps generation capability of
SOF_TIMESTAMPING_TX_HARDWARE. The most common users of this socket flag
is PTP, however other packet applications that require tx timestamps might
also ask for it.

The problem is that, when there is a lot of traffic, there is a high chance
that the timestamps for a PTP packet will be lost if both PTP and Non-PTP
packets use the same SOF TIMESTAMPING TX HARDWARE causing the tx timeout.

DMA timestamps through socket options are not currently available to
the user. Because if the user wants to, they can configure the hwtstamp
config option to use the new introduced DMA Time Stamp flag through the
setsockopt().

With these additional socket options, users can continue to utilise
HW timestamps for PTP while specifying non-PTP packets to use DMA
timestamps if the NIC can support them.

This patch series also add a new HWTSTAMP_FILTER_DMA_TIMESTAMP receive
filters. This filter can be configured for devices that support/allow the
DMA timestamp retrieval on receive side.

Any socket application can be use to verify this.
TSN Ref SW application is been used for testing by changing as below:

	int timestamping_flags = SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH;

	strncpy(hwtstamp.ifr_name, opt->ifname, sizeof(hwtstamp.ifr_name)-1);
	hwtstamp.ifr_data = (void *)&hwconfig;
	hwconfig.tx_type = HWTSTAMP_TX_ON;
	hwconfig.flags = HWTSTAMP_FLAG_DMA_TIMESTAMP;
	hwconfig.rx_filter = HWTSTAMP_FILTER_ALL;

	if (ioctl(sock, SIOCSHWTSTAMP, &hwtstamp) < 0) {
		fprintf(stderr, "%s: %s\n", "ioctl", strerror(errno));
		exit(1);
	}

	if (setsockopt(sock, SOL_SOCKET, SO_TIMESTAMPING, &timestamping_flags,
			sizeof(timestamping_flags)) < 0)
		exit_with_error("setsockopt SO_TIMESTAMPING");

v1 -> v2:
	- Move to the end for the new enum.
	- Add new HWTSTAMP_FILTER_DMA_TIMESTAMP receive filters.

Muhammad Husaini Zulkifli (4):
  ethtool: Add new hwtstamp flag
  net-timestamp: Increase the size of tsflags
  net: sock: extend SO_TIMESTAMPING for DMA Fetch
  ethtool: Add support for HWTSTAMP_FILTER_DMA_TIMESTAMP

Vinicius Costa Gomes (1):
  igc: Add support for DMA timestamp for non-PTP packets

 drivers/net/ethernet/intel/igc/igc.h         | 10 +++
 drivers/net/ethernet/intel/igc/igc_base.h    |  2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  5 +-
 drivers/net/ethernet/intel/igc/igc_main.c    | 24 ++++--
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 84 ++++++++++++++++++++
 include/linux/skbuff.h                       |  3 +
 include/net/sock.h                           | 12 +--
 include/uapi/linux/ethtool.h                 |  3 +
 include/uapi/linux/ethtool_netlink.h         |  1 +
 include/uapi/linux/net_tstamp.h              | 14 +++-
 net/core/dev_ioctl.c                         |  1 +
 net/ethtool/common.c                         |  8 ++
 net/ethtool/common.h                         |  2 +
 net/ethtool/strset.c                         |  5 ++
 net/ethtool/tsinfo.c                         | 17 ++++
 net/socket.c                                 |  5 +-
 17 files changed, 181 insertions(+), 17 deletions(-)

--
2.17.1

