Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3865E677D55
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjAWOAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjAWOAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9502E24105;
        Mon, 23 Jan 2023 06:00:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32AB160EFF;
        Mon, 23 Jan 2023 14:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D571BC433D2;
        Mon, 23 Jan 2023 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674482435;
        bh=aPVU2diHca38fcYua3CN44olBe3ZpG8pTkjRl2MYVKE=;
        h=From:To:Cc:Subject:Date:From;
        b=f47THf1PbZArFbvUjR5AdbPNRcaNzdbx+B5hf/SNtE5TcK41fYAlqUsRPSUgpQqwG
         McMV6bPkaXZf5mePWS5QTfjmASZSZWLfKxkfDx74OnW8g1UpCK66P4kNvjipFc4cha
         QBECceSWW8jbKYp3wOv6VCCdMLNlfqEE5YrwO+mesOPxTI5Y3+1rUdKpwbQjj0C7VA
         ONi56FY6hOnH9aN7Kj5Dw+m64Gf2XNsExFIMea4kx5ThUums8xMNhbYlylBhlnysCA
         HWyrIVI3CbDDcKcz9Jq41UQRDE71ceUSjbZCWz+LD+wpePxvQmwFmZaEi3U5FTF/WV
         A7YI6UYf7ZmNA==
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
Subject: [PATCH net-next 00/10] Convert drivers to return XFRM configuration errors through extack
Date:   Mon, 23 Jan 2023 16:00:13 +0200
Message-Id: <cover.1674481435.git.leon@kernel.org>
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

