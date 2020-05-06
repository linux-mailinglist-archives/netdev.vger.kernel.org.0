Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55141C7888
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgEFRsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgEFRsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:48:21 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40FDC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 10:48:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z8so3246414wrw.3
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 10:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8UNugCipw+QrgTWdqbm0O80mBvZ2lj7/H0gFxOkgBBQ=;
        b=ql7RMad1yCZLc9uPAOOO8L24yoyiWJ6r1nonj3RI/XAW+nAo7tj/J0X/8DBDHF7m4P
         IXwEOHUXwO7QgO8e/8ZQoqrJFaisYJbvvyt2qyJo4IvtwtWQZQ4UwZpAEAlTBt1Rt/BI
         NyENjaQWnZ4De9S19wv+sgcS4QLusxMBWq6NHQOd7qV+UK7w1XQ96oS8F5UV5jxbpVv7
         Mu84h9z6p2z2PTSId6CCalVry2pEf6Wq+V5nOVRiLYV/arsFL606mUMvd32gk6U9ydTF
         WT2ORm9Kegv6rivxlhNP1/720AK5MtAPVah12B2kzfYXNxukzO7hNQmlTLAowIahpC0p
         ohcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8UNugCipw+QrgTWdqbm0O80mBvZ2lj7/H0gFxOkgBBQ=;
        b=XoAYtOUsVw651np/Wcm0c72pIO6OzyaNJF2vDJ+bbuXGJuORaXp6MDHHmxXPiu4qxl
         vLAfc6YHDbIwS7DN6vkoJxfpI9hQLumPvYDIPcHhdOPgGatdlVpiuDmrRPuSbInwFleA
         c7bybxboJpoo6W2C4Mt22SrxnCkvRuqJGOWRqczZ2GBSn3AYyQVvmKe54axknOZ+Arv4
         WApk+sQodpR8mJh9sPYkO3mpPr4JOkb6+3v8kmmaTnkcyGKdOeENqdjH4O8mE0RHibUK
         AuUCrgRiM6LcmYdJl4dx/2CO3ZlRZZC1X/22r1TLEYLpA5qpJAMtBMxRw8a02UQmzhWw
         s4Qg==
X-Gm-Message-State: AGi0PuZuOv10fg9sqx8ErYy68GQaS5qh+mD4P3gMLxHx4rP2vBponEcE
        PshG0lzbF02gJNooqTBJmeg=
X-Google-Smtp-Source: APiQypJLuuaEx3XC/bKJlFXbox0ZIn8vXOxsfIVri+9lNJLbJqJghwt0rWdHIcGlQwpP0En1vZ8ZsQ==
X-Received: by 2002:adf:fe51:: with SMTP id m17mr10536597wrs.414.1588787299521;
        Wed, 06 May 2020 10:48:19 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id h74sm3402566wrh.76.2020.05.06.10.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 10:48:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        christian.herber@nxp.com, yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: sja1105: the PTP_CLK extts input reacts on both edges
Date:   Wed,  6 May 2020 20:48:13 +0300
Message-Id: <20200506174813.14587-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It looks like the sja1105 external timestamping input is not as generic
as we thought. When fed a signal with 50% duty cycle, it will timestamp
both the rising and the falling edge. When fed a short pulse signal,
only the timestamp of the falling edge will be seen in the PTPSYNCTS
register, because that of the rising edge had been overwritten. So the
moral is: don't feed it short pulse inputs.

Luckily this is not a complete deal breaker, as we can still work with
1 Hz square waves. But the problem is that the extts polling period was
not dimensioned enough for this input signal. If we leave the period at
half a second, we risk losing timestamps due to jitter in the measuring
process. So we need to increase it to 4 times per second.

Also, the very least we can do to inform the user is to deny any other
flags combination than with PTP_RISING_EDGE and PTP_FALLING_EDGE both
set.

Fixes: 747e5eb31d59 ("net: dsa: sja1105: configure the PTP_CLK pin as EXT_TS or PER_OUT")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index a22f8e3fc06b..bc0e47c1dbb9 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -16,14 +16,15 @@
 
 /* PTPSYNCTS has no interrupt or update mechanism, because the intended
  * hardware use case is for the timestamp to be collected synchronously,
- * immediately after the CAS_MASTER SJA1105 switch has triggered a CASSYNC
- * pulse on the PTP_CLK pin. When used as a generic extts source, it needs
- * polling and a comparison with the old value. The polling interval is just
- * the Nyquist rate of a canonical PPS input (e.g. from a GPS module).
- * Anything of higher frequency than 1 Hz will be lost, since there is no
- * timestamp FIFO.
+ * immediately after the CAS_MASTER SJA1105 switch has performed a CASSYNC
+ * one-shot toggle (no return to level) on the PTP_CLK pin. When used as a
+ * generic extts source, the PTPSYNCTS register needs polling and a comparison
+ * with the old value. The polling interval is configured as the Nyquist rate
+ * of a signal with 50% duty cycle and 1Hz frequency, which is sadly all that
+ * this hardware can do (but may be enough for some setups). Anything of higher
+ * frequency than 1 Hz will be lost, since there is no timestamp FIFO.
  */
-#define SJA1105_EXTTS_INTERVAL		(HZ / 2)
+#define SJA1105_EXTTS_INTERVAL		(HZ / 4)
 
 /*            This range is actually +/- SJA1105_MAX_ADJ_PPB
  *            divided by 1000 (ppb -> ppm) and with a 16-bit
@@ -754,7 +755,16 @@ static int sja1105_extts_enable(struct sja1105_private *priv,
 		return -EOPNOTSUPP;
 
 	/* Reject requests with unsupported flags */
-	if (extts->flags)
+	if (extts->flags & ~(PTP_ENABLE_FEATURE |
+			     PTP_RISING_EDGE |
+			     PTP_FALLING_EDGE |
+			     PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	/* We can only enable time stamping on both edges, sadly. */
+	if ((extts->flags & PTP_STRICT_FLAGS) &&
+	    (extts->flags & PTP_ENABLE_FEATURE) &&
+	    (extts->flags & PTP_EXTTS_EDGES) != PTP_EXTTS_EDGES)
 		return -EOPNOTSUPP;
 
 	rc = sja1105_change_ptp_clk_pin_func(priv, PTP_PF_EXTTS);
-- 
2.17.1

