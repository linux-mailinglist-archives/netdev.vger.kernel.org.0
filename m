Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653451E601E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389661AbgE1MHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388792AbgE1L4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9593A215A4;
        Thu, 28 May 2020 11:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667000;
        bh=3ASy16F1es7vnkanNr20OUjC6E3fVOIgH1vN2GFFwpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2Fjqgi9a1ivGcMQFd/pPMEjz5mFcriS5N2ATPhDGNeQaUi9OhyeGJ/BjD6+Aw0ZJ
         e9qegFlOmAp7yVJGpUJ8Puv7yydGm+eX9GV/1MkR75yIlDXcknKI9Og/CFRn5P7R+o
         oSt7ZtXoRRERfuEPEp8pL+cySgTVQ4EhGJntrFJA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 35/47] net: mscc: ocelot: fix address ageing time (again)
Date:   Thu, 28 May 2020 07:55:48 -0400
Message-Id: <20200528115600.1405808-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit bf655ba212dfd10d1c86afeee3f3372dbd731d46 ]

ocelot_set_ageing_time has 2 callers:
 - felix_set_ageing_time: from drivers/net/dsa/ocelot/felix.c
 - ocelot_port_attr_ageing_set: from drivers/net/ethernet/mscc/ocelot.c

The issue described in the fixed commit below actually happened for the
felix_set_ageing_time code path only, since ocelot_port_attr_ageing_set
was already dividing by 1000. So to make both paths symmetrical (and to
fix addresses getting aged way too fast on Ocelot), stop dividing by
1000 at caller side altogether.

Fixes: c0d7eccbc761 ("net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 419e2ce2eac0..d5aa4e725853 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1460,7 +1460,7 @@ static void ocelot_port_attr_ageing_set(struct ocelot *ocelot, int port,
 					unsigned long ageing_clock_t)
 {
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
-	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies);
 
 	ocelot_set_ageing_time(ocelot, ageing_time);
 }
-- 
2.25.1

