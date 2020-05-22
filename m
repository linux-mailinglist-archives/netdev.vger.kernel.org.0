Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44D91DEDE2
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgEVRJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:09:37 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37636 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730306AbgEVRJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 13:09:37 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04MH9YbI122883;
        Fri, 22 May 2020 12:09:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590167374;
        bh=bxtnR5upjJ5W+2FvuGQCcYEEOyiNcyNlCE6K0qGbX1g=;
        h=From:To:CC:Subject:Date;
        b=Muy8tgBUQtoiC2i0+pjCtlz++AHi4Gebw6/PMM9HoC7ONYiMfJrktDd7+ZucGIlxz
         AbM1eQMSOOuffUvKtEEtbxgiwl6Gbt/KxuV1ICoNf4mEFbXGCoG9axMuiPdbNv2Cuf
         YX9x/mRwN7mZBnVtAFBRiWmwO6WwwXtRSmBGuXSU=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04MH9Ypn010959
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 12:09:34 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 22
 May 2020 12:09:33 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 22 May 2020 12:09:33 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04MH9XlZ007013;
        Fri, 22 May 2020 12:09:33 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2] net: ethernet: ti: cpsw: fix ASSERT_RTNL() warning during suspend
Date:   Fri, 22 May 2020 20:09:28 +0300
Message-ID: <20200522170928.30841-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vlan_for_each() are required to be called with rtnl_lock taken, otherwise
ASSERT_RTNL() warning will be triggered - which happens now during System
resume from suspend:
  cpsw_suspend()
  |- cpsw_ndo_stop()
    |- __hw_addr_ref_unsync_dev()
      |- cpsw_purge_all_mc()
         |- vlan_for_each()
            |- ASSERT_RTNL();

Hence, fix it by surrounding cpsw_ndo_stop() by rtnl_lock/unlock() calls.

Fixes: 15180eca569b ("net: ethernet: ti: cpsw: fix vlan mcast")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
v2: fix "fixes" tag

 drivers/net/ethernet/ti/cpsw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c2c5bf87da01..ffeb8633e530 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1753,11 +1753,15 @@ static int cpsw_suspend(struct device *dev)
 	struct cpsw_common *cpsw = dev_get_drvdata(dev);
 	int i;
 
+	rtnl_lock();
+
 	for (i = 0; i < cpsw->data.slaves; i++)
 		if (cpsw->slaves[i].ndev)
 			if (netif_running(cpsw->slaves[i].ndev))
 				cpsw_ndo_stop(cpsw->slaves[i].ndev);
 
+	rtnl_unlock();
+
 	/* Select sleep pin state */
 	pinctrl_pm_select_sleep_state(dev);
 
-- 
2.17.1

