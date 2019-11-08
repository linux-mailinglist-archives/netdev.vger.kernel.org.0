Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68817F4A3B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390810AbfKHMHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388949AbfKHLko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CCB0222C2;
        Fri,  8 Nov 2019 11:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213244;
        bh=IEDcQfMvzR+IzJeitdKQq+ocOapyJqcmGHUCSGPIY50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CV5FcorhI76pa7vp8NYgTkKRX7Pkui7PmNuL3oWnNvhKEsUNHb4B+uHW8OwCd1xQu
         kmizxc3aljTXuReVWW0HB9Dyy0zVZRDQSTL9kzwPjUS3QcJvDJ/hcrSckmSpZfwO6W
         jBASYoVv19OV40gXLDlnNhJ+etYpaUeLsrpDLiL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 113/205] failover: Fix error return code in net_failover_create
Date:   Fri,  8 Nov 2019 06:36:20 -0500
Message-Id: <20191108113752.12502-113-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 09317da317e55e70ccbe23f65008348a4a1b7c7f ]

if failover_register failed, 'err' code should be set correctly

Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/net_failover.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 5a749dc25bec4..beeb7eb76ca32 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -765,8 +765,10 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	netif_carrier_off(failover_dev);
 
 	failover = failover_register(failover_dev, &net_failover_ops);
-	if (IS_ERR(failover))
+	if (IS_ERR(failover)) {
+		err = PTR_ERR(failover);
 		goto err_failover_register;
+	}
 
 	return failover;
 
-- 
2.20.1

