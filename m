Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5042442566B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242511AbhJGPPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:15:10 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:64901 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242457AbhJGPO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633619583; x=1665155583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PCgLNOKvD+D+esrSdKp75+KoUpZDvfGF6kQGs6L3IMo=;
  b=qkzg40QDPLD4vqrnm9dgZgPEsvVo972rnFGM080B/oEumenwNSY2zfeW
   II7j60f7U/anLSmUGvSCsR9xRAOh+wOUtt8mzMkKSPrTWbho3/uwJQU/0
   3gGTzhdmnmYWLiA5z2icrD9j063IQVlMjUPY6c0TNj3Xfmmh4JJ8NzCL3
   0r/0Zdmoz4+W6XDuGXtFJ+2m0ap8OIMGAjl8RDMR+qoqKLDOmd1o///qN
   04aHSWv0IUG42pzdnzKMoCk+B44cs5YQ9ey2AGRhxhctjbM7BvcGZowgQ
   Fe6YP9dVMNYv99nCydXXzhYYSTieZNtZ1sU21L/lH3Imv1dv+R3oQ9WOB
   g==;
IronPort-SDR: Sa60hkeF8PRZ67wTYQPTVOl80YyMZv8yk65RYvlUA1Y9vFOR83D80GhqBCx7g6taAYoh4goEKo
 NyA0NNopV4vWxNeU6Y1A/++fpbB1c7VNZgMF77KN4esOeBF+znjzMCTfafMWrfwch5pp+eh8pj
 BdkZWpFKbu8gXG/vWDFp0EmVjBRuFe6xezNpyslFNHINP/THgHN9VsCy46i4Ocv+KoE7TxmmUr
 rFBP8VRh88lfTlEwxK8yVbeF1enGsZtVWJZDiT0uUiqg0ojtcJGf0yTQv2Y4TFnrl4RqiW7iU3
 sESfhc2YWqPoKgSHZsdET4uw
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="134608484"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 08:13:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 08:12:59 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 7 Oct 2021 08:12:54 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v4 net-next 07/10] net: dsa: microchip: add support for ethtool port counters
Date:   Thu, 7 Oct 2021 20:41:57 +0530
Message-ID: <20211007151200.748944-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
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
index df29d1ed98b5..f2f42b3bdb31 100644
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
@@ -472,6 +487,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
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

