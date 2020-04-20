Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4954E1B106B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgDTPm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:42:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:12546 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDTPm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 11:42:57 -0400
IronPort-SDR: QwwSCWwKDAAD4D7LgvpIhnin8VGOXGEYc2FYuCLah3GoBE7o4zmbHshtTNDvfg9JsoGbU/naw0
 ZUqNwJhzQpnQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 08:42:56 -0700
IronPort-SDR: zDnVUSAMZOui+rWElU7lO4pGPvan++knR7cSug/ANI+Y3Q6xiywjuTLcnLkdI6/uvAk8CE98hF
 138tZQywGRxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="429169845"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by orsmga005.jf.intel.com with ESMTP; 20 Apr 2020 08:42:53 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [net-next,v1, 0/1] Enable SERDES power up/down
Date:   Mon, 20 Apr 2020 23:42:51 +0800
Message-Id: <20200420154252.8000-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to enable Intel SERDES power up/down sequence. The SERDES
converts 8/10 bits data to SGMII signal.
1.Introduced 2 new BSP callbacks ->serdes_powerup() and ->serdes_powerdown().
2.The 2 new BSP callbacks is called in stmmac_dvr_probe() and
  stmmac_resume() for SERDER powerup; stmmac_dvr_remove() and
  stmmac_suspend() for SERDES powerdown.
3.Intel platform specific SERDES powerup and powerdown sequence functions
  are added in dwmac-intel.c.
4.Since configuring the SERDES is through mdio, mdio communication is
  needed to be up before powerup sequence. As for SERDES power-down
  sequence, it must be configured after all dma stop and before unregister
  the mdio bus.
5.New file dwmac-intel.h is created for register definition.

Voon Weifeng (1):
  net: stmmac: Enable SERDES power up/down sequence

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 189 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac-intel.h |  23 +++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  23 +++
 include/linux/stmmac.h                        |   2 +
 4 files changed, 237 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h

-- 
2.17.1

