Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F7412FFAD
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 01:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgADAhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 19:37:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40872 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgADAhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 19:37:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so9988792wmi.5
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 16:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RFvEUC1XS7FPDop1XtshUe046dcZ093vDfP8lyKtuno=;
        b=jDDnEff7cLk0ghIMLI80D+CdUFlDy//FAxnvpmf2BO9u2EbEhmlT/QUxnPjSp8YDdW
         cxgVhJf/Z6GJJPRE/7es/VdrqauyFKnemIwYCr+o5lwBkfzjfZ6amv7117NT1SRbNb+X
         f/bgv9vADJPb/+DV3VNb4dkgkpVUEv7YK42YUMotG4pYTYQptCwQ/zxqVJcB7foqRAik
         ptOx1cMASsd99kcRIXF30hv+uQZKr5AYmaLLAE2FPufEUC+MKbx76QBWJvFQFo3T7Tqr
         O7Ouo1btZbnadw+vGOXtueUYozdd/UZwqLVVW9c67ClSSY834l1i0mXhzeCDbD/0HLtw
         S2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RFvEUC1XS7FPDop1XtshUe046dcZ093vDfP8lyKtuno=;
        b=Gww6FqkwgcypySY1p1WyYMuXvxIcyCrYYMknnAxTDsyj9X86/jijaIB+0mhwu59YP4
         BVch74+7v15SqfH6hlW5x8SctvSIVTWiTrk35yV3UiA22DTCP7BJa4xDwK8OsbIVS2Lq
         1dyhvImacF6F5zptEDgd0uW+jKgqj3hY+l1sUAojkLGyLbXqz3PpYrgiDms9WiOKhh5l
         nG/Hd1zMDU0ThiY0DgsPn+dl0bk2cUJUbuE3RrgR/nw8KLH9NqlUfjd/CT9qN7pzeb9t
         xVphYIR79iT8hiywY3r18PSZigm8HaL1GPQCJcXiENK3CiF6DnVOIOK4vpPYNV6JCCv0
         dpdg==
X-Gm-Message-State: APjAAAU7MVVxmeFsYWkfXqBsFAJF97z48WD8vCvEQQmq4dWoDf9+X/ha
        RIjb1q06HKLZRsWNgX8GWLR6bykJzHs=
X-Google-Smtp-Source: APXvYqyFTgE3+35nn7Et3kbRDDIWT5Clv8+vfyWzhgUbYIkQzIuHoYNZMpYww4LBJMVa9Up3svchng==
X-Received: by 2002:a05:600c:210e:: with SMTP id u14mr22000233wml.28.1578098235979;
        Fri, 03 Jan 2020 16:37:15 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id x10sm59644167wrv.60.2020.01.03.16.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 16:37:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 1/3] net: dsa: sja1105: Always send through management routes in slot 0
Date:   Sat,  4 Jan 2020 02:37:09 +0200
Message-Id: <20200104003711.18366-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200104003711.18366-1-olteanv@gmail.com>
References: <20200104003711.18366-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I finally found out how the 4 management route slots are supposed to
be used, but.. it's not worth it.

The description from the comment I've just deleted in this commit is
still true: when more than 1 management slot is active at the same time,
the switch will match frames incoming [from the CPU port] on the lowest
numbered management slot that matches the frame's DMAC.

My issue was that one was not supposed to statically assign each port a
slot. Yes, there are 4 slots and also 4 non-CPU ports, but that is a
mere coincidence.

Instead, the switch can be used like this: every management frame gets a
slot at the right of the most recently assigned slot:

Send mgmt frame 1 through S0:    S0 x  x  x
Send mgmt frame 2 through S1:    S0 S1 x  x
Send mgmt frame 3 through S2:    S0 S1 S2 x
Send mgmt frame 4 through S3:    S0 S1 S2 S3

The difference compared to the old usage is that the transmission of
frames 1-4 doesn't need to wait until the completion of the management
route. It is safe to use a slot to the right of the most recently used
one, because by protocol nobody will program a slot to your left and
"steal" your route towards the correct egress port.

So there is a potential throughput benefit here.

But mgmt frame 5 has no more free slot to use, so it has to wait until
_all_ of S0, S1, S2, S3 are full, in order to use S0 again.

And that's actually exactly the problem: I was looking for something
that would bring more predictable transmission latency, but this is
exactly the opposite: 3 out of 4 frames would be transmitted quicker,
but the 4th would draw the short straw and have a worse worst-case
latency than before.

Useless.

Things are made even worse by PTP TX timestamping, which is something I
won't go deeply into here. Suffice to say that the fact there is a
driver-level lock on the SPI bus offsets any potential throughput gains
that parallelism might bring.

So there's no going back to the multi-slot scheme, remove the
"mgmt_slot" variable from sja1105_port and the dummy static assignment
made at probe time.

While passing by, also remove the assignment to casc_port altogether.
Don't pretend that we support cascaded setups.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c | 26 +-------------------------
 include/linux/dsa/sja1105.h            |  1 -
 2 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1da5ac111499..79dd965227bc 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -426,14 +426,6 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.tpid2 = ETH_P_SJA1105,
 	};
 	struct sja1105_table *table;
-	int i, k = 0;
-
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		if (dsa_is_dsa_port(priv->ds, i))
-			default_general_params.casc_port = i;
-		else if (dsa_is_user_port(priv->ds, i))
-			priv->ports[i].mgmt_slot = k++;
-	}
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 
@@ -1827,30 +1819,14 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 					      struct sk_buff *skb)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port *sp = &priv->ports[port];
-	int slot = sp->mgmt_slot;
 	struct sk_buff *clone;
 
-	/* The tragic fact about the switch having 4x2 slots for installing
-	 * management routes is that all of them except one are actually
-	 * useless.
-	 * If 2 slots are simultaneously configured for two BPDUs sent to the
-	 * same (multicast) DMAC but on different egress ports, the switch
-	 * would confuse them and redirect first frame it receives on the CPU
-	 * port towards the port configured on the numerically first slot
-	 * (therefore wrong port), then second received frame on second slot
-	 * (also wrong port).
-	 * So for all practical purposes, there needs to be a lock that
-	 * prevents that from happening. The slot used here is utterly useless
-	 * (could have simply been 0 just as fine), but we are doing it
-	 * nonetheless, in case a smarter idea ever comes up in the future.
-	 */
 	mutex_lock(&priv->mgmt_lock);
 
 	/* The clone, if there, was made by dsa_skb_tx_timestamp */
 	clone = DSA_SKB_CB(skb)->clone;
 
-	sja1105_mgmt_xmit(ds, port, slot, skb, !!clone);
+	sja1105_mgmt_xmit(ds, port, 0, skb, !!clone);
 
 	if (!clone)
 		goto out;
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index c0b6a603ea8c..317e05b2584b 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -56,7 +56,6 @@ struct sja1105_port {
 	struct sja1105_tagger_data *data;
 	struct dsa_port *dp;
 	bool hwts_tx_en;
-	int mgmt_slot;
 };
 
 #endif /* _NET_DSA_SJA1105_H */
-- 
2.17.1

