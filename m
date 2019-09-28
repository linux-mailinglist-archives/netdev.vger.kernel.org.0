Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53F9C124C
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 00:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfI1WIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 18:08:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55105 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbfI1WIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 18:08:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so9422261wmp.4
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 15:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2chfg5LGq4F3PBBx6ctsbyvEOTOC94oZfDMFmeclrlI=;
        b=a60JqTUPArCmmanV8Dr9/g+5U0qZ3kCOP/lAHSxpfwPFSTmY9ZNLkCD9CAMXKg4lCg
         Kc2w9SUCa9qytMOTbPBy5V3vE6DNrIzzVEwCSsXdaLoS5oSd1lfZ/H7ZeGe6RTElx85G
         0UZM3KGB2kT0K98i0YtJ8W3jaPb+j8sRSg1gDTKTouxHuz2CXFR/VXmHAA4AJ5nsyXt7
         KjSwZzJdP5fRkMtwcOmXSVmyU/bBmD4Dy8VhsJvAO7WkdWTtB9YYBbgfe5p7BFxsVcU3
         RMupIIFtO0CABoQx6I9Yrj0C3SJ/0mmauWHkRl21bTKrKpGtxPvGLuI7GIJryLWVQR8X
         FCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2chfg5LGq4F3PBBx6ctsbyvEOTOC94oZfDMFmeclrlI=;
        b=hASgheY6s/+S2N8qeXy/6kAjOuHItkni9a6vRJtEjPBKB1CbiedzyxcLeZd5I2kGPq
         ASzEiB7ylEt4+M5z+ZElLsGpeBf+Yk+xLKw062wUR5xHi20LeLvjqn2b1uYGfq8fEb/0
         2ycetM/l/oxlk2tMdqg9nF3PvvuG/V+CerjCXwvV1kFKN0+gfD906hkt5XugLE+q/REP
         tCAldfiKYwzdX6npxG6WRJUKNvsaETLWTftiCtvnNbmQx5CWVF1FRV3SqaKh15UFNO1W
         3fjVeMp1YpyVFsm9NQGzXnCjl5eFEI5qjFJjYDvxOornPWCodl3RlYFmrlfvwf7p+0iU
         sLkg==
X-Gm-Message-State: APjAAAWUeUqbqycPOICTwYymCpBPJ5XKGgeBiaVXxZw7NQYtWHflqYV8
        L/m4Qc1UzxDlKbboP8cdFNI=
X-Google-Smtp-Source: APXvYqxM7JMeldB0AKjB/wchSFRrcJAYrE9MlxwiAGaoCja4zSK5V1lhC+CIEpz12GC/B6SUK3af1A==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr11984426wme.89.1569708516171;
        Sat, 28 Sep 2019 15:08:36 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id z189sm27421632wmc.25.2019.09.28.15.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 15:08:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: Ensure PTP time for rxtstamp reconstruction is not in the past
Date:   Sun, 29 Sep 2019 01:08:17 +0300
Message-Id: <20190928220817.24002-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes the PTP synchronization on the switch 'jumps':

  ptp4l[11241.155]: rms    8 max   16 freq -21732 +/-  11 delay   742 +/-   0
  ptp4l[11243.157]: rms    7 max   17 freq -21731 +/-  10 delay   744 +/-   0
  ptp4l[11245.160]: rms 33592410 max 134217731 freq +192422 +/- 8530253 delay   743 +/-   0
  ptp4l[11247.163]: rms 811631 max 964131 freq +10326 +/- 557785 delay   743 +/-   0
  ptp4l[11249.166]: rms 261936 max 533876 freq -304323 +/- 126371 delay   744 +/-   0
  ptp4l[11251.169]: rms 48700 max 57740 freq -20218 +/- 30532 delay   744 +/-   0
  ptp4l[11253.171]: rms 14570 max 30163 freq  -5568 +/- 7563 delay   742 +/-   0
  ptp4l[11255.174]: rms 2914 max 3440 freq -22001 +/- 1667 delay   744 +/-   1
  ptp4l[11257.177]: rms  811 max 1710 freq -22653 +/- 451 delay   744 +/-   1
  ptp4l[11259.180]: rms  177 max  218 freq -21695 +/-  89 delay   741 +/-   0
  ptp4l[11261.182]: rms   45 max   92 freq -21677 +/-  32 delay   742 +/-   0
  ptp4l[11263.186]: rms   14 max   32 freq -21733 +/-  11 delay   742 +/-   0
  ptp4l[11265.188]: rms    9 max   14 freq -21725 +/-  12 delay   742 +/-   0
  ptp4l[11267.191]: rms    9 max   16 freq -21727 +/-  13 delay   742 +/-   0
  ptp4l[11269.194]: rms    6 max   15 freq -21726 +/-   9 delay   743 +/-   0
  ptp4l[11271.197]: rms    8 max   15 freq -21728 +/-  11 delay   743 +/-   0
  ptp4l[11273.200]: rms    6 max   12 freq -21727 +/-   8 delay   743 +/-   0
  ptp4l[11275.202]: rms    9 max   17 freq -21720 +/-  11 delay   742 +/-   0
  ptp4l[11277.205]: rms    9 max   18 freq -21725 +/-  12 delay   742 +/-   0

Background: the switch only offers partial RX timestamps (24 bits) and
it is up to the driver to read the PTP clock to fill those timestamps up
to 64 bits. But the PTP clock readout needs to happen quickly enough (in
0.135 seconds, in fact), otherwise the PTP clock will wrap around 24
bits, condition which cannot be detected.

Looking at the 'max 134217731' value on output line 3, one can see that
in hex it is 0x8000003. Because the PTP clock resolution is 8 ns,
that means 0x1000000 in ticks, which is exactly 2^24. So indeed this is
a PTP clock wraparound, but the reason might be surprising.

What is going on is that sja1105_tstamp_reconstruct(priv, now, ts)
expects a "now" time that is later than the "ts" was snapshotted at.
This, of course, is obvious: we read the PTP time _after_ the partial RX
timestamp was received. However, the workqueue is processing frames from
a skb queue and reuses the same PTP time, read once at the beginning.
Normally the skb queue only contains one frame and all goes well. But
when the skb queue contains two frames, the second frame that gets
dequeued might have been partially timestamped by the RX MAC _after_ we
had read our PTP time initially.

The code was originally like that due to concerns that SPI access for
PTP time readout is a slow process, and we are time-constrained anyway
(aka: premature optimization). But some timing analysis reveals that the
time spent until the RX timestamp is completely reconstructed is 1 order
of magnitude lower than the 0.135 s deadline even under worst-case
conditions. So we can afford to read the PTP time for each frame in the
RX timestamping queue, which of course ensures that the full PTP time is
in the partial timestamp's future.

Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b9def744bcb3..f3d38ff144c4 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2005,12 +2005,12 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 
 	mutex_lock(&priv->ptp_lock);
 
-	now = priv->tstamp_cc.read(&priv->tstamp_cc);
-
 	while ((skb = skb_dequeue(&data->skb_rxtstamp_queue)) != NULL) {
 		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
 		u64 ts;
 
+		now = priv->tstamp_cc.read(&priv->tstamp_cc);
+
 		*shwt = (struct skb_shared_hwtstamps) {0};
 
 		ts = SJA1105_SKB_CB(skb)->meta_tstamp;
-- 
2.17.1

