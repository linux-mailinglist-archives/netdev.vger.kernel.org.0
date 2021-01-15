Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B78A2F7068
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731793AbhAOCNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbhAOCNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:13:08 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38EFC0613D6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:53 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ga15so11184329ejb.4
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3VVgo68tC1oCMu2FL88+RF6v7xXDh7YNpS0EFm1/7og=;
        b=VMqV5A8PkFEeFpzDDtDNBAG2pgayHNffK6TJpIstGWCjNPPEOaa0l7rQEnNiqRVjrs
         Y/vOYjkxxKFD7rnSsUf7FjgmYcQj/plqECcMTuZeL8Ubp/4RKi3cZEzh01Qp/YmJXr4W
         +Okmb5kN2CDcJd+6QAjAgO/Tnakh2E7fU0U9kGLvcoFyixKkUR+6KRyzYr4yd1g0bY9J
         zU4YlAocI9sRuyQLQY3kkNIBpA5UF5Q5vmo/tTUc6oEvp9PfRzvgTbIHMQBRbhzoC5+N
         Q7nE8ou0nputmFvKfYVIF/b2t4tevS0fAK0a1rPZBOE/X2mM83JWXYLTb7X1JTV0vWQb
         YNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3VVgo68tC1oCMu2FL88+RF6v7xXDh7YNpS0EFm1/7og=;
        b=eDu7KkgAfoHOMzrwwahUw+xgJxcacDeql0UGK+2bS28Ip0GBZTEf+MjU96UgCVsFmm
         o24PgwhLKFjvWlzDT/z8GoDq9vq7jepzurigXZVFD67PhcKtRn1ziWydwbuOelB3MnsA
         AqVSCXIaXT4/pAevMnrK3fKY2RBPN4D8uq4hu30HQ2ZI/NRCecIoJq/hG9e2Ceu+x1s7
         zLvHDiVyfHO3STq0X8HCabcyPdzIACYJdISm1XaWmvUoeQ8fCSQhjnCfO8IdwxOyCaWw
         UEdE74jFACaPEf0nEHSenSRlBGs5nn1RRi/HrsU8h8DatO20K+GvZ8sG09QM6Sk+188X
         yRVQ==
X-Gm-Message-State: AOAM531v5kYMqm0rVSCvyFxT+9V5tpU08IO2+2Kfzl+Y5L5HiewGmnbU
        E5YSbaTCu47D9Kk+009DGgA=
X-Google-Smtp-Source: ABdhPJw1sjdUM7tnoEb2YsydAj7WQUdL/5HfAqc2YbkU/YPQvGZ190f5tRFD4cocLJNU5K7wMa5bAQ==
X-Received: by 2002:a17:906:6448:: with SMTP id l8mr7553873ejn.357.1610676712565;
        Thu, 14 Jan 2021 18:11:52 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id oq27sm2596494ejb.108.2021.01.14.18.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:11:52 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 05/10] net: dsa: felix: perform teardown in reverse order of setup
Date:   Fri, 15 Jan 2021 04:11:15 +0200
Message-Id: <20210115021120.3055988-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115021120.3055988-1-olteanv@gmail.com>
References: <20210115021120.3055988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In general it is desirable that cleanup is the reverse process of setup.
In this case I am not seeing any particular issue, but with the
introduction of devlink-sb for felix, a non-obvious decision had to be
made as to where to put its cleanup method. When there's a convention in
place, that decision becomes obvious.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
Removed the unnecessary if condition.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 532e038e8012..3ec06bdd175a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -610,14 +610,14 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	if (felix->info->mdio_bus_free)
-		felix->info->mdio_bus_free(ocelot);
+	ocelot_deinit_timestamp(ocelot);
+	ocelot_deinit(ocelot);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++)
 		ocelot_deinit_port(ocelot, port);
-	ocelot_deinit_timestamp(ocelot);
-	/* stop workqueue thread */
-	ocelot_deinit(ocelot);
+
+	if (felix->info->mdio_bus_free)
+		felix->info->mdio_bus_free(ocelot);
 }
 
 static int felix_hwtstamp_get(struct dsa_switch *ds, int port,
-- 
2.25.1

