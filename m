Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532FB3A684D
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhFNNrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbhFNNrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:47:07 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578AEC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:45:04 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id g20so16886085ejt.0
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=klcxm9Fxa3xtqDLM+t/LhJnL0HzSyyWp/UHyUzDlKMw=;
        b=I9BNYQiqZacDNStrUawl1/9YT6+BmbN98U19u87LBzgvIzMZZXri7YiEqaAjQH8X3s
         0vAXxPpvXXeSv/LdHQNjOERP7rLQI64o7UuDtLHxzRLTU0W0JhVrKRrvZ3cw1GCqKvL2
         g4jmbxu+L8wbxpzNc/e0YtRuBmvoV6/8EoqD15ckUiHrADdA9CP2mfy6zcAlNZxRZoKj
         U1ex00nrLoFqG9PknB9TNxzgzaVKyzyG4qZBZKPYtYt7y66CQpNqaresymZP+1h9VxNk
         DeUjGy0NsTz2/5gLNBjEZujx46eZqlfrCclUA2hywQW+mbdg+EBT//MYoPMPcRRaALWo
         o5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=klcxm9Fxa3xtqDLM+t/LhJnL0HzSyyWp/UHyUzDlKMw=;
        b=Hvhat6tGHc9ysd5Od5Ak9u5JtAA7rhzTYmt7lrVcjsbZDUv7EbVExfQ8Mf6v79fN8s
         +qvsMxp5M56LWuG8p2Xd2YkSDSWrvVg20pVz9QmVT4DPW4QtGEPatv5p8svqDZSSGFk7
         A/u7jwKF+YBeEnt/IpVBJJIQ0IcPeOgNv1SNQjJyq444mNHpcRcpmM+dxwBNUFG0UFpg
         XtAgo4p1SgJONb7GlbZm+U6PHE8g8XRTz4d7+ikFwtHxQA+X0YIimsvMnnrWBF1LJjKz
         alFs8IMdf5pWBPmFviPEALTVm5aW78pIAg2w9nSldCfDT2LHzg/1CGDBCF86udaq46Q5
         kQQw==
X-Gm-Message-State: AOAM5303yqGTd+jWHYlUzyj3Kht4IHNYlWyoScceC9rp6NMvKyvP2gET
        OS6cFuNaJ3eIcajfpepG+ng=
X-Google-Smtp-Source: ABdhPJz5cTem4QZSkMD3r3iAQErJtXcPyTiKVkDb/Bb5U0wwIu00UnLLdBdzU4GNeSqUeqQ0mVr6Cw==
X-Received: by 2002:a17:906:4e91:: with SMTP id v17mr15767757eju.119.1623678302985;
        Mon, 14 Jun 2021 06:45:02 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id q20sm7626891ejb.71.2021.06.14.06.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:45:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 net-next 3/4] net: phy: nxp-c45-tja11xx: fix potential RX timestamp wraparound
Date:   Mon, 14 Jun 2021 16:44:40 +0300
Message-Id: <20210614134441.497008-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614134441.497008-1-olteanv@gmail.com>
References: <20210614134441.497008-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The reconstruction procedure for partial timestamps reads the current
PTP time and fills in the low 2 bits of the second portion, as well as
the nanoseconds portion, from the actual hardware packet timestamp.
Critically, the reconstruction procedure works because it assumes that
the current PTP time is strictly larger than the hardware timestamp was:
it detects a 2-bit wraparound of the 'seconds' portion by checking whether
the 'seconds' portion of the partial hardware timestamp is larger than
the 'seconds' portion of the current time. That can only happen if the
hardware timestamp was captured by the PHY during the last phase of a
'modulo 4 seconds' interval, and the current PTP time was read by the
driver during the initial phase of the next 'modulo 4 seconds' interval.

The partial RX timestamps are added to priv->rx_queue in
nxp_c45_rxtstamp() and they are processed potentially in parallel by the
aux worker thread in nxp_c45_do_aux_work(). This means that it is
possible for nxp_c45_do_aux_work() to process more than one RX timestamp
during the same schedule.

There is one premature optimization that will cause issues: for RX
timestamping, the driver reads the current time only once, and it uses
that to reconstruct all PTP RX timestamps in the queue. For the second
and later timestamps, this will be an issue if we are processing two RX
timestamps which are to the left and to the right, respectively, of a
4-bit wraparound of the 'seconds' portion of the PTP time, and the
current PTP time is also pre-wraparound.

 0.000000000        4.000000000        8.000000000        12.000000000
 |..................|..................|..................|............>
                 ^ ^ ^ ^                                            time
                 | | | |
                 | | | process hwts 1 and hwts 2
                 | | |
                 | | hwts 2
                 | |
                 | read current PTP time
                 |
                 hwts 1

What will happen in that case is that hwts 2 (post-wraparound) will use
a stale current PTP time that is pre-wraparound.
But nxp_c45_reconstruct_ts will not detect this condition, because it is
not coded up for it, so it will reconstruct hwts 2 with a current time
from the previous 4 second interval (i.e. 0.something instead of
4.something).

This is solvable by making sure that the full 64-bit current time is
always read after the PHY has taken the partial RX timestamp. We do this
by reading the current PTP time for every timestamp in the RX queue.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
v2->v3: none
v1->v2: none

 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index afdcd6772b1d..7eac58b78c53 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -427,8 +427,8 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 		nxp_c45_process_txts(priv, &hwts);
 	}
 
-	nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
 	while ((skb = skb_dequeue(&priv->rx_queue)) != NULL) {
+		nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
 		ts_raw = __be32_to_cpu(NXP_C45_SKB_CB(skb)->header->reserved2);
 		hwts.sec = ts_raw >> 30;
 		hwts.nsec = ts_raw & GENMASK(29, 0);
-- 
2.25.1

