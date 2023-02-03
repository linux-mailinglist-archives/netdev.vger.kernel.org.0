Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC20C688B7C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 01:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjBCALf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 19:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjBCALe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 19:11:34 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2059.outbound.protection.outlook.com [40.107.14.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6B0751A9
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 16:11:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTgw1zZL2H/hjJpnyvWSUDdDXLSSke53bxGNybBZXf0gKj8j6CQTgJ3Bi5aVux4z67wzHRUmczzHaqSiWQgs+fNfpe9VEMtforElG7409Cp4me/HTEplTaK1w7Hj9/CEC0BxaNDZI5n41KPDsewdx+QzleXieJD8/F+UF+vrq3skymlBfgXWHmCN5rY4OXGp8OfiXxY8LDACfmMHntKwpUqdruHyRgz4u8fWyqEwA0Na3PtMIg/2omdvBcW/SWF/2u50umYrlqn0Ds/8kXQzM4SjFkevDXXduiFdItOm7prLd1LRbVbWgxd/RdeUi2EuWKugKS8fKtHAjFH8+pyRfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLWDwMkDM3U4qunMCN+4zvOA9Brzxh99wJ2IUiJJvjE=;
 b=Tv3oDAN4pJ/mvIQOM+Mx1LFJmm5ew/MSF1gBDWU32gLlwWgbAxgVonWvQAr2WnaEkwMcxBNPl1G+ZdzKr5QXafRTIiCmLhMOXxb1Bf81pffG72v5xK9/rd49/ALkQ95nYqblpl/pq78SpXD4m90r5Yx4sruga8cNAgCvFIeENuOIy4eeRfL4Ydmzw/UFL3BLcotxfdUdVB1loCRZsI6dTmdkfyomjpOCxR+oyCgkd6tWeDrz7k6amULucZleHu4HiRUSIG0JmiOEk5kmUMwh8NKGs7m3PHC6hW2OIiFWgaldK33pipthmztxl8mj2mkOkMFRdqUTJ88JtuXg18/HvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLWDwMkDM3U4qunMCN+4zvOA9Brzxh99wJ2IUiJJvjE=;
 b=esHUkmg43zaSj2GVWG7gMWXYCiCRy54Ck7wkKI3pLecPfwVFyeVdkoNk9iMo3FrfHrbYm6aayyDNRJPrn0+JNGGG+hoxOcwombMwRWW8C4K1rS+U7ZDWR6ONgDU8Yh25NNkPRRoW2hS+KqCtrTFQTjn8dxPkObNWtPHKfrxVhe8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9128.eurprd04.prod.outlook.com (2603:10a6:20b:44b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Fri, 3 Feb
 2023 00:11:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 00:11:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/4] Updates to ENETC TXQ management
Date:   Fri,  3 Feb 2023 02:11:12 +0200
Message-Id: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0118.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9128:EE_
X-MS-Office365-Filtering-Correlation-Id: e455af01-de3b-4d3b-0140-08db057b333d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5CYp6vVLB/3PZ4N1bRLk4vJhrs/5Sr2CeceGtzlMRrYFIITLj352rJZb2MK65aLtNbvBGZZrbe5NR8+6bDSxVCgmB7+I7weeT0iFxMYNRuQtuNoU0CapeLVijPWrzWzqx5NZmxmyjynS5vVyenSxmNETD2QUrpHG6h67+r0TCCLa90j6tEcUPjBORYEfRCj18oBbRGe6RD8UHPTNgTe0WrMSaktTVwelgyRxJXmmenaWJEnPW1FVTruODfmAeUOg/kv7TX1r7yHnizFsLLJUw6kiZa0kp7RekyhNrqPirIb4s/VNMcwGjMTurdvnXYVi2JcTwL23km4xo9cwXmFzCZbLOoEkO08a5cbg7KOZXbZ2/vZ+EGZ56xGyGN0i5MdPuIAIMUWXp9B5xbeuMQipOTA/rPz+xc40Pl2/SgJYd9ldYLxiF/XLVCG5WiRE/AJkgg2+dqBM53q2q5R+bfDu80UukQzW5NBJ8THAATccJXH+Ekspb8JtLRxGOshICWqf5KZxCrVyxRxsfmPzOj1b6pVaJ7WBL76zxB5U3pr3ex+bLh3UlZF3pLGM8BRfRtDAUVbqht5n6uy5aN75KvV/UMg0xvYNm5fpwSLHiNNNWbLYsQ1url7Ea3LkeqwxXMqNXy+YCYazFXedajWVTTS1fHV7505zmWCZQxmWGyrocRCLcXMReozMzukRKVPD/VVc6l9HrgDVGXmdSIXk2kqPNLfEq4xvqt7JTEj8tS1pd8A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(2906002)(44832011)(26005)(38100700002)(38350700002)(52116002)(36756003)(83380400001)(316002)(54906003)(2616005)(6666004)(6512007)(966005)(478600001)(186003)(66476007)(66946007)(6506007)(6916009)(1076003)(86362001)(8676002)(4326008)(8936002)(66556008)(5660300002)(41300700001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?voBMGiqjT2qwDgD7g1HEYpstBLxn+Dji4daME6hcS8DlQVRqV/5g3YdaUeMN?=
 =?us-ascii?Q?6b4zrPSd0kJyZIU9ecPCZ6GA7WQfY6aMslQ65D+DioE/6aYg3bplMmv+Q0Mf?=
 =?us-ascii?Q?G6Ho5dmmDj9Ze8NOGmnyItLFPR2+UOoN8cJimEL/wEUgAlFsPRhcwc0lJ0FI?=
 =?us-ascii?Q?IyUebkvS+3EQxH8dMMQjgzIONyyBl9p0eKyhS3vmAszWhYxuazz1gt2n0baI?=
 =?us-ascii?Q?BttoqzjI//DwBulRUbJyOaD8TylQ6cLxcQ8USIbdKCr87kWN8bMlM/cWJVav?=
 =?us-ascii?Q?HB2ahux0cIjwWG+8oKLWNcWQ8GbQ7sH9dJvgM8tz5OAPYYOXBmR6hC+mrTaA?=
 =?us-ascii?Q?4BPKypB/oeawAHbS4J9PL2m+NxUhwp3mL5hAg3ax7NCuQ3l7H6roDBIgTYC7?=
 =?us-ascii?Q?63QQULXC+va+uIehtHQDzyh6A/tHnx+a4/+Z1L8YC+v+vudLpZ4+s2Oa7tdL?=
 =?us-ascii?Q?LtKgPDqbZM1SZj/xVOPv9ftprD/Q9weGBY3rttsVnC3aE6Fz6vTBjGmKBbTD?=
 =?us-ascii?Q?uLD0IPUm1oMvt97UKNKiqpE9FvGSrZFdSk58tS5tbj5HlmhDPqSCFdkIj7Be?=
 =?us-ascii?Q?R2SOit/A6Oubf0uM2bJsuZP2u465/BnAXhk5v9lw4BzOM/mP4LP1Y/tUS9Zb?=
 =?us-ascii?Q?su0POiZKixhIbv4Rvaq7bZW4UW+9c7Fka3QCIIs0Rr6JwLMnjLOyaNtnGxjJ?=
 =?us-ascii?Q?RbL74abvuKlvXPaW8HYljubdZAwD4U8Kfx6KtJt5ldCEBVqp62VydkZ0Yp8j?=
 =?us-ascii?Q?hpmN+sblQPL1/L7x2ZoEFfOANzoahqDnbW/qv0fvE10SIbHD9M1iVMJfv80q?=
 =?us-ascii?Q?HJDreMlJbFiefx/MQLgM1HpEFIwuH4qy1K4g3z8RIM3OzdHK9kxDspLQtD8v?=
 =?us-ascii?Q?COg6v2cWmH8s11I7gYmDXLR2tYEd5KViuOYbGUn8hu04w7t+u8iXz+7Mf7FL?=
 =?us-ascii?Q?nFkkp10uvI2pCceDV6glKR4QhwtgYsNme2bAiC2s7nB40t7/kob7N4ziV+oS?=
 =?us-ascii?Q?CuV9Noxvseb9lXN630idL8VXbgI52IsniX+ipOB26/mU6RKPTGHXzY8ESNtb?=
 =?us-ascii?Q?C87gAFdTu7PKDw5iYxXkgivYOySVZpQOpKzhoyUE3dj5udEVZ94lLL1gqEAV?=
 =?us-ascii?Q?RSsCuvCgFV7mjIgfeUDor6jBTzzx22ptcX2dTWBlP82BALgYa8BVHNUip3J5?=
 =?us-ascii?Q?9I6bBqNuQWut47amgg01NXPZm9LCIm9qoOLNpTBCm6oRA5q5INFvdQm8n9A6?=
 =?us-ascii?Q?bH5Hq/zV1aOUc6J+HLJJuKgi+/3mLvosgDvA4eF9kbNhnoNS1g6D5NVhluds?=
 =?us-ascii?Q?c2w+OABKOlaHUdJdE+DlGRbhnMiFqmW51Ol5Tg8tjXVT9lj28x9HX0JWPKQj?=
 =?us-ascii?Q?QI+ZvoaPQJPLNl+64mYCUeSbMIBX5S64IE0Jf9OVMdSiV860Nz9HTW3PxVjn?=
 =?us-ascii?Q?T6nr97kJVtco8wIJ7awtR7f81F9LfhR48yp2fXJQgItN7hxn5SoU5jsAoQfP?=
 =?us-ascii?Q?svAX32cI9STfp80CoBMuo11P0AanmVQ5QRbwQP/2+Fy3jSeO2415XYI87DAy?=
 =?us-ascii?Q?l4Csc0RB80Sm0jK87ftsuKfU/JujYniwYUnvUDyLbaTD7p9ML2VtIN5EoOpE?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e455af01-de3b-4d3b-0140-08db057b333d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 00:11:30.5871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQpYRMEpG0DxbTAkJwooz3YEcqLAhvZZ05q0XC5333bWUimspkQdFobf9oDra2x8+9NyuM8mxZlBTD1IS8KbvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9128
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set ensures that the number of TXQs given by enetc to the network
stack (mqprio or TX hashing) + the number of TXQs given to XDP never
exceeds the number of available TXQs.

These are the first 4 patches of series "[v5,net-next,00/17] ENETC
mqprio/taprio cleanup" from here:
https://patchwork.kernel.org/project/netdevbpf/cover/20230202003621.2679603-1-vladimir.oltean@nxp.com/

There is no change in this version compared to there. I split them off
because this contains a fix for net-next and it would be good if it
could go in quickly. I also did it to reduce the patch count of that
other series, if I need to respin it again.

Vladimir Oltean (4):
  net: enetc: simplify enetc_num_stack_tx_queues()
  net: enetc: allow the enetc_reconfigure() callback to fail
  net: enetc: recalculate num_real_tx_queues when XDP program attaches
  net: enetc: ensure we always have a minimum number of TXQs for stack

 drivers/net/ethernet/freescale/enetc/enetc.c | 73 ++++++++++++++------
 drivers/net/ethernet/freescale/enetc/enetc.h |  3 +
 2 files changed, 54 insertions(+), 22 deletions(-)

-- 
2.34.1

