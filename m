Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7975B51BCC5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbiEEKKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiEEKKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:10:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B96210DC
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 878F3CE2CC2
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE7EC385A4;
        Thu,  5 May 2022 10:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651745213;
        bh=ObWDA2SCWwhf8rEgifXrmUVxwSxqpiajpOZA6fDCahk=;
        h=From:To:Cc:Subject:Date:From;
        b=a4ky+JXUTuuPpxBkOR+Bn+zZ5+k3DhNXJmQJwCsa64FFSkuRXXO/MEmOvDN/K1jWG
         O6qiIRfLK1BnS60qoayp8HW08dCTYS8W4Vgfm6gR6Ced8e9RgkzkIcSVFuvpCMniew
         5sdCxoD2I5Ivcbsw68wKhrdVy1CI79rAguiaXJBCNSD2daukPId/BB1NvJC5JNVJtf
         iNEPIbiKDxDHIfkrgnTH8JOQFQOMReKzXMPluroE1PYbf7paXj7M0eY9Rv+oSrCBkm
         75VscNLxQCYp3obtNWrjay0aQPb/UeHMBOkVD9BcGIWhTbQLvY420V2t8qnjbgpmUs
         gBsx/e1smRj6g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH ipsec-next 0/8] Be explicit with XFRM offload direction
Date:   Thu,  5 May 2022 13:06:37 +0300
Message-Id: <cover.1651743750.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi Steffen,

I may admit that the title of this series is not the best one as it
contains straightforward cleanups and code that converts flags to
something less confusing.

This series follows removal of FPGA IPsec code from the mlx5 driver and
based on net-next commit 4950b6990e3b ("Merge branch 'ocelot-vcap-cleanups'").

As such, first two patches delete code that was used by mlx5 FPGA code
but isn't needed anymore.

Third patch is simple struct rename.

Rest of the patches separate user's provided flags variable from driver's
usage. This allows us to created more simple in-kernel interface, that
supports type checking without blending different properties into one
variable. It is achieved by converting flags to specific bitfield variables
with clear, meaningful names.
    
Such change allows us more clear addition of new input flags needed to
mark IPsec offload type.

The followup code uses this extensively:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next

Thanks

Leon Romanovsky (8):
  xfrm: free not used XFRM_ESP_NO_TRAILER flag
  xfrm: delete not used number of external headers
  xfrm: rename xfrm_state_offload struct to allow reuse
  xfrm: store and rely on direction to construct offload flags
  ixgbe: propagate XFRM offload state direction instead of flags
  netdevsim: rely on XFRM state direction instead of flags
  net/mlx5e: Use XFRM state direction instead of flags
  xfrm: drop not needed flags variable in XFRM offload struct

 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |  9 ++++-----
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.h    |  2 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  6 +++---
 drivers/net/ethernet/intel/ixgbevf/ipsec.h    |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 +++++-----
 drivers/net/netdevsim/ipsec.c                 |  2 +-
 include/net/xfrm.h                            | 20 +++++++++++--------
 net/ipv4/esp4.c                               |  6 ------
 net/ipv6/esp6.c                               |  6 ------
 net/xfrm/xfrm_device.c                        | 15 +++++++-------
 net/xfrm/xfrm_state.c                         |  4 ++--
 net/xfrm/xfrm_user.c                          |  5 +++--
 12 files changed, 40 insertions(+), 47 deletions(-)

-- 
2.35.1

