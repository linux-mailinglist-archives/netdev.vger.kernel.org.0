Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434B46A7F7A
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCBKB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjCBKBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:01:07 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20725.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::725])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8406C18A99
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 02:00:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRBXDLXobQrkPu9M1ivGidDIPAahlzTZVX6Raz82ug2WAyPT8AD7I9vW3DbIX0wNLIdoJNId3DYbUr068iDibanbb+JDiBuA8UwpibQA3qkDjFZ2FUXNavSLzf1XZgUPpiKhua6AIgdkjjRWqBLiU27f9M66e91JdMIsjuWK47v1+iOtU2/2ijgRzbbzW7unC0fH2UqpRNH0ISidfPudbqHnDVotCMPDHBEK6k4R31Q9ouzgjnR1kilP1P7RtT62/sW+Wmll/hxN1YAJaWFzz8aBMa8DxXjCXepiM+/kiknr08y5yRR6va/8PLYvU/+MprlWC49ZKhNpFarCpwUgHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blB+yIin0Ex5x3g19Ifp7A5ZLaRBGhG2IM9UEC5U+uQ=;
 b=kASeHTXKZhFhBfdLygLN9ITIkTd7eCUzpLIzbkr0i5O/KKUo+C3UCrmoJNHZBJUAswT+y+eUfp6OW2SIOc8+tvMP4dTj9EfZMjAzv/ydUk5EkJgbwqrPMDF3PwST90MtvjIENFC7VDdv5Mdwv5DwfM2LJmC2mJvOvHAAk+rlAERRIuB34X1SLSHQCJx81/27bfmFnWLrjAbGm/vyX52BZLvf9wHTdrvsqVh2bfZeUmKtru5OxbYR9cwSofIU1VdIarposHeK0aGYGbXkesKE33FuH39jAlrdfpunutkQfwEeXOCQYRUFpPUj1ajfJe6FZhaXVyUhkuQHXxBQ40ILWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blB+yIin0Ex5x3g19Ifp7A5ZLaRBGhG2IM9UEC5U+uQ=;
 b=ftfbjb5xlD9x+9CB16PeUvY+yidWOmm13wZ6XK0+v4gW+SKDrTGIdApH2XLj5B5z6HyBH/h6bkEwqpTfVv6lxgx0r6H/rk2Xpqcu3xj4VNAkRFmi8ms5EK6hYbGtV2yajcGQBaEVbtVNNBs0Qx58Hqbt2pTbJILCYxUt5R0bbhc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5692.namprd13.prod.outlook.com (2603:10b6:a03:407::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 09:58:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 09:58:56 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 0/3] nfp: fix incorrect IPsec checksum handling
Date:   Thu,  2 Mar 2023 10:58:27 +0100
Message-Id: <20230302095830.2512535-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0008.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5692:EE_
X-MS-Office365-Filtering-Correlation-Id: 924d9c35-b8be-4e07-072b-08db1b04bc73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x7O7EfHFZOCZ5Zjf/kBvhe9rgZVr7lulU0LT3TIxIooWUyjQFtaZVswqog7NQqACalV7/HDdh2zL7UCnf/3CQW6AHlYK1dDE0yAjTgHyZ9e8CLcZLUJ4yJ+/351xxB2uiWi+6J3Bw3ofpQc5aAQ9+BTgl9h3VJ/TWYTGkjAePJV/2e50n4hv4nTWSpugSy97wqc+0UwvdZ9uKcYjqD0JAg2tosHavDdg9/SqdpXeFeR4T4qOFWIWlFnSGhdsC+lZhN34TMNG/TIwd28dQInFNkZlYeSTS1DiPDdkDSsJ3EQBnapjt7KSfZbPfuzTllD8DXCuUiEpto6PZ5Pu1eEfaqP+2HXg79OQ7k3QIw37bEUTwLg/06Xzjsf/jyKA5Hl77fzmY2o9gLSjwZSWhpsJQDoyNqDpjy9U/17BDC5y5CugmwGEz1e9pjeXxXcyUK6N9n/WUHdIxv94yKHgRFcsqX3rirdaIXCJWJ8WGHBLw3Xc/2rFkhcRfryAXwWCjgrahpfBtiAUog+9vTrC0KqZLyWFy5NI6Ht8/3jx7KPb/Ub0kNRd+AaO5C+5J1aUqLvHSUcK50pdVrUP1EVU+mJIL7P2jIXtqeWkpVh50i8xX/y/kTdp9SuZB1T4OWfX+Z653G0Ied3bdKQvmpxyuWJFYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(366004)(39840400004)(451199018)(5660300002)(2616005)(44832011)(6666004)(4744005)(107886003)(110136005)(52116002)(38100700002)(6486002)(478600001)(41300700001)(186003)(36756003)(6512007)(8936002)(6506007)(1076003)(316002)(4326008)(86362001)(66556008)(66476007)(8676002)(66946007)(83380400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ohw0PQwT2Aoib5jxAHvtbCfkx9vD4ek92RgA/dhTeBGcLK5ewiociz2UykQV?=
 =?us-ascii?Q?9O5uqVfPE33j/EXlP8bRksG9xHr29gl4F3+hPNdxZpwi3JvyOdEZ8YsxzXWQ?=
 =?us-ascii?Q?riRdUm70/woGPpGcEWpHPMI/quSxrvnU/Y3/k87OW3EH6H9mqH349qRpG504?=
 =?us-ascii?Q?B1rNJ5/uhFp4SRk9NydMtGMTgI74kbLdx0K8JOGKiYAb95tuX0X4xQaOyOnu?=
 =?us-ascii?Q?dSXKGYgBRgmzqh9gm9daWE4KzQ95wvCg/CtYnBFOOhGRp0UyZmmF4Y+/FrPc?=
 =?us-ascii?Q?HuQhtrAs7H7mpOpmfa6KhJNxH1I3CR/yX6qCXaUXZj/75/+VXMJ6arg/LKNu?=
 =?us-ascii?Q?hGzR9Ad8eASeiF+k2Uh9/1x2KY4tW8KwFXY5HvFN8/W8ru1QQgMD9gns61cb?=
 =?us-ascii?Q?mgw8Wn5UQfQpK3JkI7m/LKJMbNEy3T8qt9SZDAi/zvdXw8AnTLK5KU9ybY3W?=
 =?us-ascii?Q?Jk1A0Z/HMp9neAdsTwlXE+U/uFcuDYvW9qTaaRzLWfnv9sIFP0vBWCWRn3CN?=
 =?us-ascii?Q?2CRZ8yXMIigvJoylNTHGoRQNowjyzx2irX3RCVW/36ubvTgsevr7gDV9zmF5?=
 =?us-ascii?Q?rwME9U/B7k6CNYewwGSK5OIfAFAo1jDr5p48V08e30Dis8dBYioVJgGnPNbb?=
 =?us-ascii?Q?cHc7HZdK+gvSW5Np9E+Mo3ix248T+2WKZbHZnqRFo8yfMOAowJlnT3fkdgjJ?=
 =?us-ascii?Q?YBD9OsszyBq7+54c8UM8WrcuwjCl9uD7GJbNGO0Ld73f00QVpZlKSyiVpMar?=
 =?us-ascii?Q?bHRIvUTHPBvuxsBftkYqp/EegXaN4WJJCHyq4sPReItCsnILOhXCfcgi8f/3?=
 =?us-ascii?Q?cUm6y40AE16v7zCSMu8xhrE8G0xioS3rF/3y8uJtqByGPjoUytgrp/dfSwp4?=
 =?us-ascii?Q?irHUgOdyMUEN0CnPrFn7h863+9LPI98URot4uGiGdACinYaeJ481fkbWtoNK?=
 =?us-ascii?Q?OELLlO09miZdQVvLxzkGA2W2T/BBORkVdknTJGu7ngmELk8EdOXlQ8vuEWRf?=
 =?us-ascii?Q?fnv9nowfcu8i0dypVgOnQgJOuANxLqW8Mm+yBHwdAx1YsgNYyic5988cIZEd?=
 =?us-ascii?Q?1nJMnd+XQCyjgDmOMzKI9T26EYUKlpYAHTFXfY4mZVBaskbF5unm6SpMuMfX?=
 =?us-ascii?Q?fpHQeuIOAjBKV+d/Dzdm1k8MVY4MeyKiOZPcyXLq/SK46ihpVQR+kQ8dqT0G?=
 =?us-ascii?Q?4+z8/Qxeg+s6j2GPmStWxaueyr62TCygw9j0vaMOUlxGKgo9a3EaHMWPtjVa?=
 =?us-ascii?Q?Esreelj6idcZ87D+IfWzV+pCugZ2QaQX3K00z45Xj0VHR35lK37dNgAGbJO7?=
 =?us-ascii?Q?ep+rOBHvqHNfTPRIVvdPhG+eVphuRWvZ91ig/9JbQyU/Vh8hae8QA75RUdgS?=
 =?us-ascii?Q?1EmTNBU3/28IgxmYi+scI8R4YG0WLNMSqyyb2aJ2Dkg8Tdcj+lSA/hYVez+g?=
 =?us-ascii?Q?q1dHb2bMSURihFlSq/mLuN2LGe1i2e1eR4FSZ9fEjvOvbrkmGR40Mh24XCQc?=
 =?us-ascii?Q?4c3VdsGMu3oeAgoOZ3AFnladz2/8TJjftAJqeIYqrRESDd14oB3tLQkHMXKc?=
 =?us-ascii?Q?c3fLpTcJPx72eAjato5aGvWFi0VXCWh+LDwHju/CkT/IegJ86Dz2Z3k/DJk5?=
 =?us-ascii?Q?oP1h04Mi7qVGjCcRuYLWofcV99Vy+NyjYAE75myOZ77E8IqC44DRVwc1+i62?=
 =?us-ascii?Q?0/8tUw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 924d9c35-b8be-4e07-072b-08db1b04bc73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 09:58:56.2124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWpaSmbr1RCDeUiDPHeY2NiMnxns1X3epBWScQSCzp4ZWLpBfPW2ju82CGNR2/ZldzYucE4DaHxb2+nF2CwLKeeYwRSrulqrXapmZp6+9BM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5692
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series resolves two problems with IPsec checksum handling
in the nfp driver.

* PATCH 1/3, 2/3: Correct setting of checksum flags.
  One patch for each of the nfd3 and nfdk datapaths.

* Patch 3/3: Correct configuration of NETIF_F_CSUM_MASK
  so that the stack does not unecessarily calculate csums for
  IPsec offload packets.

Huanhuan Wang (3):
  nfp: fix incorrectly set csum flag for nfd3 path
  nfp: fix incorrectly set csum flag for nfdk path
  nfp: fix esp-tx-csum-offload doesn't take effect

 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  7 +++---
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   | 25 +++++++++++++++++--
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  |  6 +++--
 .../net/ethernet/netronome/nfp/nfdk/ipsec.c   |  8 ++++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  4 +++
 5 files changed, 41 insertions(+), 9 deletions(-)

-- 
2.30.2

