Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33696D9040
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbjDFHMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbjDFHMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:12:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2116.outbound.protection.outlook.com [40.107.244.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBCEA5F8
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:12:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXj4pDkCQhPY/f5+xXdOjOpQFc0mg10jq7rFUsd+RZbH345kuxQ/UYZFWNhiEMo9aNB5HVkc/ZlLQnS/aHc6bnTjIqLYHGhsBfdDrlU7y+W+w8fweGZWUsSW8Xm4IfO7g9HNG+AssEkK381gARO6FVsOElfKyFj61CjXvf8+P0VPoevhm1n1bztJaR/trf+0froYB+bs6tGbPXh8sqd1NrYKCtShYmlrva+DzMectEjc+KaCY8v6d9TsldSL9HfyNVPQJXi3gj7ROWLJyMjEOGRSojS7RVs+MzTPoHcFDNvaWia7JPOpNfflY6nVV0zyLfvh6/0RcRsMpROE+SLhPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOh0uUnqtGnR3bc3f58JGoPFGOwxsUvulc8LOS6t1Ic=;
 b=VrhnMUSU5CX3aCC7jPvgAgJ94/hKz5t6sL8xQhQriwz1PK6Jb6cy0vggDyOmbVyQyafl9VpCm8Ejx2cFwrLS2WKFDWwI/4Xf3/3Ridc4NwfPiAH9T/BRVZtOT9NtssyBruVDHng1GMGVeeu1G1/6SPSSdJ4//cISeL91OB+5QOR2J0gc4I+bYG9WP0w67WstkeDbdLtvUyt+CLVbeVavxAZ8eTX9hHD0oc8XzXsK3NrW66cbkBBYn6BVrsaloAGUPBgE+5guqVjG5fDY7H5oql1RPrkdaYA59AuKaemZdBw/uE5cDytSVQ+zczW9hQctaIQ4VzLly/zjLvrY5YZMjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOh0uUnqtGnR3bc3f58JGoPFGOwxsUvulc8LOS6t1Ic=;
 b=wjc48LkIgcP4cuuU9WZ9bY/V+pWz4QW8jPtz7vYMqgBmg3MHrr+tvSEkVobAhv7KB9G8Qyaw+5eHHYHgv/7gMksWPI5uEck015uuaBeNA7ggEzzbxywTdN3A+oIOe5vSGr2B6kuCiIApp4CvKLcaNR/vosQG53kqnIzRrX1SG2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4720.namprd13.prod.outlook.com (2603:10b6:5:3a0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.28; Thu, 6 Apr
 2023 07:12:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 07:12:37 +0000
Date:   Thu, 6 Apr 2023 09:12:31 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <ZC5w31Kqh8KxHm5h@corigine.com>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
 <ZC3Ue5i/zjZkvMGy@corigine.com>
 <20230405203107.lsz53fbu257d3pmc@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405203107.lsz53fbu257d3pmc@skbuf>
X-ClientProxiedBy: AM0PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4720:EE_
X-MS-Office365-Filtering-Correlation-Id: ec432c96-6d87-4ffb-ff29-08db366e4d64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h+CmI7u5DL90kPeHNTUFgMBeblYc/9UW9lTXHMxssjUUB4XGFlNzdfTWrri4vkkVfVxHoBmbQL2UEgLF+xSnfrhSqSfNx6AP7J+9W9asDO5bkW/m6jwMomfdFtsDV1F4rpIFzCg3LMrAe5vzenACFuDIwOCGWYT3PfSIgRGk981TIWWb6Kt449AmXtwd+EO4V0SUT2QyDzWXbzBd1nzDglyqnYg+BibmeR/lrbANtMfIUIiORBaPQfUHaKfmrEriCzrdVG74EPoL/QxrVxwyJEdHo5H+nT/zOXfWn5XaIVMtKFN9hsVAexIikOXumBsrTX98uMWJoXhYrik8iKu7iyPkTuqD/v6Zsgx5JgPg4FMkiPPhi6gMbDpDHxNSJpkXVPouiqhew7D3jsnhZp+kYOjqEGKlUBqJZ+ObFasofRuwwCNdEqO0qPugHUlgA5u+26LBwJ/y1zomZu3K8S2oncQhvd4nY0471nBZ8Q3QaUyn2dBu2O6atzf+h2OOHlUke2zEKfLLrA3z4z86OqA6e5GJnjXZAJAnXBwCrDV01/e/jXGDdaWHvFxeuOC+0dOG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39840400004)(366004)(451199021)(186003)(38100700002)(8936002)(6506007)(6512007)(8676002)(478600001)(6486002)(54906003)(316002)(66946007)(86362001)(66476007)(66556008)(4326008)(6916009)(6666004)(36756003)(41300700001)(44832011)(2906002)(2616005)(5660300002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CPc9dg84yMYCwctB64msnzS0nXY9/swkUCQSBRTpcV++e8109Bg51TprkibH?=
 =?us-ascii?Q?6JT1WvUEJyV4UlGwbuZQHHy/nmU8E0eU2rSNWd6sgJs7ceqADjr5RAAL2GQW?=
 =?us-ascii?Q?e4Iv/xL1qEWNDQxz3Nf9GmubptV+4ZDhoyapa686RwYUPrhgyI/F2K17W+Tz?=
 =?us-ascii?Q?vRrrmOZyBakGJVPDIhHfzDhe7Y5kXM52UvFETyn7OkVihShKy8G++4tIn51Q?=
 =?us-ascii?Q?MXKz21xHhD0wOdfY6h1pn4pevOjHhtn++eCNk3EwB2Be1w3aqBNEGUbZWuQd?=
 =?us-ascii?Q?0TWXcrQXj2vQe+//uz8JMIc9ZIAbBDraVGOK3q+asOwK/EgygDjMYvjhir5B?=
 =?us-ascii?Q?6AyZcvHaDBICr5bOXaMSl8jlvp0JvA0xZsMRT+pP6N3byQWcbs3lnQ414fU8?=
 =?us-ascii?Q?X6Y5eXhDEKF9ST3l2Y99jtilPyLgssytYtdVhU8OUtWNUR23iQ1SgrGmERsJ?=
 =?us-ascii?Q?CoDlqmN05D/tSQs1cTzti2G2fvU4jyKciCgdwqXqp9tPF7NtPZ/sef7SEz2n?=
 =?us-ascii?Q?g3W6H7RpqL6KexRh3o1rWUh2NujDe13TjmuoJKuDtF5P1qh9G+ikhGQ+HhZV?=
 =?us-ascii?Q?ih5VVX46xkBQL3To2Nmr7Ycp1lwJCJSw+Chi7gerksihf34v5q7ZmgNxkS0u?=
 =?us-ascii?Q?Uh4ztlp8iB0HX5sslF8m2W8Vr6DZs2cxjP5QyTQOBCFzWiqYKBETGBGcsj/r?=
 =?us-ascii?Q?WvTCDNgSdJCxNSL5WkiG6Gw6teJQM4yqAiaJCSTFyt9ZKsYiv2chHz4N/4Nc?=
 =?us-ascii?Q?gZuNGXKsizvw7FI3Ld5Qlb420e3+DYZUH7kFz/205i5EyCIGtqPd+GTry40t?=
 =?us-ascii?Q?HaIwCwSck5J5v1lK7qgTMNvHJInaN8zRr7iqIe1C9n+Lk64P+KKL4YuU76m+?=
 =?us-ascii?Q?f6hh9wxPKY3ErAGq4rQIcqaciOQ10lDc4N6MWuy1nltLoL1FRPAHi/fy6vIo?=
 =?us-ascii?Q?Gxl/fReNSJB11N44YS/xbLqk/1a0ZH64MOG6/fJ2wSG/5ZM9pDQ0An75Nthg?=
 =?us-ascii?Q?irjSVmZoFCQEmXSvWAXdSMtioZ4GVjvT515//o6G71eoYUcBsG+DR0IZSEYl?=
 =?us-ascii?Q?HCr9CMpKdmonFHmtTUWwMsMNPMI4fOS+6vf40PwBtonfnIUensvE/bQmtJTp?=
 =?us-ascii?Q?JNLch+rJED6KMBXuPIuUpZ33rCV2n4sJ5200ZvoqCMuhfCMljjn9E1QLHgmx?=
 =?us-ascii?Q?I6Kkn+4tI7Wb9kx13jX34mWFqAIfuA94mvhQkTWcansW7wm5M/7/2lljc/KG?=
 =?us-ascii?Q?2G0UG+JobnN/CGnLnknNvxLMzgxRPtzMJ5LK2+/o2Elhy8Q7sOWYgY01p2gq?=
 =?us-ascii?Q?cwmJweEfxeRAvf0CpRzPtcMJa44kR6uOSQQAchfyfpWKaQ9Dq5vgUoQt2Jy+?=
 =?us-ascii?Q?ZbyzLFmP/L5iswRc+k0Kq77uZEXE6RaM0vTwBIrWBp21p8ask/EMmcmkGrV4?=
 =?us-ascii?Q?oScOtl2WUFjtzIP6dYXTS9LtcJiSIGzD8nTyb7z/Pmx4t3bjEpQR01AXytgt?=
 =?us-ascii?Q?WbANZW6PEjBRIWV2nJLEi+q3EHgDAMiJZl1r13R+IiHZ6bLrPs1BCcqVf/39?=
 =?us-ascii?Q?IzTxMlQcc9qvvNsh9NiJnwfQSM7u+Qj8t9JF6uJmUC6F1L0YeOBoypBuwaTz?=
 =?us-ascii?Q?u8897ei128BTNRX9erZ/SDMhjB5GgRh5uH5Ifc2kgMGswxmCnbB8yg8EEZyL?=
 =?us-ascii?Q?RHS+JA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec432c96-6d87-4ffb-ff29-08db366e4d64
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:12:37.7130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQ2ciWdMGcZKsJnmyZs6ws2olVXqj4EuYE4wdXKKc79xMnD7G9bYcsgFVhbRy5BANzw94dkg0om3JkP+nVvgFKMbhgQjxiiXFobtqCqLNKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4720
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 11:31:07PM +0300, Vladimir Oltean wrote:
> On Wed, Apr 05, 2023 at 10:05:15PM +0200, Simon Horman wrote:
> > > +static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
> > > +					       const struct kernel_hwtstamp_config *config,
> > > +					       struct netlink_ext_ack *extack)
> > > +{
> > > +	int err;
> > > +
> > > +	if (!netdev_uses_dsa(dev))
> > > +		return 0;
> > > +
> > > +	mutex_lock(&dsa_stubs_lock);
> > > +
> > > +	if (dsa_stubs)
> > > +		err = dsa_stubs->master_hwtstamp_validate(dev, config, extack);
> > > +
> > > +	mutex_unlock(&dsa_stubs_lock);
> > 
> > nit: clang-16 tells me that err is uninitialised here if dsa_stubs is false.
> 
> In fact, clang-16 is saying something much smarter than that, because I
> did test this code path and it did work reliably (not like an uninitialized
> return value would).
> 
> It's saying that when netdev_uses_dsa() returns true, the DSA module has
> surely been loaded, so the stubs have surely been registered, so the
> mutex_lock() and the check for the NULL quality of dsa_stubs are
> completely redundant and can be removed.

For the record, what it had to say, when used with W=1, was:

In file included from net/dsa/dsa.c:20:
./include/net/dsa_stubs.h:33:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (dsa_stubs)
            ^~~~~~~~~
./include/net/dsa_stubs.h:38:9: note: uninitialized use occurs here
        return err;
               ^~~
./include/net/dsa_stubs.h:33:2: note: remove the 'if' if its condition is always true
        if (dsa_stubs)
        ^~~~~~~~~~~~~~
./include/net/dsa_stubs.h:26:9: note: initialize the variable 'err' to silence this warning
        int err;
               ^
                = 0
1 error generated.

--

In file included from net/dsa/stubs.c:7:
./include/net/dsa_stubs.h:33:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (dsa_stubs)
            ^~~~~~~~~
./include/net/dsa_stubs.h:38:9: note: uninitialized use occurs here
        return err;
               ^~~
./include/net/dsa_stubs.h:33:2: note: remove the 'if' if its condition is always true
        if (dsa_stubs)
        ^~~~~~~~~~~~~~
./include/net/dsa_stubs.h:26:9: note: initialize the variable 'err' to silence this warning
        int err;
               ^
                = 0
1 error generated.


