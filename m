Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1B365DCFE
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbjADTlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240186AbjADTlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:41:42 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E0EF6
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7FK8Dv4g1A559Zizcl1AOG9ci34MqLqcGU62j+fe1RM=; b=G2qACssMdYol7/mKqHGlQFXQ19
        6ZwpX89PeJyY4UDDedFsLjv4PbEqn+sfGyVjpgproXX13VQJ3cGBhrZxvJWt0BiDYrVMBNnmOnOTx
        IjAd/eULcw54EDe0n9jYkgonGTV2zxEJ4Pe8ajjYxXTocRji3JrZp6UjFoGKiN4wkv50=;
Received: from [88.117.53.17] (helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pD9dq-0003c2-0M; Wed, 04 Jan 2023 20:41:38 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 0/9] tsnep: XDP support
Date:   Wed,  4 Jan 2023 20:41:23 +0100
Message-Id: <20230104194132.24637-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement XDP support for tsnep driver. I tried to follow existing
drivers like igb/igc as far as possible. Some prework was already done
in previous patch series, so in this series only actual XDP stuff is
included.

Thanks for the NetDev 0x14 slides "Add XDP support on a NIC driver".

v3:
- use spin_lock_bh for TX (Paolo Abeni)
- add comment for XDP TX descriptor available check (Maciej Fijalkowski)
- return value bool for tsnep_xdp_xmit_frame_ring() (Saeed Mahameed)
- do not print DMA mapping error (Saeed Mahameed)
- use reverse xmas tree variable declaration (Saeed Mahameed)
- move struct xdp_rxq_info to end of struct tsnep_rx (Maciej Fijalkowski)
- check __TSNEP_DOWN flag on close to prevent double free (Saeed Mahameed)
- describe TSNEP_RX_INLINE_METADATA_SIZE in comment (Maciej Fijalkowski)
- substract TSNEP_RX_INLINE_METADATA_SIZE after DMA sync (Maciej Fijalkowski)
- use enum tsnep_tx_type for tsnep_xdp_tx_map (Saeed Mahameed)
- use nxmit as loop iterator in tsnep_netdev_xdp_xmit (Saeed Mahameed)
- stop netdev in tsnep_netdev_close() which is called during BPF prog setup

v2:
- move tsnep_xdp_xmit_back() to commit where it is used (Paolo Abeni)
- remove inline from tsnep_rx_offset() (Paolo Abeni)
- remove inline from tsnep_rx_offset_xdp() (Paolo Abeni)
- simplify tsnep_xdp_run_prog() call by moving xdp_status update to it (Paolo Abeni)

Gerhard Engleder (9):
  tsnep: Use spin_lock_bh for TX
  tsnep: Do not print DMA mapping error
  tsnep: Add adapter down state
  tsnep: Add XDP TX support
  tsnep: Substract TSNEP_RX_INLINE_METADATA_SIZE once
  tsnep: Support XDP BPF program setup
  tsnep: Prepare RX buffer for XDP support
  tsnep: Add RX queue info for XDP support
  tsnep: Add XDP RX support

 drivers/net/ethernet/engleder/Makefile     |   2 +-
 drivers/net/ethernet/engleder/tsnep.h      |  32 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 468 +++++++++++++++++++--
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  27 ++
 4 files changed, 480 insertions(+), 49 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c

-- 
2.30.2

