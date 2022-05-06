Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7639551CF19
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388373AbiEFCzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356409AbiEFCz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:55:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFC25E158
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B33DCE330E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 02:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BE6C385A8;
        Fri,  6 May 2022 02:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651805504;
        bh=i+fxuynWMW8d7ryF6NYjeF+TbBJgZndnXu3ewVFoieM=;
        h=From:To:Cc:Subject:Date:From;
        b=mWOL70ISeqzJUWqWqs0bVgdJ4JHv9F0pba+MI6/wATQdB2MbyNncb8SLYP6pSxAEh
         nxtkZMdNg8lkQGaSy1bz4f44zs8KcFC6CJ4Z/q+zSZUf0z+QedtUl3kLyM8i6QHiHS
         AZFdzvDXI3wQmPxBXheKgolFno/7fj56erHRrKDVXiI+Pse3Vy4c8npHfhCnYTFx6u
         VZH4QeQU7o/gn4Wixq/E2efjH85KvjmH5PuIiGb/wSoStr/wJe1yjMdoaFST1eRj2h
         I3EVSgvCEm28qxd4XNP01yk//CCyOsP9DSZGXLAzPVaJ0Xf+i209IHnMwMFgdUB997
         Kx+vAdU6kw6nA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alexander.duyck@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] net: disambiguate the TSO and GSO limits
Date:   Thu,  5 May 2022 19:51:30 -0700
Message-Id: <20220506025134.794537-1-kuba@kernel.org>
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

This series separates the device-reported TSO limitations
from the user space-controlled GSO limits. It used to be that
we only had the former (HW limits) but they were named GSO.
This probably lead to confusion and letting user override them.

The problem came up in the BIG TCP discussion between Eric and
Alex, and seems like something we should address.

Targeting net-next because (a) nobody is reporting problems;
and (b) there is a tiny but non-zero chance that some actually
wants to lift the HW limitations.

Jakub Kicinski (4):
  net: add netif_inherit_tso_max()
  net: don't allow user space to lift the device limits
  net: make drivers set the TSO limit not the GSO limit
  net: move netif_set_gso_max helpers

 drivers/net/bonding/bond_main.c               | 12 ++---
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  2 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  2 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/freescale/fec_main.c     |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  5 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  8 ++--
 drivers/net/ethernet/sfc/ef100_nic.c          |  9 ++--
 drivers/net/ethernet/sfc/efx.c                |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  2 +-
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/ipvlan/ipvlan_main.c              |  6 +--
 drivers/net/macvlan.c                         |  6 +--
 drivers/net/usb/aqc111.c                      |  2 +-
 drivers/net/usb/ax88179_178a.c                |  2 +-
 drivers/net/usb/lan78xx.c                     |  2 +-
 drivers/net/usb/r8152.c                       |  2 +-
 drivers/net/veth.c                            |  3 +-
 drivers/net/vxlan/vxlan_core.c                |  3 +-
 drivers/s390/net/qeth_l2_main.c               |  2 +-
 drivers/s390/net/qeth_l3_main.c               |  2 +-
 include/linux/netdevice.h                     | 31 +++++-------
 net/8021q/vlan.c                              |  3 +-
 net/8021q/vlan_dev.c                          |  3 +-
 net/bridge/br_if.c                            | 12 ++---
 net/core/dev.c                                | 47 +++++++++++++++++++
 net/core/dev.h                                | 21 +++++++++
 net/core/rtnetlink.c                          |  4 +-
 37 files changed, 137 insertions(+), 84 deletions(-)

-- 
2.34.1

