Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29999119572
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfLJVVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:21:01 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:40405 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfLJVVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:21:00 -0500
Received: by mail-qv1-f67.google.com with SMTP id k10so3213702qve.7
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtJD3PdB/FMNuFQ+XD+4vKTZusrVALZiKrSm4mB8WGQ=;
        b=qUvKb9sWV3oNEU77nkCt78CD3Br0Xrn/vOCD7Rovg6S7KICfMPf6CJ6ZqTH6+IrGoj
         Is0Yx8djY8XjxPX/+3H6z3yuFVclSCUbqyCNAql8egtg70z7RhQu1dShhH5wEFmnoY5e
         mUHl1EkiNf4lu1P0zhvCk3UoIN0AdyIvNBegJiYnI1NcjcMmMlRdj8bH6c67vf7pclIb
         Wu0QuSR7OMdK65pMDEm6yrU6+QEe/qVJ3YUi+xivclmsQM02UJHP6a51Q8owIo0wlRr6
         +AdP3AjiBZUIO5uU3D0tedbbW4waanQqFp5cJv418F8zudxD+/CCg42NH/ilEDYb0Nrg
         u6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtJD3PdB/FMNuFQ+XD+4vKTZusrVALZiKrSm4mB8WGQ=;
        b=gU1Pk8XM5GgkiGK6cyYvGzNGVF4LH775swlbLiVoSokgeE1AOMytgNuHkGmoV22yJr
         KVObT++4gyHM0F83HOxeoH+rIAO9Fjx5mmQpj3MZvfPfkEVRZw0JRrNbUmpydDbF1eyT
         AM9tkrIMhIOH0K+2H3afWnSNL+trjQHOmheN7lwaaW0zA4lKRwetxNKk8RpQVXop6q4o
         oplA6Nj5cSx174mceohO52SPrfWc6Mo1Ppb3uJ9pofuQt0RFbhugRO2stcPn3P2NBvL7
         FFUNPocnibUe7bGlPg395+k9FKz0ggURQNOUMMFV3wbY8F6KuWfK81BPYtmIb9EhqLBu
         TM8w==
X-Gm-Message-State: APjAAAXR7Mdw7DDC0jhBIsI+h8UD6Qw8Wgt5goykv9lfLZGGTNWtDUs5
        vs5HbIRASpZEghDCM3UFKxQ=
X-Google-Smtp-Source: APXvYqyt8+4V+bhDq4IhcraE593a4Df/l8OvUPVxAclpFPOb4GBb3wNITBDp3e1+M4rPMe4Z2br1Ig==
X-Received: by 2002:a05:6214:4f2:: with SMTP id cl18mr31126357qvb.89.1576012859295;
        Tue, 10 Dec 2019 13:20:59 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s26sm1351160qkj.24.2019.12.10.13.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:20:58 -0800 (PST)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2] net: bridge: add STP xstats
Date:   Tue, 10 Dec 2019 16:20:49 -0500
Message-Id: <20191210212050.1470909-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds rx_bpdu, tx_bpdu, rx_tcn, tx_tcn, transition_blk,
transition_fwd xstats counters to the bridge ports copied over via
netlink, providing useful information for STP.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/uapi/linux/if_bridge.h | 10 ++++++++++
 net/bridge/br_netlink.c        | 10 ++++++++++
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_stp.c            | 15 +++++++++++++++
 net/bridge/br_stp_bpdu.c       |  4 ++++
 5 files changed, 41 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 1b3c2b643a02..e7f2bb782006 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -156,6 +156,15 @@ struct bridge_vlan_xstats {
 	__u32 pad2;
 };
 
+struct bridge_stp_xstats {
+	__u64 transition_blk;
+	__u64 transition_fwd;
+	__u64 rx_bpdu;
+	__u64 tx_bpdu;
+	__u64 rx_tcn;
+	__u64 tx_tcn;
+};
+
 /* Bridge multicast database attributes
  * [MDBA_MDB] = {
  *     [MDBA_MDB_ENTRY] = {
@@ -261,6 +270,7 @@ enum {
 	BRIDGE_XSTATS_UNSPEC,
 	BRIDGE_XSTATS_VLAN,
 	BRIDGE_XSTATS_MCAST,
+	BRIDGE_XSTATS_STP,
 	BRIDGE_XSTATS_PAD,
 	__BRIDGE_XSTATS_MAX
 };
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a0a54482aabc..d339cc314357 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1597,6 +1597,16 @@ static int br_fill_linkxstats(struct sk_buff *skb,
 		}
 	}
 
+	if (p) {
+		nla = nla_reserve_64bit(skb, BRIDGE_XSTATS_STP,
+					sizeof(p->stp_xstats),
+					BRIDGE_XSTATS_PAD);
+		if (!nla)
+			goto nla_put_failure;
+
+		memcpy(nla_data(nla), &p->stp_xstats, sizeof(p->stp_xstats));
+	}
+
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	if (++vl_idx >= *prividx) {
 		nla = nla_reserve_64bit(skb, BRIDGE_XSTATS_MCAST,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 36b0367ca1e0..f540f3bdf294 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -283,6 +283,8 @@ struct net_bridge_port {
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
+
+	struct bridge_stp_xstats	stp_xstats;
 };
 
 #define kobj_to_brport(obj)	container_of(obj, struct net_bridge_port, kobj)
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1f1410f8d312..6856a6d9282b 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -45,6 +45,17 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 		br_info(p->br, "port %u(%s) entered %s state\n",
 				(unsigned int) p->port_no, p->dev->name,
 				br_port_state_names[p->state]);
+
+	if (p->br->stp_enabled == BR_KERNEL_STP) {
+		switch (p->state) {
+		case BR_STATE_BLOCKING:
+			p->stp_xstats.transition_blk++;
+			break;
+		case BR_STATE_FORWARDING:
+			p->stp_xstats.transition_fwd++;
+			break;
+		}
+	}
 }
 
 /* called under bridge lock */
@@ -484,6 +495,8 @@ void br_received_config_bpdu(struct net_bridge_port *p,
 	struct net_bridge *br;
 	int was_root;
 
+	p->stp_xstats.rx_bpdu++;
+
 	br = p->br;
 	was_root = br_is_root_bridge(br);
 
@@ -517,6 +530,8 @@ void br_received_config_bpdu(struct net_bridge_port *p,
 /* called under bridge lock */
 void br_received_tcn_bpdu(struct net_bridge_port *p)
 {
+	p->stp_xstats.rx_tcn++;
+
 	if (br_is_designated_port(p)) {
 		br_info(p->br, "port %u(%s) received tcn bpdu\n",
 			(unsigned int) p->port_no, p->dev->name);
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 7796dd9d42d7..0e4572f31330 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -118,6 +118,8 @@ void br_send_config_bpdu(struct net_bridge_port *p, struct br_config_bpdu *bpdu)
 	br_set_ticks(buf+33, bpdu->forward_delay);
 
 	br_send_bpdu(p, buf, 35);
+
+	p->stp_xstats.tx_bpdu++;
 }
 
 /* called under bridge lock */
@@ -133,6 +135,8 @@ void br_send_tcn_bpdu(struct net_bridge_port *p)
 	buf[2] = 0;
 	buf[3] = BPDU_TYPE_TCN;
 	br_send_bpdu(p, buf, 4);
+
+	p->stp_xstats.tx_tcn++;
 }
 
 /*
-- 
2.24.0

