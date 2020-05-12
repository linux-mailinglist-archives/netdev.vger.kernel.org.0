Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4531CFBFB
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgELRUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgELRUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:52 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8796AC05BD0A;
        Tue, 12 May 2020 10:20:52 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id n5so9498567wmd.0;
        Tue, 12 May 2020 10:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nNWIB3SxMirDe17PObpmwBC9LW76uoACAX+jPiSmZbc=;
        b=uQqY9MZlOmOu8JZLD/vXjkgQdCcIqdKZpAPHj9OIkzOpgWdMmEz7eTXVlmBqlcl/K8
         DM7Pu2ZyvXLeOeHwdXKfO2CYimAOZyINoDoPeRcMm9ZrbyAh8Nbl/egnvBU4uODjcxV2
         xX6VaGqrD07n0wzZ74Q+IUXyHV5HyiCxh19UaZr2G98SIqY0mOZ4oy77e+WHaQJH8xWb
         9uj47VXf/SBmYx4xcCHJR2ncw2gYVW+E/f2A/ioKBGWI2/CgGVyry03hIU6qlMLIkZgG
         c0c+mCgU82RAODjv0xmYrD3zi29Y0m28vZhdJ9goViDeqv3Zn3d6NcsKTVGt1hjvmfEx
         ePkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nNWIB3SxMirDe17PObpmwBC9LW76uoACAX+jPiSmZbc=;
        b=kqsCPMlK37wVBS7bIDyaih741hXOAeY8zrah+U5Ewj2wHypgQpx50SSnhRmsv8BdKV
         bbGv5maZ6YxAoDG1HEwqC+21vUhYMKqdR/sjxmJ9Sdo2nRyW0VUU2gfN0Fqm/sjl3GDR
         fk483+KrFTUK7DDau4S30U2PZIupkTn2BjKDqAKqSbMZ9vDfA+sd2R+MCpjGM0tlAkgT
         bbrCFXBHjpObJMbups8Rd52q/sZ+YO2uLrLM7VrB1QAMGUOHyWHEPglO8Rv/XagL4Cm7
         ACbxDcQ0O8DyUkbx/vhLct6Sy2m279WgvlmJ34ozrf09wFV/+rwa3XYORdYkJAkWXd5n
         MiKQ==
X-Gm-Message-State: AGi0PuZTBrPTKUpSsSO7ZbND5URpzq9trfp3slELJdNvNeW8nxyZrGcl
        auxEBYxuJg/A8L+jYPFPMLShkHXd
X-Google-Smtp-Source: APiQypISzprgoKGZXLf0wrvxMpSRa2eB3/56mjTbss0A6I98G9gn0eGVTbINv1g8thMXZy+W+2Mm9g==
X-Received: by 2002:a05:600c:2219:: with SMTP id z25mr12085962wml.128.1589304051156;
        Tue, 12 May 2020 10:20:51 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 06/15] net: dsa: sja1105: allow VLAN configuration from the bridge in all states
Date:   Tue, 12 May 2020 20:20:30 +0300
Message-Id: <20200512172039.14136-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Let the DSA core call our .port_vlan_add methods every time the bridge
layer requests so. We will deal internally with saving/restoring VLANs
depending on our VLAN awareness state.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
Adapt to the second variable name change.

Changes in v2:
Adapt to variable name change.

 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index fb95130299b1..ca5a9baa0b2f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2350,6 +2350,8 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
+	ds->configure_vlan_while_not_filtering = true;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
-- 
2.17.1

