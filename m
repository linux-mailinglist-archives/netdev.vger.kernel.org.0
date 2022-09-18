Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92565BBF9D
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiIRTtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiIRTst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:48:49 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2130.outbound.protection.outlook.com [40.107.21.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA5618B09;
        Sun, 18 Sep 2022 12:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/ADlflWFJ40k6uplnz33fNnHPkfIBa/W5FBVxreP53tActB7qiD/q3907GnZzD/WCV0ZL9My7mOMncVhKdGOtd0g66V+l/+eFWXY8i/WUHcSx5kOCVkQTA+2x1z9DAUvbKoCo/imiREe7Du6RmVXuIRvX/TcVSo60rItygkutLb9gBjBTRM3EMFIg5rMHK6x27BvubxY/H1dZxlg1MJHhT2XBu193slNm+u6ElLc98Gx8AflGtLB+kJ5G/tXX3b2ukojbRxN7sruHbLB8TdWPBO2y/zKknKvtlQ/3bMILtlu/fT7aj4NjpNUaikb40eIb8LPYmrfoDpPjkJ/BWhBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihozGtm/M7IiVm1B75CJ2XkvE1Q0miM2KvYgVnK9ITo=;
 b=B+ph/qVCyvQx4ZIi9T1cyYR0NF+sm2qSyU5KQxcavgI3wufBg2vuNif0Oz5DwM3k5zFmB623IK1FoqStm8Zvf/mI3EIpMEFQSZMVYVfrtv70/4PS/8jKlodww+7HdD3MheihVV59aOQg8dmUsjuHoNUAsV1mofwNMnpOlBI9dFbo+iVooZZS8Q2P1qTq/sOl1SJCpK28EsNSrPZK7FxcDWfrdhmRNPsR5URvMEOf6nwpHxcD7CL0uPPGAwmMrHPluRoLcQTSga1gQkQzZlZlO/AmDnO+65znh3Szr5RxAeCBO4qoef+PcPE1ODSe9wTURFXAmAf3NTKGfQbf9eRWvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihozGtm/M7IiVm1B75CJ2XkvE1Q0miM2KvYgVnK9ITo=;
 b=FASkecG80of0NBQtZNYXf8SSiRRgN9qsXQ2iNWHBwfbVpUV6aYxwO8SXdxM6CAPcXLSO5e/JW0zsVSDU2U0DOWhaHhpgZPM5NxOcpPRh9LUO4cEAJJkIXkYXOaC6TRw3nPqqVaWXpKcLF83+br+3rI6aGNlNvF51Yf6j+Kxw54Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by DB9P190MB1817.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:33d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Sun, 18 Sep
 2022 19:47:27 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f%5]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 19:47:27 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v6 9/9] net: marvell: prestera: Propagate nh state from hw to kernel
Date:   Sun, 18 Sep 2022 22:47:00 +0300
Message-Id: <20220918194700.19905-10-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
References: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::18) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|DB9P190MB1817:EE_
X-MS-Office365-Filtering-Correlation-Id: ea4ebca6-83b0-40c0-043b-08da99ae9dce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOtYIIyvmTI+HKSOsGFvKYP+h4LP5E4kCc3l3M/8lC+dMMva1Q9xDKWY4rM+OxuYsnx1wTcBo09SBUMWF7TKhVtBt8HqKq0iEaZH2ksObd3N8gdU+chQ06OqzwyvNm6pb4zuwIFU4GDP4i++wqF5GiysH5jN2V3HJFS7+RXUDDlXep/mAY5mmHF5cGQ3qtveCRHlOCbbz8e92soojD9TXTAtck2ywu9OoMW9krj2RXCf1lOsLCHijS9iRQYgM79gWAUapLCvTRO+zJ4T1ZJHXzyF9qWaXgFmPqjm9BR7bFrYE7kOeObFnXnIS3d+m35San8kGVEzWFtQLEiT0GF+r0yC/m11iXcNlEy19YRUv2z+pdjYMHSe/JNz8tvSZxV6DRSbZ4UFgM+P3bGF6nxHaPQ0DRA11laBvFANfQEmpdPR+COL6hh+O05IgHiDiddPAwjeaOuvYG8CHzZsMg+PBZmUU4redB1/8lUmS5IZ6tC1YLbcw4eC4Q+z+/LjQtSxG/3XqTRWN+ZkYWJ6eM+VyGKxB8YRmOK2acjpI1fyXC1EppYG9WHYJhn6sl5NoQrwfn50BZZFZH95sZZwqeGRMpLq/ez4DahjJ7/tnTUOgrg3IEXuhYYwRCL0dZECuwZt7SB15Z9v7+22DKwp42rwhqAC+yiZB+qa1Nm5NXV/I6uq5DKGzD4/kPkBC2N4oknfQzP6taIZJpfoxEhDNCpnq6siJ6GlQKtlbFTdB9LJ/PTyoaKfr2e8sxS6c3Wsg1G1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(376002)(136003)(39830400003)(451199015)(36756003)(6506007)(26005)(52116002)(478600001)(41300700001)(54906003)(6916009)(316002)(6486002)(107886003)(38350700002)(38100700002)(6512007)(186003)(1076003)(66574015)(6666004)(86362001)(83380400001)(2616005)(8676002)(66476007)(66556008)(66946007)(5660300002)(2906002)(7416002)(8936002)(4326008)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e6tTB7SNP1BLjSHAqwbtN8oUVm4BIBrFRE6LilwPKPDO9IVqQ0ZVN2YxAojx?=
 =?us-ascii?Q?ugwPMDOj6LgTNO3QfvLMyf3qpPYkaCBqH7AyalMYA1g5jne+nLkoHdkiBcxh?=
 =?us-ascii?Q?n/ipjSdN3JXp/UY4dl19zpo6ZGcnqo+yZAFLFsKoxyGPY7iMhRHw5oZ6hr33?=
 =?us-ascii?Q?UJOZuqBH2Rg+HpsblkB+Kd7LdERVhXCX2NZh3LbfSNM18VF9Azzrgr1gWxPx?=
 =?us-ascii?Q?zoDOxxxeAGvdioLF5nrcT/vkgQVIOwmN0Oy30E6sehNoTZWFP7lDV9ZUk/w8?=
 =?us-ascii?Q?dz0/sfk41CsAhikdeqHola0fGizFNoyeKGMaqgEsJAF4HIMsdpt/1PcFsn/u?=
 =?us-ascii?Q?Hz5VB+0pHgfpM3Qf+FuBI82+N8zB/HeL5FK5C4DtZbgMb17GP1UchOWtSNNw?=
 =?us-ascii?Q?CzwL4Z9D2+8tJSXOd+RhB9gTyHVdyNjts3gqksvysIct0MVOUPxdQ80m+4/c?=
 =?us-ascii?Q?uwqutfGGnSGbxt89HviBHx58Tcopgw2gaKq9YX4i9SHZmbC0SvvzLcT/57lw?=
 =?us-ascii?Q?UhYIu/GycqXMWdos+U+1HhOQYrKHDM5S4XxAKryOjLE0ba7ac6b+CwRj43lb?=
 =?us-ascii?Q?tb/k5P4qGsNfRCbYXZOmmtnT/1D6OFwpVtA9fkOZAiIGYsCZdHpwxhp1ASD9?=
 =?us-ascii?Q?8MmRCw1zXXZ14oIjUTKnRBEqfgF4C277OOOavHvTUctnRSpJtYQNfWAkxd83?=
 =?us-ascii?Q?fpxrMH25KoEikfepmg+++t1IwobSiobDMLJrX3HpbMmC5DZNSZDZwyCqeAxx?=
 =?us-ascii?Q?aU+apRI3Gmb4B5sxGZpFL1wy0iKZXj4PbW66zQ13ThvfBeTcNqFUqeORRFr7?=
 =?us-ascii?Q?GE8OerjUo3rdmGiGq0UC5SKMNUTFQv9SaRpPHoh7Q0Rj9rrJf1TOX9dCRizC?=
 =?us-ascii?Q?47aA6WIjEC2wp5TJZ6dGzff3mS5pUWQr9BF9epaHSVk8U4ZyzymXQJn26EXd?=
 =?us-ascii?Q?zLgneY6sQ4tqLyBphC3N1Gfx9CVBMtOen8wqRubjLsJYTeUWT9i0uiuHTT8r?=
 =?us-ascii?Q?VnFmx68F6NaPhnx+2yx/79xjKNm8OeUIfZkd9wlE3IbCfka7NGCa/Bep7z75?=
 =?us-ascii?Q?3+1ysBBwOT0qGPw+IkI+fbCQhc22VNnYiDy5ZRrCuPdKn0zV4Td5asfIumQ3?=
 =?us-ascii?Q?8WMGGo1T8kP3CPJyggwWGIGXbQ+cDwxR0wHk782NYf84c5UnXh1xAkyxF8+S?=
 =?us-ascii?Q?BQtiNUcMKA8stqFleGCCI2ChPBClPEdLTkNt2japaFev4Dz8CC1ghp7qckxg?=
 =?us-ascii?Q?0xbDeK0ml+wazDb3/nqB4K3DQirZvEbb9tuZJnJASxFg1ZzpUv4h9+dgLfKz?=
 =?us-ascii?Q?P4xcp1hN7/by2UwUFq4aWrMgbJBSR9cHU5BCCHIWqD9z85bgGBux84uvSYkz?=
 =?us-ascii?Q?DRG4AaEOY4hZj0U6/M2QvlZ/NdRQAysmlRgSyoaFjlGql+5jwny4Nj0eWEuW?=
 =?us-ascii?Q?G/GAIa2DarcvnDXLB/CkJu6jLlupdLwcnRTUtgbai0VErU054gJn27ssEYyk?=
 =?us-ascii?Q?03SEoEiEX6i4Cj+9YcOHNgTKUuyyTT91YXyYbzqWctpTJ/MTRyJvZ+4KRXVH?=
 =?us-ascii?Q?Bf/xem7vdCEidyrv03Y0qNvsqMJrZlf3801ZlXSFl6dvUToyYap9DsBgIUaj?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4ebca6-83b0-40c0-043b-08da99ae9dce
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 19:47:27.8480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJDXwjwX3doyYQJdGy8dH3vSDjI/m3YoyRCJkfjkaZdDSyUgZoOXQfoLJwhEICqWdCbpuh+LJsyPFy7NeSzE+5hqyemyd2BJvG4Np5tf87Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We poll nexthops in HW and call for each active nexthop appropriate
neighbour.

Also we provide implicity neighbour resolving.
For example, user have added nexthop route:
  # ip route add 5.5.5.5 via 1.1.1.2
But neighbour 1.1.1.2 doesn't exist. In this case we will try to call
neigh_event_send, even if there is no traffic.
This is useful, when you have add route, which will be used after some
time but with a lot of traffic (burst). So, we has prepared, offloaded
route in advance.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   3 +
 .../marvell/prestera/prestera_router.c        | 111 ++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 540a36069b79..35554ee805cd 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -324,6 +324,9 @@ struct prestera_router {
 	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
+	struct {
+		struct delayed_work dw;
+	} neighs_update;
 };
 
 struct prestera_rxtx_params {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 771d123345ac..b3b68529a3c9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -16,6 +16,9 @@
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+#define PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH
+#define PRESTERA_NH_PROBE_INTERVAL 5000 /* ms */
+
 struct prestera_kern_neigh_cache_key {
 	struct prestera_ip_addr addr;
 	struct net_device *dev;
@@ -32,6 +35,7 @@ struct prestera_kern_neigh_cache {
 	/* Lock cache if neigh is present in kernel */
 	bool in_kernel;
 };
+
 struct prestera_kern_fib_cache_key {
 	struct prestera_ip_addr addr;
 	u32 prefix_len;
@@ -1017,6 +1021,78 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
 	return rfc;
 }
 
+static void __prestera_k_arb_hw_state_upd(struct prestera_switch *sw,
+					  struct prestera_kern_neigh_cache *nc)
+{
+	struct prestera_nh_neigh_key nh_key;
+	struct prestera_nh_neigh *nh_neigh;
+	struct neighbour *n;
+	bool hw_active;
+
+	prestera_util_nc_key2nh_key(&nc->key, &nh_key);
+	nh_neigh = prestera_nh_neigh_find(sw, &nh_key);
+	if (!nh_neigh) {
+		pr_err("Cannot find nh_neigh for cached %pI4n",
+		       &nc->key.addr.u.ipv4);
+		return;
+	}
+
+	hw_active = prestera_nh_neigh_util_hw_state(sw, nh_neigh);
+
+#ifdef PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH
+	if (!hw_active && nc->in_kernel)
+		goto out;
+#else /* PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH */
+	if (!hw_active)
+		goto out;
+#endif /* PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH */
+
+	if (nc->key.addr.v == PRESTERA_IPV4) {
+		n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4,
+				 nc->key.dev);
+		if (!n)
+			n = neigh_create(&arp_tbl, &nc->key.addr.u.ipv4,
+					 nc->key.dev);
+	} else {
+		n = NULL;
+	}
+
+	if (!IS_ERR(n) && n) {
+		neigh_event_send(n, NULL);
+		neigh_release(n);
+	} else {
+		pr_err("Cannot create neighbour %pI4n", &nc->key.addr.u.ipv4);
+	}
+
+out:
+	return;
+}
+
+/* Propagate hw state to kernel */
+static void prestera_k_arb_hw_evt(struct prestera_switch *sw)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(&sw->router->kern_neigh_cache_ht, &iter);
+	rhashtable_walk_start(&iter);
+	while (1) {
+		n_cache = rhashtable_walk_next(&iter);
+
+		if (!n_cache)
+			break;
+
+		if (IS_ERR(n_cache))
+			continue;
+
+		rhashtable_walk_stop(&iter);
+		__prestera_k_arb_hw_state_upd(sw, n_cache);
+		rhashtable_walk_start(&iter);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+}
+
 /* Propagate kernel event to hw */
 static void prestera_k_arb_n_evt(struct prestera_switch *sw,
 				 struct neighbour *n)
@@ -1463,6 +1539,34 @@ static int prestera_router_netevent_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void prestera_router_update_neighs_work(struct work_struct *work)
+{
+	struct prestera_router *router;
+
+	router = container_of(work, struct prestera_router,
+			      neighs_update.dw.work);
+	rtnl_lock();
+
+	prestera_k_arb_hw_evt(router->sw);
+
+	rtnl_unlock();
+	prestera_queue_delayed_work(&router->neighs_update.dw,
+				    msecs_to_jiffies(PRESTERA_NH_PROBE_INTERVAL));
+}
+
+static int prestera_neigh_work_init(struct prestera_switch *sw)
+{
+	INIT_DELAYED_WORK(&sw->router->neighs_update.dw,
+			  prestera_router_update_neighs_work);
+	prestera_queue_delayed_work(&sw->router->neighs_update.dw, 0);
+	return 0;
+}
+
+static void prestera_neigh_work_fini(struct prestera_switch *sw)
+{
+	cancel_delayed_work_sync(&sw->router->neighs_update.dw);
+}
+
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
@@ -1496,6 +1600,10 @@ int prestera_router_init(struct prestera_switch *sw)
 		goto err_nh_state_cache_alloc;
 	}
 
+	err = prestera_neigh_work_init(sw);
+	if (err)
+		goto err_neigh_work_init;
+
 	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
 	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 	if (err)
@@ -1526,6 +1634,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
+	prestera_neigh_work_fini(sw);
+err_neigh_work_init:
 	kfree(router->nhgrp_hw_state_cache);
 err_nh_state_cache_alloc:
 	rhashtable_destroy(&router->kern_neigh_cache_ht);
@@ -1544,6 +1654,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_neigh_work_fini(sw);
 	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
-- 
2.17.1

