Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A22C190175
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgCWW7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:59:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39576 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWW7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:59:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id p10so6835065wrt.6
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 15:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cJVeA0c4UffodJOvtmOyq5ZGMOGtO/VdPZNQW2YGeyI=;
        b=iQ0hoCusyRoaozLS3vKv6YklZuSS96TtNB8CoEQwypBdRXjpnnTlmGSz9NiVsVszbt
         r8YoEHTJHUkcc+kzMn6SH1lRcr57v97NCNgdSHuG9dgrfZi245tQppH0/TSfrOfqO6OR
         byPQuRRLOt7dq9ybfvKfGlnMWPD5nrtQXDn14AaObOym6Qk/ErasaNcVVTLOynGrY7KF
         e+6X7GYsPL2xM7QAP3Gh7+Qdw9OF/7SrkgrvXp8qxA7Win0LFUyyC9SbQ9Ctz2N6PLCa
         4tjGIZOikfHiK/Z6gG0wag4CfWZl7xW0bhlhlXEPcRktE2xr6oMrT8Y8v2HGqo+RD/lC
         ok0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cJVeA0c4UffodJOvtmOyq5ZGMOGtO/VdPZNQW2YGeyI=;
        b=P+elcH0DLe/IuoKjc5hkJoK65GKL0N6fFUnPf2wK7Rv+McmDRqj7heoUKSXjLskc+I
         7V7AZYO/jUZB0U2XYlSTGzWO6v+rD/S6At90pDxnX7v0cgLPEd8FGnT+RlrhF96+PaUk
         OisPQHR+7XFLHXqVtJcGmB5EuavThh5dS7LEGtvNUbPIDqwviCjquaC1O0CRsdVCrz6y
         m+52Qc8CWR3qjGn8NHD8n6piovspFcLHfosw8GkOf/yz41V5ldHViGTx2DQ+0NaVb30T
         vDk888C219pbXoyqnDyQNTbppgQNQK8kO5xiYMgLXXo4Y/nq+K54Z73hJfnNESYZAtX2
         CsSw==
X-Gm-Message-State: ANhLgQ09A1KW8gCFpuzPHeK/9FpEWkD7ZWHGrsxHc3Lqy1ivTyF/zpcc
        egrgWHfmuWA2kHozrIc1afdVUnpe9ktF+Q==
X-Google-Smtp-Source: ADFU+vvTQk8xIIXOrNz1tGjqnvYwLe80I4t5sHTvk8wVd4WIe7uhvYo5MfCPM9FM4iH8kC73lah5+w==
X-Received: by 2002:adf:84a3:: with SMTP id 32mr27645382wrg.378.1585004373393;
        Mon, 23 Mar 2020 15:59:33 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id r3sm26332912wrm.35.2020.03.23.15.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 15:59:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        christian.herber@nxp.com, yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: dsa: sja1105: make future_base_time a common helper
Date:   Tue, 24 Mar 2020 00:59:22 +0200
Message-Id: <20200323225924.14347-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323225924.14347-1-olteanv@gmail.com>
References: <20200323225924.14347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Because the PTP_CLK pin starts toggling only at a time higher than the
current PTP clock, this helper from the time-aware shaper code comes in
handy here as well. We'll use it to transform generic user input for the
perout request into valid input for the sja1105 hardware.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.h | 27 +++++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.c | 27 ---------------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 6f4a19eec709..119e345b40fc 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -21,6 +21,33 @@ static inline s64 sja1105_ticks_to_ns(s64 ticks)
 	return ticks * SJA1105_TICK_NS;
 }
 
+/* Calculate the first base_time in the future that satisfies this
+ * relationship:
+ *
+ * future_base_time = base_time + N x cycle_time >= now, or
+ *
+ *      now - base_time
+ * N >= ---------------
+ *         cycle_time
+ *
+ * Because N is an integer, the ceiling value of the above "a / b" ratio
+ * is in fact precisely the floor value of "(a + b - 1) / b", which is
+ * easier to calculate only having integer division tools.
+ */
+static inline s64 future_base_time(s64 base_time, s64 cycle_time, s64 now)
+{
+	s64 a, b, n;
+
+	if (base_time >= now)
+		return base_time;
+
+	a = now - base_time;
+	b = cycle_time;
+	n = div_s64(a + b - 1, b);
+
+	return base_time + n * cycle_time;
+}
+
 struct sja1105_ptp_cmd {
 	u64 ptpstrtsch;		/* start schedule */
 	u64 ptpstopsch;		/* stop schedule */
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index fa6750d973d7..77e547b4cd89 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -28,33 +28,6 @@ static s64 sja1105_delta_to_ns(s64 delta)
 	return delta * 200;
 }
 
-/* Calculate the first base_time in the future that satisfies this
- * relationship:
- *
- * future_base_time = base_time + N x cycle_time >= now, or
- *
- *      now - base_time
- * N >= ---------------
- *         cycle_time
- *
- * Because N is an integer, the ceiling value of the above "a / b" ratio
- * is in fact precisely the floor value of "(a + b - 1) / b", which is
- * easier to calculate only having integer division tools.
- */
-static s64 future_base_time(s64 base_time, s64 cycle_time, s64 now)
-{
-	s64 a, b, n;
-
-	if (base_time >= now)
-		return base_time;
-
-	a = now - base_time;
-	b = cycle_time;
-	n = div_s64(a + b - 1, b);
-
-	return base_time + n * cycle_time;
-}
-
 static int sja1105_tas_set_runtime_params(struct sja1105_private *priv)
 {
 	struct sja1105_tas_data *tas_data = &priv->tas_data;
-- 
2.17.1

