Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBC76E6248
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjDRMb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjDRMbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:31:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2092.outbound.protection.outlook.com [40.107.244.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4530310249;
        Tue, 18 Apr 2023 05:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMDaLEf6MTRWTnhSCRg1IbQn88NcXwiv3ZTHJYmZz6DMFtnVkVPP2nJFfTwB3czR0cFNKd3oz4eiaTLNdUgsRu5EPtDgpRO6Qb3C9BaeG1eXsMDEwUkC9u/A8w/3C/86zbk52a6vu7n+tiNxTksePnFwRkRCkp/rJG8ymucwzI82NyqVQ89moDH0i13DnpEy85abbNP/Elb2oO8PleHrRRD4yXBRg4ycsv82ssEzOiAbVQ3u0J/EgkSHFInp8+gQ8ifMfJ3Zvtp6TpRKD7spssZYxHxVvtYatjiKQFnv6HdYmzpq6PuW2anlxu2Jm3ZIyXWhAymUAsJTp+33GBZRAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCC8RnZ+lMGWeCg8y8UGUkiNTgpxsynvFUsEsEx8Lqs=;
 b=d55z/ZfhCIBBvXsfVF/qft3r6694jtC0zSOwcUFcFSul7QlazvM8HyE+omPkOuzfborD2dbIdJ6plBgZ8157gucqEEPrlEsKLxOv81Zmqc/xsqeCq2UyaKoFlmI1TYkYC4eEVOlTuBDMTuDIGy+Oaf9RCitwQauofxupdlKd4KOTH/P8Z2MzAhpC4mJ9+8zSzRE5iiwh8thn9JXyQArgApYE5gIQcuLpYIJk90myOJwtzCDw1/Z3nJAxd5GauIwlcwyyxwFde4KsgZ8fBZl/aSYG6DherGIEBq4EmvE8CJRpjzS7PnKUrI9/6HbYwL/7qbZZ+5i1LXid8yxOqFzi1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCC8RnZ+lMGWeCg8y8UGUkiNTgpxsynvFUsEsEx8Lqs=;
 b=ifLH8jxt3nIIECKCq7ZcCiVdj9po8lmPNh6Ex999b3wol9O65ce902cm7vjPiyY3TX1QqoFaw0ctrgLzRb68C+tO1bzhiaY+24qLr3NuNraPwIRFgWgD8ZjUegpslGXzxG16NbQtfRUlx+EG2uTR1VwNxPLA20BJhIT3/mswiQg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3846.namprd13.prod.outlook.com (2603:10b6:610:a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 12:30:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:30:33 +0000
Date:   Tue, 18 Apr 2023 14:30:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/6] crypto: cryptd - Convert hash to use modern
 init_tfm/exit_tfm
Message-ID: <ZD6NY9Ur46I3Ei72@corigine.com>
References: <ZDefxOq6Ax0JeTRH@gondor.apana.org.au>
 <E1pmqNb-00FNVu-SO@formenos.hmeau.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pmqNb-00FNVu-SO@formenos.hmeau.com>
X-ClientProxiedBy: AM0PR02CA0026.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3846:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ee5139-d9eb-4391-2ae4-08db4008b46d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIwm9MH2ixRCulJUhERNYSbG+wQ3N4v28yghXvjOKEOY4wbVX12EdFZ80uclaFkITiMuR7BUDJEOj5cL2Rv7f/0Ox2gz4FOxDyyu8nInfnWJl+bWXQDaQcPEg3IFQJ1EHPPXFbBrXrbO/XdU16d+KvROei7V7Xe5zKmH0/YHPAUC76fBDcXzsiv2/nkR0xDMknfJd97Jes8jvqpxQQm3WKAL+ojA98tfFpSWZbUKoQ+17YQT8SDRPFs9cyu+aFr7Vw9e/g0y/OHP+hGF9Ri2V9KN5LQdT1DWuR7BNl+YExjxVqAEyt4XoXpCltDGmDgqnulfmxzEx0VH2JWB0xv5n+Q7yW7MTP1YHalA1kRO1VJ78sbwvFl0t9f1QY4dx6YbWQ2dXbODUDRMwmG/VFOfTD7JhvT5cjuKiwnTqKHMag4lrnJqD1nH33tzQvy1R0MDHZeU2evEkC+8Gf8tPR/5UfCjpBztIN/oVtUbUKL3nm/X3HxZ3hORrHhjMiWrQNA/0esSAHQluaZ3mTlYGjLVWw/szftiXIjiq7X8RcHKTYEmezdAlthYNwqSYCTpdh/PijC+QcYsciPvh2DEYzVAC4CKwiyvAoNJ/uZ11BfJqLE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(366004)(376002)(396003)(451199021)(36756003)(38100700002)(8936002)(8676002)(44832011)(5660300002)(7416002)(2906002)(4744005)(86362001)(478600001)(6486002)(6666004)(54906003)(186003)(2616005)(6512007)(66946007)(6506007)(66476007)(41300700001)(316002)(6916009)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z9mRvBD6jBTVK8pggHvWlhsVs7P0Aix5VM8XY1/sh6UG6+5Dovq7koQXSDvp?=
 =?us-ascii?Q?dpQX8jIrkY7EnH6S10+lYho2tJOdVztPfvUFAR41JWk2bo/pWVrLDhRGmVc4?=
 =?us-ascii?Q?KbeCCSMelQZ5G6WscWOKnzZ7tP7ejZ+Xl7AViqktWhtsMKz/ZkmJrCeymJ9F?=
 =?us-ascii?Q?oOXqwi6tY7WqIRPZtykyGjfnzBErALj4QLFmSZ02xfEJbD44FNInViptkHeT?=
 =?us-ascii?Q?RskkJQnesq9naxQG5mHZ+ToVGOuZAoqQPFmO6MMZzutGVMkxLKPFI9hT0ij9?=
 =?us-ascii?Q?oYabfECw/Vz6jfA8XYFzXMU4PZpP+gIya5p30kdt5Z2pycA4qxSq8FJeAde4?=
 =?us-ascii?Q?v0EZKK+nUwWQVNgLVB2sqF2+8jA+cTGzOFBQruTwwqwASJ4eqMm2VOkwII/G?=
 =?us-ascii?Q?tR84Vt3i7ANOegpRmhqIF7xPQa0trMx2gFWVfC7VYvwTpbrFrPiUXIA74S5S?=
 =?us-ascii?Q?AAtSpGpOE1zfCfzwCtazBoTmylfl7Z68MpAfubvhpO5dUmSLftLyZQnmM3m5?=
 =?us-ascii?Q?t1MtZXXOz+45AWU4kCUOy5ozA2KaoxG4b+3vigrGuXBT6rb2fkQUoVUicgRx?=
 =?us-ascii?Q?f9Ilrf6vMFA0DwNPgnOCGqwFZKKp1DrwhgGN6+vEjm7eY/aF9jo73hT0H9Ct?=
 =?us-ascii?Q?s1/SFN12JXawcbT44kcHk+L0Kxryoj4DQ0E7Q2kkrmvkUDSmAJa7eUiFGGUT?=
 =?us-ascii?Q?/gfDED6a69kyPhM5w3kPOVrs9wGrcTcQ3CKbROc0JAV9HQ1W99z6QukFxU90?=
 =?us-ascii?Q?0J8meKVIE5DiekIv7cDWlmo1jP+QbvAda3HP6AQsLLz0RwOFXzdTwbnClidt?=
 =?us-ascii?Q?zSlr0UKhQqY3li86vfRJnHpF2mlnV5gZyacIRXikjsx7ZcaHkIrQUDZxiB6y?=
 =?us-ascii?Q?523g9xcEk+0BetzNtEPAO0NGOOqvYuhfxcRT2WMo5FlQhcKLQkTbLAk0TOgp?=
 =?us-ascii?Q?7Zz3lWFmo8JgLkyxRgfK4oR0K7tVTxIP8LfK42V2vtDv5yiUxkVXR+/1Fotw?=
 =?us-ascii?Q?wCqFMWRZplnLgoqr4FMbUT29oamNm+4djCp211fnO36sFyUnlXlYkLrdYxYw?=
 =?us-ascii?Q?hIGS0Q3HkOhlVjx2q4KuHeqaYbHsbbEArYrU0LhAAli4eBcCKvnX66yYiFkg?=
 =?us-ascii?Q?Cwf5QXd3FHvLRjT9GxGopXIrvxlskzSqi87uUfmd680Aoo1ff37AYcH0l3Ju?=
 =?us-ascii?Q?zLqUJx2O4N8zLQIuG1Pmhcc+02qea9yyN3+M+SRagC/+MwNjuzTuLDrqRWop?=
 =?us-ascii?Q?E3q7es9jgHlsVI/oFtjMz83YHBWpLGLtiqGmwsCfGubI2bspkHBLBvFdZdxZ?=
 =?us-ascii?Q?EBSmZYl2/Mksfs5yhtXU9Mu1T2nIPN8/0S3HBaqvgEinXaGunbhhw3eKEyDi?=
 =?us-ascii?Q?K3Cn59A1alGZd+/1s7i6D50LPegOTVsDYHwqSmL/mKbz69JDHhRnueWcI93w?=
 =?us-ascii?Q?82XlK1g/jZ0tXzU/fS8ys49BlYds0Yjv9sragF+1bSZNNkk/vepBVHRhK2Td?=
 =?us-ascii?Q?+/gseDHRE0rUOb6IcOng+gyfSB9Qp8hHfSwaWGxFXdAiNLb910v3Z2E3YeYe?=
 =?us-ascii?Q?xchh83On6lLGMrcmOJaxElkPzL9qDKxxDK5BOGoBPZETwvQrE1RyLXb73pMf?=
 =?us-ascii?Q?krBN3//+PRED/HZht5X1/FPLWEyh5M8/vAazZ1ty6vchu7u6Nbi2DBzWfV7c?=
 =?us-ascii?Q?N22NAw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ee5139-d9eb-4391-2ae4-08db4008b46d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 12:30:33.6167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5S/Mw9wa+eAdEMjjSjzHoy5gZsTCevCukSwRk8qnTpS6cYuTbt//Z5mXJMh7jhz6M5/TjeE/+VnbgLfkrH5p99hjXkTUYmg6LecFSKpjtYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3846
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 02:24:23PM +0800, Herbert Xu wrote:
> The cryptd hash template was still using the obsolete cra_init/cra_exit
> interface.  Make it use the modern ahash init_tfm/exit_tfm instead.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

