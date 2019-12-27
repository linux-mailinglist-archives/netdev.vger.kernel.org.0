Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A48F12B986
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfL0SFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:05:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbfL0SC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:02:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DA0721927;
        Fri, 27 Dec 2019 18:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469777;
        bh=cMnzxgdPe0e5EJ1R/Wt6vME7RxC4ksuH8NrCNU/pS1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lj/nv89h1tN1URgWSIopp4rCzYBksmUVvnEtS0LmLb181UtxdR/tEXR+FFF43aMdI
         dK0V3rY04sK9mKrvpVG0JJ/u6PuN/GgYFMeyamzj6w4gR1wvBasnJoP/TALj75Y92W
         c1fJri9khZdlqKWQFphJwod7AHFMtNkKVb/SFjdw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/57] qede: Fix multicast mac configuration
Date:   Fri, 27 Dec 2019 13:01:53 -0500
Message-Id: <20191227180222.7076-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 0af67e49b018e7280a4227bfe7b6005bc9d3e442 ]

Driver doesn't accommodate the configuration for max number
of multicast mac addresses, in such particular case it leaves
the device with improper/invalid multicast configuration state,
causing connectivity issues (in lacp bonding like scenarios).

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index f79e36e4060a..e7ad95de3da8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1181,7 +1181,7 @@ qede_configure_mcast_filtering(struct net_device *ndev,
 	netif_addr_lock_bh(ndev);
 
 	mc_count = netdev_mc_count(ndev);
-	if (mc_count < 64) {
+	if (mc_count <= 64) {
 		netdev_for_each_mc_addr(ha, ndev) {
 			ether_addr_copy(temp, ha->addr);
 			temp += ETH_ALEN;
-- 
2.20.1

