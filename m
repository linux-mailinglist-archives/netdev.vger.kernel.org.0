Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207F140FCC3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbhIQPlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:41:21 -0400
Received: from mail-dm6nam08on2124.outbound.protection.outlook.com ([40.107.102.124]:58501
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243684AbhIQPko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:40:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDHB2vi4zZgkRloWYqj5SXE/RmuztuB2QQwPExtjg5vxV2nMl3IlDFH2mWDYfj7yS4vqNKwSAGgtCzlyEanRqT1pfp1ClRp+1fI6bqIfhCtYnqedH/yjNneicKu4MgXS8LDVY9iVjiNZ2Jvbgpg+ceegXnzz8wprALXw07rMQVCD+3NOtQzYkorVJWnv0Crvgpu+vbX6FBM6UYJsR25LaPX36tiF2NftzMoN+qxkPJOQL7bHD9HeJAEzDAsOn6cnuuQf/NPqA7bY6Opb3XMn5ZZrpLZzWpTL1xJ/iALQHQJRaIuBsnZfKYs0CReMpt2InekQQBFliJk9e2ZHSjZ8Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+608CO442Q1zfrjS4eaYZ+luJKJLi4AvrJhaVCIS5yw=;
 b=LHodfiQ55oJikLbiCDVIrQlTXX/kvbOBLIbTpoeNA99Y0yYaWMblnWZHMO+sY/liPNNKNllsQFwYzx942xivRGDgFlHBN1vUk5WY1yLrsU7G6Foologaa0n9QWHmmxVqEjkM7K+ODa/364lZQvQdvRZM8n34xJ0emwZsB2NZYc/A7EO0G1NxUmzzNUBbpQnfb7lpA/6tokRCd7hT6BbKZ7q4ZlIk/NU9rABDBY8ZO/pBswuiz+UgSEA35dC6bLhSr3g+kbYOWssENGbpHEf3q6glOg4fftMJy2pZg16rKwqNb1B9a18PxAfm7h1fp0RvS3Lf6awQma/bliR7WMKwxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+608CO442Q1zfrjS4eaYZ+luJKJLi4AvrJhaVCIS5yw=;
 b=Vyjhl0KcMj0WX1hpXdXRgyDsi1lq1bfprfzUK/oYAoZ8wzRv5/SBdXA9G7n8YlfrYYTcer7JMVWgsZC+dImOoI3Lcltj1WTiC/r9yPNf/gsrRcLEXhfYyz0B+KQ1trrfkYSEVlJLZCs2x7ZSejKRqHJoQhoZ0AFqfGid7b3bTok=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1933.namprd10.prod.outlook.com
 (2603:10b6:300:10b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:39:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 15:39:18 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 net 0/2] ocelot phylink fixes
Date:   Fri, 17 Sep 2021 08:39:03 -0700
Message-Id: <20210917153905.1173010-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by BYAPR02CA0055.namprd02.prod.outlook.com (2603:10b6:a03:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:39:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b58a59a9-9f92-4d3c-a862-08d979f14fc5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1933:
X-Microsoft-Antispam-PRVS: <MWHPR10MB193342EFFA0D6F401479057AA4DD9@MWHPR10MB1933.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2MkPpk/7ahzVa/j2zvuyexSW6XUxH5QDRe2U9tHabNSvOquFEVTO45giBupXy4w6iAlHIzzWYr4K3PQP/tagYLZkQGtHnHiv/zGp95NABwfn8uwF1cHpoLPtjZBCbJX+zPW6gF9yr4jfdvU3v39hS9ZuUQwd6/DxosHgeVVBX3AXn1iYeM7JEWgapLi7JglRne+f+mLO6MP0CZOwkzU24uORyIhOxrp1d9Ozu7M2PAgj9SVDEdcircO27Dz0rtr5hbk0iQcqtiRfVe0hunSKNjxOsYCqnU6IB+d/5Tb3kj3kBO049UHxLPj1zxqagSqC5ShxgUIagcGND6P/rG1zcq4kZyAshmgfREgiKYIQyEtEk4auoZR+I1nsSg8DBLeLV46sheYyrhInlOUN4k5mixmvj6WnGxQspaIaFnPjvGiKvBPIxKFAMwW080pjRrBh+QJZdsev9H/fKCxXDVejZswhGWs9YbhEneG3b9MsnHhCqy4eDvd0FSY0J7n68ICtNP8fumKXVhmCe0gFqZseNkA6Sg+arB88M37bqAAeOBblFr3lOnPThhW43gFZBCfnPHJlZXCGELq0YTWLkWLdYnmlO7tlL8rTPds4vI0ruxNz62GfS57WdAVxcFSkNq+y3HPXDrM86x3S1sSOLjpaUp4ihjlKHPcAHvFWbPs83JTouuQEcAFoBMZcbvKgjTXi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(346002)(366004)(39830400003)(38350700002)(5660300002)(316002)(83380400001)(38100700002)(54906003)(2906002)(6512007)(1076003)(86362001)(6666004)(6486002)(508600001)(36756003)(44832011)(956004)(66556008)(4326008)(66476007)(8936002)(8676002)(52116002)(26005)(66946007)(6506007)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DcZ1WT7Q5iZBD1J1GZ4cAer+q1LUjXT33DR25Xp6GA1u//TzzrrqolUVFisF?=
 =?us-ascii?Q?3B3mV2EXGOsBzqon3p9iz2w7uxilRWQ3AZaso/8+eG2Z92bE6Y7uF543RmOD?=
 =?us-ascii?Q?BjHM6Wh3Fg6wFCirqIa3ST/KcLWCIdpRKK1//QwLrRk8FP5Eh7TGQRG2wtfR?=
 =?us-ascii?Q?jvFhuXblLNzooNIhCQ7A/Zp7uY6QDlnZTBJUterMHLQIG7PNWw7wmO6veoEo?=
 =?us-ascii?Q?NNve2C3tnege4XzQ8Wty/scMIX5JPCzmsMKtHxOO5/zfuJRA0dsezcjCzUAF?=
 =?us-ascii?Q?eablR74rHq5T8RCZ1e6pIpVsbqoywzaSz05MnKHIQyw8j55UzAS43qDPHXAL?=
 =?us-ascii?Q?R3ZPPs8ttE/X8fng6qsFLqAaIa8gu3FWbHRWt97pGJIjFKZsxMRkcO7xpIDI?=
 =?us-ascii?Q?HkKva5fpxutnx+mi/j05zsFtVO1uUi+XOgO+5Iq7DpG+MgYzbd+HWG1ZZ7OI?=
 =?us-ascii?Q?CbPOAR+IUebbJv1joJitMntW4yqHx2EWP+XxlqIVpdR+zqWhAo0QG97vKtcY?=
 =?us-ascii?Q?jGpBRLwxUsSpCkQPXLPkygjZLEDJCOILi5CgWZYOa7XJ4JYt49MaCc0hWjFo?=
 =?us-ascii?Q?TGnmq/3jjXcCAxv1cj/xKK1lN7aMyFazjO+7KqMH8mk4hTYnsPywUUe8FSuA?=
 =?us-ascii?Q?Iga1cxdcQSqa7+5qwPlWocYiCc8wad3RzjLnNEJfMasJFs17p0dkj/p5/Gtf?=
 =?us-ascii?Q?GCU+A85JISHwfADofNb7JNUEoecv6Z1kI0D3153ZYbgVeQTb8voXJO4KWAoe?=
 =?us-ascii?Q?aJddGFCfgez1HcUCpC1Y9G0merghg/RMXC+Y9ulHVHO7i/ydiBKWyaSKsSQN?=
 =?us-ascii?Q?ETFEAiKgzJ/r1OsW+Nti9QgcK57iDKJmfCY0LAZFJd9yRln8fCUypxKbw9yA?=
 =?us-ascii?Q?35rD3khJ/R1WTiQ76zW9AfYMe1TyAXqlY9mh9JhQL1CIfPgnAgaAT/Ih/PQq?=
 =?us-ascii?Q?6vJp9yOT0vPTZYi0ZcDT/oLcCMhoC2f4eYdq1RuoIP4XTV+F93o8vQjRQXTC?=
 =?us-ascii?Q?P2W31LSOBMqaSscAnKzohFnvjKVuCBq/fnaNShh9y6g1Ryl7RrhLoAgYHXTV?=
 =?us-ascii?Q?+b/ZhFzLIldCgahoWFJj5oEjIgM1QLxGpypeFiPI7qgKN8hLKafl3fT2IHTC?=
 =?us-ascii?Q?uWeEhknD45rChvTHeNV6v5AURqeusIg7lHo84PtPlG4N7X+5DhqVbWZ8uypY?=
 =?us-ascii?Q?aSw7SS9qtuMmcHnlKJYVBllMbZhwUAiVjFUb5AToszB6oFmLczM8WmiufLDd?=
 =?us-ascii?Q?UQLJWDnA8UZOXCMxjsLoUR/2phDWUUPgOyTxflVN+0wvxth9PdEXwBk3sNbl?=
 =?us-ascii?Q?ujH/KzvEtbWL0d7OnD50oqQ4?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58a59a9-9f92-4d3c-a862-08d979f14fc5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:39:18.4247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJJ8jXEBXIOFh3qBpMP4nVanudHw7TUCvUVBOadbztFz6ZpbF3LGIYFQIW9ud/+zgxGcRCB5IgwslG5B4HSZPmnpsxVco1eIhyfTB2c+b8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1933
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the ocelot driver was migrated to phylink, e6e12df625f2 ("net: 
mscc: ocelot: convert to phylink") there were two additional writes to
registers that became stale. One write was to DEV_CLOCK_CFG and one was
to ANA_PFC_PCF_CFG.

Both of these writes referenced the variable "speed" which originally
was set to OCELOT_SPEED_{10,100,1000,2500}. These macros expand to
values of 3, 2, 1, or 0, respectively. After the update, the variable
speed is set to SPEED_{10,100,1000,2500} which expand to 10, 100, 1000,
and 2500. So invalid values were getting written to the two registers,
which would lead to either a lack of functionality or undefined
funcationality.

Fixing these values was the intent of v1 of this patch set - submitted
as "[PATCH v1 net] net: ethernet: mscc: ocelot: bug fix when writing MAC
speed"

During that review it was determined that both writes were actually
unnecessary. DEV_CLOCK_CFG is a duplicate write, so can be removed
entirely. This was accidentally submitted as as a new, lone patch titled 
"[PATCH v1 net] net: mscc: ocelot: remove buggy duplicate write to 
DEV_CLOCK_CFG". This is part of what is considered v2 of this patch set.

Additionally, the write to ANA_PFC_PFC_CFG is also unnecessary. Priority
flow contol is disabled, so configuring it is useless and should be
removed. This was also submitted as a new, lone patch titled "[PATCH v1 
net] net: mscc: ocelot: remove buggy and useless write to ANA_PFC_PFC_CFG".
This is the rest of what is considered v2 of this patch set.


v3
Identical to v2, but fixes the patch numbering to v3 and submitting the
two changes as a patch set.

v2
Note: I misunderstood and submitted two new "v1" patches instead of a
single "v2" patch set.
- Remove the buggy writes altogher


Colin Foster (2):
  net: mscc: ocelot: remove buggy and useless write to ANA_PFC_PFC_CFG
  net: mscc: ocelot: remove buggy duplicate write to DEV_CLOCK_CFG

 drivers/net/ethernet/mscc/ocelot.c | 10 ----------
 1 file changed, 10 deletions(-)

-- 
2.25.1

