Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACE94DDE9
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 01:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbfFTX5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 19:57:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46004 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfFTX5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 19:57:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so5073532qtr.12
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=725QF/d7yfYfUMQu3Z2U819x6R6EClfKBO0Jx76jrw4=;
        b=ja8YK7EMM2pA9Qsk01rja5up35E7N/FT6L0cQrBO+Ul112YXl2fg1GBiAHTzytOVBe
         7QAgE6gZ34I03vF1Zl49OMR+lqqTRJRqlrP9GmpcCoNnhdnYn4sRT/trd394aOV1CF0w
         cYVYk2f4j8RMYub++ed7oiuEflPwCu39ac3HBBRqtMK+V49NbFVWscYHq6PKPfsxyt1l
         oHf87rYnKWBxcJm+pzBpxrNmHTsnz4hMokiTDk6xvYw4GGLKcNH1XZ9gtX5HKrdOmBNs
         4ogIahTHweA6l8Egz66C5ZXCk/uhiUQxw6oJ1d3qbWy3XVErBjIOrsbS/ytzEiOP6ajG
         Eokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=725QF/d7yfYfUMQu3Z2U819x6R6EClfKBO0Jx76jrw4=;
        b=mEl9AgiemJQHdF9kuhm5vXQcxeMIvVxWqRb9y3rKwU0QykrbRxSNOXQ00rgMsdKT93
         v0T2FfW5Up+6Hc5M26aMjZKJ/jEQEhu1NsXenW/ViX3LTmQ3nSAP9l8OQahUdxdK3JQf
         Ji56Ky01RumW9MhydgMgz1xk2cFkHY10S8ASWd+iZPcehRHrhdnbTSq9CO7sRpAKplmv
         gCSqjUXU0LR0qufJAZlXhifkLmISG0KWNVbLhGcS149hwAk8esnhzJ/oy5ILyFYEqDTs
         Yh+J5YoA9fpLDBKFIezNV1yF4BCBccCTM89owghXPfQZT3LD4WMZaWhgYhktzIoEMuSA
         /xSQ==
X-Gm-Message-State: APjAAAX0H1yMek0uL17luDiIizZPiRlF+ZLlEeUnTPCzcr25Fm7kLbEI
        bNAWOsknkZgWy+zir4kYMl66CKMXNyA=
X-Google-Smtp-Source: APXvYqwtnJqkI6j7yyHwLNxzGKCWA/mzxVzfkIfYryQWvEUU9Zf22q28En1kbGuJHkRX/rNLCcqLaA==
X-Received: by 2002:a0c:e6a2:: with SMTP id j2mr39953563qvn.190.1561075030997;
        Thu, 20 Jun 2019 16:57:10 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g35sm570100qtg.92.2019.06.20.16.57.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 16:57:10 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, idosch@mellanox.com,
        andrew@lunn.ch, davem@davemloft.net,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Date:   Thu, 20 Jun 2019 19:56:39 -0400
Message-Id: <20190620235639.24102-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for enabling or disabling the flooding of
unknown multicast traffic on the CPU ports, depending on the value
of the switchdev SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute.

This allows the user to prevent the CPU to be flooded with a lot of
undesirable traffic that the network stack needs to filter in software.

The bridge has multicast snooping enabled by default, hence CPU ports
aren't bottlenecked with arbitrary network applications anymore.
But this can be an issue in some scenarios such as pinging the bridge's
IPv6 address. Setting /sys/class/net/br0/bridge/multicast_snooping to
0 would restore unknown multicast flooding and thus fix ICMPv6. As
an alternative, enabling multicast_querier would program the bridge
address into the switch.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 19 +++++++++++++++++++
 net/dsa/slave.c    |  4 ++++
 3 files changed, 25 insertions(+)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a4853c22c2ff..54d838956499 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -163,6 +163,8 @@ int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 			      struct switchdev_trans *trans);
 int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 			  struct switchdev_trans *trans);
+int dsa_port_bridge_mc_disabled(const struct dsa_port *dp, bool mc_disabled,
+				struct switchdev_trans *trans);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan,
 		      struct switchdev_trans *trans);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d2b65e8dc60c..79d14c36ef9a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -261,6 +261,25 @@ int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 	return err;
 }
 
+int dsa_port_bridge_mc_disabled(const struct dsa_port *dp, bool mc_disabled,
+				struct switchdev_trans *trans)
+{
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+
+	if (switchdev_trans_ph_prepare(trans)) {
+		if (!ds->ops->port_egress_floods)
+			return -EOPNOTSUPP;
+
+		return 0;
+	}
+
+	/* When multicast snooping is disabled,
+	 * every multicast packet should be flooded to the CPU port.
+         */
+	return ds->ops->port_egress_floods(ds, port, true, mc_disabled);
+}
+
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index db58e748557d..9308ffa4f22c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -302,6 +302,10 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, trans);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
+		ret = dsa_port_bridge_mc_disabled(dp->cpu_dp,
+						  attr->u.mc_disabled, trans);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.22.0

