Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F18E5EC3B6
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiI0NIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiI0NIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:08:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED23C1857AD
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 06:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664284086; x=1695820086;
  h=from:to:cc:subject:date:message-id;
  bh=LckD10FgykrV7aKsGyhhcdj30WJ7hHizfIuU2xDd8Cc=;
  b=MZKcACWtexg0lt98H5zaf174e0TGagW1y5XzOGAlNSx7/x/rI4VTYsxv
   o/dbPjD52etB+c1Vby4wPVIPlQtQkr+QYeVX2gLXD1jljoJiKOVWm6eOv
   52aQuOpMO3bHBQcZiXomkwDxqDE6m0535zPll1Gdma2PWCjlneTEKRaOS
   kUGanhRPcDkobbalBq07W9PuuN7coqYtwp8gAPWXZPK/cz5eSheCN4qja
   r8oppTpLL3hu6Z2LnDVLpbJTAt+MkBrzDvmTgtHHhoeE7/l1hckCMPINi
   KzD6nopSJ6chtfpOOyShRk0ZEotgPpRsm2c7sLWolAFz25B/i/RSZa9s3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="363148173"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="363148173"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 06:07:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="689984900"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="689984900"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga004.fm.intel.com with ESMTP; 27 Sep 2022 06:07:53 -0700
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, muhammad.husaini.zulkifli@intel.com,
        vinicius.gomes@intel.com, aravindhan.gunasekaran@intel.com,
        noor.azura.ahmad.tarmizi@intel.com
Subject: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Date:   Tue, 27 Sep 2022 21:06:52 +0800
Message-Id: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.5 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=no
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

Muhammad Husaini Zulkifli (3):
  ethtool: Add new hwtstamp flag
  net-timestamp: Increase the size of tsflags
  net: sock: extend SO_TIMESTAMPING for DMA Fetch

Vinicius Costa Gomes (1):
  igc: Add support for DMA timestamp for non-PTP packets

 drivers/net/ethernet/intel/igc/igc.h         | 10 +++
 drivers/net/ethernet/intel/igc/igc_base.h    |  2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  5 +-
 drivers/net/ethernet/intel/igc/igc_main.c    | 24 ++++--
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 83 ++++++++++++++++++++
 include/linux/skbuff.h                       |  3 +
 include/net/sock.h                           | 12 +--
 include/uapi/linux/ethtool.h                 |  3 +
 include/uapi/linux/ethtool_netlink.h         |  1 +
 include/uapi/linux/net_tstamp.h              | 11 ++-
 net/ethtool/common.c                         |  7 ++
 net/ethtool/common.h                         |  2 +
 net/ethtool/strset.c                         |  5 ++
 net/ethtool/tsinfo.c                         | 17 ++++
 net/socket.c                                 |  5 +-
 16 files changed, 175 insertions(+), 17 deletions(-)

--
2.17.1

