Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85E5AE1EF
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 03:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391073AbfIJBfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 21:35:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39581 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732352AbfIJBfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 21:35:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so16730292wra.6
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 18:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kC3yVDL189QEZzy6zbZgG2YAiTtzildgcNdK0bFxPpY=;
        b=uYJE0KvGydzc+TV2k9XuL0qZwTpfmtxB796hKHzQqhyo+tPn/bnOPIOufVDqLtKMoE
         Ui5NRi+r1z3V/LnwDCJL1w1YyXtxnhP83Jq9jksGeZjmwMVdgyVDjYymg+1gaP32pTkY
         YomDGG4ER6QHGFzeSoCKfWyOfYwUW0Y5mgNMD/8npmSbY1M4PjiGbMj26L79fiU0jYe+
         mXP3HufwVO8ccOZ91ahf+DcJQ4iWpF1gMVoHiZ6tvtQhycDwEEx4tQhZvUeuz+G90DYn
         /Osl0BvDtxOs642nK3N1QRaaHXRX0oiETunos22lepXK51+YrUoHKWGZvn1SuMfcI47S
         aKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kC3yVDL189QEZzy6zbZgG2YAiTtzildgcNdK0bFxPpY=;
        b=ed8VDWZjRWZN0V2ucAbejEGiuRlFr8V81SwSFk4zPR3xVgbF1gjPy1TGUgFukGt5cg
         n+WNr/ejDqUjqqyPc8ZQD795G6nx1uf8iLgT9cUuS8cz4qvQdaLE6Lh3JE2kSfcw1nTM
         CYI1ck7mCBvj4/GKBN4YCXbuD1iskzPXUc3puxPoDELhtXwJIEAYcE4gOBOUG9eGSbrw
         6jL0IzY9L9IcP/W7VNBJPOwVPI8jK7yWtYeo3uH8NTaQXrDP3vdKceGnvA27B5/dcoSF
         qo9cZYqLjtBHUTyh/PdEyl/hE68h5E6mCAHucSt6vn0GhYsKzr0lLb4DQVU1q53QpFyy
         IOCQ==
X-Gm-Message-State: APjAAAXMpDcl1rtlj625H9Yjf6986FvmBHFfSbLaPCJBZnh74eZiFnY3
        qpYbQFumk4jwYtim7evw+iQ=
X-Google-Smtp-Source: APXvYqyd//G1rMSo/j6po2MKuGEuWiOHoa4oP8o1DpIsSaRzVVI5LJjz304+H8WCcdFYwFTc7Nax6Q==
X-Received: by 2002:a5d:62c1:: with SMTP id o1mr22969998wrv.231.1568079339160;
        Mon, 09 Sep 2019 18:35:39 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id b1sm1254597wmj.4.2019.09.09.18.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 18:35:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 1/7] net: dsa: sja1105: Get rid of global declaration of struct ptp_clock_info
Date:   Tue, 10 Sep 2019 04:34:55 +0300
Message-Id: <20190910013501.3262-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190910013501.3262-1-olteanv@gmail.com>
References: <20190910013501.3262-1-olteanv@gmail.com>
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
index d8e8dd59f3d1..d0c93d0449dc 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -347,29 +347,28 @@ static void sja1105_ptp_overflow_check(struct work_struct *work)
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

