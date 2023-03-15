Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014F26BB8D3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjCOP6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjCOP6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:58:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED0121A1D;
        Wed, 15 Mar 2023 08:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbKO3LCh4LHa7c3Z7zjIppN/rODePsrSeXY3zg3rKYGALY6lB4kmuTNL9JVuiwOjaAImIOhNpDvxTeip5adacp9BdDmK/DNsX6esWtECwDppVq0I/LcnlU0mwaP/i+T/wxNtlr7nJo3k0o9cEwcDKFH1HsJZF8RUo4mid1GrIMvwuNpvXHTud5GQhTHgwF0sHYO/z5zlff/0jFtTuLXYjopUKoNXivDwvcSqK6anN5+0SQ2SQ9xF027ddpk1bTCQTummxEYvSkzFUZao9hmT6kuIvhhSyO6BLOwMu5LL1e+yIHgLbHtXbEFIdO5mQxO+9wSmsUnBYi0hXdgkQmuDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+Bo730zy4D9KrFPIOHNKVumur9VX1x8tnFTVKEaJYk=;
 b=IF7bt50x5pt5y+PboM+D9Sm2tV/6I+O2nWeix9/4VGsKzcIHKdfyvJkr+5hNGe9+U6MXXTMZ4jPCNAfRHSdcjlrhhjPiXuWDUKe0fsbjL5ChXc15vojtfYzCU33Tiq1w2wxPJxNqTmj20Bya36ikh5HqVhlVY0kRfN+/Nduo1T+KUIZiOjwFm6lPB9Z+I++Gqeew6DdqJClA6yAHx4277GHfWbsHbp5eTDu1347R/SEPeBf/tzVZeQDoRpELPaLkZjH+rzbmpEOZZZtNAYRAm9azbpK2RuLmUVBNaKlT1gmJUOl04wZPwNQK5WOI5f0GBDfYZAicmPjBNLgNznWCgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+Bo730zy4D9KrFPIOHNKVumur9VX1x8tnFTVKEaJYk=;
 b=pAyQ+YRVpISqEeBQDNzATZbNfnpZVOT3HL/GE4jSv8kCq7zLqC4Iektkh2frPROX8kB9JAcqhdKA29Ju6o3+QsBdr9qa6Fd71Twde8A4tJ/2cOf7OXUxDzS9oh+4XLOarpP+DqA3j/MOSHpShWekd0P+1N7VBCMx1GWhzX5Pnw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5037.namprd13.prod.outlook.com (2603:10b6:806:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 15:57:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:57:36 +0000
Date:   Wed, 15 Mar 2023 16:57:29 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/9] net: sunhme: Just restart
 autonegotiation if we can't bring the link up
Message-ID: <ZBHq6UM8GwOaDye4@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-2-seanga2@gmail.com>
 <ZBF/wr8HUg49gWZK@corigine.com>
 <a5eea573-2418-d4dd-94b7-72bda4978666@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5eea573-2418-d4dd-94b7-72bda4978666@gmail.com>
X-ClientProxiedBy: AS4P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: 181ef5a4-1e54-4b42-3ad5-08db256dfed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uHlJQ1nzgHwNc1xLzA0s3KUUT3xx31g2MeU/WK/2Gw40bd09zN8+JBVz+k3704859HFaAS35iZcRI4rLlf6Xy1XyJ86byhjlKj22TJ8oU+DLtNSzYzq7z+yyErFa1aV2MV4Wd47Taaedi3VzsdRvuYwY65zY5zbVlYZ3rUOc9UACpQd61zMyeoCAWiqAEMo3fwgXVjAvKdOwO+o0HINWZtTX0P1zapg9UaPLit7iv0RBESD2bWn/yqSjkYxizzEM1Jf4jloNM1fC+dwzVHLyrsmcVjxZHjNrpT6kMs2j6qABe2+wvZ3Df5795Jg9TT7Z83HvZBYrUOBQfHbQtl0imgJUnJX5IFVqWNHdTaatbPOoPM8eMm3AFP4OturPJ58ux4DTKQlIJB5MuJ88UWK7TqrUUNyO0vOEvlZ61wijDwEspGUqhbOeHtu3/xlYrNhb8DwOYFBDIuaF8vez0e2zn3kWWlxGTV1xL4b9o7+7y0AUmFeW2fEUbsmq/x4tNm7NOgMCx7XWq6tMLoyxPPdziZL8hq6At0CWh4exO/KUPtk5B2sq7wNNIV+WDh+3Ume8moJtvGhp/Q931bQotoQzDNikX7jFmfee7U4fkWt9REHInpHR29yN01yPtFKegXok0tVeuAFDfKHq1GGvLFOpDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39840400004)(451199018)(8676002)(6916009)(4326008)(66476007)(66556008)(41300700001)(2906002)(66946007)(38100700002)(8936002)(5660300002)(44832011)(6666004)(6486002)(6506007)(6512007)(86362001)(53546011)(186003)(36756003)(2616005)(316002)(54906003)(83380400001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/dzePyNhz0SLGC+VVP2Avr8My0tTo8NxB80znZoTH5x0+0KmU8Dk3+6dJyLH?=
 =?us-ascii?Q?aswoRMonw5t0K/hKiIsmzDRiUki2ad4IKgz9RWBjZCI9THxinwrMd3My8+Pz?=
 =?us-ascii?Q?YzMgv3HngIK2+V8nONofybbNstcjgL+BQnguihtOLUZwvf6nV+/boGqBoEcm?=
 =?us-ascii?Q?UaRiwwnN6sxM2AKUmm+CvuYrtl4fowjKHKT7QqvmMeTD4VLCz9mavTlNHfPd?=
 =?us-ascii?Q?71fbevvGuZQMY7ZXwn6Uj0T82FdmJmDmh69HJZIH9sxMz9J+zsNFxEBvd6hW?=
 =?us-ascii?Q?J6yVCq7NPFxMeyZ9uYOa3NvVxGVlBaTSehyJxEA4WmqHyvGIHAWlCHcBGrpT?=
 =?us-ascii?Q?JlbgZYOXCaArSuWH6HRT0COfVnyF5uDpXw8116S7YS04+jOeSCipgr5U1s3k?=
 =?us-ascii?Q?lE68emfbKMdfcXAkm8RV9hM/lPWnyniJdLiW/S2+WF6K80FNWx6CvfFaAu7K?=
 =?us-ascii?Q?i68JrY9T8VpEp31ild8As9o+KVFQaxyhvCxkoijBKSy0Da5giMFvE+JX220m?=
 =?us-ascii?Q?5/RrfSYXGlFxAi7Q/YsUwHd+bgwtCkoRWPOVSiUHAGWXlFrLKZ1/INbF+w/b?=
 =?us-ascii?Q?bRUN1FM9588c0WVjkGzZguvNMgrcuROtZbavC8r6espMOc0mSEMfxNQwV5Q2?=
 =?us-ascii?Q?BYIaDqqMEx+hFmsoWFtsjm6YONI0PDrypfMYBb4g9qkVh7dw5fPGJv+AYzqE?=
 =?us-ascii?Q?SXx4RswX0TVmtJTXVAPhjgmCHf/tJ+1o7pWe2PISOyGRyzyQfJYIPWK26JgE?=
 =?us-ascii?Q?i0revf3OY75QTrldlsBpq0dvyUAmafyunL+E644qCK4VSan8y4epmAAlglqP?=
 =?us-ascii?Q?4ozCqQ0ibtHPg/7ijHn9ddioVvYMfZrxDOGO/nuiPAk5jwFOWM7QzBd/Waag?=
 =?us-ascii?Q?/xco9jYysOgZ17JeZ4A3ADoVt/+tEP0rQxbvH2Doh3z6iOgF/2IQn7bw9s+/?=
 =?us-ascii?Q?pJx6sRMiR699qPpD1aywlbn9SXvzdHhmMBfZkmcrW3V+M/IwR/wPbGxcedFA?=
 =?us-ascii?Q?a76roM0jHF1J+hzgBNtioc3B0FhH5Yf3GLD4Dga0+ApY2sYv+/liMqwXLXlR?=
 =?us-ascii?Q?pyY66x5nEcANkHqHEnBVOLFFyGXKLKFdLpJL821mZRxc3VitE6buqnKsYc/E?=
 =?us-ascii?Q?mxb8oVPX+Dh0B93lHfgUYuaKAbQ7JtiDBgmnaRNhcg+72RuiSEi/BEL+bA1F?=
 =?us-ascii?Q?B1cOwiVh+HB9kqZiV5R3qFsez164J8P4GWBHpsZPUBvtLR3rtEQlmXXWs0sL?=
 =?us-ascii?Q?rdMuyQ36IgLNncgTcyevvP6s77EUoyJn+RE83GF9t4pbvaL1/CTSzapiEF4n?=
 =?us-ascii?Q?5lC1A1Gq/35Vg14XCLmijpwPjn5yrHeHBXLnMwgukxx0/UopCX0zaK4bEb2X?=
 =?us-ascii?Q?G6s9wWGsMsRmdaLp5HUGnX+cI1CsVHJs3SuvZpkyJGTx/2hLDg+zxFC4oz31?=
 =?us-ascii?Q?FK9l7egvCkhXYDW5gFVIREkUFZpJ3BLCQsES8RiiruO7Ul733rTruzETaGqy?=
 =?us-ascii?Q?cL6AbE9If9cGjK6EHwf/mi5j/lsn/UW/nyXKP9KYlrhpLth/dLblR58QS2Oe?=
 =?us-ascii?Q?VdpmIKNpQPjhaWPxEadSti53ieEHk3fzgQs1sl9wleOqL4IrPmGygWsxPss7?=
 =?us-ascii?Q?ZVbsZH7RWfDbsNct2mVgCYiB2N+fTuB83Rd+8FQk5ql/YjdqHxwZtr0lLsFl?=
 =?us-ascii?Q?0KBrNA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181ef5a4-1e54-4b42-3ad5-08db256dfed8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:57:36.1709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GfOG5h7FRgZXkiE4w0IykZFkpDlN9n+OL6RXvXhB3onkGoGq3lszKCBYwINrtPGBMOELX1B0k/CTCYDUSOnN3fLM8lCCsTUdmHvLUstZxWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:35:19AM -0400, Sean Anderson wrote:
> On 3/15/23 04:20, Simon Horman wrote:
> > On Mon, Mar 13, 2023 at 08:36:05PM -0400, Sean Anderson wrote:
> > > If we've tried regular autonegotiation and forcing the link mode, just
> > > restart autonegotiation instead of reinitializing the whole NIC.
> > > 
> > > Signed-off-by: Sean Anderson <seanga2@gmail.com>
> > 
> > Hi Sean,
> > 
> > This patch looks fine to me, as do patches 3 - 4, which is as far as I have
> > got with my review.
> > 
> > I do, however, have a general question regarding most of the patches in this
> > series: to what extent have they been tested on HW?
> 
> I have tested them with some PCI cards, mostly with the other end
> autonegotiating 100M. This series doesn't really touch the phy state
> machines, so I think it is fine to just make sure the link comes up (and
> things work after bringing the interface down and up).

Understood, I'll proceed with my review on that basis.

> > And my follow-up question is: to what extent should we consider removing
> > support for hardware that isn't being tested and therefore has/will likely
> > have become broken break at some point? Quattro, the subject of a latter
> > patch in this series, seems to be a case in point.
> 
> Well, I ordered a quattro card (this hardware is quite cheap on ebay) so
> hopefully I can test that.

Yes, for some reason I was searching on eBay too :)

> The real question is whether there's anyone using this on sparc. I tried
> CCing some sparc users mailing lists in the cover letter, but no luck so
> far.

Yes, that is the question.
