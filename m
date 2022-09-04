Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8E5AC463
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 15:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiIDNPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 09:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIDNPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 09:15:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943EE2FFE5
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 06:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 203F960F80
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 13:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3939C433C1;
        Sun,  4 Sep 2022 13:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662297348;
        bh=v9Lf8f2kBY+b4vf/rxXCdSAZ+1x5sJiHrj+akrMPhfA=;
        h=From:To:Cc:Subject:Date:From;
        b=SlhjSbtJ6/YEf1ODzrKeLYnsOgtnTIZcEF3vv9Bv1Me2RAO6pQUW9rCErv30o9yYN
         Tq9zdcU93ePWK8oWHiQ23oyCpm7HEMKeE51L46mTwmLDKjQmUa5FBTmxD8gRevSm8q
         1OfrsPjlSjdFNvsWtPs7rkNNtv9NnwNl1HicBim0OkhCZSpXxOQvxcQywvkoJ2Opjo
         XWDYExfMdhsDyjNAqW2k/MZycF2tu9iYGMD++CRVaWfdsrPQf9caZFOQJQ/Pg0sfiq
         vW0EiBXpIe1fai+TWAn1Tq4za3FzbJPPqPkJOOvyEJYv4z9IVhxqvqf6Ci2skpQBKH
         XIf9m8iA8VDBw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full offload configuration
Date:   Sun,  4 Sep 2022 16:15:34 +0300
Message-Id: <cover.1662295929.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v4:
 * Changed title from "PATCH" to "PATCH RFC" per-request.
 * Added two new patches: one to update hard/soft limits and another
   initial take on documentation.
 * Added more info about lifetime/rekeying flow to cover letter, see
   relevant section.
 * perf traces for crypto mode will come later.
v3: https://lore.kernel.org/all/cover.1661260787.git.leonro@nvidia.com
 * I didn't hear any suggestion what term to use instead of
   "full offload", so left it as is. It is used in commit messages
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
offload - full offload.

In this mode, the HW is going to be responsible for the whole data path,
so both policy and state should be offloaded.

IPsec full offload is an improved version of IPsec crypto mode,
In full mode, HW is responsible to trim/add headers in addition to
decrypt/encrypt. In this mode, the packet arrives to the stack as already
decrypted and vice versa for TX (exits to HW as not-encrypted).

Devices that implement IPsec full offload mode offload policies too.
In the RX path, it causes the situation that HW can't effectively
handle mixed SW and HW priorities unless users make sure that HW offloaded
policies have higher priorities.

To make sure that users have a coherent picture, we require that
HW offloaded policies have always (both RX and TX) higher priorities
than SW ones.

To not over-engineer the code, HW policies are treated as SW ones and
don't take into account netdev to allow reuse of the same priorities for
different devices.

There are several deliberate limitations:
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
to fully reuse SW stack.

================================================================================
Configuration:

iproute2: https://lore.kernel.org/netdev/cover.1652179360.git.leonro@nvidia.com/

Full offload mode:
  ip xfrm state offload full dev <if-name> dir <in|out>
  ip xfrm policy .... offload full dev <if-name>
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
| IPsec full offload   | 28     | 57     | 90.7  | 91      | 91.3    | 91.9    |
+----------------------+--------+--------+-------+---------+---------+---------+

IPsec full offload mode behaves as baseline and reaches linerate with same amount
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
  xfrm: add new full offload flag
  xfrm: allow state full offload mode
  xfrm: add an interface to offload policy
  xfrm: add TX datapath support for IPsec full offload mode
  xfrm: add RX datapath protection for IPsec full offload mode
  xfrm: enforce separation between priorities of HW/SW policies
  xfrm: add support to HW update soft and hard limits
  xfrm: document IPsec full offload mode

 Documentation/networking/xfrm_device.rst      |  62 +++++-
 .../inline_crypto/ch_ipsec/chcr_ipsec.c       |   4 +
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |   5 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |   5 +
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   4 +
 drivers/net/netdevsim/ipsec.c                 |   5 +
 include/linux/netdevice.h                     |   4 +
 include/net/netns/xfrm.h                      |   8 +-
 include/net/xfrm.h                            | 121 +++++++++---
 include/uapi/linux/xfrm.h                     |   6 +
 net/xfrm/xfrm_device.c                        | 103 +++++++++-
 net/xfrm/xfrm_output.c                        |  13 +-
 net/xfrm/xfrm_policy.c                        | 181 ++++++++++++++++++
 net/xfrm/xfrm_state.c                         |   4 +
 net/xfrm/xfrm_user.c                          |  19 ++
 15 files changed, 501 insertions(+), 43 deletions(-)

-- 
2.37.2

