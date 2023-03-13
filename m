Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2756B772C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjCMMGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCMMGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:06:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2136.outbound.protection.outlook.com [40.107.223.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6602942C;
        Mon, 13 Mar 2023 05:06:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnKQ8PxRygJeNg8p2N5ZG3XfvoV4FSSlYP2DM8puvqQUp5E4PBwwmp6Jk3CDlnJuMNioirzqRTZwm7ZJLDU9gUYOPHxDOtRRCmHykfpEn6MDbltg4gUelvb3lINlOHVZFnl8gILM0PigGO+30OZmFdKZTC9iF9saVA9EaJBFvtovfrQSTbNvWVTD+MwozNOqyQe3FfLs0C4bswOaQ9m4gCobil0AM2Ucdk8kUjZOzU9O4jo4QIBe87TR0hZKkZpaUlEaocMzF83Pm7pVxy0MAf8CgOsLVe62axb4gJu0CUnybN7SkUwkyRiIS2BytEpIUk88w/XLKCbqqPArjtu7bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbpmM+d4v989Wt5JCOd+zidoOQzQHcZQW4GiAyW+AIo=;
 b=Kx3ciVGx71tQGVMhFD5D4CCkTSAeUvnSKXQqkFN+M1SDb7p6whs5ovMJS3SIvyORhJFLUFt1Td6qcAlsCKNPjqDSURhZ6pKsTkwnpw3C5pe3gZXHqLR4ItMfARHM/JoD90zOHOUZ4Dd1LAUa3kUGu48xp0SqrSOycxQJuGXLi5MoNErWWZBj/GFzzSitmPu3gDngmoWupQFAWXmpZGsPnW+48FzpqQnmUT8IhyALNaYyF79tmcyb9sBl/UPfMRsri0Dmnca2P1jPSsoqwCHSeuRegpR8sHkDxvcHlUjarh40STzHS6Sojfx9osOt0ZPbbXJxc/H7Dc1F6u7J1S9A5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbpmM+d4v989Wt5JCOd+zidoOQzQHcZQW4GiAyW+AIo=;
 b=H6CJOO0laSRj9rH3WUz4otnQxOvAxI18pqQPwJM/sGD4Y/YTIA7nCldatecvhoeLUsBBjkQA+GcOjUKW2/lQQcrlEk1v9eAIlKDa6akQLtvs88GEz3y/hn3Ht3vFUwAVwnyBfpeMaSbW9OZ9YrzDsp7JSY+4I3uuzUcvUT764dI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5329.namprd13.prod.outlook.com (2603:10b6:510:f8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 12:06:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 12:06:18 +0000
Date:   Mon, 13 Mar 2023 13:06:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v8 1/3] serdev: Add method to assert break signal over
 tty UART port
Message-ID: <ZA8RsRtUuCc++wb6@corigine.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
 <20230310181921.1437890-2-neeraj.sanjaykale@nxp.com>
 <ZAx1JOvjgOOYCNY9@corigine.com>
 <AM9PR04MB8603EDB41582B5B816993B12E7B89@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <ZA4kG1gG2qoEGZLK@corigine.com>
 <AM9PR04MB8603CD84C41775AE83CCDB88E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB8603CD84C41775AE83CCDB88E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
X-ClientProxiedBy: AM0PR03CA0006.eurprd03.prod.outlook.com
 (2603:10a6:208:14::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5329:EE_
X-MS-Office365-Filtering-Correlation-Id: ca11be7a-e3ac-4550-8349-08db23bb5a20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3nMRbbFVEgXp0w8vvGzJBwvxvPUcNkG01ILOyxnZD1Mxbopj8qou6K97cDdPpz2ZOm15+utO2nj4peZuUZXIz+kLaYvjwqlYp4Nv9iSWv/h++ax3wtH4Z2h2UYY9gJPhRM2v/U7vs2K+6xT2T9vr3UQMAPOXICxr5jstqp+LxOHNqistCzhE689Rv02VuW2htaFHlxxb7IBycSqMu3nLwWUKpYAIgnZF75N90U5r+PXrV8PBMegYnJ9KPMpOHmy+mHeBpaodZLNSqJKWbejLnbGC7COKgN/ffwY+cnZFbvA1cfMRaGq1NyslWnOfft+/tfi+pC8w2LVGaLKxoyEkE5Qfl1m/fJWP22DbbucdX7KL2szXMkXnwUnv+S5YCJIE4XNwvlOagQs6O012k2ps69JOPPujiAMKRoGyDXXP2D3A1PlzF2GlYAMyAEmlVTDxIJpBo5R8vWAHiIekYR/Mne1uYgoGuXTmDT0YioVrM1Jl3HNiohDNv1eqg2YoY38QL8jMZdLHG+Jb1M3W4rGBhSWKriC1vyiqYU9vpVVfNEvI7cNyeBVE7tZd6wXLfTmsmsWRedLVo/ssM3zp1F8hyviUOb3wD8tybLcwv+pTr04Ptij3tLkhSncgJFA5JFdmdfZsGK5G+RBbwzEbnc3QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(376002)(39830400003)(136003)(451199018)(38100700002)(2906002)(2616005)(45080400002)(478600001)(6666004)(6512007)(6506007)(316002)(54906003)(86362001)(36756003)(41300700001)(66556008)(66946007)(6916009)(4326008)(66476007)(8676002)(8936002)(186003)(6486002)(966005)(7416002)(5660300002)(83380400001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RwNWrLW9pAAfrdyfwuqBEclnkcW6UfUHQsYKNXepmANb6ha2NMFxYUjqbjXM?=
 =?us-ascii?Q?7tHGeocPIM5X1Pb9ECwf+ZKPKbLtAGtrG4qE8NjBcSi2FczFWI+jhn/3IAoG?=
 =?us-ascii?Q?LGohFEJ9NdrGevlt8BAD9sNiq6OZ6IHcxlEfXTsc7WdmIABeicbh/HOFr7P2?=
 =?us-ascii?Q?RIVbajnCi3C+eGlqRb2JTE2J1D0BgA0CC3b2gePJ7DkwmaUQguD62yoXqZzP?=
 =?us-ascii?Q?f03DaL6Nt8krvyVvRG0Njf6nZdGK4fFp3v6CUrWwM2ceAdjNbjxFvYHhhhd7?=
 =?us-ascii?Q?c5kj1BPVUzog0Ol9bsWv2q4QmnnX/nznAduKFczWvTpYXv29oWHwyB4foihQ?=
 =?us-ascii?Q?ZL0V/kUAwSGegnMeoOaY882eNhopCVBtVVxVvNI9sNOPRLGanKFNiYXof/0r?=
 =?us-ascii?Q?dmrptXezaUsjxbRZqATWbhxZh4WT4KhVWg8h4urFVSGuGkOEwykh4LMK3W8k?=
 =?us-ascii?Q?FIGam6VokYovsy9odmjsZR5ZYHSEXUacl5pWN2nq9Xdr1dPEp1N4ws5olw+n?=
 =?us-ascii?Q?znd1UA+b/cY4LZuUrvhUrG4OJZpWNe9BEe9f87PEO48Uv98T2olXDuOWp03P?=
 =?us-ascii?Q?FAEZ2xjngMRuYnWbFUHICVnJzZ3VQTCj1R5FJ9J07roKW3lmVu0YWzU0+1bR?=
 =?us-ascii?Q?xSZvp3zIkTWryiA/kSyWFqJbgal5/MqQeTIN68T0s2f1TMRz2jsnQ41Dyole?=
 =?us-ascii?Q?sGa2vVDqSpqskAeFaDlIBvsLSTDTRgZkZLmE2do+2lWMVIuJiCC1u+WDsTOJ?=
 =?us-ascii?Q?EA4LC7G7NZsjm9/J5aDC+7GPc3xsXcGwJtcGabAbX8jQqeYv8/9jhwhaKqTU?=
 =?us-ascii?Q?tdHvgMSFUj7RipXKijpbKhV+RSbCwmQnGMQjS5x3lLZ8kxIUe/M3bC+jIoVu?=
 =?us-ascii?Q?22hUstqn7Q4LFeL7318Lx3WEX+MXBrPAW/J40MMXnzPe4RV8fZqhK2LQaPcY?=
 =?us-ascii?Q?tCD1frUc3jcI8tdHFqJ9bzJSSN1nymL/KeNcP5/LX0WvIY4yhcFVbRz/r31U?=
 =?us-ascii?Q?at/GcfwbUPNhnLTZs7LDhV0sxn8yYhw/SWdRIY5/ZG9kGPJwKTF8EdXsFam3?=
 =?us-ascii?Q?OCRMeZx18r8BeZww0kEFV0XuZyif9sO9HGA2q8O/KupBpYJdjXv8kTrEG5tk?=
 =?us-ascii?Q?Ge0jSfYJ34vYgFEKr0vQKmJflK63c5R5lB0d2xgIxO96U0xgrCvWcDRvoxmi?=
 =?us-ascii?Q?2ohGeoOrCdGl70w5cZzH06v83RqJ9XzqKRcOfgcQyWCxJHEsTcgFci7KjdcL?=
 =?us-ascii?Q?BxXLERwUOI40h+F40WzfT9O9MQdqCw+v3eNWOBzzUpbEL/WoDPks4U2mWcEK?=
 =?us-ascii?Q?7V2m/WizCEKCcB66S7YAjDJmhQ1J56QQoKn/yHzeMlq38WmWIpgnOAUdqI64?=
 =?us-ascii?Q?mCdEVyspL3Itu4lsci1mmfRuDGGo3+bN5MrTQxG7/AvZiY1NvelX1s4h32L+?=
 =?us-ascii?Q?dX7FCxGVpHq9RGRuYGJB2ZwIdqW9iFm+jOhoL/7ZVBoSXKwSb2IdqmgFXykO?=
 =?us-ascii?Q?7Bdvmh2nk0noYY4uNLmY5i9b7sKEVZoW0YG5EUO1JrHYlvgXUetxlION+Pxp?=
 =?us-ascii?Q?BwS5uKPpVwP9DxYGxMlVSlY32CbY1egZFA7lTMLGI2dLOfsd+RzAkUrFeRvU?=
 =?us-ascii?Q?bA7QUJFob6njlzDbM1d9v3q2SxlfEQ/AH2dKplOsSGkZbPk+DfsGyvX5ja8/?=
 =?us-ascii?Q?wgFXJA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca11be7a-e3ac-4550-8349-08db23bb5a20
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 12:06:18.4274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVftfnVKGPIEgOWrSQ1g0BUWqmqdV28nyuXQA8c3FRdeys0UE8EziexfxHDTHD8AxQxdTTeg/YYxq9p8KcpxCXZi6xwApXMH7hORF62bQc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5329
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 04:19:59AM +0000, Neeraj sanjay kale wrote:
> Hi Simon
> 
> > > >
> > > > On Fri, Mar 10, 2023 at 11:49:19PM +0530, Neeraj Sanjay Kale wrote:
> > > > > Adds serdev_device_break_ctl() and an implementation for ttyport.
> > > > > This function simply calls the break_ctl in tty layer, which can
> > > > > assert a break signal over UART-TX line, if the tty and the
> > > > > underlying platform and UART peripheral supports this operation.
> > > > >
> > > > > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > > > > ---
> > > > > v3: Add details to the commit message. (Greg KH)
> > > >
> > > > ...
> > > >
> > > > > diff --git a/include/linux/serdev.h b/include/linux/serdev.h index
> > > > > 66f624fc618c..c065ef1c82f1 100644
> > > > > --- a/include/linux/serdev.h
> > > > > +++ b/include/linux/serdev.h
> > > >
> > > > ...
> > > >
> > > > > @@ -255,6 +257,10 @@ static inline int
> > > > > serdev_device_set_tiocm(struct serdev_device *serdev, int set,  {
> > > > >       return -ENOTSUPP;
> > > > >  }
> > > > > +static inline int serdev_device_break_ctl(struct serdev_device
> > > > > +*serdev, int break_state) {
> > > > > +     return -EOPNOTSUPP;
> > > >
> > > > Is the use of -EOPNOTSUPP intentional here?
> > > > I see -ENOTSUPP is used elsewhere in this file.
> > > I was suggested to use - EOPNOTSUPP instead of - ENOTSUPP by the check
> > patch scripts and by Leon Romanovsky.
> > > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatc
> > >
> > hwork.kernel.org%2Fproject%2Fbluetooth%2Fpatch%2F20230130180504.202
> > 944
> > > 0-2-
> > neeraj.sanjaykale%40nxp.com%2F&data=05%7C01%7Cneeraj.sanjaykale%40
> > >
> > nxp.com%7Cf2ae2c9ad3c243df2c1a08db232dc0f1%7C686ea1d3bc2b4c6fa92
> > cd99c5
> > >
> > c301635%7C0%7C0%7C638142451647332825%7CUnknown%7CTWFpbGZsb3
> > d8eyJWIjoiM
> > >
> > C4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000
> > %7C%7C
> > > %7C&sdata=6cF0gipe4kkwYI6txo0vs8vnmF8azCO6gxQ%2F6Tdyd%2Fw%3D
> > &reserved=
> > > 0
> > >
> > > ENOTSUPP is not a standard error code and should be avoided in new
> > patches.
> > > See:
> > > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore
> > > .kernel.org%2Fnetdev%2F20200510182252.GA411829%40lunn.ch%2F&data
> > =05%7C
> > >
> > 01%7Cneeraj.sanjaykale%40nxp.com%7Cf2ae2c9ad3c243df2c1a08db232dc0f
> > 1%7C
> > >
> > 686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638142451647332825%
> > 7CUnknow
> > >
> > n%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha
> > WwiLC
> > >
> > JXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=wFgYY6VnZ8BBn6Wme8%2BYj
> > aJRy98qyPnUy
> > > XC8iCFCv5k%3D&reserved=0
> > 
> > Thanks.
> > 
> > I agree that EOPNOTSUPP is preferable.
> > But my question is if we chose to use it in this case, even if it is inconsistent
> > with similar code in the same file/API.
> > If so, then I have no objections.
> 
> No, it was just to satisfy the check patch error and Leon's comment. The driver is happy to check if the serdev returned success or not, and simply print the error code during driver debug.
> Do you think this should be reverted to ENOTSUPP to maintain consistency?

My _opinion_, is that first prize would be converting existing instances
of ENOTSUPP in this file to EOPNOTSUPP. And then use EOPNOTSUPP going
forward. And that second prize would be for your patch to use ENOTSUPP.
Because I think there is a value consistency.

But I do see why you have done things the way you have.
And I don't necessarily think it is wrong.
