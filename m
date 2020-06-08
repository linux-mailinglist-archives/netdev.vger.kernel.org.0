Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F011F297A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732773AbgFIAAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387422AbgFHXWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5FB2086A;
        Mon,  8 Jun 2020 23:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658553;
        bh=gXJ+Q1Pj3aJdRLZo86iHaT9nHNrA4VTUe+HXTAwTAq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOI15Ekh0pFVOgsCT92pAxZx4Leq8MsnkGyfHR/bfPfATgHQdjPk052SGecubtuAQ
         rjTCwNmTg63IW5HC8Ub2bG4KmIvht5ocKUYSxkePu5GgH7MZbeORAeeBuHf97On4a+
         6TN2EfQEazBVdZn6thN7mhB55T7fQykL7NIU5ZfU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 173/175] net_failover: fixed rollback in net_failover_open()
Date:   Mon,  8 Jun 2020 19:18:46 -0400
Message-Id: <20200608231848.3366970-173-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit e8224bfe77293494626f6eec1884fee7b87d0ced ]

found by smatch:
drivers/net/net_failover.c:65 net_failover_open() error:
 we previously assumed 'primary_dev' could be null (see line 43)

Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/net_failover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index b16a1221d19b..fb182bec8f06 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -61,7 +61,8 @@ static int net_failover_open(struct net_device *dev)
 	return 0;
 
 err_standby_open:
-	dev_close(primary_dev);
+	if (primary_dev)
+		dev_close(primary_dev);
 err_primary_open:
 	netif_tx_disable(dev);
 	return err;
-- 
2.25.1

