Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D323AE322
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFUGbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:31:06 -0400
Received: from mail-db8eur05on2055.outbound.protection.outlook.com ([40.107.20.55]:26465
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229621AbhFUGbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 02:31:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZXdqq++IMakH5xlfKE914gf5Mte1iZDyFbY1LByUZ8MjzB4ddtN8zfReLXzs8u/lNb12St3YFgJ8HU62YimfEaTCP2zUgGLlqIHaB1ihJ1gPJziYhq2AcTuGLonmb/OUJ9bnqfSV6dm13ECE982tBUVFZ6sfGrNSLmeBnQI6z1AM2QpDqDPaDdeDZyQnzXgyvawjqWZq2JekX1pX/J0/MeMHaG9of5wurBTGdzycjYEbLMXhjfpmro6b9Z5vXwzuNa9rf26W3wKOiuq+miopE9Ogrp87vPUcWi6pyd8T238nTCzxoM4lY+nI/YeEmYZ1haC/nVtDyxYQWPEX97+fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=heHK5eDCYSZQf5gn/9ToYgM6hbYR4FLL7IZD6TdQJt0=;
 b=eDxqyhhikypRrF2vqIQMAlvI9ub27sPElyNAJS/uI7VThasWrTbgrLyTPxLazIaOccoQAx1m7nbgAGPlKM4Y07PSgmqy7ajzBbZU9nleXkrv8h5TAh+UVj4uDm5PxvMMc4EkjkINY19V3hIaHHaACaJ9/0dv4pmQS7TETMOcMVFnXnY3Ozgk0TPI8tCObFvxb7hLun2jP1EEOcsxDSaeMjM/FPwsthnUyonYlRYIIpi7zSaBbA8SKRsuVW6ChqPGPrWck2EfpjIMgs5HMMlai7VCcZxkxX8lshAbP/o3CVHKh6PnrMgf4wz7IvzLMYhAgDpLbEmFoOMrsNArDR6xxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=heHK5eDCYSZQf5gn/9ToYgM6hbYR4FLL7IZD6TdQJt0=;
 b=Kq+iDo39Ldw4wp774dRakMjIBIUJDJGVvmEvfmI8DnNfJTB6UNEHiWZhsITyi+5jCSBQa7IQziQlqDQ2MghzcdYQV18eCPDtR6VHPjePuXmGLKRHjZgkIARl//l62wmi4DlMVDWgAXkboBiRdIQIgLxc7Ly+8CgGxPlJQ1eLn6k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3707.eurprd04.prod.outlook.com (2603:10a6:8:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Mon, 21 Jun
 2021 06:28:50 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 06:28:50 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V3 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Date:   Mon, 21 Jun 2021 14:27:35 +0800
Message-Id: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::14)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Mon, 21 Jun 2021 06:28:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b83bbe3-c02b-4b59-af5c-08d9347dd500
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3707EED9DA875ADEEB63A176E60A9@DB3PR0402MB3707.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xzpINot5ZPYXbW/+i58XLZa/G6VbPTC1TN3IEXUSutZyNjinq4VdW7TeEOp3f/4cV7YvEx1/yb01q0lsB93LPC0t8s4dgtsxtf8MKA7Um/WZdJRfgGytaCrD6+qaYPyEPqJ89X8Mk5a52paH23H5+ODwifHWU73ftIbyA2uqxIAHoKrGDdKOMQt0iLPvtkDXPWRB9U9JPt4jwHXWG5xJM5fPRIJu8zAVHiPJH98vY+QhIP0u0Clh9jVsJYA0E3E67L6UPU1C13Am550sv4Nlucn9w5VijVslYilK+WZaKEuaxbKIL78T+rZ6rDAXeN5Zg8NuplZYbQzixhDEqc3wxMXTja4pCJ4y5WCO0F5kcWUs2m0rz5t0Fef18RpfU1y8fHhszJ8Miclu3kWyc+lNdToIZGigCc7Hvj0oJYWOyrc4ABd0/sL/4bxie+ji0LdUBnfRfZtBEW1yqh0PFATR976uPNNfRvelo+F8qbSFoAF6R4ZhPHa36TWknBLR9a3Duv2rUC8Fp0fSsPpAq3MUGe0+FG0FW2VmnkTaWfhOOmhmHTkin4t2LwYAadhDS4RrSPy1Im7loXQBH0jDC3bciQ76odupc70M6sFZyo+3UN5bZVTMcTQ2iUx+N/D2q5mm8maw4/+DXF6ydzWGrDaZG1E/XKoJBoOdK6xe6CRTvLHV0CP3fGfCCFDvSaVMnmPZNTynG/ASDG8p6P4eoW7dLX4tZRtkXS740ArNMn/ukleMzyyY9iLLhtqhETDA4SNM+iSV0jETLw/HSGLbHP3a0RhCYQ2RoMlmUNAxgWcZP1QgVDv5DmPe2VDGRrqKQfMM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(8676002)(8936002)(966005)(956004)(4326008)(36756003)(186003)(6506007)(478600001)(83380400001)(26005)(16526019)(6512007)(66556008)(66946007)(6666004)(5660300002)(316002)(86362001)(38100700002)(52116002)(6486002)(66476007)(2906002)(38350700002)(1076003)(4744005)(2616005)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PA+YpYJo89iXCnSCMPESdzWx8Gp3vjp5f/hO+ZfxMDG1sR0QxFBZndahNLH5?=
 =?us-ascii?Q?9fXN7HQ/FC41JPQ/IlrX8+EdnwRalRH7/WD0f0fMeTJNDuXwXTC/k7NPCDBT?=
 =?us-ascii?Q?qPAtO+dp3vBLE0GGusEQSUQEvB1+zLRdkd1O1P+harx2CvOvrA99vwb6YLiK?=
 =?us-ascii?Q?JKeN1Bi9nXU/j3PraZZDvNiZ9h4a2GkGMxUeFLU8eBo8sT41bG0iZsaOdzPM?=
 =?us-ascii?Q?CZV68s741IbrfFXmJ5BVRQv8CsLKbSIgI9HfMG5tH0T+xc8b+HXq4bVR48Kl?=
 =?us-ascii?Q?y6GbxZKOtVhTtTknK0/wPw70sbrSYKb9rNAgumkY6y21A74h9KjEnHl7wFQM?=
 =?us-ascii?Q?PqhTGVHg6KjvPUaSqtB+SqhLYirV9xoIrr3uAflcZm7s5hI+DLp5N8RD57k9?=
 =?us-ascii?Q?erDKH6DTmLMvFrI5b4PSFjhe0irLn2UWjp4/OT/dKS7Z6MekyzMmbhFLMtNC?=
 =?us-ascii?Q?9StfqYV2ObtMZYRVOdoow9dCEPW0llZuI+24SA3m/WG+cBm+YlfCj3jNflyr?=
 =?us-ascii?Q?7O8/pfQ8YnnRhnZn0qnUKKci/ug9Siq1HkKE0qdS01HNbKSBSJhv7VYZBijl?=
 =?us-ascii?Q?tB3c2DRbOHkwrLQlyVDqdecn8nj8SD5oglA+NepheQd6Cf8MZcdc71wsYEZA?=
 =?us-ascii?Q?8bF+hEYdPUBPCcNt96lOQ3sTUb5FrhNLVEfrN/mjoQoLTt9osod7nLkC+Dc+?=
 =?us-ascii?Q?zkFsF3omxc1nabIhqXywibDQNTX2JMmiNe3Sbm3Rg4+c17PnhKNt8Rw1nXgl?=
 =?us-ascii?Q?5kyT7jIm8FpCK81P395FHrKhVUmz0Cvbx2O2zR5NOzOaLrYBXg83BrRra54G?=
 =?us-ascii?Q?zyKTw6ACfjpfLk2qui0XN25xhhUTrc/6qJsEhM0LT6xKOUkNr8MuAiJq6ZXy?=
 =?us-ascii?Q?xOOITaZ+1jl7RjHqXanBZObDYY82wFIQtRSL2vxVTKrXo1bqRd/TUjFa5U6a?=
 =?us-ascii?Q?8gg0MpMIU8UxTn+HwyP84w9yG/QGvyNzilbXXJMrkDZ2dyHz2zfbxjpJIV3O?=
 =?us-ascii?Q?Y5YEOugyOle0oVSWn/SVL0Uu0PabsL3wJrzFir0P17F3dBBrZEJvzHcabCI3?=
 =?us-ascii?Q?rwk4uQWEXDiiEyNpTaKQBPGdxOyqtOfEoA4xIv6E7ATSpsIdCruJ/utsYu4S?=
 =?us-ascii?Q?2WiNAgtX23rvotAJ0fIcNdybVootoZkhwF4mLZqROUIGGm6bqivfvckovQW/?=
 =?us-ascii?Q?2rQjcThpqZKXt4/ms0kTno2pmdSETSzjm6CuVfffl5oVv4PziM/ymNTnQLdy?=
 =?us-ascii?Q?Np9hBvXA0Ajo+OXNERDxFZGupuDT5+vZ//iuq4gb7uHl5SM6IfvLO9VoPV36?=
 =?us-ascii?Q?Dn9ZUNkZn1x6hoPC0Aitcj12?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b83bbe3-c02b-4b59-af5c-08d9347dd500
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 06:28:50.2676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiqOD+dWLxfX17+CY5hy5huBMJ7v72zpllKVOHl5iepwu7cY75JKHO4Ob2bJp4oyQXGfgfxUDZZGa34z7OvhaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set intends to fix TX bandwidth fluctuations, any feedback would be appreciated.

---
ChangeLogs:
	V1: remove RFC tag, RFC discussions please turn to below:
	    https://lore.kernel.org/lkml/YK0Ce5YxR2WYbrAo@lunn.ch/T/
	V2: change functions to be static in this patch set. And add the
	t-b tag.
	V3: fix sparse warining: ntohs()->htons()

Fugang Duan (1):
  net: fec: add ndo_select_queue to fix TX bandwidth fluctuations

Joakim Zhang (1):
  net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP

 drivers/net/ethernet/freescale/fec.h      |  5 +++
 drivers/net/ethernet/freescale/fec_main.c | 43 ++++++++++++++++++++---
 2 files changed, 43 insertions(+), 5 deletions(-)

-- 
2.17.1

