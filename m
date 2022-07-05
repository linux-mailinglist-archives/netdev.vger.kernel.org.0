Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B6B566447
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiGEHgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiGEHgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:36:23 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2121.outbound.protection.outlook.com [40.107.96.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A02E12A9D
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:36:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1e+aHx6s9EfjsfHJoc4XJx/YIOvJ+zqlwQ0zEon2zvP5YsjyxWMsdgNKN7VCFjY1EzKAHocmcBq5/afrPqRxeDXcRsBZ6vbKS683HdlzqddE6XKXGa4bMZCN1Di7re2PAY9aG6eiBqAE4q/POflLLHxUffLY1r/ZkFPtcZTlOrkNMvvvul55xXy3HP5mBW6VJmUMLyNK0RwT3lwqgsDRHQu6KYCh4yatkLWtu4UlNqpxRcQc6akd/mtnK0QiK2kPJK3Oacc2F6bqv/s1eHRuFG1b4XHM692aT2N24RztX29NLSRpcXpNwfO0WGxRXGnfATAFEBQKviNFFmTvU5fNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4COb7N+FjiPGdY93D1+ix2R2fIcoYsrEE6F8ijQCyMo=;
 b=DlyiJZ8nJx8Pjl92XB3QJ6of9dydHaBEjD36KI5fn7OCWc0jFBZWfr/Q5uWh41K7l9AGKxc93QjRjra8tQhK+QCDDLDvaSjeFspeonwRWUzCeP5ACNc59S7makgoThLSagvaP6MavNeKPF6Xf16zAlseoTWrEcaDBKAoj5yzP1sYnB6LVgwjM0gzdynzinaQoHsOzkRZ2sGqvof/yKnH72S6qXaEcw0sdSyreisTIryHZE5l1wGeDbpBin7oyK1T/cCUC9e6+k7+TKtEwV9MCp9wiWVxWrgIly8THfsno/dYsfELsUZL6GtLraC7HSgZRDyESReIFhDtBaD63/Kc5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4COb7N+FjiPGdY93D1+ix2R2fIcoYsrEE6F8ijQCyMo=;
 b=ee0r2YCSwut1qpyJ+1Rt9WGD5hcQwNrV2hmRslRCKIKaKReNH9wCqv4rMzQ1gRfEW+nRJq/SC4m/myWnYoEoR3BAoUfO6gPyBiRctTU9Xu3gp/dH5ixqIcHlAUVusR3oRaVR+52EwHOnyRIM/f3MpJh+rGTnGMNTn1kszJl5pyE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5312.namprd13.prod.outlook.com (2603:10b6:806:20b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.8; Tue, 5 Jul
 2022 07:36:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.013; Tue, 5 Jul 2022
 07:36:22 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 0/2] nfp: enable TSO by default
Date:   Tue,  5 Jul 2022 08:36:02 +0100
Message-Id: <20220705073604.697491-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0033.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0054dec3-aa34-4a2d-6c4b-08da5e590ea3
X-MS-TrafficTypeDiagnostic: SN4PR13MB5312:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yar7xNW8BwzEwIM2v5KsyFOCAh6HK/HfhwX2JXb0wtgojsRQVS4QpWJSIg7atfxryJFJok0GfYOKXcYsDsFGlFEeOUvdtW+XBdt2MIVF9J3MtDmd3EMH/Z45zu3VuzPnO//syINCCH4D1HUEUhn0cm/K7teOpI11mPr7v1mWKFEDRZfS29fGnFnWwSvkqtVa62S3VQhGffx9y3Va+YhmwGQ9EgGCmdweqlyudFgkXhr4ybff4Fm+CBEOe4DZp9SHwf6dFzmdsAYJA6aO6Oki6PvvOZU6/JwHdGw2SWicApMj/cgJgIGzG4TZ7ydk8Mu9ToxWexwIaJ//5/4QoD5pvwagDHXI4wCES/VaKwaUweL9AuIysmUxlcK6QFcqPlRk9hObdWvubyozF4PWMszZXbGRIfhF64SIwm/uD9KJ1dLBI/RU/hDOOubTgFJpLZsQ4POIHMk2tXWu9H8mUy1UVtMRac8M4zynOxQi/9gWOrpFtokvPBOiqMMJI1R1b4HNT6UysxEwdl07pUdJKOhTNg7j/vks3LIbXboYbOwqDmg8BPH0Qz+ULwXJKjCULCc752eTQWDNa2BQti7txNc0kJFyGXp9bkYGSlUdOTnG0sxnZ/FRZhMYAV0V2vE4gtRsAThFx5y6IQXZAx+Nr/TGDS3aN+OsBopNH326CbwxMORRYTKbquEfYUXbSClGUcSqIRIIXjih+r9PawM01mtGCpARL5oUuyzPgnBIKcDaCMMpaWMHLpOjvcYIhMMgGdk/tgne5R2iNMFYan0hgweQE50tD4zl5/UYlGapXuVW0k6SfqLxmYXEzRvjvgp/rG72PwwuI0YOEOY0Ec6KUR8dAcK/ByEoXGxIHVVJdT04lTc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(110136005)(4744005)(83380400001)(44832011)(6486002)(2906002)(86362001)(478600001)(52116002)(1076003)(107886003)(2616005)(186003)(6506007)(36756003)(26005)(38100700002)(66476007)(66556008)(66946007)(38350700002)(6512007)(4326008)(8676002)(316002)(6666004)(8936002)(41300700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V+wb00ihtcA1OeNAL9GMbWlRr3tkDr2VpnTUXpfhWYi6OBlc+EfkhsgHU+ck?=
 =?us-ascii?Q?q8Snf9dwQ99hgfNItRn6jPMyz5mYVMFVQlCcJ/yipU/XkGBNuhCf5XahTKaQ?=
 =?us-ascii?Q?X9307cH1ra5mk180AnS27837PJBEaUYkzY+yhGZ00KUOhgzBy635TB44uO/4?=
 =?us-ascii?Q?ni4J1vSqVOeP3n7U3M4p9pBAW/AGnGNB4jBgHsGfxbHuRJyrupo6hrPj5xoz?=
 =?us-ascii?Q?vJCNd6YNbwwep0dil1t4cNPe9B5S7sOgz/q/wYIeCfsxB3/OYZ+As1Ws8VxP?=
 =?us-ascii?Q?i8hA0oeYmJGhU7Yi384u0BAywzkjffo4c9lXwjVOf/swwv6EHL7+Bd6ofuIh?=
 =?us-ascii?Q?EohPVU+VWyhHZY+/za8jISzAF6nxbGtqu7MW7ECm2kn+m3KVZNu46kLn5Fhn?=
 =?us-ascii?Q?22qzVdeVng1kaxUI9pvvGr07Oz6MerBZNdb/FOMsc3SJ6U8teb9OuBS/Z9L4?=
 =?us-ascii?Q?ZjnOnMEJO4jnwoXOLNB1MYYVgWiLStfZolRqZAqvH+A5ubhm4lmOeheycxsa?=
 =?us-ascii?Q?nX0Goe7r0+xXGg9AZC/b+iLbWZV3f0fWLEWhqERhA3Vb3rvNeQngynQAL4hJ?=
 =?us-ascii?Q?+rgdjPJY9Ztfnh8itmxMCNT9w1aVA8OdnB5eGPnMViucZBt+t4K1ZgCaQiMm?=
 =?us-ascii?Q?qCZVlDVCDky7lJNUhqCW1DeagtLVC6c9FEecnnPom0CoyqGtcjkIq26q3+da?=
 =?us-ascii?Q?ymG5Bb2Wd9Jj04AkBcPJuUZ2E9CpzyjtTzA13tDlw4x9J5Fw38zSwTEAFLyK?=
 =?us-ascii?Q?hSg1UMq15r+qoDcEJlpR9ppFJ62jLJM4QoM9HNogtZzZtUEkgH36/ohymVQI?=
 =?us-ascii?Q?oyj574GwD7dkar/aHzAvpw2c0348W2gqcYqRmC69XbffWIU/HLd00e4tG2Wa?=
 =?us-ascii?Q?sUJfPcMG/NiKLZi7Q9sxGNgKO3HWTzYNx0pfMuO+Ots5elPjHRa/xOj699x/?=
 =?us-ascii?Q?NlLzenMAcI/GZWRXY1TcUIyVnZ5KV20PwdQKcrSkvKTs8EvlACMSRisn9i6B?=
 =?us-ascii?Q?dQf3ciVS03wTziQSGHqWpIRqYo54jEQOEu62Sv1dlLHhhDIvDMhiJ26pmIM3?=
 =?us-ascii?Q?5V48KPLB2SYXjPZRQz6OmeptYx9+FlWdmBxlPy2npaIZf+Dbvd+QsHUtIyV7?=
 =?us-ascii?Q?qLUWiTghdZ4Pc38hgR6F7bPWoOc+2WjxcOOOEtllcsKnYThHwQqWAmV5Dhxt?=
 =?us-ascii?Q?x+a5EQscVkorFMU6a41z0ElzBq6bWDGRbXb5voFoPAQ6Y+OREGtu5iGN/ICd?=
 =?us-ascii?Q?/aLNrwdOLjORvYMJVtQVtx0kefjsvoxFwSjATXEFGGRMwnUrfgQV4UtQOWby?=
 =?us-ascii?Q?DgRqJ80NR3tHl8CP5nr/wVfhim3mXYeD8gVO/Ai0Angi+ViPLY3dzUxuZZW3?=
 =?us-ascii?Q?erQST47J5MHbhRXXF/b5qRvvyTbFXb3q0DbjZSRRrmBvvU12e7yB2Wm9Y7kC?=
 =?us-ascii?Q?MNBE9dM8AOkT3+h+jg2ElYSGG16Cn7lDgqK7WQ+i/Tv6eqJbXblafY04Vzec?=
 =?us-ascii?Q?tlNtRMFrTTwwwH/KZ0+3H67yIkqncMkbwKGFmAyi5Ed/i1kA/0BvOFRNTniO?=
 =?us-ascii?Q?xfTgVWEY/82KWfbpIzsiM2ablpr1G/xrCLeX7F+56yeQtBIC9fHiANM3Wev6?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0054dec3-aa34-4a2d-6c4b-08da5e590ea3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 07:36:21.9860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDQY1pxU6+FQT8Dq9s1W2SNIMB2GmTfswds8ZOz4SKFN26+N9QVwBnVx+9zGZoUxFypcxJX8AJ8kum4Tsioygfhk1WwSMvuimOZNSwSrBug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5312
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series enables TSO by default on all NICs supported by the NFP
driver.

Simon Horman (1):
  nfp: enable TSO by default for nfp netdev

Yinjun Zhang (1):
  nfp: allow TSO packets with metadata prepended in NFDK path

 drivers/net/ethernet/netronome/nfp/nfdk/dp.c    | 17 -----------------
 .../net/ethernet/netronome/nfp/nfp_net_common.c |  7 +++----
 .../net/ethernet/netronome/nfp/nfp_net_repr.c   |  5 ++---
 3 files changed, 5 insertions(+), 24 deletions(-)

-- 
2.30.2

