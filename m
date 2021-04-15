Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9383615B4
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbhDOWxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234854AbhDOWxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06E756008E;
        Thu, 15 Apr 2021 22:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618527200;
        bh=cYw49w2FpCcTeCZtuTdHwyToqAnECEd+kZAyvZR6kyA=;
        h=From:To:Cc:Subject:Date:From;
        b=tQL5uif5DwKKNJsLfVyq06YAKqeC3X0v/S3A8lAbQGzkFxwFF5Qdjxnwf6eiZeJz4
         4HoPIXjxNh3Fouwwx0zeXIvxWRujV2+zMOmDY03ozJ92C0Xh2LdiPT7rJp2q9Q+xGx
         GUaQiPHHLZXdPDuS/WTWRFDu0Sc0x4wkX4i0xy3SBDsz7G198YCyXCIsQ+RyMQubln
         BRBsE6nWxIacYfx5VL4/7g1w6Bvg/OEbhnWZPPagJtwlpExDiQ38MEj9ZxnMar1B1Y
         R7JvJ84IO/5hWT5A81WBZfcynQPa4z9v2dj8qYKeWeXWf1t7X5ru6U2/ljVZhDY4Ih
         Vk8KRkWiqcrng==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/6] ethtool: add standard FEC statistics
Date:   Thu, 15 Apr 2021 15:53:12 -0700
Message-Id: <20210415225318.2726095-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

 # ethtool -I --show-fec eth0
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

v2: check for errors in mlx5 register access

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
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 29 ++++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 +
 drivers/net/ethernet/sfc/ef10.c               | 17 ++++
 drivers/net/ethernet/sfc/ethtool.c            | 10 +++
 drivers/net/ethernet/sfc/net_driver.h         |  3 +
 include/linux/ethtool.h                       | 46 +++++++++++
 include/uapi/linux/ethtool_netlink.h          | 14 ++++
 net/ethtool/fec.c                             | 80 ++++++++++++++++++-
 net/ethtool/pause.c                           |  6 --
 13 files changed, 242 insertions(+), 12 deletions(-)

-- 
2.30.2

