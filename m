Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA73C5B987F
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiIOKIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIOKIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:08:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CDE6745D;
        Thu, 15 Sep 2022 03:08:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2oD8DBr+q4S+vK7xO3xeHm9RMIFrZ6B3B+j9zDQO6cnnf5PqtEY3Uf/+ppnd0uaYMG6OsS5/8LFvkIThv/EKLkINxSfAqTuZxkZ/plA4/LiO7/B188CNFORtSe5G8LFFiXaev7aEzSvD9iLQQhxTP6SNSbGmJERJcNDrB8d5yZJzd0BFJ5qWwz0eK0LMaaLEIkGZyiyv6FUYw29tP9wIAOkim1dYncz1xRElv61ucdpA9mvt6UJ0MVQgdhQ1VHkQHrm2ki57/z8G76HSrP1FbxMiGpOACxN6uJeaE5g1cIiQfvQiWPGkj24wwl2CxEzyaq8LKQvvXn0JEiBRdCVEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8wfL9rr+kOYEkSVuJqBrvHLZduIIkYIWhji4WvymuU=;
 b=BgNcm2Qr8AzIv5tbv1KKLdat89gs6829Ywi9JDL65F9LX5PEEcvHlOGhW4APdx1lw0ycV1clb8l0Wjs8y89265sybw2ly78ptQ1R5Z+tbtD9O8eQPmvOMtN88XuB6ZFgU/U8e2WostEB+W+ZAPqDt6iMMxrpjOklN6XP8y+uJkxbRZ8fosnU3V8E8yR2B7a+3BoAeBX4fYbGRqbYaPLM6gWRipkw6buism9PbsGQkWMUuR1f4K6tcUD2091iVm+fQgiBdjxYl54xvtCsePtarL3xn/QL0BiPdiB7LivpeZX5bD29zXisNT6xrEp4GiplY9Whs/CQ+xvIq5hAJ9c7sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8wfL9rr+kOYEkSVuJqBrvHLZduIIkYIWhji4WvymuU=;
 b=Hf853VxkSHOgev+Jph3ltA5k2msexJprcgJQSdEAgFicSLMBCufHgMDVy1fe1JxROmesihjn1TkhhqmFC0JhfO5479LWPjxlnr1SGh5ufolPsgYrSGsZ6Bfkyc6p96JVvEGVJmgsO9aphNA4zXRDvdluws37bs2X6qSndYyZ4u8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8457.eurprd04.prod.outlook.com (2603:10a6:102:1d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Thu, 15 Sep
 2022 10:08:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:08:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 0/2] Fixes for tc-taprio software mode
Date:   Thu, 15 Sep 2022 13:08:00 +0300
Message-Id: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0044.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8457:EE_
X-MS-Office365-Filtering-Correlation-Id: db6acefb-396c-43e3-917c-08da97023329
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iai5srX9rTEJMVrrM49iOGhESEaGshVov/7bwM8qAgQvVkB9ASVfgaaVPrhekMMjPI+WmtEth746x+xvXrqA0ublrzg3FDklYN2p3U0XLaJl3af2eyiQV5y8H0XED/Ep3VrJM834ETdpY9jw94MwVZi+eyIsy3kutw1gN4o3O2u4gaNKc9QaPlxf3kux2h1E0kz5Y5j//A/4seL9/gCs1pLtoZFv+xwD7sTOO3vqi4fZa5ecFv2b3JsOCFNj2LlKM73lGOW6oFgP4XLG1fpDiMSlnoWWXiV1mZhq/5Hpc7oIQu94CyAIxHnMzChBmB2Nm2P58WV22efCV+kfC+jtMfyabgp6h7Ufsf9nZfaF4XbiVmL1ClTweCigppI4jAGGl6mWTBCljI74+gH7GhmOhC+RJAt1mklGdS/gZbc82i51bA1KMHQkqtMRb0BUq3wew0gHjyf7TXY5+A6nCWBaIa0LwhhSD4uAju/HLs1eqeCa6neG8mVHGy6u/XFMe5r/Xe5BbqcbD+IrBGZezWaXScVvtPdCsdnm8F1u+aMsbnSlEgCfP8ok29PlIzasA+3xvQvpBlnpv4DW/v2jP+qb+gdUiwRwzPv8O6f2yVpj9BN6yzVhKkMinuZsSIweO1zwvdWKNa/Gr0tS4Hz2OvuO/SRfGwJtmtX+jDmEkAUNGAH8/uBrS9o0K8GtQiGbEMTydm6RSx6wdWqk3nwkokEXNYnfYPr+RiEXQH0u/lb8XnRKYH/Pkd98PTtG4LxtiZAyzyEIlvRMS3doiTwqgSP/kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(6486002)(2906002)(478600001)(41300700001)(6666004)(8936002)(54906003)(38350700002)(6916009)(52116002)(66946007)(316002)(4326008)(66476007)(66556008)(8676002)(36756003)(38100700002)(7416002)(86362001)(5660300002)(1076003)(186003)(2616005)(83380400001)(26005)(4744005)(6512007)(44832011)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DBJyRHzG+aayAUaHOSmDXIvw/eHS7QysaG3MjWDqF641hagg5U7scQsp06DL?=
 =?us-ascii?Q?npUaZ7DbsjMjvQcYTisOrPbAO+BfJYiCb6vzxmaKqN+AJOhH/iLMJKXp7p8g?=
 =?us-ascii?Q?6AZB6OmTFoQDPyp42r5g889iVlZaiPx+Casdzh4gvP7kjG9BHSHmA9txKW9c?=
 =?us-ascii?Q?Osd3JfaIUyuyseyfMjTurffe59/9IMdt0VhsKuhfta/D/ieV06IMkdu6rT43?=
 =?us-ascii?Q?+EydhBADs1U+T+CbRSdUuy/5xzZi1QIGxIq8DVxVURo4FQuew4MVyKNT9pvo?=
 =?us-ascii?Q?hLCe+4toSnMCBrP+Hzx8+Gr6j1NmAziKHcuae5md5CflDDB8vCv2lfCknOX0?=
 =?us-ascii?Q?oT6FMZrc9wQqvJRlxCzl0TTUwW7aeOivmOMl8/OGlwoSmf1SFsbgZDo95RlM?=
 =?us-ascii?Q?kHB6m1ThQ9e5RZs8lV+bmJY3OqRRn3kDqnYglI9FlWjQ23XvmEd5w3mzYRC7?=
 =?us-ascii?Q?EcvkGXiohNxVdrrm0JmQbuIs3F+uWeJDIziR9XfaW8E+4FnO5NrPeoWcdSjz?=
 =?us-ascii?Q?0UGy+EAtGWIzV/ERmjIz7PWxGDzeliTUCRVC8njJYYCag/om8DmoBo6BOjva?=
 =?us-ascii?Q?yEnAEQGLHrYdRp9odzeOXguQP0PpLgoYSNOcEbPyDPJxXbKrYJg7ZDzOKeFt?=
 =?us-ascii?Q?d3sAaeiNTxW/X0flYDFiKPaGuH0L7jTpKcOERvn8fnQkacl+knq9F5IvYYZK?=
 =?us-ascii?Q?m6e4ipoyM+qBNnIcANLWXENcwCprrQBlIUMemgOxdC90Nc30hmHAcOX8TsMJ?=
 =?us-ascii?Q?HB06unpC4ZnBMClwHkoxnjTxxYNGmAJg3eMpplHw5UtTP2Oo1uHjsmQWi7Cm?=
 =?us-ascii?Q?f4DYPVSzGQgDefpEYcY6oHOKVnwV61f5Ez82zDSmPja+HP6Z36CCwIUOylp7?=
 =?us-ascii?Q?Vte92ySd2OXuGFdCKiQta2eVy2lUUIvHNv+5k71g+Idl3DxNi8Fk2mX20lYu?=
 =?us-ascii?Q?qmnAEJNbAsCYAF7I53CwXxCFLEIqFyE42TgflfC0/7C1yP0YbpilQnXOed4p?=
 =?us-ascii?Q?qlMaglsXA/HpoC72ZdcQtqrdGQQjqZkGigPxq3VgM9aEqgnjedqZH63trS3p?=
 =?us-ascii?Q?nv5mTsGp/MEVgEH5QnXPzZNILofmi5JjFrScPXS6Xh4Ezmg5bG2pW1sZZkXZ?=
 =?us-ascii?Q?+Wf94bfoFJKV8oDXB1cSYNRm0uX3x1dWHQS1Q36tqASeGAcBRvwzJX3dx8Aq?=
 =?us-ascii?Q?/6LOpQDTUl1TUKwYLtwUzPUji2T2Y6/cnLNulxzlztdmYSgjA5rD1xSDegMh?=
 =?us-ascii?Q?Jxtrk+e6cw2iZ5SnkOPdIBRRUbpuDbCUqrV6H4AWoulauRtBdyH4Ru5swvh2?=
 =?us-ascii?Q?y1+0/C/lqBBefW0jpckI/a6E6qlXSqUZXqt/a1Ii15BpVeyKjoL5I69vfSl4?=
 =?us-ascii?Q?Y4vaSQgsyqw1nivzVtmYBiGXUZ3iEB+VplPk0D+wvICy66O+z/e2gVWB1e1m?=
 =?us-ascii?Q?cLUB7t8LSAzNIpgBXODDtRipX9D2Ep4lnAoq58lMp4RFRmJnTgxnWSOPyR6p?=
 =?us-ascii?Q?6vny0DlvTBdWQbSzqSn8IJyvJcLHy4ijJ3oCMel75u53HAwbyGsVrAyFBPvS?=
 =?us-ascii?Q?YzIh3kEhhyBxap5Ri0t6fDyeVUJXo4ZRuMpf53kcZeQ4btKcUIMznUFBptBB?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db6acefb-396c-43e3-917c-08da97023329
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:08:13.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WkXESuLghoV04FNrNUPJ513urVmQxHMFd6A1kUEveEGqxOCEyW8pOlqgDvjD3FatapO+ES6AvCuA75HEfW0YEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8457
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on some new features for tc-taprio, I found some strange
behavior which looked like bugs. I was able to eventually trigger a NULL
pointer dereference. This patch set fixes 2 issues I saw. Detailed
explanation in patches.

Changes in v2: dropped patch 3/3 (will resend to net-next).

Vladimir Oltean (2):
  net/sched: taprio: avoid disabling offload when it was never enabled
  net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo
    child qdiscs

 net/sched/sch_taprio.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

-- 
2.34.1

