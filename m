Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B12225F89
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgGTMuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbgGTMun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:50:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C018AC061794;
        Mon, 20 Jul 2020 05:50:42 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595249441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CB5H/YHGiCyYzTr4iglevitlMOepA1m6Hp8M8xP/Zcw=;
        b=VNGH+WeW7XyE6iv6uKO8KcHM0OAirZVPw+HHF0T0/bcv48RBO0ckGKlkB5fVhwBXKOtf0g
        UXpabsT3V+2mNNRhCA6ZoYEOIzHb+F1HcAhgJtneqMMw9aLp50wJpk+yrxczOqbrWjcwrg
        WgIX7Y6zIUZIGGi9imcUidEtXX4Va4jKsPebO1HVk2Z2PZoTemkklLk48lqI9SERyPoNKH
        hA4tR5/g7ui5Y22HfVPznJoY/J58YOBFGZXpYf70BLEyYWiMva5yoV2gNcfV1z96Bxki+M
        9JvV3LDbWM4rADXk8dzUfLeMMDKLuU6H2O/QqGWXsujl9269DjmM3lZFxJGqoQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595249441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CB5H/YHGiCyYzTr4iglevitlMOepA1m6Hp8M8xP/Zcw=;
        b=rRa5puuGs4dFxAOEOVk4GHxLZc7qyq/7YN4X4YuMJfd5CsjHERs5YaHOxAdaJBOk2clIhj
        eG5URipdCn60X+Cw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 3/3] net: dsa: of: Allow ethernet-ports as encapsulating node
Date:   Mon, 20 Jul 2020 14:49:39 +0200
Message-Id: <20200720124939.4359-4-kurt@linutronix.de>
In-Reply-To: <20200720124939.4359-1-kurt@linutronix.de>
References: <20200720124939.4359-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to unified Ethernet Switch Device Tree Bindings allow for ethernet-ports as
encapsulating node as well.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/dsa/dsa2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e055efff390b..c0ffc7a2b65f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -727,8 +727,12 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 
 	ports = of_get_child_by_name(dn, "ports");
 	if (!ports) {
-		dev_err(ds->dev, "no ports child node found\n");
-		return -EINVAL;
+		/* The second possibility is "ethernet-ports" */
+		ports = of_get_child_by_name(dn, "ethernet-ports");
+		if (!ports) {
+			dev_err(ds->dev, "no ports child node found\n");
+			return -EINVAL;
+		}
 	}
 
 	for_each_available_child_of_node(ports, port) {
-- 
2.20.1

