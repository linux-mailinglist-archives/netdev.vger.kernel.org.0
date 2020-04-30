Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E171BFB63
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgD3N7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgD3Ny2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:54:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AC642137B;
        Thu, 30 Apr 2020 13:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254868;
        bh=JwRwvA9PcU1kqrQS88gZNGalhbtB/u/W4FKcJ/X3FsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvppIz907G7EO5tTkWJcW4ga4edZbTlMXIf5hv/rzm1SMF6Lic0bSMZPNxvK7wIn6
         huMtilqSDcPHch/fTXUsEuNaGDb9PcNSTD+NgF2W8WVNte0eoUSbWN6ETMKJo/bwy4
         dioasqT7cvQtvgcEP82PBEJb+KNXTwqDSu9xNsxQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 23/27] net: bcmgenet: correct per TX/RX ring statistics
Date:   Thu, 30 Apr 2020 09:53:58 -0400
Message-Id: <20200430135402.20994-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135402.20994-1-sashal@kernel.org>
References: <20200430135402.20994-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit a6d0b83f25073bdf08b8547aeff961a62c6ab229 ]

The change to track net_device_stats per ring to better support SMP
missed updating the rx_dropped member.

The ndo_get_stats method is also needed to combine the results for
ethtool statistics (-S) before filling in the ethtool structure.

Fixes: 37a30b435b92 ("net: bcmgenet: Track per TX/RX rings statistics")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 3e3044fe32066..4b3660c63b864 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -973,6 +973,8 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
 	if (netif_running(dev))
 		bcmgenet_update_mib_counters(priv);
 
+	dev->netdev_ops->ndo_get_stats(dev);
+
 	for (i = 0; i < BCMGENET_STATS_LEN; i++) {
 		const struct bcmgenet_stats *s;
 		char *p;
@@ -3215,6 +3217,7 @@ static struct net_device_stats *bcmgenet_get_stats(struct net_device *dev)
 	dev->stats.rx_packets = rx_packets;
 	dev->stats.rx_errors = rx_errors;
 	dev->stats.rx_missed_errors = rx_errors;
+	dev->stats.rx_dropped = rx_dropped;
 	return &dev->stats;
 }
 
-- 
2.20.1

