Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFAE080109
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406071AbfHBTfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:35:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43852 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406025AbfHBTfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:35:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so30769312qto.10
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S20mRfs21a6mJIf8+9PLUIhTZacEb9AVKCCiDw7cMBw=;
        b=PzV+CbRhKQ0ZgIG9yc+rFvM6u8X5v0FdlcQItQXnFGSODN++Gyg8k5j0cpEiqTH1Ql
         BqL85K5bOjCn4Zuhuezo40fYc4A+9RGqw9XY/KssDK7Rzx6VIew4NPxbKblDdboiKEoW
         r+yH6E2ESMum3JeyyGQEtP7RYAzTE8KpXucOj/GpV5gpaD9i2nzAAGDnVhTV91n3sZfv
         Jvi/Uxue+AOUlJRJfxWW8szK3N9CMCgy6T2ZM0Ff7fJa6nBXqJ/Bpt6XR+gs84ClDtSM
         NP3UarAiYkVel2U42aS1Qi7y5XqQRT6VImj1mn/VlYi95zMr2zBVColKuazyDkv/qnqM
         FwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S20mRfs21a6mJIf8+9PLUIhTZacEb9AVKCCiDw7cMBw=;
        b=hTcQ6QPTrkVI6uPv/0buFphbCN8PKjnKFLCaaA7Xtzau8yS+iqRSRNfbKHWe+nViId
         NMUGJ2CMZUB1I1QRBEBKHlEyxxjrS6sdJaNowQjiTkvtFzwYwYlb0uU4FdgeQmcO8nCq
         aJtiQqJRl+5Q+S1KhdZ4vFzsZLR/EGvBmhI5/hy3dgCqpME1jGOsIxSTFGs2pbokaTtw
         Ah2AIP/9TXcpEVHNBcPPJBHqzkiiIuJBrxTv2nqO19N6dcofrzDYGXbRtgySl4mz2Pic
         VH9hh9ztlWKnGQbOCvFDOz9EzO0PNSDmKY3V+Ig2BDt6EPJ553k2OTT4ON0v38ipGDK0
         Sh5A==
X-Gm-Message-State: APjAAAWyOPa4RSmcSgNjLKi/TW2dTAS5DvBFQZipQnEjXR+qPIqzc37F
        ABSXQ2jM6C63jYiRxLnEbzLVUJuTfCo=
X-Google-Smtp-Source: APXvYqy78FhbCCHgVmp8Sm+uhjGaev8N6qlcHQ6phHx4qHYbjcX6dLWwgsxrWWnvSLybrWoTEQfEfg==
X-Received: by 2002:ac8:2d69:: with SMTP id o38mr95588588qta.169.1564774506534;
        Fri, 02 Aug 2019 12:35:06 -0700 (PDT)
Received: from localhost (modemcable184.147-23-96.mc.videotron.ca. [96.23.147.184])
        by smtp.gmail.com with ESMTPSA id x7sm1025660qts.38.2019.08.02.12.35.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 12:35:05 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        linville@redhat.com, cphealy@gmail.com,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: dump CPU port regs through master
Date:   Fri,  2 Aug 2019 15:34:55 -0400
Message-Id: <20190802193455.17126-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802193455.17126-1-vivien.didelot@gmail.com>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the CPU port registers dump into the master interface registers
dump through ethtool, by nesting the ethtool_drvinfo and ethtool_regs
structures of the CPU port into the dump.

drvinfo->regdump_len will contain the full data length, while regs->len
will contain only the master interface registers dump length.

This allows for example to dump the CPU port registers on a ZII Dev
C board like this:

    # ethtool -d eth1
    0x004:                                              0x00000000
    0x008:                                              0x0a8000aa
    0x010:                                              0x01000000
    0x014:                                              0x00000000
    0x024:                                              0xf0000102
    0x040:                                              0x6d82c800
    0x044:                                              0x00000020
    0x064:                                              0x40000000
    0x084: RCR (Receive Control Register)               0x47c00104
        MAX_FL (Maximum frame length)                   1984
        FCE (Flow control enable)                       0
        BC_REJ (Broadcast frame reject)                 0
        PROM (Promiscuous mode)                         0
        DRT (Disable receive on transmit)               0
        LOOP (Internal loopback)                        0
    0x0c4: TCR (Transmit Control Register)              0x00000004
        RFC_PAUSE (Receive frame control pause)         0
        TFC_PAUSE (Transmit frame control pause)        0
        FDEN (Full duplex enable)                       1
        HBC (Heartbeat control)                         0
        GTS (Graceful transmit stop)                    0
    0x0e4:                                              0x76735d6d
    0x0e8:                                              0x7e9e8808
    0x0ec:                                              0x00010000
    .
    .
    .
    88E6352  Switch Port Registers
    ------------------------------
    00: Port Status                            0x4d04
          Pause Enabled                        0
          My Pause                             1
          802.3 PHY Detected                   0
          Link Status                          Up
          Duplex                               Full
          Speed                                100 or 200 Mbps
          EEE Enabled                          0
          Transmitter Paused                   0
          Flow Control                         0
          Config Mode                          0x4
    01: Physical Control                       0x003d
          RGMII Receive Timing Control         Default
          RGMII Transmit Timing Control        Default
          200 BASE Mode                        100
          Flow Control's Forced value          0
          Force Flow Control                   0
          Link's Forced value                  Up
          Force Link                           1
          Duplex's Forced value                Full
          Force Duplex                         1
          Force Speed                          100 or 200 Mbps
    .
    .
    .

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/master.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 4b52f8bac5e1..a8e52c9967f4 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -8,6 +8,70 @@
 
 #include "dsa_priv.h"
 
+static int dsa_master_get_regs_len(struct net_device *dev)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	const struct ethtool_ops *ops = cpu_dp->orig_ethtool_ops;
+	struct dsa_switch *ds = cpu_dp->ds;
+	int port = cpu_dp->index;
+	int ret = 0;
+	int len;
+
+	if (ops->get_regs_len) {
+		len = ops->get_regs_len(dev);
+		if (len < 0)
+			return len;
+		ret += len;
+	}
+
+	ret += sizeof(struct ethtool_drvinfo);
+	ret += sizeof(struct ethtool_regs);
+
+	if (ds->ops->get_regs_len) {
+		len = ds->ops->get_regs_len(ds, port);
+		if (len < 0)
+			return len;
+		ret += len;
+	}
+
+	return ret;
+}
+
+static void dsa_master_get_regs(struct net_device *dev,
+				struct ethtool_regs *regs, void *data)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	const struct ethtool_ops *ops = cpu_dp->orig_ethtool_ops;
+	struct dsa_switch *ds = cpu_dp->ds;
+	struct ethtool_drvinfo *cpu_info;
+	struct ethtool_regs *cpu_regs;
+	int port = cpu_dp->index;
+	int len;
+
+	if (ops->get_regs_len && ops->get_regs) {
+		len = ops->get_regs_len(dev);
+		if (len < 0)
+			return;
+		regs->len = len;
+		ops->get_regs(dev, regs, data);
+		data += regs->len;
+	}
+
+	cpu_info = (struct ethtool_drvinfo *)data;
+	strlcpy(cpu_info->driver, "dsa", sizeof(cpu_info->driver));
+	data += sizeof(*cpu_info);
+	cpu_regs = (struct ethtool_regs *)data;
+	data += sizeof(*cpu_regs);
+
+	if (ds->ops->get_regs_len && ds->ops->get_regs) {
+		len = ds->ops->get_regs_len(ds, port);
+		if (len < 0)
+			return;
+		cpu_regs->len = len;
+		ds->ops->get_regs(ds, port, cpu_regs, data);
+	}
+}
+
 static void dsa_master_get_ethtool_stats(struct net_device *dev,
 					 struct ethtool_stats *stats,
 					 uint64_t *data)
@@ -147,6 +211,8 @@ static int dsa_master_ethtool_setup(struct net_device *dev)
 	if (cpu_dp->orig_ethtool_ops)
 		memcpy(ops, cpu_dp->orig_ethtool_ops, sizeof(*ops));
 
+	ops->get_regs_len = dsa_master_get_regs_len;
+	ops->get_regs = dsa_master_get_regs;
 	ops->get_sset_count = dsa_master_get_sset_count;
 	ops->get_ethtool_stats = dsa_master_get_ethtool_stats;
 	ops->get_strings = dsa_master_get_strings;
-- 
2.22.0

