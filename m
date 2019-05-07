Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2A015C49
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfEGFfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbfEGFfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2EDD214AE;
        Tue,  7 May 2019 05:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207330;
        bh=mfgA1AuaX10R2u6azGrWCWNVloqUtLhMbn73+xrO3Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgsBV5ntmD6YRYy0DsZrp5Jz5q724SMQmzC+J240+HdvUloD21Pm4m4OTkhEiJKfn
         3vdanpXLnR+GTq84q0dvK4ejeSRKVaBvQTOncXotnB2JLxU2wbqRi0czZ60qVFQbFX
         oER0D7FRg0ve4uFvVn50r7PKRIYTVQka/B/OKWxs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Hui Wang <wanghui104@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 90/99] net: vrf: Fix operation not supported when set vrf mac
Date:   Tue,  7 May 2019 01:32:24 -0400
Message-Id: <20190507053235.29900-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 6819e3f6d83a24777813b0d031ebe0861694db5a ]

Vrf device is not able to change mac address now because lack of
ndo_set_mac_address. Complete this in case some apps need to do
this.

Reported-by: Hui Wang <wanghui104@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index cd15c32b2e43..9ee4d7402ca2 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -875,6 +875,7 @@ static const struct net_device_ops vrf_netdev_ops = {
 	.ndo_init		= vrf_dev_init,
 	.ndo_uninit		= vrf_dev_uninit,
 	.ndo_start_xmit		= vrf_xmit,
+	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_get_stats64	= vrf_get_stats64,
 	.ndo_add_slave		= vrf_add_slave,
 	.ndo_del_slave		= vrf_del_slave,
@@ -1274,6 +1275,7 @@ static void vrf_setup(struct net_device *dev)
 	/* default to no qdisc; user can add if desired */
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->priv_flags |= IFF_NO_RX_HANDLER;
+	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/* VRF devices do not care about MTU, but if the MTU is set
 	 * too low then the ipv4 and ipv6 protocols are disabled
-- 
2.20.1

