Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE5526EB92
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgIRCGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbgIRCGK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7EE92388E;
        Fri, 18 Sep 2020 02:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394769;
        bh=jIhQZwXP3VavhttXfmnocOIZi+wRX7HUe9ayE5xeqI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yv2UDUQdcx7xNcptd18lFp7J/vPn4uV29i2hIpcOoh4vQnGRc/h8VCSvHguJYQ1DV
         iYkK7GTFfvmh6W1wgh3z7i5smUHbiK+yUCO6/LbzLeU60lr56GwwFlOAfCRhTU2hNr
         TbmZBC3uunLesvV+tzF+3KJjvityDSZ8wAOXCYkQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, Andy Zhou <azhou@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH AUTOSEL 5.4 244/330] net: openvswitch: use u64 for meter bucket
Date:   Thu, 17 Sep 2020 21:59:44 -0400
Message-Id: <20200918020110.2063155-244-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

[ Upstream commit e57358873bb5d6caa882b9684f59140912b37dde ]

When setting the meter rate to 4+Gbps, there is an
overflow, the meters don't work as expected.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/meter.c | 2 +-
 net/openvswitch/meter.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 3323b79ff548d..b10734f18bbd6 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -251,7 +251,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 		 *
 		 * Start with a full bucket.
 		 */
-		band->bucket = (band->burst_size + band->rate) * 1000;
+		band->bucket = (band->burst_size + band->rate) * 1000ULL;
 		band_max_delta_t = band->bucket / band->rate;
 		if (band_max_delta_t > meter->max_delta_t)
 			meter->max_delta_t = band_max_delta_t;
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index f645913870bd2..2e3fd6f1d7ebe 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -23,7 +23,7 @@ struct dp_meter_band {
 	u32 type;
 	u32 rate;
 	u32 burst_size;
-	u32 bucket; /* 1/1000 packets, or in bits */
+	u64 bucket; /* 1/1000 packets, or in bits */
 	struct ovs_flow_stats stats;
 };
 
-- 
2.25.1

