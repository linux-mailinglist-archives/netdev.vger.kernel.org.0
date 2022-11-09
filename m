Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1136E622BEB
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiKIMyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIMyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:54:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A64175A9
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:54:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07628B81E60
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D1CC433D6;
        Wed,  9 Nov 2022 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667998480;
        bh=xUAT2iVPUbPiJXY+E5GnqB/urlVMFZNIsM1qxztY0YM=;
        h=From:To:Cc:Subject:Date:From;
        b=jOAjgaswoVvt3nZEi/zv3x6vrVja+4AmfJkc6DG9SwQFTsrHAtwjW/SxhFw2Or9Pr
         adKqIgXbpZYdAh6Jxq+IbOcfTKppE+/ZhyQCFSwqBZiswS2kkAMRQ1XZB7ybZrfVEU
         1Kr/8YYQuGF8wdRtlXd0RrRaNcnfjsiGiWdsnj7wTwdH6f5Hk06GMococcGAedm2gi
         9go9Gmv0+uBxeg14firlgAHBgg2Ryz7/p28FUuzTFP4Ww3VpuONLCQk26lR/jgVTdM
         m9q1VQTGdKRTZKTK+VGDfTXuMkuCukD19pFj8SntPkn6ywuHs82gUC9ztY0I/4RXB8
         NHlxmBvBkfTig==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH xfrm-next v7 0/8] Extend XFRM core to allow packet offload configuration
Date:   Wed,  9 Nov 2022 14:54:28 +0200
Message-Id: <cover.1667997522.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v7: As was discussed in IPsec workshop:
 * Renamed "full offload" to be "packet offload".
 * Added check that offloaded SA and policy have same device while sending packet
 * Added to SAD same optimization as was done for SPD to speed-up lookups.
v6: https://lore.kernel.org/all/cover.1666692948.git.leonro@nvidia.com
 * Fixed misplaced "!" in sixth patch.
v5: https://lore.kernel.org/all/cover.1666525321.git.leonro@nvidia.com
 * Rebased to latest ipsec-next.
 * Replaced HW priority patch with solution which mimics separated SPDs
   for SW and HW. See more description in this cover letter.
 * Dropped RFC tag, usecase, API and implementation are clear.
v4: https://lore.kernel.org/all/cover.1662295929.git.leonro@nvidia.com
 * Changed title from "PATCH" to "PATCH RFC" per-request.
 * Added two new patches: one to update hard/soft limits and another
   initial take on documentation.
 * Added more info about lifetime/rekeying flow to cover letter, see
   relevant section.
 * perf traces for crypto mode will come later.
v3: https://lore.kernel.org/all/cover.1661260787.git.leonro@nvidia.com
 * I didn't hear any suggestion what term to use instead of
   "packet offload", so left it as is. It is used in commit messages
   and documentation only and easy to rename.
 * Added performance data and background info to cover letter
 * Reused xfrm_output_resume() function to support multiple XFRM transformations
 * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
 * Documentation is in progress, but not part of this series yet.
v2: https://lore.kernel.org/all/cover.1660639789.git.leonro@nvidia.com
 * Rebased to latest 6.0-rc1
 * Add an extra check in TX datapath patch to validate packets before
   forwarding to HW.
 * Added policy cleanup logic in case of netdev down event
v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com
 * Moved comment to be before if (...) in third patch.
v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
-----------------------------------------------------------------------

The following series extends XFRM core code to handle a new type of IPsec
offload - packet offload.

In this mode, the HW is going to be responsible for the whole data path,
so both policy and state should be offloaded.

IPsec packet offload is an improved version of IPsec crypto mode,
In packet mode, HW is responsible to trim/add headers in addition to
decrypt/encrypt. In this mode, the packet arrives to the stack as already
decrypted and vice versa for TX (exits to HW as not-encrypted).

Devices that implement IPsec packet offload mode offload policies too.
In the RX path, it causes the situation that HW can't effectively
handle mixed SW and HW priorities unless users make sure that HW offloaded
policies have higher priorities.

It means that we don't need to perform any search of inexact policies
and/or priority checks if HW policy was discovered. In such situation,
the HW will catch the packets anyway and HW can still implement inexact
lookups.

In case specific policy is not found, we will continue with packet lookup
and check for existence of HW policies in inexact list.

HW policies are added to the head of SPD to ensure fast lookup, as XFRM
iterates over all policies in the loop.

This simple solution allows us to achieve same benefits of separate HW/SW
policies databases without over-engineering the code to iterate and manage
two databases at the same path.

To not over-engineer the code, HW policies are treated as SW ones and
don't take into account netdev to allow reuse of the same priorities for
policies databases without over-engineering the code to iterate and manage
two databases at the same path.

To not over-engineer the code, HW policies are treated as SW ones and
don't take into account netdev to allow reuse of the same priorities for
different devices.
 * No software fallback
 * Fragments are dropped, both in RX and TX
 * No sockets policies
 * Only IPsec transport mode is implemented

================================================================================
Rekeying:

In order to support rekeying, as XFRM core is skipped, the HW/driver should
do the following:
 * Count the handled packets
 * Raise event that limits are reached
 * Drop packets once hard limit is occurred.

The XFRM core calls to newly introduced xfrm_dev_state_update_curlft()
function in order to perform sync between device statistics and internal
structures. On HW limit event, driver calls to xfrm_state_check_expire()
to allow XFRM core take relevant decisions.

This separation between control logic (in XFRM) and data plane allows us
to packet reuse SW stack.

================================================================================
Configuration:

iproute2: https://lore.kernel.org/netdev/cover.1652179360.git.leonro@nvidia.com/

Full offload mode:
  ip xfrm state offload packet dev <if-name> dir <in|out>
  ip xfrm policy .... offload packet dev <if-name>
Crypto offload mode:
  ip xfrm state offload crypto dev <if-name> dir <in|out>
or (backward compatibility)
  ip xfrm state offload dev <if-name> dir <in|out>

================================================================================
Performance results:

TCP multi-stream, using iperf3 instance per-CPU.
+----------------------+--------+--------+--------+--------+---------+---------+
|                      | 1 CPU  | 2 CPUs | 4 CPUs | 8 CPUs | 16 CPUs | 32 CPUs |
|                      +--------+--------+--------+--------+---------+---------+
|                      |                   BW (Gbps)                           |
+----------------------+--------+--------+-------+---------+---------+---------+
| Baseline             | 27.9   | 59     | 93.1  | 92.8    | 93.7    | 94.4    |
+----------------------+--------+--------+-------+---------+---------+---------+
| Software IPsec       | 6      | 11.9   | 23.3  | 45.9    | 83.8    | 91.8    |
+----------------------+--------+--------+-------+---------+---------+---------+
| IPsec crypto offload | 15     | 29.7   | 58.5  | 89.6    | 90.4    | 90.8    |
+----------------------+--------+--------+-------+---------+---------+---------+
| IPsec packet offload   | 28     | 57     | 90.7  | 91      | 91.3    | 91.9    |
IPsec packet offload mode behaves as baseline and reaches linerate with same amount
of CPUs.

Setups details (similar for both sides):
* NIC: ConnectX6-DX dual port, 100 Gbps each.
  Single port used in the tests.
* CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz

================================================================================
Series together with mlx5 part:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next

Thanks

Leon Romanovsky (8):
  xfrm: add new packet offload flag
  xfrm: allow state packet offload mode
  xfrm: add an interface to offload policy
  xfrm: add TX datapath support for IPsec packet offload mode
  xfrm: add RX datapath protection for IPsec packet offload mode
  xfrm: speed-up lookup of HW policies
  xfrm: add support to HW update soft and hard limits
  xfrm: document IPsec packet offload mode

 Documentation/networking/xfrm_device.rst      |  62 +++++++--
 .../inline_crypto/ch_ipsec/chcr_ipsec.c       |   4 +
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |   5 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |   5 +
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   4 +
 drivers/net/netdevsim/ipsec.c                 |   5 +
 include/linux/netdevice.h                     |   4 +
 include/net/xfrm.h                            | 124 ++++++++++++++----
 include/uapi/linux/xfrm.h                     |   6 +
 net/xfrm/xfrm_device.c                        | 109 +++++++++++++--
 net/xfrm/xfrm_output.c                        |  13 +-
 net/xfrm/xfrm_policy.c                        | 106 ++++++++++++++-
 net/xfrm/xfrm_state.c                         |  70 +++++++---
 net/xfrm/xfrm_user.c                          |  20 +++
 14 files changed, 474 insertions(+), 63 deletions(-)

-- 
2.38.1

