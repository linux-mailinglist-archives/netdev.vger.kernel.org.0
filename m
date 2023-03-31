Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CE16D26D6
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjCaRjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjCaRjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:39:53 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2090.outbound.protection.outlook.com [40.107.223.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504D422211;
        Fri, 31 Mar 2023 10:39:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1hs7buYxVboezJPJyPk8FGI3BC9E3kMuoQEpS/8iDrfjrSicKTUkbkyirAofBmzMIHuMEjIboAuDHOfL0kPNCfa9as/knYxmw7FASpdTAABwtgmQ6f6nt53p2nP17EFEKj0hIQGOX3Da0nQSefPdC+Q58PjSE/qJv3JwBwZxwKXfWAOpal9c9r4UVZ4zxjjVAmczmiz5A685a89FDXqE1M6z6ub5ocPFPj514z2eLtQt1J9WGYJtnwvoL+Hs67CUHvOscuWevFqsK6u2j3fK5lzWE24GQgU/xmsnWSaHaNUDYRBabeWc/DofmOj+k2+Ngxx3uj33nK5FYvFj1E+Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnxYmF4hGURY3qmTg2RXCxLiKEYXB8qu5iZXvTHy880=;
 b=TmW388UgGUNJM3xVgSubnhMqOryPJAycTWyrKOMVlKA/LH80pPvffLZwKy80axTK0e7AgQCRsLlObvr6M6TAlFdxs0UahxlBfR/y+2rBi4toYJyKZHh57CcXmtnotXVQ1e8ngbrWbSDKOXc79gT3QwiU3YExW3wLdzbGTHjhEn+Kul1TRk62trbdbVN3Ogf5M9RULq5k07kjWsXrp1VSXtpcIF2fH10yEGoVjiyobXxOA/Bjp/9S9JC0aiXNwYpDpeda45ZI8HWQMm+X0qIDYwSLvucpJbIfdVbuO6/ypHFKJM0TQeRX0DzbSozwIAgu3+Em9JkQxmnFoOqPrW4fNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnxYmF4hGURY3qmTg2RXCxLiKEYXB8qu5iZXvTHy880=;
 b=flv1cyGIEWRzosdyXsjDtIYgi2HPV+LMaPqfGAHFu1docLTq8dorHc9xcwWLJjpQ0XgmGkLlCz690/55qqxAlWou9jtAbHmUYO/rFGwtiUF61celn51Z32NqWMoXidNxDvouXOHap7FotWq4F8pr7rYMBQHgBxvZr6w5TG+LSPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB5029.namprd13.prod.outlook.com (2603:10b6:303:d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 17:39:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 17:39:37 +0000
Date:   Fri, 31 Mar 2023 19:39:31 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Fix check for allocation failure in
 comp_irqs_request_pci()
Message-ID: <ZCca09894IqLudkZ@corigine.com>
References: <6652003b-e89c-4011-9e7d-a730a50bcfce@kili.mountain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6652003b-e89c-4011-9e7d-a730a50bcfce@kili.mountain>
X-ClientProxiedBy: AS4P195CA0007.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB5029:EE_
X-MS-Office365-Filtering-Correlation-Id: a1cac688-275c-4c55-7390-08db320ee5a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mcKtqugBo5Jqhk9ozuoX9W1qSepw007IBc425I/q/uPyxsP4bQxf26Vjz/6N/oRZefMLW36lVpqbvZK0leW7xVFVp3efVbtme0Xo9+sEVY6ujnVn2xvDntQBj7J8l2b5bfhF71LBYyoEi3GeHzto4fIhYqdRMMC7Q7QNdNYguSwUPulluFqG31fNm4jnJ0yynDEODLhVzRuL1Rz7O5tjMc20oamNkZxZjGPJWdPT91i4EFak4yQ+r/cObOknn1i7EGuKwM4yasrVJL7UqbiTD9OpeN5wCkSqxPNtSFDxU1qUq86NBU8ib8MfJRC0tzRVeh2mldAmSLmoFDFjwZxBNWrIj/7gUf7bPutkwZ6nGyyTpFhwieTjh50BnP4bTmogbYRJUSdh1I3AOzl4qmN3l3bLAN6XEWzwiMfhHlpnv+zRFV+R4Y/ddLjsrtiX5vhBPdwkdjPf4ykOaAMOzKn1cWIXFvbiWJcO4f1DXY115H6dpU6LCRCCTgPrQS8lG8wgHmpF7mTqsuit0Ohnxji+IqDlb/phrdE5Kh+bPgV/AjDViw1BxvqBLHWkfwAg06wkGZvie7vICp9q58Cw6OPq7ah447c3eb0CCp3vVbSOuaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(136003)(39840400004)(451199021)(36756003)(8676002)(4326008)(6916009)(316002)(66556008)(66476007)(66946007)(54906003)(6486002)(478600001)(41300700001)(8936002)(5660300002)(6512007)(2906002)(7416002)(4744005)(44832011)(86362001)(38100700002)(2616005)(186003)(6506007)(6666004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IO3O0s+79SEOSZTZPJr3WGlBRSq3krblSh/IZgPeoppbPY2xyCab79mGS3fl?=
 =?us-ascii?Q?HCchMeKVS/Y2+j0wdTSeC67e9I9i6f0aiYjk/jo7/7BeadaRCdGu0KYdh+KS?=
 =?us-ascii?Q?CqLQFoNFeib7G9HbaIGh5Sol5sroeFH0DaJqVRL2afBqXyWx1/nclKeIdqrE?=
 =?us-ascii?Q?gDWqLZb46WFP7FVoGsIs2R7RIDMQBsd/Su3RY0WvBnI6DxSJb7HoSjbwFdsy?=
 =?us-ascii?Q?XEXCvkQESInueZ7eCN3eawhUkPvvt6qDxABEQIWYtnoMfz9uAQTvY3RYIK6/?=
 =?us-ascii?Q?X7qicTmyoWT206BbiLGwxxK292N4vD5kPmejJc+3Wq3Y5vq6KEjp+ajdJtMV?=
 =?us-ascii?Q?vg+oMsPSTIGJ4NMlAdiWcC+UveYu2NJc2dGX0MV0KHtoYsSijs1lLQ85Su3t?=
 =?us-ascii?Q?yG9EOZqLaLaCYAIIipwnoDj++EgPmEtISUKZAG+q350pBwpEGI09Wgq/oA0+?=
 =?us-ascii?Q?ne+tyPc6D5HtoZAcv1spGH7B6cQziV36tXErxIUxuoNJ6gnoXzjXy8ickfCX?=
 =?us-ascii?Q?JOuY0h+LIX+Ic5HPYv7HmBcCorDAcsz/zMAv/QpIzkqFy0Yfhaj2bSxOZWn+?=
 =?us-ascii?Q?cbHlUNP0CDyjJnVq0wCy7is16Rf5Jl3W25O4JAdtBc3mleO5Q460WzrcciHz?=
 =?us-ascii?Q?neVESprduQQQjT/Sj/eqTYe72CgQxKQXKT6kiite0wFhAMnq9/VpkdkRyJ+A?=
 =?us-ascii?Q?e6DWDfAs8WmND0DhaKV9KT1D0uIm3GdMtHgiTkv+rInvCoV12ecmey1Lctcy?=
 =?us-ascii?Q?qLPxuN0tS4F2bvyCE1vQKUmASxIxdgFJz3ykHur4DiGlbhuLki1rlyglbxHb?=
 =?us-ascii?Q?pYq6cLFdWxE/8SjRgFnkg0FWalJElgmZOh99hxSumPjUvz4HJcwaZrHBm8nU?=
 =?us-ascii?Q?QaPbFtkQmpOUejlq9K1eP6Cm4FM2tae91fnOesKO39PNxuEsrz+nnR8NPYbG?=
 =?us-ascii?Q?ARoGl2vi6zDjqY0yusH9b5xBIgpBJJWSB7Z5hTHe8B5TC3Qb23qkCtsRU69N?=
 =?us-ascii?Q?uz0DVURjj8mXrzxQSkcU6LQjoN8guf3qT6xC6nxO06j4okgrvHacmb1nHgOn?=
 =?us-ascii?Q?y+0DLxx0lgnBZHXjA6CmIEmegos3i3Uj8CnH35IGKqG9lU8bPHrfHpgpOUSe?=
 =?us-ascii?Q?p9R9dRA5O9SvEc+WHSvlJYn+7MAtlX0az1wV7FRy5vM12GpfnRjIX+vn6qGK?=
 =?us-ascii?Q?ymBqpdDkVa7haHNCdpxUyabhgvX0JbZv6BFtFfNppvpAu4/AYSJZyjKlqsSP?=
 =?us-ascii?Q?EZZ+WVuDCwI4pVWxQ5QKVKkFXx+yjgVBwmtJnm9bjILwRyY5b8q5SQEYkAD9?=
 =?us-ascii?Q?8sh/VGOkxZPjKT/rPKrRJeGD8MUKjEgSKyxozy/Bpk5XPkuTtOvGfWeVyc1B?=
 =?us-ascii?Q?h+4RJ9u5ZK+RcykSm4hqIqfiF3A2R3bl3BQwjheIjb850aluU9uZfn6jqbbg?=
 =?us-ascii?Q?Vd+62+BOomZJJVcx+7kJyg08MZ6hWVTmlgBzhhEBbVjg56WvSE4H9J9e8hTz?=
 =?us-ascii?Q?k0yfH0sYmoQbgYUC3kVQUoFzV0HJ4v72ORHpWN//NTIGRW6sbVydYP17NVwa?=
 =?us-ascii?Q?eq4vQAvSyHqOL8O4EwLPZABlrRkPD4uLOOKoE/cWrqFtSkv6Fmrp9LbQjxw4?=
 =?us-ascii?Q?Xd1Bc4hBkwZl7jLjZcPGms5Gmu3AakYoYxKLklgOqvoatPlobn/5le7vvLxw?=
 =?us-ascii?Q?7nWuIA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1cac688-275c-4c55-7390-08db320ee5a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 17:39:36.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqtAsx2vr6vr6ex1pERCCwHMJPMEPV0lQTBfnDv6A5U6wp16osh3ydpjfOjfrncoqE6HPRqxwXX2FGnuUxER+1693UjxNqyJzPyR3vnrvxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB5029
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:03:47AM +0300, Dan Carpenter wrote:
> This function accidentally dereferences "cpus" instead of returning
> directly.
> 
> Fixes: b48a0f72bc3e ("net/mlx5: Refactor completion irq request/release code")
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

