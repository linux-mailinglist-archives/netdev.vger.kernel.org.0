Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9952638E734
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhEXNQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbhEXNQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170F6C06138C
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:47 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id l1so41735777ejb.6
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Wqlk+TZ8rZk9OYrKPRVyDZXufQCwM9t3DpuLMUaIGs=;
        b=s4e99W2Uc8hVXqKNuizngm6eXHlUOsbymM6PnK3wmWa/bqea1zbPB3eI8Aa7E3ytfb
         /8FfmTcchbi4N4aAdl/B0pyl1eqBxKjwhOJtLLHuzAFZxu7cgEgF2B8+54fGubKtZ4rd
         Zszvigaa8Ba4obhDSBLa3eL5UKQgZcu5mDQmLlCzXDt+gflDGaSZvGZ/06bWHJHhe/29
         I3rroCp+vfU3kNL2P8+K6MueXhBxg1WpP9Ft++KDi26lPWGCzzMTQi5D+6meUa3rkV2h
         ybLzS5VmcA4Agnc/qVrFZR+64Wdory7Tmi3pKQkYK0CCiaF7ll2UCBz6lTBZ5VBSQkTK
         leVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Wqlk+TZ8rZk9OYrKPRVyDZXufQCwM9t3DpuLMUaIGs=;
        b=oAGRZOhZ1UEKnoIFHjWtIkcTleEoI6h3V65AINBtKQf1xIgMRsehMxJlrqPXMxTi/7
         pmwdJdSl5lyYFxKj5qHdGaKQ0mh/H493oSop5amL/SfEoquufpis+Ha7+xCjFq76RLjb
         6DAgnW2xjhfWlo7fTPIBVrFrcWkxOwb2RTQmb9kuKUchHwBFtc0TJDhmO1z4mzfVIncr
         bhTocV71wbXfD0v6Y33lPGRxG7G8xAx9/zcahtAuVZwGdZG5BMPJM8dnqfRwPmQ91Km5
         YC0FKSa2Qlg5XvkcKZ5zgLnTKQt8DaXNFfdST5BVZbujqIsLsj/CeXEauJf1w4T2Uhqz
         uu9w==
X-Gm-Message-State: AOAM5328WH1zDcivL434RjWj722UaJHwS/VC6PZRBzRIubTfFwmU2oPL
        Dz8bsIp5tiuQVGfi63HcFnYs84oUAIo=
X-Google-Smtp-Source: ABdhPJxd4kTxkqzTKcVbLtBaDo2dUKrTlrJ6OID1nUB0oDItMCY2m4PeZyey6cDzg0gV+xPKzdfRBQ==
X-Received: by 2002:a17:906:5786:: with SMTP id k6mr22640101ejq.198.1621862085735;
        Mon, 24 May 2021 06:14:45 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 4/9] net: dsa: sja1105: don't assign the host port using dsa_upstream_port()
Date:   Mon, 24 May 2021 16:14:16 +0300
Message-Id: <20210524131421.1030789-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If @port is unused, then dsa_upstream_port(ds, port) returns @port,
which means we cannot assume the CPU port can be retrieved this way.

The sja1105 switches support a single CPU port, so just iterate over the
switch ports and stop at the first CPU port we see.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5d5f6555dbac..4a81b1b1cef3 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -556,7 +556,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		 * receieved on host_port itself would be dropped, except
 		 * by installing a temporary 'management route'
 		 */
-		.host_port = dsa_upstream_port(priv->ds, 0),
+		.host_port = priv->ds->num_ports,
 		/* Default to an invalid value */
 		.mirr_port = priv->ds->num_ports,
 		/* Link-local traffic received on casc_port will be forwarded
@@ -579,7 +579,16 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.tpid = ETH_P_SJA1105,
 		.tpid2 = ETH_P_SJA1105,
 	};
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
+	int port;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_cpu_port(ds, port)) {
+			default_general_params.host_port = port;
+			break;
+		}
+	}
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 
-- 
2.25.1

