Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454CE68D9B8
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjBGNzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjBGNzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:55:06 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2081.outbound.protection.outlook.com [40.107.249.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743AA9B;
        Tue,  7 Feb 2023 05:55:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWnn8Qn+IzGlOxCU0evRb8i32851Bj2YHRJmhStpglQHmJsM22WudN9a0H/jo674qcSUsBTJTFcK+fT3SMuc7tqjZSzi3PuML5F0+Cut7JtRMGcA3D4nNtmKTGhGT19obR8o8/Ay3nhRfyzb6VBAbmXP8QESHiC+YS7ns5uagNU0htCB7g+kf9KErX86pyIkG89PfJVY0rKZewpOesBScLeg+houEDe6PmmFFt6959q/0YRZ0jcFbxBYZiwliLt8KxVm6x+lhhDn+XtwnwWZCJo3GKZWRIYrJD4xx0NV88utQP9bdEAATSpzz9p6plsQW6xPihSsReRykGgF/UN0wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5p1G6HAb1hNypaegy2b0d9rW7m3NXjhbJuqIVcuxMw=;
 b=XGUdSzxnn/ezTjZdkAnVZkjo8pazmB7SB3czBs4n+iWAKirJejAIP1Vykj8SxvbuoN1fQtlr/4u7ZpkniIvGKSN7bQAGWS/XsfrYjGTfLVixZdK1VNrweDtRFRI+fRjmJkvcqXaQra+KUc/ZVIUaB56YCZvXeO4pRzD+LnW3YodTni/82LIDXrhENufEBLhTFW35NE3uBNjL0ZBOeG+b8TOXRVpcfCVi4EJY38xX45KHwsnoU07k055yiA4WS3pzmYoqiT9uOvolqaofa01TcnHbWV0v7Sr8oRAMWr4P7iwkT/ebpdSN+vSBSbX7MQelf1ovNnyaypcXXbC7jfDjVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5p1G6HAb1hNypaegy2b0d9rW7m3NXjhbJuqIVcuxMw=;
 b=l/i5KWJfMP/PD2JPcsFjx/Ayu5gGWzPLK3xVyAyVP5FpJFpIa6YQKSzTr4JPTQatOmGxRKChmM4OYRScU4Z7fDXf7x1WvLJUIwaJIPDVFomPnQRJ9Iymj8CLxbG8+rQEhk4e6Qa1/+uv6X8fkGMkLFlE137FgnKdAdOVFyuRH7w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 00/15] taprio automatic queueMaxSDU and new TXQ selection procedure
Date:   Tue,  7 Feb 2023 15:54:25 +0200
Message-Id: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: a989b726-989b-45e8-a65c-08db0912e83d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DCMA73mZajFQW2HxDidUr4RtPgGO6qNm6lmI7Ew3Wg+tURsHfhBB7dIP8NFbnYF1whfiMs4lWuQayYadMt7lPCbtwpUeC9qgR3RDkAoJLgYx3hv/aLR7m33NyQkl4hZXMBGy5j+sf1bqeuxk8V3mJe4FIT/zOJsb0L/nfBk3QJGGDOqkiha2NmXUtj7z2gnXyaoizZszeUmx4qvz9BdyRSS3fn5KXh4SMSPcszg7xqtpbrtLVPJZQ5r4PTN+MPB4e+liHim+/jfIdFpBQM8+NrtDflWXi8s/U+vzyAhzXYlPDFt4zJJiaDhFm6+EfPjAleO6YJLb+v0BM9pS5BlFZ5cYmaE8Scauya2/DXoraHzolj/hBx/mszfoGVR/TiJT3u3cYjEsHA9LAAPGmjLLWrM9eJwIXl3+n14cL1NZXfLi/qr3EBQ6c8hzxq8tJw3qDyLQp2LO5Pxbe2VJt+9GIqNuB2a9igN/ciQEsnrRlduMNqgyADh/A4Im0KRW1XaIK+5895kQxnhrwazGwpaQimecDpWy8/gAvfde68KSpamg3hUBUbotsc4jB0ODiDFH08WVVK/EzZn1/ouO0DyeFnhrMSvq4l23v1JJGm/gZU0E2GiShHgg6fv14R/qCw5YKDfUS/VOATmLRaZtqFDcTrbEtrqKAlMoWHBa3Orj18v+V0Vw+UEc3CV9bOjVxggNKhDiIHiZ9rU+Z9YjYFRuUwRMTsOe3qpdVhrogr9rzoY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(966005)(2616005)(6666004)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Jx+WN4Y1HTuYaCk21jwWUhTfsih/4ZOLVT8Rl06MxrjOxc/DmkyjwEreuDH?=
 =?us-ascii?Q?nrfNiXds2mYfIUcyjTOReaVuKokmdJPSIrChDanDAg4BWKveZ4ix8GF6fbVl?=
 =?us-ascii?Q?I63CHTxCIYjKJNv64Q06Rrk2zPJOcN6UqB/h+DwOwN0CqcMn9X8DrXbhjhB+?=
 =?us-ascii?Q?S9R3xU2HD1/uvZFAKeAdH6wg6nZl3/D5MRE4zFQZXIQlVDHuPS198ElWk4TT?=
 =?us-ascii?Q?x2d8L0N8anZm4uXqTLbHFm2nTazQnyfSALYF3wZNCyWNoAzYlcBeUBZq79rE?=
 =?us-ascii?Q?EAnShta1QQyg7s08tJ/wnJ8H792rmntEqTupCSnMXy0JhuC4trgz7HSu3pZL?=
 =?us-ascii?Q?LLTle5LuwA0jHLwJSxTH1xKuEwP0JeZbC/xQvHAlCo1x/6GiWySqy7lRoY19?=
 =?us-ascii?Q?PnXiWktCxVQfAarJZeK2uylJi3xOUiCxaKUV1cOq9jwZ4R4ifL8OYgU9grwY?=
 =?us-ascii?Q?d0fEGh2SI2XHz6hFA31yWvIy1wpCdRplBNJbkk4fKbtTBocrwlH8sZtSTlf3?=
 =?us-ascii?Q?sAhWzasKtYpiNLXquDAebFq9KipmhAHWek5YPkIPZdsr5FBNoKegN/ilzoxb?=
 =?us-ascii?Q?9VUVY11W93ygMoBZx6h4GF+FWlZXw8q+9cLBRqk00eL7EuYquKpaZOT4A6cP?=
 =?us-ascii?Q?eOugvIlzC7tj9pgRzNDXgfwX54/B19BeQtLYEZLjTz/F9kIfQA7iAyzHyrxi?=
 =?us-ascii?Q?y/Ijnt2pN+P4d2eA6cBBkBcImPlRlSeQ9d8MfP4AVyhFkjcMZq3BA53DdGTl?=
 =?us-ascii?Q?s5ZvNgK3m03jncSR4ed50etrzZFQv3QQGalY6IjhCBmBo+ZXQmA75lgEhxYK?=
 =?us-ascii?Q?8Q9vvYcAvNfN/o32qTxWZU72ZvGHbOuaIdN+c7u0R88XPphCTuGVtHVRySON?=
 =?us-ascii?Q?AVd7WaVzo/Yl0m6wmkJ2YEM6pAu04NbCN60Chsf8RnZkrrIpuQsmU7lZWgwJ?=
 =?us-ascii?Q?2wwBKIN4SSeIwI+U0a9UAJfYxvCIOC1i2HifbDLav22tOQVk+l/An3RxfnTt?=
 =?us-ascii?Q?6UUjIrqKMB9kpD15xYycDnBt7+7oZ6vMNi89QHfR7c4z1Ct/FO7Sc4zxRTEs?=
 =?us-ascii?Q?G/paOIb5a2iRJ76cZEZMgpDvgHBJvSvpb2dybjW4hEEVLWskLGPrVrPEoA42?=
 =?us-ascii?Q?hOtJhn6X+sFyMNEb88SzgUd1kQ6puj0Z7st56ygQWIzJfq1KQqS7DLrjLinN?=
 =?us-ascii?Q?qvLSLjlz2Ot+neDJ4vrSPNIDT8VLSUHLyGFgmsi7e7VAIcNBdUbiR8Vk3qg5?=
 =?us-ascii?Q?ey+jPHf9fR3ZCx2QDxVbONnJkJEO26uXVFT0opEI6VP6UqbVaPkCNjH2w0e5?=
 =?us-ascii?Q?71BTsiFlRt3UvJ8iwcYS3n25EIHGiLMUrMvldeYZ0B7SGMulWR7RnwpGPDqh?=
 =?us-ascii?Q?+AB0inpzgAWlVPyS9RJaa0HbosyyZS4gDv27A2eIc8l/PWfku4GZbTz7Chvy?=
 =?us-ascii?Q?snFwmaPv9SnZ5k61jkuV3X6bo4yT8qLXcQutZTxvDYYL0xg96wNIiiHclgLE?=
 =?us-ascii?Q?4Z+eLYIg7xKE96vQ99skEHy72dsWliMBjtk5o3cqi12xjU4JVBLqMeOR1rHq?=
 =?us-ascii?Q?7TlhqYN6teA6F0zZdVt7HbacbgGXq7+yrYx+xmOWntswyNDvpPHEjsuoXYKY?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a989b726-989b-45e8-a65c-08db0912e83d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:01.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LmR8Ia1ZPhAIFak51hPBAg0vylhiueOCzoCIbdzVw74YEu9RkdE6tFCpTeUehnByB4kjmWjdPgJcKJuGFVeZzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set addresses 2 design limitations in the taprio software scheduler:

1. Software scheduling fundamentally prioritizes traffic incorrectly,
   in a way which was inspired from Intel igb/igc drivers and does not
   follow the inputs user space gives (traffic classes and TC to TXQ
   mapping). Patch 05/15 handles this, 01/15 - 04/15 are preparations
   for this work.

2. Software scheduling assumes that the gate for a traffic class closes
   as soon as the next interval begins. But this isn't true.
   If consecutive schedule entries have that traffic class gate open,
   there is no "gate close" event and taprio should keep dequeuing from
   that TC without interruptions. Patches 06/15 - 15/15 handle this.
   Patch 10/15 is a generic Qdisc change required for this to work.

Future development directions which depend on this patch set are:

- Propagating the automatic queueMaxSDU calculation down to offloading
  device drivers, instead of letting them calculate this, as
  vsc9959_tas_guard_bands_update() does today.

- A software data path for tc-taprio with preemptible traffic and
  Hold/Release events.

v1 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230128010719.2182346-1-vladimir.oltean@nxp.com/

Vladimir Oltean (15):
  net/sched: taprio: delete peek() implementation
  net/sched: taprio: continue with other TXQs if one dequeue() failed
  net/sched: taprio: refactor one skb dequeue from TXQ to separate
    function
  net/sched: taprio: avoid calling child->ops->dequeue(child) twice
  net/sched: taprio: give higher priority to higher TCs in software
    dequeue mode
  net/sched: taprio: calculate tc gate durations
  net/sched: taprio: rename close_time to end_time
  net/sched: taprio: calculate budgets per traffic class
  net/sched: taprio: calculate guard band against actual TC gate close
    time
  net/sched: make stab available before ops->init() call
  net/sched: taprio: warn about missing size table
  net/sched: keep the max_frm_len information inside struct
    sched_gate_list
  net/sched: taprio: automatically calculate queueMaxSDU based on TC
    gate durations
  net/sched: taprio: split segmentation logic from qdisc_enqueue()
  net/sched: taprio: don't segment unnecessarily

 drivers/net/ethernet/intel/igb/igb_main.c |  18 +
 drivers/net/ethernet/intel/igc/igc_main.c |   6 +-
 include/net/pkt_sched.h                   |   5 +
 net/sched/sch_api.c                       |  29 +-
 net/sched/sch_taprio.c                    | 639 ++++++++++++++++------
 5 files changed, 500 insertions(+), 197 deletions(-)

-- 
2.34.1

