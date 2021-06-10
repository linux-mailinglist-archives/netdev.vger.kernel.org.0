Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B951A3A322A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhFJRg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhFJRg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:36:57 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAB7C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:00 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id k25so422500eja.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=by48++3AxiExmswbyD3pG9IXGFwzf6C3FctQPsWJ55c=;
        b=vTpuuBnzeN2ZslCSb1IlgPYL9nQmNG7kKToRPnrBeArmVvWgFap2Ite6NAUv5qT+c+
         YatJFg1/V0h7PpZ9Me5J5bUAVOdodeqJqV4IKjVXEBOSaoeVgv4cgYZkLbC3GQwaWgHe
         3Vld/u661Rjp/fYGZNC+ehtTA/qpPMlJOriix3ELWx1Fg/bcpV2wwFZKOspad/35wizc
         Ndm945t6MdqouZUa2O1hm9KQMkKAwGOe4fmuSwgRppRQc4FsO1/Apd/Be5T9Yg++7YR0
         WkKMM5X1vEIebdba5MeEvT/FIYTRjOB4WGikCPB7NxVOoyDil7QBRXK+BjQgbg3efMQ7
         MrmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=by48++3AxiExmswbyD3pG9IXGFwzf6C3FctQPsWJ55c=;
        b=AOJuee99zydJ/DVZjnlTWG1SmLXMo000U9FPQDbfwglx4deDlmujVs5lcPMz++dYRz
         wyrlVSot8Q39kiFZ9nPMTTjTpvuEDgXVPeLS2EYoYC78yjxb8YR0Vo/ipoVpkQ4Kz8dI
         dvjP7HFzQQHNAnjTV8DNT77EpBvTs38jW1fzQhjYlsAk392SNtK1lgnSVqJXEa43l9oU
         vKJeo8lSMLdwk1KNniCvLP8gfUjDVZdYuy74tZBGMbTDi4BtAYQM7ztaUks5GdL6YlW1
         +oHa6RwIIZ8PShOWDfqtJ4zEh8LW9n3uKM1/OeXfd7njDh1x2sQfUf8Y6DKi92dMBk+8
         b1rg==
X-Gm-Message-State: AOAM530lgo/5qz3KW5/s2P3obQnLo5ROlqEM+D8Ne93WsAKYlrPjyZy8
        WuKNtg70l2VIQi30Wq4DoKw=
X-Google-Smtp-Source: ABdhPJzEg1NnzTszwinkN+hKSP+jTTcym0AQMSNIIBNaJb2LPX4WEC1TBFY0CLL/9Xk/G2rw+E8GxA==
X-Received: by 2002:a17:906:3181:: with SMTP id 1mr738421ejy.36.1623346499124;
        Thu, 10 Jun 2021 10:34:59 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:34:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 01/10] net: dsa: sja1105: enable the TTEthernet engine on SJA1110
Date:   Thu, 10 Jun 2021 20:34:16 +0300
Message-Id: <20210610173425.1791379-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As opposed to SJA1105 where there are parts with TTEthernet and parts
without, in SJA1110 all parts support it, but it must be enabled in the
static config. So enable it unconditionally. We use it for the tc-taprio
and tc-gate offload.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3b031864ad74..de132a7a4a7a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -673,6 +673,8 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		 */
 		.tpid = ETH_P_SJA1105,
 		.tpid2 = ETH_P_SJA1105,
+		/* Enable the TTEthernet engine on SJA1110 */
+		.tte_en = true,
 	};
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-- 
2.25.1

