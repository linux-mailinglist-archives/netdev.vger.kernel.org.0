Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E7721203F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgGBJp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:45:28 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:26188 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGBJp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593683127; x=1625219127;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9tUmu3Sw3rOqTQH6B2QqulbAJeo7lfwvMHct9nObl+A=;
  b=ZrUwUShKF3kvhkOMn57+bYUfexPYLeKchmmztmBVetXaPh9Xh2Q9iw+s
   wlQGgRO+8nLwIqXJQ1I2b1o3CPm0zu4+z5GJ40kLpEdCu12Xo80fqRLl4
   CSWZSQkGxxMgQWRazsjKIDxZhcBQ+Kh4vpzKBL1KeDv88Pgnn5hpwt5rb
   mrzKvRsDWSwHVduvZSebnKwsxk/3mVlh+fiQ1uCdWCTcKklbEScgB06dt
   ntCml3UpLAiEV/lP9GLa4e+jC99c00an/KdHM2LRmIC91hQHOkCumauCu
   +TzrRC1ZAHRyRx2nfkat8ATNxYIafViwNPUe5aHFHvx7EZIGuTDJ4v2ui
   g==;
IronPort-SDR: /PaVc6AzY3x31tzJKEUag3hLapYqI781lYHFtiT4DiEEDPJqBJ5x8S1xjK5Eiy5H+wE0Q4JkBl
 PS6JWOWStk9nem4WMX95ywThPJrl6TZHGsWnO5Mf4rQsZV1ITlXvrVk+E8211BPW+Xo8XZxq8o
 z9mcORIL3mNzulYlhPFdVSUX9eGhdZ23BObTZbkYZC87RUgRvdGIfTe6zjFmPRi35IXTj2jPrb
 kXhAh0hxUtkKFS26EDOq5RC3LjPgWdoTcBXWyhpZpzoYUao/gVF7Bd17kgXUYlGKeyXyWKKVNn
 sSk=
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="78541808"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 02:45:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 02:45:05 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 02:44:41 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH net] net: dsa: microchip: set the correct number of ports
Date:   Thu, 2 Jul 2020 12:44:50 +0300
Message-ID: <20200702094450.1353917-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of ports is incorrectly set to the maximum available for a DSA
switch. Even if the extra ports are not used, this causes some functions
to be called later, like port_disable() and port_stp_state_set(). If the
driver doesn't check the port index, it will end up modifying unknown
registers.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 3 +++
 drivers/net/dsa/microchip/ksz9477.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 47d65b77caf7..7c17b0f705ec 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1268,6 +1268,9 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 			return -ENOMEM;
 	}
 
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->port_cnt;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 9a51b8a4de5d..8d15c3016024 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1588,6 +1588,9 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 			return -ENOMEM;
 	}
 
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->port_cnt;
+
 	return 0;
 }
 
-- 
2.25.1

