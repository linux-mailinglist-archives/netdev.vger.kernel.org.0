Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B07580B64
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfHDPKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37323 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfHDPKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so56825489wrr.4
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bGr223WMRrbUFbfPwA0NQPu1Jr1GMcU7LLzKSfcbQ1o=;
        b=kgJ5LHe96h2/hKmYsaqzfXm9ug0/P1PoaDhKdFbQnZyGJeyHf5vFTGBkKFPpT10qZZ
         0OeLWrXyjI2MyMlv7XESuMbwODFtzLHeJ1qWYs+VSGvz6rvXNJw5pp/w2ihhWrDNukRM
         bH4bwrVrJOB1ubDaJxm3FzeriVrZ7ar22DwT4uKDm9SgKoiWZJTdxiAyd7r9uK7a3+aV
         Jb82TfmTXMw0qETkpu2VHwOuscxFzAPiMWZCzJrXl4WvSrHl0UDdZJG2WNbGez/iCbwt
         zH3/WYHHKoackmlbaZ4Ds5M7FfbM6SGM+vD+HJPh3fEaxlR65L6XbuE/eU6sStDhWJ+K
         j5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bGr223WMRrbUFbfPwA0NQPu1Jr1GMcU7LLzKSfcbQ1o=;
        b=YqeR2M2Bhioc8hNNzvQ3+0E4hnwukQlPFwU4QJuYd3lHS2JnFMdCaGawmubr5Lu6Hm
         NVLZNcTuRfb+QFMYkJj5jYDlLFyHopXEdoRxYdbzqvJRbqevTdCVCuQ5aKb74FpkOqJi
         YNoGsxrITF8oA6n5SReYiZOYvROGqumQ1JLlBGNxunGfssH+oPQ+Yi6nHMVl0XkvtrLN
         VmAR3xuCKITdFXbEff+9P7KYYucWEoSrbXkmun07cNbdo5mKISy4YX75DueEg5QZllQm
         sQCdFeFQ1RhBr/gIBtWz5DjGWQ1qrIS4QXnw9sslPPr839LM3xGUVHbbCqhxBsblssoz
         KKqg==
X-Gm-Message-State: APjAAAVr0vpmPNiPbPut8ZeoShXS9Fw74YOwAsdxBmrc0ZT5OLEcGzyQ
        An8bja+cVb+ESLzb4EkzpJKLgPasVRM=
X-Google-Smtp-Source: APXvYqx36oFJSlGIX60fJtH2JeP+2of+YSi0h/7pJiaebFQoR8WmUtG6iqQVjb1n7fqlqi5g5f6dOw==
X-Received: by 2002:adf:e941:: with SMTP id m1mr6664505wrn.279.1564931432828;
        Sun, 04 Aug 2019 08:10:32 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:32 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 09/10] nfp: flower: remove offloaded MACs when reprs are applied to OvS bridges
Date:   Sun,  4 Aug 2019 16:09:11 +0100
Message-Id: <1564931351-1036-10-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC addresses along with an identifying index are offloaded to firmware to
allow tunnel decapsulation. If a tunnel packet arrives with a matching
destination MAC address and a verified index, it can continue on the
decapsulation process. This replicates the MAC verifications carried out
in the kernel network stack.

When a netdev is added to a bridge (e.g. OvS) then packets arriving on
that dev are directed through the bridge datapath instead of passing
through the network stack. Therefore, tunnelled packets matching the MAC
of that dev will not be decapped here.

Replicate this behaviour on firmware by removing offloaded MAC addresses
when a MAC representer is added to an OvS bridge. This can prevent any
false positive tunnel decaps.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  7 ++++
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 42 ++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 5d302d7..31d9459 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -221,6 +221,7 @@ struct nfp_fl_qos {
  * @block_shared:	Flag indicating if offload applies to shared blocks
  * @mac_list:		List entry of reprs that share the same offloaded MAC
  * @qos_table:		Stored info on filters implementing qos
+ * @on_bridge:		Indicates if the repr is attached to a bridge
  */
 struct nfp_flower_repr_priv {
 	struct nfp_repr *nfp_repr;
@@ -230,6 +231,7 @@ struct nfp_flower_repr_priv {
 	bool block_shared;
 	struct list_head mac_list;
 	struct nfp_fl_qos qos_table;
+	bool on_bridge;
 };
 
 /**
@@ -341,6 +343,11 @@ static inline bool nfp_flower_is_merge_flow(struct nfp_fl_payload *flow_pay)
 	return flow_pay->tc_flower_cookie == (unsigned long)flow_pay;
 }
 
+static inline bool nfp_flower_is_supported_bridge(struct net_device *netdev)
+{
+	return netif_is_ovs_master(netdev);
+}
+
 int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 			     unsigned int host_ctx_split);
 void nfp_flower_metadata_cleanup(struct nfp_app *app);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index b9dbfb7..a61e7f2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -730,6 +730,9 @@ nfp_tunnel_offload_mac(struct nfp_app *app, struct net_device *netdev,
 			return 0;
 
 		repr_priv = repr->app_priv;
+		if (repr_priv->on_bridge)
+			return 0;
+
 		mac_offloaded = &repr_priv->mac_offloaded;
 		off_mac = &repr_priv->offloaded_mac_addr[0];
 		port = nfp_repr_get_port_id(netdev);
@@ -845,6 +848,45 @@ int nfp_tunnel_mac_event_handler(struct nfp_app *app,
 		if (err)
 			nfp_flower_cmsg_warn(app, "Failed to offload MAC change on %s.\n",
 					     netdev_name(netdev));
+	} else if (event == NETDEV_CHANGEUPPER) {
+		/* If a repr is attached to a bridge then tunnel packets
+		 * entering the physical port are directed through the bridge
+		 * datapath and cannot be directly detunneled. Therefore,
+		 * associated offloaded MACs and indexes should not be used
+		 * by fw for detunneling.
+		 */
+		struct netdev_notifier_changeupper_info *info = ptr;
+		struct net_device *upper = info->upper_dev;
+		struct nfp_flower_repr_priv *repr_priv;
+		struct nfp_repr *repr;
+
+		if (!nfp_netdev_is_nfp_repr(netdev) ||
+		    !nfp_flower_is_supported_bridge(upper))
+			return NOTIFY_OK;
+
+		repr = netdev_priv(netdev);
+		if (repr->app != app)
+			return NOTIFY_OK;
+
+		repr_priv = repr->app_priv;
+
+		if (info->linking) {
+			if (nfp_tunnel_offload_mac(app, netdev,
+						   NFP_TUNNEL_MAC_OFFLOAD_DEL))
+				nfp_flower_cmsg_warn(app, "Failed to delete offloaded MAC on %s.\n",
+						     netdev_name(netdev));
+			repr_priv->on_bridge = true;
+		} else {
+			repr_priv->on_bridge = false;
+
+			if (!(netdev->flags & IFF_UP))
+				return NOTIFY_OK;
+
+			if (nfp_tunnel_offload_mac(app, netdev,
+						   NFP_TUNNEL_MAC_OFFLOAD_ADD))
+				nfp_flower_cmsg_warn(app, "Failed to offload MAC on %s.\n",
+						     netdev_name(netdev));
+		}
 	}
 	return NOTIFY_OK;
 }
-- 
2.7.4

