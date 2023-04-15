Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254886E31E9
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjDOOnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjDOOnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:43:04 -0400
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EC455A1;
        Sat, 15 Apr 2023 07:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MUqpw3CxRF8s0DjevM/XGQafhBrPUW4nHhQJdpRlLV0=; b=n9vIRmcZthmPAtGZ/XeF63wmoF
        yZvQ5SSOLhrUq/Jq7tyUfMv5D3xUD9U7sXQYH2LzJqdbvJBR+XhddqXxfJvE58X5j7OUnztwCiM8K
        mgOWeZPQNO+HJwC5KlcvPhWAFdJ1/a5Qa9VlE5PUa77CK/V0s26mX2FBvDZO/DH4hbVA=;
Received: from [88.117.57.231] (helo=hornet.engleder.at)
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pnh7C-0003zN-OI; Sat, 15 Apr 2023 16:42:58 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 0/6] tsnep: XDP socket zero-copy support
Date:   Sat, 15 Apr 2023 16:42:50 +0200
Message-Id: <20230415144256.27884-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/engleder/tsnep_main.c | 864 ++++++++++++++++++---
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  66 ++
 3 files changed, 823 insertions(+), 123 deletions(-)

-- 
2.30.2

