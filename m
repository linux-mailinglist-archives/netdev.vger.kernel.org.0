Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999A06A0907
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbjBWMz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbjBWMzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:55:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2102.outbound.protection.outlook.com [40.107.244.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F67F4499;
        Thu, 23 Feb 2023 04:55:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZ3lLvNZcQ3kWjWTrliQjnN0/k5NDuiaJS7kfXFNaMaCONdkDy1fLP5qxW9N5NKSKbN1sE7zn6oCwOHVYqak2T/LonbH1/QrAkWzUnZOXbyJ0Dp5vrSBh3uAwtHlwK912y7WuKtzuRWEeJcGA//TDs9nirnvgA1EoCFXIJT8QXY+BXBlQPdz2zDXKet8wLMkJ63y4/CAVYm2nnMoQFdeDBcFEIA2HJ0KUzI9FzdCOkAipvFXYpLYcKAOWru+HikZNvnf9kWzkFJUD+6qtnTX7j6CUpUsGlavSeGTJqsE4FkKIZt0MtvJvgh7HwdLnf93BXFES3HOzzivD6e01lLHfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kj6rQ/tluF3mSdp5ln5hILL5CMbSiy9uHZo303zh7o=;
 b=eLY/+Pka9rQF+oe3iS3T6MaewocLINb47mRgU3MOaU0HpLCejiEw5wansemUxvETOqcb86ShvEo0lEgUSSwTqgAM1Qq2555r7Nv5dz/rlbh8f0/uO41CkngRvL5o8tYjPjy2tY2iGgoLXG1dzZMOtTBp0FLm2rJz05qTs3h5BBNZKfra3SEfLf25jJ05SMgiLkYPMZo1SMRDzVzJ22wxPjyghELacbPt6BouLC7FLiYiB4wCJYZGwVWJGAFVxn0Zzuj7BmKuLcr2ESC34pZA0NhNIvhOsJRIwPKLtqqwluN2Y0Ldqs+Qx3jfROF0tLPZtGn6LtgO9fYlWCDP8HwK5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kj6rQ/tluF3mSdp5ln5hILL5CMbSiy9uHZo303zh7o=;
 b=eN/Au4bOwxNKFGiEg0GBKkEIoxNHPE5lOeYO9ZPz+e2UsNf28Kt+wLXW6mdByISxO/NBK6mfbLi/8loflZ849hLjmrdlRxuC+0a3eQnst/AIHD+kC2Q2lW+rBuyFMFRVaT9INuiqjux61aK2r7hp+b0ejOM4FTt7CFV8jjj0dNk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3752.namprd13.prod.outlook.com (2603:10b6:610:a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 12:55:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 12:55:48 +0000
Date:   Thu, 23 Feb 2023 13:55:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V3] net: stmmac: Premature loop termination check was
 ignored
Message-ID: <Y/diTAg2iUopr/Oy@corigine.com>
References: <87y1oq5es0.fsf@henneberg-systemdesign.com>
 <Y/XbXwKYpy3+pTah@corigine.com>
 <87lekp66ko.fsf@henneberg-systemdesign.com>
 <Y/ZY/o5HvNCPLfFg@lunn.ch>
 <87v8js4nqa.fsf@henneberg-systemdesign.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8js4nqa.fsf@henneberg-systemdesign.com>
X-ClientProxiedBy: AM8P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3752:EE_
X-MS-Office365-Filtering-Correlation-Id: dc75447e-548c-4cd1-80d6-08db159d4912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uu4nPY0UErcKManP6KxDVg28fCH0LzH+o+tgA7RAWV3M+3fTdKzF2Jh4TGkBqb5KuDh/ZE2+P0e+BtBFPzDcXaorpK8XMX0oNhPrCMxtVCVwntSX0C+2fS3ZK0gv2xyNwUOkEpNSjIogcFuRDG7irykpZDDESU6scL7uOykYtfNpzLWgzBHmZYnFHGaWMQVaxuy0gbTJRBNYipG6iqHdbCa2VNwlZFIJo/6SvTa3LdJfKYRYo/X5xBmX6W12NbawUBZQz5FLCrGul0krfaPmjDUVIG8HMQbaafq2wafrL8/MRJOTJU9ZFtshNPIbegmLw48clKFm47Sm1P6IxhkHQGxDeQ1RSvqmRKOvGn2riOtLETDnCpOAikFHJj4CplH8pGMTdeML47YEuFcojsm8FXXidgv6IzOs5HIPehAPJWHSpyRUJdtoUfKB6knAWvKRA760kkiQ8JLdzb0XILFp/RgBnDSD+1F5fTfWKGFky2IGLUSJau5xA3MGHgBXLF/7vuczGsDw4vhLQcVOhqqAIm+nPJq9DYVO3yr8o9TDBfrWUr804ciqAuk8YJ2rOJdrbVF7XAAumGcdHDhSVE4PDaXsQR+lmXW59DIg06bnp3LdNMzDJJ7JlGasEAPTnflFKIOScWM9uFljO0toDT5y2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(396003)(136003)(366004)(376002)(451199018)(7416002)(44832011)(2906002)(38100700002)(6486002)(6512007)(186003)(86362001)(36756003)(478600001)(66946007)(66476007)(83380400001)(6666004)(54906003)(6916009)(4326008)(8676002)(41300700001)(316002)(6506007)(2616005)(66556008)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fB1SVvq+0y2Qb4ZMhiqeDRP/oR0sjcVok3OhZgKsy90nwZqoJE4hTknzpegS?=
 =?us-ascii?Q?A8U3y0567/K14R/24ieAB97Gr3ga63ndNbyrWJ2stm3hSgq2WePQ+kkPr1nd?=
 =?us-ascii?Q?yrzbjD/RZFKP8D1egB9G8jEENwAoVOVcQaX+gwr3wBcrPUxgt8q1MN52+npU?=
 =?us-ascii?Q?RJhOJuwComLTEjcHMrWkONiH/DdqQ9Rn96aYwRsGp+HzGqHAuCnLNlCFZKVo?=
 =?us-ascii?Q?dFclDzLEivrIyWItFWOcUEESzGz96ouTXxwSEqQgdnlFtl+OO7ofH0ZjD0Vr?=
 =?us-ascii?Q?x3ZLYZKwB9cIfXEShMME9cJOagcr+4CfvZg9EORKa5nil187nGPpGASyqGgf?=
 =?us-ascii?Q?l05zwAbtDp3xbaVP00lDMyAe+PDKDsoru0D6XES5QMnGMHLtd6JnZp7EZs9H?=
 =?us-ascii?Q?C1VQ3csnN79adBjzlbZ4SxVVR3xhP99phGEfuP3dCFpwF7SaEmGjJsSBckVI?=
 =?us-ascii?Q?WQvh+eHEkEhTBbiOY40TfntwII7Xp6QKXnRfWhVugVIRorBi0MHjalG4/a60?=
 =?us-ascii?Q?z77XBMtqHpXQunRAIirkD6thDTHfCbyKMqigkwnS1XZqWM6S0fYKvV5A1SdP?=
 =?us-ascii?Q?Q4LT62ZldRcdxYE4xQO5Yc7UT9dbzbGKUyIS06g1FMs3gnMNLPFnfRrP6Eqf?=
 =?us-ascii?Q?rPSPxbrl3u9cyKRK1lp/Hkw2mn0M9rjX7YDvKHsyGQpbIusSzepEO46MqZaX?=
 =?us-ascii?Q?3xJ4erDoEvziKJ9xyIJfW+zLRmv3zFYei6TZ4WiFTxBmAuIsbedVywl7TTRB?=
 =?us-ascii?Q?ddjErc43KEA0I3XybEnN5ewpZidQRfSjWolmOT7S2cN68sX3b/chMNNy3Y2X?=
 =?us-ascii?Q?GmbIiW2af9y6Af8PhBoqYQAyXp/bleD1HnqpMAhLIsRvHijm6MYqjLgX3f29?=
 =?us-ascii?Q?lB7usMLYwa6nJY+uBAJH7+oLu6pzV6HSq8o84MN3HaXhnEKgFrn7TgHxCVrV?=
 =?us-ascii?Q?NcKQJCCITRZdfC/IxjmuQxEIqz9N4VMogYKIc6Gcj6D+L5kRCilWTOu5bAGz?=
 =?us-ascii?Q?CDqvvA4iYo1Nirm3lc06IK7sMYROQ1iiF0eha+aZ8+//DAnaogIUkImOTYuD?=
 =?us-ascii?Q?3AROgCPbMUpJow8lgSPhKmLpekNhHKYU3UYYKTvAlfi58bdyAmoa9RgGayH/?=
 =?us-ascii?Q?/Hq4b1stlKmHDQIYh6lQdMvoRAe1+vvUcjCFSmOeolHMg0ys779cc/fGSnzV?=
 =?us-ascii?Q?10YhixIf+XzL1rvhI/x5Xc0U1LKitsw6FHzJmLOyyl0gk0rXSXcZ1vKmcm9D?=
 =?us-ascii?Q?A2HXgkd3oHHEMA8mN5Yr3uxYnP7vJ9BbRho3dW5qdolJOcLTVfhnTD0lFo3S?=
 =?us-ascii?Q?jeZEBQ7ubjCw4SgUUMuAPiGw4C/sKt6THXT7d7DxNIou+7pe5QJCl/YZBoGA?=
 =?us-ascii?Q?tcQsIclGixLyA4E2S64TEHK/mtBnp6r2IIF8VF0XdzKBPLLZ6Aos+AJJ1T37?=
 =?us-ascii?Q?arx2Az6EJEJXsueW8zbEfEKzQh5VcVJU+NQBgCNAq3T1me0XuVmDN8SsdZt2?=
 =?us-ascii?Q?2TsO6rIkrWLLoRagDB75d+eoJs6PXfgn6JLsk0psQKAX9GQfaH5S/a5aqJ6X?=
 =?us-ascii?Q?qsUL+7yQ+g6dGVa8/C7Pi61GalFBIG8CIoIbFrc62QFSo/AyG7aE3ze+p2JL?=
 =?us-ascii?Q?nB7KX5zO1sF95gzlEPD+QJrQQG0jtStRZOrWKt4ZeUYxR/6ZYJW4u8+JhtYg?=
 =?us-ascii?Q?wp/9vg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc75447e-548c-4cd1-80d6-08db159d4912
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 12:55:48.4617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9lTuLz8Spbd97wvwGlI80I/VyLpi+F1Af2q2T9WHDQEJNIBkc1EF/1heotXO5q2JcPR2WqzMMDbp7hGKRANz5Q3dgcdjAl6Fm7zYMsrIrTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3752
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 12:34:18PM +0100, Jochen Henneberg wrote:
> 
> Andrew Lunn <andrew@lunn.ch> writes:
> 
> > On Wed, Feb 22, 2023 at 04:49:55PM +0100, Henneberg - Systemdesign wrote:
> >> 
> >> Simon Horman <simon.horman@corigine.com> writes:
> >> 
> >> > On Wed, Feb 22, 2023 at 08:38:28AM +0100, Jochen Henneberg wrote:
> >> >> 
> >> >> The premature loop termination check makes sense only in case of the
> >> >> jump to read_again where the count may have been updated. But
> >> >> read_again did not include the check.
> >> >> 
> >> >> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
> >> >
> >> > This commit was included in v5.13
> >> >
> >> >> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
> >> >
> >> > While this one was included in v5.4
> >> >
> >> > It seems to me that each of the above commits correspond to one
> >> > of the two hunks below. I don't know if that means this
> >> > patch should be split in two to assist backporting.
> >> >
> >> 
> >> I was thinking about this already but the change was so trivial that I
> >> hesitated to split it into two commits. I wanted I will surely change
> >> this.
> >
> > The advantage of splitting is that it makes back porting easy. Both
> > parts are needed for 6.1 and 5.15. 5.10 only needs the fix for
> > ec222003bd94. It if does not easily apply to 5.10 it could get
> > dropped. By splitting it, the backporting probably happens fully
> > automated, no human involved.
> 
> Understood. Will do the split and send two new patches. I will not
> continue with version upcounting and not send a patch series but two
> completly independent patches.

There may be fuzz if the patches are not applied in order.
I'd suggest making a series.
