Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFB76DCBCF
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDJTwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDJTws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:52:48 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB761FDF
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 12:52:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlGCsMNWLGc3Nc4xB/Psw83M9P55LmyU0tdZ+imuDlH34VnjzLmO2ioP1viEr5sI79JzW63uzEOC8YbrM7Fy8AVbjwtudiucRIKVNEp3I2ABBHph+jaoozKQiGnbHbzNDoYEF2Dw0gC0cUPF99f+aWeCQ0By8gwtVjfUjSdVoPG1xKK0UHV3dlgioqiErF0cH7WvYw3GhDeBl9ig/EF7Iux+QcO5pp0gCx2n/9S5YUtmxh5Vn2kMK31N2uhgqwpGZhuRCyG36pRIdk81eKB5J6I+brHa3RFGy2z5ILlqJ7Qrfz0TJ/s/jiXuFEgdMNhZfy+W5JcQ1rRUgma9ctouPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZbeckdCcx/s/cJwsrjzxeeNmromQPuaCLipzC3FmXE=;
 b=aQ6AzxyPujldfjNiyGu76yGf204Ki63d8Z7IwWSUJ5CDL3+K7cJhhNIeL30uNZbtYf117MRsGmW/3tNny51rVrzAyervxvJfE3cCtJLVM5GBWfYBzGH+O6zJ21ej2hTxzazrw21xKGsUJBIa5SaqNpopIv3CqzDugOLZxZFxb2ilOMTDrE1LEyLghablncXtxPnjQBJIr/Y/xkCk/4Z0OGAK1ORtinvC8aDPsSL+dCGjda4WO2jL3Pd6r7bHkjMLXN3IavkYg7Jzy5XfvkFaBP7Re8S7+WnAMFJYPIAB9S3dg+3ydqzI7dFd/KyY0K+se4gZGmj8PBwLayc4tKGxLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZbeckdCcx/s/cJwsrjzxeeNmromQPuaCLipzC3FmXE=;
 b=ksqzkihdO1a8EnK2cqKlL2K1PvWBcPkWD9xQYmQ1Sx0U2gR13L4yHTOVgwsELquCmUmvZvcPJ4QvxZxkxtIslfBAcQgbviMcy2yghB6Uxgp8QSut1B8kCjDbhyJurgfPesOWWqvnkO8s8IHr+kgHmV9R9PnjdyE71lxIFKYWAB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8257.eurprd04.prod.outlook.com (2603:10a6:20b:3b6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 19:52:39 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Mon, 10 Apr 2023
 19:52:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH v2 net] net: don't omit syncing RX filters to devices that are down
Date:   Mon, 10 Apr 2023 22:52:20 +0300
Message-Id: <20230410195220.1335670-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0161.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: 7348196e-b7b4-4702-4814-08db39fd23cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9qjC01NnCN1ocSVB8koCPdC0se0PV1h7VaJrnVnmzem4az6O9upSzc9Bwa1wMQJiJvBth3gAq9J9YI+t7JBXyqH11CyFIQFP13BTSMuJdvBSc8mu/jW8HLqMngCb0CpYpt5fGMWidNI3lJeIZsFLCFD8x0ttRmZ2Jhq7/aUgzPDJZ+jaM7k+PxkPkY3l53YwThGk27+p7U/j8a/9QM8KIRhfqEnb8IKcqhajAX/Ah04qFJEAEd+XS7mHnrJt2+UmzKxEC18Jf7d25/KYPfpCAPrntMc1h1SVZq0qNrcYbrMHQ9z+bX0BT3ATHTbXl5fTdSlSWampdUn14RvqjYwxblwJwTJZZtz3oSPyDcRWo0tyHJKqtxjAIYWvtnoPcLrCh/LNIDHAXdK4/bPo+uSVgyZuxuqjnc8dIj8ZG8fr7ctHiiDjQF6HgH8BFgnB7Ul0KlN2m8L5h19ic+zM1FIvths1jFjAFYM+dP0DXxr6LZdX2Ylo00UsQ4lDzCBOsQXneGupXnGfgkgE7/H09wTVwzxPrknt2SNJDkP4BWbOgji6IuFp6sBIBGKRDWdpUDI7VKG5lR0lhDP8/xAv9UJ9RYOS+K9YItwK5YP2vDecBuM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199021)(966005)(6486002)(52116002)(186003)(2616005)(36756003)(83380400001)(26005)(1076003)(6506007)(6512007)(6666004)(44832011)(86362001)(66946007)(66476007)(66556008)(2906002)(54906003)(316002)(41300700001)(8936002)(8676002)(4326008)(6916009)(5660300002)(38350700002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?63AC5EVZ6rmHa9sFVmj8UdCRNXCWG9SGOkTEyL9ZKwVOvg45sxix9VlVXcOD?=
 =?us-ascii?Q?yrBH9MrHdzRhxE0xymHz/IHb86CJwBr94plelX7Lfcoy/bnQavh0IfwoVA/Q?=
 =?us-ascii?Q?hJUFLh1nLJvIwKjBlB0FOe7v/KLjbziQ0oNIAQVXDL7Z/hPkgf0JyJ1CKUaU?=
 =?us-ascii?Q?alG+nDTInYPbwt9ic+FOhc7T2/DPNiJX1MaBYjPquS3MU5pd0OUI+QOsfl2b?=
 =?us-ascii?Q?bzrlspW+xNeqXBPg7nj5XUyU95pWsn0saS2evEwx8o7QGxHiueQdkGOH2V4t?=
 =?us-ascii?Q?TpsfZdI50LT0frZci3G3jxNMFyaHj2i+3GZZsgkqKg82/56M7DplpGcmrS5F?=
 =?us-ascii?Q?4fhu3kqxIADiiy2aKov2zg/UDuBASSouv93wuq0hQ8UA/oMGvc4uKD7pZnBR?=
 =?us-ascii?Q?b+tVLjjebqUIB+heNwbu1MOTevoEmYiOu1LPq3Hf9LJHpNvaoCi1VB0aeO1l?=
 =?us-ascii?Q?BN34NxZ+MoR9yLX66NsgWECE4W7/hdTsNlJRgA6/G7Vmy1ElzhBKoSAG0uc3?=
 =?us-ascii?Q?KiZNFALcGRt7Snisu5EgczySZ9+OnYyqG3yr5iZQCKu23cltVYezcyqGlHsj?=
 =?us-ascii?Q?6DnVrhQ/+IQKG8lpX1ptuJltZETciOBts9/356WnNDXaAVPIBSKXMYdyDcCm?=
 =?us-ascii?Q?sLr0uGSWTO98aeZqvx7RXvZlD/Awyzx0W2EaAdCoqvaX49EOgdq5Uf44hSZs?=
 =?us-ascii?Q?IeRr3rZ8togCy4heQXthaDZ89PkYjGeYEDybtVhxPdEwf5y2Ybz5ApBDMiu3?=
 =?us-ascii?Q?fcJjUVPZAXAvUjRQRWDbMoeKKkKbz95qFVhTLTjHy+bZKlbe9JfPJQrAvJoz?=
 =?us-ascii?Q?Zp2/MC16VTu9yOeoJK17dizGnoWtAagAsj5cOU34Bs7KPTp7YkNjG1F/INzg?=
 =?us-ascii?Q?DOLgKqOwHMwiCz5bB7vJuhMt1/BDBGyvIQVbNerD7FhD4FkGMC2H3QHCaLyu?=
 =?us-ascii?Q?RcBOkMkVQBMeOyfpiu6UBt65GoubRgmp8P2aW80hhpbpe9lGCv+w21EEDyHg?=
 =?us-ascii?Q?/CB8cljXb4vjR7/u8U9PjPatuRnC3/uYjtH3mlUpLXd+bYclU9CPlxDU4kJK?=
 =?us-ascii?Q?l7ePYoEv/oQ/FvezM5Mh+B2bn0IdC2WlX/p+xBcKSohM83NuBFaNogwKKu2j?=
 =?us-ascii?Q?0wFn7xuHjcXLMl/+oPW17geCO/ve0guYjmlEyOQMy3f1nOdqkkzteZYShdX/?=
 =?us-ascii?Q?/0rD2R5k/xhzgzPGSKtlHHIi0TW4NW/xHBufmknPQJQo/b6Wum1S7RJbhbjK?=
 =?us-ascii?Q?6HLeXaWJTQRrgaRZA2YYtiqFqk7Ngn61SujQTcbt8CdOzW16YwXVLO0mtmYN?=
 =?us-ascii?Q?ks377e4skvVxD8ChZrCwfWBMd4xR8mRqXmBEAeVJa7u5x073+SIUxmRyYSXg?=
 =?us-ascii?Q?gBCMlfcoxrEC/C2UG9jCVMSvSc2US8Sy4oQzPn8xoMhCwp6BACbZlYWo1m5Q?=
 =?us-ascii?Q?xonO7gDL/XIBeV+G9MKfYwAfPokb/8C6SWs+Q8jJfI78gpRhBi3UhjaK7GEH?=
 =?us-ascii?Q?bAwT8SO631Y0gnmkb7BQqSKqAaTwn5kgpne2C7HZZT+j9GqmgJ0Ub3129beK?=
 =?us-ascii?Q?RjUhHSjgezqlTAneXQcyDL+SCSWCBuQHwuyvFqaQWy+96XRnApJv6uDCGNyd?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7348196e-b7b4-4702-4814-08db39fd23cf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 19:52:39.5145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Nrbq0HvgN+nYcpiDLSiZo5McMj21/NXT/DQJ2MfyJ8nJysOHgy0u8UqgPuT4pfIKNFVxydrsbNbfJbax76fjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8257
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During NETDEV_DOWN netdev events, ipv4 devinet calls ip_mc_down(),
and ipv6 calls addrconf_ifdown(), and both of these eventually result in
calls to dev_mc_del(), either through igmp_group_dropped() or
igmp6_group_dropped(). During the handling of that notifier, the IFF_UP
dev->flags bit of the device is unset.

The problem is that, although dev_mc_del() does call __dev_set_rx_mode(),
this will not propagate all the way to the ndo_set_rx_mode() of the
device, because of the IFF_UP check removed by this change.

DSA does some processing in its dsa_slave_set_rx_mode(), and assumes
that all addresses that were synced by higher layers are also unsynced
by the time the device driver is unregistered.

That unsatisfied assumption triggers the WARN_ON(!list_empty(&dp->mdbs))
call from dsa_switch_release_ports(), and we leak memory corresponding
to the multicast addresses that were never unsynced.

Minimal reproducer:
ip link set swp0 up
ip link set swp0 down
echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind

There are 2 possible ways to solve the issue.

One would be to change devinet and addrconf to react to the earlier
NETDEV_GOING_DOWN event (which is emitted while dev->flags still has
IFF_UP set). That would work, but it would require paying attention in
the future to other call paths that would also potentially need the same
change.

Alternatively, we could remove the check/optimization and thus make
dev_mc_del() always propagate down to the ndo_set_rx_mode() of the
device. This would implicitly solve the IGMP/IGMP6 code paths with DSA,
as well as any other potential issues of this kind with address deletion
not being synced prior to device removal.

Fixes: 5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
Link: https://lore.kernel.org/netdev/ZDP2bxXGbHX8C4BC@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1 is in the Link. A different approach was used here.

 net/core/dev.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 480600a075ce..a83f725c76d8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8448,10 +8448,6 @@ void __dev_set_rx_mode(struct net_device *dev)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
-	/* dev_open will call this function so the list will stay sane. */
-	if (!(dev->flags&IFF_UP))
-		return;
-
 	if (!netif_device_present(dev))
 		return;
 
-- 
2.34.1

