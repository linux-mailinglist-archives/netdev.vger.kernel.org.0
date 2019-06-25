Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387D555C6B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfFYXkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33605 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfFYXkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so3339171wme.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vir+G/PX6qRAdzLLrtDKyq+D1/ksJ4zmdnJpJhvDRig=;
        b=Es5VOBQc7lci+SAnovNlFCtir0fbl2PJ5qR+NERbbkYeMPURTFRFj+8IkvE2VT1H5l
         6U70jNK7SJ9DSgO8LwvXlh8F6ChyFfoZ61ngF/uDhIynToUSLHquwo1IgWvA/o3aHpNP
         Mw0P0C/NhBLBn5Hhs+5vf37g+RVjBuLro5VjawdPBul7I9VM4x3z/KI1xFlmE04hoFUp
         +p6XA+vzVyrbNnjCHa8L+3LcwVHl6RPudkRQcvXqc8xkjd6sHqqxt4ky32GGpNfXwA2f
         8Q2SR+ycP9KH0xA9T8+p7OVFwtO1315NpQrbHbWk5oOmwExcK15j/iXc7HTFjX97uX2a
         jMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vir+G/PX6qRAdzLLrtDKyq+D1/ksJ4zmdnJpJhvDRig=;
        b=KYNmw5m6qublKJOs4u2NxDYmTh2zHddQkSOjTYfrN0WyxCuSA55vkeCibydbdvbfDz
         t/+XvM6dI8dHXMVqW1LStCOLOrw9UtLGtrZntad0jjDMjWTXukEt2mYpowuzG+NzT6R4
         UhvcnZNXFeYRWhaY2wPDwCgiP/YB5x9nX1Ctpq4DFOZxs8vY0rf6ThU8XF4BesZWb8Vl
         0lP9nZRY5jGEdyG8A5xlQmo7JpQl4aiXFEoxhjFN+PCNSawwbgqiDW5kp1sDkXGC5OD5
         1gQvKWnsCt24dnqG/LEh+7RdOVW7uB/3YbH2v+TnjdBI/jZSSvHagOcS0AfaaFUyD9+R
         eUbA==
X-Gm-Message-State: APjAAAXBK3ICYwtKfFeP/I5azrXbEsUbqColLQgc8C6IVNrB75mKXwcB
        MsxplN9t1Hdv5+1TP16UMcc=
X-Google-Smtp-Source: APXvYqx+Zdxf4ml4NBVV0mxnKa/aObYeGy+cEZo8s7Y01ITkW6YJyzoXp8rckR5DB/cIkv9tkn8RrQ==
X-Received: by 2002:a1c:3b45:: with SMTP id i66mr244023wma.48.1561506006677;
        Tue, 25 Jun 2019 16:40:06 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 03/10] net: dsa: sja1105: Make vid 1 the default pvid
Date:   Wed, 26 Jun 2019 02:39:35 +0300
Message-Id: <20190625233942.1946-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In SJA1105 there is no concept of 'default values' per se, everything
needs to be driver-supplied through the static configuration tables.

The issue is that the hardware manual says that 'at least the default
untagging VLAN' is mandatory to be provided through the static config.
But VLAN 0 isn't a very good initial pvid - its use is reserved for
priority-tagged frames, and the layers of the stack that care about
those already make sure that this VLAN is installed, as can be seen in
the message below:

  8021q: adding VLAN 0 to HW filter on device swp2

So change the pvid provided through the static configuration to 1, which
matches the bridge core's defaults.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 9395e8f5f790..bc9f37cd3876 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -80,7 +80,7 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		.maxage = 0xFF,
 		/* Internal VLAN (pvid) to apply to untagged ingress */
 		.vlanprio = 0,
-		.vlanid = 0,
+		.vlanid = 1,
 		.ing_mirr = false,
 		.egr_mirr = false,
 		/* Don't drop traffic with other EtherType than ETH_P_IP */
@@ -264,20 +264,15 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		.vmemb_port = 0,
 		.vlan_bc = 0,
 		.tag_port = 0,
-		.vlanid = 0,
+		.vlanid = 1,
 	};
 	int i;
 
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
 
-	/* The static VLAN table will only contain the initial pvid of 0.
+	/* The static VLAN table will only contain the initial pvid of 1.
 	 * All other VLANs are to be configured through dynamic entries,
 	 * and kept in the static configuration table as backing memory.
-	 * The pvid of 0 is sufficient to pass traffic while the ports are
-	 * standalone and when vlan_filtering is disabled. When filtering
-	 * gets enabled, the switchdev core sets up the VLAN ID 1 and sets
-	 * it as the new pvid. Actually 'pvid 1' still comes up in 'bridge
-	 * vlan' even when vlan_filtering is off, but it has no effect.
 	 */
 	if (table->entry_count) {
 		kfree(table->entries);
@@ -291,7 +286,7 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 
 	table->entry_count = 1;
 
-	/* VLAN ID 0: all DT-defined ports are members; no restrictions on
+	/* VLAN 1: all DT-defined ports are members; no restrictions on
 	 * forwarding; always transmit priority-tagged frames as untagged.
 	 */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-- 
2.17.1

