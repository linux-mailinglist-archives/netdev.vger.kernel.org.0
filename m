Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F133229E186
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgJ2CBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgJ1Vt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:49:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F72C0613D1;
        Wed, 28 Oct 2020 14:49:28 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603870981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+V3E0mNbqmC+z3DHzjYNErh3LMSMmsuM3JkFFcoNFcM=;
        b=AwXkRw7dHxas8UvK7LuAsShNF6Ia9sFfyzkFXFoXcWcFXZoj9jREbAiRO4I6sNV1jNXElZ
        amRKPZZIt8CQed7Na0WuS+juxYmBaQ3dw8X7zRgU+WCWUYNil73BlZ/n452U+5DkdMbPMh
        V7d6dK6l7nRg/UZgFD59GPu/+Ry6v+nNa8URZPIVrfUxYSz3a7qnb4hAvcsRfGwhelw5DJ
        u+g9a/BX3ZtYSkC+hY8C/4/33MrB6IxvhA/NSd+Q3lXrOkyw6wNF/M1dKWk3DzF1YOqI0H
        JcKx0LimoFjxLnaewnwCSiMLDdQ8ViDClLGNao454sC1ySs3DQPKGJfnHr5OXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603870981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+V3E0mNbqmC+z3DHzjYNErh3LMSMmsuM3JkFFcoNFcM=;
        b=3eGVq149Bb4Vs+VHIzhKhW/xY6OSWhRvBxdb8xhE49rgmpBBnyMP1r3IbA7oXxQk/X9yAa
        0uWalw/44ON9MkCg==
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
Subject: [PATCH net-next v7 2/8] net: dsa: Give drivers the chance to veto certain upper devices
Date:   Wed, 28 Oct 2020 08:42:15 +0100
Message-Id: <20201028074221.29326-3-kurt@linutronix.de>
In-Reply-To: <20201028074221.29326-1-kurt@linutronix.de>
References: <20201028074221.29326-1-kurt@linutronix.de>
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
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
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
index 3bc5ca40c9fb..1919a025c06f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1987,10 +1987,22 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
+			err = ds->ops->port_prechangeupper(ds, dp->index, ptr);
+			if (err)
+				return notifier_from_errno(err);
+		}
+
 		if (is_vlan_dev(info->upper_dev))
 			return dsa_slave_check_8021q_upper(dev, ptr);
 		break;
-- 
2.20.1

