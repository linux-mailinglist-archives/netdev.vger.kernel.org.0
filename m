Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B22511C1DC
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfLLBHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:07:24 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40173 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfLLBHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:07:24 -0500
Received: by mail-qk1-f193.google.com with SMTP id c17so239196qkg.7
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FupJ3RGGSuXqZLNq9OYkiWJfWzpWGpZdY0+xiHFNf5k=;
        b=PjjiqJD70gViXxHlckRfHszeRsbEJIdein9bLpB5qNeYEkSfEoTyWW9wkU27svoDy0
         0mxU/QUmL6fRlJtD0dKcT/Q9P5+Ovr2iasAgSLBLpK5Mdc2YSJWsqNsP8Adqs4jmSIb6
         zUPRkCxxbBPNlANZHRj+fZcJtOM/fWE5aHguHGBChkGGJX6KOW4ZXO597JCrxEK3Cyh4
         jj3rxyymrXrUObd0sw+sFVJBltdo67iqcrdu35p/12jQDm6ByLD3HfVecZkA2e6SWWRH
         Z8Qr1Va2idjdJxmpP1U77twQjydNksoo9NtHmK3QLmB9pbbRoOk+GouyAzdUstI00J2B
         Yf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FupJ3RGGSuXqZLNq9OYkiWJfWzpWGpZdY0+xiHFNf5k=;
        b=Xp1SgjvVyEjCSYLNzIeRIs6OrZboeUVhOLLw26o0pr46FQForzUhby1hjPtLF7fQTK
         KqcFqC0WPE4olvWfn/oeSgFPWhVvTexKFte2N/Yxl66G0/L1Fp5rvjCwN19yFz+FzIKN
         CbUWkXdi/C7NRUBDhq6BgPCDKYZURL8tJzEy3gJqqOoQ/96I1w0BD7uFFndtNaeAnY2u
         aAcLhC5AqG1utLpqyEndt1o6KJqwtdNzDrxvBD6DrUnq52Wyc8W3FwEiB407ZtNkdIW5
         rMVGIupwP7EGcn/cF7s/pNn3o2TR/NeG9sA1Dfm6xhYSzd7toRoxtqGMrJylfs3bIVnV
         bjMw==
X-Gm-Message-State: APjAAAVwcP5almd7G+4pORx7ievyoHXaqIHVXnEl8xzZoOP13K+cJw/6
        5Lp9Sutv4hb5IJCAogeiu+rut9pY
X-Google-Smtp-Source: APXvYqxGprr/mAqF6JwMzrw9GeYyV1ZvN2/gkQuSUvX6dGvRZqrZvRbXveEiLEf/uH2nVDK2ZK0gZg==
X-Received: by 2002:a05:620a:b19:: with SMTP id t25mr6025198qkg.82.1576112842707;
        Wed, 11 Dec 2019 17:07:22 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b7sm1233208qkh.106.2019.12.11.17.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 17:07:22 -0800 (PST)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v3] net: bridge: add STP xstats
Date:   Wed, 11 Dec 2019 20:07:10 -0500
Message-Id: <20191212010711.1664000-1-vivien.didelot@gmail.com>
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
 net/bridge/br_netlink.c        | 13 +++++++++++++
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_stp.c            | 15 +++++++++++++++
 net/bridge/br_stp_bpdu.c       |  4 ++++
 5 files changed, 44 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 1b3c2b643a02..4a58e3d7de46 100644
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
@@ -262,6 +271,7 @@ enum {
 	BRIDGE_XSTATS_VLAN,
 	BRIDGE_XSTATS_MCAST,
 	BRIDGE_XSTATS_PAD,
+	BRIDGE_XSTATS_STP,
 	__BRIDGE_XSTATS_MAX
 };
 #define BRIDGE_XSTATS_MAX (__BRIDGE_XSTATS_MAX - 1)
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a0a54482aabc..60136575aea4 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1607,6 +1607,19 @@ static int br_fill_linkxstats(struct sk_buff *skb,
 		br_multicast_get_stats(br, p, nla_data(nla));
 	}
 #endif
+
+	if (p) {
+		nla = nla_reserve_64bit(skb, BRIDGE_XSTATS_STP,
+					sizeof(p->stp_xstats),
+					BRIDGE_XSTATS_PAD);
+		if (!nla)
+			goto nla_put_failure;
+
+		spin_lock_bh(&br->lock);
+		memcpy(nla_data(nla), &p->stp_xstats, sizeof(p->stp_xstats));
+		spin_unlock_bh(&br->lock);
+	}
+
 	nla_nest_end(skb, nest);
 	*prividx = 0;
 
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

