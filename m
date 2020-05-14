Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD641D3CAC
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgENTJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728485AbgENSww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:52:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C452065F;
        Thu, 14 May 2020 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482372;
        bh=lcueI47yo6BlEzNwWWuUHfShAOnbiSny5HrrmS9O73I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzPZ+c6/YiZJo8ZCY8lgZb3g8Oxvs+KHC0AQLbrpYo1r/POk4g+d46FLMYkGuU2mv
         cNB172hVMhi8uvMY/LeyRJey0inTqRQ+kKDfmNGny7OJW0z+dZnWJrxmzoE+COJLDQ
         no6AuMKwrp5v9AeLxs7mHjniXJcwGOe86wBbq7AE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Faineli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 50/62] net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms
Date:   Thu, 14 May 2020 14:51:35 -0400
Message-Id: <20200514185147.19716-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c0d7eccbc76115b7eb337956c03d47d6a889cf8c ]

One may notice that automatically-learnt entries 'never' expire, even
though the bridge configures the address age period at 300 seconds.

Actually the value written to hardware corresponds to a time interval
1000 times higher than intended, i.e. 83 hours.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Faineli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 33ef8690eafe9..419e2ce2eac07 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1444,8 +1444,15 @@ static void ocelot_port_attr_stp_state_set(struct ocelot *ocelot, int port,
 
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
 {
-	ocelot_write(ocelot, ANA_AUTOAGE_AGE_PERIOD(msecs / 2),
-		     ANA_AUTOAGE);
+	unsigned int age_period = ANA_AUTOAGE_AGE_PERIOD(msecs / 2000);
+
+	/* Setting AGE_PERIOD to zero effectively disables automatic aging,
+	 * which is clearly not what our intention is. So avoid that.
+	 */
+	if (!age_period)
+		age_period = 1;
+
+	ocelot_rmw(ocelot, age_period, ANA_AUTOAGE_AGE_PERIOD_M, ANA_AUTOAGE);
 }
 EXPORT_SYMBOL(ocelot_set_ageing_time);
 
-- 
2.20.1

