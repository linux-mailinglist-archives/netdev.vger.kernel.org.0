Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119AD2074F8
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 15:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391167AbgFXNzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 09:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389484AbgFXNzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 09:55:36 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07D0C0613ED
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:35 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b15so1553153edy.7
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G6aQWmNbfcwXVkaoEAsBmW4iaLgVVQpsdUgl5A89JWc=;
        b=QgzMBXeR3wtGhqOFUCmWaJu4Jv/lttGUuaFqCCJrQuIPbA3v81TGR6l8mXrSLo6gRK
         clUxnjqG6uxxSNr3LZcefeUyh/bmTIJUfVoiUYB7YzdaABaqifFK0jM+16AGLC3lgVhj
         YGUFQRYq46I2KH8bXl270FQChoUlybkOTjwF/UtccU5WvjwuwtI2KKXNrpK5ySGEeYDA
         GbFiyceMiwnTKRTaSzPJHUxLgjz6UKziijIT6IdK2spaS04aKqNihixE7E4XV8uZIp/6
         rFkJrk71d6oAw7vCztdwZPG9YNuEkL+tEMLtGKbiJE5n2U1Xf7HS5m/3ViO9PIA8geoy
         9RCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6aQWmNbfcwXVkaoEAsBmW4iaLgVVQpsdUgl5A89JWc=;
        b=pPXjzYjy2n0VlWLQ6em/qYRby/w5sD/f/IdIvUC3jlodXERRSBJCUf3wkO6MxxQIp8
         +LCzifvqa6HBYmgOh6g0DsFmSA7P8YlgGi48nWMTzf/BmR4P12afsz0/wpIVgoZg51Qz
         pFxxMVwXRGVXax7tYytXAS/HPP8fIiPyNRzY8GIZkSZdSfFCWiomDyxe7lYyqidZfbpW
         LPjyLEo3N4OR8AVSPRnbj3HDJP0Y8sl5duH6ifyqJNGyi+f+ctcRXtK/SYzPyP4XLpxH
         MUjxEMA8nZRYSCO+Fs0Hiob9/Uc7ZwipT+aPs7gg0M2BWClHDt/lglBth0RALJw0FSbW
         qXtw==
X-Gm-Message-State: AOAM532hhMOj7+Ouwj/IWgQWi0EXYvx7hNUn0541wysei9XrXP5nkDrX
        98OiQrHgrnACiH4ewI46n1UJVjzg
X-Google-Smtp-Source: ABdhPJzltmv4ViTiwgaV/u/t9VaS72oQLT6MWl9ICS+tVMhHNGDjXMJp+0FXNJJG4Oyz8Nx2Jxsdvg==
X-Received: by 2002:a05:6402:787:: with SMTP id d7mr11101983edy.46.1593006934388;
        Wed, 24 Jun 2020 06:55:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id j5sm17756649edk.53.2020.06.24.06.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 06:55:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        po.liu@nxp.com, xiaoliang.yang_1@nxp.com, kuba@kernel.org
Subject: [PATCH net 2/4] net: dsa: sja1105: unconditionally free old gating config
Date:   Wed, 24 Jun 2020 16:54:45 +0300
Message-Id: <20200624135447.3261002-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624135447.3261002-1-olteanv@gmail.com>
References: <20200624135447.3261002-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently sja1105_compose_gating_subschedule is not prepared to be
called for the case where we want to recompute the global tc-gate
configuration after we've deleted those actions on a port.

After deleting the tc-gate actions on the last port, max_cycle_time
would become zero, and that would incorrectly prevent
sja1105_free_gating_config from getting called.

So move the freeing function above the check for the need to apply a new
configuration.

Fixes: 834f8933d5dd ("net: dsa: sja1105: implement tc-gate using time-triggered virtual links")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 2b7966714e55..936b14cbb45d 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -98,6 +98,8 @@ static int sja1105_compose_gating_subschedule(struct sja1105_private *priv,
 	s64 its_base_time = 0;
 	int i, rc = 0;
 
+	sja1105_free_gating_config(gating_cfg);
+
 	list_for_each_entry(rule, &priv->flow_block.rules, list) {
 		if (rule->type != SJA1105_RULE_VL)
 			continue;
@@ -116,8 +118,6 @@ static int sja1105_compose_gating_subschedule(struct sja1105_private *priv,
 	dev_dbg(priv->ds->dev, "max_cycle_time %lld its_base_time %lld\n",
 		max_cycle_time, its_base_time);
 
-	sja1105_free_gating_config(gating_cfg);
-
 	gating_cfg->base_time = its_base_time;
 	gating_cfg->cycle_time = max_cycle_time;
 	gating_cfg->num_entries = 0;
-- 
2.25.1

