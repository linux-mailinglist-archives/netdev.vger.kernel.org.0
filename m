Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9FF2A08F
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404329AbfEXVnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404298AbfEXVnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 17:43:15 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03FC92186A;
        Fri, 24 May 2019 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558734195;
        bh=vzk/AJqDGsJ4aydvA1gUtrg5436Kq6mvolxJhd1u72w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JT+PCYkfk5jdV25avUDJGkGGkVg7bsEGbl+30MlUFmxSRfQcMuahUYwT3fCDRScSw
         GXimsTycdET9Qx5voPzTmqUYw0EttSE94EhzAIiyOJz09QCVPW41P19qP3Xm5LBHXS
         bVcJnSrMFbP4eyP+4gnTuYgcYXfjmPEn4ezYRPNE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     sharpd@cumulusnetworks.com, sworley@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 5/6] nexthop: Add support for lwt encaps
Date:   Fri, 24 May 2019 14:43:07 -0700
Message-Id: <20190524214308.18615-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190524214308.18615-1-dsahern@kernel.org>
References: <20190524214308.18615-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add support for NHA_ENCAP and NHA_ENCAP_TYPE. Leverages the existing code
for lwtunnel within fib_nh_common, so the only change needed is handling
the attributes in the nexthop code.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h |  3 +++
 net/ipv4/nexthop.c    | 37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index d188f16c0c4f..7cde03337e14 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -35,6 +35,9 @@ struct nh_config {
 		struct in6_addr	ipv6;
 	} gw;
 
+	struct nlattr	*nh_encap;
+	u16		nh_encap_type;
+
 	u32		nlflags;
 	struct nl_info	nlinfo;
 };
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f2b237a6735c..3a1cbcb96baa 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -9,6 +9,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <net/ipv6_stubs.h>
+#include <net/lwtunnel.h>
 #include <net/nexthop.h>
 #include <net/route.h>
 #include <net/sock.h>
@@ -182,6 +183,11 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		break;
 	}
 
+	if (nhi->fib_nhc.nhc_lwtstate &&
+	    lwtunnel_fill_encap(skb, nhi->fib_nhc.nhc_lwtstate,
+				NHA_ENCAP, NHA_ENCAP_TYPE) < 0)
+		goto nla_put_failure;
+
 out:
 	nlmsg_end(skb, nlh);
 	return 0;
@@ -213,6 +219,11 @@ static size_t nh_nlmsg_size(struct nexthop *nh)
 		break;
 	}
 
+	if (nhi->fib_nhc.nhc_lwtstate) {
+		sz += lwtunnel_get_encap_size(nhi->fib_nhc.nhc_lwtstate);
+		sz += nla_total_size(2);  /* NHA_ENCAP_TYPE */
+	}
+
 	return sz;
 }
 
@@ -370,6 +381,8 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 		.fc_gw4   = cfg->gw.ipv4,
 		.fc_gw_family = cfg->gw.ipv4 ? AF_INET : 0,
 		.fc_flags = cfg->nh_flags,
+		.fc_encap = cfg->nh_encap,
+		.fc_encap_type = cfg->nh_encap_type,
 	};
 	u32 tb_id = l3mdev_fib_table(cfg->dev);
 	int err = -EINVAL;
@@ -402,6 +415,8 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
 		.fc_ifindex = cfg->nh_ifindex,
 		.fc_gateway = cfg->gw.ipv6,
 		.fc_flags = cfg->nh_flags,
+		.fc_encap = cfg->nh_encap,
+		.fc_encap_type = cfg->nh_encap_type,
 	};
 	int err = -EINVAL;
 
@@ -561,7 +576,8 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 		cfg->nh_id = nla_get_u32(tb[NHA_ID]);
 
 	if (tb[NHA_BLACKHOLE]) {
-		if (tb[NHA_GATEWAY] || tb[NHA_OIF]) {
+		if (tb[NHA_GATEWAY] || tb[NHA_OIF] ||
+		    tb[NHA_ENCAP]   || tb[NHA_ENCAP_TYPE]) {
 			NL_SET_ERR_MSG(extack, "Blackhole attribute can not be used with gateway or oif");
 			goto out;
 		}
@@ -626,6 +642,25 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 		}
 	}
 
+	if (tb[NHA_ENCAP]) {
+		cfg->nh_encap = tb[NHA_ENCAP];
+
+		if (!tb[NHA_ENCAP_TYPE]) {
+			NL_SET_ERR_MSG(extack, "LWT encapsulation type is missing");
+			goto out;
+		}
+
+		cfg->nh_encap_type = nla_get_u16(tb[NHA_ENCAP_TYPE]);
+		err = lwtunnel_valid_encap_type(cfg->nh_encap_type, extack);
+		if (err < 0)
+			goto out;
+
+	} else if (tb[NHA_ENCAP_TYPE]) {
+		NL_SET_ERR_MSG(extack, "LWT encapsulation attribute is missing");
+		goto out;
+	}
+
+
 	err = 0;
 out:
 	return err;
-- 
2.11.0

