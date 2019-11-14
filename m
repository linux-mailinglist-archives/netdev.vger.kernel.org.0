Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA7FC97B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKNPEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45087 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfKNPEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id z10so6817751wrs.12
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dL1tbTMOxMOwni4mK2EyUD3j/p1IkTd8YUEGJtmDyNA=;
        b=OCcZmQlsYn56EvgIKslCVKu3um9JIyH6Z4TfirzSJnDfv0+cjWMRiXKBOlSojgEIZg
         kp1RCzPaYlGjOIR/78yh/TZgNLNAQXHvPihJ3UUtBUqTLfJgBzf0D2BSKSJpgd4wxPyQ
         X3PWdWMEpXq/TrBo2v7qYdz+hBZAJpABpj4Bmmg1vpi8hNOLusTdQZHLl9BBP4usMQYC
         rdMwd7cjPypusMlp5kPgBDDaRLP7wfa7a+SeoGAU8ukFtI0m5PH0iY0heD5mrqTZ1Crh
         XBnaDPXbM5dDBslvSv9Fndlt2WxgrV6fEbghHfV6GGSSPPMv1STBEZfQWGE+b9rLc6AX
         OuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dL1tbTMOxMOwni4mK2EyUD3j/p1IkTd8YUEGJtmDyNA=;
        b=DyW37BPRLMWqDVfp8ckizitAIKZKBPkaGY1x+VqCue/oPbj3Ku0NtLNBSVBGZJTgIA
         NvDEW2RxoEwmNjU68VXQO0DIkc35+BKLgIXXM/2yMegJvHHPLK43uvsru/+J/0Ye6Wk1
         P07yubpFezR1OUHI5HvzNVQMsTYFCZ+gRwntD11mvhUwbpkYGUBrP3IlSvmxs4MBfGtV
         sFg8Rb9QKn+brafSeLzxmXaIhGejhdreSsuwlUGjIGdld5aRJIYrp4RLUpDDurFMPv3o
         L4SXW7fqflFZOTB7ykYgburMztPuIfBBaPXtdjGEydgTCFbklEVbOM3cc/AUIDl9ZRpS
         T2Sw==
X-Gm-Message-State: APjAAAXfnbd74WHuRXHMiTpFNkCMw27f5u3U6cGx4I5bsLSkVUE46gTj
        PHqIMynOuy1bGHunqzdmTLQ=
X-Google-Smtp-Source: APXvYqxYD6o5kALIXsVmJojbD5lcVTAiXVtex14Zz74VMczh0BJ1Ya9zAMzb2bm+oHA/V0VHb/NLWg==
X-Received: by 2002:a5d:640b:: with SMTP id z11mr8370357wru.195.1573743859852;
        Thu, 14 Nov 2019 07:04:19 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 06/11] net: mscc: ocelot: adjust MTU on the CPU port in NPI mode
Date:   Thu, 14 Nov 2019 17:03:25 +0200
Message-Id: <20191114150330.25856-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When using the NPI port, the DSA tag is passed through Ethernet, so the
switch's MAC needs to accept it as it comes from the DSA master. Increase
the MTU on the external CPU port to account for the length of the
injection header.

Without this patch, MTU-sized frames are dropped by the switch's CPU
port on xmit, which is especially obvious in TCP sessions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

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

