Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6B2392BE1
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbhE0Kf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:35:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235950AbhE0Kf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:35:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622111634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sPD/3iv1LCC0U8GA+nL6tPMT5TsURHOUeON3NmGaw+c=;
        b=OW8D+NZgJxbp9Bpzv0LD0BxyPtJt78jJ19tHk1LPO/y0gP3yK5qs3p+6bvaGic50azjQdE
        GO6bOFT4Tq3QJwTGn0k8yI7yg1unOyAcX0CZPJYBioKFucZjgNNp1BV6CkuzNjbMZFQoN0
        P3YfDkxPEXh5iKHd25R9jSbQyA5o/5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-V57bzSnvOX-8lvKWZ-04ww-1; Thu, 27 May 2021 06:33:52 -0400
X-MC-Unique: V57bzSnvOX-8lvKWZ-04ww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D3A119251A6;
        Thu, 27 May 2021 10:33:51 +0000 (UTC)
Received: from kks2.redhat.com (ovpn-116-123.sin2.redhat.com [10.67.116.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26F155D9C6;
        Thu, 27 May 2021 10:33:48 +0000 (UTC)
From:   Karthik S <ksundara@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        karthik.sundaravel@gmail.com,
        Christophe Fontaine <cfontain@redhat.com>,
        Veda Barrenkala <vbarrenk@redhat.com>,
        Vijay Chundury <vchundur@redhat.com>
Cc:     Karthik S <ksundara@redhat.com>
Subject: [PATCH 1/1] rtnetlink: Port mirroring support for SR-IOV
Date:   Thu, 27 May 2021 16:03:18 +0530
Message-Id: <20210527103318.801175-2-ksundara@redhat.com>
In-Reply-To: <20210527103318.801175-1-ksundara@redhat.com>
References: <ksundara@redhat.com>
 <20210527103318.801175-1-ksundara@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port mirroring involves sending a copy of packets entering and/or leaving
one port to another port which is usually different from the original
destination of the packets being mirrored.

The implementation would provide three modes of packet mirroring (For Egress or Ingress):
1) PF to VF
2) VF to VF
3) VLAN to VF

Signed-off-by: Karthik S <ksundara@redhat.com>
---
 include/linux/netdevice.h    |   4 ++
 include/uapi/linux/if_link.h |  46 +++++++++++++
 net/core/rtnetlink.c         | 123 ++++++++++++++++++++++++++++++++++-
 3 files changed, 172 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 259be67644e3..21448fa5d2e5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1352,6 +1352,10 @@ struct net_device_ops {
 						     struct ifla_vf_info *ivf);
 	int			(*ndo_set_vf_link_state)(struct net_device *dev,
 							 int vf, int link_state);
+	int                     (*ndo_set_vf_mirror)(struct net_device *dev,
+						     struct nlattr *vf_mirror);
+	int                     (*ndo_get_vf_mirror)(struct net_device *dev,
+						     struct ifla_vf_mirror_info *vf_mirror);
 	int			(*ndo_get_vf_stats)(struct net_device *dev,
 						    int vf,
 						    struct ifla_vf_stats
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 82708c6db432..b5cb3987e182 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -904,6 +904,7 @@ enum {
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
 	IFLA_VF_BROADCAST,	/* VF broadcast */
+	IFLA_VF_MIRROR,
 	__IFLA_VF_MAX,
 };
 
@@ -998,6 +999,51 @@ struct ifla_vf_trust {
 	__u32 setting;
 };
 
+
+enum mirror_type {
+	IFLA_VF_MIRROR_CLEAR,
+	IFLA_VF_MIRROR_PF,
+	IFLA_VF_MIRROR_VF,
+	IFLA_VF_MIRROR_VLAN,
+	IFLA_VF_MIRROR_MAX,
+};
+
+#define PORT_MIRRORING_INGRESS (1U)
+#define PORT_MIRRORING_EGRESS (1U << 1)
+
+struct ifla_vf_mirror_vf {
+	__u32 dst_vf;
+	__u32 src_vf;
+	__u8 dir_mask;
+};
+
+struct ifla_vf_mirror_pf {
+	__u32 dst_vf;
+	__u8 dir_mask;
+};
+
+
+struct ifla_vf_mirror_vlan {
+	__u32 dst_vf;
+	__u32 vlan;
+};
+
+struct ifla_vf_mirror_clear {
+	__u32 dst_vf;
+};
+
+struct ifla_vf_mirror_info {
+	enum mirror_type action;
+	__u32 ele_index;
+	union {
+		__u32 dst_vf;
+		struct ifla_vf_mirror_vf vf_to_vf;
+		struct ifla_vf_mirror_pf pf_to_vf;
+		struct ifla_vf_mirror_vlan vlan_mirror;
+	};
+};
+
+
 /* VF ports management section
  *
  *	Nested layout of set/get msg is:
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 3d6ab194d0f5..a385e004bb9c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -911,6 +911,117 @@ static void copy_rtnl_link_stats(struct rtnl_link_stats *a,
 	a->rx_nohandler = b->rx_nohandler;
 }
 
+static int rtnl_put_vf_mirror_info(struct sk_buff *skb,
+				   struct ifla_vf_mirror_info *vf_mirror)
+{
+	switch (vf_mirror->action) {
+	case IFLA_VF_MIRROR_VF:
+		if (nla_put(skb, IFLA_VF_MIRROR_VF,
+			    sizeof(struct ifla_vf_mirror_vf),
+			    &vf_mirror->vf_to_vf) < 0)
+			return -EMSGSIZE;
+		break;
+	case IFLA_VF_MIRROR_PF:
+		if (nla_put(skb, IFLA_VF_MIRROR_PF,
+			    sizeof(struct ifla_vf_mirror_pf),
+			    &vf_mirror->pf_to_vf) < 0)
+			return -EMSGSIZE;
+		break;
+	case IFLA_VF_MIRROR_VLAN:
+		if (nla_put(skb, IFLA_VF_MIRROR_VLAN,
+			    sizeof(struct ifla_vf_mirror_vlan),
+			    &vf_mirror->vlan_mirror) < 0)
+			return -EMSGSIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int rtnl_vf_mirror_fill(struct sk_buff *skb,
+			       struct net_device *dev,
+			       int vfid)
+{
+	struct ifla_vf_mirror_info vf_mirror;
+	int mirror_index = 0, err;
+	struct nlattr *vf_mirror_info;
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (!ops->ndo_get_vf_mirror)
+		return 0;
+	vf_mirror_info = nla_nest_start_noflag(skb, IFLA_VF_MIRROR);
+	if (!vf_mirror_info)
+		return -EMSGSIZE;
+
+	vf_mirror.dst_vf = vfid;
+	do {
+		vf_mirror.ele_index = mirror_index;
+		err = ops->ndo_get_vf_mirror(dev, &vf_mirror);
+		if (err == 0) {
+			err = rtnl_put_vf_mirror_info(skb, &vf_mirror);
+			mirror_index++;
+		}
+		if (err == -EAGAIN) {
+			err = 0;
+			mirror_index = 0;
+			nla_nest_cancel(skb, vf_mirror_info);
+			vf_mirror_info = nla_nest_start_noflag(skb,
+							       IFLA_VF_MIRROR);
+			if (!vf_mirror_info)
+				return -EMSGSIZE;
+		}
+	} while (err == 0);
+
+	if (err != -ENODATA) {
+		nla_nest_cancel(skb, vf_mirror_info);
+		return err;
+	}
+
+	nla_nest_end(skb, vf_mirror_info);
+	return 0;
+}
+
+static inline int rtnl_vf_mirror_info_size(struct net_device *dev)
+{
+	int vfid, mirror_index, nb_mirrors = 0;
+	int mirror_info_size;
+	struct ifla_vf_mirror_info vf_mirror;
+	int num_vfs;
+	int err;
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (!ops->ndo_get_vf_mirror)
+		return 0;
+
+	num_vfs = dev_num_vf(dev->dev.parent);
+	for (vfid = 0; vfid < num_vfs; vfid++) {
+		mirror_index = 0;
+		vf_mirror.dst_vf = vfid;
+		do {
+			vf_mirror.ele_index = mirror_index;
+			err = ops->ndo_get_vf_mirror(dev, &vf_mirror);
+			if (err == 0)
+				mirror_index++;
+		} while (err == 0);
+		if (err == -EAGAIN) {
+			vfid = -1;
+			nb_mirrors = 0;
+		} else if (err == -ENODATA) {
+			nb_mirrors += mirror_index;
+		} else {
+			return 0;
+		}
+	}
+
+	/* nest IFLA_VF_MIRROR for each VF*/
+	mirror_info_size = num_vfs * nla_total_size(0);
+
+	mirror_info_size += nb_mirrors *
+			    nla_total_size(sizeof(struct ifla_vf_mirror_vf));
+	return mirror_info_size;
+}
+
 /* All VF info */
 static inline int rtnl_vfinfo_size(const struct net_device *dev,
 				   u32 ext_filter_mask)
@@ -948,7 +1059,8 @@ static inline int rtnl_vfinfo_size(const struct net_device *dev,
 			 nla_total_size_64bit(sizeof(__u64)) +
 			 /* IFLA_VF_STATS_TX_DROPPED */
 			 nla_total_size_64bit(sizeof(__u64)) +
-			 nla_total_size(sizeof(struct ifla_vf_trust)));
+			 nla_total_size(sizeof(struct ifla_vf_trust)) +
+			 rtnl_vf_mirror_info_size((struct net_device *)dev));
 		return size;
 	} else
 		return 0;
@@ -1356,6 +1468,8 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		goto nla_put_vf_failure;
 	}
 	nla_nest_end(skb, vfstats);
+	if (rtnl_vf_mirror_fill(skb, dev, vfs_num))
+		goto nla_put_vf_failure;
 	nla_nest_end(skb, vf);
 	return 0;
 
@@ -2487,6 +2601,13 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 		return handle_vf_guid(dev, ivt, IFLA_VF_IB_PORT_GUID);
 	}
 
+	if (tb[IFLA_VF_MIRROR]) {
+		err = -EOPNOTSUPP;
+		if (ops->ndo_set_vf_mirror)
+			err = ops->ndo_set_vf_mirror(dev, tb[IFLA_VF_MIRROR]);
+		if (err < 0)
+			return err;
+	}
 	return err;
 }
 
-- 
2.31.1

