Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635B835EB85
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346907AbhDNDpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhDNDpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 23:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F9BD6024A;
        Wed, 14 Apr 2021 03:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618371902;
        bh=F9Fm6AmAgV2UyoQOOv7FMRE2oBXNCyHchp+QaFXMsWA=;
        h=From:To:Cc:Subject:Date:From;
        b=o20w0gE0W6UtvcVrgJu/7LONuju1bwc6sVLNP4hhDde5piDK5G07XZw9UNae9fJ7c
         rthJ5kooYx0hgcm0dTY6ULWWA1Bhmv6JYEr4tfFEST7QbfLffBFuWshWJspw9Py3zh
         Nz158mlTjC0PHQjzJP8hb1I3tHoIA6GtKszd1zVrieXVYwbsDB9ilD87VIBQ9UmrUq
         T1z2N1X8F3NNNNc1jfGniW9W8GY4zhX+my+eiIbLgo7GEo5LsA9KQ7o6cIaVBdp5/5
         RaW3+3BcYh9KYN+5/E2IDJAAvCV7ZUYCKKMw0by7gDpnVbW1o/EU/i9AyY32PIZXir
         UH7QztW/EhAbA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] ethtool: add standard FEC statistics
Date:   Tue, 13 Apr 2021 20:44:48 -0700
Message-Id: <20210414034454.1970967-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set adds uAPI for reporting standard FEC statistics, and
implements it in a handful of drivers.

The statistics are taken from the IEEE standard, with one
extra seemingly popular but not standard statistics added.

The implementation is similar to that of the pause frame
statistics, user requests the stats by setting a bit
(ETHTOOL_FLAG_STATS) in the common ethtool header of
ETHTOOL_MSG_FEC_GET.

Since standard defines the statistics per lane what's
reported is both total and per-lane counters:

 # ethtool  -I --show-fec eth0
 FEC parameters for eth0:
 Configured FEC encodings: None
 Active FEC encoding: None
 Statistics:
  corrected_blocks: 256
    Lane 0: 255
    Lane 1: 1
  uncorrectable_blocks: 145
    Lane 0: 128
    Lane 1: 17


The driver implementations are compile-tested only.
I'm also guessing the semantics, so careful review
from maintainers would be much appreciated!

Jakub Kicinski (6):
  ethtool: move ethtool_stats_init
  ethtool: fec_prepare_data() - jump to error handling
  ethtool: add FEC statistics
  bnxt: implement ethtool::get_fec_stats
  sfc: ef10: implement ethtool::get_fec_stats
  mlx5: implement ethtool::get_fec_stats

 Documentation/networking/ethtool-netlink.rst  | 21 +++++
 Documentation/networking/statistics.rst       |  2 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 15 ++++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  9 +++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 28 ++++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 +
 drivers/net/ethernet/sfc/ef10.c               | 17 ++++
 drivers/net/ethernet/sfc/ethtool.c            | 10 +++
 drivers/net/ethernet/sfc/net_driver.h         |  3 +
 include/linux/ethtool.h                       | 46 +++++++++++
 include/uapi/linux/ethtool_netlink.h          | 14 ++++
 net/ethtool/fec.c                             | 80 ++++++++++++++++++-
 net/ethtool/pause.c                           |  6 --
 13 files changed, 241 insertions(+), 12 deletions(-)

-- 
2.30.2

