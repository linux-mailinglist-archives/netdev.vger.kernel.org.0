Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE94B799B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiBOVZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 16:25:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiBOVZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 16:25:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2116.outbound.protection.outlook.com [40.107.21.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F182E61D8;
        Tue, 15 Feb 2022 13:25:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnD20I6a+Kv2e0gy4kYBXiNBARr8Y+TUw3JT2iu86NExyd+u3zBGvJNOGko+Y/cq9Ewa3MkYkt1XEQzuzZUDhsV9+u2ohiPiQ32+mDEpy1weSKnGbtCVz/hgCIV9yT+LUa2UW6QQoXnsU01JHjBk0NZYFdoDF6BH//mOAOt17hAGF3zq+/4CfIZiwPNg4LhFK+dzrfJBE3sNyT0Y2rV/jKqstXIbfekVx/Jd0cLpvm5xnyxZtmzXguc+V5Yla3Qo6E9GpQOnf5HSt2xw4mMYJpYF/6Z5/SmkSfNobxoZd08jt/T7SrlY11VmCdaScPOwtEe+KkJTi92JJuUev3eFcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RO03c2eyEscVUcWMCZemjPrFXyHKQn3010VbuxhDgys=;
 b=KXXd67wJ190aIuo44VBF3+wapvUWQYSAwUpBa1b7F61MTa+4ZkoeKhonDSv3TWeK0pV77QA1lVTCQKWZXUIrxJCF4zZ4Ynq+8QCbuXnZY+Z7oGw54KGh74BDiqhIg9sjkvlXbnm97oXc0K8GNxa4i3gNi5jBq5yW5Wrnoo8Ma2FsX8bYW7ChjtDko6pxBWwpqBeP5b9kvDvSsofsQne2x8ZkfK/5ed86rCWLa9ZvvXD/VlFfFM3LPF3VqqLaDJ34T9VvbVqIJbk/ig1QoLqf/RclWC+JDnXbg3lB8tqlCJVbNIRe+88Y7uza/qDGwy891zLPSrUF/6TVk1072KUAhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RO03c2eyEscVUcWMCZemjPrFXyHKQn3010VbuxhDgys=;
 b=oIBXFwijj0vzmRewyMmfvBEY0nmRJEEvpcBkDn9hFeAJ9NaZr8PzTP1B5N1X1JSZpkdTQJQcS49WorxY29npVUESFVtIAJi+AssSnCjR1/XBBPKjD3e8qJHbYPbKGY1t1fkMmWAFtqucf2AZnq+Xnmfgi16DjBPOBQ+rLV1hgQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1425.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Tue, 15 Feb
 2022 21:25:07 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117%5]) with mapi id 15.20.4995.014; Tue, 15 Feb 2022
 21:25:07 +0000
Date:   Tue, 15 Feb 2022 23:25:04 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: marvell: prestera: Fix includes
Message-ID: <YgwaMO/13LuekTvj@yorlov.ow.s>
References: <20220214011228.5625-1-yevhen.orlov@plvision.eu>
 <20220214211743.6fbd3075@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214211743.6fbd3075@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: FR3P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::7) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a9d5575-7cba-4101-48c8-08d9f0c9a343
X-MS-TrafficTypeDiagnostic: AM9P190MB1425:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1425422150BD5CB9822BF52193349@AM9P190MB1425.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: anbUB7oYUiZiOWJvWbc1ELXjnrE9AMUXzbpzR13GuXN5cfTTvmPZJAxHF9acI+YSN7AFQb78LwT5JwOb+xQA7HGQ+SNfC6WQV/IW5gcarZabdX1ORIVl9irYMcha/tkmfBZxd1tzmPbSOS4Qh9eYwu/mFcizIafFxT45OkTIqeEnKvMTjeg8OkAmp1qZRVflHvUWlFHyjvqCHtX1c0dC9EK1iGfinR9XKOxXubOnUrU6A+6p7EJpuEU0Uf1TjqqcPMsAcI/2lFAvThU+Q8qn5vzPxv2v0jfF8ufcITJ222F7lAyNRdd+oC2H3Dc1gNr7u5o7/+Uzb1iGN8fYCy3qZgZZ5Gnaiwj/9QO3u98STIZE+enyC8NIubOjrpHlJsZw0QuYEI6hwjGjyoVmsSFilJcoWVWZ/eTqpiCBGw+gIU9YxuhciOqgPMuBmpkkn2qsviFZlEGvjHoW1Fj/WfxpSn4LZQjKCdaWivYn+zBTn2qZqaCsv6jUS5onH2x53BURPw+HPZnhIcOEOabh22enUz7311BQq5lQo+Ussj69q6gjhBDoX5jFIShysfFNRhboBdeChkbnoeKmZFBt8bRu7NZrS6L9OSa5V3VYxylDOdaeqnZWOJngXcWRwqsYWuO5lKXjJZNew0OA0s3rsfFVAty0trAy2dYOaw7aVKxkqkh81tfK/T6nh8s/23eBqEl4qjrfreff4cZHA2b2HdxMpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(346002)(39830400003)(136003)(366004)(66476007)(4744005)(8936002)(44832011)(5660300002)(66946007)(4326008)(8676002)(38350700002)(9686003)(38100700002)(6506007)(6666004)(6512007)(66556008)(52116002)(86362001)(186003)(26005)(2906002)(316002)(6486002)(508600001)(6916009)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iOfJceMAJo941RPB0R/OHLF3kaef814pLMKXVXQxNW7u4VikZaQQyhYwg8Sh?=
 =?us-ascii?Q?xxylOCzCXmPN1ebWvkARDrWfsG00nrg7JPkIAyhd3xrNbvERcTaPa9EwUEHH?=
 =?us-ascii?Q?EvWbxoWYLzLb+Hu7QupQXfCyfMsK/D1cz2DJVY5URUMeCOiTSWKJvSXXU68j?=
 =?us-ascii?Q?OlSbYUFCd+dJo9OUq1exdWMkfA90ZcWGveyGtPdMQtKP5zqdj2ZyX+kW6q4L?=
 =?us-ascii?Q?9ZV5IHkr6iz8RGQM4eANQz8o3lfg8swqV9IrQ2hHvFYRjw2qk2QFA0W3GLnA?=
 =?us-ascii?Q?V10lMx1go8wzDLKebX0pvV2pUEY1KdfJk+kS/UqS7/0JP5Jwf8NXrx0iZzgU?=
 =?us-ascii?Q?HOY1dhYsiEBoOpZrfOW4RuticXkeq+lQNf1/CUBqr4+SLKVG7zZMV2wpjc5Y?=
 =?us-ascii?Q?Dh5LhhPB3+pukG/i0DguWSc3Hjutv2OwLPCj1n4uwXNhTSx9H+JjFNQy8m2X?=
 =?us-ascii?Q?Xi/PK2HIBOeVq6CqFSu8ANy6LQWYX+YUiiObBb0cIvc29eKOUtXMQIPKbdNG?=
 =?us-ascii?Q?jW2aL6Z39luFHYKFvD+qpM9dNuQmKkXY0MlbAUzKy/fdAcqwyBnCjSdwNe/v?=
 =?us-ascii?Q?6Dkbvqnz0w5RHFG4JC4ZPRnbMZW8UJNFUvAoRBYMlL1mQcoccC54bXEYZms1?=
 =?us-ascii?Q?D9Q1Y84GpPaXLo/2MXSp6cCRgnQT7PYOLL9gcdnrRaVp+P6Neb/CfdKisJBK?=
 =?us-ascii?Q?CkuGNcSTKMk96O4PrWoRN4GwXYq/SA14YNM2NRZLG860mECURLruOSsv312i?=
 =?us-ascii?Q?ssaPQHhKksfgz2KHPJoF2SvH1BS/THYyRaPdkv6AKq3FEUR7sNNZGNjiwPdE?=
 =?us-ascii?Q?c/KfeHsqNZJ/17Vo+qCy55q/S9tTXWK2VOVfpnTCT/sXwXsYTK+MD/dVp1fJ?=
 =?us-ascii?Q?bdgwWuLs3C44dQoFSbqnOSAlCW6R3m/GgVik3IxbleiyGi9HIJB6L6zSX94O?=
 =?us-ascii?Q?EG6slKbJgV/bZr5FPpHAu+w4FT54jzFAIJh3A0hf+ydKSkzukzS15KHJPjZb?=
 =?us-ascii?Q?g7lF6Ynp9jHOOxwJKe19ylzeql1e81Sdb6g/64aqJLC6DBuFTJ4lR1GNzZp3?=
 =?us-ascii?Q?uNmdAeh6KVo8XHEeFxoCgpGJ75kg1wdbhobQCxzS2bOaGlbY8D1EIJzGFXgK?=
 =?us-ascii?Q?0Sm109NI+wYukJlsDdwpoEjFhFvf6syBEnaH5hm2PZMJFCOCdT4h6IljU+Gy?=
 =?us-ascii?Q?jbkEXIUTgEu4jMHBDSrtBwE9//Vg+oGDqVkucewwVSAtrr7AUJ8GI7F+xsDB?=
 =?us-ascii?Q?QUk2UWMn2G8AydwmJs84V9VI06CtuSe4dVwunqSvAVUfRwrE19xNZ6315Kni?=
 =?us-ascii?Q?ax22PodzuvN9epJ6wNSTN5G3XwnTkqLAiRZWmQSgVlo20u0G8aK07seKnxfA?=
 =?us-ascii?Q?PIA7g6u22ie4Bt17r5UT1bIjrVK1tzCPs1bGbF8QYQSjKBK2kP2ZeiAPa7O8?=
 =?us-ascii?Q?zLp1LklL8IjVvUhh63YI9qRjIZwnk/Ys4bcEJCyUcl2TEDDMTVzYOqdInqx6?=
 =?us-ascii?Q?akh1bh5eGvBEOuwKkjXk8wQ+PmkD8t899P2LxOWmddeFyhfe8yPRR+KmDS5b?=
 =?us-ascii?Q?1eZcq7QO7QCxoOK9ddRErQj+uz6c3EUucI6HopukyMeczhJgyyYgvL+N8LTH?=
 =?us-ascii?Q?J5MEFiqT+kX6VkCLImDJ23gG2thzExBj82gZNZQJ+jpu/Jgngkmj+Aw9ewp7?=
 =?us-ascii?Q?mrCcgg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9d5575-7cba-4101-48c8-08d9f0c9a343
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 21:25:07.1261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10ua0tm/lKMDyvfsMtBVEkRb9/q4OTcezVPcKpwFYhvFdJhghvGLoYjUgHuthS7CTxVlncbT1GoXJBPNjS8mlhTy6M1tHcTtMlulSFoKgvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1425
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 09:17:43PM -0800, Jakub Kicinski wrote:
> *May*? Is prestera_hw.h using definitions from prestera.h today?
> Dependencies between header files are best avoided completely.

Make sense. Thank you for review.
I will try to avoid such dependencies in the future.
This patch could be abandoned.
