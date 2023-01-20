Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED766752C0
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjATKsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjATKsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:48:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2098.outbound.protection.outlook.com [40.107.92.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D611B6A5B
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:48:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJHLdS3ajnjspWTVfQt/FdB9cN/19wUvrq53AAihhfeA3zcAVNgi1hBRibgEkOvxvoJWQe2WG/kzH7Lu+CLKIPK7SnVK20ONK/T9MVirruSsfK1EBsJJrteVWcxDrATCU8FQ52mn8hkI6s1/FEoJyhe9agpIx5ssshFWt3MFwoIZIbg4rbV1HzxwdlVRPCaHXsUCVh6DKwBJg+Nrz5qF00iprTUStpp2+UHt2K5ogi339025tnx3jinGNQl/ElE1qCoLDv5svy9xLECal6SGRwdDwvqppS13MuW23FHNCMngBywzbjoO7SArMZ+mFGsgoygaYob4RxHtLmb0+JlsyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqzs7OZ+Tn+3km4W0eKeGEv431aK4yrSf0Z8oXF4Y14=;
 b=VVFkeb+SajD3bBof/Xf8qPqGum87LHGQegi1nipQwGqv3PK1nn6CwdgoxO/uYfN0Icj9WwnB+KvA7RG/EoA92gkR6XTD/TThI85dWQyYhC0xObmz8RRJ1vegiX1cqIkSiRsqTneH4ny1JoTywUNY7rDMun25qZwE4EBaVpgeM9nkDrxEXk/yyrdvPrr97BTiIWWAXTlfGs8Ej/viyzoLuW9BRptvX68+t2JtaguN7WtytQEsanJ/PkbFGeQ15cYm//YB++puv0Nw9/bkEMCOg9lTQoEIvM3n/5paUfaCv3ILh63c7Qyt8MShX7kTBOF1ImixdGXRnZDDenWItmiq/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqzs7OZ+Tn+3km4W0eKeGEv431aK4yrSf0Z8oXF4Y14=;
 b=t6f6wAD4n5W2N0598aWZ/9QiUSGV1kpTiYDByCnQ+L0MePY7wb9uCRrpllZBrVsywIIdnbH+X5AGgRGwrtSaDl7R8sQpbn3uyjxddq2vp2VcS8/Q4LJxW8s8NmgxZpXqGooMeUiI3JpUAbs2810QThPnZzB1FzyOSUH/zQkDxqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3839.namprd13.prod.outlook.com (2603:10b6:208:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 10:48:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 10:48:31 +0000
Date:   Fri, 20 Jan 2023 11:48:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     ehakim@nvidia.com
Cc:     sd@queasysnail.net, dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 1/1] macsec: Fix Macsec packet number attribute
 print
Message-ID: <Y8pxeJARotjyVl6p@corigine.com>
References: <20230119115302.28067-1-ehakim@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119115302.28067-1-ehakim@nvidia.com>
X-ClientProxiedBy: AM0PR01CA0131.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3839:EE_
X-MS-Office365-Filtering-Correlation-Id: 1089e997-0c84-4bb2-03b4-08dafad3de6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /33uvIjwXv9tZFVnvJl2iczG0dWuFkfZYB9MbCj7W4W465taXqRSKU8FYpfYXHNTf6bhvfghmIf5P1R1AoZ9Umf+1N0enbxJ+JaYjNYzaBDKXQh9DRj08kY1d+3HZLl6j6BA8IfFtVDN78YPHlFtT/uhuj51lxsOimf0zeTcj9cobd/5Rd+4FhYfnZJiHMgM7u/ZQqS6fgJ8OvlwkYxfn5u6VTC5OtCxUQX+QJBT9zlKnRegJDUrRMdzBVEwRjXAn8cebmWrhT1Ww01lUtPql36+qloiv5NsXgo5QPO+FN9CeAVkMXdomnt5xcfNQJ2SbGwzFCMoGXVOlFhDbC7BzoJbk4zsVlqg8a7lGRtizsJyjCqiRkfdpJuzyEz91WpxyWmpuJcVAqoHy6AquG6rLJZ9bNSHy32GmUyOQ6oA3ttUQVaWjexYLKt2Lp6kSlZUGVd9Yd0VI7j82j22e1c/ERP10cLnKCD08fx6zhQbGXt/dBZCJczMIL8JUDrRYxbYZzQ7I5pko4IPksWWhASh3PuOKZl51siL+z8Obanz05B+TwbEoOQ5NQAcTIcKLlRsdG3y+6bpIdV/ChN5lYiPJ3Ml1uGGKBSlUennTwn9Um68kMde2ZpP08rP0HIdWQcxTtmGvTdXAvTiVyOJvOdxzPb9+DOUZEdMD0DJuHBQIhwdWucPX5AqPWQQJcCeQjtG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(366004)(39840400004)(451199015)(6506007)(86362001)(8936002)(4744005)(44832011)(66476007)(2906002)(5660300002)(38100700002)(66946007)(66556008)(316002)(6666004)(36756003)(4326008)(478600001)(6916009)(6486002)(186003)(41300700001)(8676002)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sqlfDImGT/LZd5L+k2kI97cNbWgcFKrMus9YeeMGwrvjJqiRKeLBlwfzZLoo?=
 =?us-ascii?Q?z0qlrKUNanYk0mW38wW3AaTJQI1lrhue+j4nZk/zrwtuYHxFkfZJGjNtH3oa?=
 =?us-ascii?Q?VCtRxAXIl6OS/y5nay132diNj115+z/R+1A7DpC6lU2/VJmf2outncWNaoNS?=
 =?us-ascii?Q?1+rytZQIjEqFxtuxiZ4Cs/D73Uj9n4Fgq/m6VeRQ18PZtIaiJRyqvz1SOMyC?=
 =?us-ascii?Q?gM4Fylwaslo7hNyiBhCQAbE12ebfLmn9zWR6BsoI4g6D+pf89SrN1e9TU9Jw?=
 =?us-ascii?Q?5lvBlwzBnZZ35tetF9LrYCUZlDVfhzkrCgk6ZKVoG8wREn+JuTAFIDMokEfl?=
 =?us-ascii?Q?klGrGI/72ZbLhxAOZUx+aLgcZ3VX7wKL6uE6Fe5s7uDPlGnEcSGq7X20anui?=
 =?us-ascii?Q?MZQzkYO1S/RNjGF5LoLRjxwnYyJwJidBSpM+JHtIsVSiXauxadMaZO3RUPhP?=
 =?us-ascii?Q?jybDhAd0L5rnGRSJS+ZsHdZqD+2F8+WKLbU+oVlQHLWCDQ5OrDDKwLRG9trd?=
 =?us-ascii?Q?1ha+B9ghCMsM0J2s7u4MkBahHmP8KkA1xtQf48Uq6a33Ix3Z6406FsTb1FnY?=
 =?us-ascii?Q?jtVGqeId6uFJa4MwnsjbkHvh91qVKjYP6vCGJY9L+J06UpRKNvBENthTAHmO?=
 =?us-ascii?Q?kfiF4owLadSHojkzunozltkISfZAR9uncu5sMBNvVg4ZMh6D0mLD4+/qnrld?=
 =?us-ascii?Q?RIXDRwyx8OPtlx+UHuVCN1LPuh5EZ/LZ7hsgy/huHXFuSiA3wbpwU5C46ONx?=
 =?us-ascii?Q?jhJfEPcOR/ARTmb4+fpy4jU11zkWYYiI2+riOZ7Hrshig6VGSjuhhELur1PC?=
 =?us-ascii?Q?MkV8t0NWno88lR1gxo3AS7LsaiWnj4ICdFqQ+n62xj42ftARsRkGT/9+RUne?=
 =?us-ascii?Q?VrC9LGIlXLmqRkG2M5QcCL56NWehUt0Ej4nqQPsSvWpVP6l/HYmGj90fLsUq?=
 =?us-ascii?Q?NUIhcYoRKfXBpUz7Msxwexaca9rj1rUDGsA//iDuem6G+Ywho1lA5/1p6uRr?=
 =?us-ascii?Q?KN5KR60QfRJHJ85perlgnmyx080sr/Qxz/UsHHJjLbPidLqDAqbPxAuxwtah?=
 =?us-ascii?Q?pdf2NRLWFqXGng3Kvr90eeZS1MG9s17gCUgWouSDeJ824nvJzGSk0Dv+44VD?=
 =?us-ascii?Q?Nex64szDS5MeMdPV4+ZaK6bv4+an+Q7aLhrsRTlhZDx6GpfzWndIzinQGQRO?=
 =?us-ascii?Q?Wp+KaAwF4ErAimisNkGqQWkebisA84/4t1H1sIpG9R7ldHPHNFS7Ob/jilVX?=
 =?us-ascii?Q?pK0a/M2ux0i39hZ0Zs7G1OUWwZ2DWI3vfXYBbpLKJhbvOlQfbKJLYZmZo2/r?=
 =?us-ascii?Q?uDGCenBsDEb9jXftgKWOBri51CnhAxjeC6xk4dE66Nno2oQiZlNuHkEqQ+tH?=
 =?us-ascii?Q?Hrmotq1lUXTDfNKQoMsCB2Q99b47IIax6jOJPjw/+MD73pVL4nqoOjfIfqKJ?=
 =?us-ascii?Q?P24V3D5z1S/YavBv7DFkCL6Px3FLmdu4ADo6VuNkpZLG3Mxb6VVaBJWAjMVr?=
 =?us-ascii?Q?XYCC2WNIld7YetzfnhpQbzNZa63KzKWINNQZZ90RZQ7+q2hdHQkVvsQCJZbM?=
 =?us-ascii?Q?7uYZPCciPA+a6GJzJmoJl35a/pvYy3qv11ADKHxOz4kjuEnJCu3jnuY+gbIT?=
 =?us-ascii?Q?wlM+L6wYI2yUdWTJ6mKgGgbMulPknPcNYMy9Uiu+NzH7I+RX8CIi211O32BK?=
 =?us-ascii?Q?CmS89Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1089e997-0c84-4bb2-03b4-08dafad3de6d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 10:48:30.5263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXcRUUcp32/IHjZBhpUbNLgqmxW1+u/AWFYQSh+AyRHWOHSe3w8Ckd8DzQLFFXI0j7sz+/n5Ews8Cnt8sqWArGWhlrHn1noX26yvoQHarWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3839
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 01:53:02PM +0200, ehakim@nvidia.com wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently Macsec print routines uses a 32 bit print routine
> to print out the value of the packet number (PN) attribute, a
> miss use of the 32 bit print routine is causing a miss print of
> only the 32 least significant bit (LSB) of an extended packet
> number (XPN) which is a 64 bit attribute.
> 
> Fixes: 6ce23b7c2d79 ("macsec: add Extended Packet Number support")
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

