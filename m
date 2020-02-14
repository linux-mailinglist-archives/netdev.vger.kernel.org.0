Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D6A15F08F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388280AbgBNP5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:57:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388271AbgBNP5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0B924676;
        Fri, 14 Feb 2020 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695852;
        bh=GenGKx8klKN5QOWUcat6rkevYzH+j2MnwyEAoetKWvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uqs3Jx56DNBaxzKJL2+jKtSh2JeVBUQqZiHvXwbUMIWec4bqSu0p1Q/znNiCRVh+2
         w0Q7gh7JbQPKY6RDgssEFeE+jhR5oulOITRZoUSqb+O/6QIIxh1gPZKBY71AAL7W3A
         9M5fPlQmGC7pxVs2aPMmatrH7ezw3Gx35nGP4M8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 401/542] enetc: Don't print from enetc_sched_speed_set when link goes down
Date:   Fri, 14 Feb 2020 10:46:33 -0500
Message-Id: <20200214154854.6746-401-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 90f29f0eada4d60e1f6ae537502ddb2202b9540d ]

It is not an error to unplug a cable from the ENETC port even with TSN
offloads, so don't spam the log with link-related messages from the
tc-taprio offload subsystem, a single notification is sufficient:

[10972.351859] fsl_enetc 0000:00:00.0 eno0: Qbv PSPEED set speed link down.
[10972.360241] fsl_enetc 0000:00:00.0 eno0: Link is Down

Fixes: 2e47cb415f0a ("enetc: update TSN Qbv PSPEED set according to adjust link speed")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 9190ffc9f6b21..de52686b1d467 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -36,7 +36,6 @@ void enetc_sched_speed_set(struct net_device *ndev)
 	case SPEED_10:
 	default:
 		pspeed = ENETC_PMR_PSPEED_10M;
-		netdev_err(ndev, "Qbv PSPEED set speed link down.\n");
 	}
 
 	priv->speed = speed;
-- 
2.20.1

