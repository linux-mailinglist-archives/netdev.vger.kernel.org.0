Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE0679723
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjAXL7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjAXL7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:59:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F11541B61;
        Tue, 24 Jan 2023 03:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5782FB810F7;
        Tue, 24 Jan 2023 11:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A38C433D2;
        Tue, 24 Jan 2023 11:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674561575;
        bh=YZ+vBu4ztT6wwThgjIPo2vsGVB02GGGHCVkvRdgZXYA=;
        h=From:To:Cc:Subject:Date:From;
        b=Vudp/uaBjlLkgY5TVF3F3D2/WJGfRGkddKr3VLOxk+p4tB+Rn9tJncLf9nK+FqAR9
         Ubn4IucGXYwUH/Nb9hMHy+CQ0C7Ps4SF44nvR6qlGIlsdTt6xU0laZp3IDEebgaM4o
         zBW1aCuFpPUvir2xueZVzX/TiNtNIE07xgy7CWwaAUVYwuMHHxBqtGhyn75G1ErWd6
         m01kB1YTt5UWRcRHugmd1mOQRdgLQjuvzxh328bKIeHO5YKZP1nx7oZ9KZfWFNtFVe
         cSwzyXJlzprD7wJQMiR2pFRE7CrjjaoAM7sD35IrqeiwDNVAdvML3wt9oc8v7PdSBA
         QmduvV/iO+orw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: [PATCH net-next v1 00/10] Convert drivers to return XFRM configuration errors through extack
Date:   Tue, 24 Jan 2023 13:54:56 +0200
Message-Id: <cover.1674560845.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.1
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

Changelog
v1:
 * Fixed rebase errors in mlx5 and cxgb4 drivers
 * Fixed previously existed typo in nfp driver
 * Added Simon's ROB
 * Removed my double SOB tags
v0: https://lore.kernel.org/all/cover.1674481435.git.leon@kernel.org

---------------------------------------------------------------------------

Hi,

This series continues effort started by Sabrina to return XFRM configuration
errors through extack. It allows for user space software stack easily present
driver failure reasons to users.

As a note, Intel drivers have a path where extack is equal to NULL, and error
prints won't be available in current patchset. If it is needed, it can be
changed by adding special to Intel macro to print to dmesg in case of
extack == NULL.

Thanks

Leon Romanovsky (10):
  xfrm: extend add policy callback to set failure reason
  net/mlx5e: Fill IPsec policy validation failure reason
  xfrm: extend add state callback to set failure reason
  net/mlx5e: Fill IPsec state validation failure reason
  netdevsim: Fill IPsec state validation failure reason
  nfp: fill IPsec state validation failure reason
  ixgbevf: fill IPsec state validation failure reason
  ixgbe: fill IPsec state validation failure reason
  bonding: fill IPsec state validation failure reason
  cxgb4: fill IPsec state validation failure reason

 Documentation/networking/xfrm_device.rst      |   4 +-
 drivers/net/bonding/bond_main.c               |  10 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   8 +-
 .../inline_crypto/ch_ipsec/chcr_ipsec.c       |  34 +++---
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |  27 ++---
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  21 ++--
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 103 ++++++++----------
 .../net/ethernet/netronome/nfp/crypto/ipsec.c |  41 +++----
 drivers/net/netdevsim/ipsec.c                 |  14 +--
 include/linux/netdevice.h                     |   4 +-
 net/xfrm/xfrm_device.c                        |   9 +-
 net/xfrm/xfrm_state.c                         |   2 +-
 12 files changed, 137 insertions(+), 140 deletions(-)

-- 
2.39.1

