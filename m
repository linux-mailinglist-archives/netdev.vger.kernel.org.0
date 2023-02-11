Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECD4693408
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 22:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjBKVgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 16:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjBKVgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 16:36:52 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2040.outbound.protection.outlook.com [40.107.105.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B875A35B8;
        Sat, 11 Feb 2023 13:36:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqCYFIeXiY2CGWQ4HmSamyGy7xOyJOky+knoYKCtq4FHCGlMVxVLoB0BwCVJdsVGSVaygZX7UGs0suGfZTuElI6PyRYvvPffn547LYcyOP5xCBcgd7rSzhNscn0dX9bq7ofMW2yUdnCxsNnlPdhJbb4/f2fdp83eSr5pZ4TEt/FB/LbT3cgsvv82meaNRhKKFYj5cjf3ZzUcK+G8OSYYcszovVzTTY5OT6en9jEbAl1ivG8pM1JsNiby+3rHfMq44sHiMfB9K+NMGejYRkI/77gCsWrxGuWm+Wz8vM7ZeBESAHMDFAfGvpt2cTA75xnrAO0FS3zf/8xMuYbyW2hskg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vL+RDuWKeNabbIK4GwvJ6VAYfPahYEJxVoWkYh+CYq0=;
 b=j2Ld4OHVeg/0wXkPHdgkDintxoPV0nC3wDc/N00NtSOaJeSqwOpqgw5Lf3YfWzCTz12EwM0dQ3XSMarUJlBZrWpYgzeauzQpbwcRXMpBoujgT3EoSMMKCOE7tMAxOnMsPqGeaEq/ayuqnecSgjP9WSEKk/XgQ0Jz1Sa9sdjtxL4jIVlfegbUHp1fl/SPj08wLTXQKkI3tlGLNVOm/eNCFj1KtGh1JdjwO4a3ZbX6JnEPp63QLV8I8vhf6kHqUR7yHlArBYzeUZ9s0siakMAysTyCn6RGh/H1nrUBH1apyoV0MeL8MQ1wtuCWpswHffI7JDr3ROHqYjjSyFNA5+whqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vL+RDuWKeNabbIK4GwvJ6VAYfPahYEJxVoWkYh+CYq0=;
 b=dEJlcqvlZ1qfbuwK9usJhegi44d9wgqccgV4FEPpQwHFFfYY6xDPy1IeQTZpWpvlxaBcrlkVnMDMU1ZQYospBV2E7cvqFUH8JFo7KCAQO1UVZvNTcojfkV2TONdvOfHzSyQhGL13ObOHyFzeyrIR+H8ZRl9bcLSGjbm7x6j79xs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9507.eurprd04.prod.outlook.com (2603:10a6:20b:4ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 21:36:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 21:36:48 +0000
Date:   Sat, 11 Feb 2023 23:36:43 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Saravana Kannan <saravanak@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
Message-ID: <20230211213643.talp76wceyc7mypp@skbuf>
References: <20221222134844.lbzyx5hz7z5n763n@skbuf>
 <4263dc33-0344-16b6-df22-1db9718721b1@linaro.org>
 <20221223134459.6bmiidn4mp6mnggx@skbuf>
 <CAGETcx8De_qm9hVtK5CznfWke9nmOfV8OcvAW6kmwyeb7APr=g@mail.gmail.com>
 <20230211012755.wh4unmkzibdyo4ln@skbuf>
 <Y+e5TzNRckDADd5d@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+e5TzNRckDADd5d@lunn.ch>
X-ClientProxiedBy: BE1P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS4PR04MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f32f789-901b-4720-c452-08db0c781424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZUBX5vYiiaMvKbTcYO9acgrc95fTAXWWfbwmfxga02uYTm8YbicDPJ2U0v0dDH0TkF16lUr5XO1nf6UqY9EnODw/49XsUohHNZjrpoqOYyg3y7E38VXB4VebvOpHcL6NA6uBGWK69UHHu6gtBrH587CKpmtnsoEPyxt6qU9ZLNgXiLzuAMFNzdCRYnpTR7plwGLJ/5io4Ng3c8TpcKazIHF3rSixgiBJ4cvV2Ru4FRNMpacm6bunJVRRzSZVWM85NOPCHYhdVENRPmgNvd4hiLKFCGqfBcDLSz23K8BblTaBpdHvSRxU7efCDpM5f6swTeRJd4djJJjjf1sE+N+W/M1Ai8h1nrgT4WP75xx5G4R30I5+Q1W0ybNjaumWhmCqNGXx7Qn682rrFm4hWnBMdqWZ6V/bdk0BNINm2oFS96OKvpaJwGHOq7WZYoeJo18skE40hk+tlixy7km5VfilRbrPA3u+fxebWi8tdwqrfX/sV2+JCb+b01SbMFgJJadE7qe2OkUV4aMwr9ZS5oOvntMV+bud/NqYD0UhAgpY6G9hUlunhjslhhi6GAlwe9TcmPkYg4XVLy1n/BgcScOIrvUzrncOK5QTGFTLHC5DUqEHHnbDMZNP7ee4IqLTfgOczPy3y7qaNprTD2HaAK8uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(6029001)(7916004)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199018)(4326008)(8676002)(6916009)(66946007)(66476007)(66556008)(83380400001)(316002)(54906003)(41300700001)(1076003)(6506007)(6666004)(9686003)(6512007)(186003)(26005)(44832011)(8936002)(7416002)(5660300002)(86362001)(478600001)(33716001)(38100700002)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MF8IICk+w5UCp7xYAGV/pWYMN+ZAD+Px0AjlxOEFYNdk5IAiXQvepO4VoWvT?=
 =?us-ascii?Q?MKTVvcBhGVEVUy4beUcY6ADvPqwQIqFP4M4vJm13r7M5f5fx9IMuOsFDkfxZ?=
 =?us-ascii?Q?Ewi4zfe+NmN9QpXpL4rPDpXgHS3Jh9WtdX7Kd/BrKOa+UFYXIFveFdQxsrfe?=
 =?us-ascii?Q?W3n7kmXSNaxF4fKnGWVA9H1UUPeHGhlo2fpJqvoh2A4VXWfHYE/3V2DrLzbJ?=
 =?us-ascii?Q?GJv9/7LEe57Lvb4Ntiw2ffdcEBLnjVXJeAcJHYxIXnDPG8gFPc9hj9jdBPt5?=
 =?us-ascii?Q?20FbNsW3kTzIw41+gZSOkILW8t7tbp3tuWt1s4xtWJfeC74eTPIlSThNyjK5?=
 =?us-ascii?Q?DGkfdRry4apz1oygHz8hA0vK7Be7o50P6ORjRYvKTlels+oZD5gq7zNGSJa9?=
 =?us-ascii?Q?i+pmu6dOhJwESNtohdC/b4gWDGnTOumSyxw56iPZtwzAoY1rSyb9NMWyqbQC?=
 =?us-ascii?Q?rzF2POZ6jlGTZShUVbh7YeAK9u9CRpee+YBkEukXjJiqXJhuJjV34aRT1SjQ?=
 =?us-ascii?Q?jNrTn3VIdndzn7z69QYeslw3OjEzpJVZHdu6Qcgig1eb4k7aSQseWnLdvlTu?=
 =?us-ascii?Q?/PH7KoA1WsldRSXDeovkZ9Lroy/hdjDMTa8AuvzJ9w/PjploJjlD+Elx/8sQ?=
 =?us-ascii?Q?BLoQP1bzZ5O1kGDkZpti41cXEq+Xup1oH11LL51zoBLVb5bhCU3qyavjGlZG?=
 =?us-ascii?Q?rvLnmu3JxkQ0Bo5uSsnfMLfoHxDZKCRMdMRgW9eIlec4vOfTnCTwwW1CVsip?=
 =?us-ascii?Q?zT9KntNIppZIUABWvb/2SX9mIJkyL+tBTvrnV9p7EZEBQf1/cDxOXDqe9MkY?=
 =?us-ascii?Q?401fKl9kzmOt4IggHVd0gTeJ/Yf2I/utC5obdtUx3erw4rzhkOheKPlh12o5?=
 =?us-ascii?Q?8r1uHevCZlc8tZwAsTt8ZwfaMc04DfC97SMY7UbyjK2kJZw+cIfsXzcX3OLB?=
 =?us-ascii?Q?glBLkNdIGMhTijW1idOvdl2nGAZEnVefZY2N7Zwt33TdZm7zFMD9ZbOA16Aj?=
 =?us-ascii?Q?Ebhc9kh5DOU2Q3thgyXoR21QBusWfAbYo60y01kDoiY6DgViSIQVd6jfHUdb?=
 =?us-ascii?Q?EYgZjoJmvqueLNsVlpsLCg8lQ46QrTI9x+hypcoUBBjjYsG/j2sFFbI5M08u?=
 =?us-ascii?Q?PcaZTnHJ3b4ZwzFOzOFp+MQCR4KSjT+mI5Dync5lqmA5ekmNNl0LPSmLGf09?=
 =?us-ascii?Q?qTAW+zQoX1hezs6trUrA3zf8j+yAgmbjCB2bNDjam74EPYV5bzBqTpZ1IgZg?=
 =?us-ascii?Q?9RHAFkTrhbIH0F4C7KYbnkyQV1C9y4pkEiW7ShZ217Elo4dGcAqDso/FNJYy?=
 =?us-ascii?Q?EY9axK7m6+0eL6spy4yEz3+LZYC7vAsK4+DLjz1wPb06o+OfsC0AEemZ7Ph2?=
 =?us-ascii?Q?dvTYTXghO2e/ZdLaJzxLo4mNqCoE/+wC1enMP1g2dptdraBI4yeh7tQv1XL+?=
 =?us-ascii?Q?NoLvQa9Zqg0pVFVq5RDxFRGfzCM8AV5wDZtaezvKPIb6AVJ4kDBfQQFslvWq?=
 =?us-ascii?Q?9WB1Ml2PQryQXkPpAZjD3mqRjlN3LjstT+TotEXxMxHU1coSPBIs/9wmFWXo?=
 =?us-ascii?Q?VDPkXF6UygkCNQ5EvdLmDHnOfTnEq980OZdgPRMpU6APU+iqqJCB3wfOlYpV?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f32f789-901b-4720-c452-08db0c781424
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 21:36:47.9275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JF+PtB0/idv3ik21lSx6Pj6I8FJpxQF+vR/XCzOzm4FTbJvOJ7ZEfpiWMcosnfHx2FPaU6ozDrXA2aHk0AQ46w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9507
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 11, 2023 at 04:50:39PM +0100, Andrew Lunn wrote:
> I'm not sure that is true. The switches probe method should register
> with the driver core any resources a switch provides. So switch #1
> MDIO bus driver is registered during its probe, allowing the probe of
> switch #2 to happen. When switch #2 probes, it should register its
> clock with the common clock framework, etc.
> 
> However, the linking of resources together, the PTP clock in your
> example, should happen in the switches setup() call, which only
> happens once all the switches in the cluster have probed, so all the
> needed resources should be available.
> 
> Because we have these two phases, i think the above setup would work.

I was thinking it wouldn't work because the PTP timer sub-driver would
first have to request the clock input from the CCF, before registering
its own clock output with the CCF. So the driver writer would be forced
to request a clock from the CCF in the probe() phase, if it wanted to
also register as a clock provider in the probe() phase.

I.o.w., switch #1 would get an -EPROBE_DEFER waiting for the clock from
switch #2, before it would get to call dsa_register_switch().

TLDR: the rule "provide all you have in stage 1, request all you need
in stage 2" would only work if you don't need anything to register your
providers.
