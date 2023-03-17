Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EEB6BEE61
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCQQdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjCQQdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:33:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2106.outbound.protection.outlook.com [40.107.220.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD522CC40
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:33:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPoLtSukS79vNwkVBUpfCCy04QmTrEndJQIf8Dm3ay+eFDc8cmn/h67PGwzakkj/ummNXIckhjecq3ov0FaXGaz1lpb8B6RDeiB1VNU+X1Mz7lfUr0uT4tPWUdY27Me10XnBcyMz8UDowiywT/IfSU7CdVeWiOWSqt2SUOUyztCCWFSX79NKQ7iJKEi/i0mm5IPcOUUhNCn+sGDQ+iMcDy0iSv/ecgAf9SsO96kXE/uX+oXyEy+1QWBLnBWbtGz2NGvIhVM+3e33LU1Vz5Sd5HxrrClRf5feXsSiFO8lO3XpBx0gcVO98HWUAaqn1rSIw/OCCwxVpC+SaEDpyYVMvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVhz3GBEGqgp7zYx4Q1n+BFllW0kYCcrTDHErUVIMi4=;
 b=a4v3fdV1+L5ceaEI6rEUvE4ta8LMxh9Cq26mtgBSPChJktIPyZql41p6YBFh8XhXdayWcM+rc9k8CdqL+T2m2BTld0AO6u1+EdTnYTMqkqe8K79bJ3PA6ZkYCqxRdCNYpSIPbA7FYtjqUpEogo2q66OacRm4BzbCw5xZO0FL3TSOaBKm2ZmYI/pRxbsjP90nQEcZCk6GuV4bdfKyPTOTNrsF/hX2p6gZWJ121DrMI9KMwdIx+lDLX+btFmVlYlgTI1g46hZ/WrW6mKK29clNhp0m+sbvIEXGatd69xiBqIHmTCJl/bu4jgzzO9SdP9N6RdLglcAZOQt1yeNiHmLy/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVhz3GBEGqgp7zYx4Q1n+BFllW0kYCcrTDHErUVIMi4=;
 b=BxH9AfGpN9Okkynab/Tr4+w8Y6V8ClBMHTgBF25Xx/95CF1I8P0NbWurI89GBS6Wqvl4DRkGoeSiYhdhqpcnQSBiVSvvNP1s9Ag28Bmta2p/84UgjySCbPWweEeMTI7drunlA4cZJGgCe5BY+MtEemHzoUAigDTQLSJsc/umCdE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4954.namprd13.prod.outlook.com (2603:10b6:510:74::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:33:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:33:10 +0000
Date:   Fri, 17 Mar 2023 17:33:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 01/10] udp: preserve const qualifier in udp_sk()
Message-ID: <ZBSWP3dpaJc6u+W2@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-2-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-2-edumazet@google.com>
X-ClientProxiedBy: AM0PR01CA0162.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4954:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e8acba-586b-4afe-8589-08db27054bd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/s9OIuW726d34hxwJCxR6TscjvF2SndqFROq5zty0InxqH5e/CCMdS5RMTGdViNn9q8t/P4JhrcjH6fKZ5oRabMqXnqkYiyc5uVyDuI+KcxyXN2pHI5mNogPnfjVvd/V9M1323VRTLTTnNYEehmjjKy27X9RsiV5Ma5Q8XyLtVGUh6lVpKeW8vUXDe+36kLBQJp2tSfw1GlKKvVA6qkQ2f+As05JoLPDYlqgc6tx4fNg/WTI1FdS+6pBg0B8P+sQmxansaw7lNeaj87Q9906lPtblZAefCY9+Z/7F5RKnZslyePLTuyt1DHkX5Lzm1sX/7ilsTZPsBGFnbqlVz7rQLIuL8CtWrbJe56ZxZbCT2eyF4GOcMj1jWF+pJAzHkE6iiqNNa9tqdLQTPHlPUtgmBE3Zz/cUHh9Tjy6AUKILgxxfWJxx7iMaH2EdCpfTR1zFSURiLRjPhMxPraHin1Yz4Y/puI1ssaatDi+e+h46aghsDKrBxrdoDbQoD0ztLj2UaxAoZSvfSB24h1emoOdiXtaFU/5XkGsau35hnFmsIH4ILQIxEbuzdh6Offl2odlFfH7+Tdymk1X7j+pq34zqFLY86ZWeSBJBjqXpJMbKKLQ3zZtz9oRXiEzZFNtc9bcCpeJ2JVseTrAECpfRhzJrfnCE2hzED19cBJuSh4pIGea2crDsrNatquUHFhMUx+UZtYkmSVejrlK/deQ2LNeVW90tTzDaddcSdoRENk3buZ303lMQx02EVHSvw0MqUt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(346002)(136003)(366004)(376002)(451199018)(36756003)(38100700002)(86362001)(44832011)(4744005)(8936002)(2906002)(5660300002)(6486002)(41300700001)(316002)(4326008)(478600001)(6916009)(8676002)(66476007)(66946007)(66556008)(6506007)(186003)(6666004)(6512007)(2616005)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kMy9zl5lmy3kFgdkbMWt8H+9pid3OH0+RkBA3/aL+ly7hEqXUFKWSA9yecB+?=
 =?us-ascii?Q?S++NqECi/u4ZTdA6RlTrZz6tTsk3X9L8X5frpKOWz14rkTUuc2PEa1KXrSsd?=
 =?us-ascii?Q?mL1Htc1Cs6nkFybo8lT8o/TIaQXTw0cxNz5vuqIcB/WesNvInND0Gdur1Voc?=
 =?us-ascii?Q?tpt+1l7ezstu5ub428bJ6/5EJSloPzfUhTCRkOz+d5//2Riebo1O80+ED6a4?=
 =?us-ascii?Q?r+bZLgpzgj7sbzjTO6hDYg9yicH4KtRsfiXMb0DxVp2sdzV84yd/xTl7l3jr?=
 =?us-ascii?Q?V8yKQ4/mqkVYuyLd9LLlWLF1KBsH9E+enDhysHkGCtDJVNSq97Jta7jBQROt?=
 =?us-ascii?Q?7p8uVIdbT2m5lBirMD8TyJP8q+9jz84EJGBBhLwE1VbPOJMDzsSnhWyZohgt?=
 =?us-ascii?Q?CZPlFg70/nku/WaLnOPE6RgZH4hcu8t2d8vKQBGXC2jyI3T5EsovL3UXcJTm?=
 =?us-ascii?Q?qQJ7CYf61MHnXLfLhvMPAM6sEFmFj8AMyKQtfVxIhY/h2p2UIv09k7rW0LIp?=
 =?us-ascii?Q?nRtha2h8vJfino+KeKSl1sipbI97aiZJ3IrUy8cKFmWJMJIekm3qaoMIe8Wz?=
 =?us-ascii?Q?co67Fx1Pry4GZGAYj/WFHKJQEY9/y2SZrMt93lwOWCdLqAbu+jlRqDEcTjmv?=
 =?us-ascii?Q?tLvyeUBFb5vFnVAWxAUdEal1fbMB9s+iPv07IMzIb9i5JR1QZdrGBHSJWTIx?=
 =?us-ascii?Q?fGC87QRLLvpPi5idZFMIvRQy5+w/FN++i450A6yibTQvmRdF/C/QTchx4sBG?=
 =?us-ascii?Q?PB6tOifUFrb8YdWRoR+8JGMJZ+aMxdAqP0bk7rHyUj+yZMOqEvASIaGry92L?=
 =?us-ascii?Q?JfNnHmp+pSOgcbNygRtmSyC9VRCX0A86d2/R70NRKCJ5sXvPjdk0kqphDytt?=
 =?us-ascii?Q?3GqJa8lDM5t/k4pH1OvduZRSBC0AEE18eJ5iXwYqfAVgqGan5x89ysdGt4Mn?=
 =?us-ascii?Q?qU5ybgiQdcp0cVU58VYEUXEIRuO99BqgQ5EDBQ7x32woWzciizdTZYcinekI?=
 =?us-ascii?Q?Yn7DyJKwF6t/heHj2NjYZB3/bsIj4yNlUZIn3tVYY9oxPPLATHrBPLA0d0J3?=
 =?us-ascii?Q?M0nABVg0+1pvAAmOEVlIoS1VIDWl2Mzx4GPV+denJKUhsQBB3vRqvl83gruR?=
 =?us-ascii?Q?3ZptnX7LViHGHNn5bYTi+KcEMHnwNzQ/ks5E6u3bgjGy21Wd9sk8U+dmkSnz?=
 =?us-ascii?Q?a+7kXk1FnZ+bRTWVRG9gmvzqG/U6jdOLlmazhKOLTsibAPFWADH1Fc9NcJ2p?=
 =?us-ascii?Q?f2moP3eWcaLN7NfbJLA1Lot4BzeF7Chqc+T2R9TdgUx9Rpy4CEgx8WGlzixc?=
 =?us-ascii?Q?6XJPIVJcsTmlgCzM+mm16jlHLkg+/C7pa8ChvjebxAw8Vh99g17c9NWvM1O0?=
 =?us-ascii?Q?/vkwtWOsSh4MywrAqaDGDHBMaPHN+bX0kn6Fpq+I5PO5hod1S61xmaP1rycm?=
 =?us-ascii?Q?WND2ONyNuK4c4o/MUBK4zband0hXtrKIBPT8VrNWt0rTZzzvTcxyVozNO34e?=
 =?us-ascii?Q?qdpBK/1+nrsWoF1xBP1onQx6rxA/jpc4j7R5cbAfFFnz3V7M6JKaV48y3EyC?=
 =?us-ascii?Q?kuUAWiRBuRFWCD5hRyXzL/vBfAishxtXrujwaSiUjZqYXmFBMIvRntGSTOpr?=
 =?us-ascii?Q?rqQGdYU+obJ65m61fxkCTlxGHxw2VoJc/4FWB0gtazrYeG7elGMKm9EmpnYy?=
 =?us-ascii?Q?9B54aA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e8acba-586b-4afe-8589-08db27054bd8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:33:10.5576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUYUHuQbwDuoLcXgH1VkCrI91GmlGntX+hCgiFB5NkOg59T5Mbk0AjOl0ocAVjriAL+pEOafp5mqb8OZNRX3am+Tw5Iz+LO8Uvv2Uq8qJj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4954
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:30PM +0000, Eric Dumazet wrote:
> We can change udp_sk() to propagate const qualifier of its argument,
> thanks to container_of_const()
> 
> This should avoid some potential errors caused by accidental
> (const -> not_const) promotion.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
