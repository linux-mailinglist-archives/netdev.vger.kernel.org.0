Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0873B539B
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhF0OMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhF0OMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:50 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A113C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:25 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hc16so24303705ejc.12
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OmnkHE63ICnW7mGQCaJkMYpyhoywe6TU1LHujNyikC0=;
        b=bz8Kpr+MGZyC1/3rlJUN8So35mD4K+nfWNRT6O2LtXLc8yDGtRZ4w512/UItmtoIvO
         MA9VAhEwsOqYX/Tf9L3daS5XFznjQ8yGz/xAmMoJW5qNFe6RUGoT4XnnOWfZt3ombtta
         qorm7xQC7dRhUpKaO+gioZ01mo/WfKAEwL4MIKmeUcMoa0EAwFOAerey+kDMhFiuK1nh
         oRDMyhhyg+jnP/LsbtcPWRllLs+Db9xZBEMA3rftX6RPCDo/cUuKgSto4gyvr7qP95Ru
         CWr+TchgG4AMzgZr1/UrV7efAdQq7iBWu/BLKlvlDftGLgSKXqlQcICI9ecELKnvUGZC
         lMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OmnkHE63ICnW7mGQCaJkMYpyhoywe6TU1LHujNyikC0=;
        b=sC0cPGKnwn5DFb1HM2FZVwbQ/Rv4XN8uZTWRCqvomkFG4BeXrrZ/Z3RKz/R8yz8kph
         0l9Ecuu2Rswkm9g8Gv6fRAbN9yk0xKjtdKmIdLLGuqK05QdR5RO2TAiI+xWgXJ+gwiJi
         Md0Q/hzooVuE4vwUZIpw41qdPWBuOHCiv25S3N2bRe5+dssxLejUY20y6VuP4SoaT5EV
         zacsa3kpY2ax5Rc++WdpbI5pQpv7gB771EOiDCXXrqoOU1Q8N45LXRs+K4ZCFd/z0TaX
         e1HkFqxgLaZWW5yjxA2lZc60gxlUdPD5tAdhNwvEteKdLv2HBk1PsZzV2NtwRDEbBca1
         ki7A==
X-Gm-Message-State: AOAM533emO/uhsvPLt+r/Iw/FgD8LmBzVvwDWE6Y+ci/XBs6nx6FmMPA
        j7lt5iehwclNK5JNRzzdqw8MQhDgdmg=
X-Google-Smtp-Source: ABdhPJxjJsLW478Rl3h109tdIX2Jq4tCuV14bfTolNgliN/7uzrLpj7HdpAqpnPmNvThoiee6mGwJA==
X-Received: by 2002:a17:906:c1d2:: with SMTP id bw18mr20027323ejb.123.1624803023887;
        Sun, 27 Jun 2021 07:10:23 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v3 net-next 03/15] net: bridge: allow br_mdb_replay to be called for the bridge device
Date:   Sun, 27 Jun 2021 17:10:01 +0300
Message-Id: <20210627141013.1273942-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_mdb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 17a720b4473f..fda61a90cfe5 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -617,7 +617,8 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 
 	ASSERT_RTNL();
 
-	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
+	if (!netif_is_bridge_master(br_dev) ||
+	    (!netif_is_bridge_port(dev) && !netif_is_bridge_master(dev)))
 		return -EINVAL;
 
 	br = netdev_priv(br_dev);
-- 
2.25.1

