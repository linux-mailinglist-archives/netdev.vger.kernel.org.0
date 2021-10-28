Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D88A43E65E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJ1Qor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:44:47 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39670 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhJ1Qoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635439332; x=1666975332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=64s30kDz1ZBo74A+RcUlPbw6No5OGcdT/hbtUXfasKg=;
  b=GJdtED8KaNRAkrs5I5kFnLR0Gpv9nFEA6cSIttxqpDnUlFIUUscVNwmo
   CaAEEYn/jeRppRBUMO7P29vr6mRg9tgbhFL3jZ2BslQWaX5vM2F3ACJt5
   3zyQrc6UzBKrWkv3nvpxvdZEred6jiGQnmU4vm1Q2ICbHV1lNX7GoedYP
   OBODXme3BtqmDVO4M2u4eIv12v1JqVWh1v+g9fDDJJYRJ81F4Ox/eG2ec
   pwk1wIjVXFjzE8lhoswGlp/PG+3atArzh0uGv0T/TBD6/sj7FpakTmac+
   ly9HFkvB37VPW9iKd0lT3dfO5SlDjf8c383nHr/QXhFIsxlE9HVodELID
   g==;
IronPort-SDR: 8F7bOQSk6Y2HtM7Qvlck/6RpzrlIABvm4sqmyte6pX48Wnr2pjXHqZn/zRqLAgwQhWXHszFMi+
 jSChso+My4op29EBE2QqFEp/twiYqJsvfiIii+QBQAXHbCfktWVOU83GE2eJksbhhsf32wNc3d
 oazc9looJfAulPLRJYyEpmDvPOpwhGGL3mis31kodhrsbbCMA9te+CtozOvSgzCR2UBqGhJpV+
 4PfZ5kVNTyznpjbLnhgna4UI1+8KL9WlwatFM6HTlPC0Iqwx7UeY5iprtpq6CzPLFSntrkjRFj
 5wV/dH4c13LfktPHNzd2WQEY
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="149906240"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 09:42:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 09:42:08 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 09:42:01 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v5 net-next 07/10] net: dsa: microchip: add support for ethtool port counters
Date:   Thu, 28 Oct 2021 22:11:08 +0530
Message-ID: <20211028164111.521039-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
References: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
along with relevant lan937x hooks for KSZ common layer and added
support for get_strings()

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 5dfd60fbc322..0976a95851c0 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -45,6 +45,21 @@ static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
 	return lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
+static void lan937x_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+				uint8_t *buf)
+{
+	struct ksz_device *dev = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < dev->mib_cnt; i++) {
+		memcpy(buf + i * ETH_GSTRING_LEN, lan937x_mib_names[i].string,
+		       ETH_GSTRING_LEN);
+	}
+}
+
 static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
@@ -426,6 +441,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.phy_read = lan937x_phy_read16,
 	.phy_write = lan937x_phy_write16,
 	.port_enable = ksz_enable_port,
+	.get_strings = lan937x_get_strings,
+	.get_ethtool_stats = ksz_get_ethtool_stats,
+	.get_sset_count = ksz_sset_count,
 	.port_bridge_join = ksz_port_bridge_join,
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
-- 
2.27.0

