Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1805142D5
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 09:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351499AbiD2HGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 03:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiD2HGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 03:06:15 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2112.outbound.protection.outlook.com [40.107.220.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA22B822F
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 00:02:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k24a6E+C+oxvxhrMRKHFfa7A9CXjiuHInUF0hJ3uRMyguaAPYeJF9puJqjCLwDSX4v0bJMZBiDv+gPuFisBvkxrEgYu0RJEyg/bXfqNBsXBxCCCh2RBgR4XKWZjtnH783kJ0Li2DtZ4AVT0l105rXhoNXt5GSuGM08UnLK80098RwnxPViLL3e3V1/EhSQEfn356oz2YWASC7hTe9e9ePBrrszYP/LoBJZF023Ads8QdeFbTqBurLH5jCT/QKpoktWnSEVtuvqTelIDi/kTa9Lhdf+VIJIOsAtqI2OysDMK6BUQ2pE/xKAQE0AlbOi5dzo7UNERyOIK1BgE75+384Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jFvEoPflLBmu2GHYFAWkOGZzlg0kjzQYiFouabpDkM=;
 b=XOjytTwRrDIOtG1JFpofLMolW3npvMg+cezvbLKHwHIlmI6IzRcfVuF8PuHABW4q1yQFcAYxBV3FjbIucBmlumOw2C+VAxBAVeyv2b1UWlBlwVSw9EmLOhc8wlrUdPu446HEcF3V3/O73PwdNTriq3DE0VJnbcL4ZjaH21BHVJqVQzxNvoddry7hEzy/emnyZ20WHPiliIjYdpKhksSk37P59ehRtNBGwmgZmKoSNwFGsxxcrFY0rC+588zNP8qGM5lKWoWH18xcGcDc+0eYOML0CDmT7Kzr8b9YIRhDaWqV9cVqFoy5Fy8u/BA8tKbsZ1RC5rgXFmuQbpCP+7zwvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jFvEoPflLBmu2GHYFAWkOGZzlg0kjzQYiFouabpDkM=;
 b=doEColXFBCypMK0tMp4qZ6CUx8GXjXOXsHwHVxLic8v3TZNEwo0a8xk4k+3/gR/Aco1wZ0jF3ri4QPh8xfIBy/FRizVDCoUkmezSbYWV7uBbZq6aNSPipco4fHHJ5FpZrHHWKqODO4GirX8nXHw5RaoK+Sl1pffUKGQ3ME/3reo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3668.namprd13.prod.outlook.com (2603:10b6:a03:219::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6; Fri, 29 Apr
 2022 07:02:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Fri, 29 Apr 2022
 07:02:57 +0000
Date:   Fri, 29 Apr 2022 09:02:51 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next] nfp: flower: utilize the tuple iifidx in
 offloading ct flows
Message-ID: <YmuNm7e7RoTIwuov@corigine.com>
References: <20220428105856.96944-1-simon.horman@corigine.com>
 <20220428154646.7b9d85cf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428154646.7b9d85cf@kernel.org>
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 653646f4-c1d2-4578-c463-08da29ae49ee
X-MS-TrafficTypeDiagnostic: BY5PR13MB3668:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB366839982CE3E51CD5E90308E8FC9@BY5PR13MB3668.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYUg/FY0KQbjQqzvihwa2eokigFfty6u21bnRnfbqbc4jhjy/ziLEz7fO5CPuSaBQ19dBrxI4YLY/iL6FALKqSm8VcKzcibWTZG7b4oZdPJVh5MvwIiA9+JKysdsXrvAblEZ8b/qQ5WBYwqve9ZHukk/7oXItuZQcbNV0aXuoACMjQLF01J3B1Dp566Z7Gqf6FAaJUmxHZN6OI8MzJKKC0xbHkmyBeoFuELap6GTgjUpoUaL8DJux807swMvCkDHZupfYljo11kPD4os9ixNrbcbELYxvYILwl0yLPyu8kQC759Ut4h141ZR7YjkhOvtWoHHClMu598fM0Eb2aEGKDwHFFFcvmcTbKwGCBjWGM3HgG8tYmf2uV6ez43RClCyDFg/WyO7ukhVzNAW+0sQBXsNHwg7e0gL75POZkgSOT6HSONRoXQ7YSScWM6CqtslVdprBl/J4e5kGILd78+ZLDJ5B33HYkcRhJbeX3om/Fa7o1hwNVQfU+0g/0VvlVwemm+FjfK9ImbzznK+At50ubSJbL6pyEx02SGjmyBn0786DbTdBUIZBR9+Kc/dw5NN19VfR0ArrQBnqTngBn7Y5QZxO34iyzp/ooaf1Ije3cEp3CmbNvkWsohMTDf1pH4Hw3LZ3/JbN57xbDgc5KvEHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(366004)(376002)(39830400003)(346002)(52116002)(6666004)(4744005)(44832011)(508600001)(86362001)(38100700002)(2906002)(6486002)(54906003)(186003)(6916009)(107886003)(2616005)(6512007)(316002)(8676002)(6506007)(4326008)(66946007)(66556008)(66476007)(36756003)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iCtcUvJVpXj+hTT9zZiJwlHP3sZmHcc6eaDp4OtjuPbSx8LwkkVwQ9EtO4Po?=
 =?us-ascii?Q?SkhNvQC2egsqJL4HIPwrjukedITRGOsaU/IzdG7R4Qzg69Nefe76MkKlloyd?=
 =?us-ascii?Q?ZTz0M0oCGQKeZLyr5T5Xv1X5ujy1d3RPSbSQ7M0vK7z0rq/cky+3HwptbiAq?=
 =?us-ascii?Q?BRGCAqAikAWYnMQiLMVfcd9jHNZWETxD80GR75EJ+Aonkj6YGGcq/exyVvb3?=
 =?us-ascii?Q?akplUSDpZUAI+SjZXo0xGuFFDPy/EYlu4tBlUhmQ+8VXztzdM5IWBMLe5AzC?=
 =?us-ascii?Q?RMH9QfvJh7fPvckcOyJtGd89M4n0Ri3wtiT8ww07rIbroH3C1VcONO0eSJoA?=
 =?us-ascii?Q?KBmvTlAbi6rwHDz0T0eIls+tzmst/Bll9o+/eWXrF7B/JEFm9d0USpHpjNER?=
 =?us-ascii?Q?pvbxA62ojsuA/eIJouG8WaA6fYvhmHXP/En6GQprH0clSWN+NcVeblIT0khb?=
 =?us-ascii?Q?D+NUiQV/9kWJK992F9lUoYYmZ7mx0t0XF/xKy3rmpPanWCqShLc+AAdA2gKW?=
 =?us-ascii?Q?bzY7508yGedQ6/7zg20OXFtzjUMf2t3hP4wVBrhrRQaTQsvDstXOlLQaR8/y?=
 =?us-ascii?Q?tuf57NHywYEmR0lX3unzHdPezU59pTMGt31QfZeArJNAGyCS1WEJnddvCHff?=
 =?us-ascii?Q?InQvkg/MqPABUV2JCEa1F3+0IU8qutXVyTSbEYxSfgNTM175lu2OyfqoWrBt?=
 =?us-ascii?Q?q3+jgLpgI5h/CK8IGbtQJmfDrK+QnmWFcsmOnYoZSalxABV9mPGcFxtkJM1r?=
 =?us-ascii?Q?Tpu70K6lMzc/R7mJSNLJmTs+eSugS0Z1zC8Z2Gnfnonrg/RXdt499BRHCtds?=
 =?us-ascii?Q?U+SIiUVUv3vl34bKu5nfajJHPEknJvb00vy3/nqUycZL4eh1myqk/TXiPqRL?=
 =?us-ascii?Q?bEzHGapBcClMsEmy5PhBIaXBqSW+bq3QtGzejjpvzk9UlId/VuDibxOOv2p1?=
 =?us-ascii?Q?OmwCVnENTH9LO15HxtoCEzeBioo82P63S71w2RGd6uuo3lPh8RuqiqCr5nDi?=
 =?us-ascii?Q?tlA7xXj/XVXKCshFFWv1kAHflhrmLz+OVqNtQjzGCf4/RgpDfCpY4RBC+YUp?=
 =?us-ascii?Q?NZddInQRvYcGOIgDUdi3i49lQxGY9J5gqQSU2UeTECcyClNWtOCHpzSnxmdm?=
 =?us-ascii?Q?NkwbMttRe7maMKYRuX7/jzxn9JQI43Ju0repHHSduUzZnAmm+Bc5PPa6mmTq?=
 =?us-ascii?Q?awdqamzujbNiMwGtCmbw91bRttVavEREPMQ1eS6ex0bDXOOkLzG4KzFhy8Vw?=
 =?us-ascii?Q?gDZrlPo4KDBmIKQM8KpD3lPBkjtFrsJyXan5+vQRtqomwK6OSdYQOB4QUb4t?=
 =?us-ascii?Q?+rS5r2pEdXTPjcGti6gUgyGv3rhNLrlj++bRk/QCWBTc78RvZh5/tJGkOMp5?=
 =?us-ascii?Q?5SEL/qXMExHz5OSCML7iC8qQl70A8FHPLp2HDyJJONk1i9ZuaGY2eqxy8YZu?=
 =?us-ascii?Q?7yp9RoCGR/7FhMe36ROWZYjnpIxqVR7jUcKfIfjGQq3H6xwfVcsQZJ3emmTB?=
 =?us-ascii?Q?yXre7/XQIg2kQRfyOaubV60KBk+UHszUmt8RgjsXtdmlTp4LEbLSi/wLDAgr?=
 =?us-ascii?Q?O4uB/igCCh27OlbPIxT1rryr1PlahXXqMQKBD47/IcMk4sQiCcSToPaNZjon?=
 =?us-ascii?Q?tj6dlcWq0Rb3FOoSq2mD3AJRSZd7Xgop+OWq1IRsrlAueq8T83YPKNthwRZ3?=
 =?us-ascii?Q?CEGhJDYm6yYLMkjgF60ogRFP5bPKQsZWlINMBo1I9DgyJhPa3WphjTTXW3yP?=
 =?us-ascii?Q?12ujBjz7Aa66zl5iwcbtT5yjw4dV9WewXxaJi6C4LDhMeAsAtYW3Z5sW8ZdQ?=
X-MS-Exchange-AntiSpam-MessageData-1: j4OmUZFN78bnAd7Fqefti5Rl2u/Fbhm+fpU=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 653646f4-c1d2-4578-c463-08da29ae49ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 07:02:57.0135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I431xu8fgfD3pLyDe/e/LKWjuYDdF/bnqsENcPbL1u1s2eHiYuftxDP5z0WdDcVtqIaCcOTTbrd4KkwW39k8Q+xtljiPwylnKnnjy+Grpmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3668
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 03:46:46PM -0700, Jakub Kicinski wrote:
> On Thu, 28 Apr 2022 12:58:56 +0200 Simon Horman wrote:
> > +static inline struct net_device *get_netdev_from_rule(struct flow_rule *rule)
> 
> No static inlines in C sources, please, there is only one caller 
> so compiler will DDRT.

Sorry about that, we'll fix that in v2.
