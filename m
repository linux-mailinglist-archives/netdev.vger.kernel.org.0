Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24E7679B9D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbjAXOVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbjAXOV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:21:26 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5246E1703
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fH7A4v2fJnzI67leSqX86sVWE3K5bgWfJKAY1EYS66V4OqHhv1uduLCf1g5j4zXpX6g5m7+8lnq0pincZZ15RFQ5qRqltUTa7yjYZEQDKtC2exP3HmzjTm4I09UNu6qB6sANllZ5eOMz2lfYP4z3SI0sVKJyytjt1TlYmnNthiA0Jy+BSYBpRvN//9OMRMAhv7+S66Z5llf5UKX2eTecVESkAphdFHh49dEphE8DXG6QtCo00SA0wVWDHDgOu46y2VouoHjG42+i+yDMbPadxVN3+3xU8igBp3wdyIhVDr6DR0ts3QpLqBzDXX4uNpEsymiK2HFy5EwmSU+6LYv/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekSrJYQqRQrL1DEb9S941q+bQ8XytdvXQFnuz2l4umk=;
 b=dAloRmvrIKrS77wT5TgHgyEOSUndlZIm8WWA38aLWfktgxJbogClsZuc6Z3adlhk0OE8S7BoUMl4coRpreRL8rx9K8IO56/Mswq6orDc1UcuoB/dGYqtp8Q8jhQu9tZ11fVbdExLNCmd858m0EcotEuP9YYjmvV3Uruoj2W4tgvbfE+Akjy6F74gH7o30inFHyDN6OwlO0RlGm6L/gbsHxdD1NDde70FHY4KRPyDDoQ8y3PKIkvuogVmguW8uwgs53nPRNOjlysFbmBp2zX1n2+pOotqH7ved9Nff9t2ZRr/xxLQwtU6IkqqGs6HsM+mLBs7mfX873RnMDThUcRsHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekSrJYQqRQrL1DEb9S941q+bQ8XytdvXQFnuz2l4umk=;
 b=cx0CtNprqpA0Hq/j/hTQHeKXSgDvgR05dtT5RdB+M3fLi5uahzVMy4wPgI5AJqvcYQT641USkYv8kMvSspZPQYu9ZdtmHS+KgG9vQdr3ocaCCfCJMOiOVi3wl1AoYnxjEPGBWsKrVcnyoP6UFTH2Qqcx0p8eOWhw65M+nrc1C4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7024.eurprd04.prod.outlook.com (2603:10a6:800:124::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:21:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:21:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH v2 ethtool 0/5] MAC Merge layer support
Date:   Tue, 24 Jan 2023 16:20:51 +0200
Message-Id: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7024:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c961df1-7317-4af0-9273-08dafe163c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFh41MLJC63bFNlrtWhrEFV/Cjxj3ShozRHFh/c/j3OpsKvY9rKY00/Kb2U2xiOWg4y5ClY8i0Z16nZUXlNhhF6rgndadrLCfp0QZ+ylJA5LpxdPsS4xms6mpQio7uwC+JYpJLDRsaQSdKoMEpbRryHv26mVTll+wHvOgHSR5Gk+pbvSxknG6b323PkzGKHkkSl4iei1mOQWJTNMJWHuKCgXPR+kiyngJKQqFkTIUD++9QvI/Iq1gX7P3mzxUX6FFhI4tsh96bfcxmrbYflruUIGyhgsG3ESlAkwgXvJPR499n0pgJV56e/iQ6UIoM0zN+vWeyM5p/l25Op8wxQ8ZSrRnzFLvVJrsfFVoStxc9mVUOpKIya8rMM38whIAZ1BzVPpu+EqgL1tvgkLamUuNYotPy1K3jY8i0geOaA+0dy4owoFQcsM07chz0U+tW9UgSDllPm6VssoTQlS+sGyGUtXcemyXWbPsYQSca4WIHqMMbwiiqve+IGUTgaDkvKFaweKtvOMmBiMrnig9Horm/EQOADFce4dSLQJrtaysxqb9SFYTeMRTkCIl1OvXpYP//27+JE0FOk1yS+/YcqvqfwdYz4mhLq79PnwsQcIQSZT20fdlDMQo4+chh+sWRtby2xq8fBfGWbgc3V07K1F8DscJqL6N4VtD2JTBSAsjRM7QaoomjlZQIT6mjIssJ2nIMDTYNZoN87ELUH6GMbzIoZhLHLQkEa20grLn2lRi9k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(83380400001)(38100700002)(38350700002)(2906002)(86362001)(44832011)(8936002)(5660300002)(41300700001)(4326008)(186003)(6916009)(8676002)(6512007)(26005)(6506007)(316002)(6666004)(66556008)(2616005)(66476007)(54906003)(1076003)(66946007)(478600001)(6486002)(52116002)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J6LQY+zkLH06A/zBb7rMFf8La6Yc5v1iXpJLV4R/0G0dSAhc/Pa6SUIehKTz?=
 =?us-ascii?Q?jiDuIsWvvdyXiaY5IBh9vcKMMQCXtI1HT42KCT8klxZXyrhjOjcIjYN7WZTo?=
 =?us-ascii?Q?B+oWYmUiyz5wSh8eCVCE7TwUjKhYVP5KtYs3sWeY1Rxi3a9kGQduG1VaRQFq?=
 =?us-ascii?Q?5w4l8KMB8CplAYU0PfRqjJPyTR3oMh7ys9c7H9qTd3OBB28fqanjH68emVRz?=
 =?us-ascii?Q?1eJn9lIE1vbB6bz5m48VLvS85afsHUR2eQR9itP8qmPTVWhH3E9QORoG/H4L?=
 =?us-ascii?Q?Y09iO8IKuCpQK0UzQvOLZOmicY82uqrQx50GfOBx2iEyfInsZMjzuWmqv6BJ?=
 =?us-ascii?Q?g6i+Bp64Hp0/TOVlqiiH2dDjksbvF2LOfHu7inVAsCA+I9TzVbUYX4A5BEFR?=
 =?us-ascii?Q?VmaBfIzXW/0BMbOjXeOzCBO52HbhvwIV2E80sKsijqvhMvJnD29jligIChnQ?=
 =?us-ascii?Q?wioW0BctambgkyZk3woveKMc7ky8ntxmIIFd/WZ1EzP9lAclj7JbxJPuHn0N?=
 =?us-ascii?Q?lxICB8JO6qimEiGujiWCK6Er9GwhcLOTZswRHcUNTGM4AiIm/97wOtJ2Z6RP?=
 =?us-ascii?Q?H4/irA0afOpEpfkSQhGinSD+ffJQ/PNXqi/VwV0zQ9CMeqKbvcFbesAUwueX?=
 =?us-ascii?Q?0daOWu8mgTErrJg/idlQVZXT9EgWDpJjLOfnQqjG50dM2qjQY6hLqp3WfSpo?=
 =?us-ascii?Q?fHQooxqoIDZD9OrOh/DVBBdxWF4YT0WxK4zM7PSmoCXbItJwwXRd5FJ/h1TX?=
 =?us-ascii?Q?aB+pCH8aVAqMez4F7W38Mps4GlLokH+dUuxXyl0x5/FlO0JLavAFH8ZnpIKJ?=
 =?us-ascii?Q?G8O9Lfv6QmywIg7JgJD61N2UOXykPljICi2F5RcIZoxKDCQcGsCtkABRPgUF?=
 =?us-ascii?Q?MFCnQf/OB0OVzLGkA6p1c8JOJgHtExDWNwDWnUz1vKpirfrCEl7wT0PAnpGa?=
 =?us-ascii?Q?bLi96asGsfly3DH6OOxDCW1w6Z6FBdgpxbFxU0w9hbD1geQwRIhCMPR8wZEy?=
 =?us-ascii?Q?2q90a93YpzFEad4h7eTGPwp2/K8BB+VZybIr8wJtDSTW8dRylS2sEf31xqyk?=
 =?us-ascii?Q?x77Bv+r/Bc/8mRtDQxqlZZUyE3KjL5fhgghfCmCZmlqH4knq7cwLyNU9jEeu?=
 =?us-ascii?Q?2ib/DylA07eBj0cXVAxbkKsk4Dy7kr4faS/6e0fHsmfDiwulYI7Xjv6oO2xh?=
 =?us-ascii?Q?bUIc23Qaff3TbVBBhaSU1OCgRpIWAhpmfL8KWV2kH0HIOknIdPIVNi+Q6nBa?=
 =?us-ascii?Q?9NDi3FWGJA+XIvdFN4nFrCTFh6g+ZHCRH5zNUNMTyyIMNt/s+jyWUKLa91Nq?=
 =?us-ascii?Q?puCvmsOPU2tspKxkzq+d9cZwHm8FjOA28KlOcNApdwKBxoihlLB+JLTb88Dd?=
 =?us-ascii?Q?HdjtVgO4RUqkI3cxmp3JcijNJDfYne5m08n73l6q2mKxqsyiOZIel7n7EpBs?=
 =?us-ascii?Q?Br1l0NOrCreUYFRD744m8EX7M9/R/BgsukqxWSP+7afIK0LETIetPIWnRcd5?=
 =?us-ascii?Q?jPqAT/gE44JryBZ8xXw6NZazxE8SF3CWFfWXeU8khbNtb4X/zaM8FAzN+tKg?=
 =?us-ascii?Q?OA3a2JFXxHpIrno+bDt8+J9rTgZC8hAky9Y37z40SfH4S7H4jD8clUr10ZLh?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c961df1-7317-4af0-9273-08dafe163c2a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:21:08.2567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myuDJ+LnMa1YVxuftajBm4h+X0yR0YlDQex25kcjTmOfTj1X4pqtwOSeyEKC8RdtVrPQFBRhEPrrZibbu3zt6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7024
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the following 2 new commands:

$ ethtool [ --include-statistics ] --show-mm <eth>
$ ethtool --set-mm <eth> [ ... ]

as well as for:

$ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggregate
$ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggregate
$ ethtool -S <eth> --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac

and some modest amount of documentation (the bulk of it is already
distributed with the kernel's ethtool netlink rst).

This patch set applies on top of the PLCA UAPI update:
https://patchwork.kernel.org/project/netdevbpf/cover/cover.1673458497.git.piergiorgio.beruto@gmail.com/

Vladimir Oltean (5):
  uapi: add kernel headers for MAC merge layer
  netlink: add support for MAC Merge layer
  netlink: pass the source of statistics for pause stats
  netlink: pass the source of statistics for port stats
  ethtool.8: update documentation with MAC Merge related bits

 Makefile.am                  |   2 +-
 ethtool.8.in                 |  99 +++++++++++++
 ethtool.c                    |  16 +++
 netlink/desc-ethtool.c       |  29 ++++
 netlink/extapi.h             |   4 +
 netlink/mm.c                 | 270 +++++++++++++++++++++++++++++++++++
 netlink/parser.c             |   6 +-
 netlink/parser.h             |   4 +
 netlink/pause.c              |  33 ++++-
 netlink/stats.c              |  14 ++
 uapi/linux/ethtool.h         |  43 ++++++
 uapi/linux/ethtool_netlink.h |  50 +++++++
 12 files changed, 561 insertions(+), 9 deletions(-)
 create mode 100644 netlink/mm.c

-- 
2.34.1

