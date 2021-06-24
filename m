Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6C33B32DF
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhFXPyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhFXPyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:54:38 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9282C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:52:18 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s6so9186828edu.10
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pu/g2b+XuRImHt/QZ8v2d1zoeT32cbUhDFClrmI9wrw=;
        b=nxflM7MZkX+AxgeplmnPXBt/GcLeQcc74upvLGq7pWE//cc35kOyE4ss+ttEQjUkJ9
         thiflgCal2wvXaci/MzRveQC2AupaVoZO7kd3ktPjh3z3IrxkicHIW7zoNkGeASJyBw1
         fQp0IK58+pSCcOlphFTRt6KmTvSeg+1kUQARr9LHAFT3VJ5ynhRkU77iiioSoM5E9lln
         1EIVBqbGpl3kRUQBhJtIKj46+ng3tFSZXHUhMzn3WckmO3+HOQ4ti6qt1GYvmN0PyrWu
         R98h0FYC5UvewsvpeQTOm7DjuPTILJQMrhOxSo0qq4JO4uRetqyQa/uQ9zUZqHqtWgpB
         Og5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pu/g2b+XuRImHt/QZ8v2d1zoeT32cbUhDFClrmI9wrw=;
        b=HTT1q+WjJY3N2guOThOPkGft1+A+9ieo599GKftllLfN5xKjxGVP2FmQyH2IfcyUty
         OeIUT8cLJLaPrYLZ+vjailSNXwPI1ECOdm8hOe8q8dsTAxcoubTjlhYMyFkUYPR3kTRL
         PX4u7+T37I7HhNPylf2KI15qdnZT7uhOec23E6QZdwf7B21XHUohZAueKzUHhVroVKgX
         M/bkursegwwsXVzkWjRcwJYWUdT3RAopLMWj0A/PALS39XIBqXtByMIPCBaniZYqZNju
         3V3NhgJXpL9cCteKnco7Xd2mkg2T1XpwmNcQyYKQgFJiXCVQ0raNs529Xlwio9bZUvjo
         JOOA==
X-Gm-Message-State: AOAM530NYHVgamoZjs7ZrL9RM43E2cd/yT3cxBOYZ4i9I52e61PN/Mz9
        yxu8mC5XNqoqWRvQMZr06s0=
X-Google-Smtp-Source: ABdhPJziRVcMywrWHMHBsLQ2wV/jIe2LUWZF6Vo8rPshS6+JggVK6FV65rAYPPp0PxcJpFudL50feQ==
X-Received: by 2002:aa7:d34f:: with SMTP id m15mr7837260edr.311.1624549937291;
        Thu, 24 Jun 2021 08:52:17 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id hy18sm1396423ejc.111.2021.06.24.08.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 08:52:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: dsa: sja1105: fix NULL pointer dereference in sja1105_reload_cbs()
Date:   Thu, 24 Jun 2021 18:52:07 +0300
Message-Id: <20210624155207.1005043-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

priv->cbs is an array of priv->info->num_cbs_shapers elements of type
struct sja1105_cbs_entry which only get allocated if CONFIG_NET_SCH_CBS
is enabled.

However, sja1105_reload_cbs() is called from sja1105_static_config_reload()
which in turn is called for any of the items in sja1105_reset_reasons,
therefore during the normal runtime of the driver and not just from a
code path which can be triggered by the tc-cbs offload.

The sja1105_reload_cbs() function does not contain a check whether the
priv->cbs array is NULL or not, it just assumes it isn't and proceeds to
iterate through the credit-based shaper elements. This leads to a NULL
pointer dereference.

The solution is to return success if the priv->cbs array has not been
allocated, since sja1105_reload_cbs() has nothing to do.

Fixes: 4d7525085a9b ("net: dsa: sja1105: offload the Credit-Based Shaper qdisc")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index a9777eb564c6..4f0545605f6b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1818,6 +1818,12 @@ static int sja1105_reload_cbs(struct sja1105_private *priv)
 {
 	int rc = 0, i;
 
+	/* The credit based shapers are only allocated if
+	 * CONFIG_NET_SCH_CBS is enabled.
+	 */
+	if (!priv->cbs)
+		return 0;
+
 	for (i = 0; i < priv->info->num_cbs_shapers; i++) {
 		struct sja1105_cbs_entry *cbs = &priv->cbs[i];
 
-- 
2.25.1

