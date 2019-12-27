Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465DF12B822
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfL0Rxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbfL0Rmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A1D218AC;
        Fri, 27 Dec 2019 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468562;
        bh=7MCWi2wW9qIDpvkip6IuoAN4007KN6VUkFJj1ovRrsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwcD90rblYIU1a3Y8fEriuIt0Ur5Dz8zGhJQ+vvOEmK0nUN61Mh9l22gCpC82zzgm
         lls7xoGMOlodq0aD/hO2o6yAY6TbHzCMGLKIueEz0ZLO2FfPIZz/pfJj4sFJ7HCQk+
         cdUrVVTryy286jESMHLqwWoK95QpOD3KD6WDKnyU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 088/187] qede: Fix multicast mac configuration
Date:   Fri, 27 Dec 2019 12:39:16 -0500
Message-Id: <20191227174055.4923-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
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
index 9a6a9a008714..c8bdbf057d5a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1230,7 +1230,7 @@ qede_configure_mcast_filtering(struct net_device *ndev,
 	netif_addr_lock_bh(ndev);
 
 	mc_count = netdev_mc_count(ndev);
-	if (mc_count < 64) {
+	if (mc_count <= 64) {
 		netdev_for_each_mc_addr(ha, ndev) {
 			ether_addr_copy(temp, ha->addr);
 			temp += ETH_ALEN;
-- 
2.20.1

