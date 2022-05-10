Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479BB52124D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiEJKlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbiEJKlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:41:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D522609FC
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2AF8B81CB3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35179C385C6;
        Tue, 10 May 2022 10:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652179023;
        bh=ihrvZmN2F4uvZeVG17dLxgVShXcGNuymwbG//FQtals=;
        h=From:To:Cc:Subject:Date:From;
        b=pj+bA/QQBmQV+/rOaWAhfr7OOJ/VLb+VA66k1BjruEKs5h2qhmXFZt2D3HOPMRc5T
         ZAq0jLYc2RYc6n47LfaNEC2JR9zg1h32acymazFOVX8bdcsAm+rMQdKKUmXHV+QcYg
         92cg6OSq163rJG8M5RoZVUfUb4gz/dvtrW65EG2srcKWSe3HhLpz19H+frhNPkRdGr
         4GbErulm3fb8Xp8pmWYEBTtqH7bfuhtyKyreBdo09Euvze3ksCsqqMYpbHFqS7kkf9
         KOA6PuvIaSBa6/ojwlKuj1sm3GbvwD2/IOcmG5nqBdAhdViiOllqfGSup7gE8RE4Xm
         CKLY8vUgQBQ2w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH ipsec-next 0/6] Extend XFRM core to allow full offload configuration
Date:   Tue, 10 May 2022 13:36:51 +0300
Message-Id: <cover.1652176932.git.leonro@nvidia.com>
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

The following series extends XFRM core code to handle new type of IPsec
offload - full offload.

In this mode, the HW is going to be responsible for whole data path, so
both policy and state should be offloaded.

The mlx5 part is coming.

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
 include/net/xfrm.h                            | 102 ++++++++++++----
 include/uapi/linux/xfrm.h                     |   6 +
 net/xfrm/xfrm_device.c                        |  84 ++++++++++++-
 net/xfrm/xfrm_output.c                        |  19 +++
 net/xfrm/xfrm_policy.c                        | 115 ++++++++++++++++++
 net/xfrm/xfrm_user.c                          |  11 ++
 13 files changed, 342 insertions(+), 29 deletions(-)

-- 
2.35.1

