Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B27B51DE23
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444093AbiEFRLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444122AbiEFRLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:11:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5157A6A417
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92BC0B836B6
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 17:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12329C385A9;
        Fri,  6 May 2022 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651856877;
        bh=zqK4VTWEi6oghhNfX8YTb2Wb6+l+lsj/p4CtBCAa/Wg=;
        h=From:To:Cc:Subject:Date:From;
        b=rvEoneho09p+smG8v9JUtycJai5UDNsYylM/pqFmRlh5KCf1XibxVpT0x6XOkoO0S
         uuITzrCnpBqfbbqKy9mZJmwhjqv5JUDVDZN6r68+UP+K99IWkmHxORvz57DBFk8OcC
         8Bw5uDXjN/phtRGtVP5lY2e8qmwNGRCHXEihYJbYHfpxWWTCARWUfXUL2dFb7I/kB6
         tw0egMoM38lDpUY/HOIdzq9Xz7OSbRdbP0hMaVpfKr9ZZ6aMls2Jr327BSPnOP/hOA
         0QzKHuUNdngLmgzIg6dTifiuITef1j1HFbZZ1ZmBCZArGfciU8jKkyeUI/goQH621v
         NQ3Xy6xvGoZFg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] net: switch drivers to netif_napi_add_weight()
Date:   Fri,  6 May 2022 10:07:45 -0700
Message-Id: <20220506170751.822862-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
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

The minority of drivers pass a custom weight to netif_napi_add().
Switch those away to the new netif_napi_add_weight(). All drivers
(which can go thru net-next) calling netif_napi_add() will now
be calling it with NAPI_POLL_WEIGHT or 64.

Jakub Kicinski (6):
  um: vector: switch to netif_napi_add_weight()
  caif_virtio: switch to netif_napi_add_weight()
  eth: switch to netif_napi_add_weight()
  r8152: switch to netif_napi_add_weight()
  net: virtio: switch to netif_napi_add_weight()
  net: wan: switch to netif_napi_add_weight()

 arch/um/drivers/vector_kern.c                         | 3 ++-
 drivers/net/caif/caif_virtio.c                        | 3 ++-
 drivers/net/ethernet/3com/typhoon.c                   | 2 +-
 drivers/net/ethernet/adaptec/starfire.c               | 2 +-
 drivers/net/ethernet/amd/amd8111e.c                   | 2 +-
 drivers/net/ethernet/amd/pcnet32.c                    | 3 ++-
 drivers/net/ethernet/arc/emac_main.c                  | 3 ++-
 drivers/net/ethernet/atheros/ag71xx.c                 | 3 ++-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c          | 4 ++--
 drivers/net/ethernet/broadcom/sb1250-mac.c            | 2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c           | 2 +-
 drivers/net/ethernet/ezchip/nps_enet.c                | 4 ++--
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 3 ++-
 drivers/net/ethernet/hisilicon/hisi_femac.c           | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c          | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c          | 3 ++-
 drivers/net/ethernet/ibm/emac/mal.c                   | 4 ++--
 drivers/net/ethernet/ibm/ibmveth.c                    | 2 +-
 drivers/net/ethernet/intel/e100.c                     | 2 +-
 drivers/net/ethernet/lantiq_etop.c                    | 8 ++++----
 drivers/net/ethernet/marvell/pxa168_eth.c             | 3 ++-
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c   | 3 ++-
 drivers/net/ethernet/microsoft/mana/mana_en.c         | 2 +-
 drivers/net/ethernet/moxa/moxart_ether.c              | 2 +-
 drivers/net/ethernet/mscc/ocelot_fdma.c               | 4 ++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c      | 4 ++--
 drivers/net/ethernet/neterion/vxge/vxge-main.c        | 9 +++++----
 drivers/net/ethernet/nxp/lpc_eth.c                    | 2 +-
 drivers/net/ethernet/realtek/8139cp.c                 | 2 +-
 drivers/net/ethernet/sfc/efx_channels.c               | 4 ++--
 drivers/net/ethernet/sfc/falcon/efx.c                 | 4 ++--
 drivers/net/ethernet/smsc/smsc911x.c                  | 3 ++-
 drivers/net/ethernet/toshiba/tc35815.c                | 2 +-
 drivers/net/ethernet/wiznet/w5100.c                   | 2 +-
 drivers/net/ethernet/wiznet/w5300.c                   | 2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c              | 2 +-
 drivers/net/usb/r8152.c                               | 6 ++----
 drivers/net/virtio_net.c                              | 4 ++--
 drivers/net/wan/fsl_ucc_hdlc.c                        | 2 +-
 drivers/net/wan/hd64572.c                             | 3 ++-
 drivers/net/wan/ixp4xx_hss.c                          | 2 +-
 drivers/net/wan/lapbether.c                           | 2 +-
 42 files changed, 71 insertions(+), 59 deletions(-)

-- 
2.34.1

