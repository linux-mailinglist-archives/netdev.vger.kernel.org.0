Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA65324EA
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfFBVN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:13:26 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35311 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfFBVNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:13:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so6133596wml.0
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qhh+ZRi0m7Fl7rphx81TRgM+7smPSvb6Eoiou0mpCzc=;
        b=f+APhyfIKJwnaCmUORIt5Suw5x4RmF1mICmsppKPlNpfAwsnxxjiL5ppgwOjorgcW7
         gjumsbdseacbIfHcPw6/KYk7DDQfkqc17+HBpvxasWw3e1ffas+ztn5o4H+YhNdQJOSm
         xuKTr/PYIcAfi032VpYczzmGyS6+lj9V5J2qFq/N5kL5w46xJfAPAcLGHPgy235noDUU
         aZ6/qf6WjdoXaWByO+j1ATUOjB7pkZf09LLHseSaQeXepKlhcB/aJkIyPRIH+z0SuTq4
         ISkSFnLf2qFlNqJzAATfegf6O2rgU8YM4dEYOs1VVAdKfJ2MmuFa4KrH69xEp5ZJHL1m
         IJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qhh+ZRi0m7Fl7rphx81TRgM+7smPSvb6Eoiou0mpCzc=;
        b=BY1Ic2iwCwCS2jb7ZA5NK7l1V8roKPmVVPwofNMc65Cdipz3X5htawClg54Ev+9noC
         g5SFldYJqPoERdCt+7qoi8/Hj/Qw2m1l29vGd9odS5faDjKt60gvrjggbRvVidGdcYvX
         lr+4MG2tDvxeyncvZ5n8sc2q50javV8ipPoq2ODo3DnJm/xys06W1BVsKXIVEvciUKqH
         /dPmxXpRrTkMV219J2TFbWYKxPzk6I3lxJesQ1kamjK597RGiLShvDFhwLcgmIn+LCF/
         t09hmtRaR4ikAAmB+zhkQ3bvYPgGaHepK+QXmzYq8ck+9NE+osDqvzBrmlax8v4IqYo9
         Lpjg==
X-Gm-Message-State: APjAAAX69u55sbVb/TEWCnPrfOTNcZuoIXrW8g9OtO5RCFYO5JnwS/Dt
        VFzqhSOKqp2MpReTkem6yLo=
X-Google-Smtp-Source: APXvYqxX6OU8R9xlcleuf4V7IY1l01+zVHyJw7v8qdKXRdMFCKddZpSG1C3rNT8GmQNDyO5x/5b3rQ==
X-Received: by 2002:a7b:c003:: with SMTP id c3mr42754wmb.157.1559510003574;
        Sun, 02 Jun 2019 14:13:23 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id q11sm9548193wmc.15.2019.06.02.14.13.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:13:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 07/11] net: dsa: sja1105: Make dynamic_config_read return -ENOENT if not found
Date:   Mon,  3 Jun 2019 00:11:59 +0300
Message-Id: <20190602211203.17773-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602211203.17773-1-olteanv@gmail.com>
References: <20190602211203.17773-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conceptually, if an entry is not found in the requested hardware table,
it is not an invalid request - so change the error returned
appropriately.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 2 +-
 drivers/net/dsa/sja1105/sja1105_main.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 7db1f8258287..02a67df4437e 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -502,7 +502,7 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 		 * So don't error out in that case.
 		 */
 		if (!cmd.valident && blk_idx != BLK_IDX_MGMT_ROUTE)
-			return -EINVAL;
+			return -ENOENT;
 		cpu_relax();
 	} while (cmd.valid && --retries);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c78d2def52f1..dc9803efdbbd 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -948,7 +948,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
 						 i, &l2_lookup);
 		/* No fdb entry at i, not an issue */
-		if (rc == -EINVAL)
+		if (rc == -ENOENT)
 			continue;
 		if (rc) {
 			dev_err(dev, "Failed to dump FDB: %d\n", rc);
-- 
2.17.1

