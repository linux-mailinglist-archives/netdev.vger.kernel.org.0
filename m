Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D963D0064
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhGTQ7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:59:06 -0400
Received: from mail-eopbgr20056.outbound.protection.outlook.com ([40.107.2.56]:38117
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231910AbhGTQ5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 12:57:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUogm/p6cGw2nxkCuej/MuYwH1KqzZTGy3YNvDu0NzJpUEnwEyftR4MY4JnnX3aIaD5bfF35syU5810/LZ7jB7nFQ1DCcTXSrL8Wv2ZvnNJG3Pth0FA1lB93ItcfqyGYYmqEaYfv1sfClqCqAbvv1sq/m76Mwez0slLysHYiDheM2djuX/iEW3iCdgPsetXHzh1OvQMHqyUVBXj+xK3ecbAAV1+RLiLrGppMR5+QDgjegYR84Cs7MeUfq2XS9+h4Ca7H2bjzsutTN9GUYJJcSwX9pxGWDzEBfg0K+o4qaWJRA9RzCCeS7KqpuYhrW32ePspLyL7/XKok2YzWqg4Acg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frswYOZLMCTRxp4zmq4tpQ1QmjO9BmtLY0rA7qrfM9w=;
 b=O1j2hYCM59zmQuziiBxa/S0g+r9ydI2gT2zfvEpEpff3CTM7qE5ii1wNvjOPGUn5rU8hgk1NKejGKO1ZopcMGjOZmtw0lfmVRrJPLpAOI9SZ4GIHaa15t9Y+VYhvaJPT0E1UZ+O3fG7IXqj3iMi4ykd5Qa9ls1Orz6prc9nMBQ+q1CehN/LurbXrl2etyB5NYdDEaVzH8WM+QuNI4Z02uCAvE2jybafOXIp4wI+exvUAqXWEeB0h/Y1akE2C1hj0ILMd61m6c+u1YGGDHyDn1d++wHmgLscjElTMWLqwjaaQvfmVQXaYHuBoxwVsXyjtYf8ECtgEVJNPveztvg0Isw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frswYOZLMCTRxp4zmq4tpQ1QmjO9BmtLY0rA7qrfM9w=;
 b=L+X52G68+Y+pjP6aJzABOfVsf84CTVGf++O/PeCOTVk+eu1+nASPPAOy8gIqtscwKPnHhXsAHIuZzu6EgXhmJf4xFHwhGmWS1oyXkWOOdRXYRpy02kPJ0pryCYp6+9HG9TN1ziBzMNCJ09izUFbOXDFkK6274vKoh2UmxaQ10MA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 17:38:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 17:38:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 0/2] Fixes for the switchdev FDB fan-out helpers
Date:   Tue, 20 Jul 2021 20:35:55 +0300
Message-Id: <20210720173557.999534-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 17:38:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 220f5fd5-0674-4449-e000-08d94ba522f8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3616:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3616A3369ADA3DF0BCA325E2E0E29@VI1PR0402MB3616.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kdlGWvIvvcdwqltKwtNP0XlMZ9efH5//omLVsNdAmdelnEQAwJchsChfCRN2RZ2zn9ZwdjOA+DshShcRx9UmZLBBsa4yxLsLUO6KLyKwZVbMRItpbYiLPjW21lV/jTRgq+bHoVIP9nEcYqi7+i1hwDm68wD9EU73qwBy13ALRBDJ/yzj3cUzEvihb31hsHkigvn81NcKJmq+QYgliDsXwrcHLI1qmv5/WNfXAzjvdLa31AQK5AMyQyx6bA2zbM5nyOGgE6cOXJGN1cJyckr2Ewd4jRxwDLbH6hJdFQrXWloaC0+PQv47tok2LJ+HVRtBbhnreNswnMro5xItuZDhOx1NUqDbt8rH81ceFQE0btThy7c/JEskG14sn/cRWbhn8bGHIhp2su9Xxsl1hrf585GgutQ6R2cegPyTHzk1MR14qHGMXBqUCqPKi7P/sE9ng8vi2bC7XsZviXQ+EhujX1qyk4zSJEbmoPhqFmUrMcPPv9V6MGtVLsNmwktJhVkoqd7WgoWdj+UW2mJJVlIaOxQV4oH6e0SkiMONwmYGfuQYVz0MybS3y0KG+OXuIT4FAfY7+Qt+CndhgoEnpdqWwbe9yBxz9A85+IlBa/CXfDmEPGoc9yJ8e2m0efqGmghgd8FCdZ7yjOpz+6KXzde5zJHqhbmjjg/tERa0+6xLzZuWq+2YhGzG3QUoJ+8MtleOO+XvgOh5e7VSuTRctxqKmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(396003)(346002)(376002)(6506007)(26005)(66946007)(6666004)(478600001)(6512007)(186003)(1076003)(86362001)(52116002)(110136005)(66476007)(6486002)(36756003)(83380400001)(316002)(66556008)(8676002)(956004)(38100700002)(38350700002)(44832011)(8936002)(2906002)(4744005)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IpbGXpEbZQkYHsDZQWHMH7wkqFlNfQxqJOfd9WhQ9V9FsF+umMavklMHktca?=
 =?us-ascii?Q?pPfkKQr8oTLdJrLq6hlbDG55V9Mahax/4GzNeADYEERe045/2+H9q3OO8W9F?=
 =?us-ascii?Q?UHy1BFe98K0geLIDZM70EVtqEsaJ+E3utCPm+ezQwWnDDAuu6MSgoiJlfmgO?=
 =?us-ascii?Q?TT8IarKO4g3c5US9sjtg/YTeokRx3PUxpjmkd3gCLZcmfakWBANZbJZHcHvj?=
 =?us-ascii?Q?FB+SZ0OVcaI2I6wXFTJZ9+Js7pd4tOuVIo/Tz+Iy55H1h4n1drcylps93wu7?=
 =?us-ascii?Q?a8qIOAY1x6E6n2wmF0ngGfBWsRIotDEO+qfC9S0cZBIwjKSnPQIX0JGBhbX+?=
 =?us-ascii?Q?0C5JWhEq/LVR+49B3oTxRca//dK2XBGa5Ss6FhLJqSUKf38hv5RzaMfr9Op1?=
 =?us-ascii?Q?QqePuKDcBtyLV/YAnSnbxjvoDMf/ACVyd6e0bCyfSNk3SHb5k0erG30qVelQ?=
 =?us-ascii?Q?KFmr6JriOUIlTPQu3p/bKaSQy/oCShIyy70SuigmbhsQ35r1fhidkSxa7idd?=
 =?us-ascii?Q?GfL77XsTEVAagVJb8TnkGOck05VJmpSjX2YOySVOq/1KmZVyG8DPj+a0T3s0?=
 =?us-ascii?Q?MXKA2hRkkK+aAbePn00XXiafoxnHouBT8b/JPCs8CkkGjYcCRmHX4uEYE3wV?=
 =?us-ascii?Q?dx/o1U1Vq9v0aZqsHp56ftfMMahGSMiXcncgbnup12dbS+/eXryzfyENKBCQ?=
 =?us-ascii?Q?aR5uE3NIrIisBS15LUXDeiop24xtGFLeUbA00RVCkZ2kIR/ez5dwsghn2a4y?=
 =?us-ascii?Q?KJUhyfxD3KemkMdO2HkffFryZhm20oL2YKdxY25gyrrrdb8rGo/B6kxa2B5j?=
 =?us-ascii?Q?G0cN0cMW4B95sLkQaggBkOcmcwsuT5T32G2LV6hRo7vss3+lNCnAm4MmZyHz?=
 =?us-ascii?Q?wdH2AZFpX+V3f7VHNwVYK2ahd9GCqdbZ9dtXTSbujsBbOgJoE4E6CICxRlFE?=
 =?us-ascii?Q?kpYV+xSqTh+NkTIcQnCK2Zj0ZbAFoeC6SXalA/tqKHJoJN29L0Z4uGDIoZOR?=
 =?us-ascii?Q?jh6A1XkWs7VowD0Kj5uJIHnxYBilqjV8ZKonpG6UOzCuV5a40MzOh5Zs2Vqc?=
 =?us-ascii?Q?1NLJfzEp1aYx7PcRJDyGFPfQOQpiN+jmus6zzuiep9C8SSjcnud9xZ17069S?=
 =?us-ascii?Q?qQKf6gPKvuJFsZ/Zph++HfeNvxO8LUJfyqViAsNezQEVqqFoqDeNxi2AXA+a?=
 =?us-ascii?Q?CQtuqVNHAHl3IU2CKW5iQp6BT1lcfVo4IGfPakSEyfQmwLsNYoeU/cOGhouz?=
 =?us-ascii?Q?2tkmOfXFoADCSnZA1i86kZy6/21Up4oXei+C+NsD+rilbVwAuJlD+rINjccS?=
 =?us-ascii?Q?54i7Jgkbp/V+U6jh4I4UWw25?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 220f5fd5-0674-4449-e000-08d94ba522f8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 17:38:07.9567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCcW8qcFS07gzcs0U/JtdEZqccW4UwhJYl2Hr4bmPlhm8P2NLkA2g0aWjh5CHwotnbAgaekGW8v0yaqTI+YvxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

There are already two fixes for the newly added helpers to multiply a
switchdev FDB add/del event times the number of lower interfaces of a
bridge. These are:

(1) the shim definition of switchdev_handle_fdb_del_to_device() is
    broken, as reported by the kernel test robot.
(2) while checking where switchdev_handle_fdb_del_to_device() is called
    from, I realized it is called once from where it shouldn't, aka from
    __switchdev_handle_fdb_del_to_device(). That shouldn't happen,
    instead that function should recurse into itself directly.

Vladimir Oltean (2):
  net: switchdev: remove stray semicolon in
    switchdev_handle_fdb_del_to_device shim
  net: switchdev: recurse into __switchdev_handle_fdb_del_to_device

 include/net/switchdev.h   | 2 +-
 net/switchdev/switchdev.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.25.1

