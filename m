Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FAA6DB2B3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 20:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjDGSRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 14:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDGSRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 14:17:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2121.outbound.protection.outlook.com [40.107.94.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87600420F;
        Fri,  7 Apr 2023 11:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJtMkfUThp0RSODsABKe2GfLDrs1/vwDB9t+mvU9uPabrykJUfOs5nv9alB6BHYtIueuL/pi5s7I16HOGNBZufgMuJ/jA4W9bt1R6+NBrWdYZg/jfuxpQtS+0NSAa7pKq2Ukvd4zhpmCnhAWOY1NZpE2rhtKANnyJEqGxNwcS0cCWQevaA8efR90KkMs0uGYTQDx0EN+BGR3L8keKq3P/Rvc6+nGxANgLrs/xbYIEwRODpZhI98NY7cEr6nX/dnJ9buA3W0JBZl5PAN3AcMi24yEsChqSNLH4c/E/6ZoKfRZa2xV+Zqsveq8Uiaj0WAEAkGB8IzP/ZXt0LTyBBrw7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3eyFveFbOen/7EFZiOnieBMyYMPNb16m57BqJ1cDto=;
 b=isf3pIB7S+4BxeIkc+zG0sujFVZArZaoV6WHPEpLyreeSjWDvJ7/eBdpPiEnjJX9Ur20yfNTfW6alF0W/7LZf2+319UPaK1oHLmhHMO5GDEnTGjiAzx1KNYE/uAMtbLlhA5jxmMeEpGp00toHXFRohcMmVRGdDmhEKPSVMozvniXRVokg4TrPtpULXpoq5CDevwgwXwJBs0tXlTKX22DOOuQcF+Tls6CV35A0ItCRj9clXglEtuX1QBxctU5DkTwGc4TcQ2rZNdpGB3rVUS0NFCb1t3LPaUBEiBnHbHJN8Is6IpQibPqHS8cnE1L6uUd5N48gakmY+szhbHyrNXpzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3eyFveFbOen/7EFZiOnieBMyYMPNb16m57BqJ1cDto=;
 b=gRBFF1rRSiagvRlfz1vlfw37ae9Jnq0AkJvL3Ghl7sxSlE0J2iPKafu7AIOw3Lc2sQt0tFScm32ONIl3y5n6zlG6euRWimJ6SLyLTzAdSWc6fErvjBnBiSMIfrY7DhS+HKgd3Y7FeRTF2p33cOts8Cny0MddfH8vHXaav3YaTxo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6122.namprd13.prod.outlook.com (2603:10b6:a03:4eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 18:17:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 18:17:44 +0000
Date:   Fri, 7 Apr 2023 20:17:37 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH 1/8] net: netronome: constify pointers to
 hwmon_channel_info
Message-ID: <ZDBeQam3wj7ZHodC@corigine.com>
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
 <ZDA/0qvfO1qHMoEJ@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDA/0qvfO1qHMoEJ@corigine.com>
X-ClientProxiedBy: AM0PR04CA0013.eurprd04.prod.outlook.com
 (2603:10a6:208:122::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6122:EE_
X-MS-Office365-Filtering-Correlation-Id: 35db8313-1939-46e9-151c-08db37946201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPY1X16VCEsMKJ9rROoT0yShIQvhgyjV+fBGETEGy4C5uK1AsYlhWhTyZHAJc6LcIuqJvlWdx7HIe7uizktDAaO5ZvPZPCIJSEyr3poK3R9OStiwzCKTSSA+maafSC6dRe+LsH/pi9eipv2n1q3EIC7mKFQ2eg+m7458RCfUX8igs3K/m8Zk1YmHq3OEo4BMdT+zOq/rl8ZeSx3qLMYcmByOnJlQxmeokegbUqp0EjMWK4qJOHHM/cDBZTUSoTsKc4F4t9hxQjuxEjYprR1SCW9QYciVCwUXbZxeHDPnYO0mX1nH+psRf1RxK0npKBewa702KoX4ivNL7RQAx8absc4qHwBG8Pb/nAHTMmjjgrWGCgDvwx8oxC1UDzym5QwMCbEnrKJ22kq08svl99pY/vrTvxdKnnQvKWpxR/7SU/Pzno7q0gqiKzbSQKlxGlmdPhOFnivuP7xdTHGSH7tpzKUxHqvruWLY3MuPI32BNqXlOFv+vevHfPvpkcREqEwHV+x47VHOMpi1bpKPd67PHBm8dXLHcE7oMeLoU9w/HjpdtMiJjxu0XFuuYiF0LlSRDUVhUn9ky6cj62ow31Jeal7P2+0JTLDQYGjgDAGmCpE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39840400004)(376002)(346002)(366004)(451199021)(66946007)(66556008)(8936002)(8676002)(6916009)(83380400001)(41300700001)(2616005)(316002)(186003)(66476007)(4326008)(5660300002)(6512007)(6506007)(44832011)(2906002)(478600001)(54906003)(7416002)(6666004)(6486002)(966005)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tW1FHseorGbmJwfv/jYo81wBCID2MYmE8caUFjQ6TyBujgUWlttGTldCUEeb?=
 =?us-ascii?Q?9eWBni9+uZ+g1qiJ9sIi3WnYt5naQkyB1D1mBMVGcEyxoZywG4qDV6ifAuog?=
 =?us-ascii?Q?j9249EHb64J1yMY1Qpd86sTvNaJGhgznh0ABj0pbuxeskHJT4xGTxosXMfaX?=
 =?us-ascii?Q?kI1zaeL3frC8F4/7QUMSVmuHTombmUzdDfAkyG2U9KpXRM9/BN95ER/RnqHz?=
 =?us-ascii?Q?vrOl+ksywJ14oynAB9LxcyFfLK5cJpjFvKo8PNOhOIm3Q76PyZ6T6ivt4xCk?=
 =?us-ascii?Q?W9h/gEKz2LzAt7Dgwi6VTwiRCoXmjD2RrXb+5Mic0BOuXf64D/Tk461nzPY1?=
 =?us-ascii?Q?iIK5Y95stuXcHvt9/FoT3C+nZK6rd2WyJbbxhtNmm1dA0jUsdrNjPV4MeVmY?=
 =?us-ascii?Q?Sglc4Hjpe8zod4tP+/XyKnhWrAHCxP37kglNEDeaEYsz7wCBOPhctO3V1Cdy?=
 =?us-ascii?Q?NdVFOABWKxSfYt98PO62E2/U7RPhK5TvXLf5YhLJGro1RTv+O5EmXY6peQNG?=
 =?us-ascii?Q?t9UofHmTunWpTB7flbK9+JjeP1Y3Jdj/A5aUAbB6VK1lq0IoxOwFuI1SgMTm?=
 =?us-ascii?Q?MBqDBL3JkfsxlBm+PXoHZrUG2Rwll3Sx/ZmFlOTd7/9pddeUuE+F82F9DWkx?=
 =?us-ascii?Q?S6FWjJJ9kgsJbnIYxreywYY1cN4ThkoIrp0SL8Kd21FJ5vVPZbJMLlovBeff?=
 =?us-ascii?Q?JXRcE8WjorAT2JNEivMdn8sI8NPCc+/l7p3fDJJhCYgJY8QfkfAEvvfP33o+?=
 =?us-ascii?Q?ZWT3jEGch2uO1zeNPXneE+GMzJWyQn147kaCLV5WzTHE3UXyu9dL0Bi5sypx?=
 =?us-ascii?Q?+5+E+EhxAo9ikse/GKOfc7Pr0dZowE7bZRZlqSsl4tv1IBonDqUIU5LG0frV?=
 =?us-ascii?Q?Dgz8mhVgJc3pcqyWuqSMpMhJqgFOXZGi7K/oJT0UPdl+M/Q3/D6b7N4QxX4p?=
 =?us-ascii?Q?x7TG7uodNQ7M0v8xZBDcn/9Tt+lpsTFAYGYAP/lWpFkuxYDhfSJ5gOeku0B/?=
 =?us-ascii?Q?+e/eH1H/ZmVXefEOH5IpOP6VyQio33Rj0XoHBZFwj5XL2kHzOMsgRlW36eNN?=
 =?us-ascii?Q?S+EbRbmrZ8Ws7LbMUmqZV7WuKdE+hxLwc5QC/RFoRu/ty8FkYsqDyJudoLj7?=
 =?us-ascii?Q?u3TEbZI2wU3u5enAVR+ptZQbEt7kUdG11BV6gr/utm4Sn5Ve27mciXlmujFZ?=
 =?us-ascii?Q?79LLzjV74zkKX9r5lk5VRkYWyL7uZtSMhgQKYa+Rkgvi9fmdOaUMpFI5WAV9?=
 =?us-ascii?Q?66xvhtvAJOUXnTA8ar+/7SJtbNZPYfC6KlSW8ukO7YMi4GDLh9uBrVosceV+?=
 =?us-ascii?Q?Y+WqaHh38Wku3dnni9aZFqHP93+GSHalsN+Q0gRzg1W1LV2WSWf4L395l3Xu?=
 =?us-ascii?Q?cXiQHqFSDJ7J0Qi40oToH5Z5knDoo/XUVVa9p1B4Y4stcCfYIBj+juo6zrN5?=
 =?us-ascii?Q?+rttUUcrgJWQKfSlbDtHw423OtRHLRkDpLFFOhtX0VBZm96kKi8jR9LzZGxW?=
 =?us-ascii?Q?7PUg/qqhtSUk1nCR1cLjGsLaLc2twrsa9wG4akGGCVXGpjD+C32axFd8r1jo?=
 =?us-ascii?Q?yrKBVJ8nlptVMv9X0WsXjKvuBXLOmpMj/bsjF9w1YBhwdgadAySteQ/+9/Xd?=
 =?us-ascii?Q?EAScYoloFlG9jXZa8tOrLJ6nX37DkdSJyLzLkC35E9lpxLjQ6NuBtZm+II/S?=
 =?us-ascii?Q?Z0t6fw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35db8313-1939-46e9-151c-08db37946201
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 18:17:44.5226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CWZakqxyYj6t0h7Bxp2GzrqdqVnrUvrSJfRsu1PW1SupHI4E9z17RpdqruFR9CsUdaWkT5bTIvsxqpGh0xmy0kibnBIIkTdndCxikTQu6ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6122
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:07:56PM +0200, Simon Horman wrote:
> On Fri, Apr 07, 2023 at 04:59:04PM +0200, Krzysztof Kozlowski wrote:
> > Statically allocated array of pointed to hwmon_channel_info can be made
> > const for safety.
> > 
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > 
> > ---
> > 
> > This depends on hwmon core patch:
> > https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/
> > 
> > Therefore I propose this should also go via hwmon tree.
> > 
> > Cc: Jean Delvare <jdelvare@suse.com>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Cc: linux-hwmon@vger.kernel.org
> 
> Subject prefix should be 'nfp: '
> 
> Other than that, this looks ok to me.
> Though I am at a loss as to what tree the patches at the URL above apply to
> and thus am unable to verify this code in any way other than visually.

I've now been able to apply and build the patch on top of

git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-const

Thanks to Guenter for supplying the branch.
And thanks to Krzysztof for the patch.

My nit about the subject prefix not withstanding,

Acked-by: Simon Horman <simon.horman@corigine.com>
