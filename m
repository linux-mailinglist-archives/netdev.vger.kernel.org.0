Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34ED6C6B13
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjCWOdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCWOdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:33:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2125.outbound.protection.outlook.com [40.107.237.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98148269F;
        Thu, 23 Mar 2023 07:33:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2iO26wtsVd27aF3dhftGju/P9qraWaZ7TSvjcyY9wgGiexN774JOmrGIv2jJzq7anq7NU+PuOCD34/Evus9N6xqARgV28129MNPHHjb/O6LFBIyJ7seJ4EIQxHs/jThL+YJ9rfL/+8Fzun05T5tWxy0nVWZvin5TsrQp66mjsg2Zy/E+xeeQ0BCFOq7Tf0qkme/E10i86OUcnInVmE8+Zp0tzakGd6IU/GSkeGpQRMUKo0RBq5PL7qnBY29Sg+aJ3TusLRmMd518ePJ617ARoKAHxxzkVzAs7VXFWqvZoA+at2eTfsNuh22thQaUeHFhLWgkMaWXQ1A8Qf3Aai/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmVaAWMaoZBvW4rqLYYG+ScWZUYGGwp/Ryyaj0ag5p0=;
 b=MqZSOO9SdSI7qH1w6n7d4kdux2E3cgZrTpHvOnUt7y+uDgA4tsZX0S9neR0Cbq7/j/I5+At1TiJmGwVzp/TdzSWS8UFkblLKVWyFqRqDU9chK0CIpBPhswRCME/cZHo53RoYQkqaAhNl4YptuJSLoNniA/P5COopq4V80uoSFy3A77Y/J5dtMfpkyUDe2PewHUHEx4rBPsjaYmVjZHvzey1wnyuVYhC+73SjjSCRk3SXfMBuDCDm1F7zcjnHLh15xNOZ6F4iY+HaZOyDM7YPx7mOrffs+4aBcUtm15SIWNWlPBdieM4wLkMop5dSfVLb60ED5yuIArysgdXVb9z6LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmVaAWMaoZBvW4rqLYYG+ScWZUYGGwp/Ryyaj0ag5p0=;
 b=UZASLY3AKyT0p4WBDtNIqZFZM/boVqdJsHphVBBPoiwiF1LjTphoW2DkmI3wQx8RVcfWM2Hw3yjSOzpmi0T3F4x1pfDV8d6OK5P48V+b8NeJCXBIPQ5CC+sms+RAmUkqMkF51ZOcCyS06INsG+AlBdZzmKsI08IlyrhRxfElSBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4871.namprd13.prod.outlook.com (2603:10b6:303:fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 14:33:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 14:33:45 +0000
Date:   Thu, 23 Mar 2023 15:33:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/1] netfilter: ctnetlink: Support offloaded
 conntrack entry deletion
Message-ID: <ZBxjQjfLRwayvVKm@corigine.com>
References: <1679470532-163226-1-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1679470532-163226-1-git-send-email-paulb@nvidia.com>
X-ClientProxiedBy: AM0PR02CA0156.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4871:EE_
X-MS-Office365-Filtering-Correlation-Id: 77015f8b-ec5d-45c4-678d-08db2bab9b68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HRo5TIqTMwaROKS4+nH5k68kqkpmB2h8AdfzzWtWo17EstQfueVn5+V7UxjFWChl4PqCkf+QRJhQndMjefdN+SO77PHoRjVqn7E3htuXTnb7h+qHLTMmRsM1yA6x/Cc+uyZ9OUvM0M5BTpt8NshK44LsIGhciqwnXG4skVuCLSS2cQC6yqAw+9DOvSVL+miEkdBrDyHGfXvIZRlb97gW8Vtbdv4J2zuw8iQJ1J8dlV7jaXuVbAs85dXgc7rCcSnVNrJJt9lL6/e9dVBykai9HKr+XOC9Z4Ze8kW7FACuIqQy74A79TnCt2eoq16Mt9zx4EFc/iIMm/ooktCILvD942jfCNelXPO/mcYzFnSBBqPdf6WKkQivME2MKfDkRagV2aKLiyUNf8qyArKN6697od5elkKFso6XomWgP4WQyt7tu+5C9vtpmlP7QXZ9aDkbWtsEkCs662B6eLuJrWGB6TGSFY/UolEZirPR2FGcMRHnT10psi3JNYHFdnzoZOuvZGhuptvE1QkjKTqj1MqLVaQ2fJG63VKGqXmwrmywQlBaopv4Myu1wToduixypMt8MFgXT5wTC8sGxcVphJSmd6EoEihnMS/iyMijjKoWZatQc3wWOUWzKCSzmrFbfTZXoO82fd9Z2o3mkSHS7qvMIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(376002)(396003)(39840400004)(346002)(451199018)(36756003)(4326008)(86362001)(8676002)(6916009)(66946007)(66476007)(66556008)(8936002)(41300700001)(478600001)(6486002)(316002)(54906003)(44832011)(2906002)(5660300002)(4744005)(7416002)(38100700002)(6512007)(6506007)(6666004)(83380400001)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QzRTNLzG/fMBrftGcuS2/BWeORQLzlONKfuBcBBBJAQ9Hj3h6FgzGi5cnxUT?=
 =?us-ascii?Q?Bb4B7aM5snNHm1OAtlZ+0cehidE8/+W02F2pM/zloAPy59GS31DtOCxC6BUR?=
 =?us-ascii?Q?AxHjnj6zK/cjtwpECOPGzmD3rrbzhOLKWqf3/wdwyOepjtR31AuOujxXN+Up?=
 =?us-ascii?Q?wOG+5fxDWkgV0XUvBUKTlcWq4d9JZB/7pn78f62tpu5Rs5GgjcdyxN76nZ8Z?=
 =?us-ascii?Q?mo5vc4K1oaS8RRAjaw8T0hktUSeyftRlHRQy6iM2wdO5VDCuyT/9CCvD4MXW?=
 =?us-ascii?Q?1R6HUGd1MpBFdGgy10d5PDjDee3y+GWbfeDnRi1dwFF84xT8D4K2E1ND/7LK?=
 =?us-ascii?Q?1nC17t7saD6r1opjhwXKPpigcCy0KP9EYy6H7xOMxfTAyXmtEOPHb3tSM5kC?=
 =?us-ascii?Q?rjFEIQo4rHBvD8/kswADim0hZssBcoMJO1uxu3hzDwN7G1ibkscDqUQehjSh?=
 =?us-ascii?Q?JWDuMxScoWbzkEzXAIaTzTaSgEClMtjT6V1Gk5DRnfwhrP1SHA9vZJ4+0/6S?=
 =?us-ascii?Q?wPylvZqdpYOMxvMokomEmE9FUmQ5/nEO5zF1H2jB3g4UPpInZOgsOX+gWib2?=
 =?us-ascii?Q?Ru/TkgM2J3AwFBPX9NdIfVkpx2XtNuTdFm2i5oe5JZJxF8AYjEOgVGMcDT2n?=
 =?us-ascii?Q?jcbi4L65/L7WF7/MPPlhV9fbAOup9ki3bCQeby/D7174liMbxS4awAmxXKGe?=
 =?us-ascii?Q?KOOAVxgflcDRnxlwXgN5jmU59zr9k0SPz0k4132Qf7ImpzIROuR5G9BskaH3?=
 =?us-ascii?Q?3pczPDpsCNQsFhNLarXcTq3twrLNXbqyWR3R9I/nbTkwK8YWOS4NrVABg5Ge?=
 =?us-ascii?Q?j1LzOxsaqW1bUt8U/ePvKNwjiyCGdaiSxnOW73gHbQU69PtcNmbMYkH/87vE?=
 =?us-ascii?Q?d/L6PAhl7TQvU4UEeGlWAX/4Y+P6/WxiKrhUpHiG2ZvqSK4kzwhdjsYfQzkX?=
 =?us-ascii?Q?zq+yQ3DlSPTvpS1uvgQErYCO2Ty5d60XBKqXH6glxp9ejmHkZA6gJJ+OjtzZ?=
 =?us-ascii?Q?ELJ+sjS+z+Dnw7jxh2MaPbwQR/GyggoTdqKiDCxkGdJQIwzajW1n1qUwDWQj?=
 =?us-ascii?Q?j30x0Kw1UqguCGo/HBbCYFipLM5A3O1CNqjN+z4MnANHjsGDBTNsDjOMj/8F?=
 =?us-ascii?Q?aOgH3deDJNQd6w2QkeVU/jZ2KNQNzWUoD81q4LJY3vbsjGad8S4ZBgWJFuRv?=
 =?us-ascii?Q?F8+syzwCOPNdg2nYejBRUlCcCN2nYyoHLS1Nmt5vXfDbfdEZuHwWoEfBeNab?=
 =?us-ascii?Q?ct+u30lLJgVDwFOWOCyv7dXfBHT7KWBAzc2U9tYbKun8295hC7z8esbGDsXG?=
 =?us-ascii?Q?/IhrsIJicNWBCwGyL/z337H9flFfpomAQwZp01iWYdbD7QJUR2xAOVdyZVLa?=
 =?us-ascii?Q?om8QZR5j9rKMv7Vdv9FD440hzeBUG10zVg/RdxxvikWiZXOnxY/5zCc9/s9Y?=
 =?us-ascii?Q?TeFRG1ODBQ+jNPor/3GApWyuYkgi7l1aI9kUtadL3zdTFzr86fDagV5C/MGG?=
 =?us-ascii?Q?BB9LJxyv8jiI4PPW9Us1hpiUxlGdH5dyvAnOyVwkimyKNavDPsJ5rQhGCzmX?=
 =?us-ascii?Q?aQ7rxx3+eJS0SeKdEt7nIQwasUlkXOTlnp4XWwQtWjvKuFCdC+sCe72M17Td?=
 =?us-ascii?Q?mfYPQoDXpEGlDD5QMh8/eqjFVK9ejOtWSd8bqaZD9LRqH+HGFUpMe2BS7QJp?=
 =?us-ascii?Q?3S1qyQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77015f8b-ec5d-45c4-678d-08db2bab9b68
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 14:33:45.2321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TM5KwQQvoRDHzw34Iur8UeuS9ThwDXw1fghxs+mtN/nfVBWwS82r7V1v8KgTadaHTOojlj7F6/fIi9XcIIpTDZ/fkdkxNPmWY/sEjS62w6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4871
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 09:35:32AM +0200, Paul Blakey wrote:
> Currently, offloaded conntrack entries (flows) can only be deleted
> after they are removed from offload, which is either by timeout,
> tcp state change or tc ct rule deletion. This can cause issues for
> users wishing to manually delete or flush existing entries.
> 
> Support deletion of offloaded conntrack entries.
> 
> Example usage:
>  # Delete all offloaded (and non offloaded) conntrack entries
>  # whose source address is 1.2.3.4
>  $ conntrack -D -s 1.2.3.4
>  # Delete all entries
>  $ conntrack -F
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

