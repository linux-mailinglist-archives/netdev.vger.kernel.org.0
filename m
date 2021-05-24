Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3D838F629
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhEXXYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhEXXYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:24:00 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036DBC061756
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:31 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gb17so26268531ejc.8
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/9bWhs445gAiwdSyw3ietl2EjsqD9TY4kwX3Wb/IRHc=;
        b=jVb+0oyzWHQIZMZEbzkmw5LgGBNmfhUN4J/GCG3+oa6LjOti5o8WYSf8GqxXOHXh4d
         rz69ETK3zmvY4s6U+qrTOlbKAfOqsKRnbez6Qpn6oqiNiJ/9wvjQUmVA9oOF/zvm2J+Z
         ggIr1dGdmIfA3Pk201NVpSeVLRgGFUPCSx5R7SXN/Dp5LvudwJxqLpt3GnUrJdcjnGfh
         /W888eR9uKd1kr8Ziwlq1kSq25IZCOt+fJHXUnlhZZYRuD8MwrhDMnBg50e4LXXLwZAT
         9GuomSuorFtVwv5BR6FStCyMauQe/mjUpKvWy8H/+fQNpmApuFzrQRQdEqE8L1V8gkKt
         EYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/9bWhs445gAiwdSyw3ietl2EjsqD9TY4kwX3Wb/IRHc=;
        b=UMt7ARrNZRV+ANdd6jqKxS43IMPDbDG6LOBpPJRYaCKGJ/ENgTEnjE+jb6crbXZ87j
         QoiyfOxEKy14WMRB4j60aK/cP2hV1JkVDAbUS8Re/3xTjNXiz5DNoWABRzyhcJlpnOFt
         Mr1PFYV5LHo9tZkMYTSnZtyTTzqpM36nqlHfH1rVjICSXVNLPQPQ2AMdp4kBCYd3zM6S
         O9cz3eNVJtYNquxGvTLAq7eU7CzgosLuFzwAGOdCtYt9FXxfYYHMXKGQIpP5HZ5UDhKJ
         zEpgRCAv8r4Icu8eYwmt2oiLZ6Bpbz92mjgloiCPdYkAStLCKhj/0lKRcZuPdeM4oXyf
         Sm0Q==
X-Gm-Message-State: AOAM533SogQTIp9mm1zMIbXp/OUB/Y27VAWWYbfULcMfmgYg8grTdoJF
        6CM3OKGZ99Xxx+NhvqtJeq0=
X-Google-Smtp-Source: ABdhPJxPJMYVUz/YYvCPKM/3jsyvBhlFie+KPAuEdXYEO/13JVnU/kmd/ohfvYDLM4NopzY4Aql40Q==
X-Received: by 2002:a17:906:5917:: with SMTP id h23mr26019808ejq.457.1621898549614;
        Mon, 24 May 2021 16:22:29 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di7sm9922746edb.34.2021.05.24.16.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:22:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 01/13] net: dsa: sja1105: be compatible with "ethernet-ports" OF node name
Date:   Tue, 25 May 2021 02:22:02 +0300
Message-Id: <20210524232214.1378937-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524232214.1378937-1-olteanv@gmail.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since commit f2f3e09396be ("net: dsa: sja1105: be compatible with
"ethernet-ports" OF node name"), DSA supports the "ethernet-ports" name
for the container node of the ports, but the sja1105 driver doesn't,
because it handles some device tree parsing of its own.

Add the second node name as a fallback.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 11fffd332c74..b6a8ac3a0430 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -885,6 +885,8 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 	int rc;
 
 	ports_node = of_get_child_by_name(switch_node, "ports");
+	if (!ports_node)
+		ports_node = of_get_child_by_name(switch_node, "ethernet-ports");
 	if (!ports_node) {
 		dev_err(dev, "Incorrect bindings: absent \"ports\" node\n");
 		return -ENODEV;
-- 
2.25.1

