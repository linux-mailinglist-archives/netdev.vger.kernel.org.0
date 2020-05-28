Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245711E5F87
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbgE1L52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388847AbgE1L5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:57:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C7521548;
        Thu, 28 May 2020 11:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667041;
        bh=bP1ZKI71IizBC9SAWIYUwECqsXwwyoX9crqlrmQ7N4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/QipGCmXasBMkkDQQjW/jW+xUqALxaKFDL3ERIC8mPeHAlEPQzl6O8tk5nUl/3l4
         uFjnrTO77qvFJAsFuD15qqcMOuleZCGAJ/OqljpkXPG8o0Nf/3Z4nWacxf+rGSZVvL
         rvIXH4lvxq5MIMVdz7jwewOj07mAeqWiRYtFwg5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/26] net: ethernet: ti: cpsw: fix ASSERT_RTNL() warning during suspend
Date:   Thu, 28 May 2020 07:56:52 -0400
Message-Id: <20200528115654.1406165-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115654.1406165-1-sashal@kernel.org>
References: <20200528115654.1406165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 4c64b83d03f4aafcdf710caad994cbc855802e74 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index d7a953c647b4..39df8c8feb6c 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2999,11 +2999,15 @@ static int cpsw_suspend(struct device *dev)
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
2.25.1

