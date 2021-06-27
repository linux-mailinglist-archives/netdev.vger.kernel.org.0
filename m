Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B203B5331
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhF0L5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhF0L5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2493C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id nd37so24100293ejc.3
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KT0Mw+aJ1C0QaTdmJaw0bDUcyw7gNnwG05tV6d6KCzg=;
        b=Yumnqp8TdTxnZaCH8fy3YoceLAm0Rk8SqU1jfqIs9bJvBNnNfrlmAPyZlJW8r/3d/A
         1e0YecQbWacfkxK7HuyYraTGBY4gB7UPA+5yvccWDD6yZpe9e+fuUkH8m+eBHoRtyGEB
         oG6EOf+AFPdpiEBTL7Xk31OC8dKZjz9d+jMJvZDecSlSwZ25l2po4C1imCVYCzzmzVXg
         VLXLL365CcZpCPhmMCMHvWCZc4PHHbzEii6r7Y0w5w0SVeCr0K6yf801S698djgwP42S
         NB5HEkvHlBJw6agta+xScorU/oO7dsetz2f76Wnm+omxLjnNuaXI0uP+OCDsEs+YpYis
         Ha5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KT0Mw+aJ1C0QaTdmJaw0bDUcyw7gNnwG05tV6d6KCzg=;
        b=fEdRqeUSkcCTIXrbLAzHiIGi6WKEl8B2AmfuPIJ7C5JDRrqgIsbc3K9JGrzraEnrG0
         KyaYXwfKYc47bcr4xtu623r+njZLG4qD7KcLXoZkMkMU+4+bQaYbvYtm0D+1g9N2x7pL
         fiMIFhMaGAGeCfsXSi8cE/o5/NxNmGOjtJPhCmM7Up66oi1+ONKdJn5Sy8ZPdY5UDFdD
         oEdhWa1dyPajNudXoUMjwnBwp8+21xllLIYpU7YBMBpiA33qWsoqsy9mZpwXOS16FzqR
         ZDCxukzmKPd3DSA781Z2ivKsXTjt9lwuzqtK67AFU/pSQyWKf1POUcWYStnbJFZeCSjV
         3dIQ==
X-Gm-Message-State: AOAM530zUmoJCfMu04OmHRyN4Yo+V9Ez/MpcwwPFWxpDwU8yjawBJliy
        PF049KWaZlAsTquR7Fypq6Q=
X-Google-Smtp-Source: ABdhPJzaOJQhSgH41e7lm3dJqZ+gQ64CCUJqDVfbWxUgXaZN4Ud0A2dlWYlObM5f3jn8xLY9vcG7xg==
X-Received: by 2002:a17:907:2045:: with SMTP id pg5mr19876179ejb.5.1624794878530;
        Sun, 27 Jun 2021 04:54:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 2/8] net: ocelot: delete call to br_fdb_replay
Date:   Sun, 27 Jun 2021 14:54:23 +0300
Message-Id: <20210627115429.1084203-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
References: <20210627115429.1084203-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Not using this driver, I did not realize it doesn't react to
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE notifications, but it implements just
the bridge bypass operations (.ndo_fdb_{add,del}). So the call to
br_fdb_replay just produces notifications that are ignored, delete it
for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot_net.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index aad33d22c33f..4fc74ee4aaab 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1165,10 +1165,6 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_fdb_replay(bridge_dev, brport_dev, &ocelot_switchdev_nb);
-	if (err)
-		return err;
-
 	err = br_vlan_replay(bridge_dev, brport_dev,
 			     &ocelot_switchdev_blocking_nb, extack);
 	if (err && err != -EOPNOTSUPP)
-- 
2.25.1

