Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC7B66D022
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbjAPUZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbjAPUZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:16 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CC128852
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KWgMJHJpgpFwi6ASX+ehgcpl6GnQvWfTGjqYunbfh5s=; b=na3gkHJ6GL9/fw/iicrixSOqRT
        YXisPhUVanhoHIDQoL3MhrsHCDGPf8CdqXd7YenAjUfKf907mZ9zAvMZMQOhq3SuGu1ubzDAChd4g
        Jo2MWBLjMCr0J88wbJQ4kc6z8xc0jt0vCcMUCLF3IKcXydcHH1r1Hui6Yc1jgYc8liK8=;
Received: from [88.117.53.243] (helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2X-00018Q-Et; Mon, 16 Jan 2023 21:25:09 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v5 0/9] tsnep: XDP support
Date:   Mon, 16 Jan 2023 21:24:49 +0100
Message-Id: <20230116202458.56677-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

v5:
- fix spelling of 'subtract' in commit message (Alexander Duyck)
- call txq_trans_cond_update() only if TX is complete (Alexander Duyck)
- remove const from static functions (Alexander Duyck)
- replace TX spin_lock with __netif_tx_lock (Alexander Duyck)
- use xdp_return_frame_rx_napi() instead of xdp_return_frame_bulk() (Alexander Duyck)
- eliminate __TSNEP_DOWN (Alexander Duyck)
- introduce single function for xdp_rxq and napi init (Alexander Duyck)
- use TX queue of pair instead of expensive processor id modulo for XDP_TX (Alexander Duyck)
- eliminate processor id modulo in tsnep_netdev_xdp_xmit (Alexander Duyck)
- use bitmap for TX type and add fragment type (Alexander Duyck)
- always use XDP_PACKET_HEADROOM and DMA_BIDIRECTIONAL

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

Gerhard Engleder (9):
  tsnep: Replace TX spin_lock with __netif_tx_lock
  tsnep: Forward NAPI budget to napi_consume_skb()
  tsnep: Do not print DMA mapping error
  tsnep: Add XDP TX support
  tsnep: Subtract TSNEP_RX_INLINE_METADATA_SIZE once
  tsnep: Prepare RX buffer for XDP support
  tsnep: Add RX queue info for XDP support
  tsnep: Add XDP RX support
  tsnep: Support XDP BPF program setup

 drivers/net/ethernet/engleder/Makefile     |   2 +-
 drivers/net/ethernet/engleder/tsnep.h      |  16 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 474 ++++++++++++++++++---
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  19 +
 4 files changed, 445 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c

-- 
2.30.2

