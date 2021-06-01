Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15982396EEB
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhFAIaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:30:30 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46876 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232963AbhFAIa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 04:30:29 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B06841A3C1C;
        Tue,  1 Jun 2021 10:28:47 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com B06841A3C1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector3; t=1622536127;
        bh=vWCv+MeGTvvz1WVA73qZXjvvuHB4aTe/cxgc3hg+kwE=;
        h=From:To:Cc:Subject:Date:From;
        b=VG9n6A0RyiNUtHUejUzAqLT6FnL31SuW+5En8RdNlio7+Y0PmJ3tVfjJalxhgLygs
         G/xxWi3y0zAfVgCJycJnYYtViDyjbbQVucutgzgGxk2xpy1kfOBC3wgO9q1POWYg7C
         ZHsgS0oGff0HFORc9UGDQ05MKhzocTfeBo7/x7JmTz2a8gajtJPOknYugnFjhWw7wE
         izxOkhL1zmzsHMnTHvB9KoYRgrpF9BXVrEtTN+86L7YWB0Cm5WQt6D41vmIPdNbTg5
         HQceHZ3s+/lic1fx1PkR2z9tH37P/sq9tdtxkuF8rcxrV4FhzqZ1ZOdkd8Y03YYuyj
         Q2Y95HtdTmlog==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7C5FE1A3C23;
        Tue,  1 Jun 2021 10:28:39 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com 7C5FE1A3C23
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 75AF2402E9;
        Tue,  1 Jun 2021 16:28:28 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, joabreu@synopsys.com, kuba@kernel.org,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        tee.min.tan@intel.com, mohammad.athari.ismail@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        leoyang.li@nxp.com, vladimir.oltean@nxp.com,
        qiangqing.zhang@nxp.com, rui.sousa@nxp.com, mingkai.hu@nxp.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH v1 net-next 0/3] net: stmmac: re-configure tas basetime after ptp time adjust
Date:   Tue,  1 Jun 2021 16:38:10 +0800
Message-Id: <20210601083813.1078-1-xiaoliang.yang_1@nxp.com>
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

