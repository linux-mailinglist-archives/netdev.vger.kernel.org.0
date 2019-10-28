Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1DFE72F0
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 14:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389679AbfJ1N4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 09:56:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54232 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727567AbfJ1N4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 09:56:35 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AC1DF140078;
        Mon, 28 Oct 2019 13:56:33 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 28 Oct 2019 13:56:28 +0000
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next v2 0/6] sfc: Add XDP support
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
Message-ID: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
Date:   Mon, 28 Oct 2019 13:56:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25006.003
X-TM-AS-Result: No-0.704000-8.000000-10
X-TMASE-MatchedRID: rx+pvSBilgzSfkI8LIozOyAI8aJmq0jw4+QcMo54nTiMUViaYYbK3JdL
        XG1oAbASHBeCYRWJgIo/R3Sjv4UxLqn7cUty5471qjZ865FPtpoO9z+P2gwiBcz/SxKo9mJ44rl
        +FHG3VoAGUmUBKg9hSaLbzE92hJygs+W45XOOo5duh7qwx+D6T3qLr3o+NE+IHdFjikZMLIdcpk
        b9zUI7BOGgS4rOorYrl6GYMIzN7TujxYyRBa/qJX3mXSdV7KK4mVLlQk0G3GfCttcwYNipX2Piw
        HD6nUln2OZlONgsq0dKEri3IQEi12u9DhurUq4RbLuk4LhSCe1Bi+tUnmGHEx/5XyyFA1u2oHnG
        G8wRbgR1+S2w0xe3ShWrbX22XTSOfObqGK9JplminaV/dK0aEhK3Vty8oXtk2SsLyY4gH4tVyvb
        Tg/runA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.704000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25006.003
X-MDID: 1572270994-01sN_pB0Yhw8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supply the XDP callbacks in netdevice ops that enable lower level processing
of XDP frames.

Changes since last submission:
- Use of xdp_return_frame_rx_napi() in tx.c
- Addition of xdp_rxq_info_valid and xdp_rxq_info_failed to track when
  xdp_rxq_info failures occur.
- Renaming of rc to err and more use of unlikely().
- Cut some duplicated code and fix an array overrun.
- Actually increment n_rx_xdp_tx when packets are transmitted.

Charles McLachlan (6):
  sfc: support encapsulation of xdp_frames in efx_tx_buffer
  sfc: perform XDP processing on received packets
  sfc: Enable setting of xdp_prog
  sfc: allocate channels for XDP tx queues
  sfc: handle XDP_TX outcomes of XDP eBPF programs
  sfc: add XDP counters to ethtool stats

 drivers/net/ethernet/sfc/ef10.c       |  10 +-
 drivers/net/ethernet/sfc/efx.c        | 269 ++++++++++++++++++++++----
 drivers/net/ethernet/sfc/efx.h        |   3 +
 drivers/net/ethernet/sfc/ethtool.c    |  25 +++
 drivers/net/ethernet/sfc/net_driver.h |  64 +++++-
 drivers/net/ethernet/sfc/rx.c         | 147 +++++++++++++-
 drivers/net/ethernet/sfc/tx.c         |  74 +++++++
 7 files changed, 549 insertions(+), 43 deletions(-)

