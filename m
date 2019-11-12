Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C41F9C36
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfKLVZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:25:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40602 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLVZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:25:22 -0500
Received: by mail-wr1-f68.google.com with SMTP id i10so20169736wrs.7
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/Bc9mD0su6y/qMwnSap3fGfdGalbmMm43pLfTXBSjvE=;
        b=Mu8ETqT7ONL/N4WWBxCn63ynw1xcAAMJfm6yc/3QvObzzkcYQpdzm3oNsdRf12uO1k
         KXu4NdOUqflEhWtDtUcU4K2ahDe+MhNn5XWulN0UG/OhEOV1e/6xZweBCDvjdxJWm34J
         BdvJ2uhiBmnphEgzAJcfU8lT4uh3SplNBaogWXK0K8KjkQAvmi6ZgCb4H+r6VyST/OvY
         HRIb6fNZtPktfTdodixA+xbeaPrZKVvyqefyffXshMgikl37AnDlfv+87Yt2gmjy94LJ
         WsdzTB4tnvAxmlwX/Tjghvpk2AU11mr2KCiw6/HOdbI69PVjcUDust7rZ+bgUO3+k/0x
         Ki5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/Bc9mD0su6y/qMwnSap3fGfdGalbmMm43pLfTXBSjvE=;
        b=bVIqHqmSXa1DZ/p96BJcuVykXAWLmjizZeH+91drZA32jcdNFc54Nlv/z+LpmAnc79
         ozypQoTqWm8kAQwn9XzRd8RpcL0IhH74fXBgqQCsnYFbW6uNnuYnM0OnhD3nQMOrW/lw
         HdbvaXSrTZLVAiDeiQaNGfB9PguC1jSXUkZL75rMXw3u/K3mJFkk4we9otZEqaSI6u3J
         0lq7tMVvzj7Kg2Q96ezOd8Z8lbvO7e/tMrTPefEGiYI2X77HwJl/BjKvpH2Mo5IX+/1T
         Ok7nEajixK3QrG6H/+dn81oUUDVwF0hrZTYVN1zePzryRIchOQ4Vb08X4Nxh5qsB9OiA
         WzEw==
X-Gm-Message-State: APjAAAXA7+Uqn34ylkKg5st9W3R9Ee7+2DZOTIjDZrTnpW5LzoxR125u
        SDTKXaBtoOyeESQkBYw3dUQ1zLOX
X-Google-Smtp-Source: APXvYqzeq7YZisDW9dzGegpcNRDWOIJccmxE266dz5qZ7oSdSFPaJfARJ3rp4AcmHoZwAGBtuSRmzg==
X-Received: by 2002:a5d:6607:: with SMTP id n7mr14270387wru.133.1573593920650;
        Tue, 12 Nov 2019 13:25:20 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w132sm8758291wma.6.2019.11.12.13.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:25:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: sja1105: Make HOSTPRIO a kernel config
Date:   Tue, 12 Nov 2019 23:25:15 +0200
Message-Id: <20191112212515.6663-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately with this hardware, there is no way to transmit in-band
QoS hints with management frames (i.e. VLAN PCP is ignored). The traffic
class for these is fixed in the static config (which in turn requires a
reset to change).

With the new ability to add time gates for individual traffic classes,
there is a real danger that the user might unknowingly turn off the
traffic class for PTP, BPDUs, LLDP etc.

So we need to manage this situation the best we can. There isn't any
knob in Linux for this, and changing it at runtime probably isn't worth
it either. So just make the setting loud enough by promoting it to a
Kconfig, which the user can customize to their particular setup.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/dsa/sja1105.rst |  4 ++--
 drivers/net/dsa/sja1105/Kconfig          | 11 +++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c   |  2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index eef20d0bcf7c..2eaa6edf9c5b 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -181,8 +181,8 @@ towards the switch, with the VLAN PCP bits set appropriately.
 Management traffic (having DMAC 01-80-C2-xx-xx-xx or 01-19-1B-xx-xx-xx) is the
 notable exception: the switch always treats it with a fixed priority and
 disregards any VLAN PCP bits even if present. The traffic class for management
-traffic has a value of 7 (highest priority) at the moment, which is not
-configurable in the driver.
+traffic is configurable through ``CONFIG_NET_DSA_SJA1105_HOSTPRIO``, which by
+default has a value of 7 (highest priority).
 
 Below is an example of configuring a 500 us cyclic schedule on egress port
 ``swp5``. The traffic class gate for management traffic (7) is open for 100 us,
diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 0fe1ae173aa1..ac63054f578e 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -17,6 +17,17 @@ tristate "NXP SJA1105 Ethernet switch family support"
 	    - SJA1105R (Gen. 2, SGMII, No TT-Ethernet)
 	    - SJA1105S (Gen. 2, SGMII, TT-Ethernet)
 
+config NET_DSA_SJA1105_HOSTPRIO
+	int "Traffic class for management traffic"
+	range 0 7
+	default 7
+	depends on NET_DSA_SJA1105
+	help
+	  Configure the traffic class which will be used for management
+	  (link-local) traffic injected and trapped to/from the CPU.
+
+	  Higher is better as long as you care about your PTP frames.
+
 config NET_DSA_SJA1105_PTP
 	bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
 	depends on NET_DSA_SJA1105
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b60224c55244..907babeb8c8a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -388,7 +388,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		/* Priority queue for link-local management frames
 		 * (both ingress to and egress from CPU - PTP, STP etc)
 		 */
-		.hostprio = 7,
+		.hostprio = CONFIG_NET_DSA_SJA1105_HOSTPRIO,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
 		.incl_srcpt1 = false,
-- 
2.17.1

