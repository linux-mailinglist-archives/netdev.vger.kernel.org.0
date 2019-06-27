Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6887358D54
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfF0VrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:47:06 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43839 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfF0VrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:47:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so4104422wru.10
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RRSC+v5GAyc4d+LzE65opWJ8QI+45lAcuwx3or+abKU=;
        b=i5LzB36nHBrIc021M0gzuZFThpn7vp4kkBISUs9DT1Gg3JvBbZseoSp4/RzhuP1jYj
         N8ObpQIIFIzu4PAz31Wr85JA8gWu2MQzacSFX3Cv3pvqGTZaufiLc0YPu+NYjvixbodq
         LoAHaPLcKKmSMI4RxVJzfIiq/gidSvoZ11n10GUAe0b9hDYQ+RpFQZw2uC4u1SODhFyy
         1VG0SvOM7+zJ7FNPwZinBMM/DiSduUfxOU/9IAEcDfjwTPRsWIWPUqP3odqIkesw1Ua8
         XQqwSghrS7BegwQcGtlylVU/5XCuuwdfp4SSdO0B4cgCcL3s9P+9uJNAuk6Wkl0y6Kw4
         gtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RRSC+v5GAyc4d+LzE65opWJ8QI+45lAcuwx3or+abKU=;
        b=Oeg8nHMfsEAcqnsJtc82mOIB6XOJpVXjyXajwx7DksB4gYYhwpEG4PXNA9JENjEFnA
         Q4ilVqhivfN1BsBbq2/0+RCC6URzx4XAWIbBPTuoOFpSCM0Fnketn7Lw9Pe75w+BdV2V
         +EQ0J+/dAorFe3Z/P102m3MhYA2AGiJ+Yfr9Pa7wtMnw95VS2zNWmTrYh0ttn1xUwH7k
         lq4/YJgOzdx9RSXJCRxhsMuk2MiFKuTGSi/f92E8NO6K92Rp4u8Wu5CTbHsty0g09Yz0
         CuiNAJ7w1UfubRZaVvB7uP1WqeUzg2uNYJlM7IzgqbhhPA7V53Cb1EibF+lPXq8AXt4A
         ThjQ==
X-Gm-Message-State: APjAAAVsVFnVhEp0MZZ5cvcvND89d0PHL9PooxaH0fw4JS15gzIUaBsm
        d9+zRq9Q42Z+MT0Orcf5xuM=
X-Google-Smtp-Source: APXvYqwRvt4byK9oXymeVstszeRi013Emp/ojC5OmClqBM+7Z82dIIAtoY6SE7OshDdRFaWKdaLvZQ==
X-Received: by 2002:a5d:4909:: with SMTP id x9mr4524309wrq.226.1561672023111;
        Thu, 27 Jun 2019 14:47:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id v18sm286923wrs.80.2019.06.27.14.47.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 14:47:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v2 net-next 1/3] net: dsa: sja1105: Don't check state->link in phylink_mac_config
Date:   Fri, 28 Jun 2019 00:46:35 +0300
Message-Id: <20190627214637.22366-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627214637.22366-1-olteanv@gmail.com>
References: <20190627214637.22366-1-olteanv@gmail.com>
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

