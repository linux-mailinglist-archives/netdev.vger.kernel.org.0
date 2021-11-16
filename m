Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE91452A66
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhKPGSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:18:00 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:51762 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232504AbhKPGR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 01:17:59 -0500
X-UUID: a1e427dce47a4814bc3357c6a9c8530c-20211116
X-UUID: a1e427dce47a4814bc3357c6a9c8530c-20211116
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 271601239; Tue, 16 Nov 2021 14:14:58 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Tue, 16 Nov 2021 14:14:57 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Nov 2021 14:14:54 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <Rocco.Yue@gmail.com>,
        <chao.song@mediatek.com>, <yanjie.jiang@mediatek.com>,
        <kuohong.wang@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        <lorenzo@google.com>, <maze@google.com>, <markzzzsmith@gmail.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH net-next v2] ipv6: don't generate link-local addr in random or privacy mode
Date:   Tue, 16 Nov 2021 14:09:59 +0800
Message-ID: <20211116060959.32746-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the 3GPP TS 29.061, here is a description as follows:
"In order to avoid any conflict between the link-local address
of the MS and that of the GGSN, the Interface-Identifier used by
the MS to build its link-local address shall be assigned by the
GGSN. The GGSN ensures the uniqueness of this Interface-Identifier.
The MT shall then enforce the use of this Interface-Identifier by
the TE"

In other words, in the cellular network, GGSN determines whether
to reply a solicited RA message by identifying the bottom 64 bits
of the source address of the received RS message. Therefore,
cellular network device's ipv6 link-local address should be set
as the format of fe80::(GGSN assigned IID).

To meet the above spec requirement, this patch adds two new
addr_gen_mode:

1) IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA, this mode is suitable
for cellular networks that support RFC7217. In this mode, the
kernel doesn't generate a link-local address for the cellular
NIC, and generates an ipv6 stable privacy global address after
receiving the RA message.

2) IN6_ADDR_GEN_MODE_RANDOM_NO_LLA, in this mode, the kernel
doesn't generate a link-local address for the cellular NIC,
and will use the bottom 64 bits of the link-local address(same
as the IID assigned by GGSN) to form an ipv6 global address
after receiveing the RA message.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
v1->v2: Add new addr_gen_mode instead of adding a separate sysctl.

v1 link:
https://patchwork.kernel.org/patch/12353465

---
 include/uapi/linux/if_link.h       |  2 ++
 net/ipv6/addrconf.c                | 22 ++++++++++++++++------
 tools/include/uapi/linux/if_link.h |  2 ++
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eebd3894fe89..9c5695744c7d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -428,6 +428,8 @@ enum in6_addr_gen_mode {
 	IN6_ADDR_GEN_MODE_NONE,
 	IN6_ADDR_GEN_MODE_STABLE_PRIVACY,
 	IN6_ADDR_GEN_MODE_RANDOM,
+	IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
+	IN6_ADDR_GEN_MODE_RANDOM_NO_LLA,
 };
 
 /* Bridge section */
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3445f8017430..0045de10f4b5 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -392,7 +392,8 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	timer_setup(&ndev->rs_timer, addrconf_rs_timer, 0);
 	memcpy(&ndev->cnf, dev_net(dev)->ipv6.devconf_dflt, sizeof(ndev->cnf));
 
-	if (ndev->cnf.stable_secret.initialized)
+	if (ndev->cnf.stable_secret.initialized &&
+	    ndev->cnf.addr_gen_mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA)
 		ndev->cnf.addr_gen_mode = IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
 
 	ndev->cnf.mtu6 = dev->mtu;
@@ -2578,7 +2579,8 @@ static void manage_tempaddrs(struct inet6_dev *idev,
 static bool is_addr_mode_generate_stable(struct inet6_dev *idev)
 {
 	return idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_STABLE_PRIVACY ||
-	       idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_RANDOM;
+	       idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_RANDOM ||
+	       idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA;
 }
 
 int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
@@ -3331,6 +3333,8 @@ static void addrconf_addr_gen(struct inet6_dev *idev, bool prefix_route)
 					      0, 0, GFP_KERNEL);
 		break;
 	case IN6_ADDR_GEN_MODE_NONE:
+	case IN6_ADDR_GEN_MODE_RANDOM_NO_LLA:
+	case IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA:
 	default:
 		/* will not add any link local address */
 		break;
@@ -5798,7 +5802,9 @@ static int check_addr_gen_mode(int mode)
 	if (mode != IN6_ADDR_GEN_MODE_EUI64 &&
 	    mode != IN6_ADDR_GEN_MODE_NONE &&
 	    mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY &&
-	    mode != IN6_ADDR_GEN_MODE_RANDOM)
+	    mode != IN6_ADDR_GEN_MODE_RANDOM &&
+	    mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA &&
+	    mode != IN6_ADDR_GEN_MODE_RANDOM_NO_LLA)
 		return -EINVAL;
 	return 1;
 }
@@ -6428,15 +6434,19 @@ static int addrconf_sysctl_stable_secret(struct ctl_table *ctl, int write,
 		for_each_netdev(net, dev) {
 			struct inet6_dev *idev = __in6_dev_get(dev);
 
-			if (idev) {
+			if (idev && idev->cnf.addr_gen_mode !=
+			    IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA) {
 				idev->cnf.addr_gen_mode =
 					IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
 			}
 		}
 	} else {
 		struct inet6_dev *idev = ctl->extra1;
-
-		idev->cnf.addr_gen_mode = IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
+		if (idev->cnf.addr_gen_mode !=
+		    IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA) {
+			idev->cnf.addr_gen_mode =
+				IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
+		}
 	}
 
 out:
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index b3610fdd1fee..fb69137aea89 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -241,6 +241,8 @@ enum in6_addr_gen_mode {
 	IN6_ADDR_GEN_MODE_NONE,
 	IN6_ADDR_GEN_MODE_STABLE_PRIVACY,
 	IN6_ADDR_GEN_MODE_RANDOM,
+	IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
+	IN6_ADDR_GEN_MODE_RANDOM_NO_LLA,
 };
 
 /* Bridge section */
-- 
2.18.0

