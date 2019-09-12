Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A0EB14AE
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 21:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfILTE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 15:04:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18880 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727209AbfILTE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 15:04:56 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CJ0mwX028604
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 12:04:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=WH/ktTfc54pI4Hqq22UNfMBhilMTMzVAZzYnwRWMNsA=;
 b=Loexyj1Pr8iz2u1kwfPzSD+fckPUep7KBLxOB01cCpIRaCnM3M8w86Ea5PreO0lt+Ash
 Ng6EEt0Ylb9W8z1Wrr6w1URzn285vGM14W7K7Nr801DW0Kl4G5Mnzox+w83uhHKnru07
 HGZBcgPjFLY4rQ+dn57SLSWloJfZ4rl2mWM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uytd88g65-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 12:04:55 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 12 Sep 2019 12:04:54 -0700
Received: by devvm4117.prn2.facebook.com (Postfix, from userid 167582)
        id CE0851353DBE2; Thu, 12 Sep 2019 12:04:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Vijay Khemka <vijaykhemka@fb.com>
Smtp-Origin-Hostname: devvm4117.prn2.facebook.com
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <vijaykhemka@fb.com>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        <joel@jms.id.au>, <linux-aspeed@lists.ozlabs.org>, <sdasari@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH] net/ncsi: Disable global multicast filter
Date:   Thu, 12 Sep 2019 12:04:50 -0700
Message-ID: <20190912190451.2362220-1-vijaykhemka@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_10:2019-09-11,2019-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=982
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909120199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling multicast filtering from NCSI if it is supported. As it
should not filter any multicast packets. In current code, multicast
filter is enabled and with an exception of optional field supported
by device are disabled filtering.

Mainly I see if goal is to disable filtering for IPV6 packets then let
it disabled for every other types as well. As we are seeing issues with
LLDP not working with this enabled filtering. And there are other issues
with IPV6.

By Disabling this multicast completely, it is working for both IPV6 as
well as LLDP.

Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>
---
 net/ncsi/internal.h    |  7 +--
 net/ncsi/ncsi-manage.c | 98 +++++-------------------------------------
 2 files changed, 12 insertions(+), 93 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 0b3f0673e1a2..ad3fd7f1da75 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -264,9 +264,7 @@ enum {
 	ncsi_dev_state_config_ev,
 	ncsi_dev_state_config_sma,
 	ncsi_dev_state_config_ebf,
-#if IS_ENABLED(CONFIG_IPV6)
-	ncsi_dev_state_config_egmf,
-#endif
+	ncsi_dev_state_config_dgmf,
 	ncsi_dev_state_config_ecnt,
 	ncsi_dev_state_config_ec,
 	ncsi_dev_state_config_ae,
@@ -295,9 +293,6 @@ struct ncsi_dev_priv {
 #define NCSI_DEV_RESET		8            /* Reset state of NC          */
 	unsigned int        gma_flag;        /* OEM GMA flag               */
 	spinlock_t          lock;            /* Protect the NCSI device    */
-#if IS_ENABLED(CONFIG_IPV6)
-	unsigned int        inet6_addr_num;  /* Number of IPv6 addresses   */
-#endif
 	unsigned int        package_probe_id;/* Current ID during probe    */
 	unsigned int        package_num;     /* Number of packages         */
 	struct list_head    packages;        /* List of packages           */
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 755aab66dcab..bce8b443289d 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -14,7 +14,6 @@
 #include <net/sock.h>
 #include <net/addrconf.h>
 #include <net/ipv6.h>
-#include <net/if_inet6.h>
 #include <net/genetlink.h>
 
 #include "internal.h"
@@ -978,9 +977,7 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 	case ncsi_dev_state_config_ev:
 	case ncsi_dev_state_config_sma:
 	case ncsi_dev_state_config_ebf:
-#if IS_ENABLED(CONFIG_IPV6)
-	case ncsi_dev_state_config_egmf:
-#endif
+	case ncsi_dev_state_config_dgmf:
 	case ncsi_dev_state_config_ecnt:
 	case ncsi_dev_state_config_ec:
 	case ncsi_dev_state_config_ae:
@@ -1033,23 +1030,23 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 		} else if (nd->state == ncsi_dev_state_config_ebf) {
 			nca.type = NCSI_PKT_CMD_EBF;
 			nca.dwords[0] = nc->caps[NCSI_CAP_BC].cap;
-			if (ncsi_channel_is_tx(ndp, nc))
+			/* if multicast global filtering is supported then
+			 * disable it so that all multicast packet will be
+			 * forwarded to management controller
+			 */
+			if (nc->caps[NCSI_CAP_GENERIC].cap &
+			     NCSI_CAP_GENERIC_MC)
+				nd->state = ncsi_dev_state_config_dgmf;
+			else if (ncsi_channel_is_tx(ndp, nc))
 				nd->state = ncsi_dev_state_config_ecnt;
 			else
 				nd->state = ncsi_dev_state_config_ec;
-#if IS_ENABLED(CONFIG_IPV6)
-			if (ndp->inet6_addr_num > 0 &&
-			    (nc->caps[NCSI_CAP_GENERIC].cap &
-			     NCSI_CAP_GENERIC_MC))
-				nd->state = ncsi_dev_state_config_egmf;
-		} else if (nd->state == ncsi_dev_state_config_egmf) {
-			nca.type = NCSI_PKT_CMD_EGMF;
-			nca.dwords[0] = nc->caps[NCSI_CAP_MC].cap;
+		} else if (nd->state == ncsi_dev_state_config_dgmf) {
+			nca.type = NCSI_PKT_CMD_DGMF;
 			if (ncsi_channel_is_tx(ndp, nc))
 				nd->state = ncsi_dev_state_config_ecnt;
 			else
 				nd->state = ncsi_dev_state_config_ec;
-#endif /* CONFIG_IPV6 */
 		} else if (nd->state == ncsi_dev_state_config_ecnt) {
 			if (np->preferred_channel &&
 			    nc != np->preferred_channel)
@@ -1483,70 +1480,6 @@ int ncsi_process_next_channel(struct ncsi_dev_priv *ndp)
 	return -ENODEV;
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
-static int ncsi_inet6addr_event(struct notifier_block *this,
-				unsigned long event, void *data)
-{
-	struct inet6_ifaddr *ifa = data;
-	struct net_device *dev = ifa->idev->dev;
-	struct ncsi_dev *nd = ncsi_find_dev(dev);
-	struct ncsi_dev_priv *ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
-	struct ncsi_package *np;
-	struct ncsi_channel *nc;
-	struct ncsi_cmd_arg nca;
-	bool action;
-	int ret;
-
-	if (!ndp || (ipv6_addr_type(&ifa->addr) &
-	    (IPV6_ADDR_LINKLOCAL | IPV6_ADDR_LOOPBACK)))
-		return NOTIFY_OK;
-
-	switch (event) {
-	case NETDEV_UP:
-		action = (++ndp->inet6_addr_num) == 1;
-		nca.type = NCSI_PKT_CMD_EGMF;
-		break;
-	case NETDEV_DOWN:
-		action = (--ndp->inet6_addr_num == 0);
-		nca.type = NCSI_PKT_CMD_DGMF;
-		break;
-	default:
-		return NOTIFY_OK;
-	}
-
-	/* We might not have active channel or packages. The IPv6
-	 * required multicast will be enabled when active channel
-	 * or packages are chosen.
-	 */
-	np = ndp->active_package;
-	nc = ndp->active_channel;
-	if (!action || !np || !nc)
-		return NOTIFY_OK;
-
-	/* We needn't enable or disable it if the function isn't supported */
-	if (!(nc->caps[NCSI_CAP_GENERIC].cap & NCSI_CAP_GENERIC_MC))
-		return NOTIFY_OK;
-
-	nca.ndp = ndp;
-	nca.req_flags = 0;
-	nca.package = np->id;
-	nca.channel = nc->id;
-	nca.dwords[0] = nc->caps[NCSI_CAP_MC].cap;
-	ret = ncsi_xmit_cmd(&nca);
-	if (ret) {
-		netdev_warn(dev, "Fail to %s global multicast filter (%d)\n",
-			    (event == NETDEV_UP) ? "enable" : "disable", ret);
-		return NOTIFY_DONE;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block ncsi_inet6addr_notifier = {
-	.notifier_call = ncsi_inet6addr_event,
-};
-#endif /* CONFIG_IPV6 */
-
 static int ncsi_kick_channels(struct ncsi_dev_priv *ndp)
 {
 	struct ncsi_dev *nd = &ndp->ndev;
@@ -1725,11 +1658,6 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 	}
 
 	spin_lock_irqsave(&ncsi_dev_lock, flags);
-#if IS_ENABLED(CONFIG_IPV6)
-	ndp->inet6_addr_num = 0;
-	if (list_empty(&ncsi_dev_list))
-		register_inet6addr_notifier(&ncsi_inet6addr_notifier);
-#endif
 	list_add_tail_rcu(&ndp->node, &ncsi_dev_list);
 	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
 
@@ -1896,10 +1824,6 @@ void ncsi_unregister_dev(struct ncsi_dev *nd)
 
 	spin_lock_irqsave(&ncsi_dev_lock, flags);
 	list_del_rcu(&ndp->node);
-#if IS_ENABLED(CONFIG_IPV6)
-	if (list_empty(&ncsi_dev_list))
-		unregister_inet6addr_notifier(&ncsi_inet6addr_notifier);
-#endif
 	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
 
 	ncsi_unregister_netlink(nd->dev);
-- 
2.17.1

