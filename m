Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0423EFCA8
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbhHRG17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:27:59 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.33]:28286 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238034AbhHRG14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:27:56 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3BF296C0026;
        Wed, 18 Aug 2021 06:27:20 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkLzjwID8JQLW0Ee6ZUeHh+11+wrhYSTPDBm4g9WbDM/zAmQhZR2XG6Nl0SBNjIUTjgWugz7Kl6uahATVdPu4EW/3a5SI4I/3o2HT6UlWAMV0QOAytd8djrOM7mXKtSoYWNdc5W0VqVlrIryHfczPUT/OhdegaHiteHFD112vk6CYuAjDUfO5Wm4ZWKVNTCz1SebhSuj7qvd8jbAIvV409h3NFrns9zZe44IdhLllubOcj6VQUqVoFEat8cjz55Kk5Ns3h59LDPvBGV4nYi9SCcPgoqOBKpGTAqKfR/kvKjmt4NfMv6/KIdMFm0CsQI/+n4pZCZY/5hXYJEHe8GNZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b36e1BfetQ5Uz8Xu29TvcCAvxp27kqCYRYjdwGgy8LQ=;
 b=Z4g5xDI0U/Z9thl1YSyieEFWjLn4DSJh6DMHytvYGqOr84JWe97gGhwirsZXpaK2CmU/G4js0qyJQpVL6yFMGk5WwB4+dl9pX2SLO1RoIm68hfWphLqlMSIoUZxMHoGIstIoxuuGsGX1YpiUo2N7k332MZaGTqbyLrx77K8YgyygHrwQ+CpDre3Gm4a6Y/92H0OThBq35AA9hONnxXMCM/lJqG3zFUxhf1GVxlnyhPOzHkNzfRPaOsKYc355dOWj93FvEYTJNHdrhp3s3JIrCVnGytmMs0F34SyG6kDrMMy7r2A0oSjN3Fl/O425BKcCUOQq8LJxUmEg1jon2ha6zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b36e1BfetQ5Uz8Xu29TvcCAvxp27kqCYRYjdwGgy8LQ=;
 b=Gfw7re6NsWU8mdUHtTvD8wXlFkuprh1MtUeZZMyqfMm0F1mXwERXUbn0AYM/0QgwxEFmj+JiUBt82yxzkURNz1cLGcBud+7754C5xkdyjKLI8ZsnXaD4YhbJtGtWEzyoxYzVcOkKG9Y1RQgl0AR4ZabC9jG/+BvqkUVvXWHeO+M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=drivenets.com;
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AS8PR08MB6616.eurprd08.prod.outlook.com (2603:10a6:20b:319::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 06:27:18 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce%4]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 06:27:18 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     davem@davemloft.net, kuba@kernel.org, luwei32@huawei.com,
        gnaaman@drivenets.com, wangxiongfeng2@huawei.com,
        ap420073@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 0/1] net-next: Improve perf of bond/vlans modification
Date:   Wed, 18 Aug 2021 09:26:36 +0300
Message-Id: <20210818062637.343839-1-gnaaman@drivenets.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210817110447.267678-1-gnaaman@drivenets.com>
References: <20210817110447.267678-1-gnaaman@drivenets.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P250CA0025.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:102:57::30) To AM6PR08MB4118.eurprd08.prod.outlook.com
 (2603:10a6:20b:aa::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gnaaman-pc.dev.drivenets.net (199.203.244.232) by PR3P250CA0025.EURP250.PROD.OUTLOOK.COM (2603:10a6:102:57::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 06:27:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83ef6124-fccd-4c65-86a0-08d962113a9a
X-MS-TrafficTypeDiagnostic: AS8PR08MB6616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR08MB661691AC02F13A6E4DC6118FBEFF9@AS8PR08MB6616.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 231GM31JssVl/bol+TrpBVCPyDyjUd4LhZ0iffQet7+hvz3zeqxTGHoFjegDqjOfMQQiqkC9hlHb31R3q2V+bSPFbNwau00bGwI50g5I5EeHOAiIwkt5wtz20lUm/XfKZGXiU2NAHSML9poj7aXgMjQI3+nJGpQ8QRvStcHVk3mOZi658razMpZJFPQIDy62HNim5+dYyB1g1JwfYGkJ1VTeKP8+jo5DgRrNgoTxCyN99+nwEcMriCSNHjKHFH9/McJLtewkrJ+CKOvFWPBm4p39lCTfwxZMJNVAiei4ck69nn4AQLIgSgwefoLrICpm0vRRx3MKiCP+ATvoESQ38Ro+bss82GRP/A0FF1uHAF76OA6TWnbPbJ+K0FqbBne0eSUZAsOYfACTqTgqlqCDK3zD/EQrpiUqhqktyUZKwWxlxYeNOGI4UvdEsuxp2D5PFR3tmpyZQ1cDKreDUS4HHcV16ECvGz9yPovF7TLSbVtGyXsyGpEZDxTQ5fsBOqqo6qpyFdgLOnwBlGaCGG2MKyvxRwwe5vLsacpiPahGBWnXsc9OQuh4+rmkz7YEXKn2Qk9oQOoPMqOS/X6/8bKyWD8BHvzXnE7+sua1hJUax7hFbqv3J1+8KsCwkVRxAnB7Y+OpiVInQJkaq8PW2oEv2j+8545Adq6Pf7CCd1DR9D+Sr3t+IIXFB+jp55urpo5LON0q/5B9SV+v+qmIsQ5KYJ0iZ5hYTsQtzY2yjvyGLuw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(396003)(346002)(366004)(376002)(4744005)(1076003)(66556008)(66946007)(66476007)(2906002)(86362001)(6666004)(5660300002)(52116002)(36756003)(2616005)(38350700002)(38100700002)(8936002)(4326008)(8676002)(26005)(6486002)(478600001)(186003)(6512007)(6506007)(316002)(956004)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KvXpURE2mZIuOTd5tLnGratNL29bapLULKP8aBUvfQYcwClU+A/FkJ+TyFCR?=
 =?us-ascii?Q?4MKlFLkvGTtzPo0Vbb6Xy0eq3pDN66jaB6+sVT2LpfgWR6TmaS0N0ZAwDBAh?=
 =?us-ascii?Q?9oxGrUDVIGb1eobv4mzs290dSgtMZjxAQVz8hoWAl9YxPCdAnoaO2udeY2Wu?=
 =?us-ascii?Q?8qz19lOUVqNqHqWOlzTW+fRfB3TU0dvWYhKlN1S8wfLTQDKmhksvDxdqKbYt?=
 =?us-ascii?Q?cAuCHeiAxgdycXqlMmwC4JxGEIv1nEy0S+ubj/sKMIfo+16PEDihQ7PuqmI0?=
 =?us-ascii?Q?iCfPhplWIT4Ik7VYnwNbVK1JvtgL1V0rUiUojp0WIguFnzEQPf/AXziO26sZ?=
 =?us-ascii?Q?qNohj4cXrGc9G3QUrKAUFgWsN9ZmmLZsqmbWRY6Wzy7OJf+PV3af1srAt2mX?=
 =?us-ascii?Q?P1B0QA5pZZGE12qwEwUsAKB9vR/LfF9mTYgQQpDnzNk3n9UVC9nyIgdj9rNh?=
 =?us-ascii?Q?vWgnaQhHS0j6Q6RQOk6HVgRjinQJU2/5rm5/Zi3IInwkdqGQAeQiH7hoHToe?=
 =?us-ascii?Q?oqzOWJAxUaWVPi7imgzp8GgxF3cdLfFOrALoC1vAY62jeqnHu5Yaf0DNdT0+?=
 =?us-ascii?Q?ME5R5ozVws56v3JigwYx5JlXFWvrWXgZd2Du7xJn7RuSzI/IP/tmqjRG1zq+?=
 =?us-ascii?Q?5GZvijR8qkFickG2zOBHh28WabhxgEMx07mdTGqA6LVP7Tbs3K/8RT+/DYwH?=
 =?us-ascii?Q?fCjNV+zpKnnYgIXcjc96bXJ2Qc82ossJ2Iseiwfm7kkOLhBmUdOy5VCBvsnC?=
 =?us-ascii?Q?Yp7Tx2b2pUDgrUdDkWwDs4FN73YPnHNMTO10VdwQXXAkbxCu2SSBcuixnntd?=
 =?us-ascii?Q?OTnXL+kDvi2OHu/4axvv9+wLi/PdA0k/j/kZ7VnSnNUk4cdxFzqsG0p64mW1?=
 =?us-ascii?Q?/qJmdCtCvNuIG1Y5E+QPHh8kM29GAeR+1ty4QxWwi7waRj70hbn+ddv6XXL+?=
 =?us-ascii?Q?92fezmAmrQu4GvxsDmZdUAyJc1aIFW9pzpXCt/APZuvGcY51wnh8xP82Bp07?=
 =?us-ascii?Q?00N7NHLALf9RQDpI6dFUWycvn9ZtRJlwzp35NNwoG/McBMBl2RopORJjksaj?=
 =?us-ascii?Q?hIrvjkMAl2yWLQuGcppNajiLQ4nsxjPIkZvlrNc3prrM2gewlu1TpSvdQXq1?=
 =?us-ascii?Q?GRR8TjPzGPELunW2BC7FMl08156eNO/ROfgwrJH34N6SwPtbeTR/usX006Nm?=
 =?us-ascii?Q?a2LI0fjizErgM+RMsqP+Wk9AAIfCsP3Wb0XwnRf5a7DKK4sb2XKEnchofr4k?=
 =?us-ascii?Q?kKDeUWaZsOg0yOgwfnFkSCPP3BK0QhJd9Igv28CEjaYbbVYG+mUXNC3jR38C?=
 =?us-ascii?Q?goxsWLks8022bawN4bHT2RV2?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ef6124-fccd-4c65-86a0-08d962113a9a
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 06:27:18.8776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +4iCxidXNesFErvYmt2t6xFV8yA1iEELlVuTOrucjvrwLCWXyw0Dk+fp3KELRMSpFphXqDyF748iHeMXVfqViQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6616
X-MDID: 1629268040-XcxNoPbs7hBj
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous version Nikolay Aleksandrov <nikolay@nvidia.com> asked
why not remove the list entirely in favour of the tree.

Altough this sounds like the right solution,
I am not sure it's possible to do this with RCU-safety in mind, and I
doubt my ability to correctly patch every place in the kernel that uses
the list without introducing further bugs.

v1 -> v2:
	- Formatting/typo fixes
	- Retarget net-next


