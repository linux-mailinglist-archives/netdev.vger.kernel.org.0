Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA381D5D9D
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 03:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgEPBaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 21:30:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:60902 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgEPBaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 21:30:02 -0400
IronPort-SDR: 0+JP+BgS2rIl5zS2caon6INxJ6G1/NXFKHk6YdDmINmMwpUMEM73RlcQBJvFfa1QIKMpaZIm4D
 Z3ijd3u3Y+dQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 18:30:01 -0700
IronPort-SDR: c/1wXf/KexM6fjgEE6TwkFvVC4jFoJ/IJtxuNnt9d9ZaAAZKjpTyHuTRMebdkaI2OxJ3j101kr
 JEF3iufYlTnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,397,1583222400"; 
   d="scan'208";a="307569128"
Received: from wkbertra-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.131.129])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2020 18:30:01 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: [next-queue RFC 0/4] ethtool: Add support for frame preemption
Date:   Fri, 15 May 2020 18:29:44 -0700
Message-Id: <20200516012948.3173993-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for configuring frame preemption, as defined
by IEEE 802.1Q-2018 (previously IEEE 802.1Qbu) and IEEE 802.3br.

Frame preemption allows a packet from a higher priority queue marked
as "express" to preempt a packet from lower priority queue marked as
"preemptible". The idea is that this can help reduce the latency for
higher priority traffic.

Previously, the proposed interface for configuring these features was
using the qdisc layer. But as this is very hardware dependent and all
that qdisc did was pass the information to the driver, it makes sense
to have this in ethtool.

One example, for retrieving and setting the configuration:

$ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
Frame preemption settings for enp3s0:
	support: supported
	active: active
	supported queues: 0xf
	supported queues: 0xe
	minimum fragment size: 68


$ ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68 preemptible-queues-mask 0xe

This is a RFC because I wanted to have feedback on some points:

  - The parameters added are enough for the hardware I have, is it
    enough in general?

  - even with the ethtool via netlink effort, I chose to keep the
    ioctl() way, in case someone wants to backport this to an older
    kernel, is there a problem with this?

  - Some space for bikeshedding the names and location (for example,
    does it make sense for these settings to be per-queue?), as I am
    not quite happy with them, one example, is the use of preemptible
    vs. preemptable;


About the patches, should be quite straightforward:

Patch 1, adds the ETHTOOL_GFP and ETHOOL_SFP commands and the
associated data structures;

Patch 2, adds the ETHTOOL_MSG_PREEMPT_GET and ETHTOOL_MSG_PREEMPT_SET
netlink messages and the associated attributes;

Patch 3, is the example implementation for the igc driver, the catch
here is that frame preemption in igc is dependent on the TSN "mode"
being enabled;

Patch 4, adds some registers that helped during implementation.

Another thing is that because igc is still under development, to avoid
conflicts, I think it might be easier for the PATCH version of this
series to go through Jeff Kirsher's tree.

Vinicius Costa Gomes (4):
  ethtool: Add support for configuring frame preemption
  ethtool: Add support for configuring frame preemption via netlink
  igc: Add support for configuring frame preemption
  igc: Add support for exposing frame preemption stats registers

 drivers/net/ethernet/intel/igc/igc.h         |   3 +
 drivers/net/ethernet/intel/igc/igc_defines.h |   6 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  77 ++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  10 +
 drivers/net/ethernet/intel/igc/igc_tsn.c     |  46 ++++-
 include/linux/ethtool.h                      |   6 +
 include/uapi/linux/ethtool.h                 |  25 +++
 include/uapi/linux/ethtool_netlink.h         |  19 ++
 net/ethtool/Makefile                         |   3 +-
 net/ethtool/ioctl.c                          |  36 ++++
 net/ethtool/netlink.c                        |  15 ++
 net/ethtool/netlink.h                        |   2 +
 net/ethtool/preempt.c                        | 181 +++++++++++++++++++
 13 files changed, 423 insertions(+), 6 deletions(-)
 create mode 100644 net/ethtool/preempt.c

-- 
2.26.2

