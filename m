Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBCD6CFD9F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjC3IDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjC3ICp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:02:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E706E80
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FD5C61F45
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF17C433EF;
        Thu, 30 Mar 2023 08:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163364;
        bh=p9yvJqFXy31tpK2c4KHroRQ7IIPn+bQfZkcqZaplQic=;
        h=From:To:Cc:Subject:Date:From;
        b=mfffDzRegRUAKGPnLrllvk/eQeM3qdExPsYh2a6uJW4N3WejtI30yRG1TYHJzdsjL
         BOFGyjEQPjUJGFRcPxXjvInmFyqYnzmhAlXbr70vDM5w/MsiU1vwqnbIE7Hsy+v6Pq
         DVoihaMsitLhSBW/ScD5CkmVW8Q3EzipjPLP+/jfyPIuMtxB2lRFAfrGGpkDa2TG+R
         WNX7xQfBvNDTZEycDJ0+sOHjoeLE2eifJXAElVPznq0qDCfc4/uEctId2AZVlOQbyc
         NgEKiM+wCRXQdQP8OxR+UihKAyuah856iHxsMgRDOBYDKp4suPpnxTb2/+egS3dAl8
         e1BgGzAZf9wFg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 00/10] Improve IPsec limits, ESN and replay window in mlx5
Date:   Thu, 30 Mar 2023 11:02:21 +0300
Message-Id: <cover.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This series overcomes existing hardware limitations in Mellanox ConnectX
devices around handling IPsec soft and hard limits.

In addition, the ESN logic is tied and added an interface to configure
replay window sequence numbers through existing iproute2 interface.

  ip xfrm state ... [ replay-seq SEQ ] [ replay-oseq SEQ ] 
		    [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]

Thanks

Leon Romanovsky (10):
  net/mlx5e: Factor out IPsec ASO update function
  net/mlx5e: Prevent zero IPsec soft/hard limits
  net/mlx5e: Add SW implementation to support IPsec 64 bit soft and hard
    limits
  net/mlx5e: Overcome slow response for first IPsec ASO WQE
  xfrm: don't require advance ESN callback for packet offload
  net/mlx5e: Remove ESN callbacks if it is not supported
  net/mlx5e: Set IPsec replay sequence numbers
  net/mlx5e: Reduce contention in IPsec workqueue
  net/mlx5e: Generalize IPsec work structs
  net/mlx5e: Simulate missing IPsec TX limits hardware functionality

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 329 +++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  47 ++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  31 +-
 .../mlx5/core/en_accel/ipsec_offload.c        | 198 ++++++++---
 net/xfrm/xfrm_device.c                        |   2 +-
 5 files changed, 496 insertions(+), 111 deletions(-)

-- 
2.39.2

