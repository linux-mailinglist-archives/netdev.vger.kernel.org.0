Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C724C30E3
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiBXQDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiBXQDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:03:18 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2080.outbound.protection.outlook.com [40.107.20.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7031D192E0C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:02:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rl9THtkLsNQmBoun7kFOcgJlSGdR6GXnAuDQIbY4Br78B0JbStkvPYFG78FuztnM/BiHSqZZvF//DRoMwbsfpDmNXUSEWPa/7GkoV3MLdtX4WoUpwmFa+L3utcN55/cbieCdVkR5GLGuddH1c6oUP8keqdR9fkD1AZI+9JLEj8/Nxb4hAvzhbsxKpMPoyPNzeCwtFLMKDQwEabFM2hXPhVTgSGWfc33+D4hMLZVHCJCPNyuyNmM3OVvb9D52Lty2VCFUwxVevt1ojdyO4s8Cg8ECqEpnFUvTbAeDSG1p198X7XxWAeIMPFPCuqLZ4ZVFroW8JgMOJBzrK7Xuna0hwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rd/3EZmBuvM9v8ssspfYzgzSm3COse3+5Clt2nEz49s=;
 b=cFXPsqTFcP9ALPgAN7AfkJP39VA9ijFwoTaSYqxqrohfFs2D7cLHDl6mgcBqegqDQ9Z602lZFCBfP7WgDTVM8XcZcnKV7ROOgyMdFVwRG/6xmUZ9vIRLq1pR/Nit53Rerv4ddEMHLkUzkUZ7daTrDwi18XJQDNWr90yc17R2IzzKw8cpsAERYVdx3oqW56/34vp4+t7zAUvlwfDYmr/SO4TWom7qMqbMw+3qKgFWHftiPq72t2fOS7m1cf2Hzkqzk0lPvpc97YlAhb9vbS7TQNyNL8Ng2XWjTyTtYse/nI0dcAOqbwh4biQiGO+eo/QwHJbeMii1fBo2OCkL8FE7gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rd/3EZmBuvM9v8ssspfYzgzSm3COse3+5Clt2nEz49s=;
 b=iaVO6JG4UB7Ix8Dopw9RfRSZWTaT0A5d5R8hyyqnxZV40ZfinxS4+tI20XxkfvneU7e4GtejMFbTmcC0S+Wm9QTwcMQ/eHM3uSB8gZIhyy1BwxEl17+61VR2lgSYLNrAW22DnioHDNrrM2M7YaPs8k3D4wEzwhtBGJrb3fjoQgc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5875.eurprd04.prod.outlook.com (2603:10a6:208:134::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 16:02:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 24 Feb 2022
 16:02:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net] net: dcb: flush lingering app table entries for unregistered devices
Date:   Thu, 24 Feb 2022 18:01:54 +0200
Message-Id: <20220224160154.160783-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0002.eurprd05.prod.outlook.com (2603:10a6:205::15)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c153dda-ead8-4a7c-ee2f-08d9f7af0339
X-MS-TrafficTypeDiagnostic: AM0PR04MB5875:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB587567379261C58D7721B487E03D9@AM0PR04MB5875.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKERDnxVmEwcxMUTkec/20ElgJ9Z0aSYwZhcZpbl7/I8wZH1BTE9pIO9dDldoTXBYWcS3Waz1QIbKKuY2SuQ2ij2sYET7Vi8XL86u6RROgOp4MupAO5Za5ECDeY8pOQtZzzqE0+6RbIEIb8jIgoxlT8+NFjp5PSWoBM5gEWHc3T1xZb+DY1NylygeSCr5lLdzI98m54u8I3J1gMFHOORlJI/SOXERzon4/3HB4KkkkPlpbXnYJdQFPj6waCbPlZCFmOGAS00xiwA6RyKDD2CUvtojWbjqKY6TSlBAZOMkCz8R283/eCDEIHlJ2cfZQnpnDE1OmOc3IwMRmbY0fuLNc7wkVJWss+5Dr7n5/KbO0TWw3enHDw2XJkx9Q1AasicScHaoXpEF1UCmBllS4NOFB1B72NuIjVrGrLtlsia1uof4zbcvINlLd/9WuR5wlpszNvBMWh7lg/h4VESo3r2YXxviedOnwlCQ26JfjG8O3PabJeyqCtO4XUwAxGAY1M55iWjN9+nDPmt+18S/Py4+kSlh9AQkmTvEcmczbyR7kQzgT+oKyGQb5DJJ9oMXSYk/YsMErpZTzhB5gs9swFuIeWNuRw0dfq6WifC4FL632mllX2wCTZOB2zwC47R6GGbVTOEq/bOVRhlw5558PzG4NE1yaPx8DO9N6vfQJuQYO8Uf68OPn3F6lWdDiOj9QB+YoKBK7V3Gh1Fw5p9u1A5GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(508600001)(4326008)(5660300002)(316002)(86362001)(66476007)(54906003)(66556008)(6916009)(8676002)(6486002)(2906002)(38100700002)(44832011)(8936002)(38350700002)(6666004)(6506007)(6512007)(83380400001)(186003)(2616005)(26005)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y7M0LxRs2cLxkNnaly9qsUV8gE+tQ3PlAuZK2LI4zMXrebS2BJKbCxZwzCPK?=
 =?us-ascii?Q?y4PxxoN+ObRd9I+vjbjrYbcVGj4FCPWFLKfsSk1XcOGWif+y4q1k8H5NraAR?=
 =?us-ascii?Q?ZjfC3VFFpE7Ln9u9nKLRbNkcQfRrXw4tHgggGR8VfKGdDfj+zzKK/Qexb5Zs?=
 =?us-ascii?Q?XIk1z7AyJR4FC/GuKAZq9elFnL17k/UxR9YECwtJlSVs5RfcBSfxDIjAGJP1?=
 =?us-ascii?Q?4Nl95/zE/X2lwjNejfTzBmeaAxq3+BneDlhvAE0DDwod1K65Xy0hYpm1fmqH?=
 =?us-ascii?Q?QHns+JyQx97YUUfMj46ALRI1oNF8FQKG3V86xKnsVs/iILIqIPzUgpcvaqdG?=
 =?us-ascii?Q?MPBZFQNvvswXXfaYIL/UZE27SJv2416AUbtK8Jd6+0DbUtkBZKDbvoO37V3b?=
 =?us-ascii?Q?AgmGqhN4jkVaDai5lmWhA2Ip8aE7AzdhXCIODSalrFuvj82qblbWl0GIa2QK?=
 =?us-ascii?Q?Mu2qMnhnNDtDEJdvFLDoSuXJg9DCKENOlMgtBlqIw0ggg7SaeAbmBc0ADCk4?=
 =?us-ascii?Q?9wJ0U8bjygiwGGmO3sBP/0ZA+nyr+Oc6nw5msYg+oANRguCsbIzG/hjVRWCd?=
 =?us-ascii?Q?tU8oJauPCyjNMXGqHY4sgu16FN923byCuRqBAGDKYj7Ql2Lnp9hs5/B/Ypu4?=
 =?us-ascii?Q?V4DrLxksNWexSL4yRbJ5HSKeJPrzk3sOGYMci0B0GXcNhL2IodDOuuapyIz3?=
 =?us-ascii?Q?RUum48+W6ZlFt6TsX8dscBEvKkMGKx+z6gNQgbVRA9bCqpH7opq98GEIBD2Q?=
 =?us-ascii?Q?1s6/ad76rABNVhOaArMmRI8SG81+sBprirvuznY8FvcxEAaJM46PdAW/QZC5?=
 =?us-ascii?Q?4Aoek0yQ5A+SPaaRf3hm4oj7wEUxlE46WsTZ62pD6J9I6mkncmJDVkc6N4vo?=
 =?us-ascii?Q?qiKRvre3DruQnZmkQAOmB5VdrLLTZFKcO0E2jWqLklRfuHd6+E6nkZWFygrz?=
 =?us-ascii?Q?Y+eOnmfEyCW4cDpwd/CCMLVa3hLa54Q5UxPWJ24MxeWRKhRtGpXef2CvAjIe?=
 =?us-ascii?Q?Ko1Y7ZTWyWIloJbWlDyFDC7kfXflHXake+zczOjIk+QK6RY3mJdKIcOBQ9gB?=
 =?us-ascii?Q?bU4E0N0aRqdi5spPAW+obYmemX/nyaPpJY8xubZf7FXEMuJXG141dZauZXzp?=
 =?us-ascii?Q?lbVe0ueXeTyXqN49iZFDgCdyr3DK9QmyqaBB3a2VW2EB/clFc9ebrKzrJ/WV?=
 =?us-ascii?Q?jjMigjADlmlqOmw3e72j/QaLBZ5//gy4wvOd/vfrvcoxNRGV75l9f1OJhocV?=
 =?us-ascii?Q?pWbYYz5Cy/z/XosdarYF3zmO5iQIMt37DS9zo14ikA5Ct+ux/CR+mPWo8G7S?=
 =?us-ascii?Q?lhd7soJ1gS6G7tSMiGl3kTR22oJLaa24O8iXr3qIbcqMPMHqhIXWBqvXj3wt?=
 =?us-ascii?Q?dvLkaf8ooIJt0KPLLZOBQOW2vA56w4I2CnJLvJD84r3ergF9umBr0t1jhSwR?=
 =?us-ascii?Q?N1gXUo1DYBAmO63PBh5QKY6tReUNekXxWr2tjYAaG3QpTdPI7fqYBV/ZJEUZ?=
 =?us-ascii?Q?wcrpb0BAhXmiR51SauJK6wC6s6TcAoj6+5I0yafaPa5AUSYXjthekQM69S41?=
 =?us-ascii?Q?DsbNiVf6+QI4pkZnwVvYezchSZEiOg0zux9KcLkUYwxvsonC5t1dcmFkb4WG?=
 =?us-ascii?Q?aOQ3x+tRj/2p5cMUqQEc0ls=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c153dda-ead8-4a7c-ee2f-08d9f7af0339
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 16:02:09.8070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ya6G6h6Sl+4ISIGb3sZS0dbYHU0SbstNL/VbWp6fsPP6Kb3sz0mGW2BSG+ZcpzJa0PmO7JAqxUkW6JSkuLOjJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5875
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If I'm not mistaken (and I don't think I am), the way in which the
dcbnl_ops work is that drivers call dcb_ieee_setapp() and this populates
the application table with dynamically allocated struct dcb_app_type
entries that are kept in the module-global dcb_app_list.

However, nobody keeps exact track of these entries, and although
dcb_ieee_delapp() is supposed to remove them, nobody does so when the
interface goes away (example: driver unbinds from device). So the
dcb_app_list will contain lingering entries with an ifindex that no
longer matches any device in dcb_app_lookup().

Reclaim the lost memory by listening for the NETDEV_UNREGISTER event and
flushing the app table entries of interfaces that are now gone.

In fact something like this used to be done as part of the initial
commit (blamed below), but it was done in dcbnl_exit() -> dcb_flushapp(),
essentially at module_exit time. That became dead code after commit
7a6b6f515f77 ("DCB: fix kconfig option") which essentially merged
"tristate config DCB" and "bool config DCBNL" into a single "bool config
DCB", so net/dcb/dcbnl.c could not be built as a module anymore.

Commit 36b9ad8084bd ("net/dcb: make dcbnl.c explicitly non-modular")
recognized this and deleted dcbnl_exit() and dcb_flushapp() altogether,
leaving us with the version we have today.

Since flushing application table entries can and should be done as soon
as the netdevice disappears, fundamentally the commit that is to blame
is the one that introduced the design of this API.

Fixes: 9ab933ab2cc8 ("dcbnl: add appliction tlv handlers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dcb/dcbnl.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index b441ab330fd3..36c91273daac 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -2073,8 +2073,52 @@ u8 dcb_ieee_getapp_default_prio_mask(const struct net_device *dev)
 }
 EXPORT_SYMBOL(dcb_ieee_getapp_default_prio_mask);
 
+static void dcbnl_flush_dev(struct net_device *dev)
+{
+	struct dcb_app_type *itr, *tmp;
+
+	spin_lock(&dcb_lock);
+
+	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
+		if (itr->ifindex == dev->ifindex) {
+			list_del(&itr->list);
+			kfree(itr);
+		}
+	}
+
+	spin_unlock(&dcb_lock);
+}
+
+static int dcbnl_netdevice_event(struct notifier_block *nb,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		if (!dev->dcbnl_ops)
+			return NOTIFY_DONE;
+
+		dcbnl_flush_dev(dev);
+
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static struct notifier_block dcbnl_nb __read_mostly = {
+	.notifier_call  = dcbnl_netdevice_event,
+};
+
 static int __init dcbnl_init(void)
 {
+	int err;
+
+	err = register_netdevice_notifier(&dcbnl_nb);
+	if (err)
+		return err;
+
 	rtnl_register(PF_UNSPEC, RTM_GETDCB, dcb_doit, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_SETDCB, dcb_doit, NULL, 0);
 
-- 
2.25.1

