Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA33A34E55
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfFDRIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42024 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbfFDRIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id o12so9524097wrj.9;
        Tue, 04 Jun 2019 10:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dV7GdG3wJbcwgoYxvKWH97wEYz1kaR/OcrpF1JOeUlE=;
        b=jUkzMeT1khrSPWIaSlqTAKainYLphJMXDDKitCsccNMLgGW01N1UckAM67mgQrXumk
         R7rFzQIUNO1V0NNYSIDr3fiDxS6GtiNrshYRcfDciWCH7y6wHS7k43jJwLZllusFt0l8
         il/j8yBtDpzuz6E0Cf86xwqVQpZMyjR/63wF60mul/edqbg+eXEutV/FJwQQAQYWNtAL
         WRH8kF4m8xMXiYMZMPf3CeY5HPquuaPQzPpFO+ariq4DcZD9f+D9fqQd16imfQn2CrpT
         hmWbQjIQmj7f9Q2ideCM90j1c5F6/YQ5BAqnB6LnkVkdM8RjXfxdgKytjmD6wuUCGVqm
         wHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dV7GdG3wJbcwgoYxvKWH97wEYz1kaR/OcrpF1JOeUlE=;
        b=WdwPxFyhx5KsUkEC6OT5ZGDWPno4XO8p8ljlEzHIDIzgTMbDqkC8ONqRH6NfwZNbWA
         IHLKzXYYWw3U221zRfWm9NCWsWSZWP+fKLVP7U1YpZSmDLoODcU0HCESATwWxcN+Ucsv
         4I5FdZ3mWk31ZVwIbuKMABuhZO8XHZsTdgR9hVFQrzA8DBdXc5k9ovzpADH32SFKvhzO
         qLv+H5lru3GPCMipKNdAgp0ku6dsTv+y9+/bu3Z3ghvrx+a3EXxITfI/AG20xC1KU2jR
         aMnEbYADpakbeCcRkBr7KVYyIAnh48Rt+EdqCWqnooPWpkr8pe7BYUbTQ0mOI01m5af4
         5mmw==
X-Gm-Message-State: APjAAAU+oy/ehpzOuuYy7Ds34eYP3Mxu1LsJFZGH9Y3u1ID5osJZzCCF
        +Kl0mwPQQHgv4gNKLgyAUMzBMGkasbQ=
X-Google-Smtp-Source: APXvYqxqoXOD7VDYHTbu2e29hYuvQVIPWSt93ECmiC7+k5HddszhGAnwffOlc0IjJogK631J4bQC6w==
X-Received: by 2002:adf:afd5:: with SMTP id y21mr20932168wrd.12.1559668089822;
        Tue, 04 Jun 2019 10:08:09 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 06/17] net: dsa: sja1105: Limit use of incl_srcpt to bridge+vlan mode
Date:   Tue,  4 Jun 2019 20:07:45 +0300
Message-Id: <20190604170756.14338-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
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
Changes in v3:

None.

Changes in v2:

Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c |  9 +++++++--
 net/dsa/tag_sja1105.c                  | 20 +++++++++++---------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 0f34e713c408..a30b89455421 100644
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
@@ -1435,6 +1435,11 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	general_params->tpid = tpid;
 	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
 	general_params->tpid2 = tpid2;
+	/* When VLAN filtering is on, we need to at least be able to
+	 * decode management traffic through the "backup plan".
+	 */
+	general_params->incl_srcpt1 = enabled;
+	general_params->incl_srcpt0 = enabled;
 
 	rc = sja1105_static_config_reload(priv);
 	if (rc)
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 535d8a1aabe1..b35cf5c2d01c 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -66,8 +66,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
-	struct ethhdr *hdr = eth_hdr(skb);
-	u64 source_port, switch_id;
+	int source_port, switch_id;
 	struct sk_buff *nskb;
 	u16 tpid, vid, tci;
 	bool is_tagged;
@@ -75,12 +74,17 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
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
+		struct ethhdr *hdr = eth_hdr(skb);
+
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
 		 * the incl_srcpt options.
@@ -91,9 +95,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		hdr->h_dest[3] = 0;
 		hdr->h_dest[4] = 0;
 	} else {
-		/* Normal traffic path. */
-		source_port = dsa_8021q_rx_source_port(vid);
-		switch_id = dsa_8021q_rx_switch_id(vid);
+		return NULL;
 	}
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
-- 
2.17.1

