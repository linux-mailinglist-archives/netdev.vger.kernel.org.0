Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C526C8F43
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 16:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjCYP7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 11:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYP7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 11:59:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2123.outbound.protection.outlook.com [40.107.220.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C78293F1;
        Sat, 25 Mar 2023 08:59:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keMz2gSxPCuFKUSxGg0wNNsaavnBORV+iAVjKfk2LyEe6fIwlBc0qKIUfuvvtzuPjjJKLaKc0ipZFer8H5gVOSZ+fVIvKKFfFhFU5SuudBy0JpMMwB/tcy6B9T4O4UViYa9Khft/V+2AppY39oo8YbZykqT9aavH4w12OPKzOp6rK6eyYIHl0BAUoacl6uzabKmflzn+sCbVujOHrcXClG9O11WyWcME+h9AxMqWP7x+EAh39wFBt6HdoMfSRDZpmzjgD7DBAoX1saPVRr71ZDPIM0UUpblW+LC5l0DJpOiEB60PMpfZlVj0blwoZ6O25hioIKvu9IiBU3/WNlTswA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFfOc6F/srpvQpa5wJiwvUdCjzi4ShQWTiKS2h2bZWk=;
 b=F+RRK69P48kMOA0FRBCcliZK5VUfYs8NkhXHqKAdNi3vWvKHO/flN2nzsqHLcl82+calhYHNcZtocBXdY08//7zDyDX3SXm4zroieSPALzbpwuUbxWxau8gaC7FGkPXbsEJ6HIYTSfT95cFq4S70ckfRJJDHHtKuREJTFP2s4HquWeOEHNF8hMSZTCt5dMiatm4axbJ9eYWoIDAFzqPmP7t7aMwa9F4eArv9hqJq8cEBfo2VeR0yv6bNchG09ZVC+8IgZn24369KkkAug/9PNQXkm2OCOwsbd7UDCGOzABcBd9dJgMsBCnbvDTDEgwFL4iNni4lTjH8kBlXg0CxNNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFfOc6F/srpvQpa5wJiwvUdCjzi4ShQWTiKS2h2bZWk=;
 b=QhPWA/VJxryoQGjj3gNZeML8pycB6J8usJHYsl0/czJpGAldrgoTp5ZI8Hnach2lj45hLnPgpXnRQy8ihDAvccX+PooYwVFAQ2LhjcOd+S2HPyHZMvEG94anuKUlzZBl7k5rms+rNUYM6Hii2zkt6G+2FgSl563uroULHhcH+hU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4621.namprd13.prod.outlook.com (2603:10b6:5:3b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 15:59:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 15:58:59 +0000
Date:   Sat, 25 Mar 2023 16:58:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        johannes.berg@intel.com, quic_srirrama@quicinc.com,
        alexander@wetzel-home.de, shaul.triebitz@intel.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] wifi: mac80211: remove unused has_5g variable
Message-ID: <ZB8aOahMb4PQoGQK@corigine.com>
References: <20230325130343.1334209-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325130343.1334209-1-trix@redhat.com>
X-ClientProxiedBy: AM3PR04CA0134.eurprd04.prod.outlook.com (2603:10a6:207::18)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4621:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a20e63d-aa00-4c38-e55d-08db2d49d883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50QDB8HuVOdBr9mR7J+HrOLsyJmbj9CpJW7D0+l4rP5vev/8fQF28oOiSAdBzYhCXUIb4lYm1xbORzbYJDMuZU6y35y/m+ONRbHbAUDEExj66DSYwe9+t8bXMl9HTmLpEJ8heLms1GMYD3tYKQOWYX7xkHCZRgHJMOWXyTAgxJTE29HDMgEmJcLnp51bfkAM9Sz2NOlKtDzHb9mq7OElWOVHui9mtYt2+sfZt9IXdATH4Oy4E3Jtvi0XEv9nO3ROlOY5O6WSSGdKAb6DFFEqGtB4maCMh3mZVw5veExj4OmT2dPi1sI6zVX++sv6rCqrt1aj2qdHXLQiGkiQGZCMXIXO4pZeFDSwAQW5X5Ce4N0UOUDCYNMGSTWe3Is1Wo0TsreE56X5mAGG9j8FQ36wLIfFKXNR7OVsgINuJmqKGzoEQhFvfPhF/qitc9sve8oa0e+vTNMuszMG4uJv4XzDYyTmW65u6cg08vItrGmUtBgSI9pCN/9cKN3RS3yungAg7jJzJg3ZZK+ocZNEIQNoROnnXX3fdjd1ikFl7ktkcmkYlxD0nwZat8rmRAKhFyKEBOdvuzhaZ2N2+QaI5GF158vEzARBs0feGROuYvBUiHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(366004)(396003)(346002)(376002)(451199021)(36756003)(86362001)(6666004)(186003)(2616005)(6506007)(6512007)(5660300002)(7416002)(8936002)(66556008)(66476007)(6916009)(4326008)(8676002)(66946007)(41300700001)(2906002)(4744005)(38100700002)(44832011)(6486002)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q2CLgUT4dlrZzKSN4zStrcedvIwxwYjb8IYHBaLpwBQOaTlzmDKAK/4sD3MJ?=
 =?us-ascii?Q?aupH7v66XxTHfuLd1OAuOplZeDzg1/dbGhy0E1e+cYYcv3YKPa3lHzd0r3yl?=
 =?us-ascii?Q?DavZN367Q00WMg7lgZwge6GxG6+3CAfCc7hL+8YdcZjeXqoLvXuGNSFkoMg8?=
 =?us-ascii?Q?1NCkqdcSA6w7MkNJvXiA/TXk6s2ev9Ed50x96+i8Jt/jh+52fI3UdRcCHzDw?=
 =?us-ascii?Q?fVoJwEeDQvDUZRvmmAO0zPT+UIK7MskjRrvtL/ndDy3+7D6Gr/4EDVl8WM84?=
 =?us-ascii?Q?h22KQFBHaGYSnOQ6i6INI1U4iXAse0RXwY516dDs0MXzpIkgdV5fIb94ClxI?=
 =?us-ascii?Q?g2cea+ziqriaEHX0Nh8cQGX/FHyuBuE7+uCbMLaA7nHaDIBJJXhAS2wZbi7K?=
 =?us-ascii?Q?8p4C2nAkJg5Rm7auEiYPTZEd+JAtgS8EFzO3F+0a0ex90BUFw2E+rk+CU/Py?=
 =?us-ascii?Q?R/usz3aCOnkuQhKH5jyraNVH00q3jZBN+3NKfzI90qCRIWnT/Hyt7WukRgU3?=
 =?us-ascii?Q?EzPrYsn0qMeF0j9NzQlK8jv+X2jFCZ+L9J7D9oH0WF7WkTNEA02KdPxox98e?=
 =?us-ascii?Q?PI3Hm9xk7+aL+10IIY1Ndv9RxqG4XayzlguRoAaRJb59ePWDE/54X5H632B3?=
 =?us-ascii?Q?ZqHhauViXvQjxC5fD2cpPII7nvg1+It6Tz0dswMEAWraF5I73JIeGQb4+3jh?=
 =?us-ascii?Q?IksU3PJOM/DFESVRB2hdQ1nDo5frfmmA8n0xfeq3loaeFHNbqDfsw+EACEQu?=
 =?us-ascii?Q?t0++G1MZ6mR8Ccbu6vfJYGwjbjm6WwKQ8rTmCV5ydA41KkIUIO+48SWHR10e?=
 =?us-ascii?Q?Vppzjv3u3Bssb+2Yjt4x6ZHI4lZhIwa8/ut0Zzv+4ok8E2o1nzzYfHeB4CUa?=
 =?us-ascii?Q?MXfNmDN3P+fnFF7HfhRcYIWT7w5l0IPdNVoeZnWBE/ACkEDil9U2L3kpzeg8?=
 =?us-ascii?Q?KtI/lBgQaeIAB2Jl4o9Nyi0/eVwoz92saJE0F+fiad4W9JZpLROFbbWddcOY?=
 =?us-ascii?Q?tn6LT4L5zCcqoEH2YTGBCxcsMnT4QNX7WePsfZnlDvWMH8E/kHoAYPH9Q9La?=
 =?us-ascii?Q?bV4yXdBIqeOfRyJgQHm1OmR+irNgt4J0AAfJbvRTi4LglLtUs9qyVDeFlfYg?=
 =?us-ascii?Q?L+hY6O0+3y3EH74DCM9sTWTe5Zyf9E6wFWUwvRPn8eIe/p4BejvMbCw0IZmm?=
 =?us-ascii?Q?1e1EpSv8YlIOui3mt7pyCFVCBQAWzrSVBxxe5mbrXdvBu8PYMraJw/RBq5+r?=
 =?us-ascii?Q?v2eNqKXPIuBZlJQHl61G7I4wnKZtvOFTA1XcYN/pjQ5dG6+anji6Q4pQUrD6?=
 =?us-ascii?Q?FmRHK4/WWOHeuVk6QfFH6vkRju8VJ+BnWiNauuFluUlTJTK2boYO3C1ULbcd?=
 =?us-ascii?Q?zbM81KEjshIo+tqnT+dkWt5QIgdxU2H7Q1RrCfkhIxakz4ijG/t/gQrxTTRZ?=
 =?us-ascii?Q?FFIGvebBV/2SNGXfq0iA9IWor3Wmpg9OpQMnAR+hOFMb9A1D0PhMBqb4U84O?=
 =?us-ascii?Q?e9LjKAd5DQ/9nRP3qZgJIhTHQ02gE9UPTW8dWKWMJAmevoRe8xzaT9toonbM?=
 =?us-ascii?Q?XpZG+uc8qo2pw+07CPfBhu3EhRDt+ZrBqXMZ0JDg9vWB6CA1aPPmdsAs+6bN?=
 =?us-ascii?Q?XzdQ2t0YIelaVN9kKid2MpQh23ObflWQkmDXuB3DT3O2EqnV1x8pcK7tzJcV?=
 =?us-ascii?Q?HiQRHw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a20e63d-aa00-4c38-e55d-08db2d49d883
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 15:58:59.4254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kMNIb0f0kXw88K+amuM0gYgMY/7RYURzgpaSiGOiGwXqYeSa41nheLMS6/EnAaXkRHyxqA+1/k9ZtESsgIJCcKUgWp8qDUPUo40KZMvXr0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4621
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 09:03:43AM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c:1051:6: error:
>   variable 'has_5g' set but not used [-Werror,-Wunused-but-set-variable]
>         int has_5g = 0;
>             ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


