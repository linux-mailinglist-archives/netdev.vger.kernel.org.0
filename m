Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9803938E736
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhEXNQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhEXNQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0812C06138D
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:48 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y7so14382773eda.2
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sejg8AMIZ1p9v/thwWFpkqzjMT34eML1F1ck7fvyRks=;
        b=RmjOaJcASyKei0TkBp0zuG14JICF3zPfilffnOKijdCr5KPk8yVBHs1oug0y7hlIm3
         lCM5QOG9zopZ5yLN2c4hhGyhS64jJF1YCV5E677gRBIbS3ZM6rOJoD8BOE642OpGISFc
         y3mD2PHQxvlyQu/PMk6RbpCUwscJWP4W8tEVvzBe2KFNcREv0muDo8e0WdVUKlM4nhA4
         caiCVgRUoDjtZKQ8zug7Yq26IlkDBG41Uj+WhzvcyFO2ASDQ1jIYR/wJdngTfGRvI2PS
         lpJcOSKyhfelmrwwNgWanTNy0NDkf3tdie93gcbFxONmD+9RGKJMYfCc/+9BDeddkV2m
         J/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sejg8AMIZ1p9v/thwWFpkqzjMT34eML1F1ck7fvyRks=;
        b=kClW+OuuRz1DWOx6KpnTykN9XZwmdsxJ8jEAap1zVTktQgHI7wxmdsEwnHDYIq7U7T
         6Hy0HxmkG5zkFyJJrtRuArAAlhZa6Gp6VPNx3rPjlK8e3OwKFuvukjKCJAOJL9gGx/b7
         POEioOpQFYBvQbyNmCMq6JGXAxXzVduPZ20+hSc2yGDPMeVXZsjSbz34sNoQm2yPTUIq
         g1Aib6QMuXUPN/P6XajljC14WZ22S38ZtnJ1dpMpOJGy8bHZRKvHiknq5xcIef25TNSi
         SjbgYP4gudRES4poPOcIVw7FAFfUclaQA3gIUywNKCkg6w2H9Lngtap9CeYo44WBkKAi
         UB9Q==
X-Gm-Message-State: AOAM532xKd+kg+EOWIvm38H0/F/bbE7rXEbbIsz5Wc6mj7uQLFMJ6vom
        Yut9BaDd5SCf4ZOCYYl2LAk=
X-Google-Smtp-Source: ABdhPJx7hdPnDl/Yoiu7E0sFJ9cWDaMZY0AQCzMkNoHWInYzbQaqHFMipj3V6EwRZvDGezURaD7xmw==
X-Received: by 2002:a50:d589:: with SMTP id v9mr26338104edi.126.1621862087486;
        Mon, 24 May 2021 06:14:47 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 6/9] net: dsa: sja1105: dynamically choose the number of static config table entries
Date:   Mon, 24 May 2021 16:14:18 +0300
Message-Id: <20210524131421.1030789-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Due to the fact that the port count is different, some static config
tables have a different number of elements in SJA1105 compared to
SJA1110. Such an example is the L2 Policing table, which has 45 entries
in SJA1105 (one per port x traffic class, and one broadcast policer per
port) and 110 entries in SJA1110 (one per port x traffic class, one
broadcast and one multicast policer per port).

Similarly, the MAC Configuration Table, the L2 Forwarding table, all
have a different number of elements simply because the port count is
different, and although this can be accounted for by looking at
ds->ports, the policing table can't because of the presence of the extra
multicast policers.

The common denominator for the static config initializers for these
tables is that they must set up all the entries within that table.
So the simplest way to account for these differences in a uniform manner
is to look at struct sja1105_table_ops::max_entry_count. For the sake of
uniformity, this patch makes that change also for tables whose number of
elements did not change in SJA1110, like the xMII Mode Parameters, the
L2 Lookup Parameters, General Parameters, AVB Parameters (all of these
are singleton tables with a single entry).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 32 +++++++++++++-------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1d2fcfa0f48f..937cbdb89686 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -118,12 +118,12 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(ds->num_ports,
+	table->entries = kcalloc(table->ops->max_entry_count,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
-	table->entry_count = ds->num_ports;
+	table->entry_count = table->ops->max_entry_count;
 
 	mac = table->entries;
 
@@ -174,13 +174,13 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(SJA1105_MAX_XMII_PARAMS_COUNT,
+	table->entries = kcalloc(table->ops->max_entry_count,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
 	/* Override table based on PHYLINK DT bindings */
-	table->entry_count = SJA1105_MAX_XMII_PARAMS_COUNT;
+	table->entry_count = table->ops->max_entry_count;
 
 	mii = table->entries;
 
@@ -322,12 +322,12 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(SJA1105_MAX_L2_LOOKUP_PARAMS_COUNT,
+	table->entries = kcalloc(table->ops->max_entry_count,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
-	table->entry_count = SJA1105_MAX_L2_LOOKUP_PARAMS_COUNT;
+	table->entry_count = table->ops->max_entry_count;
 
 	/* This table only has a single entry */
 	((struct sja1105_l2_lookup_params_entry *)table->entries)[0] =
@@ -414,12 +414,12 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(SJA1105_MAX_L2_FORWARDING_COUNT,
+	table->entries = kcalloc(table->ops->max_entry_count,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
-	table->entry_count = SJA1105_MAX_L2_FORWARDING_COUNT;
+	table->entry_count = table->ops->max_entry_count;
 
 	l2fwd = table->entries;
 
@@ -484,12 +484,12 @@ static int sja1105_init_l2_forwarding_params(struct sja1105_private *priv)
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
+	table->entries = kcalloc(table->ops->max_entry_count,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
-	table->entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT;
+	table->entry_count = table->ops->max_entry_count;
 
 	/* This table only has a single entry */
 	((struct sja1105_l2_forwarding_params_entry *)table->entries)[0] =
@@ -597,12 +597,12 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(SJA1105_MAX_GENERAL_PARAMS_COUNT,
+	table->entries = kcalloc(table->ops->max_entry_count,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
-	table->entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT;
+	table->entry_count = table->ops->max_entry_count;
 
 	/* This table only has a single entry */
 	((struct sja1105_general_params_entry *)table->entries)[0] =
@@ -624,12 +624,12 @@ static int sja1105_init_avb_params(struct sja1105_private *priv)
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(SJA1105_MAX_AVB_PARAMS_COUNT,
+	table->entries = kcalloc(table->ops->max_entry_count,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
-	table->entry_count = SJA1105_MAX_AVB_PARAMS_COUNT;
+	table->entry_count = table->ops->max_entry_count;
 
 	avb = table->entries;
 
@@ -708,12 +708,12 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(SJA1105_MAX_L2_POLICING_COUNT,
+	table->entries = kcalloc(table->ops->max_entry_count,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
-	table->entry_count = SJA1105_MAX_L2_POLICING_COUNT;
+	table->entry_count = table->ops->max_entry_count;
 
 	policing = table->entries;
 
-- 
2.25.1

