Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B58ED4AD5
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfJKXS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:18:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35755 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfJKXS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:18:27 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so11590664wmi.0
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 16:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S8xmFq96SEfIYB1XdHQdxTajt9IjxgWY/sWpaAxGljI=;
        b=sE1IGK2xqhffVcnrzogPhX4nlPAed4Fo8cwKjrO3VTB5cK8ed68V31Jlf8MSNOYOXj
         D2etA9cSRNVUDC1ljKUc/kDik1fyFygKqc5HNsATQu0WVok44R59E/Zcblwqlsxd33c0
         aLroz/b88/ggIjEmrctdMDeH8wsj0s+kTqU8TJvoM25NDGPvWpNhuJjB3OJssQiLrxQc
         MP+J6l/beu2pimedz2Euq0Tn/vf0HgndMOxJeycv+pJhfhaJt8miE0RUBsi0H7rS+/pk
         HINlaADLVQPHXQ8ezG6G0+koM3EBQfVvPcppRZXOWMwGvlNDc4Zle2KTrKSd+Of3Ce/b
         pnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S8xmFq96SEfIYB1XdHQdxTajt9IjxgWY/sWpaAxGljI=;
        b=ArYGINxAY+2wlqdCMQEnvQ03ksW8lzxYg/bRzK/wkg+/ilsAapDD9u47IU5kdtQM9j
         nM0ZR9ANn1ufFfNLrzIL2f+s/3WwnryXu6Z6PRgGuqliGseMt0cuZyiwgFkTibDRkMFU
         u+phsM+1LLnRzZyCnwx0Z+k/+/9UXOIsP1jD0eDT0ShfFQ21ywugeWP1lbdb94K4Bdm0
         R430a8mBoNSObHZPmi3gao3Of/Q+jIg3l1tTwu+d14BhuzVpfByekqPUOYWQbDYvpeF2
         JJyKoeRaWUUgD1RFNKfqam5CBq9g966g6hgVb+WVZBLeBugD0xmIMIk+AY3mBKoe6SCV
         GpaA==
X-Gm-Message-State: APjAAAWq7jVHqAqAJd1KoyJd3MiA3F+pYJwJlyA9wpOuxgWlCP0QCxdS
        9pOThKktmmzLvGXlytmUlYc=
X-Google-Smtp-Source: APXvYqyoJQh9IbUz4dbA1hdcFEo547Qch3JskNkS4si3TI4LjyBZx6htX0WbWsQSscIpxLErJ7I+lA==
X-Received: by 2002:a7b:cf12:: with SMTP id l18mr5127684wmg.105.1570835905505;
        Fri, 11 Oct 2019 16:18:25 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id 207sm17425853wme.17.2019.10.11.16.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 16:18:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/4] net: dsa: sja1105: Get rid of global declaration of struct ptp_clock_info
Date:   Sat, 12 Oct 2019 02:18:13 +0300
Message-Id: <20191011231816.7888-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011231816.7888-1-olteanv@gmail.com>
References: <20191011231816.7888-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need priv->ptp_caps to hold a structure and not just a pointer,
because we use container_of in the various PTP callbacks.

Therefore, the sja1105_ptp_caps structure declared in the global memory
of the driver serves no further purpose after copying it into
priv->ptp_caps.

So just populate priv->ptp_caps with the needed operations and remove
sja1105_ptp_caps.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 29 +++++++++++++--------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 0df1bbec475a..6b0bfa0444a2 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -344,29 +344,28 @@ static void sja1105_ptp_overflow_check(struct work_struct *work)
 	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
 }
 
-static const struct ptp_clock_info sja1105_ptp_caps = {
-	.owner		= THIS_MODULE,
-	.name		= "SJA1105 PHC",
-	.adjfine	= sja1105_ptp_adjfine,
-	.adjtime	= sja1105_ptp_adjtime,
-	.gettime64	= sja1105_ptp_gettime,
-	.settime64	= sja1105_ptp_settime,
-	.max_adj	= SJA1105_MAX_ADJ_PPB,
-};
-
 int sja1105_ptp_clock_register(struct sja1105_private *priv)
 {
 	struct dsa_switch *ds = priv->ds;
 
 	/* Set up the cycle counter */
 	priv->tstamp_cc = (struct cyclecounter) {
-		.read = sja1105_ptptsclk_read,
-		.mask = CYCLECOUNTER_MASK(64),
-		.shift = SJA1105_CC_SHIFT,
-		.mult = SJA1105_CC_MULT,
+		.read		= sja1105_ptptsclk_read,
+		.mask		= CYCLECOUNTER_MASK(64),
+		.shift		= SJA1105_CC_SHIFT,
+		.mult		= SJA1105_CC_MULT,
 	};
+	priv->ptp_caps = (struct ptp_clock_info) {
+		.owner		= THIS_MODULE,
+		.name		= "SJA1105 PHC",
+		.adjfine	= sja1105_ptp_adjfine,
+		.adjtime	= sja1105_ptp_adjtime,
+		.gettime64	= sja1105_ptp_gettime,
+		.settime64	= sja1105_ptp_settime,
+		.max_adj	= SJA1105_MAX_ADJ_PPB,
+	};
+
 	mutex_init(&priv->ptp_lock);
-	priv->ptp_caps = sja1105_ptp_caps;
 
 	priv->clock = ptp_clock_register(&priv->ptp_caps, ds->dev);
 	if (IS_ERR_OR_NULL(priv->clock))
-- 
2.17.1

