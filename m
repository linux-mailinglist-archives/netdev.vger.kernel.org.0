Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC542CFF63
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgLEVvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:51:18 -0500
Received: from mail-eopbgr20124.outbound.protection.outlook.com ([40.107.2.124]:61735
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbgLEVvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:51:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uts6Uk+wg6xeAH1bW7Syw4rDQ2QznfLKzObJJ3lD7No11opFDtmhp/zkIIK6aPKNHqGaKJ3MOzJRLbGMIXacxVuZNuhWw9LQlEjgDEohLRbnRTSvXI/by2k/E8/2AiKdXwnUkiOofEF2sqQ240RLomvGQnbF1lRYYpk6hCJ9hLjTA3vPj1au6djpczZM3n18E/UXt72LFUbJiai2JsQMHMH3MZOS3Xhf1TdPujUU4mF8K7FxNVe/G/wFUJR21Wm1QD7rV6h6soqdVV1x6onW3fRsQ1cXUDEAckJtTeLg92/rYH6Lz8ykuBx0Ah3Nqd8xTyJzRQ5zoS/BUOFoYdItdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOLRSOPunIQjNNx6SAyKyFs7XZvCDo450U7vn/K0GHY=;
 b=bq3bJaBHLaHMoYOMxuj/nsRvOrqmR3QGO2kjqh1IEpEHnjGCYyHae57Wu7KG8PjVSI22m7bAmZKvjuP45b1llWHfc9RgPd7TnRP5FGn7Me3f5TtK5P5lqkZzuBBOfquQVTvfAiYA5M8rrO94iOAZ4/MYv8ypda/mnShI3TyXqqZ/A314ZB9O2mlXWnzt3aXGluVSnhY++p6Ok8ZIuUBWbNhAnttyFNNHTyl0F/HuVh3TSNMPiYYpjvOhbcsuVXduMlgi8i3/57sGfxytDP3uUtupQp2fGVNJdYOP/vexanFGJW4mvcIwj9/u03pD4krJlDZCJEX9j08aC2y5qvBMZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOLRSOPunIQjNNx6SAyKyFs7XZvCDo450U7vn/K0GHY=;
 b=MLhCki0tqCS4KWt8cttN7nMK79RHPZS6ztFOr0cDgu4YFmJt81RihjxOo4ndGT/mtRJm4yaFMObK7Pdkdq/pn9qgc4IIp5+P1vhJN5IVN7og1WEdXkXaaW3EJy9SdayUq0sBrN9+xx4v2HBzQ8PuBmJyCmSSJ4d17GpsFh+MVC8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2866.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sat, 5 Dec
 2020 21:50:28 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 21:50:28 +0000
Subject: Re: [PATCH 11/20] ethernet: ucc_geth: fix use-after-free in
 ucc_geth_remove()
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-12-rasmus.villemoes@prevas.dk>
 <20201205124859.60d045e6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <4d35ef11-b1eb-c450-2937-94e20fa9a213@prevas.dk>
Message-ID: <e5c1443b-1582-51b8-f863-4eab6e9d1475@prevas.dk>
Date:   Sat, 5 Dec 2020 22:50:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <4d35ef11-b1eb-c450-2937-94e20fa9a213@prevas.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AS8PR04CA0093.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::8) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AS8PR04CA0093.eurprd04.prod.outlook.com (2603:10a6:20b:31e::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Sat, 5 Dec 2020 21:50:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bc32f06-3934-4807-0b94-08d89967c777
X-MS-TrafficTypeDiagnostic: AM0PR10MB2866:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2866FE8F0D9D2E97CDA37D0E93F00@AM0PR10MB2866.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QHfaZ+HfNBg21ZHJu/yPUvJXONMOQhOrV+JKX8Sc3c9TbktjeSA/KkgdkafZ28iGeAdLNydPfIROshuOZDcZ4+tyJa6u30rIdS2yERMSAGsU8moYLijYiZ0jjCXmilJtfVG88Hm/iOuPKXHPynBnQy2ET7T1svylVakrsfWodX2J5un2SL3cx66tM7Wp4ul3oAUDl0amEyklURRLuhkikRLK/WqrBV2OFcEGd7fIc2sAupqaWh6mrZqj9QNiRDYHSxA74Vx36vpmsi1S3QBtdIF+nQ1g63rsxliwt4M78gHC4PyTzugfIBljyJXF86aUFgOvsFQYFqaKHmCdI5GgSTZgauexkYM0wJ5miau5FIsdOqDQZ3LeWHhIC7aEIe+lKNDmvd/SziY8v4bQR2x4M5QezzjTKfPJ1G7zDtfG3s8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(136003)(396003)(376002)(346002)(366004)(31696002)(6916009)(8936002)(4326008)(36756003)(558084003)(6486002)(8676002)(83380400001)(8976002)(2906002)(478600001)(956004)(86362001)(16526019)(186003)(66476007)(66946007)(31686004)(66556008)(5660300002)(44832011)(54906003)(316002)(52116002)(2616005)(16576012)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?mrsy9dQ+9qRjEtr6SzOCwkRFIL+dMshjBY8+ERJeVypc8G5a0pkUaeJL?=
 =?Windows-1252?Q?150cNmfyTCPNoYS0MxMt7IIPoc8wMn4R+jErqe3Cr8msdm/EM9gnnDwr?=
 =?Windows-1252?Q?d+Xuakkw+JfgBoZZtehD0vIcptM2TqVYpJGdoine34xxl7levE2D1sgz?=
 =?Windows-1252?Q?n8LBiakEsemDtMx1m929jffMQmTJM14zhJ5AF0Lyk0DxSGb5qC3TWUPY?=
 =?Windows-1252?Q?y7t+mADSX2iGxHxgiO5xYtRcjgI8q2KnIvW+NBPMToQy0GnSX2iudF3q?=
 =?Windows-1252?Q?q0NIGwDP+f368Op9Z+TGZ93wWQLqs2TBd1sTtVfUg/FCh+W4UL0zZXhD?=
 =?Windows-1252?Q?xTAajVnB6QqTk7BMm7d9cYtPV4kosh2gNPcMz+qGkyeTRkPpA13KkBu9?=
 =?Windows-1252?Q?55ZoprBHVe3Sj/M2bUvZwOg/3TYo2Z7hP53ZT8YbvmYMw6Ud5a4Z6Yup?=
 =?Windows-1252?Q?gorXodF2C3tkWWJhsvumNAfaq6AX3dKu1kFIu4PDxI0R14Td45qhrGRR?=
 =?Windows-1252?Q?McjCqEbYthNKFITZjfTvVy2OlBFpwYA2jvggwDg6VBe9C5sHx8S53sXm?=
 =?Windows-1252?Q?/SZHfRxxS83FM9Ke6xQGWB78NsAgX5y41hJXVGUayiB4MIr9qkgOIIOX?=
 =?Windows-1252?Q?JkFf1N+cvCkTPHjNiD/ujuJws/QUCMZvTJHtAiSr8xhzLtIaH0xsLxKj?=
 =?Windows-1252?Q?9R8Uaz34Yem7WlB5AqocjmpDI6wKg+VcjYkADxkwPeRgKZXbr5HKz2hF?=
 =?Windows-1252?Q?fo6vJxP1oWAB69jQXkBKtK1A4rP3IjB4qskMcndyF/qVYAOFyqPsNK0j?=
 =?Windows-1252?Q?53ILvLe1xxLpFKdKfNKvhBaiwUhzloM4TVFLQAwQIZc2w9D6nZe0aT1r?=
 =?Windows-1252?Q?JnnP1D6LGQCQdWDut0iW5bJa6oJY9Kbh4LwtN1Gxy0uj96ip4vn03zPc?=
 =?Windows-1252?Q?BuxziIzyFGihQNAzMGM+ATi+wsL2Tr99KezjlYWSqgNymGvYP9CF8FKw?=
 =?Windows-1252?Q?Jn5vZM98akBZdADsgi1YIP0uh4I9894Hfh636bsZPJZTjb+6I3YMFSJM?=
 =?Windows-1252?Q?oDJ+B1rkVDvQm2si?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc32f06-3934-4807-0b94-08d89967c777
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 21:50:28.2043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRQ+ADIM3hmiECPJfrPJjnaAdsn3heew/c7OmG15udyJNo8cDbKY4W4oJxJSpwl7piK88KTlNXnVfukFNV00PPQUTlGuXxo0ShdMuDl9KTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2866
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> I only noticed because I needed to add a free of the ug_info in a later
> patch.

Where, ironically, I add a use-after-free bug by freeing ug_info before
the ucc_geth_memclean() call.

:facepalm:

