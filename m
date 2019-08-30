Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150F8A2BA6
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfH3ArR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32866 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfH3ArA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:47:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so5239347wrr.0
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=okvCbJRGSBW0afYBgPHs06MKr4GY4K4DnCbOWgAvAbY=;
        b=jj2Uq9yO27vHSCL9gSIIT7Dbh/eBniMdfAl51DoC1RBWAk91zPx73vlWkvts3H5P7l
         DapgyxCP06gYFFeX31DOjhLAGTy+X8UeC1+SfFohPcQJvryJo5hMK7+6FGgllzU/R5+Y
         77wN8sDaggizW7Dkk9WsgGjJkIeusQ3Wl/ipA5pXI6OveVxFnw1emKmCHWcOn9tXVwPL
         YUwBU+G6Gb+a1V6Q+3HcQawuraelfLVFxI6N4/Qn6vowILxzm0A9HaqUJ0searTihzce
         BbVMhkRuithfgyfn4I60+Yehr6xfJwBaEP3uHq0rzeRYQWrg+l0UI9Y24OV7D5uyFig0
         aBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=okvCbJRGSBW0afYBgPHs06MKr4GY4K4DnCbOWgAvAbY=;
        b=ZG2mRUDqBiOBNqdTCpOX6wfDjScD+BvbjKvYFAGiCwORTvnZwo/MbxejwI6ojx5Q23
         m2A6i5SYnCfvimKAu6FYConl2FGGnuy+95Tx9CacCv81Elk3KkGTVtB3G7gbfeaQ7C4D
         LhtMwQ8P3eZKhH//itvX43/z9gQFdkh4H7SEHfTp+qxQXtOWWXkGFRCy21dAy6yMYRNj
         ai6VPocaFmwWFCSMkq6vWjPBLk+vR1KAp1vPTI5SRWvBzwmvkQ8duFoxfhk7K8yJSETC
         KzHX+oPjKv7HAY+9z7BgHabTMBXCwMjC6p8P5jQpEL31T2J/EhDJlHR5FWPh7kcAiGHw
         e9Wg==
X-Gm-Message-State: APjAAAVt10qdcPAjB912wVHZpuWsGOKtfrT++bKjTUg/oc3cSsZ2Yxf2
        Ucx9XvbQCwYMAHx5hQkFGgc=
X-Google-Smtp-Source: APXvYqxDq4phU+cZIvBCICDJP8ACzBvm4hRiFcKVdHiGySYePHBWh8sIs7Pg3yJe9PpWJNh1ZkxAcg==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr15666885wru.27.1567126018463;
        Thu, 29 Aug 2019 17:46:58 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 08/15] net: dsa: sja1105: Advertise the 8 TX queues
Date:   Fri, 30 Aug 2019 03:46:28 +0300
Message-Id: <20190830004635.24863-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
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
index 670c069722d5..8b930cc2dabc 100644
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
@@ -1745,6 +1747,9 @@ static int sja1105_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 
+	/* Advertise the 8 egress queues */
+	ds->num_tx_queues = SJA1105_NUM_TC;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 47ee88163a9d..9c9aff3e52cf 100644
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

