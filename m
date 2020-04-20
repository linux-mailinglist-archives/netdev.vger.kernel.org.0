Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66461B0F93
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgDTPM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:12:27 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:24412 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730266AbgDTPMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587395544; x=1618931544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ftp7xSwi7rxzsVo0k0Kw+rDFAUz/DiSW/6uUfIvkmrM=;
  b=a+MI3BLt+4aD1ZfwbyTLnlwRYNMHiKdQg+d972QUC3dI1tOx/mvlbmc+
   PXsVZd/0AL4XOM0QtV/VRGgrKxvZCZ32nQgCJgWaOmtzgsYgVMtt4RmOA
   jOZhkD1MraewOtMedzFG9gPA3ptfs+WgeT3UG/a0US05DjmhrmDR2M+Jz
   Jnjn+keNhv8HpkGCVJTqDBq6gCaJk5HfeuH4WVtqUCsSI5snv7r7/8vcX
   vDaQvRtUk8bEsVKNYTHFY1COB/Ist4OkD8kZalr1ckLxHzRhP/NiugYLK
   Gxhz3NuoS1HdjHPWTCssVmV7vTDILsxY48kJypg1U4+67h+HPTSR46q6O
   g==;
IronPort-SDR: uEAoTSkFU6kmXKmm06xIfurVoJPXDrvTgWOHzJFTa1YtBq1vfEe1yki5MVDtR0gT5nbevzZPqb
 Ca47M3UTTk8xvszhA36upuVHzB3h9kPZ2etDhRZDHXWKDDZVVHe3jDdU1m3rQiybZuhTUFEFJA
 xjIBlVDwPhsoCR3MtJNUzM46hxrpP/KS+ZdV2EPecJDNSJhDoRNNCaSqaoEtnPwCWxAurzuuOu
 CoSfPIgX8ZKSRC1Fqx90Uq/lURKVWWXG+wnydyFFMY0/77IKcLA9BkvMx5QR111LQyur0jrnr1
 9cA=
X-IronPort-AV: E=Sophos;i="5.72,406,1580799600"; 
   d="scan'208";a="9780084"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2020 08:12:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 08:11:54 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 20 Apr 2020 08:11:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 13/13] net: bridge: Add checks for enabling the STP.
Date:   Mon, 20 Apr 2020 17:09:47 +0200
Message-ID: <20200420150947.30974-14-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420150947.30974-1-horatiu.vultur@microchip.com>
References: <20200420150947.30974-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not possible to have the MRP and STP running at the same time on the
bridge, therefore add check when enabling the STP to check if MRP is already
enabled. In that case return error.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_ioctl.c    |  3 +--
 net/bridge/br_netlink.c  |  4 +++-
 net/bridge/br_private.h  |  3 ++-
 net/bridge/br_stp.c      |  6 ++++++
 net/bridge/br_stp_if.c   | 11 ++++++++++-
 net/bridge/br_sysfs_br.c |  4 +---
 6 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index ae22d784b88a..5e71fc8b826f 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -242,8 +242,7 @@ static int old_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
-		br_stp_set_enabled(br, args[1]);
-		ret = 0;
+		ret = br_stp_set_enabled(br, args[1], NULL);
 		break;
 
 	case BRCTL_SET_BRIDGE_PRIORITY:
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 52f7bbd3f382..dfdf076616c6 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1112,7 +1112,9 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_STP_STATE]) {
 		u32 stp_enabled = nla_get_u32(data[IFLA_BR_STP_STATE]);
 
-		br_stp_set_enabled(br, stp_enabled);
+		err = br_stp_set_enabled(br, stp_enabled, extack);
+		if (err)
+			return err;
 	}
 
 	if (data[IFLA_BR_PRIORITY]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index bbc496fcb181..5c24ff92352c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1287,7 +1287,8 @@ int br_set_ageing_time(struct net_bridge *br, clock_t ageing_time);
 /* br_stp_if.c */
 void br_stp_enable_bridge(struct net_bridge *br);
 void br_stp_disable_bridge(struct net_bridge *br);
-void br_stp_set_enabled(struct net_bridge *br, unsigned long val);
+int br_stp_set_enabled(struct net_bridge *br, unsigned long val,
+		       struct netlink_ext_ack *extack);
 void br_stp_enable_port(struct net_bridge_port *p);
 void br_stp_disable_port(struct net_bridge_port *p);
 bool br_stp_recalculate_bridge_id(struct net_bridge *br);
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1f14b8455345..3e88be7aa269 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -36,6 +36,12 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 	};
 	int err;
 
+	/* Don't change the state of the ports if they are driven by a different
+	 * protocol.
+	 */
+	if (p->flags & BR_MRP_AWARE)
+		return;
+
 	p->state = state;
 	err = switchdev_port_attr_set(p->dev, &attr);
 	if (err && err != -EOPNOTSUPP)
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index d174d3a566aa..a42850b7eb9a 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -196,10 +196,17 @@ static void br_stp_stop(struct net_bridge *br)
 	br->stp_enabled = BR_NO_STP;
 }
 
-void br_stp_set_enabled(struct net_bridge *br, unsigned long val)
+int br_stp_set_enabled(struct net_bridge *br, unsigned long val,
+		       struct netlink_ext_ack *extack)
 {
 	ASSERT_RTNL();
 
+	if (br_mrp_enabled(br)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "STP can't be enabled if MRP is already enabled\n");
+		return -EINVAL;
+	}
+
 	if (val) {
 		if (br->stp_enabled == BR_NO_STP)
 			br_stp_start(br);
@@ -207,6 +214,8 @@ void br_stp_set_enabled(struct net_bridge *br, unsigned long val)
 		if (br->stp_enabled != BR_NO_STP)
 			br_stp_stop(br);
 	}
+
+	return 0;
 }
 
 /* called under bridge lock */
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 9ab0f00b1081..7db06e3f642a 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -126,9 +126,7 @@ static ssize_t stp_state_show(struct device *d,
 
 static int set_stp_state(struct net_bridge *br, unsigned long val)
 {
-	br_stp_set_enabled(br, val);
-
-	return 0;
+	return br_stp_set_enabled(br, val, NULL);
 }
 
 static ssize_t stp_state_store(struct device *d,
-- 
2.17.1

