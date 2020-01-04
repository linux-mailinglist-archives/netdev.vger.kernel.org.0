Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26B01304E3
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 23:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgADWO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 17:14:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgADWO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jan 2020 17:14:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9vprpv7LINw0iEBwwHP/NWML19zO/oh4LkULSpYwb8Q=; b=1vYKUP6/Q6JEih51uDKa44QAn7
        m3AQGqH6NNRoO5/YZp0JMJvEUZ1ug94yrP/Z3EFZM+NmfupoL9oaG08QEIYJLc78mDZQ+84RwXLi1
        SlwbiUklznKiQBzyemYOej13LqPYk/GWJIikHxcOVPkiX0LE+oWti3MW2Kcb7ej3b37M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inrh9-0002i8-0w; Sat, 04 Jan 2020 23:14:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Chris Healy <cphealy@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net v2] net: dsa: mv88e6xxx: Preserve priority when setting CPU port.
Date:   Sat,  4 Jan 2020 23:14:51 +0100
Message-Id: <20200104221451.10379-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 6390 family uses an extended register to set the port connected to
the CPU. The lower 5 bits indicate the port, the upper three bits are
the priority of the frames as they pass through the switch, what
egress queue they should use, etc. Since frames being set to the CPU
are typically management frames, BPDU, IGMP, ARP, etc set the priority
to 7, the reset default, and the highest.

Fixes: 33641994a676 ("net: dsa: mv88e6xxx: Monitor and Management tables")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>

---
v2: Fix a couple of spelling errors.
---
 drivers/net/dsa/mv88e6xxx/global1.c | 5 +++++
 drivers/net/dsa/mv88e6xxx/global1.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 120a65d3e3ef..b016cc205f81 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -360,6 +360,11 @@ int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
 {
 	u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST;
 
+	/* Use the default high priority for management frames sent to
+	 * the CPU.
+	 */
+	port |= MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI;
+
 	return mv88e6390_g1_monitor_write(chip, ptr, port);
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index bc5a6b2bb1e4..5324c6f4ae90 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -211,6 +211,7 @@
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST		0x2000
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST		0x2100
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST		0x3000
+#define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI	0x00e0
 #define MV88E6390_G1_MONITOR_MGMT_CTL_DATA_MASK			0x00ff
 
 /* Offset 0x1C: Global Control 2 */
-- 
2.24.0

