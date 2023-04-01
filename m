Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027206D31A1
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 16:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjDAOtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 10:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDAOtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 10:49:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2112.outbound.protection.outlook.com [40.107.223.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A61D1BF52;
        Sat,  1 Apr 2023 07:49:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwtaiRml7EId8f7raBJ9ZCD9gAAR/MVSY+vpOmULSMAEPn70U5izLUWBGuFrdwUZnID50/66K/2fWbyg6IooqSnvCc/3gmooKD3vQR+pmjFlIXo3Q28tLOyokNpX4yLyd6Y3hJjUogtQx7lucwPoO/lx8FUTDlgUZOXoBQa/LreXiF0oZoAioFXFR5wvkFpQc9uOcIm6TPYK9NIOGQUdDwx1Ae/8ruvhbd4/a2/LAfEWW2QJ7sXCgz0HKfq+7M4Kpnq1qq8YpXFpHgC1iueL3GKcifN8zK+L+azB3ndbTRh9qWj6vzPAV5vsVVirHqoUYc2pfA+Mlpl2wyMhoB7OTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8tPGns9u1LHYEJDXsVrp8jTEj5uw5kl/50uPqdNdrU=;
 b=KQljiPk/wh8p4QDaphKLAQDZlD1N9QKSUpPlOj6fcmJ/4Y/hVcdStjZ2GtgqkA0gDe6BRAICkmFibEN435onp6DecvHMGkwjaYkGTU2P3/d+/GHUNZmZ9yWwLjGX8YAbMc/lRpz1RinG71sWpzvLc+0G+BmvdoqRrzFGttlUsuRhvr1I6i9B7F9kmRT/pyc4gIGMQXzGxbcft6S7pOCBuN22Mu1F7L36x6MSDWFOh9C8tPySV75ZNsoGbk9cRGLZdd2FeTf46yNgEjABaqWwcN+5eLPEkU6ruA4cRIy0kP89wwDUjON141C9sObtwh2StNOv4gpLfuttKxMOKO7k7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8tPGns9u1LHYEJDXsVrp8jTEj5uw5kl/50uPqdNdrU=;
 b=n5RX9Lyeeunmw+ix/4U/S9dICyFscEDzfPYbdatuA1vqj8ShqMlPaJTrzLsEJVCVNrfLkEyPfr6gIPtDElIx1bM1E2cbCgNPXS7cEBTlCTh5fq5JNLOmQJ7qQE7X3a/MWaTFaKJ7rt2MLdDIDuSR2xSwrLAlC53HxSsrOW1iSpU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4789.namprd13.prod.outlook.com (2603:10b6:303:f4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sat, 1 Apr
 2023 14:49:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sat, 1 Apr 2023
 14:49:42 +0000
Date:   Sat, 1 Apr 2023 16:49:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v3 07/12] net: stmmac: Remove some unnecessary
 void pointers
Message-ID: <ZChEeuyNJlL6mpPC@corigine.com>
References: <20230331214549.756660-1-ahalaney@redhat.com>
 <20230331214549.756660-8-ahalaney@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331214549.756660-8-ahalaney@redhat.com>
X-ClientProxiedBy: AM0PR01CA0161.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4789:EE_
X-MS-Office365-Filtering-Correlation-Id: c13d6ede-b371-44d5-701e-08db32c053dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y3PNvaaOgidkmlTqtTdyUnR014FAp8yirt4yodcgiqkOa4/DVqYhaLOQ0R07s5NOpd1k307p9J31bnoj3E65ww6lidkNkMZlhLUjPvJoxXPL/sBMxmbdNkNW1M2quVHpn58mcF9Jz4xfd++ha+zywXe8pRHQW4ct98A6NYA07aASEV30mHMaV1y6dBa1LEnKQeP3KZOXLYq8c/7u2RRk0cAdMknfjWZcoMy5cWKU+mDrQpYw2x+oh+uGMEZLR2cngq7c9bIpGf2trl+C4bR0dgFtynXVam2IHrQHGuEQZLNmcf9ms8tXkJRKaACNehg1TunmvWtPD3XmvdnE66dSFdsjvWCg86mF7X2vpOG6IyEKciKWIfrAMDa+Me76+lpps77VHapgqthCXInIsgT7b5rS3gpWl4XlKfo40wh28YbLFXKXkN5eGPK1GSnhNnV/F3u3Guc3Q0GyqVlUPNmkhYIp+3s8OctEXhN1Rhbrqy/PQNczldbAi7bHfQJ9bIT8m3JLiF/TLFvTQaZG2CDCd0UV+8pQdErtqnoYWZ4IiqObFL0f+TSg+6gAptFkD1HQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(346002)(39840400004)(136003)(451199021)(36756003)(6916009)(316002)(4326008)(8676002)(66946007)(66556008)(66476007)(6486002)(478600001)(8936002)(5660300002)(41300700001)(7416002)(2906002)(7406005)(4744005)(44832011)(86362001)(38100700002)(2616005)(186003)(6666004)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?njKEqOpGFwUjeuyewXLj4yNrQYSiUXx65JT4j6MQAjPlmquSeC0SGard5F+9?=
 =?us-ascii?Q?PfJ0Trs7GsD/bCWb46ZkEH9m5eoK92oTzMXq6O3Krvm12fJcY/YeC49UjIin?=
 =?us-ascii?Q?Wuy17ZQMd1cWAN07luyzcAA5REh25KnK2Ge7HhpplOl6GVWEWhAvfmyA9zPd?=
 =?us-ascii?Q?J2YIAx+9EW9cn85ygiqrO7aFppgHVe8mALRLzatKySpSSY19krN5isobYQr7?=
 =?us-ascii?Q?JPyQ95fwPb/5v6dzuYowaI+eu8f45BTZlpJIX3KitnFCt2GfIcpdzUxluVkR?=
 =?us-ascii?Q?DULcml3HsAFoMBL9vrnwaipiBixPND++zv6a7QawnoFxmdTl5FTzK4FFA+wR?=
 =?us-ascii?Q?j4+Unv5/8iQP3elKhwxZRV3FlBByoNc1kI8Hcg/J+cMeZ1erdaBHOi7XCUKX?=
 =?us-ascii?Q?PY76iOIlyRLdcMDKYIWfQm+ugca44pIqp2n4FDTP6ohj9BniTJjE/hiU9xsi?=
 =?us-ascii?Q?HbMVZ9zQDGcRD7E7Eb6XWdMbHmeV0vBLXTdgn/zRufvG/FR6kF4fhpoXR0Oh?=
 =?us-ascii?Q?OcdMWLWCX6wmuRyftEaYzn+B402/2hVND/Mu7J8+kX8S+CzKAEfRoaQtV/I9?=
 =?us-ascii?Q?KfgJnNvUvtBHu1Sou6jVPoyw3QXNQW/LHrxApRJnnGlUtlIczUuz1gc/Qx7y?=
 =?us-ascii?Q?6bujcWEA/yUq5mCMj3rssX8zmM8wgBigMvGuQg+i4m7zn+LjemmkwyBB6hba?=
 =?us-ascii?Q?COxz1wHmr0UgUxv6HEDLGCmBnz2Nra0SBeH2x5BuPreNM0skhQSStd2W/Yq6?=
 =?us-ascii?Q?E5d25IFdPro12sVrzbntwOEi0CahA3O5ysCRBJe7wPW/HMQR0wKNN3c/+HQ0?=
 =?us-ascii?Q?wvzpdtt8Wk1FJwnKPv/zSsnYxPRQ7btInUuoJ+QdXRV5kzoiTugwtJJLGtgQ?=
 =?us-ascii?Q?kfA3eTJxsoU/4ukA5/Ec7NakWlK9PVE0c/e15/vjgl/tT83OSfclgdBe86t1?=
 =?us-ascii?Q?c+U3G+vdlhq2swVPR4FEUMqJmF2sEKtiFNGYlAhCY1ANWslwuK2hZlXJRd6n?=
 =?us-ascii?Q?YYrlsGof/RmX5y+USCk2aj7VltPLhxnu8ckmhT/u0RsEo19CPT+Ds9dfDRvy?=
 =?us-ascii?Q?YPvaruGEqKv5rQMn5ryfIdr9CZz0acJa7gtQW7YPe3rN0VRnZTatOUKS1Yoz?=
 =?us-ascii?Q?/cX2I2uq7X3NlXiLxuojQ/9661hQhcUytLhcGpEWCnmPc2gaXPT3Jla/0RjU?=
 =?us-ascii?Q?VgAjypAjavMhUWI1LGf1rm0KlyqGPvjaMDXzl+DqeNlmDpWtzHwor81ZipR2?=
 =?us-ascii?Q?eE5m1kHZ5mPXyvSeTghUzNdYKLipT30pKHtCf4OidzKRpWyNIqD/m6K8wENC?=
 =?us-ascii?Q?cHUroQRpQzY2dTxWw2innYrNNiROyLz4+drTLfbrk6j52p4RoaBq1Ftzkpq9?=
 =?us-ascii?Q?lhYVcucdt534F6/LnNK3rswm2f292Dq/5xD6cWG0ATnisy2bDWx89uhymGCx?=
 =?us-ascii?Q?BMlGDyIutohzvQBnLJbbhE+Om9E5LakOp73x8/52azQk0mxvcvuQF9tWriI+?=
 =?us-ascii?Q?MBqXU03mCvoW9pKyS0n0R2vRhLZEyVsucJujmmCq7EXFvUJQSGFNgFJnU723?=
 =?us-ascii?Q?rUxiN8ob4DgiquLMHwfO0cCW6YteqYrL1d3eylfvj5q0iHSrIg1I5+j0wlya?=
 =?us-ascii?Q?45njv5nTKwcqBe2kSW4OIhXmLX0fE0kevwLp13A9FqTUUxu4H5bnBSXkvhqD?=
 =?us-ascii?Q?jH3VqQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c13d6ede-b371-44d5-701e-08db32c053dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 14:49:42.7524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0TY7PKpuuLD9VIQKJm8JCWvYKz2XPwq7GLtFdEirzO5Yr2uTFzTCC9fGdMlyf87++NUGMm6wsJYkqQEuBFZHFzbexk2f6sSWTwJP4bPQPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4789
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:45:44PM -0500, Andrew Halaney wrote:
> There's a few spots in the hardware interface where a void pointer is
> used, but what's passed in and later cast out is always the same type.
> 
> Just use the proper type directly.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---
> 
> Changes since v2:
>     * New patch. In later patches refactoring hwif.h I touched these in
>       their first form (which was later dropped) and changed this as
>       part of that. But I thought the change was still good overall,
>       so I left this improvement in the series.

FWIIW, I am very pleased to see this kind of change.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
