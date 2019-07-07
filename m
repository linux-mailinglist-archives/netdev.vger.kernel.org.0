Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C357A615B2
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfGGR3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:29:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38456 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbfGGR3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 13:29:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so14118535wmj.3
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 10:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1Yy+EllIuFIeHh+2l2fUyLKdsx7arkax3CnTrvl8+W0=;
        b=XcWjvAt6aSY/4x8hDI+MjyBtshhmmiPALWWdAWClh0GW1q73qw/g6QsFQFezOtWXkI
         Q3VW98BP8WFkodOw9srp9gDKwhNuQFZ3cAc38GzRV0J2qgirTPGkEYuSUDajd1/Cv+9k
         eqV7wwUYOhAsmEJrZ+KTBunJSMbAYk46a+a/yGNn3UzQeK/luy2HI9acm8mCvB2DL/9w
         Os+ntFmV9vkokHGUvNf81H8vF/JLk1JPbhJMMdvjuUYBPCFjAjb7TAyoaS+vvKz3o4bQ
         MiUP/MAD6hMW99ChOkTLCVr6aeTRhcR+/DlpFWvsjjh6xrWdKKFfuDFK7YUxNN28/Uqm
         WxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1Yy+EllIuFIeHh+2l2fUyLKdsx7arkax3CnTrvl8+W0=;
        b=c+hW7Z1tpy5zfFp/CN5hzQDZuIwLDKnhtJx3ha/2w1tzkynuErrQG0hO5QO92loSYm
         YZq4qRCdmBhDZ74u5HjT0L7Ix3dUu6CcvdcjIlPblpOfTNLoxAjaSyVChsYY5iD4MILb
         iBz09ScLQdO4nm7HqZa9rjQHRfHWU7EuP3zffDWGQf45vZRWRMXNDcUKnVAd1L3gobeT
         LIfK7i0LbrYQPAvc/RgGKRwm0LZnLxGt43jZFAAmIENsFLpk+Q/saYcNHGFJa8mjscBL
         EBamxe8Pq60i7Im5tNaGEPqsDBogUNcYaXhct1nxvMDQBEMI+/I4DjFm7lCRyrcJVMHm
         zPEA==
X-Gm-Message-State: APjAAAUPow9Oas1p6WASukwHerOi3lCL94p1j1tZFlj5eaISCr9yh/0F
        b+z7NQCIyiHlfgXcEq4M+14=
X-Google-Smtp-Source: APXvYqx2pb/V1zicA5zbFiEqaA1aTp/irmCAojxADmF5zNpK103R1p9oo5ygUNoXiuOpV2tWbMP2WA==
X-Received: by 2002:a7b:c455:: with SMTP id l21mr13007893wmi.114.1562520579333;
        Sun, 07 Jul 2019 10:29:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id g14sm14280463wro.11.2019.07.07.10.29.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 10:29:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 5/6] net: dsa: sja1105: Advertise the 8 TX queues
Date:   Sun,  7 Jul 2019 20:29:20 +0300
Message-Id: <20190707172921.17731-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190707172921.17731-1-olteanv@gmail.com>
References: <20190707172921.17731-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation patch for the tc-taprio offload (and potentially
for other future offloads such as tc-mqprio).

Instead of looking directly at skb->priority during xmit, let's get the
netdev queue and the queue-to-traffic-class mapping, and put the
resulting traffic class into the dsa_8021q PCP field. The switch is
configured with a 1-to-1 PCP-to-ingress-queue-to-egress-queue mapping
(see vlan_pmap in sja1105_main.c), so the effect is that we can inject
into a front-panel's egress traffic class through VLAN tagging from
Linux, completely transparently.

Unfortunately the switch doesn't look at the VLAN PCP in the case of
management traffic to/from the CPU (link-local frames at
01-80-C2-xx-xx-xx or 01-1B-19-xx-xx-xx) so we can't alter the
transmission queue of this type of traffic on a frame-by-frame basis. It
is only selected through the "hostprio" setting which ATM is harcoded in
the driver to 7.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 7 ++++++-
 net/dsa/tag_sja1105.c                  | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index bc7e4e030b07..30761e6545a3 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -384,7 +384,9 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		/* Disallow dynamic changing of the mirror port */
 		.mirr_ptacu = 0,
 		.switchid = priv->ds->index,
-		/* Priority queue for link-local frames trapped to CPU */
+		/* Priority queue for link-local management frames
+		 * (both ingress to and egress from CPU - PTP, STP etc)
+		 */
 		.hostprio = 7,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
@@ -1704,6 +1706,9 @@ static int sja1105_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 
+	/* Advertise the 8 egress queues */
+	ds->num_tx_queues = SJA1105_NUM_TC;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 1d96c9d4a8e9..9ae84990f730 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -89,7 +89,8 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
 	struct dsa_switch *ds = dp->ds;
 	u16 tx_vid = dsa_8021q_tx_vid(ds, dp->index);
-	u8 pcp = skb->priority;
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
 
 	/* Transmitting management traffic does not rely upon switch tagging,
 	 * but instead SPI-installed management routes. Part 2 of this
-- 
2.17.1

