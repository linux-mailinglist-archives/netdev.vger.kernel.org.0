Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60525770E8
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiGPSyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiGPSyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:05 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB831C935
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFnk5qPyk/vV/rhwMjkP1j95Ua3gPRLbOk2C323tfi7Rm2OiSmSl+IIqm+tpKWXn8oScqOgjp4KPZ1kIbjlaDGNLPiD6PzFHcom0+lhvdzauDyeWAX5fqfKbDEvtRlreXZhWTOBtQX0CQ+FqblNmAceYAQzqoj29BvY+w0GGmgFjssn7YSiqhYG7hOy3D8/Nv1+AoXCkgM4cAeMH6XvaTmwcZ7DaFY5F+I/uVflA8nDvO4RMuQqPGN3y+172ns3D2SiXMM19hZB3O4mluWOUtgQS7IvRulQmWjjQFIJ1zrD2TegVcvivueRe59R9yWUHjq2ktZXBfzX+c5c3/31pfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOzP3V5IU4VN75pSWEVTaQiNPaxkYK0JJTSo42iSAnM=;
 b=hBbcYyfqYPRipEgKqpDqLzwmUsng/gDoDSlX941LdDwu7psicaVCNdbiAvckgUKs54ZNu0wuyQrFvXHlCgIEdIKm0xqU+YhCOIdWj17aEJ/jqkOXb2AxVrTbBMv3S2xgy07cADifQk0YHhs66KSBdd8/w3N1CdnrFPcUMF5HyL7bvwEhpnjNmWlJ0WTPY0rtZ+pHA5hcwj4deGUuzIMcrblkJXmCDG3QUy9Gur4wjKebOmm3RZ1nEsnhTbtHuIqVv1aZvvsLZwS6qWR818vjiZCdaUY5WsPP0CQi6trU8ZgO2Bg5r+qN2eMJ5JZ9SBqyQH1sHCmVZFiD8cACpXGKAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOzP3V5IU4VN75pSWEVTaQiNPaxkYK0JJTSo42iSAnM=;
 b=ZVxWjagBh8+h1gpwhUzZYv4P/Nr1aGIADd0MbSHKBz2XKfnv/ExQPCu4ISuTen2nqjNtegrGmc7xWyIHIk4ZnseHE3Sga2Y/3RoVuREoOpNMRMVTynQPAaUjhNLDGIe8v8DwZoVf7OqMoGdpFWLdWd0Y3h+xYGUY4mJEcU6W0FM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5261.eurprd04.prod.outlook.com (2603:10a6:803:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:53:59 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:53:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 02/15] docs: net: dsa: document the shutdown behavior
Date:   Sat, 16 Jul 2022 21:53:31 +0300
Message-Id: <20220716185344.1212091-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ad76bfd-062e-4f20-f04f-08da675c8a21
X-MS-TrafficTypeDiagnostic: VI1PR04MB5261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8pjsQjapaxTYiCQR4FixO1JSmBEJgE4M0LfLvufaeNDI40z4+1BYaGeHIesr4z3YerKHN0Us7jiKWo1BzrNBpneY5ExIEXsEZR2DH934a8i5b56ZkXYOLeNrW7YRJJWceD1/nfMHsJyPjEyf11oF6BvjfmB9f8cmS74ShoGNEEkdsY+95SCZTDN0cUvAAjsQQTb01N6/xit+M5jqJU5v1eOPum+BHNZqjb+nwvvA5igb3lp9XMGLGtrSUIMu52UwejRsIa8rdU8zUSznHJyhybbLklU1ZZQhXbuXdB+2tAGfH/1QWzjfrxadl2DshUF2jrhQM2eBx1Q4Vm2oWZBZhniPNVYu2Lo9h/43YMWlKQROKC6t2AmF/doaY693BsZ8O6dpeAG2sYFgyeOxzOKap4d6RncGq6fykm5EJ2r56dUviAXZP0AD6v1yT9isUGTyNCxyd5LePexjIPFCgpFNiT5xQjsXuua+xIy7vosetNFKhScb1zFX1E9KTN2hW8BIhuFBbhjQepJC14SxZmYeVMYKRLNR6jTSLZBRB6VmDLlSvTQ9Uv3Ths0yZa4CU4gTZdj/6wh8WTWJst0tox6riFix++1u11uDhPlJwIrBR8JGFkobI71j4TT5wipuX0rrZg+I9mlpqqjEv+ghWeOlIrZoojPHPgGkR/S7na080pLWMC8MtscFTQ8QY1cUZZe4WqL8h8X4J4IsDONXu4HFho6xm1bmVfgkH1jeTbIabSrMAyVYKl+6srozIC2X9zPHA16ajtppHbiEdS8BGBZVKiCd2bgKsQHM0jmjnBafh2Nrz9aokbq7czere297gAcW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(83380400001)(2616005)(6506007)(52116002)(6512007)(26005)(86362001)(1076003)(38350700002)(38100700002)(186003)(44832011)(2906002)(8936002)(36756003)(5660300002)(6666004)(6916009)(54906003)(4326008)(8676002)(41300700001)(6486002)(478600001)(66476007)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sqFlUGooHmREmtSce0p+UYwoeXUU5GMUIkxDdKcB9sz+fwarmeRJA4NvEQS8?=
 =?us-ascii?Q?48Wq3Zygr6twJNXemH0K66fi6m22zsKfxLKw/DQ9sLssda8ZI4aEwUSSFcBE?=
 =?us-ascii?Q?udLBr+o2/IwolMchnQq5VGTI23Q4ovCsJM1y5FUspMfWL8WAbV+toE4k6sEx?=
 =?us-ascii?Q?hMqZZraZlCMUxJOvfwIrSeRhSV7IeyMavZH3ltzFGKHgbtTF6ZlconVXU4iV?=
 =?us-ascii?Q?daN5jEqpSznT5HJ7X+9BfVVSlayJWtgcb5mX1bAhRtK/hQR7t85Rycdk8M0v?=
 =?us-ascii?Q?f0+fZPG7mByHxmq5S1USCDCHfCRSb68g0oHiep6X3Aeo93nqi8sxWdFgWeRg?=
 =?us-ascii?Q?jilbWSMzpff+/kyxFnmY5xjUk478defn5DGeWkPkE0YCNbgW7iblIiekVktQ?=
 =?us-ascii?Q?9KVyUezolEXMmd5lNQ7ifKj+U19iKuYrMf/1gNpwxNxV/HEb3JTTxBNR108m?=
 =?us-ascii?Q?Wav0VGE9Ik7rERu9dJ/ndEEuhTdz4plJUTKfG+JG0C3WhQ37WpKrlvU+u2fR?=
 =?us-ascii?Q?3Zb+GrNYQV1gmwmSCk6f50rYz+cmnF/mcG9EPoYdVvFjGniBfWbl6FMf3ynW?=
 =?us-ascii?Q?2ohKBcZ//cJxnjP4KIQZixideT8xKATOQstelhtWd1//7lrpVejkU4L6Dwjm?=
 =?us-ascii?Q?Wau8VS/XwUXG833ybzS13tDIPKBsEnD2gHN9RruxPRbZAoC3Eqwu+aTam5mr?=
 =?us-ascii?Q?afWN4j+P1QbfmaUZtuPCU8a958aYfe/YU1efG22Yc1fXis6xpuzTkIxc9KN7?=
 =?us-ascii?Q?jrS1QbbnxQeE62P9SOYTpKGEygzK/y7LFDmeUrW3lOb2EQ9Td3ckt90DHfBL?=
 =?us-ascii?Q?s+auOrWF6+dykcOrewsIdXkSAcq5OsnxHdh5/93MlVAXdeVhLV8XJV7pOpOf?=
 =?us-ascii?Q?G3uC+2J6/GoVIOXRFVJL2YAAvohLANQ2GG4aTjFzWDgvBbOin+bGuZcOmO0I?=
 =?us-ascii?Q?fTVkrkeFhqEVO2JjVMIXbMAwGC4oKy46Q1HYK6tUavkZVHsFz69tMFwXruOQ?=
 =?us-ascii?Q?yw9bhu96oF71u0a5Vm9vflnwSEniZqcXRE3dGifWziGwhdyrRQUmgeleOAlH?=
 =?us-ascii?Q?/ojeT3RoEcyWUnrHFOp95AHegPCh/tF+BmbMpdfPZmUNYX9arIKou8OuWNUG?=
 =?us-ascii?Q?A8jkyzKGWo7Mmx9SgUJL4A9GU2/uwGpI8ZEqfzKfzREzqXMwk761issjAUQi?=
 =?us-ascii?Q?y8wLOFLZTwgc0RNasL1nOENCp/V3g8JvMQiATUPo0H0NQ4uUHy938ZE/+lKp?=
 =?us-ascii?Q?R75ehe5pHYvzyqTOly/ilkYVUi9kFq/EoHqFxC/ZisVoukcRigwYssScMPwb?=
 =?us-ascii?Q?j/WckfqFe6dWjbM44wgFSw3rFBUEIrQku9KHjpBJzmOmYPO/OZd4uNmgoj6H?=
 =?us-ascii?Q?nkSyoPEl82yj8+g9/RZAsgQMuA7tpcD51hPFvdxWH/LTZkN8j/lhHSjWVJLw?=
 =?us-ascii?Q?/LPt6J/qehJsklRJ1pxyxNFbgSzkyIvNiWiKsqu4JDOpMs0wh79Hd7N8taJT?=
 =?us-ascii?Q?MeM6zPfhgN9ZsgBcOG3CWehf0u8uwfeHWM4eIN3L9ZLfmNIUD3LWjmuPJtgU?=
 =?us-ascii?Q?HqVniSX7w/YnsaMeqxWEshjqNkjt7mgZ/OaRj8vGf9Av8aH+/vYfLKULfFWk?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad76bfd-062e-4f20-f04f-08da675c8a21
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:53:58.4728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjzIsT9D4GAOVEoS3AZcxI/LHbb2d6hnmg4n4U4cvVq5BAsP/GX3pbNpmYmaij2ChOS9lIj9VIiVJxZ6CPf5hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the changes that took place in the DSA core in the blamed
commit.

Fixes: 0650bf52b31f ("net: dsa: be compatible with masters which unregister on shutdown")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 8691a84c7e85..c04cb4c95b64 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -572,6 +572,24 @@ The opposite of registration takes place when calling ``dsa_unregister_switch()`
 which removes a switch's ports from the port list of the tree. The entire tree
 is torn down when the first switch unregisters.
 
+It is mandatory for DSA switch drivers to implement the ``shutdown()`` callback
+of their respective bus, and call ``dsa_switch_shutdown()`` from it (a minimal
+version of the full teardown performed by ``dsa_unregister_switch()``).
+The reason is that DSA keeps a reference on the master net device, and if the
+driver for the master device decides to unbind on shutdown, DSA's reference
+will block that operation from finalizing.
+
+Either ``dsa_switch_shutdown()`` or ``dsa_unregister_switch()`` must be called,
+but not both, and the device driver model permits the bus' ``remove()`` method
+to be called even if ``shutdown()`` was already called. Therefore, drivers are
+expected to implement a mutual exclusion method between ``remove()`` and
+``shutdown()`` by setting their drvdata to NULL after any of these has run, and
+checking whether the drvdata is NULL before proceeding to take any action.
+
+After ``dsa_switch_shutdown()`` or ``dsa_unregister_switch()`` was called, no
+further callbacks via the provided ``dsa_switch_ops`` may take place, and the
+driver may free the data structures associated with the ``dsa_switch``.
+
 Switch configuration
 --------------------
 
-- 
2.34.1

