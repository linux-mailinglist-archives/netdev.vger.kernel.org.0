Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B2B2A3D3B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgKCHLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgKCHLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:11:36 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7C5C0617A6;
        Mon,  2 Nov 2020 23:11:36 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604387494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=surYfHlM1ozYVHj2lqfFFLTGCzYqEboTB+HIxbPBChg=;
        b=oNMSnnT1XY7bhVkRHZsV4zLJyRGJseLrDuJW4EkW3CO3aAAJ8VvvWANK+WtnFTGWQw4x4o
        kqX9VDqinlrmOoSpXbmb9L9Ntmv5Y3XqzAAkA7ajKUBM5CNohaG6Ab72g2n47pW/rYtwCr
        zZEZgHd+g9S1ro9cKEXuvm9CNo+R1BIgoViCHOKGyHcFfpUqEizoZRfuTuGT9+xsCqx0lF
        FDtZPJO5j+hB5/YTXyy4LE26AnHmdvMR02Gt05rxyy8ODddmLi/jzNIekGYc8WSdXTwsZB
        k2fM05yBekQWh2ztPsv3iAED1X+hZrz+07uvr+7gk3WPqxl6Cqss2YSyeDcirA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604387494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=surYfHlM1ozYVHj2lqfFFLTGCzYqEboTB+HIxbPBChg=;
        b=CX1apcAS6+HjBWQkUgRrRPFzMl8YbzcOoTHyhbiP5SUTfrUYt+x6wkMhXHy5YW+bBj+V1T
        wQsgbohopsPgUgCw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v8 2/8] net: dsa: Give drivers the chance to veto certain upper devices
Date:   Tue,  3 Nov 2020 08:10:55 +0100
Message-Id: <20201103071101.3222-3-kurt@linutronix.de>
In-Reply-To: <20201103071101.3222-1-kurt@linutronix.de>
References: <20201103071101.3222-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some switches rely on unique pvids to ensure port separation in
standalone mode, because they don't have a port forwarding matrix
configurable in hardware. So, setups like a group of 2 uppers with the
same VLAN, swp0.100 and swp1.100, will cause traffic tagged with VLAN
100 to be autonomously forwarded between these switch ports, in spite
of there being no bridge between swp0 and swp1.

These drivers need to prevent this from happening. They need to have
VLAN filtering enabled in standalone mode (so they'll drop frames tagged
with unknown VLANs) and they can only accept an 8021q upper on a port as
long as it isn't installed on any other port too. So give them the
chance to veto bad user requests.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
[Kurt: Pass info instead of ptr]
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h |  6 ++++++
 net/dsa/slave.c   | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 04e93bafb7bd..4e60d2610f20 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -536,6 +536,12 @@ struct dsa_switch_ops {
 	void	(*get_regs)(struct dsa_switch *ds, int port,
 			    struct ethtool_regs *regs, void *p);
 
+	/*
+	 * Upper device tracking.
+	 */
+	int	(*port_prechangeupper)(struct dsa_switch *ds, int port,
+				       struct netdev_notifier_changeupper_info *info);
+
 	/*
 	 * Bridge integration
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c6806eef906f..59c80052e950 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2032,10 +2032,22 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER: {
 		struct netdev_notifier_changeupper_info *info = ptr;
+		struct dsa_switch *ds;
+		struct dsa_port *dp;
+		int err;
 
 		if (!dsa_slave_dev_check(dev))
 			return dsa_prevent_bridging_8021q_upper(dev, ptr);
 
+		dp = dsa_slave_to_port(dev);
+		ds = dp->ds;
+
+		if (ds->ops->port_prechangeupper) {
+			err = ds->ops->port_prechangeupper(ds, dp->index, info);
+			if (err)
+				return notifier_from_errno(err);
+		}
+
 		if (is_vlan_dev(info->upper_dev))
 			return dsa_slave_check_8021q_upper(dev, ptr);
 		break;
-- 
2.20.1

