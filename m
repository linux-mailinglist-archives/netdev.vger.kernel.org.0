Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828A962BADF
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbiKPLGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238598AbiKPLFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:05:42 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0352FC2C
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:11 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t10so21347757ljj.0
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2xrQk2QoCyteNifyf752ChzTmEoJc0akwXN/7mZghA=;
        b=YfHd5X8Fm9dFTkqIZ5zqj5PM0vD9bQ8Yq2Mx8q76pWZYve8hTYVa2e9rHhRlXd/Kps
         yFrjC30R+XS6HIRd6w/l3CWK/zTudgPrGT9wX0HOz8+sQlPSSy66T4UNKZqpLq1pzITC
         iQDFkQDAT5keVT9YQOIZMsOReK9dc1UfVS7FY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2xrQk2QoCyteNifyf752ChzTmEoJc0akwXN/7mZghA=;
        b=bYUY2J33T4ZYXO0tpLnKkJA9YVXpxqnZivTTjem7221v993tzTn0EcCHtv68XRbdeu
         xSGHsTCEWrsN/bipZQofiHYH7NL7Kt3v3N0vK+/LoR639e4HOs0tmffwbmOM09DKOJhU
         TTqBZlmYLpQ8mpj+HkP1TkjU01bqFldg2CdK1lr7dVRHyYqLbuDUl8mydD0NhhYtbc5w
         5/HaOqDbHC3KBYnlLIawvGYx7JyiChdlEminKxJEU2bCSBFQdZuQ7dIrUN9yqkQ/tcgR
         QhtM2jDGPExq3TJavg69Ln7CWDckhuqvU3nPL6wteevnlZC6zqoPIGuk7PSGZnzsm6ZX
         26AA==
X-Gm-Message-State: ANoB5pkLv3DMckV6qU1OpeTywJRT4YM7DY2uj6ZO6Gy7ZNIJ+gNICss4
        VqyFKcMWrRBs9dDem+rPU3bEqw==
X-Google-Smtp-Source: AA0mqf4UqMmKuAqhLDlKz1ZS51zEl8c7CRymYZthgAknebgfsxHP6+A/Ts1VpueTwhK9ox6z9gdGww==
X-Received: by 2002:a05:651c:905:b0:277:71e4:20a3 with SMTP id e5-20020a05651c090500b0027771e420a3mr7303564ljq.332.1668595929858;
        Wed, 16 Nov 2022 02:52:09 -0800 (PST)
Received: from localhost.localdomain ([87.54.42.112])
        by smtp.gmail.com with ESMTPSA id g42-20020a0565123baa00b004b094730074sm2547119lfv.267.2022.11.16.02.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 02:52:09 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] net: dsa: refactor name assignment for user ports
Date:   Wed, 16 Nov 2022 11:52:02 +0100
Message-Id: <20221116105205.1127843-2-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
References: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following two patches each have a (small) chance of causing
regressions for userspace and will in that case of course need to be
reverted.

In order to prepare for that and make those two patches independent
and individually revertable, refactor the code which sets the names
for user ports by moving the "fall back to eth%d if no label is given
in device tree" to dsa_slave_create().

No functional change (at least none intended).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 net/dsa/dsa2.c  |  3 ---
 net/dsa/slave.c | 13 +++++++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e504a18fc125..522fc1b6e8c6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1364,9 +1364,6 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 
 static int dsa_port_parse_user(struct dsa_port *dp, const char *name)
 {
-	if (!name)
-		name = "eth%d";
-
 	dp->type = DSA_PORT_TYPE_USER;
 	dp->name = name;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a9fde48cffd4..d19e9a536b8f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2374,16 +2374,25 @@ int dsa_slave_create(struct dsa_port *port)
 {
 	struct net_device *master = dsa_port_to_master(port);
 	struct dsa_switch *ds = port->ds;
-	const char *name = port->name;
 	struct net_device *slave_dev;
 	struct dsa_slave_priv *p;
+	const char *name;
+	int assign_type;
 	int ret;
 
 	if (!ds->num_tx_queues)
 		ds->num_tx_queues = 1;
 
+	if (port->name) {
+		name = port->name;
+		assign_type = NET_NAME_UNKNOWN;
+	} else {
+		name = "eth%d";
+		assign_type = NET_NAME_UNKNOWN;
+	}
+
 	slave_dev = alloc_netdev_mqs(sizeof(struct dsa_slave_priv), name,
-				     NET_NAME_UNKNOWN, ether_setup,
+				     assign_type, ether_setup,
 				     ds->num_tx_queues, 1);
 	if (slave_dev == NULL)
 		return -ENOMEM;
-- 
2.37.2

