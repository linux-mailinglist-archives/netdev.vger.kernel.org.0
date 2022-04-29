Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42385515902
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381726AbiD2Xe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376652AbiD2XeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:34:25 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2109.outbound.protection.outlook.com [40.107.101.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD788B0D16;
        Fri, 29 Apr 2022 16:31:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huE3TPzGl8dVGauCvW149fiBHqrj3HQu6rw+rgX+7VaKRwSI406oftcQ5kaFpzVJqoZYM4pSTTpTL4HTlxGTqQ4z6tcvW0vuJyh3mjimv0cHLFludnjVN+Bw6d3qrB4UZ29cn/fMQkqp1UZ1IPKUr/kYngsTfmVjuovjiaiZMzlw++Z1P2kJPokXonOh6iNYBpUxc9a356wcGpYmT4bVbEkqzTugm9Fk09NP6h8/6GnDFfVcNk516V7z0T4z0eV5nKSNKtjwyNezr1IllLacJyWJAsuo3V0G/YdxyQDuzPQ/TFy8QXHHmDReMjl9yZ0kWrOo/CKJ55Spx1I3OKopXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgKWtVEZ3up+wPwvmmGJSQmpFmFuU6ycm0LYZUneewQ=;
 b=CSoDyn6p9DijDztbGcdM1iUEwqEktAhQH/NJWMY8HpR75SMbIMXtpN9cevoDG94ZBZDA246VEAw3Nbhl66tNx1RfHmsO8nr/+xUSE9OqYAu3NmSSR8fCnId7Pektrkmujk6MBMvujxzi8hbhOXtVqTrpArQEFOF40LPTlwXw/RlYf+IVfsVHLycMRDbsJ3HgmXVwxWj/rdd9RESqvlTqt6WCvhu5Bhv9b+LEH2nQDS8dZfl5Oey8KCeo52kFkwCU0knXJsW61YQzz9GmF93G2xZvCELpNU2mmgLhm0MQjzaD+nCvXhcSLbJFZF735LjqTzY2S4sYjdDdOrn9zygFVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgKWtVEZ3up+wPwvmmGJSQmpFmFuU6ycm0LYZUneewQ=;
 b=cYbuu6Q66ONeH5dLfraT4lJMuhUzEWZ4Hw8mwiJxLqDhRr7Ftsj1dokZ501VJiA1YLoDTQLmpahH+GXpESRqI1uPJHZhTvx6mLkwX09m8dRpLOYN/m3g7v8eKzCRUf5R/w4m/OzqWMe7I1snuKYdl8rHG3lEjzanrAJaZjYLh+8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5483.namprd10.prod.outlook.com
 (2603:10b6:510:ee::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 23:31:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 23:31:02 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net 0/2] fix shared vcap_props reference
Date:   Fri, 29 Apr 2022 16:30:47 -0700
Message-Id: <20220429233049.3726791-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::37) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5564afff-7aec-4930-6ac0-08da2a385277
X-MS-TrafficTypeDiagnostic: PH0PR10MB5483:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5483D2B0AA88668465946B3CA4FC9@PH0PR10MB5483.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unK0ZIWgFQWNXOUZPR5XX9s3nmNilo7BowEpxcROER8+E2o10hrZyxCN1O06opxWYwaTiYcbn8q1Cu7HsSYfrTEj2PvL2r+TmfXC1SzJ7lgNChv21bhO9y/YISKGkvMx1mS0mItlMaDGO6ZpuCTYIoz83cuj6nmOmgVAZmY8x4kLsgYsQCsGQxx5NOLljqvn+Y+e5jdU8woAghmT9druDZczLUsFIteJohvW4y3l8d1+waB+JMHX2WoeDM3dN24Zmy8vhlOT8tCp91xfVIHstT5KudY7w6xlY+JFpR6iSQt3uQvFA2EkkTM4GFptm9EGVFi4fdp84NdrN34Ui9QEp/MLiajuKR/ZxksrzPWTUFflAIxT9NB1PtW8tcmRxJICXU8Jco7X0fPCE2r8sqd2iqHTuOvLvvh+ItjGfJHsJ4My6JC3mGTWObSivfvb6cNx7hodKLHj2PhAPvlSVPp5Mw2EZAjufPcQuSd2XTqYPzl4jvJYS1I1M7htfchkntoNJ19WKxpKAZdC0fM/lyp8dXtpeFtPC9BtavMTCEDnvGgd3T6F7gbH+QsDY0jT58A7RB9D7uTbkVKfH5+FX6PYQMWNY++Xo4budFDG7ueZcGRGT5BGuWe6l3Dll0/pcbbQFAsaMcw0xBHqTCj4aIATsZcicc5HAb9HugA0fXLDsttQbvmQt3MzE3hNeLhUQfdCGCLG+9Ewp9ALkjgeqKva1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(39830400003)(366004)(346002)(376002)(508600001)(86362001)(44832011)(6512007)(8936002)(36756003)(7416002)(6506007)(316002)(5660300002)(186003)(6486002)(83380400001)(6666004)(38100700002)(38350700002)(52116002)(2906002)(2616005)(26005)(1076003)(66946007)(4326008)(8676002)(54906003)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jcmWLURkwZ0uDPsH0pxqzsctgn/gOMJILUh1CCdBcCYoKEgS2oNOABDdTXJS?=
 =?us-ascii?Q?2Xm/R/uSG/rUXXqxU1JYtNFmQMW1sDIKEcK5zKvMNldgZcUVHTNTcuFcoGfy?=
 =?us-ascii?Q?tdJEP/RHVMR53G2smxQPHyE/hkM8w7JIAdwr7L/LNCEgtb99fuFw+NWbVftt?=
 =?us-ascii?Q?VnyVkXTWJt/4DSZP4NXwajX4sZE75u2TL4BwTYHHdCeRd+ApDoOZEPdpRUD2?=
 =?us-ascii?Q?MhRqA28NLxIbfmafpZ4k9DDfw3/8tVzaYK0kWJx5MqruryJWFdYdfeE+HB26?=
 =?us-ascii?Q?JP15gv78elWzth92dokxC2ebJDkDDN+4F7aeMIcP5YO4v5cXRd/1T+VaJRAp?=
 =?us-ascii?Q?3bD0XwS2wvQkfhYw8gXk9eyX3ARVBm6ODppJQR4TKkpe91GRIVMXo+lC2uej?=
 =?us-ascii?Q?TxS9BEPAyektLZZdDhnGTj3HQfoc5/r0dkMz+7dRSChnHblSxViMUS341D8l?=
 =?us-ascii?Q?7n/pVnr1xivyBeTo1E3qddbmBeziluFoJBw747Aymx+DHIQvnuaii651/puB?=
 =?us-ascii?Q?DA6qx0kX4gAMSbLMs3Wgj/8GZACUKqxI2gieoaI39NxPnR5iv69to185c7e7?=
 =?us-ascii?Q?KscQ3P/HkGuzgPqCghbW/uQ7tgL2BgT3VH6ri8iCWGMDnxQn95NdrqrSUXHr?=
 =?us-ascii?Q?Ujmph/0XIepGXSwvFsj0d9nwmQArKkWDN9C7EPJDK+g3HNro68doQyjUQSiY?=
 =?us-ascii?Q?PDfJYrY0kNH48nKAM3vlSL/JYodqKXcdZfWKJGr5wc9IiyWd8fsm9m4YqoGa?=
 =?us-ascii?Q?1iND+9PNJBTnoJuDaMQG/YcVIAkirD4NIOPsdtFaSlix/5YWWxePIWv1wpvw?=
 =?us-ascii?Q?zYkeJFUoFssE4w57SnyaADwcW0YuKqS6WXp2GF+t4K2NQEKlj/gd+U3X/kFN?=
 =?us-ascii?Q?XM72/5/JO5UOPnqmPf9NaEZCBihYdpXmLeTpW2uf7ueUMe3aXaezemkksH7n?=
 =?us-ascii?Q?+vRuxSE3aMJ6UaIhEzLQMWNFgoZSuPrIjM0VKVgXvo3cGttpwZT6NsIVgtOK?=
 =?us-ascii?Q?4SaEfWsIWqt/o5WO3ctV98wNHUWoIyGGvdE06QaBtKwNjczyCIX7XphNdfIh?=
 =?us-ascii?Q?4O1WUJvmIP0uVr7EPEjA63g0lkiXSc4nhCUf3IYYJUydipgLr7s2VYouqN2w?=
 =?us-ascii?Q?xB5haPzmESGN76HBGk+20rakBWC8cWrIeiG0TT+Hjy2QpOHfhXhGbz3hjiyM?=
 =?us-ascii?Q?Lz3zp5YrO+j9ePpB6MufB8BR30yCuuJfNSaAWZ5OXrdBfFXcQIA0fcaejtSf?=
 =?us-ascii?Q?yt9aEWyqhOl6i3yWVUIYG5boP9Fr1S9OvALQjpJuCfS3Prc16ID1kP1NkI/H?=
 =?us-ascii?Q?8bvVGVU5jyw0H1JzmcHbc7yEecOTYwncKVNN94XR+fYzfXYofjpDITw2uLgw?=
 =?us-ascii?Q?SXft1uVNXX7fZldYcceEmxj0/T1VpcxdQqQiYGiQPyqaaJUqFfXbuSEOrCYL?=
 =?us-ascii?Q?thvutwr6yJCRfL7nYEeEb+Pt2catUcHj7a2oQGUExHeuQ9vLnNgF76VNcZEK?=
 =?us-ascii?Q?A3/HsZEfFD1tlQi1aKgEpC9P+FW3I393u6z+VL2G7FWaZsCjUlIIJbbdKadP?=
 =?us-ascii?Q?rkQK8JXfW/CKHpUuzRlYu/NtIRq7SB0CFtXw3OoFuftAz5iwDS5o0ZjEZWgr?=
 =?us-ascii?Q?Wgcz3mJYgaTSjZVwkQwB67EZTcsM9ODBuiEh334VBctexneGWnmZbVv2PVf6?=
 =?us-ascii?Q?cu2TdGUvK/XLtnnKCFl55WVZQukKcGupV7nLWZ/zMunCCQZAAjoJM9UTOeRX?=
 =?us-ascii?Q?X3cMgL3a1YmEJbjAoXzxP6AAbur1bir3Tp28P+U4+YdpzslkvFpA?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5564afff-7aec-4930-6ac0-08da2a385277
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 23:31:01.9251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /KwQWmBTfLAeba7s8jjjDdMSt4B1HbWa20cjBPHJMkMTV/vQmMbidLZi3h5hKddIbeY03ugmwv/dFAxyctUCsdyS1UvJzDVe+MhhBfdYJIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5483
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix vcap_props get statically allocated at the file scope, while the
felix / ocelot instances get dynamically allocated at initialization. If
there's more than one instance, each instance will be writing over the
same vcap_props memory region, which would lead to corruption.

I don't have any hardware to confidently test the vcap portions of
Ocelot / Felix, so any testers would be appreciated.

Also, I believe the memcpy of a structure array should be
architecture-portable, but I'm not 100% confident there, so that might
be an area of extra scrutiny.


Colin Foster (2):
  net: ethernet: ocelot: rename vcap_props to clearly be an ocelot
    member
  net: mscc: ocelot: fix possible memory conflict for vcap_props

 drivers/net/dsa/ocelot/felix.c             |  3 +-
 drivers/net/dsa/ocelot/felix.h             |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c  |  4 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 54 +++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  5 +-
 include/soc/mscc/ocelot.h                  | 34 +++++++++++++-
 include/soc/mscc/ocelot_vcap.h             | 32 -------------
 9 files changed, 71 insertions(+), 67 deletions(-)

-- 
2.25.1

