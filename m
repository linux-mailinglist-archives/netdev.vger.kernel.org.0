Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424B368F0FF
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjBHOkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjBHOkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:40:45 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2136.outbound.protection.outlook.com [40.107.220.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AFE227AC;
        Wed,  8 Feb 2023 06:40:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFDyUEexqVv8dmfrspwjj1qkty0Eg2MQVrKOds8VkkLbi0j+A4IP7RHo/HemiYFxsz1XiKc47eM89RbqnorKN+R38TAg6CQZFOJUoTtIG45T111lni4XIX9KKE1kAVGZOR5JqA9iJ2S4CWyeiK3DaLp7+Vp98HixcapKeUexqTMjYuP18fgph6PUl9xHxwptFxNdt37i+upDw51BdhyoRkNpYToaxDrXDgMqdV/KMfR9Dd4qJGWAL4jZpv1FO3xcp3uImsRUdFP5B7nCdxd3xM4RdXmchd6JNSeGR6LTaXlKoqk1J09LPyoW5MIjAzy2J2+zDg+p2BGpEa/0rJYzqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDWVxNZJWH3PC+CXhPEcFw0iFBr10KeAL9230JlT35o=;
 b=gznC6U+CHk5HNUjbVi4sFTKJwyykWluiAE/s+HFscviGOy6yQSbfRhX4vQQhZBKLjCX8vot6GzjclOP26jho5TREtWMKEaJDVSMtzJ7/ftprAH9pTXyXOkV75fcSdNJAJA6//TRVy9lR1tJjpe5k3K2utrdDbGLZLxUKQpn+TdsYRFmoOkPP4hESe5TLj46TEuelOjGFyOd03X+eTLrtqR7VqiUS6/qTRUVj43qDbCt1QhmuJyUjJQQMi3m1eU56ysQnXN5x5DfF6PJPl8z5WxCLnM0DD5DecF3TFr555lvjksMR354UCxlmAYfqiDqKRcH/ZOc2A4/03g6InvplLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDWVxNZJWH3PC+CXhPEcFw0iFBr10KeAL9230JlT35o=;
 b=ZoMTPeN8GyeOXmK6jGOpjKnLkrRl4OWmg+2RLdGIMtIlSTI9v0wlu5A3doeyEJfYQ57ZYl6Pm+1sBZbeFbfIGF/CDVYFo76AVjt5gcbRJuypAe09azoVgkWivWhPUdmGo97VfVcLdHhSKmwx3hVwGtEM/r0912/eqX2IVteud2s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4545.namprd13.prod.outlook.com (2603:10b6:208:17d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 14:40:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 14:40:39 +0000
Date:   Wed, 8 Feb 2023 15:40:32 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>
Subject: Re: [PATCH net-next 4/4] s390/qeth: Convert sprintf/snprintf to
 scnprintf
Message-ID: <Y+O0YAcr1CXr025c@corigine.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-5-wintera@linux.ibm.com>
 <Y+JxcPOJiRl0qMo1@corigine.com>
 <63c6825fc2c94ad19ac7de93a6f151f6@AcuMS.aculab.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63c6825fc2c94ad19ac7de93a6f151f6@AcuMS.aculab.com>
X-ClientProxiedBy: AM0PR10CA0069.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: fbac0270-d2ea-420d-1ef3-08db09e2727b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kpNqPUjw1WarhxlEo/aBWPCoTY/hboGWRiXZtmsfoebCou2Isp7j4pKycPxn1oJhPb4i2waDJ2p8zRwBaLiN675zxH+BdNKH86mWd6XM03vhhfh5YloETKk6U0zXhEH4GXK39IAOdDbrTWAVjXNEZ59NZQeXPfPopWbdnkDyPPGypwfpI+snhM0D9cS+dV7FoabWlQqivWyk8EOjbeKylW2xaFtaAxjz86QNvnJdqUPcUTfZv0q3hacoIM8ozVB4AUhMSuYI0pXJbUtsDl0dtQW1iJvHzzz2esUHzBRYkk9rD3pae83T36k5PH6m8qxAPAFl2ORw39y+FluFuu42ZsD6yeUetYbWo6j1x8hc9PPPgWUYHEYe+74oXsvIPfsBL7jhPV44cZBbOXvlKPATSribXFV1ZRL/wOnArgig3oRQ4P64yN8vJFqGjNcxOHj8CIEApB9sNs4g1tcVS5Yb5P+7w8Dja2xUYXT9YFIrEBNveM3TNzvtdtVvkVacqC5Dm1ZOzCcq0ge1JBzt8sdw19wIzoJXpYxfpxQ7zMugGK8eqIcvKrSTG+3p6TUBBYXiVyGTOrQUmdMg4fhgGQRseITIwjAB7IVKw8IWtuHE0Z/w9OEZnBLUS9lkcfrV9deludRGBITqZq5wWY/rvu9F2B/OXP4KWceR3UBIB9QQ5OVoEPqQtSD4deibCzQtS1eRGt1wMV5oipQnqaJ5Vlkq/7oY8On4BqA4iwMu83M5ujq1oJdLsyNr0jg1whh357a4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(39830400003)(396003)(451199018)(4744005)(44832011)(5660300002)(86362001)(2906002)(8936002)(41300700001)(66946007)(8676002)(66476007)(66556008)(4326008)(6916009)(36756003)(6666004)(6506007)(186003)(6512007)(478600001)(6486002)(38100700002)(966005)(2616005)(54906003)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DhnFGhz37HTHEDXjapBUk8YmCHsFeiRKFmv84wa70u2gE6AcwDohHgJd1jMM?=
 =?us-ascii?Q?9zS47uesCz+08EAWw0bhCFx16PWCOIGv0KpZQXQH+c8pvyS8RzT6G+TypG8C?=
 =?us-ascii?Q?Kr1zm0XTEOobeltDWyPA/icDaib7pe9jogvIzcQEtjfwow4JakMYz3vXMwsw?=
 =?us-ascii?Q?HYVbOS+30yFWHAALhq/RD6xopg/5ZDC3s72VyaWzANFCRpKu5BMdUEOACFm9?=
 =?us-ascii?Q?9JApkWEdGGKnkUAckrlmXjXJRn8kjbflDoJOGa7a9NuvBre0gCrj8+DG8MRI?=
 =?us-ascii?Q?nNAV468bAurot98BOQlbYFpqCwsS4mbDdfKH3vUPgguqnhRiESDnz/I4J3Cf?=
 =?us-ascii?Q?l57yaSTTJwsuec5Qi8a/xIZ9hyaweRKRV4AZ5VBF3hzEjD7NpohaZ0HzMh9s?=
 =?us-ascii?Q?bAH/A+n17B5LKQrNX35kgfDoo5XTOJ16uUiDSqvl4yHGY1A4EbYcvwbwNyoH?=
 =?us-ascii?Q?46RpoFbpMpgTYPQrrnE35k7DlpyzBM2d5IFe1gmDHDA/jxeu6mu/5SLZdirt?=
 =?us-ascii?Q?MVuLGpX11s7ez0pwy/i9u6EOLYioSWUa2NK9YFuG3yEQE8f+cCF+bHpEIy/+?=
 =?us-ascii?Q?edTEeXR2AGWA00m9cfGaSJ4d+Hk/+6eFW8EudJSUwylHLFAdG3ksIacFKOWQ?=
 =?us-ascii?Q?FK0WdUHfBe8yhK8yQ4m6UNxxqjLzun3an08ST/sFlRIEebpr5izTPahH1gLD?=
 =?us-ascii?Q?459F6tpwNXJ42WNLdMi+c8quar8p3HAutLTaehrK9nyrQzKW3rorwk0JmAnY?=
 =?us-ascii?Q?zKhh94HySu9N1Xg/RgPrkuv1qOHKvg3kHoH1zdVWgPDhM7oBIyT+SPQYiFlH?=
 =?us-ascii?Q?Ph8gP0C2WqqOYxvDKR7t8F0ikh9zPNjXKaw5/e0XBpRHdsf6taB/Jdd29SbL?=
 =?us-ascii?Q?vEPhid9vafAA9WOo70biKfkU0PyM115T+oDZjI93KYgX3/sAuQ1P+DSP7y7c?=
 =?us-ascii?Q?dpdzGb5W7wJxfAPYBojTBqbqBSPbrSztR009/i6Cejuos307U0bTGg6IQnYK?=
 =?us-ascii?Q?RllD1P1Y1W4C4ldRVY11NCtWaoiTcpuGuXMomv0BzHj4e31ymf2R4FPedMHL?=
 =?us-ascii?Q?iASTeD/vKtSTEAIqteNVDeqfwZEi6Uyo8JM5pxyetAX3r3rAiBz2pHMAQFGl?=
 =?us-ascii?Q?wOt9gxGDk4hikhODZ+ojXSx9FKrZ1o4BCDwKRBX5cs74uun4MbwiD/MzqHme?=
 =?us-ascii?Q?t38PQkdEVpgRRYiXgG6EGsKpx5lxy6dKTjbMqR0UvpNN3hWJSp5x2IJZtems?=
 =?us-ascii?Q?YKMDW6fp4CFmqTZn8ysR4Uod0buV/Rkzb6K+FNYZVB1zf8VPbt/bTHYi5Tzm?=
 =?us-ascii?Q?CA1dG7OELh3kTQQfwtSUeHghvdJAZ5TBnELFnpuvqiEHDFCTi3NCClJ2y+D1?=
 =?us-ascii?Q?dBNpxkaaBEGPHM4EfuVURF3gyZZID4t2HIQ2FtMiS0mNas1mCDb1MAcWgSa6?=
 =?us-ascii?Q?OJcB6yuaWrx1q4o4uE1tNmfKnhiaDjyBeL61oOzVtbM5dQS6Hpyx5rqnmsei?=
 =?us-ascii?Q?OehhgW7QAaqe9/Ycr4ivERytVuXlqeMWwM4HFeomDmqyLX4VWnhzeAAH9IwP?=
 =?us-ascii?Q?cE90AZQkh7fi/0nKuV89JJNaES0OSRwG4A7q5P+LEj0/rpWHrelQZ8NsDP/0?=
 =?us-ascii?Q?nObEOKMXRQ+WD6XsGX6AxAhcDBak9KMddBb19c3jcEwR/sSqb8BxJqrwDYGO?=
 =?us-ascii?Q?Wt2msA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbac0270-d2ea-420d-1ef3-08db09e2727b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 14:40:39.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkQV8S53uIby82y0xqQL0oaQV56r8yQhpxu5OiWAY7RmLQSdC3NoFykJQzNHiUdCoISs9llwhH9yEseaIwqo7z7wPXOzzfzYPZZ62kXQjQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4545
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:37:32PM +0000, David Laight wrote:
> [You don't often get email from david.laight@aculab.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> From: Simon Horman
> > Sent: 07 February 2023 15:43
> ...
> > However, amongst other usages of the return value,
> > those callers also check for a return < 0 from this function.
> > Can that occur, in the sprintf or scnprintf case?
> 
> That rather depends on what happens with calls like:
>         snprintf(NULL, 0, "*%s%*s", MAX_INT, "", MAX_INT, "");
> 
> That is a whole bag of worms you don't want to put your hand into.

Ok :)
