Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C689324FF
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfFBVka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35514 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfFBVk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so6157144wml.0;
        Sun, 02 Jun 2019 14:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zgGWlGW8jVRRLoYu3mmCFoThmgXvRj4t19oGxfOq+/g=;
        b=QScI1mzdclNyf4sjnMYWzJbdXa2ZeDNTXf/GbLN2lWE/m1nNr1KKx89Nmrcv9nDK8f
         1pfGoKNQB2yTfr5JpnqFXMLALJz5eeRTB5LIZ+01JJdI8FIwJua3/ObU+0anW97U4vnA
         KkMfBFqWLULIHnNK1L4xXMSp6PgbrAQ4W4uhX6F4NEI4zhfrRySylsDNHvEx8OKTp/YL
         CCRASonVPzH078fyjl4chygYNUQoD1FM4hqd9BJ7HqiGcWoBJKtBFc3iUvv7Bk+D4Qnv
         H20jG7zRB6q6YvnfEEoSHsIxplmdOPtSeJsGC16bcUiWh3dOwhB+M8apU2j7E4FFZVti
         uJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zgGWlGW8jVRRLoYu3mmCFoThmgXvRj4t19oGxfOq+/g=;
        b=NXnvkBmuUi9Tl3IULM5DVGn1KPUq8hmIwFbxoPozq3I88BowLU0XL6PY85KFQR8wXs
         cvNpGXxl6VKaZlqlY1X4qyy1tj+TCTU4MGGznEOTeQ0bWtirozeh5fvAjU/KMpESIckS
         pGHgxEoJCd/0Hp/aEOP7PN1exQmDCESXCKy1e9T/gxjRMwVYpAFqgUkmNncWLXLc4Go9
         a8bH6tNhTtDPDs3jaqw+LYuhXKVxwdYBMUCmDX+Z4JwcZIzg6NrrGnto76B9S34ksJI0
         wXW1c8HPFxcOFbWhssWk1vge4HpelQmtBFxzVaAdnRcLS5ZQQvuMWBFtZGI0Hr/nQMQE
         Ou6A==
X-Gm-Message-State: APjAAAXf+4GT+2USwQQ94d088s9gcurzjSYAd1FlrU4qqy3FQJWVRNIW
        vF1xXL6oKzB4kj/uHUn9cnyLtOeRNwQ=
X-Google-Smtp-Source: APXvYqyVk00QUxNTzskp0nXmbYlEvJgaLOvIQZU/rtCqlsaPcR2wRQvs3kZUdZFClV3qBeaPX0m5Vw==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr12307136wme.177.1559511626936;
        Sun, 02 Jun 2019 14:40:26 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.40.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 05/10] net: dsa: sja1105: Limit use of incl_srcpt to bridge+vlan mode
Date:   Mon,  3 Jun 2019 00:39:21 +0300
Message-Id: <20190602213926.2290-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The incl_srcpt setting makes the switch mangle the destination MACs of
multicast frames trapped to the CPU - a primitive tagging mechanism that
works even when we cannot use the 802.1Q software features.

The downside is that the two multicast MAC addresses that the switch
traps for L2 PTP (01-80-C2-00-00-0E and 01-1B-19-00-00-00) quickly turn
into a lot more, as the switch encodes the source port and switch id
into bytes 3 and 4 of the MAC. The resulting range of MAC addresses
would need to be installed manually into the DSA master port's multicast
MAC filter, and even then, most devices might not have a large enough
MAC filtering table.

As a result, only limit use of incl_srcpt to when it's strictly
necessary: when under a VLAN filtering bridge.  This fixes PTP in
non-bridged mode (standalone ports). Otherwise, PTP frames, as well as
metadata follow-up frames holding RX timestamps won't be received
because they will be blocked by the master port's MAC filter.
Linuxptp doesn't help, because it only requests the addition of the
unmodified PTP MACs to the multicast filter.
This issue is not seen in bridged mode because the master port is put in
promiscuous mode when the slave ports are enslaved to a bridge.
Therefore, there is no downside to having the incl_srcpt mechanism
active there.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:

Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c |  9 +++++++--
 net/dsa/tag_sja1105.c                  | 15 +++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 909497aa4b6f..6d7a99579026 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -392,11 +392,11 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.hostprio = 0,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
-		.incl_srcpt1 = true,
+		.incl_srcpt1 = false,
 		.send_meta1  = false,
 		.mac_fltres0 = SJA1105_LINKLOCAL_FILTER_B,
 		.mac_flt0    = SJA1105_LINKLOCAL_FILTER_B_MASK,
-		.incl_srcpt0 = true,
+		.incl_srcpt0 = false,
 		.send_meta0  = false,
 		/* The destination for traffic matching mac_fltres1 and
 		 * mac_fltres0 on all ports except host_port. Such traffic
@@ -1433,6 +1433,11 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	general_params = table->entries;
 	general_params->tpid = tpid;
 	general_params->tpid2 = tpid2;
+	/* When VLAN filtering is on, we need to at least be able to
+	 * decode management traffic through the "backup plan".
+	 */
+	general_params->incl_srcpt1 = enabled;
+	general_params->incl_srcpt0 = enabled;
 
 	rc = sja1105_static_config_reload(priv);
 	if (rc)
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 535d8a1aabe1..d840a3749549 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -75,12 +75,15 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	nskb = dsa_8021q_rcv(skb, netdev, pt, &tpid, &tci);
 	is_tagged = (nskb && tpid == ETH_P_SJA1105);
 
-	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-	vid = tci & VLAN_VID_MASK;
-
 	skb->offload_fwd_mark = 1;
 
-	if (sja1105_is_link_local(skb)) {
+	if (is_tagged) {
+		/* Normal traffic path. */
+		vid = tci & VLAN_VID_MASK;
+		source_port = dsa_8021q_rx_source_port(vid);
+		switch_id = dsa_8021q_rx_switch_id(vid);
+		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	} else if (sja1105_is_link_local(skb)) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
 		 * the incl_srcpt options.
@@ -90,10 +93,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		/* Clear the DMAC bytes that were mangled by the switch */
 		hdr->h_dest[3] = 0;
 		hdr->h_dest[4] = 0;
-	} else {
-		/* Normal traffic path. */
-		source_port = dsa_8021q_rx_source_port(vid);
-		switch_id = dsa_8021q_rx_switch_id(vid);
 	}
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
-- 
2.17.1

