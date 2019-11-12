Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A598F8FDE
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKLMox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:53 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45979 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfKLMot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id z10so13056911wrs.12
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=htO3NaGF/rYsY0CnNr/FEqqtqUup384P1QEiCmmfNdQ=;
        b=GhXxar35mY6+jgHaa2PPOuAnIWE1ThNHHMx0TwSuAf9YTlOhwIO6cR0s8Kbu2raQqU
         3VTW8hKurdxwgliRVwmT1fsHBJmi1qDReoE1cjCOEP/NgfjliyqX1nlGeBAUN+e9NpZn
         /h0U/iYW2RQ1zSEbPLA+AE0wTa0yGSplcvlSL18ULwPNiVZlESo4SR7yCpGDYJwO54VY
         Zx5PVvLScR468J1l5NW8D6F60QmxAquTck//iHmP2Uow8TSLePXISuiyScY5bs9KqIVI
         pWj4nSZ+mlVCXcgqoKY8hRNPh9RlF/8AbQ3HQjF9xDU0sPhP/tj5w3KLcjqkAdWaWcSP
         91nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=htO3NaGF/rYsY0CnNr/FEqqtqUup384P1QEiCmmfNdQ=;
        b=aEac4hmTQqDZ+uDvAbQydNrfZ9zXyBtPVNJRqCFvBos+YIY/RuQsikvo/BgBkLR0BD
         Vj4SBcx5bJaA+uBP1a9iXLfruK7eZ2Fspy8zuR8284d8Pv8fKXXRopMVsw8oLIkSZ2kX
         aU/mLg8yYB0pwHZWm0jlACxC1TbHZGTvsU5C+Z1cMkkOW0/jzilIRw82iVsYcrOjYUZ1
         Hkz3rLTixyMFZAi7NubNtksLSnoXin+X+xkx4Gt18iwBeBJkhg646r85N3K1eTwSQAqF
         zIca2B6rhNq7xaf/SsiTCWa4gVgs6h98gEdDWd47EMd4pDcaAsE9VO6hDA+QscQCBVhh
         c2gw==
X-Gm-Message-State: APjAAAXatwsi+BqaRySP9IQIeJuUEroujV/8C4jtafJdzRicm45OXGtK
        4X+gdFSVdUlCD/+gkHeQO38=
X-Google-Smtp-Source: APXvYqydvis+oSRXnlvN4ATQutwGNc+Covc0uZZnGEsdkeEr+9QdgCdtwR8Ro7772QCANGqMfrPVgA==
X-Received: by 2002:a5d:4a50:: with SMTP id v16mr24202792wrs.85.1573562687033;
        Tue, 12 Nov 2019 04:44:47 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:46 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 06/12] net: mscc: ocelot: adjust MTU on the CPU port in NPI mode
Date:   Tue, 12 Nov 2019 14:44:14 +0200
Message-Id: <20191112124420.6225-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When using the NPI port, the DSA tag is passed through Ethernet, so the
switch's MAC needs to accept it as it comes from the DSA master. Increase
the MTU on the external CPU port to account for the length of the
injection header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 9 +++++++++
 drivers/net/ethernet/mscc/ocelot.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8b73d760dfa5..42da193a8240 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2230,9 +2230,18 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 	 * Only one port can be an NPI at the same time.
 	 */
 	if (cpu < ocelot->num_phys_ports) {
+		int mtu = VLAN_ETH_FRAME_LEN + OCELOT_TAG_LEN;
+
 		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
 			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
 			     QSYS_EXT_CPU_CFG);
+
+		if (injection == OCELOT_TAG_PREFIX_SHORT)
+			mtu += OCELOT_SHORT_PREFIX_LEN;
+		else if (injection == OCELOT_TAG_PREFIX_LONG)
+			mtu += OCELOT_LONG_PREFIX_LEN;
+
+		ocelot_port_set_mtu(ocelot, cpu, mtu);
 	}
 
 	/* CPU port Injection/Extraction configuration */
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 9159b0adf1e7..bdc9b1d34b81 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -65,6 +65,8 @@ struct frame_info {
 #define IFH_REW_OP_ORIGIN_PTP		0x5
 
 #define OCELOT_TAG_LEN			16
+#define OCELOT_SHORT_PREFIX_LEN		4
+#define OCELOT_LONG_PREFIX_LEN		16
 
 #define OCELOT_SPEED_2500 0
 #define OCELOT_SPEED_1000 1
-- 
2.17.1

