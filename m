Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44F22A0D79
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgJ3Sd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJ3Sd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:33:27 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D96DC0613D2;
        Fri, 30 Oct 2020 11:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:Sender:
        Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=arFiHimQtiFJb6n6XZtdH+1ty6P+gA0qV1YCQIOIjbk=; b=aJHkwdWk41/8ufHHLn2WXErvDb
        dSUEkmia/KuWPYiFNhG99EkAxwqDtmrRsVtEHBAsPL/Kof5rlu2W1676LwG/frn5/xY692AN+jiCi
        dCsEfi2RXzUzi+OTzezrj/v1XcjZAFtOfBaW/WcS6TwRem5OCX/4uctfIQysgAbh0SPHuub5SB3iO
        CsDE8JbSlwIymdTYGualZ2zoHw/i8qZwQyV346jMVe9jnuBfkodIkSjsa7/1N10/Gzkd8ydrmqstn
        8bCyJzlVYMAkOoxkQ6gH30f25dFytHOMU8XnESJXrFWSi21vH9Dt05g/cVX7wb6dqU0tlN3wiZrD4
        j2TNba8A==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1kYZD9-0001uR-F7; Fri, 30 Oct 2020 18:33:15 +0000
Date:   Fri, 30 Oct 2020 18:33:15 +0000
From:   Jonathan McDowell <noodles@earth.li>
To:     DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: qca8k: Fix port MTU setting
Message-ID: <20201030183315.GA6736@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qca8k only supports a switch-wide MTU setting, and the code to take
the max of all ports was only looking at the port currently being set.
Fix to examine all ports.

Reported-by: DENG Qingfang <dqfext@gmail.com>
Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/dsa/qca8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 53064e0e1618..5bdac669a339 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1219,8 +1219,8 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	priv->port_mtu[port] = new_mtu;
 
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		if (priv->port_mtu[port] > mtu)
-			mtu = priv->port_mtu[port];
+		if (priv->port_mtu[i] > mtu)
+			mtu = priv->port_mtu[i];
 
 	/* Include L2 header / FCS length */
 	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
-- 
2.20.1

