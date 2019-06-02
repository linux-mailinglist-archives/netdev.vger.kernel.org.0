Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83958324EE
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfFBVQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:16:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41450 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfFBVQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:16:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so9974664wrm.8
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RPC40hnGNPlUQtj7Er2lSee3fyXOHmsMs5ve+6z4rTM=;
        b=qq2x0/bpCfnnWKx8O1VTr+PQuQn1SkapJV/LQP2hYC4bQW2talnKwS/oVEMmiIkkA9
         knB0fKScyHtZJ+5GtBTCxJQyoShs0cLs2tNCUBipT5uAECOTJCdt6zChtU1Al6S4yhKE
         w6kk1+4HMJ4h5yk5k6fwHOTE+DUVgtl1Ssj607cg7evMfvFaLkfdHv4RkdUzxBJQcgLp
         yBJuT5osS2Om9pnK2A1teqs8iJGXJ6msqOXaaFRWUBD/TGEhEv5JavpnLnECUgD5w0nc
         hL2geeW1ihPpWbQhCU9zSumZ2ToFm299wHzFV4ESlHKmsKLOpomw12jFOuXKhQlWrsrg
         4pJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RPC40hnGNPlUQtj7Er2lSee3fyXOHmsMs5ve+6z4rTM=;
        b=Ng4M6csM3vYLEDeHX3oYQ0QxuKsTe/YG0o1MfvpwnknVo5/AIE6c4cZi82qAL6xqZM
         gF0Ek1E5O12O8vvQm+x+TOV+/vymQPd/iLrYlwqdDaqT47G80f3zBW4eR4JYncksD+pj
         pkKgOIKc0MmUYgDJViS8fOyzb2RFA8ZTa+XHYZq6QWj6YvWGd6oGyTR/BV2sxl4DZLDb
         cF88j4cMEE1fv/4hS15Oidz6ffczzX7lZsdOvrbKdTJZqxus5MS0w2RKESbhf7C949M1
         v7nZN8v4BZvcqaA4ELZ7u2b/olxvcc7tCQxtKWNGYXw9u1RA5PKfvCWKrHc6x5lvm8WS
         JP+Q==
X-Gm-Message-State: APjAAAX13bLFHsfavIe5gtOlFQuiy1ezHVHF7S9mZsbFYoSE6v616ZMB
        o4RBoUluue7b+WOf9AGukRG2Ie3T
X-Google-Smtp-Source: APXvYqyoWdDZhpvdYWaus5nDGfpinDEutfX8dOft9VtGSCImxT4FtIccIKo4M33VT2fgaOU94/NUJg==
X-Received: by 2002:adf:9e4c:: with SMTP id v12mr14020473wre.312.1559510164349;
        Sun, 02 Jun 2019 14:16:04 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id j123sm20392857wmb.32.2019.06.02.14.16.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:16:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 11/11] net: dsa: sja1105: Hide the dsa_8021q VLANs from the bridge fdb command
Date:   Mon,  3 Jun 2019 00:16:01 +0300
Message-Id: <20190602211601.19169-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX VLANs and RX VLANs are an internal implementation detail of DSA for
frame tagging.  They work by installing special VLANs on switch ports in
the operating modes where no behavior change w.r.t. VLANs can be
observed by the user.

Therefore it makes sense to hide these VLANs in the 'bridge fdb'
command, as well as translate the pvid into the RX VID and TX VID on
'bridge fdb add' and 'bridge fdb del' commands.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 37 ++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8343dcf48384..b151a8fafb9e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1006,7 +1006,21 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid)
 {
 	struct sja1105_private *priv = ds->priv;
+	int rc;
+
+	/* Since we make use of VLANs even when the bridge core doesn't tell us
+	 * to, translate these FDB entries into the correct dsa_8021q ones.
+	 */
+	if (!dsa_port_is_vlan_filtering(&ds->ports[port])) {
+		unsigned int upstream = dsa_upstream_port(priv->ds, port);
+		u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 
+		rc = priv->info->fdb_add_cmd(ds, port, addr, tx_vid);
+		if (rc < 0)
+			return rc;
+		return priv->info->fdb_add_cmd(ds, upstream, addr, rx_vid);
+	}
 	return priv->info->fdb_add_cmd(ds, port, addr, vid);
 }
 
@@ -1014,7 +1028,21 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid)
 {
 	struct sja1105_private *priv = ds->priv;
+	int rc;
 
+	/* Since we make use of VLANs even when the bridge core doesn't tell us
+	 * to, translate these FDB entries into the correct dsa_8021q ones.
+	 */
+	if (!dsa_port_is_vlan_filtering(&ds->ports[port])) {
+		unsigned int upstream = dsa_upstream_port(priv->ds, port);
+		u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+
+		rc = priv->info->fdb_del_cmd(ds, port, addr, tx_vid);
+		if (rc < 0)
+			return rc;
+		return priv->info->fdb_del_cmd(ds, upstream, addr, rx_vid);
+	}
 	return priv->info->fdb_del_cmd(ds, port, addr, vid);
 }
 
@@ -1049,6 +1077,15 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		if (!(l2_lookup.destports & BIT(port)))
 			continue;
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
+
+		/* We need to hide the dsa_8021q VLAN from the user.
+		 * Convert the TX VID into the pvid that is active in
+		 * standalone and non-vlan_filtering modes, aka 1.
+		 * The RX VID is applied on the CPU port, which is not seen by
+		 * the bridge core anyway, so there's nothing to hide.
+		 */
+		if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+			l2_lookup.vlanid = 1;
 		cb(macaddr, l2_lookup.vlanid, false, data);
 	}
 	return 0;
-- 
2.17.1

