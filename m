Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983E512B00F
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfL0BAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:00:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52719 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfL0BAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:00:01 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so6988909wmc.2
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=V6CIrE44EorfZBGerraLM7M7pPe81QPov31au7gEhew=;
        b=Z8zdoYunXThJpxfMxDDqopRkyA6YPrxjuT3rCo3r6087+zNylPaQx4LGNryXIEVbZk
         yh8RosCWH1It1GdXnxN3z8/IxPkZO759keSJOOcK2ZbbS5iMmUxq47pA41aIY7LPV1Ti
         qnSH+tD63BxJa+lwvM9T26CdXn/7veT8ATxf+Swavzy0L+4yZrBlkR+JDSlRwUZMPGgk
         tKrA9D6cumYMatCiXRwQdPYOSbs/j0clGbB/JAm5juLMdl7u7Xj/ZeVDS1GWhliIuifQ
         CCqvyBq3d9luPAFCJ2u/09v5EMFvmvKzoWh6q3diNrI8PVEQ46txXK8PD/7n5ahx6yoL
         Kx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V6CIrE44EorfZBGerraLM7M7pPe81QPov31au7gEhew=;
        b=C+Jbdczg/Yzyq07312qsX/jUkbYDhySitUOmi6/PFPGbWdHLxplxUxY/FCUXQvOAl8
         /JTlfag1+Ga8Om+4+wu02J7HhiwI7bO86rIgxmYpU05/AYvbyr9mIBU3h6Xwr+ROEGDH
         DSTrfScJ5q6lx0x4oSz4FtAfYbuojyvqppccZw9iY9ezEc8nkh/Fr4hpcLjyGu9NHa24
         cipJmBZSV4dC//xTADP7Ci551GhzSTo/RumAH3uabowq2DHZ7IGG3b4OtOH3wYxq+5q0
         y9xNutd1wRe2XP33OQ3rSJddNQj/jtAa0WldIqnDjX2E5+0SgfzyiGkMm+fW0MzZhvPq
         QdnQ==
X-Gm-Message-State: APjAAAUd7+vQXldjcbnJTkQJwI4TEf5vCEJj17TmUqnn1pDDKjFcLFNB
        ms3IgWdOJTSk62M+DlVMFq8=
X-Google-Smtp-Source: APXvYqwdf6cc2QK2vDQpl9xCmNtONSSqN1ySqjKfvG8KVUauFPFcZbjyoNkhFb2hfustaYJLm4guWQ==
X-Received: by 2002:a1c:20d6:: with SMTP id g205mr16412770wmg.38.1577408399607;
        Thu, 26 Dec 2019 16:59:59 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id u13sm10090553wmd.36.2019.12.26.16.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 16:59:59 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: Take PTP egress timestamp by port, not mgmt slot
Date:   Fri, 27 Dec 2019 02:59:54 +0200
Message-Id: <20191227005954.25268-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PTP egress timestamp N must be captured from register PTPEGR_TS[n],
where n = 2 * PORT + TSREG. There are 10 PTPEGR_TS registers, 2 per
port. We are only using TSREG=0.

As opposed to the management slots, which are 4 in number
(SJA1105_NUM_PORTS, minus the CPU port). Any management frame (which
includes PTP frames) can be sent to any non-CPU port through any
management slot. When the CPU port is not the last port (#4), there will
be a mismatch between the slot and the port number.

Luckily, the only mainline occurrence with this switch
(arch/arm/boot/dts/ls1021a-tsn.dts) does have the CPU port as #4, so the
issue did not manifest itself thus far.

Fixes: 47ed985e97f5 ("net: dsa: sja1105: Add logic for TX timestamping")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
This patch will not apply to stable trees due to refactoring commit
a9d6ed7a8bd0 ("net: dsa: sja1105: Move PTP data to its own private
structure").

 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3e9bd205d91a..73649c99d5a5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1952,7 +1952,7 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 	if (!clone)
 		goto out;
 
-	sja1105_ptp_txtstamp_skb(ds, slot, clone);
+	sja1105_ptp_txtstamp_skb(ds, port, clone);
 
 out:
 	mutex_unlock(&priv->mgmt_lock);
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 68d8c3440c46..56f18ff60a41 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -655,7 +655,7 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 	ptp_data->clock = NULL;
 }
 
-void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
+void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int port,
 			      struct sk_buff *skb)
 {
 	struct sja1105_private *priv = ds->priv;
@@ -673,7 +673,7 @@ void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
 		goto out;
 	}
 
-	rc = sja1105_ptpegr_ts_poll(ds, slot, &ts);
+	rc = sja1105_ptpegr_ts_poll(ds, port, &ts);
 	if (rc < 0) {
 		dev_err(ds->dev, "timed out polling for tstamp\n");
 		kfree_skb(skb);
-- 
2.17.1

