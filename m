Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730F15BFF39
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiIUNvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiIUNvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:51:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B3F83046
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B10623C8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4E3C433D6;
        Wed, 21 Sep 2022 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663768281;
        bh=ghieRbZEgzAtaCxAo/N+ZOtV1EjaBZgc4HuhiGWM+Ks=;
        h=From:To:Cc:Subject:Date:From;
        b=TP3CHEa3eRIxYoFJLpKTNs3wfP9tVz0ucsHCcx5qpZm/3iOn7NCD+flr2QrAuG5M4
         BnCMF0SB8bbraUMWEpHVlOeCnaYy65+ZS54/S+y2pvEzBn5XgP2BpWUO/06nH3W8Ff
         nyJ9HAbetGwx6eOvncLpnurzdagJQPYP/jhEHpzGTVWvt8ZAuSH6WIFz7mVK1mqN1h
         Wxbot6essdxao2vR6Du1qCSMU7IS2C7XbDofgrOBh3q5JoZ3IS8Mni/yp8F6nFQ+W7
         a+PO3PoBvVaLkxdDiGYQoqAB61f7s5kKmyr3Tsq3H6DhPQ0kQksGJvEujynYdnf7p5
         SYtdVeZeOX4qg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, sundeep.lkml@gmail.com,
        saeedm@nvidia.com, liorna@nvidia.com, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com,
        sd@queasysnail.net, netdev@vger.kernel.org
Subject: [PATCH net-next 0/7] net: macsec: remove the preparation phase when offloading operations
Date:   Wed, 21 Sep 2022 15:51:11 +0200
Message-Id: <20220921135118.968595-1-atenart@kernel.org>
X-Mailer: git-send-email 2.37.3
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

Hello,

It was reported[1] the 2-step phase offloading of MACsec operations did
not fit well and device drivers were mostly ignoring the first phase
(preparation). In addition the s/w fallback in case h/w rejected an
operation, which could have taken advantage of this design, never was
implemented and it's probably not a good idea anyway (at least
unconditionnally). So let's remove this logic which only makes the code
more complex for no advantage, before there are too many drivers
providing MACsec offloading.

This series removes the first phase (preparation) of the MACsec h/w
offloading. The modifications are split per-driver and in a way that
makes bissection working with logical steps; but I can squash some
patches if needed.

This was tested on the MSCC PHY but not on the Altantic nor mlx5e NICs.

Thanks,
Antoine

[1] https://lore.kernel.org/all/166322893264.61080.12133865599607623050@kwain/T/

Antoine Tenart (7):
  net: phy: mscc: macsec: make the prepare phase a noop
  net: atlantic: macsec: make the prepare phase a noop
  net: macsec: remove the prepare phase when offloading
  net: phy: mscc: macsec: remove checks on the prepare phase
  net: atlantic: macsec: remove checks on the prepare phase
  net/mlx5e: macsec: remove checks on the prepare phase
  net: macsec: remove the prepare flag from the MACsec offloading
    context

 .../ethernet/aquantia/atlantic/aq_macsec.c    |  57 ---------
 .../mellanox/mlx5/core/en_accel/macsec.c      |  36 ------
 drivers/net/macsec.c                          |  14 ---
 drivers/net/phy/mscc/mscc_macsec.c            | 113 ++++++------------
 include/net/macsec.h                          |   2 -
 5 files changed, 39 insertions(+), 183 deletions(-)

-- 
2.37.3

