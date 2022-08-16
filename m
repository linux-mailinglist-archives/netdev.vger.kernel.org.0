Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEBA595757
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbiHPJ7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiHPJ6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:58:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE2922516
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 408C8B8124C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BE3C433C1;
        Tue, 16 Aug 2022 08:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660640377;
        bh=TYMbP9QFYIAgFSbMUqTmwa6JbobDzHxNcuDp/l8Tea4=;
        h=From:To:Cc:Subject:Date:From;
        b=nDZYt54QBGEDhpPh2MVD+A7Apo00SEiG+WctjtY1M05WqSgT+XcKqJJICY4GkpHZD
         Z7RDTGya8G+HalbFUGpDW+CAWPTj6nFb0Lv5XpBjVYCiydu6sekg8Iul6UFEH6OZlR
         h7Fwz5qLM1Y/F49V9TwI2P8E51dobFwW1WKqQXGnbiLbUiOMylfWdNhoR+5qBOstNB
         gmxOMiMOskN0Fn7p3Yk8E4wrNltZn14HZjVjgsK0GiOWg+mYTnvoNzn+cjdFl6khOD
         L+ns2KcnnL9KOt/lhuPRVH6ax+WeHn83R99dtKMGYdHXLaYlRe9PwB2RBCve8j3mAh
         2pri8i/elfxmA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload configuration
Date:   Tue, 16 Aug 2022 11:59:21 +0300
Message-Id: <cover.1660639789.git.leonro@nvidia.com>
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
v2:
 * Rebased to latest 6.0-rc1
 * Add an extra check in TX datapath patch to validate packets before
   forwarding to HW.
 * Added policy cleanup logic in case of netdev down event 
v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com 
 * Moved comment to be before if (...) in third patch.
v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
-----------------------------------------------------------------------

The following series extends XFRM core code to handle new type of IPsec
offload - full offload.

In this mode, the HW is going to be responsible for whole data path, so
both policy and state should be offloaded.

Thanks

Leon Romanovsky (6):
  xfrm: add new full offload flag
  xfrm: allow state full offload mode
  xfrm: add an interface to offload policy
  xfrm: add TX datapath support for IPsec full offload mode
  xfrm: add RX datapath protection for IPsec full offload mode
  xfrm: enforce separation between priorities of HW/SW policies

 .../inline_crypto/ch_ipsec/chcr_ipsec.c       |   4 +
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |   5 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |   5 +
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   4 +
 drivers/net/netdevsim/ipsec.c                 |   5 +
 include/linux/netdevice.h                     |   3 +
 include/net/netns/xfrm.h                      |   8 +-
 include/net/xfrm.h                            | 104 +++++++---
 include/uapi/linux/xfrm.h                     |   6 +
 net/xfrm/xfrm_device.c                        | 101 +++++++++-
 net/xfrm/xfrm_output.c                        |  20 ++
 net/xfrm/xfrm_policy.c                        | 180 ++++++++++++++++++
 net/xfrm/xfrm_user.c                          |  19 ++
 13 files changed, 434 insertions(+), 30 deletions(-)

-- 
2.37.2

