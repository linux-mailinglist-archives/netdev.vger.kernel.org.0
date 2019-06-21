Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE574F079
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 23:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFUV0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 17:26:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42574 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUV0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 17:26:41 -0400
Received: from mail-qk1-f199.google.com ([209.85.222.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1heR3O-000404-Kw
        for netdev@vger.kernel.org; Fri, 21 Jun 2019 21:26:38 +0000
Received: by mail-qk1-f199.google.com with SMTP id k13so9027685qkj.4
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 14:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ATE8lhTswCbMgIcjrXZsyDzJSAxzG424RDwYUdGXPWQ=;
        b=jMxJZCtUm8BGmQqEVni/SIFxF69K45PzeVltYv1QH4d3PY6VYiUbZFF9SsegJ23MlO
         JumJMUYjo97Dzrhuob0vYW1ckjL8C+Kj7Dy4iHnYBe84WFzFknbWTt3XalZeUnh7LyGX
         nuZd74MdKWtIRO2V4clSUUudizd0kvENSciInuLn/E6LuDfk1ChHk1RCe6UmvB9FCZZi
         1YZGClcqdR2PFHnnVDqIAw681XwVGQRwYqdp/r3KdGN52zQJVMZFs93SJiBBjfhSTB4s
         sETrZxKHchBoYzHZgktIDpnLsTkOn0wNTF4rZjMwTDHUQ/jyl77Qbf6MVJ3ZiOXbiU30
         4+vA==
X-Gm-Message-State: APjAAAXDqen1te1j6q5woR8L5dNVluyEnCZkWjSw3kkvfl5ZeqFDEpD7
        u/v/fNXvRQT9vZZlJR4NpAHDcPJnChnzPVHgwjhXkgPlt7J4vB/bC1rdXfyHUzK1mOnKLYaVueF
        rdGJusTZg+nmjk6H2apYkC0IU4OQVrb7wtg==
X-Received: by 2002:a37:9fd4:: with SMTP id i203mr7219177qke.419.1561152397824;
        Fri, 21 Jun 2019 14:26:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwSlZndd/FfHuV6c+nIx7MADPyDWWFcBGy1qD7yeobx5X2sXi2R0z/8NWdgtnaJlHh9FN9eiA==
X-Received: by 2002:a37:9fd4:: with SMTP id i203mr7219159qke.419.1561152397609;
        Fri, 21 Jun 2019 14:26:37 -0700 (PDT)
Received: from localhost ([152.249.30.79])
        by smtp.gmail.com with ESMTPSA id h4sm1904935qkk.39.2019.06.21.14.26.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 14:26:36 -0700 (PDT)
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
To:     GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org
Cc:     aelior@marvell.com, skalluru@marvell.com, gpiccoli@canonical.com,
        jay.vosburgh@canonical.com
Subject: [PATCH] bnx2x: Prevent ptp_task to be rescheduled indefinitely
Date:   Fri, 21 Jun 2019 18:26:34 -0300
Message-Id: <20190621212634.25441-1-gpiccoli@canonical.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bnx2x ptp worker tries to read a register with timestamp
information in case of TX packet timestamping and in case it fails,
the routine reschedules itself indefinitely. This was reported as a
kworker always at 100% of CPU usage, which was narrowed down to be
bnx2x ptp_task.

By following the ioctl handler, we could narrow down the problem to an
NTP tool (chrony) requesting HW timestamping from bnx2x NIC with RX
filter zeroed; this isn't reproducible for example with linuxptp since
this tool request a supported RX filter. It seems the NIC HW timestamp
mechanism cannot work well with RX_FILTER_NONE - in driver's PTP filter
initialization routine, when there's not a supported filter request the
function does not perform a specific register write to the adapter.

This patch addresses the problem of the everlasting reschedule of the
ptp worker by limiting that to 3 attempts (the first one plus two
reschedules), in order to prevent the unbound resource consumption
from the driver. It's not correct behavior for a driver to not take
into account potential problems in a routine reading a device register,
be it an invalid RX filter (leading to a non-functional HW clock) or
even a potential device FW issue causing the register value to be wrong,
hence we believe the fix is relevant to ensure proper driver behavior.

This has no functional change in the succeeding path of the HW
timestamping code in the driver, only portion of code it changes
is the error path for TX timestamping. It was tested using both
linuxptp and chrony.

Reported-and-tested-by: Przemyslaw Hausman <przemyslaw.hausman@canonical.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h    |  1 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  1 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 18 +++++++++++++-----
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index 6026b53137aa..349965135227 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1838,6 +1838,7 @@ struct bnx2x {
 	bool timecounter_init_done;
 	struct sk_buff *ptp_tx_skb;
 	unsigned long ptp_tx_start;
+	u8 ptp_retry_count;
 	bool hwtstamp_ioctl_called;
 	u16 tx_type;
 	u16 rx_filter;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 008ad0ca89ba..990ec049f357 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3865,6 +3865,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			/* schedule check for Tx timestamp */
 			bp->ptp_tx_skb = skb_get(skb);
 			bp->ptp_tx_start = jiffies;
+			bp->ptp_retry_count = 0;
 			schedule_work(&bp->ptp_task);
 		}
 	}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 03ac10b1cd1e..872ae672faaa 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -15233,16 +15233,24 @@ static void bnx2x_ptp_task(struct work_struct *work)
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ns_to_ktime(ns);
 		skb_tstamp_tx(bp->ptp_tx_skb, &shhwtstamps);
-		dev_kfree_skb_any(bp->ptp_tx_skb);
-		bp->ptp_tx_skb = NULL;
-
 		DP(BNX2X_MSG_PTP, "Tx timestamp, timestamp cycles = %llu, ns = %llu\n",
 		   timestamp, ns);
+		goto clear;
 	} else {
 		DP(BNX2X_MSG_PTP, "There is no valid Tx timestamp yet\n");
-		/* Reschedule to keep checking for a valid timestamp value */
-		schedule_work(&bp->ptp_task);
+		/* Reschedule twice to check again for a valid timestamp */
+		if (++bp->ptp_retry_count < 3) {
+			schedule_work(&bp->ptp_task);
+			return;
+		}
+		DP(BNX2X_MSG_PTP, "Gave up Tx timestamp, register read %u\n", val_seq);
+		netdev_warn_once(bp->dev,
+				 "Gave up Tx timestamp, register read %u\n", val_seq);
 	}
+clear:
+	dev_kfree_skb_any(bp->ptp_tx_skb);
+	bp->ptp_tx_skb = NULL;
+	bp->ptp_retry_count = 0;
 }
 
 void bnx2x_set_rx_ts(struct bnx2x *bp, struct sk_buff *skb)
-- 
2.21.0

