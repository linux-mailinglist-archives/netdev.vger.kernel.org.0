Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB39350C4E
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 04:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhDACIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 22:08:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:5163 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhDACHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 22:07:35 -0400
IronPort-SDR: mBOplFD3EPIR6JRChmAUTdwO2o7jJgPoq3kxM0m70moBaOZ5WY904HDlHcpo0H+DrM1bA1JWnF
 AH2+wwhx/32A==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="192156229"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="192156229"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 19:07:35 -0700
IronPort-SDR: ePneGV3mI4UPzr+IRRbvKpXyIARqNnqPyq9j3+RUSTUg4WOex6YemwffIcuVEaXdT+lKIlcIi3
 PyMFBUhizDBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="528004184"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga004.jf.intel.com with ESMTP; 31 Mar 2021 19:07:30 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v4 0/6] stmmac: Add XDP support
Date:   Thu,  1 Apr 2021 10:11:11 +0800
Message-Id: <20210401021117.13360-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the v4 patch series for adding XDP native support to stmmac.

Changes in v4:
5/6: Move TX clean timer setup to the end of NAPI RX process and
     group it under stmmac_finalize_xdp_rx().
     Also, fixed stmmac_xdp_xmit_back() returns STMMAC_XDP_CONSUMED
     if XDP buffer conversion to XDP frame fails.

6/6: Move xdp_do_flush(0 into stmmac_finalize_xdp_rx() and combine
     the XDP verdict of XDP TX and XDP REDIRECT together.

I retested the patch series on the 'xdp2' and 'xdp_redirect' related to
changes above and found the result to be satisfactory.

History of previous patch series:
v3: https://patchwork.kernel.org/project/netdevbpf/cover/20210331154135.8507-1-boon.leong.ong@intel.com/
v2: https://patchwork.kernel.org/project/netdevbpf/list/?series=457757
v1: https://patchwork.kernel.org/project/netdevbpf/list/?series=457139

It will be great if community can help to test or review the v4 series
and provide me any input if any.

Thank you very much,
Boon Leong

Ong Boon Leong (6):
  net: stmmac: set IRQ affinity hint for multi MSI vectors
  net: stmmac: make SPH enable/disable to be configurable
  net: stmmac: arrange Tx tail pointer update to
    stmmac_flush_tx_descriptors
  net: stmmac: Add initial XDP support
  net: stmmac: Add support for XDP_TX action
  net: stmmac: Add support for XDP_REDIRECT action

 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  35 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 539 +++++++++++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.c  |  40 ++
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.h  |  12 +
 5 files changed, 547 insertions(+), 80 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h

-- 
2.25.1

