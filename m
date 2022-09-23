Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044C15E7EE4
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiIWPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiIWPqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:52 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56011DFF0;
        Fri, 23 Sep 2022 08:46:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvqlqIS23mdk/xry1pE2cpjjKF4ECRPhjFWNNKc4dXlKrhtxaPXk4yLwH4ydyEHSmAzWj5dqNrsbFUut/s33AYRqvB9BT1RuWkkbWK33bU42JeFBIwrCILUF1tHX7waa6+Apy6nByNrb6Ou1mTdz5X3W9QBeyXZ6nHS08FKDfYpD8yl9x7xfiggdZtyVt0BrUW5pUf0fhXw/pxDA8d+hptEJv9saBbQaQpnZGvKHaYuzLRo4c138XIFiu5Fk+zw2C8uSVtS+/1fc8C43Os03eN4LIzGkjnYUZpPkVlQNefutxGtSrCFy65xY+jaWrJ4IOQeQ89EiZIyGlB27Q70Nhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtPbCQ+ml/Dq0MeBdk+YWGR0W9o8044lN5BTHO96ecw=;
 b=GOfJKhm9xSkdturkTzRcgYOjwaWI6jI61gwvLV9WKQwckV83UlLuKCBKf/BpHhdC7wdF6vY4GRbBdrXfQvH2I9G1Zmmd84glrnYH02ezNG2/pjG2+Zp4VcfkoMm8qd5KISV51jn1wdRu01uCb22gIr6w+wq2K6SIv+4JOFnllNTyoUrkGG608xAkp9853VNxCEwGptBwcNSObs2EQNcRhtdLnrYIyOTK13hkrf8r8+kmDoIxflkspmVSDVpJFrAF2UHSfjVlUHLdl1jvZtXhG0f4mhQzyiF8RAkKh/8IuGFSWSuqUn/qxKPLxjwE9AyVitYc59PvLKl+UUxgbA5+zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtPbCQ+ml/Dq0MeBdk+YWGR0W9o8044lN5BTHO96ecw=;
 b=ozr+Xt8vN0/HeBkAE4eST0LuZAHU8+OSyPGLIkRSxOBHQTdxnm/I3uZQzbmseg7Mk1Aroov+pttiTQ8PagtQ3I06BGqNnDER6wLmzkDABOZ4iXV7qqZdCZD7C6V2Ac41482g0gzkg7MqRj7z3gWlhCiC1GqA2y46ixMMhAC7mpo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:48 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 07/12] net: dpaa2-eth: use dev_close/open instead of the internal functions
Date:   Fri, 23 Sep 2022 18:45:51 +0300
Message-Id: <20220923154556.721511-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923154556.721511-1-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a406335-0b8f-418c-611e-08da9d7ad2d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eQYwOfiPlYfUtJ+uGosTY8Al1HxiDR7tTl+Z2LPBTGVa4yvunt/noinXaoBGtl8U3o++VvRBef82OC/ixacNT2DS09D4RZCqRqdQSq14yF2kJI+N0KGr4I6QqpZRgNXp13lcXZBAREAW4dxdkoKAl9RxoJu/yvcyXb+m2R/ngIK4D+FTnvhEQh+0iwtOVuTJ8mrpEOxoAKt9e3fENX3tznGNktB8GifBgODfWFDuDQx9ZKitMM6KXUAj7MrJPJ3KlBhEsCCw/ktD7Me5+EgWa38hrbbsT83C3XHM2nZOKgV7iVbL+Qs/dee6O73E3ThXETkQjiEeOaN0aBZQubFLydUsHKUcfV6bkCAyLlxJmmtazaxakMwPzCm4tliP4xcMxPTd7Q9cHIw4Kc2pb8BuqCU6dkPwdwAMFRW1i4LFbQ/9TUXWilvcY7GBqVgwIxkVSjIF8eLThP4YjxtCxVUsLAnG3Ja1hZKhK29WGAhnyKlTm8FcG1Lg6M1FFTKzcMijirnPgIVsbYDTkRVibGrNkn+6PB7h0iHtGGKLcUhcXvLrWGZzN+fI7HatuZGx8BMnQNL565GJvt4NJ7SUr3BVKCKLfRq7BgSxQOeujlUU/02d04IUV85Us88Kv+x56ZFodDd1gFl6n7xkMtFf5lEu8zwJ4MqYfa1gHCbfz+EHNJysW7l4N4SbFt4ff4VREqtkxsvwPAQRvYxNhEoPCNtHduKxYuCw9JzFHkPqY5VXr/6rAjVNCtU8TxvvHXZOsmjgFgmohD/1K8Ji6fUDaViHWRae582oNXDFg2+DfERm5c8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(66476007)(41300700001)(52116002)(83380400001)(6506007)(66556008)(4326008)(66946007)(8676002)(26005)(36756003)(6512007)(38350700002)(8936002)(38100700002)(6486002)(110136005)(54906003)(6666004)(316002)(478600001)(2906002)(2616005)(44832011)(86362001)(1076003)(7416002)(5660300002)(186003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gjxMplx/Q7+aFFjvxudBjfe2hJDYYsaSDxZjmMu+LthhNt1a+HONlFmPhx9M?=
 =?us-ascii?Q?7+3x9VMbe1oMiLFmALJhOHUhaqpvYSmFDobduufWdDMfdfLq/6bdpHIQGP/P?=
 =?us-ascii?Q?sBSFpuYq1pvuYd2eqGYkIG51+jl+cqcHh6qlnGTAdVOXybrSGgGzDPEzWjIU?=
 =?us-ascii?Q?6gF7fwz92srpYpz/NTuZ4une086hyL+xMK7gU0Z8Ul1BBazo2zhj/Ys+VyCe?=
 =?us-ascii?Q?Gt4Nk/YyMMLFoU08tZe5C8nvxxooSPgia5ri3qLQqe8NNecoFt58oeHYqJYS?=
 =?us-ascii?Q?QOpS7PXbAqGMDSdPxVMKqJF/j1xpse/q8Cz/WGXJx0Wr8OLtu9uiFe5A1DXh?=
 =?us-ascii?Q?JyFvi6RjjXqQbCLG2WrgFQwr0Ex/MbZZNDQNt6eVbc0GsZoEXJwXh0Z9r2z4?=
 =?us-ascii?Q?G/VF9Gy8sbp9jxudiKwBDElFKuMmoZQwbMzgkSJR4MjBuBuJn2UV0y/nFPmL?=
 =?us-ascii?Q?FH5ohIkRrWj3+SoW8YKO9nTg/5ycmgnmUbZEsNqU4mw/yQn364b5oa/1AyyR?=
 =?us-ascii?Q?eZ/Z42nQZby1SUnb1Hns7ECVPtAJ3GNVm5USfXrbgb2sAXspuli0YdZoskWX?=
 =?us-ascii?Q?ZCs8YCY9veH7IMUqU0b49yoaxeIIN+jfsnvaNIIc4Bq1TvCogX04M4k80crg?=
 =?us-ascii?Q?fIyq8DDFRREKCfJoXr4ZzaBxdv7BegT3WL+IpfLGS1qma4bgSUpIy+2/NmA/?=
 =?us-ascii?Q?PMr26k5VqIcYciVinAiKyoUPtKEoyry9XizzmXHLYO2t8993qr9cYQruemye?=
 =?us-ascii?Q?qys3jcOjFaz7+2mLPbO8GpCIBcjcJytl04obn0/ZN9GC8kMvOHjIdEaOPBWx?=
 =?us-ascii?Q?jtYIQHB/39iPHTN+JZ03sEimL1CIYnQxkOaj3VqrfP5OfMBxdJ8XNCW5TxIa?=
 =?us-ascii?Q?4u8J0ZhdZ4TbkDDuK8LLxjrtM+u7yWIcmv5ZdbiM2Nkz7kQU5WXofNBH8rbn?=
 =?us-ascii?Q?XpuywGv8h97c0mmiXPn3vschERlb2r1/lGcNCpqlARHEo9MjqPlxQCdL4ky7?=
 =?us-ascii?Q?OtsrAEUBAKn+SIz0iRVtm7gw06vxp/MNDp1QJEtAgpHd+5hWiXDvEuFyLxfv?=
 =?us-ascii?Q?m32Abk1Mhdhyi9ihkdAfseW6V9qSGFpXW9cW1eH0RRwiaZTHleZ58Vw5exy+?=
 =?us-ascii?Q?2wsUbPe/i7C5U5XfVlb/F+eslYY6FyZfundaxnzr+U0JWMc94i5Yw8v8ZXTm?=
 =?us-ascii?Q?aAcvQdc5/aPglAyJHXweA2mbeK2oGbW/FflqrZYZcsdrF94h42D87WmcbvKo?=
 =?us-ascii?Q?sz280Xzo5ArbLTA2OqUB+XVXQDW2YQDShNBOExvEo0ogGttFehvM/BLqEbN9?=
 =?us-ascii?Q?ke3mVmJmls0LaV2/7Wo4FqGQNFgCLV2TB0yvO6ai8MmBrrxb8TUj1/pzQYMT?=
 =?us-ascii?Q?OFEXWgmk9Rvg9EpUn7Ld2YqkjsRXmQyq8uEZuQdTJuA0ELmr6fnQOP1b2Xgg?=
 =?us-ascii?Q?IqiRIOyb7KN/9oZxKaPuQhqElfWIOEWVWg01wALghiF8by27Mwc7TIc+97wi?=
 =?us-ascii?Q?EKsAGdxDZA8KEH7H32zWZ23Hn71uC5rKjMSci7wAx+kKPWyxAFlOpT6e/QtB?=
 =?us-ascii?Q?pVAEmD83M14LZpbHKVHEY1SVbhA7+YrvbuM7yKTN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a406335-0b8f-418c-611e-08da9d7ad2d7
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:47.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DM/rWxqDwe4rIvOyY5HX21l7kjMSVXylyYHtVPinXnPxgYy5WaLQLFnHzLfoiswkO/C8S/eBZaoKtMqCKfxeQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of calling the internal functions which implement .ndo_stop and
.ndo_open, we can simply call dev_close and dev_open, so that we keep
the code cleaner.

Also, in the next patches we'll use the same APIs from other files
without needing to export the internal functions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index aa93ed339b63..d40d25e62b6a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2626,7 +2626,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	need_update = (!!priv->xdp_prog != !!prog);
 
 	if (up)
-		dpaa2_eth_stop(dev);
+		dev_close(dev);
 
 	/* While in xdp mode, enforce a maximum Rx frame size based on MTU.
 	 * Also, when switching between xdp/non-xdp modes we need to reconfigure
@@ -2654,7 +2654,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	}
 
 	if (up) {
-		err = dpaa2_eth_open(dev);
+		err = dev_open(dev, NULL);
 		if (err)
 			return err;
 	}
@@ -2665,7 +2665,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	if (prog)
 		bpf_prog_sub(prog, priv->num_channels);
 	if (up)
-		dpaa2_eth_open(dev);
+		dev_open(dev, NULL);
 
 	return err;
 }
-- 
2.25.1

