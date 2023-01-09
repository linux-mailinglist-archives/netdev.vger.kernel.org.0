Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B26663021
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbjAITPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbjAITPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:15:32 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EE763EB
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VyOeAhxPhw27XdNUl4fWabSwyMJI6Y75gK5YFmb77mg=; b=nMAe5ZCKKdHWqDuB/xbBRJKHU/
        R61XFtWCTRgGqMLND1oRR82j+s8LqC0wkrp/bORdESm1t3rmps6fuAKUN9gnxu8JkPXnN6SzAwV8v
        B8HwMRowxNkH/YAlnZwKNKz68YuBlHAiPz4+FNMHEatbKs0XPFmtwejHUx2NN/k8P5Ic=;
Received: from [88.117.53.243] (helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pExcF-0007WQ-6N; Mon, 09 Jan 2023 20:15:27 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 00/10] tsnep: XDP support
Date:   Mon,  9 Jan 2023 20:15:13 +0100
Message-Id: <20230109191523.12070-1-gerhard@engleder-embedded.com>
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

Some commits contain changes not related to XDP but found during review
of XDP support patches.

v4:
- remove process context from spin_lock_bh commit message (Alexander Lobakin)
- move tsnep_adapter::state to prevent 4 byte hole (Alexander Lobakin)
- braces for bitops in combination logical ops (Alexander Lobakin)
- make various pointers const (Alexander Lobakin)
- '!i' instead of 'i == 0' (Alexander Lobakin)
- removed redundant braces (Alexander Lobakin)
- squash variables into same line if same type (Alexander Lobakin)
- use fact that ::skb and ::xdpf use same slot for simplification (Alexander Lobakin)
- use u32 for smp_processor_id() (Alexander Lobakin)
- don't add $(tsnep-y) to $(tsnep-objs) (Alexander Lobakin)
- use rev xmas tree in tsnep_netdev_open() (Alexander Lobakin)
- do not move tsnep_queue::napi (Alexander Lobakin)
- call xdp_init_buff() only once (Alexander Lobakin)
- get nq and tx only once for XDP TX (Alexander Lobakin)
- move XDP BPF program setup to end of patch series (Alexander Lobakin)
- check for XDP state change and prevent redundant down-ups (Alexander Lobakin)
- access tsnep_adapter::xdp_prog only with READ_ONCE in RX path (Alexander Lobakin)
- forward NAPI budget to napi_consume_skb() (Alexander Lobakin)
- fix errno leftover in tsnep_xdp_xmit_back() (Dan Carpenter)
- eliminate tsnep_xdp_is_enabled() by setting RX offset during init

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

Gerhard Engleder (10):
  tsnep: Use spin_lock_bh for TX
  tsnep: Forward NAPI budget to napi_consume_skb()
  tsnep: Do not print DMA mapping error
  tsnep: Add adapter down state
  tsnep: Add XDP TX support
  tsnep: Substract TSNEP_RX_INLINE_METADATA_SIZE once
  tsnep: Prepare RX buffer for XDP support
  tsnep: Add RX queue info for XDP support
  tsnep: Add XDP RX support
  tsnep: Support XDP BPF program setup

 drivers/net/ethernet/engleder/Makefile     |   2 +-
 drivers/net/ethernet/engleder/tsnep.h      |  24 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 460 ++++++++++++++++++---
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  29 ++
 4 files changed, 464 insertions(+), 51 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c

-- 
2.30.2

