Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C39F1F2C4F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732918AbgFIAXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgFHXRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 028882085B;
        Mon,  8 Jun 2020 23:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658237;
        bh=fG6qvArHAOpxPBq0c7pJwPJv0dvVieW7wkNnf/C8oaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kh6NK8TLO2BmEZxdgrETlHt2oD3h5mzb4MS4M6ygI0FEqnD+FjrlMWBUCwd7Pkr2t
         n3JODDRz5Eali5oYR8Hj1NHXvOVE9UZStGw0QXkMirnmZ75GMrQarsRl2hBqwtkY6Z
         Rvp0QjttJmuzFRLqVnmkTDxCz4jpvxg5NM3xJNQg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 249/606] net: mscc: ocelot: fix address ageing time (again)
Date:   Mon,  8 Jun 2020 19:06:14 -0400
Message-Id: <20200608231211.3363633-249-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit bf655ba212dfd10d1c86afeee3f3372dbd731d46 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

