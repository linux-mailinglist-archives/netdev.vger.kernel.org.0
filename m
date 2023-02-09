Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAF9690E8C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBIQmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBIQmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:42:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1125D1F0
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:42:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKA0Mqnxd3VCCg7SN7+N7c9Ex7/MFgS8uINOrGFnKkxys7wW4DK155GLqmw1DnsYASJYuNjuNZB1xWm3C5z5jiB6XkmyDi2vTtodnbgYJ5qvhmWXvXL/bIN2vr+7QzxdgE/DJjgfUHjW0OyS5Ol4FwDGfKKKCQi9e0KAZ1mtYpamzEcVYhx8wXqaBTk083VSYlN1DO+SkScaItli8CTFTYAcTbTfZjl+IezHFPxG+RJ8jEffNt9E006cBqr/lUZ+0encjPLkYloyfiDjHXLhdM91vMigCSstXjkRBrXQPTPWhJvKZ9rxGXxltLc88204afTOobKbYV4AglorXJoa3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6FiwzZB5J+fKO65pnR5n6o2fPOjLouDgWinWDxOkCg=;
 b=akpOuPQx7i3jw2X5tVJ38qImoMMaw6hLpbjBXF6ZGe8Hef6XUpJRMJHF28fI1O6mXIZviCHbbcqE2iIXFQVq+kLsS8U6NnzDINPxTAdb7qUlcYQ2A4bdMEdWHACbjuUEdrk4lfxXeAygz8rH9+H6n86Mjpkjj8xlVeyms3lfp8xR7PehaxRRDmtgp6myPvK+ACqF6YDH7o0NZCqwvY/8VjZVX6u9v1bms4Gn9IQs83AOC+me4q4E+KckjJPrWmF1b/EC1UNgsllKnZyzG9pfjeUYdOX97m0eIpcyCrXkfVvjzDBtLIXPJd/pe4faTtpRnr7f74Rup3Xm2P8AkF7cfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6FiwzZB5J+fKO65pnR5n6o2fPOjLouDgWinWDxOkCg=;
 b=TNn6Fv0pfpWTlRAUgqoLPFBBK0K0uQHiSc0P91bji2ilinFT6Y8yqV+ycT2931DbwXH90ZDVl+q5SadpPb7aLG7y+9eaCHYRFuQl/5aijqacA8yKgQl6+HK9rGTrNZAcu+Q6vfA5alUuuhZmy4GQXShQ+fWv0Z8H0woJwXzHa/Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5361.namprd13.prod.outlook.com (2603:10b6:510:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 16:42:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:42:42 +0000
Date:   Thu, 9 Feb 2023 17:42:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 2/7] devlink: make sure driver does not read
 updated driverinit param before reload
Message-ID: <Y+UifNXg7HEZjD8V@corigine.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-3-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209154308.2984602-3-jiri@resnulli.us>
X-ClientProxiedBy: AM0PR03CA0084.eurprd03.prod.outlook.com
 (2603:10a6:208:69::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5361:EE_
X-MS-Office365-Filtering-Correlation-Id: e03cc79b-623a-433e-f635-08db0abca9a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXC7ZLKEgj/C0tRBUBZMVQ7Naq7muF/b2WJUTqnnpZunAVhPd88I5I5M30h9vXuAzb1/6ioNQocjqoULg2gBvkaEDfDG983C3CXISjdZ9wrR5/x1Hmgr/hgJx4/zsIVOmQfB+rof7zJHp6js00KDrS9Z3T289hJRzlA8l1tohajelNJpRy3g0COtWKTLdhmmzhxgLExhN7kQAxpG9GwINrInpcny2X+7+hS3abxHRwk4lFheSJdFPpe2Ys4+fZqKXc6KO+CKuSrcWVzzvzhhLLgnKDyc23vZuCBMit4HUZoO5sjMZHzadHpsjSeBHAG9s6Ia1zV9yZ8Eu0I0l67xAVqtjkgJeVZA83ksREgmV+wbrkzbhuiDO58eZyYoAbscVSTWuGSbiiiFVGTD2QDHNFgM97kA/z/MCY1cNoUzA25CAyoMeqqPK7ZJucYbCMMaPkXWDkVkku0Jo+sNDLJd+YS0b4UK2Ev3V0Y5UCCuFWlngxBNaXDelSeRgzTX6adBxFiG6QVR6Qbe9CTux4lb54faTDYcx0fBR0OFDxTC8O3vnc8G7TipcRG0JVN09QVtkA08CMYLoPXqAjEljs0/nQ/TpMNp6oDPJCdbBUUbrlQ3PX0XHaaWKOqrboJiwRTXVZnZOL1ej2XyCA1oXZ4Q33hFosiFUM0qTM5A+Ilm2P65oGFZhUa56hG/zMT14fhg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(396003)(39840400004)(451199018)(6486002)(2906002)(478600001)(186003)(6506007)(6512007)(2616005)(6666004)(83380400001)(36756003)(41300700001)(8936002)(316002)(6916009)(4326008)(86362001)(66946007)(66476007)(8676002)(66556008)(15650500001)(38100700002)(7416002)(4744005)(5660300002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UjArEMEZnFwa0y98KZW5B2blde8hcGcm0C/+s3QV57EOiMjykG291aQku32/?=
 =?us-ascii?Q?O+dBS6wMi3y72nqpVFTdq48k83y6AFu1Q0MvT5lSqpxQXPAJZsI3sj6o7HWt?=
 =?us-ascii?Q?bCGSxUah2j0zutyRdMzTvjdX9uD7qJcNQ464oox6qPoLP7EVBVR7JHsBMBsw?=
 =?us-ascii?Q?5XUaQ/+oCOZ/EtmpKM/T73EIQhoiVQJv+Fe9/E0QQJeYa878ndVFFW4xpRrQ?=
 =?us-ascii?Q?7RkGOskb4EaO+4yvXZZ64ZFeW4lEsqTo3dzTLdV4npAllLNy4HnPp8O8NAw1?=
 =?us-ascii?Q?RnT/se1tAuOra3IKofiFrP9pmDR8C6sSYdXoLJkrY9xEH0Fim9dcsh935yaQ?=
 =?us-ascii?Q?5UKQyUYTizblTJ79kkFloFCKfpEPAJ3b+iHhqqV5GH5Co/XfOuF0u+BlVhHi?=
 =?us-ascii?Q?VtyYxB4LcOLoTP0UcKjw5XGwk14iwQMM4lO05sbz6Pfhd0QfQB9Q0vVwazNC?=
 =?us-ascii?Q?Nn4vtysN+I/i2fx8amoHvDhut6geWdQeKcxnRwE8LsrgONX8bsxo6p9UUTl+?=
 =?us-ascii?Q?I2d9kEataBQyPEaNjXcUGbDgpixSoLih+avZZf2mKC9+BDcqsxqv6Rz3vIsN?=
 =?us-ascii?Q?EMjw4VpOgE64Thy1mdJKUVyZEAqB3rhBeQYb51OSnvna/rJR71SFCxmqrv6l?=
 =?us-ascii?Q?LV+Dt0lmBdw7E9NUeW0cSAmPO1ItCeGVwme4MXlArsfRl6Raytvvu2tP3ew4?=
 =?us-ascii?Q?A1EHhWD8FCOC4bmM4K6vNVxyyOLyA037ScstzI/iIBZQj5YUR1s6P71DD3pN?=
 =?us-ascii?Q?JJmBngN3hKTWVm63g0DlfhuydVjHQufDOyO2M7gq3tT2QrzlwTsHYGoYm31j?=
 =?us-ascii?Q?mhtw6TvMWno7lpOV5tS4L0hEJ71HCFsg6Z51L6ESIH7H36I1hLC89eJlJlOO?=
 =?us-ascii?Q?bWVWf2X85bTL/CahNEzPvw0dOw/SQUjb+2TZx4kzRs+dfwnTq6LDdVtX7fc2?=
 =?us-ascii?Q?vKJe3n8P8oXk/OYZExclbwHqF63lDmEtUzSX3pKFcR9psRKx37ZwCYxor0F+?=
 =?us-ascii?Q?RD+fFy1gfW6WX65MX1/rndk7W602LRSbATzEY0ZVVyVSWIbIHXP/aopI4vng?=
 =?us-ascii?Q?mVcohzyhJFuvoMfEICawHEy8zZyc05bQDaaztLmP3w0lY1TGV0crP1faIDgV?=
 =?us-ascii?Q?rBHwLvPNe+10pjrnFtTAysyH/FyjPCktHY/PFAqZreyrwWb1n6v4xBkhNb00?=
 =?us-ascii?Q?htLr3v1umo0rLL2SYZjAu1zpSihm2OnTsYCxCt7doB0cvM1URB+5DVliN4ww?=
 =?us-ascii?Q?H4psgjConbaSaSHgm2ZQr0NjX7tap3VAuZZ0fXnxOt22TuW7Xj3op1P8Evjq?=
 =?us-ascii?Q?qAtz57F2FVGcOrQkxnAd/ao3CZKFMcafE96gfeo+7PyL8bUDyldDM8DQNba0?=
 =?us-ascii?Q?64N7OFav37szzvd6IgN92m5fPDhBVC4FLxxGsprQZ2bZ0W8xlbYKj9QXDL6r?=
 =?us-ascii?Q?Y+qe7It7L21wmoo0mMzTsrot+g52ZSf4cStaU7N7L77xsNuvgVT/m6uDyWJz?=
 =?us-ascii?Q?Yg4DYKs3S5aRmtq+EL9iCvl+IWWG9cKM52mXo3pSoHCLyz33YmkUI6l2KC4W?=
 =?us-ascii?Q?aLtMYz47r76Jc4nvWnhhNhEY+OgmPmzPWp3Q7Rs3O/s/xIF/LLG+mjuZWIWg?=
 =?us-ascii?Q?PG4bbfcOebl2q3NTF1SwIYJ7VbL6J2bk+O+qyKNJXsqOM59UbfVU0mvDbAG0?=
 =?us-ascii?Q?pYK1pg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e03cc79b-623a-433e-f635-08db0abca9a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:42:42.1861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qk1xIS483owpBQxQeJCRefliHc2yzCMeoWQY7LofLGEyCVxPRwOMxxLrf/r16Ne3AHyS68i5DSf8SnJfYrs4Mp/SsRMZzc37dVzZ+80ODOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5361
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 04:43:03PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The driverinit param purpose is to serve the driver during init/reload
> time to provide a value, either default or set by user.
> 
> Make sure that driver does not read value updated by user before the
> reload is performed. Hold the new value in a separate struct and switch
> it during reload.

I gather this is related to:

[patch net-next 6/7] devlink: allow to call
        devl_param_driverinit_value_get() without holding instance lock

Perhaps it is worth mentioning that here.

> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Irregardless, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
