Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0679E51EF6E
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbiEHTGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbiEHRm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 13:42:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A293E023
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 10:38:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoNjKST+p1FSP8q4hYcWCVNfugzWGlKNMQ1/MJL2V/yFK/sk/7lvZ6T4olV006mMI/Ve6qmMmqBLQHCNC1CMHlYKM1KpaxWnZ5G/m73wjk7+qsfVFDlCGUxISVleJ1D4hM+79HauqNSp9A3DX1rjQLMxfZx+9mVIXWCZu9uoYvFDT7R+OBAcRLu3xFRG+XYgc1IgA9TJZuG7OA0ESkU1FCntRmIJNeyrst45kH2p4HsUajJQUWLokFQLhBobhJTDXQLl1aVrGv8yTsNXhVyIULIEdJxWVdvvmUyUNWOAcRXeK9OXzG+X+tzhuZCbyNHRvUKeKxUaozcr0cfCp3C6eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJ31aCxFUYuBh+vYbpWi4o4b7sVn6vdQadOFJwwnoJs=;
 b=Z+O/wUVVI8r6lI+FEG7KCdDTgfY4G1b7UIcvYBddi66zAAxVUptwAeFxCD9MpWTVUoK9TqfDaDNwYkn+jZ4GY18YZyjfMlchba3R3idgkr0NvZ+7xVXE6jmNp3Vt1boAnEVLRCw+m+PXnAEr/tEQx/625rI2FK6nsZwwxvTyrWOQWwIJ3QV5n0as9GWEZPdeGYxQTucPr69WJ9wLhz/axwHhw6w9MJJ/C8id5NMwYm3denAW5UhJBaKiNsViY4pf32d3IGnND5dQxRXR6HUJNmpaXwaR52wDGOw0YXdENSwEYq5B0qqgcsGcefwsgETf+tkoHspv7dMwvt8UIn92gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ31aCxFUYuBh+vYbpWi4o4b7sVn6vdQadOFJwwnoJs=;
 b=iINwr00GIq3Sk5OWVASkVRVL8ULZOfg8cE1aZzVOMGogl07ysS4tckC7MIQxGWaNp0poW8Ytm5UB74vDvZxotSRS32XiREMHj8T2TtWQlshPwo0Qi+WCIS3VWOFn9K1d+fNvBZP6caHDCvKIyUyPtoakop8PZg+WLdcSXhTWdAI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1200.namprd13.prod.outlook.com (2603:10b6:300:12::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Sun, 8 May
 2022 17:38:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5250.012; Sun, 8 May 2022
 17:38:32 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>
Subject: [PATCH net-next 0/2] nfp: support Corigine PCIE vendor ID
Date:   Sun,  8 May 2022 19:38:14 +0200
Message-Id: <20220508173816.476357-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c36120c0-2312-4ce9-41ba-08da311991e0
X-MS-TrafficTypeDiagnostic: MWHPR13MB1200:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB120072401EC43512733C84C2E8C79@MWHPR13MB1200.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKYc+/z6a/4jxy2KgowBaAbA8NFQ9RQtdW1b2YctxAISI5oOgBVqaKTmiAC5hFGrlBPiyzYG1aHA5EiXK+tAtsn8n2gDB+iV5VC/O/YSVm2Ol81ZWRo+7ryJcKTucVxqEdWeelKAbR1RvAEmwWnu9CCuhSiDxEgq8MNsQqOpDcpsbdk3gL0PrQQ5W+u/mHbtS+CqW3QuAPJ+ELzXoUXoeCtYr6tobIFIV0oqmwzVwZ1SvOFJSvYOljtX3HbWXg5ZcgMihXJI3LARfaxX5p8RJs/85UJ74bPXF9BmRg5JWixXNOo0I7ceuPZ2RQfWqcu5vUXENEuGCR5uqJc7yWCIOTfgL30cQeUzZq7RtBpGQephvhwEY222ZqT95KSy/kRppEeboVV5ntZ2A6oSoFch1sgsJNHO7PlmHfyVivsQVitUtcqd2tkUGcCTquITm8PikIawZDh2mfqc8/ac/9nvAoAj/wJcrsx7jbLM2P7PaaJWWYy0zskrk4rGGwgSdhg13NoKXnVs6TSy7GkGbVPnrgjv7GgRk9OHDDMNhBseDXSgv7AsTgvnfZtmgowNqeKMXpLQCzJNnvrsjfW/SPSvG+/IBY8imDfdNtAUlM4nwAFnECERpiMJiJUvstP//GXvFCL5je/CX/5d608AWdWwPI/POmPLWupHeYS+JiSnRuuCwKxABfAcvrwPW4xDsXOr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(346002)(376002)(396003)(39830400003)(2906002)(36756003)(8936002)(5660300002)(4744005)(44832011)(8676002)(66476007)(66946007)(66556008)(4326008)(107886003)(86362001)(110136005)(83380400001)(1076003)(38100700002)(6486002)(186003)(2616005)(6506007)(52116002)(6666004)(316002)(6512007)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EvcBxF8q8bS6U9xv8FI0dBKRZp+tnVb5QuJSjntlJ9StxSCQx3LsvnW6bWzS?=
 =?us-ascii?Q?3iUodHf+WV4/NfBMGWaJpan9T2rOcaBfcLk6CmRvRBwLHklYaOw1F3gZWll6?=
 =?us-ascii?Q?IvBsHk5GNKsF5Y46Ma5B/xnCxwUKjpxNvldIsVscZT3b/1NoPMfLkVZgqQNO?=
 =?us-ascii?Q?ZuVpAJ0vs1tpBP5KeVpWFhwFcgx0FVLH/6N56u65aNLTN6kKceIlttTThPeB?=
 =?us-ascii?Q?oLiTyo3CVGCuSKJ0BgUSrAoCTeerJwl+mXC36ow/p9/MISTbZH3cPBP8qdxM?=
 =?us-ascii?Q?JGWM3Vu+C5j24dpKS/QiV8Rlhv8TAHik6gQM3Sab9QVLfejzbp72n5UOe/hw?=
 =?us-ascii?Q?cBqBsWOm+a649V3ubxUtq+vGhmBCqENbGdYuImpejzzjsUPz9l443gHt6o87?=
 =?us-ascii?Q?yhIVUSAVxyzPvq6kRCbCHgOQfaq25wzCypHEcQqwUzVjx3XRnk+96j8PjkjR?=
 =?us-ascii?Q?ixM6IgIa07B81ACFZmcMVzkf7CDBFJXegR+JzCz2kDNBxFx4wVHAtABzVl/Z?=
 =?us-ascii?Q?HmjmYioOur1VRpzXajhjOm850Wa2zbdlhMOrurzIFnF2AGtPu9iQKBc40siR?=
 =?us-ascii?Q?Lb/qqYc6L99fmZWDDm/Kji0DYVb1JO1/WCOWyFxqbBh+dZ7/B8Wri7lxDSWo?=
 =?us-ascii?Q?Ya9EBwgzV47Pg5eJjBgeAu2d6TKD4Q6V1VPzL+daFRuKZVyvqBpBxKhlcI4P?=
 =?us-ascii?Q?luypJ8St48v4io0LyuYHmJ7UjWDufCekcVnnI6+EmDKTrAk2j+CztQTxcrE9?=
 =?us-ascii?Q?a2Db4Khn8iYXEMfY3UQ31F/ELFeFdKQhBk7Ez0f2X6jOFEgWBDN6b4WYZqbu?=
 =?us-ascii?Q?kYx9RzbYRQCgNpvfdwH4dCK6RuUXTPhK+43qP2nVPirDdZ9RRt2Mzm4PslCG?=
 =?us-ascii?Q?oWbLhhuPz5wANtntU+AJxkNX9MqiGOPOO46onxgSy4wUFVBVeZyKa8MTb0v/?=
 =?us-ascii?Q?RUTSSNk6XDXaFlBCoLDrtVK1jCmIDX4ai5ou6DrIbZVHSZRRZxiTznll1kBI?=
 =?us-ascii?Q?cQUuok7DiFVtesWEB4uj57L2r5FnBemJBSByeoiguvDbTXVpomwz2BJyeXlg?=
 =?us-ascii?Q?4+hdh5dydjUbEFeKhUbVl/b3QODJYSYT5/R6FKB577mNI8aaXSxfoZhTnTE9?=
 =?us-ascii?Q?3/rv9ifvW8nIHdeGXLdnCBdoOTUCZ187Kw+kCUwnkM4bgJDS63IYqreJTh3M?=
 =?us-ascii?Q?Jcq/C5INjvHBusvo21DARXryH3Ep0I8/SKkJ99xD9hKbSwfdtKLdAm17ki8d?=
 =?us-ascii?Q?IFpH77k53ea1wI9jHxv9vfwcvUrCgts/5kOHc+EZbN4QDzwX7s46+xweI+el?=
 =?us-ascii?Q?hVPAqaEAxDtkKiJmtynnBMTExexk1t1CTYeQ5DD4vqHy/er7ZMUMcNZMAPO4?=
 =?us-ascii?Q?oA14HQFyTwRUdV8Xz9Uv632lFD9BY8D35FrjOnOazMVz8nih9pmq0pxYQVGX?=
 =?us-ascii?Q?cjZ4bqvEV3LPqLWxdkvgLchyN7S3wNHhnytwDHO+5SBtnyaOlvY9Un0qtYos?=
 =?us-ascii?Q?2/JAlK2ye2r8+wMojM7bI4R8hfQTPy+Mtr9zV3vYXjm+J52sEMTMaf398Hoh?=
 =?us-ascii?Q?F8BmA46BUCEUsGZynSLVQjNr1tPxcthZ6r1+g2UFq6suwOSmeDL0upwUb/xY?=
 =?us-ascii?Q?aNhy1id/N6s2ylYq/gjNsR0bvUjcAi5CAHH4cJEgWzD2dtjahKJer/qVIaOt?=
 =?us-ascii?Q?Y+KczwAAK0OVh2w6UvlgCHdlrlJwtolIBUAozjr8lggDlVvGt/vYRDH2VADt?=
 =?us-ascii?Q?9KSJjXDhhmGX8WvD3siNpHrBKcVD+ct4D5Px92Vbcb7UOzeQQQyVfFvzY8EI?=
X-MS-Exchange-AntiSpam-MessageData-1: 7bhu4TCEzz8LwJORVODWMclDaQFsDwDD8S8=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c36120c0-2312-4ce9-41ba-08da311991e0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 17:38:32.1744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qr5xEnmIrW4gDc9znu3WnDPp7WNiX+uBXi/FEnlwwqB4SdC5BodG6L7iYwCc3v8wCiHYGxLXulchnoYwQvsUtL9UAUJ1SaiexAQgKTLY1pM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1200
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically the nfp driver has supported NFP chips with Netronome's
PCIE vendor ID. This patch extends the driver to also support NFP
chips, which at this point are assumed to be otherwise identical from
a software perspective, that have Corigine's PCIE vendor ID (0x1da8).

This patchset begins by cleaning up strings to make them:
* Vendor neutral for the NFP chip
* Relate to Corigine for the driver itself

It then adds support to the driver for the Corigine's PCIE vendor ID

Yu Xiao (2):
  nfp: vendor neutral strings for chip and Corigne in strings for driver
  nfp: support Corigine PCIE vendor ID

 drivers/net/ethernet/netronome/nfp/nfp_main.c | 38 ++++++++++++++-----
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
 .../ethernet/netronome/nfp/nfp_netvf_main.c   | 12 +++++-
 .../netronome/nfp/nfpcore/nfp6000_pcie.c      | 18 ++++-----
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.h  |  8 ++++
 5 files changed, 57 insertions(+), 21 deletions(-)

-- 
2.30.2

