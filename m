Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFCBEAD50
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfJaKVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:21:33 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56952 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbfJaKVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:21:32 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6EB5480057;
        Thu, 31 Oct 2019 10:21:31 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 31 Oct 2019 10:21:26 +0000
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next v4 0/6] sfc: Add XDP support
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
Message-ID: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
Date:   Thu, 31 Oct 2019 10:21:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25012.003
X-TM-AS-Result: No-0.668500-8.000000-10
X-TMASE-MatchedRID: rx+pvSBilgzSfkI8LIozOyAI8aJmq0jw4+QcMo54nTiMUViaYYbK3PVZ
        RgYwg53IdQtHgP/hC5AvNH+KjTOW/R8owvkAm18t/HTKStsDGMLy3jAsGkmynNEsTITobgNEuqB
        E5JB7VxGJsHTHB6fd3J1U8OaqwSn3gL9a82DEgczc+EHoN3gzl3qLr3o+NE+IHdFjikZMLIdcpk
        b9zUI7BOGgS4rOorYrl6GYMIzN7TujxYyRBa/qJX3mXSdV7KK4mVLlQk0G3GfCttcwYNipX8MFH
        FkKVmrBtmnAvGhAM9CXh2SxI2kZ6orERqCnb42Mh3v9tLM4NQwSyNWBdolIvMgy1sWF8xTcYDgp
        E1RDOA8y5ZmenN1TuTwu6G2yev8+fObqGK9JplminaV/dK0aEhK3Vty8oXtk2SsLyY4gH4tVyvb
        Tg/runA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.668500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25012.003
X-MDID: 1572517292-izGSSwm_wAWg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supply the XDP callbacks in netdevice ops that enable lower level processing
of XDP frames.

Changes in v4:
- Handle the failure to send some frames in efx_xdp_tx_buffers() properly.

Changes in v3:
- Fix a BUG_ON when trying to allocate piobufs to xdp queues.
- Add a missed trace_xdp_exception.

Changes in v2:
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

 drivers/net/ethernet/sfc/ef10.c       |  14 +-
 drivers/net/ethernet/sfc/efx.c        | 269 ++++++++++++++++++++++----
 drivers/net/ethernet/sfc/efx.h        |   3 +
 drivers/net/ethernet/sfc/ethtool.c    |  25 +++
 drivers/net/ethernet/sfc/net_driver.h |  64 +++++-
 drivers/net/ethernet/sfc/rx.c         | 149 +++++++++++++-
 drivers/net/ethernet/sfc/tx.c         |  92 +++++++++
 7 files changed, 572 insertions(+), 44 deletions(-)

