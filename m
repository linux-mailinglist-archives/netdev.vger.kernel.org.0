Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F54C2E78F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfE2VnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:43:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43492 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbfE2Vm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:42:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id l17so2749246wrm.10
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 14:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KKtOYnmS8nX/zEDt9b9gVRz3nEUKb+Pxh6+fQ4O5Ms4=;
        b=AE0bTA4/1cmhKaR7lEpA13H2+6XOgoXUrLF5NDfD8Y0rjmSSunI04owibIf88YzgIj
         mgq2TTTapsco6E/ppO68qDiggOVvkQgW1MG/uJw7rpw5fLbOp0YJuRS3bfVdVVVpsVWX
         ocSLl62VVle+Wvv5mrhw0zUBsw1qCNZLZ9H0IuTXPsUbExp3apYOXUFAuSEwYJllwbYB
         79Ac1glW8HIArff6fyYJniBKjlY3UbhqllJTCZBRhm2WXwNkxwm9HiL/9ILkHt60XgoS
         C6T+DhJYl+S6ED7BXZvgp+Ki8KLyHn+WmBOnJRJYtpj++W8IGhSMvIBO9jcLlNfiKxMU
         18/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KKtOYnmS8nX/zEDt9b9gVRz3nEUKb+Pxh6+fQ4O5Ms4=;
        b=DVupbMR9CPCbQmBuqXTWBJoWg1J5G4FjyW46IunQTGRSe/biaj7VdX8//GrCkpnLgH
         +RXaji1ZLhFatbr33P1+Tb0g8P9YKals/zogAdExFfSKJratHPfYM8qs0s7zl/qYE4Os
         6rbYlFgEE0VjQu5vtr0YcUF1g9/ngou/It/M9McGI0tKVEWCrgMi73vt63ZRa3ogBWfF
         99r/ttimIfa9XFVNp5fGzdx7Wztxg/RVG53weyj7vxFtOnezSdXzbt2zFvRqnZABcAps
         TDmxEoclhCFIkfh2vcKsApDgo8kbwZy9hhVm0j+1BYLvq9lc5jhoGvjKoCj/yWPhX83O
         uL8Q==
X-Gm-Message-State: APjAAAUFbXPW9MMJB0j0YeoqN13vbob3hzr8W0w4odstZF4fuWSXHyE7
        JYevYtppMgtoTXoZP20XBeGF4jKZwio=
X-Google-Smtp-Source: APXvYqyXdIT5Dg4s/eV3CSnaG9LPpzKRRbNNCt1sQ3eSWDjHKTpdFd7mNgsIpwYAOS7emMCHCE9MFQ==
X-Received: by 2002:adf:ed44:: with SMTP id u4mr145334wro.242.1559166178260;
        Wed, 29 May 2019 14:42:58 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id u19sm1421060wmu.41.2019.05.29.14.42.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 14:42:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 1/2] net: dsa: tag_8021q: Change order of rx_vid setup
Date:   Thu, 30 May 2019 00:42:30 +0300
Message-Id: <20190529214231.10485-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529214231.10485-1-olteanv@gmail.com>
References: <20190529214231.10485-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The 802.1Q tagging performs an unbalanced setup in terms of RX VIDs on
the CPU port. For the ingress path of a 802.1Q switch to work, the RX
VID of a port needs to be seen as tagged egress on the CPU port.

While configuring the other front-panel ports to be part of this VID,
for bridge scenarios, the untagged flag is applied even on the CPU port
in dsa_switch_vlan_add.  This happens because DSA applies the same flags
on the CPU port as on the (bridge-controlled) slave ports, and the
effect in this case is that the CPU port tagged settings get deleted.

Instead of fixing DSA by introducing a way to control VLAN flags on the
CPU port (and hence stop inheriting from the slave ports) - a hard,
perhaps intractable problem - avoid this situation by moving the setup
part of the RX VID on the CPU port after all the other front-panel ports
have been added to the VID.

Fixes: f9bbe4477c30 ("net: dsa: Optional VLAN-based port separation for switches without tagging")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

None.

 net/dsa/tag_8021q.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8ae48c7e1e76..4adec6bbfe59 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -128,10 +128,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 		u16 flags;
 
 		if (i == upstream)
-			/* CPU port needs to see this port's RX VID
-			 * as tagged egress.
-			 */
-			flags = 0;
+			continue;
 		else if (i == port)
 			/* The RX VID is pvid on this port */
 			flags = BRIDGE_VLAN_INFO_UNTAGGED |
@@ -150,6 +147,20 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 			return err;
 		}
 	}
+
+	/* CPU port needs to see this port's RX VID
+	 * as tagged egress.
+	 */
+	if (enabled)
+		err = dsa_port_vid_add(upstream_dp, rx_vid, 0);
+	else
+		err = dsa_port_vid_del(upstream_dp, rx_vid);
+	if (err) {
+		dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
+			rx_vid, port, err);
+		return err;
+	}
+
 	/* Finally apply the TX VID on this port and on the CPU port */
 	if (enabled)
 		err = dsa_port_vid_add(dp, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED);
-- 
2.17.1

