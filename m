Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D871F8AC4
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 22:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgFNUyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 16:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgFNUyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 16:54:24 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE272C03E97C;
        Sun, 14 Jun 2020 13:54:23 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n24so15297735ejd.0;
        Sun, 14 Jun 2020 13:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tgWmDiNQdaMJHDiSYz9iwVWHmMa2MnorA3k8D09lAhw=;
        b=TSwpfReSaIF4z1dNW/MPfEH3d2mft/xewUwQlCZbnZjgyZu2sBMlSOBs4QcfXnZ1Ph
         60QXSBdL9Ju0/27De+oMUYYOYJmZOAhh3QNSh1wDIB90fO5rHzzTpTE8aRSRZvU9KQTc
         XmJXHTSnu4qw05ma9uzOM7zTSHKLltzorWEMaXGKhdU2jTvsDtki9QAFoOYkme5Ne6Ko
         aN3Z7sVGrRZvegdQNELrBy8H1pI+cnM7GZ3byYbIhOkBYuWIZUa1vsavYcxcrJf0DDv7
         HYtHyfCVwPDrdxXFORYuBVVql4ygjGTqmavC19ycUkZtZ8DVt6rFiyDYDdh0lKMbiyhi
         Oyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tgWmDiNQdaMJHDiSYz9iwVWHmMa2MnorA3k8D09lAhw=;
        b=GQAaqQI/mRhJD8mkX4jTklD3IeThG/+vVP359xigg9ESHattJobZ3S1WOdkLpBspz4
         nALoKmfUHg50qU8om9sXkkNNrM6RexfQH44CuCHL2wQK5mGjhYA+s+Jk5RngSufQqgV7
         geE+c7cpa23oLVVpL3WAgUPhPSAUYPmOoxGOTMLAWFwU9h0JSxBxVw1XkXjq/Ge7cK1F
         tkA0pDAEMFOoDs3JQIcFgJ7J1tjjHXVtVsvo0Euv/FIwSCcdu9JM8Sfl1sHKwdnn2Lnq
         7mL8vP6Tx3ZvMFRthebaFniUmgyKRUcSZK5aA+f6ZM2pXAcI7H4j13+Wk8RmTfWNcw+r
         0uKQ==
X-Gm-Message-State: AOAM5323cYkHBPqnaU+j+BZsCjsnkGjFyPZqvxfTOeArGZKWXeAxa/Z4
        t8ufzXwafI30zMGRxZheh8f7DCCY
X-Google-Smtp-Source: ABdhPJyI0Ife0VA9liuc0IpiUy/Ri6tXkbWcxLylTVYh28H70Dv6sZoyf+UiqjfyGF5+uIVa1ctLqA==
X-Received: by 2002:a17:906:fc13:: with SMTP id ov19mr22331139ejb.212.1592168062154;
        Sun, 14 Jun 2020 13:54:22 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id m23sm7108163edr.86.2020.06.14.13.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 13:54:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, vinicius.gomes@intel.com
Subject: [PATCH net] net: dsa: sja1105: fix PTP timestamping with large tc-taprio cycles
Date:   Sun, 14 Jun 2020 23:54:09 +0300
Message-Id: <20200614205409.1580736-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It isn't actually described clearly at all in UM10944.pdf, but on TX of
a management frame (such as PTP), this needs to happen:

- The destination MAC address (i.e. 01-80-c2-00-00-0e), along with the
  desired destination port, need to be installed in one of the 4
  management slots of the switch, over SPI.
- The host can poll over SPI for that management slot's ENFPORT field.
  That gets unset when the switch has matched the slot to the frame.

And therein lies the problem. ENFPORT does not mean that the packet has
been transmitted. Just that it has been received over the CPU port, and
that the mgmt slot is yet again available.

This is relevant because of what we are doing in sja1105_ptp_txtstamp_skb,
which is called right after sja1105_mgmt_xmit. We are in a hard
real-time deadline, since the hardware only gives us 24 bits of TX
timestamp, so we need to read the full PTP clock to reconstruct it.
Because we're in a hurry (in an attempt to make sure that we have a full
64-bit PTP time which is as close as possible to the actual transmission
time of the frame, to avoid 24-bit wraparounds), first we read the PTP
clock, then we poll for the TX timestamp to become available.

But of course, we don't know for sure that the frame has been
transmitted when we read the full PTP clock. We had assumed that ENFPORT
means it has, but the assumption is incorrect. And while in most
real-life scenarios this has never been caught due to software delays,
nowhere is this fact more obvious than with a tc-taprio offload, where
PTP traffic gets a small timeslot very rarely (example: 1 packet per 10
ms). In that case, we will be reading the PTP clock for timestamp
reconstruction too early (before the packet has been transmitted), and
this renders the reconstruction procedure incorrect (see the assumptions
described in the comments found on function sja1105_tstamp_reconstruct).
So the PTP TX timestamps will be off by 1<<24 clock ticks, or 135 ms
(1 tick is 8 ns).

So fix this case of premature optimization by simply reordering the
sja1105_ptpegr_ts_poll and the sja1105_ptpclkval_read function calls. It
turns out that in practice, the 135 ms hard deadline for PTP timestamp
wraparound is not so hard, since even the most bandwidth-intensive PTP
profiles, such as 802.1AS-2011, have a sync frame interval of 125 ms.
So if we couldn't deliver a timestamp in 135 ms (which we can), we're
toast and have much bigger problems anyway.

Fixes: 47ed985e97f5 ("net: dsa: sja1105: Add logic for TX timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index bc0e47c1dbb9..177134596458 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -891,16 +891,16 @@ void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int port,
 
 	mutex_lock(&ptp_data->lock);
 
-	rc = sja1105_ptpclkval_read(priv, &ticks, NULL);
+	rc = sja1105_ptpegr_ts_poll(ds, port, &ts);
 	if (rc < 0) {
-		dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
+		dev_err(ds->dev, "timed out polling for tstamp\n");
 		kfree_skb(skb);
 		goto out;
 	}
 
-	rc = sja1105_ptpegr_ts_poll(ds, port, &ts);
+	rc = sja1105_ptpclkval_read(priv, &ticks, NULL);
 	if (rc < 0) {
-		dev_err(ds->dev, "timed out polling for tstamp\n");
+		dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
 		kfree_skb(skb);
 		goto out;
 	}
-- 
2.25.1

