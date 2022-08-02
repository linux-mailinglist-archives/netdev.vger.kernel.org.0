Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFCF58797C
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 10:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiHBI7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 04:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiHBI7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 04:59:38 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2123.outbound.protection.outlook.com [40.107.101.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1554E622
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 01:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxrtOL0kbtyt9gvhDqXvbOVydPv7JKRwytGBQeih6bH37FR4BxyHa7DdnSE9ycfr1lvcikqm+F03gCWv0FDYETxxzpLi1nTsADofMCbo9jg/qCQrTa7IY0LPXaZ0Jqo5XPnHs47j9HizN5lBXP3XTFE4l9aWzmcf99TzSUWHiI/5R1HYh2jNi64itFexP2RvaisxYkHHXbKnHso2/ueIKwOTrBaxNg06WKXrytD/QZsRymQSUezuqOignyIFrxJ2tPHq7CbbBTwUsqiTW0i/Sqy9OyE6MPgBWkxabYq7Gl9o7DAK2RhcUnwidCIeH1aDWoMfJkpxBmINP0lDvlqqxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDMI7x1GfWAlj6RdX1HoV7LmAKtTUyXPBSNZ5hW1OHc=;
 b=HYWRZS2RarWjN0dvettqyGlxCHS3yXosZbEuSIEKX/eVdEKFwdLy7KCeEGKtk5WAGrji+mTgPzeqx6YMRL6n5MCkUz+QnId99KkyUhMSIigbZCyzj4ORVkbEexbH8ObkhAg5V7QYcllTfDz9Mu3Bzj0O0dFveLL8i8Bach9igeXdLKhV7mpUqeDHauf3ftpoueb0ojlu6jPOLnN1kDesuQBiNOYBE2H7jCumt04+gUUFw/cASnl4fGA9R0HqWgjKQjFocQxjMH84QfTdJZvIeyb1smKfkHKMKzZHJMocGSEHZG/HxihZzRRRJS9m2J48iLiJKsBLw9iKfJ+lc6iEqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDMI7x1GfWAlj6RdX1HoV7LmAKtTUyXPBSNZ5hW1OHc=;
 b=Yc138voGmjTS30UVHCqmg6tYgYsnx5VaTVXS9T/l49sxNG/BEn7HMnVQ+Q9jFRzAy4/NwC7YLxmYVgeo2Gvp/7D1VCWW5OcIfTFkwhBIBySnfAXsoTieSMb5dDe0/CQtKb+d8DouYvJ7Jp9OGdRMtraEzIE0NXFYUtJG72q8mwA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1323.namprd13.prod.outlook.com (2603:10b6:3:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 2 Aug
 2022 08:59:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5504.014; Tue, 2 Aug 2022
 08:59:34 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net] nfp: ethtool: fix the display error of `ethtool -m DEVNAME`
Date:   Tue,  2 Aug 2022 09:59:16 +0100
Message-Id: <20220802085916.63988-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0075.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a50ee449-1b6b-4b0d-8f2d-08da746551e1
X-MS-TrafficTypeDiagnostic: DM5PR13MB1323:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uH6YqHc0FSEcljGeIfV6U5eU8rEQeo9tD6guC8rKdU3Nv5CA7X03BxOKPy+OfAz6mgXVVH6u3OW5TSLVDubtbUaw/zMaGr1y16xKq4n2rtds9jheQfHIJOxPPThQiGU3XmGKE0iqoqE3oiAQEI6im5d5HuhetdouN5BDz8l9t5hTnCTbUcm8rq9hp0UJr7i8jySxAhXQ4QJFDWnTGgMffQOGd/XVu0cmOADwDaopNogcyZJlIE84mNY1C6OibjHlPTTdoNszzabyRiFWlgwWMDLXLdrtEwqBi8Fvw8Ka75Po15p+CS+JzykBtMqXtkb3jotjuWW5onKJeaTA0FFSJagCtWuPv2QMSXGDd9iAhm+jFM6LoGCk7Zq86izG1Zib6eT+DnFzs4485kVrfvM+8xtN7XHKPibF0VsVNQ3mwf1pf1SX0Q6LGYLAfAgTMAStVk0p2fIbo/+sXyQy83Ou6qVKL7Ejei9moWtx0r+Ar4k3IAIWdJWztE4oKRI47+MY8kw0DMbkn1jNKQ6uAGKQ9lvp/1FoKAxCfw8IRiqAf7TO3MSw1XM4Cd21BMxRZxbfvzmXIP0Z2XPLL2LNOKlxgugEiGWA/7EtM8kunKKgWMwoka//o68BZ+dKTQqLyM2c/YP3dmIYCMQIMusi/IGYsC8Wih8/GuSYBK47Kbv4TfxEf48ASn+RvvPI62HwrEHcTHciG7LrKd/U2srzmP9WOFQ1XLAqlW5waPqTZ9NDZQmR+ag2/nYQYlGdi+7CIczZGIF0OPHP2ysHFCkmjzkki7SurrABueV9dv3Rf5wDBKwQbg5nPyKiKCkkSke3KcoPwcDy5dHjHoBjLAQAZJ1YWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(366004)(39840400004)(186003)(83380400001)(36756003)(110136005)(316002)(2616005)(107886003)(1076003)(478600001)(6506007)(8936002)(5660300002)(6486002)(66946007)(44832011)(2906002)(66556008)(4326008)(86362001)(38350700002)(38100700002)(52116002)(6512007)(26005)(6666004)(8676002)(66476007)(41300700001)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZARwExqzVdLgL+d5ihqzBfrRDxYWwiCVwhdfgeA1LWRPNO0ApBuOLCWDCzWz?=
 =?us-ascii?Q?PGe8eCHtMfEDE3vy8f9BsNi0DOke3K25O/lzTs5LeBief57k8lZX39+3wHPo?=
 =?us-ascii?Q?whCTsT58f1L4c2cxyd8T73+5SJAnI8IHYbxVSPo88QarPgb0wiTI60PmVyfB?=
 =?us-ascii?Q?jkmzA2pc/u4O/WBXNDVwpxicNcLr/FnHz2rbFVglQEkVH2BZpuAhUmYj8WSO?=
 =?us-ascii?Q?h9zonioHkoSMFpnnuKL9hUzDcaZXkgr4Bci8hNlte/uefdT1kzFXqZsQsFfE?=
 =?us-ascii?Q?HX789fAHo2AwLoS7WqEvFXQd9bAIeZHMo3zakKGbi35EUi9ef7dglPXCB0Y0?=
 =?us-ascii?Q?vCYbB+X3oAm+b71sNOKqktf8t8e0B0gbcz2ln6SE/+Bx2ceum+F6w0P81rQ+?=
 =?us-ascii?Q?gKrASD6fSwnCJENORh3apPE2Un2xyh4UH0B+NH8lJmk/0aXEuAQtSU75iYqM?=
 =?us-ascii?Q?3S3hIHoIh3kAq2nn+96IbnY+cZHUV0sZfNYk/EYl5RAu6+7BKIdl+XIs8YQx?=
 =?us-ascii?Q?QDc0Luh8+HP24H3vc+oYDdDspkvmV6N+ZHVYuCQQWMjNP2PmpsbGDhQgyV/d?=
 =?us-ascii?Q?hPNaKAL7Id6w/AaNa3XOxA8LfScgc/rtme2AihNxqwgirG9KE7aFfBN+XfzD?=
 =?us-ascii?Q?zqCmB3JSlqZoILy9sDpr8GhilTcXoVBvtPLR+b6p49iBYqgecRMKdSMSQucw?=
 =?us-ascii?Q?un9HQfaQ0SNr1jS+n4WGxwzplWRdIlO9tt964ncYdfabpXFzaXj8oQdzUls6?=
 =?us-ascii?Q?birnSDCVOZsZUmP/asVTCX4YM6RGtUH4SjJ+oPKIUUyRd4HLKjTZaem4pxaC?=
 =?us-ascii?Q?jK/a2h2c9Cl3OzWaAug9QLY27Dgq0V1wlB9uy1eN3INUXMg9AxUYIyUxQmX8?=
 =?us-ascii?Q?0U+nTnQUu15J8EuWDqOuoIZIKMSSU8KIA/FmM5hX06w6i+YhkotTaoh0m11J?=
 =?us-ascii?Q?x6judb+IvUkMMW9Lk+8+LrtBMaH1z/uwtxDqwxT75sUuMxlg52rHqljhAahA?=
 =?us-ascii?Q?6b2YUotM+ohCApy0pDC8BAKP8jERCm/BuT0+Bx8tb3FRg891WWzUhP1VLJd0?=
 =?us-ascii?Q?q+HFIFCB8osUjFGA0qtnJSu2gJgdmJX3gFXfcz/2wpCVjS3JSMsllU36hhfL?=
 =?us-ascii?Q?y5a3+zuy6zlmMMlPeFM5hUOYUiwmmcc4zA8xLH2zd+osypi/5jBo3unNBWln?=
 =?us-ascii?Q?RhIm6Rkf1/+mBtK7QBkGalfI3KmuB+hPkbINdroT8ljg320M4iUOxRGpP0yz?=
 =?us-ascii?Q?6HR755y3eR32KfXmEL1x6BCTSEQUNymv9hYuCgHZGHfGeLzeYmotiVUxgkXF?=
 =?us-ascii?Q?TUDNYW57uOGwR0o8IXlr+U4w9404ytuJne1c/yt+th/uKFvOS9UqEuYZdgfo?=
 =?us-ascii?Q?nbTefgvrrWdCWNT3zHPUdJmPhWfoYQgYz9Rjb0CnVpRIeiuJmv77acep4tLt?=
 =?us-ascii?Q?uV11jes0BZgH9t5uNfH1JdCNzV9VuXTKiQjn16xHkpTJrfIVIzn2TWDWMYRL?=
 =?us-ascii?Q?/UFSYvxcD/xkseJdPgHG+6oTUHAKoMWBc63LW/70WRr3V+Q3quhcD7du6y7C?=
 =?us-ascii?Q?oNvSdbpRIodbkkLhmrJVTE6ag5axSWZu/SHZKg1mlHIw1XUCWuHn6qxXoU0b?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a50ee449-1b6b-4b0d-8f2d-08da746551e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 08:59:34.1383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kEanayTJ8ZbVMB4wjLtEuBaSCaLIGGd6Z2g5o4k8xyUdWO6Yc6J9hyMxty2+yv8xn6ZwJdcuqq6aAikO46ORESW+Pyus8xWHwTFZeDYe7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1323
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

The port flag isn't set to `NFP_PORT_CHANGED` when using
`ethtool -m DEVNAME` before, so the port state (e.g. interface)
cannot be updated. Therefore, it caused that `ethtool -m DEVNAME`
sometimes cannot read the correct information.

E.g. `ethtool -m DEVNAME` cannot work when load driver before plug
in optical module, as the port interface is still NONE without port
update.

Now update the port state before sending info to NIC to ensure that
port interface is correct (latest state).

Fixes: 61f7c6f4 ("nfp: implement ethtool get module EEPROM")
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index df0afd271a21..e6ee45afd80c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1230,6 +1230,8 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	/* update port state to get latest interface */
+	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
 	if (!eth_port)
 		return -EOPNOTSUPP;
-- 
2.30.2

