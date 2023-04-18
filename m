Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0437E6E6C9D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjDRTFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjDRTFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:05:11 -0400
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E445FFB;
        Tue, 18 Apr 2023 12:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dsBWyfGRaFvX7bIHHJWds7X5trT0UrnBIVsiGmf6RdM=; b=soFGLSpHumQkc4ve8OtnLiww60
        3e01a2d5lfxFHksFu0e0tqee4Bg3HkOlvR0VdC71SAscGzi/Yd6HkuD4PeX2ZTHYkuvKsXRmRvcGl
        ElOF7d2K4O1rLLjzaL7rUJhL4m4A9GT1g73nbNmMkAEFQeX+aDTM7LhyuItNC+A2GQwY=;
Received: from [88.117.57.231] (helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1poqdV-0002eV-I9; Tue, 18 Apr 2023 21:05:05 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 0/6] tsnep: XDP socket zero-copy support
Date:   Tue, 18 Apr 2023 21:04:53 +0200
Message-Id: <20230418190459.19326-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement XDP socket zero-copy support for tsnep driver. I tried to
follow existing drivers like igc as far as possible. But one main
difference is that tsnep does not need any reconfiguration for XDP BPF
program setup. So I decided to keep this behavior no matter if a XSK
pool is used or not. As a result, tsnep starts using the XSK pool even
if no XDP BPF program is available.

Another difference is that I tried to prevent potentially failing
allocations during XSK pool setup. E.g. both memory models for page pool
and XSK pool are registered all the time. Thus, XSK pool setup cannot
end up with not working queues.

Some prework is done to reduce the last two XSK commits to actual XSK
changes.

v3:
- use __netif_tx_lock_bh() (Paolo Abeni)
- comment that rx->page_buffer is always zero terminated (Paolo Abeni)

v2:
- eliminate modulo op in TX/RX path (Maciej Fijalkowski)
- eliminate retval variable in tsnep_rx_alloc_zc() (Maciej Fijalkowski)
- scope variable entry within loop (Maciej Fijalkowski)
- use DMA_ATTR_SKIP_CPU_SYNC directly (Maciej Fijalkowski)
- union for page/xdp in tsnep_rx_entry (Maciej Fijalkowski)
- provide performance numbers (Maciej Fijalkowski)
- use xsk_buff_alloc_batch() (Maciej Fijalkowski)
- use xsk_tx_peek_release_desc_batch() (Maciej Fijalkowski)
- don't call tsnep_rx_reopen() if netdev is down
- init adapter pointer of queue only once

Gerhard Engleder (6):
  tsnep: Replace modulo operation with mask
  tsnep: Rework TX/RX queue initialization
  tsnep: Add functions for queue enable/disable
  tsnep: Move skb receive action to separate function
  tsnep: Add XDP socket zero-copy RX support
  tsnep: Add XDP socket zero-copy TX support

 drivers/net/ethernet/engleder/tsnep.h      |  16 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 863 ++++++++++++++++++---
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  66 ++
 3 files changed, 822 insertions(+), 123 deletions(-)

-- 
2.30.2

