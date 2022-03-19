Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B624DE83E
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 15:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242049AbiCSOGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 10:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiCSOGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 10:06:20 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA6C1B757C
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 07:04:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id u22so499644pfg.6
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 07:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=1p1XE8cUpkaNhF0xRALTjdI+9XRtp53pLt2eWerOanQ=;
        b=Vu7Y1pfgB0fNy3oDcPCfNhXT7Y1FGkmqg+ViXbKGCRASpyBgjinLApd0FQPOCCXTVA
         wrQzcqyCxXW/UT61WDb4TZgmgTLqC1fghxIWMQxrlQe1wL8aU1sh5oJRxU6KdgVvm+kq
         VnIakAlf9NPufeu/n6WeyrUZUtSUd5QyCQyV7CCPTOzqV+SrPcs2uhdNVoNv3+KmlnIN
         9pApWRhpTa/G4bkyIgll9WKDmLFCFnDQ8TnL7jrpdSHMgZeQgGyU92TpeAolG+KJY/p/
         orn3W2TJ8Y7+bf9pNTSTTAQKKjG8BGdjR1kY9VZTT7eem/7da/NgJn4+uflOPk1Z/9CC
         yGQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1p1XE8cUpkaNhF0xRALTjdI+9XRtp53pLt2eWerOanQ=;
        b=gz2pHUF1h1je2NkMFi7NyUQZUgo8/aDeSFQkGqL77SBPeoivAsjAVYq2AflCBCEI46
         Ee+krXMdg6G17tvC1I0CoC/72+dy5N1DKbCOH5YCGKZc9e4K0tQCx/4otauT/F4qe/Bs
         1Oiw3AH2ie3g50yiQ5nZ8QsgDFME+97jd09Ed5d/c/FhSsw2nOpZQaF4+WMFKaPpkC28
         3OpPltz9wITJicatHXjmqEWVejtp+umai/skdKmzBgeRIwWxwzJ2MerQJrmabW0H6jKi
         W95mLQ1hK8plIlVZkUyHVhFCtEof4UblEmZFzIwxU8fpuJr+6FyIk2DqVxBMkUabvxCZ
         X9Ug==
X-Gm-Message-State: AOAM531Mr3OiqNy+YNtetKQhIAmL1BdR/bCibcvZMWqr35dB8/dB3dWm
        ljgF+/9GqbqtTf4Dt9qab9I=
X-Google-Smtp-Source: ABdhPJw9BwxHvjV2Uwdqv6bU+bQpg/6zmGio+IP5wbfq4JqFRyqdKIijR0x0fWJjgGVYzgdbb53Jvw==
X-Received: by 2002:a63:4e0d:0:b0:381:4606:ec9e with SMTP id c13-20020a634e0d000000b003814606ec9emr11592808pgb.345.1647698698507;
        Sat, 19 Mar 2022 07:04:58 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id e11-20020a63e00b000000b0037341d979b8sm10168438pgh.94.2022.03.19.07.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 07:04:57 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        irusskikh@marvell.com, epomozov@marvell.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v2 0/3] net: atlantic: Add XDP support
Date:   Sat, 19 Mar 2022 14:04:40 +0000
Message-Id: <20220319140443.6645-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to make atlantic to support multi-buffer XDP.

The first patch implement control plane of xdp.
The aq_xdp(), callback of .xdp_bpf is added.

The second patch implements data plane of xdp.
XDP_TX, XDP_DROP, and XDP_PASS is supported.
__aq_ring_xdp_clean() is added to receive and execute xdp program.
aq_nic_xmit_xdpf() is added to send packet by XDP.

The third patch implements callback of .ndo_xdp_xmit.
aq_xdp_xmit() is added to send redirected packets and it internally
calls aq_nic_xmit_xdpf().

Memory model is MEM_TYPE_PAGE_ORDER0 so it doesn't reuse rx page when
XDP_TX, XDP_PASS, XDP_REDIRECT.

Default the maximum rx frame size is 2K.
If xdp is attached, size is changed to about 3K.
It can be reused when XDP_DROP, XDP_ABORTED.

Atlantic driver has AQ_CFG_RX_PAGEORDER option and it will be always 0
if xdp is attached.

AQC chip supports 32 multi-queues and 8 vectors(irq).
There are two options.
1. under 8 cores and maximum 4 tx queues per core.
2. under 4 cores and maximum 8 tx queues per core.

Like other drivers, these tx queues can be used only for XDP_TX,
XDP_REDIRECT queue. If so, no tx_lock is needed.
But this patchset doesn't use this strategy because getting hardware tx
queue index cost is too high.
So, tx_lock is used in the aq_nic_xmit_xdpf().

single-core, single queue, 40% cpu utilization.

  30.75%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
  10.35%  [kernel]                  [k] aq_hw_read_reg <---------- here
   4.38%  [kernel]                  [k] get_page_from_freelist

single-core, 8 queues, 100% cpu utilization, half PPS.

  45.56%  [kernel]                  [k] aq_hw_read_reg <---------- here
  17.58%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
   4.72%  [kernel]                  [k] hw_atl_b0_hw_ring_rx_receive

Performance result(64 Byte)
1. XDP_TX
  a. xdp_geieric, single core
    - 2.5Mpps, 100% cpu
  b. xdp_driver, single core
    - 4.5Mpps, 40% cpu
  c. xdp_generic, 8 core(hyper thread)
    - 6.3Mpps, 5~10% cpu
  d. xdp_driver, 8 core(hyper thread)
    - 6.3Mpps, 5% cpu

2. XDP_REDIRECT
  a. xdp_generic, single core
    - 2.3Mpps
  b. xdp_driver, single core
    - 4.5Mpps

V2:
 - Do not use inline in C file

Taehee Yoo (3):
  net: atlantic: Implement xdp control plane
  net: atlantic: Implement xdp data plane
  net: atlantic: Implement .ndo_xdp_xmit handler

 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   1 +
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   8 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  59 +++
 .../net/ethernet/aquantia/atlantic/aq_main.h  |   2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 126 ++++--
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   7 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 409 ++++++++++++++++--
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  17 +
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |  23 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |   6 +
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |   6 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  10 +-
 13 files changed, 595 insertions(+), 81 deletions(-)

-- 
2.17.1

