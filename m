Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88A534DE9E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhC3CqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:46:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:37058 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhC3Cpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 22:45:46 -0400
IronPort-SDR: 37H52IAaEmj2PFywmM8SexoAFCTeg9gltWXXVoHRIV0YKNtLTgQZ/xcMzDw9ZQfdg38Y3H2BMZ
 5IUzIa1jgk/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179213525"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="179213525"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 19:45:46 -0700
IronPort-SDR: dsfpKMTEoglPzqdA/0WtM8HzPVOVV2WzHnUOlY79mVuxd8/WWMmC5caoFlJE4Gn5TKm1Hykle+
 Se7fg3I7Oj3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="606598450"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2021 19:45:41 -0700
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
Subject: [PATCH net-next v2 0/6] stmmac: Add XDP support
Date:   Tue, 30 Mar 2021 10:49:43 +0800
Message-Id: <20210330024949.14010-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the v2 patch series for adding XDP support to stmmac driver.

Summary of the changes in v2:

1/6: Move IRQ affinity hint from dwmac-intel.c into stmmac_main.c inside
     stmmac_request_irq_multi_msi() and clear the IRQ affinity hint in
     stmmac_free_irq().
     Tested the patch with reloading the driver and confirmed that there
     is kernel warning during free_irq().

3/6: Fix build warning of unused variable found in
     https://patchwork.hopto.org/static/nipa/457321/12170149/build_32bit/stderr

4/6: Fix build warnig of unused variable found by lkp

There is no other patch changes in v2 for 2/6, 5/6 and 6/6 and the summary
for their changes are in v1 patch series:

 https://patchwork.kernel.org/project/netdevbpf/list/?series=457321

The v2 patch series are retested with the test steps listed in v1 and
the results looks good as per v1 patch series. The test are executed with
preempt-rt build and it also requires a fix that was sent to ML here:

 https://patchwork.kernel.org/project/netdevbpf/list/?series=457139

It will be great if community help test out these v2 patch series on your
platform and provide me feedback.

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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 521 +++++++++++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.c  |  40 ++
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.h  |  12 +
 5 files changed, 530 insertions(+), 79 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h

-- 
2.25.1

