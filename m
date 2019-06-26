Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4358056779
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfFZLVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:21:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35229 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfFZLVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 07:21:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id f15so2310202wrp.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 04:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RRSC+v5GAyc4d+LzE65opWJ8QI+45lAcuwx3or+abKU=;
        b=aA9l4hfukvv0t9cZWo2cSMYmODdu13DEoUyNr7r8ySAleYysqRCEoiPmPWjt2t6ZGe
         zhNOvDmwa+pAmBzVzKHRAx+BwiwKFbaGd+M+5BVeRCVVyQ4gqUxvNqWgq5KKDVP3WKcJ
         7cqPE2012fUPA6BDg/adpIrSTYcz0F1K3CUpl49xDkDGe9rkf9xlajJgEmpb9t4K4puN
         HJonGbqd6ySGiKEUAcEyBh+wCdeRY/4oOdlPB7MiTsFO2ZT9HQvtBqS8m7FDEVyCTbg4
         aUxpdzC9/z+EWbAK5A/hQSna3pkv0pNhqCmYzihrtKhu0QznRRcn3S+p2iqRTGK85kL6
         viWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RRSC+v5GAyc4d+LzE65opWJ8QI+45lAcuwx3or+abKU=;
        b=r9FG9Bbg9PJbZu6d5O6L9psGJhRX3ObSpaBb1QRrElYGNz2Ga9u2v8+NdcXOPzDDD0
         D4l7WTlCH+VKIW7JBplJxIim8DHWwcagDn2YqPWG3hJfb63zsZzt7s6HlG5m7NtZLl4W
         8GQ0Hp/765mjzTcbhdoG7xYo4FrErgTSTGWrdZfIDvRtYjFNMYZahLtW3HRGNpiFi7PP
         FuBxPtSD4hGHiRdmtbBs97/IDTY8un0biVNiK/kcW/I68ZJB0pW6nfTb0C9fvQtM52BN
         tPiq6TnzWgdr9JS527dhxPxVgPPZNLD+BBs65LrzReoXx13TlRY5i5B805bCQLr0/h8t
         k11g==
X-Gm-Message-State: APjAAAVrL98KjQlzUPltwPgoiGS5Wo4nsc7M9Szy46dh4LT6lRlkU8bS
        01j9zOkdPKBia6PxjRWgwjE=
X-Google-Smtp-Source: APXvYqzTR/+iCLsYovHXEjDUpKBRR0YpNa8+ukE9aErF9z8aASfTmSA/Alb/AR/alsV58Eg26+7VeQ==
X-Received: by 2002:a5d:4489:: with SMTP id j9mr2264100wrq.15.1561548071859;
        Wed, 26 Jun 2019 04:21:11 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id h14sm6233701wro.30.2019.06.26.04.21.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 04:21:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     rmk+kernel@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: sja1105: Don't check state->link in phylink_mac_config
Date:   Wed, 26 Jun 2019 14:20:12 +0300
Message-Id: <20190626112014.7625-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626112014.7625-1-olteanv@gmail.com>
References: <20190626112014.7625-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been pointed out that PHYLINK can call mac_config only to update
the phy_interface_type and without knowing what the AN results are.

Experimentally, when this was observed to happen, state->link was also
unset, and therefore was used as a proxy to ignore this call. However it
is also suggested that state->link is undefined for this callback and
should not be relied upon.

So let the previously-dead codepath for SPEED_UNKNOWN be called, and
update the comment to make sure the MAC's behavior is sane.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index caebf76eaa3e..da1736093b06 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -715,7 +715,13 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 
 	switch (speed_mbps) {
 	case SPEED_UNKNOWN:
-		/* No speed update requested */
+		/* PHYLINK called sja1105_mac_config() to inform us about
+		 * the state->interface, but AN has not completed and the
+		 * speed is not yet valid. UM10944.pdf says that setting
+		 * SJA1105_SPEED_AUTO at runtime disables the port, so that is
+		 * ok for power consumption in case AN will never complete -
+		 * otherwise PHYLINK should come back with a new update.
+		 */
 		speed = SJA1105_SPEED_AUTO;
 		break;
 	case SPEED_10:
@@ -766,9 +772,6 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
-	if (!state->link)
-		return;
-
 	sja1105_adjust_port_config(priv, port, state->speed);
 }
 
-- 
2.17.1

