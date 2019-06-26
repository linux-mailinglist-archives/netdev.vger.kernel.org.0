Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A9F56B21
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbfFZNs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:48:29 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:51124 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727868AbfFZNry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:47:54 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CF748C0C4F;
        Wed, 26 Jun 2019 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561556874; bh=LSk/dW4zyxmZMD77PMR2MqUNJZFP8fAWo5ecqoxYj2k=;
        h=From:To:Cc:Subject:Date:From;
        b=dxu385K0Z1Us4dLKCUXhHFLQ9a1FnF8qgDXpXo9nNWtPFFE195Sqp6mQ9CtnxsM9c
         GR+h7CTknyvKHhoKStRtCUszTp1v6BJU989CZ/X2rGrSMJExaZrsAM6pTZSAVN2F+T
         hnr7sPtE6BVKF/UTywPvmdkxo64EzrMohYIhJsme8P5vn3MDPlKL6kFD94nlTuuJss
         YVaE8VRUzps8mDRa8+DKPfiCKeZWD09r8aWYCPv+sj7U+egiPpiUzseBDtF0PKtTVn
         DzlfXIoazo12zr1FmDQA/9AvuTwdW4iMtmzysSOsg5mlw8PPJ1/tZvfgiTIlM0cYJF
         QN/UCGDzSe0Ig==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id E4E90A0063;
        Wed, 26 Jun 2019 13:47:51 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id A22F93B557;
        Wed, 26 Jun 2019 15:47:51 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 00/10] net: stmmac: 10GbE using XGMAC
Date:   Wed, 26 Jun 2019 15:47:34 +0200
Message-Id: <cover.1561556555.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for 10Gb Link using XGMAC core plus some performance tweaks.

Tested in a PCI based setup.

iperf3 TCP results:
	TSO ON, MTU=1500, TX Queues = 1, RX Queues = 1, Flow Control ON
	Pinned CPU (-A), Zero-Copy (-Z)

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-600.00 sec   643 GBytes  9.21 Gbits/sec    1             sender
[  5]   0.00-600.00 sec   643 GBytes  9.21 Gbits/sec                  receiver

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>

Jose Abreu (10):
  net: stmmac: dwxgmac: Enable EDMA by default
  net: stmmac: Do not try to enable PHY EEE if MAC does not support it
  net: stmmac: Decrease default RX Watchdog value
  net: stmmac: dwxgmac: Fix the undefined burst setting
  net: stmmac: Add the missing speeds that XGMAC supports
  net: stmmac: Do not disable interrupts when cleaning TX
  net: stmmac: Enable support for > 32 Bits addressing in XGMAC
  net: stmmac: Update RX Tail Pointer to last free entry
  net: stmmac: Only disable interrupts if NAPI is scheduled
  net: stmmac: Try to get C45 PHY if everything else fails

 drivers/net/ethernet/stmicro/stmmac/common.h       |   9 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  14 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  14 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  27 +++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 165 ++++++++++++++++-----
 6 files changed, 178 insertions(+), 55 deletions(-)

-- 
2.7.4

