Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893E5640EE4
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiLBUKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLBUKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:10:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B458F1162
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:10:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CFA4CE1FA6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC66AC433C1;
        Fri,  2 Dec 2022 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011843;
        bh=7QXsFQsjAlHtWFPIrCaA20g5hQp7wcqHMj+0h0qjLao=;
        h=From:To:Cc:Subject:Date:From;
        b=ZGHlhlc9ZHgkPFwBrkw9vh85oCqPyxYb6W3CEy5X7Q4mYOyHH+tB49+oLhms21+p6
         FrdIyYerVwsTpDVBwZtmMe0a1bg7TTSF8RiOf7hwC+Ow55La8gFRQvZjwfAbxkvG8c
         U2ZfHJt+SZVroATox162ocHyAFiX+yDF96kMnV0KwT14eVxKe6To/C/8Y9Dyykb6vt
         v1hY6x8k39J7+5BDmnqPo5DLvGNfCrjSOqd/EvVTXROwf7UduEjZETtk4UIqJUnodF
         CsmJSoS5Fl+pA0K0fhbBZkekXXWJBa6cTqmboorqAiau/ICRAXlnqq8NKVLxrTbZWg
         5Oo5qO5SBADQQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next 00/16] mlx5 IPsec packet offload support (Part I)
Date:   Fri,  2 Dec 2022 22:10:21 +0200
Message-Id: <cover.1670011671.git.leonro@nvidia.com>
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

Hi,

This series follows previously sent "Extend XFRM core to allow packet
offload configuration" series [1].

It is first part with refactoring to mlx5 allow us natively extend
mlx5 IPsec logic to support both crypto and packet offloads.

Thanks

[1] https://lore.kernel.org/all/cover.1670005543.git.leonro@nvidia.com

Leon Romanovsky (16):
  net/mlx5: Return ready to use ASO WQE
  net/mlx5: Add HW definitions for IPsec packet offload
  net/mlx5e: Advertise IPsec packet offload support
  net/mlx5e: Store replay window in XFRM attributes
  net/mlx5e: Remove extra layers of defines
  net/mlx5e: Create symmetric IPsec RX and TX flow steering structs
  net/mlx5e: Use mlx5 print routines for low level IPsec code
  net/mlx5e: Remove accesses to priv for low level IPsec FS code
  net/mlx5e: Create Advanced Steering Operation object for IPsec
  net/mlx5e: Create hardware IPsec packet offload objects
  net/mlx5e: Move IPsec flow table creation to separate function
  net/mlx5e: Refactor FTE setup code to be more clear
  net/mlx5e: Flatten the IPsec RX add rule path
  net/mlx5e: Make clear what IPsec rx_err does
  net/mlx5e: Group IPsec miss handles into separate struct
  net/mlx5e: Generalize creation of default IPsec miss group and rule

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c |   1 -
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  50 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  48 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 629 +++++++++---------
 .../mlx5/core/en_accel/ipsec_offload.c        | 107 ++-
 .../net/ethernet/mellanox/mlx5/core/lib/aso.c |   7 +-
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h |   3 +-
 include/linux/mlx5/mlx5_ifc.h                 |  53 +-
 9 files changed, 543 insertions(+), 356 deletions(-)

-- 
2.38.1

