Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC5D3BBAF7
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhGEKSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:18:49 -0400
Received: from inva020.nxp.com ([92.121.34.13]:32872 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhGEKSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 06:18:49 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D05121A16CD;
        Mon,  5 Jul 2021 12:16:11 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 982711A045A;
        Mon,  5 Jul 2021 12:16:11 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 650E6183ACDC;
        Mon,  5 Jul 2021 18:16:09 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, joabreu@synopsys.com, kuba@kernel.org,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org
Cc:     boon.leong.ong@intel.com, weifeng.voon@intel.com,
        vee.khee.wong@intel.com, tee.min.tan@intel.com,
        mohammad.athari.ismail@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        leoyang.li@nxp.com, qiangqing.zhang@nxp.com, rui.sousa@nxp.com,
        xiaoliang.yang_1@nxp.com
Subject: [PATCH v2 net-next 0/3] net: stmmac: re-configure tas basetime after ptp time adjust
Date:   Mon,  5 Jul 2021 18:26:52 +0800
Message-Id: <20210705102655.6280-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the DWMAC Ethernet device has already set the Qbv EST configuration
before using ptp to synchronize the time adjustment, the Qbv base time
may change to be the past time of the new current time. This is not
allowed by hardware.

This patch calculates and re-configures the Qbv basetime after ptp time
adjustment.

v1->v2:
  Update est mutex lock to protect btr/ctr r/w to be atomic.
  Add btr_reserve to store basetime from qopt and used as origin base
time in Qbv re-configuration.

Xiaoliang Yang (3):
  net: stmmac: separate the tas basetime calculation function
  net: stmmac: add mutex lock to protect est parameters
  net: stmmac: ptp: update tas basetime after ptp adjust

 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 ++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 41 ++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 46 +++++++++++++------
 include/linux/stmmac.h                        |  1 +
 4 files changed, 77 insertions(+), 14 deletions(-)

-- 
2.17.1

