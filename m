Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF48A6F124C
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 09:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbjD1HUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 03:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbjD1HUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 03:20:33 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2095.outbound.protection.outlook.com [40.107.100.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65151210B;
        Fri, 28 Apr 2023 00:20:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGtQ47f5ZUrW8Y7Ximjb1uyrtQ/hZilqSOnmmMwow0t8ScYZP8/QgaqQHNUACZJGkyFosJnedtemAEIrdXdOoEN5zXXx4dcnLnMYO0GbujvtaQKHQVjhhclobRx3ckuJIevlv7mRybNiWcnIVAWHrYgSNrnMsK08+Wxc6aWfuI+boFW1cQcUDoSSwdM4rRS3O9PNhQwoaWc9Q+gPqwCUT46L3rlzhmdhLjeDFZUlhRSBspKPm2bbZjPvJkOl9cfuLdYUY5+ra2IphOxZ/hnqOrYfHQmWKDs14skBQRceyE5vRnyb4sMfFpmkmV4pKs8UNZR9ZDJk7BFS0Sixt6LHhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgAn83e5KmmIxJ9GIytQFKErApEzgBUxwoItPPfi4w8=;
 b=J8UhM4EdI9Tqt3txPvP+028hgipgF9aBVofPvghR80r8wgdTa/f4DuwwOQ7NpDNIibeXotBV4wjkj1jA2FNmtE/6KZ6WVKWYr6Z0/tcaT8kEKabtYtTEBzuZiRhLbM3bxZwklov6C2vLXExhV5chbT6EK5U2E1nPyhQrMwCaPsWnvKRLv3PV10FZk/YeFk/Kz+S4VyDmdcF849oZb5p6cDZwP/DS8FzBp4cbtyYc+455quUpNtx9MvSmecrJxXSYHwPGBsKLbbMqybXSDi16qIsMx0FWdOYCVdMUnEp4UuTr02HHA+csFJ5/Tf80sx0KwD+5HIC+AIcShxBICkgQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgAn83e5KmmIxJ9GIytQFKErApEzgBUxwoItPPfi4w8=;
 b=HA8VmvaFRE9W8gKoVMYDVg2VUJZO8GlxYyscQkZYK02DdB2Nne1lh57e5r3/+riReIBxtB6m8hjWuEgOfWWDKiBf2hiYuwSzIhuifKOxiFnD2jg9zAQt488p8kZN3SH6aEeEFkQ3ODioLsxGjd7lUon60AZgjt7yg8qU4lxvoeo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4086.namprd13.prod.outlook.com (2603:10b6:208:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 07:20:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 07:20:25 +0000
Date:   Fri, 28 Apr 2023 09:20:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Tero Kristo <kristo@kernel.org>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [EXTERNAL] Re: [RFC PATCH v6 2/2] net: ti: icssg-prueth: Add
 ICSSG ethernet driver
Message-ID: <ZEtzsCr/x5i5e2hA@corigine.com>
References: <20230424053233.2338782-1-danishanwar@ti.com>
 <20230424053233.2338782-3-danishanwar@ti.com>
 <ZEl2zh879QAX+QsK@corigine.com>
 <9c97e367-56d6-689e-856a-c1a6ff575b63@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c97e367-56d6-689e-856a-c1a6ff575b63@ti.com>
X-ClientProxiedBy: AM0PR02CA0122.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a057599-562d-4697-3692-08db47b90909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GzyFasvVGYOcPJ0M2oGoZg+RHRYLIyT3KGS2EMr7SC3Ce9WU0X4OUxR4cJdjSGIzQ6rmgyixq07ddjyVfZw9zhOV6NwVIpzZtEmRKW+HEZNyi3eNAAOJs0IO3c+mSqFltXIutDYMpo2TnaBzbS7Zz2Orr4b7UcdX6v9RnwM4a6Q8x1vXDq4CEYhxxCZrkEI4iMMumk0wWfi0HmQjSRFBZvy+5m5eQd5J+xqWRSO1axq3tP39V/6M9t+8z7klyUfUFahTvAi1w1vksNN+i7Bmvz+SBp7jbEInhKDePA3ODslYluWiY82JdDG4DlQQNA154tGA2nJyt3xmzor5Jkfr3U25tiEjUds1m3USDd9uBupdLb34UD4WnQ8X0co/jY7m7PWCU+ZyBafSHH8PAQoqfaJkNR+ucuMzzWOXrDmeLaOOzZ+YpqIZ516I+jrLXiu3qXENIfjCcv5NVDX3TonYCE5gldo5CsJXavdoxPv37yvvE7yp/zzDE4UMIW4e9rYm2HprjWhHD59NoFOHx3fGf2w9V+Vhav2bcQpAthbRt+qdqj6r56wyWIjuth4qFld9LL1Hqd5vmD9Pnu/UY7eouBmBrQvSAU6hdiC2FazsHVM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(396003)(366004)(39840400004)(451199021)(316002)(8936002)(4326008)(38100700002)(2906002)(6916009)(7416002)(66476007)(8676002)(186003)(5660300002)(83380400001)(41300700001)(2616005)(54906003)(66946007)(44832011)(66556008)(86362001)(478600001)(6486002)(36756003)(558084003)(6666004)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XqqWlbzpU+S4G9jxMezHqbbA5r+cl2wutNX4cB5S7Xxj4qgQOpP/lkEIQ2MH?=
 =?us-ascii?Q?goC7M7O0J5s2xu3kLCXgq3ns627j+fb59Fzg8GvSLmbZiRVm16pBrgDInEZN?=
 =?us-ascii?Q?yJI6jdnVFjtJEdfPSaBCN21fazIfPkXOkaOzhnSn/YjsM4cFi30Pro83kafh?=
 =?us-ascii?Q?2e6A1qFYOpj8HRX+ZcS4D375WWmXDLugM441K8itP48gIT195IpP3v1qKMxq?=
 =?us-ascii?Q?vxOFaHtGP+elRlBGkt9gpkCpCAkPr2LOX8x1Rwkd8tL4mC0PNGZXBKhp+pVl?=
 =?us-ascii?Q?qa4kfAjeGy5jj63Pi6PVC6qzhDHF1QqFbtH4+9l0v7IdPXX9agnYLM3XGRZH?=
 =?us-ascii?Q?TP3G+zDiLOHGVPp+YXImGo++6uMSA/kTkmb/ohyxnTpaljuGmPGOQZY46fKd?=
 =?us-ascii?Q?wxC+hKO8vaV/v/K+KPJKXquAlKr9f0nIfa4flC7Wf01Y+KgbFwkmY/XYqfIj?=
 =?us-ascii?Q?KnFbFApcGnlNGadNWkJpIoRg5x6nlv+UlZXg1/nf0bxAk7u/0Go0p1ItaVk+?=
 =?us-ascii?Q?FsWlPpYkWeYhfk0uALCWffV5m7m+NFZy+qgT1UcnTIt5Z/kvLqHxCgD5d+RY?=
 =?us-ascii?Q?ZhBXFXNw5nTzxI8PuCsCth6qKRePwW9vwBVV974bMEfmrBF69e4WsonGQ5Xs?=
 =?us-ascii?Q?8TYJ4gOlZn/oC+Dj1WdEyqLxTjPTSyEppVwPMetCoMKCGILUBsx6EOc19tBs?=
 =?us-ascii?Q?Tu3w7MrT0K9NPo1QlK22ANzOKbnHR7mmvVBpAiDh1ZgLjVYCYKiTQ6oTS7t9?=
 =?us-ascii?Q?52sFrUTTHso9TxAE7N5YgTemUv+jazQUy79fwolzOsEUXrCCbnvDg0GaoJMv?=
 =?us-ascii?Q?4M0JyBlPMrYwpsjizKUpkcw9GbMmXQBm1JIN8MzWPn3bq1SwKtvnRD7Osc9A?=
 =?us-ascii?Q?YFqYefzoBkxr1OPFU0cauawflUJwk+v1k8s+9pq/D1rz7yP2spzLGdKrxg4a?=
 =?us-ascii?Q?4mGfk+h+ypa6nOVkjvmFLJCcZd1hCFqnLaOp7D09htgsHD8eYg3KQpsbA0QO?=
 =?us-ascii?Q?1Ok6x9/6lKgXlRWo7UVAXXUtGT1iQuPmE8B0VDaI+jbXw58Sev5zx978Eh+n?=
 =?us-ascii?Q?FKzFzMGqZI7y+aZB5ElrEn+T2vgAv3Hk9x/v/rosi2LHaGjUZETcXllYqQOp?=
 =?us-ascii?Q?5DdhaBKr8LV58wDSjwxOBhbQLiqG0GTyGLa4SjobGI8wRgYHlP2ov/SdYcSE?=
 =?us-ascii?Q?pNw3mQs4fvLog2DIukD4ejPg1p4LjVF3fROSyM/YN8az2+bXST/SVEj27xqG?=
 =?us-ascii?Q?ORk4vrF1Bm844SI8Fzq1bAXiX745F941yDe4CSNO07IFii44rBUASB8xEs6v?=
 =?us-ascii?Q?Wk7Het4dBL7zP7Ix862EkyhjdzXOCAgmDXDRHNKVviNi4cZMFpefyCk/josx?=
 =?us-ascii?Q?rprhiMmKFBuYXdK9dp2dTX+OdWbdJcAX7gMdw3MvxLXZ79gebj1tQNSH9Ew4?=
 =?us-ascii?Q?VW9VINgo7qxLcFOmkHJg9tvF6F9m2ZQ7pILf5mFvrIT0WALcEHBTclsT8dF/?=
 =?us-ascii?Q?XS8P6qSl21gBKu5ZG0CVFzXA1bNGhfp+NPY3ruq+0CAXjBYS5of827eUzugD?=
 =?us-ascii?Q?VUqIJI4EeXfCjDKL3JYf4NGdIYb+NscF4hJXFakMisCam7ZDARIKrFDjzYyF?=
 =?us-ascii?Q?12oiYSf+2PowkZ5vjXVdJwlkUbomCDZokg9VHWsBz+LiaRYrHGZBwFRk8JYX?=
 =?us-ascii?Q?5zIiVQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a057599-562d-4697-3692-08db47b90909
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 07:20:25.1527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/YnXzo7QL2K9flaFptKDhQZwALWTRVMfU+UkUq1mE48gYFISTZek1tSrq1sMIphZL0t12IiPLQuXc2DNcHLsQOsWS6iShQ2l9S3gD9HGqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4086
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 12:42:56PM +0530, Md Danish Anwar wrote:
> Hi Simon,
> Thanks for the comments.

...

> Please let me know if any other change is required. I will adress these changes
> in next revision.

Hi,


Thanks for responding to my review.
I have no further requests at this time.
