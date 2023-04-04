Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081366D6734
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbjDDPZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbjDDPZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:25:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36291449C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 08:25:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbVIwGsHwF7jWd6Y97PuORpDFYhELS3GlQdYsA+cxFfIoO0E4fQCSCKl0lhEiYM3hbbrWlKvp7em7SLT8Qnx3t8gjvL3kSk97FPQnMfKOaJyAtd71X2pk3GswsfDvZwnSMHhzm3+q6BtFfILHWHuKESIjngO71gbbJbzvGZtu096y+W1XgYY4astN2OrW2pmKzK00wGx7vL5vZz8FxUYUr31U8+F2hAvGgtR/Kcsen3bRvs5G1pWgKmKgxcGpTOAMKGdR2sggiXhmO8msH7D0Jkjd2zbdXt1J6OTWWX8vzY4/x7cmRevngSTAlKdTek6UQWa9y09+HdDqb8zeM0XUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbT1IMs7/MIpAC6JJNnyBThRoVIfZNpUazmS4iufOZA=;
 b=KYRw4xUsr6RdwQSRlJvqlgU5Mig3L0PKk5TQgaRUoZARpgqass3xoQFqIXrncsSNIeZRXT81igGL2OH2VuWxRbgpn1aih3SHBp+m9P015b1CarY+tA9rUH5fnvpPSuzKRUPoFpiC/EyUzH8tWB/0JBW1xkUym3J+jBbMiFR1jUX/zXOWGzsrirJ73EAFwY9dHXZsiplx0x9XVhAoMsw/s6n56hzfLQ1L5njvVGr//+aOptMLDC7flX2uosNBK7MtnMusgcTu0tHhj0cYHAMCK5EvelmMMbS3MafKZVNnb6mBiCFV4odUXWvK8ay8vAxSH5SaObqJH+NN4GyfhrFNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbT1IMs7/MIpAC6JJNnyBThRoVIfZNpUazmS4iufOZA=;
 b=ihuxl/Ij12rb0FlSIdcLpW6Sq6XPN+gY99FBFWW9u2WU9HyA1IXZ8V7xSfAFzH/He+6LX+8CxP2QqsKgavxlYViOpAfsskv8R9u5m32ZYXmyqu5AStmgbHO3Cf4YuCKnvdUjKprDe2lMdz8mc+tpqt++CL6KctoS3wh3h/hNweg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5886.namprd13.prod.outlook.com (2603:10b6:303:1b5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Tue, 4 Apr
 2023 15:25:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:25:33 +0000
Date:   Tue, 4 Apr 2023 17:25:25 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        imx@lists.linux.dev
Subject: Re: [PATCH v6 2/2] net: stmmac: dwmac-imx: use platform specific
 reset for imx93 SoCs
Message-ID: <ZCxBZZ4DAgy5dTGi@corigine.com>
References: <20230403222302.328262-1-shenwei.wang@nxp.com>
 <20230403222302.328262-2-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403222302.328262-2-shenwei.wang@nxp.com>
X-ClientProxiedBy: AS4P189CA0026.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5886:EE_
X-MS-Office365-Filtering-Correlation-Id: b74b4bd6-5e4c-4a95-bc57-08db3520d504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TVCkR/3B44hv3EPc8lNsAscpk9jCkz+YuwqwYeYnyQssIlkXGxFWm17ih7bXq4D8GEYRIg+CVVyW7Hu983dG3ttljHG04smFKJrQwYUAEG4MOVLGIPUXEeTmNyHpVhoa1zsykSxlHTjbQGOW/VTBmTVrEjVy5JGD4v1ihRYxES7NSVKTnjTprxDI8QrmE8SEVAcqqfVyK+Gp5yd2y/LKUBUAeOb9ijZy7b5AgUH2w2hB8G/sN1TJ6C3alWSHVsi/uoSyOyymQtYXfKB3Z+2ooLbliy4lcm+Plrd+xmHVoBUxMYqzfNXu1NVEIeDBGxOFUBM0TGDlodW4DXgOhze4LEBTEfYtKCI/XpT97zHT+Qeo0ocjRz6AptPqn+80+NFm0OoWlGNOLdOrJxbIG5WVLNtYG4YfQzEN4xXngcdTpU95S4c1TY11A338YnZwxkRByiUH52PQw59k9x5s3+ubVjuhDVUhNF9Me+Q2RYxpmRpyIDx2QtjiYAGXVsIjol57v+5stfshdwDZtuxYqm7axOldWVoaDudIYip69vsrKoglOFEcf9R2OVdklLxpQ1kr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(366004)(39840400004)(396003)(376002)(136003)(346002)(451199021)(7416002)(36756003)(38100700002)(66476007)(44832011)(8676002)(4326008)(66946007)(8936002)(66556008)(6916009)(5660300002)(41300700001)(2906002)(2616005)(86362001)(6486002)(6512007)(4744005)(316002)(6506007)(186003)(478600001)(6666004)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fu8J9npsdZ3TEy/oPLVFHqlALDE1pIDREHCNTDdgife7NP6GaDstCxjEyp3e?=
 =?us-ascii?Q?htgQSdKVevN/mpipM53GUAxANfOeF4gQp7+xPh8l7vDa0m/gMUOOgW4n5MAz?=
 =?us-ascii?Q?TCnQLpZ0Dd/L09p90XNqd9iszYkA5wj65YDCLRgJCaYUYzmbDS3GSf3MFLAn?=
 =?us-ascii?Q?UYuto1a8kr0DnQjtIUyyqyEOHU0qYFYWFwEYUm8q6hEuv1lpBXnky2MjWSd6?=
 =?us-ascii?Q?691uv7JCSsaOMAEM6pWSXS/mWUA78XwLeJbHtxa5WIgH+qtc6AvOb4K77oaN?=
 =?us-ascii?Q?JAuY/MdarsYb3zQAXQo4dbzafLFCgH8u+WS7UJVZ5ezv12yO8xlNA+TouSX+?=
 =?us-ascii?Q?QtOlXQldz041YOu6CVRXChKLrUNVtePL7k9nkuHHVhVGiaZ18JI9tEeAtYcS?=
 =?us-ascii?Q?O5J3QJpGyUbcI8uQFnmFDnB/l9Jnk14pLrXYwsu76nORP+MdXE2w9xKjXhOn?=
 =?us-ascii?Q?iXrn7OHDyz1PoKjSflB2kpm0JiKN3bR6BxEbfyCt/afSLMuAjoV/XYfX7oUz?=
 =?us-ascii?Q?WSbXCA5JvCde9xsODd73rNHNlhkxloZQQrEYL6qbP+tZPb0c9ED1GVLxH7BW?=
 =?us-ascii?Q?WweoPbLi+VB2UwFa7aJPELwbFtxMmjA/FNYvRbqJxeHwdZta5nw6D1k5ZGwq?=
 =?us-ascii?Q?biQC8jG+DzfkLo+V/UoQVJe11BCdxd/dXN19ks2/ybozUnH2ov6k3cLzXUPv?=
 =?us-ascii?Q?T5DxNsTpBIK6e8HeSjp8hCvb0LN+NkYsA/tB3ZndovJbt/ljPlrPcZ9bET+f?=
 =?us-ascii?Q?s6Z8U/WvaBHjh9Wvp7GF8WAeqlJTnn0y6PjcdNNeUGEdXkcklmvPbsNQ9w8c?=
 =?us-ascii?Q?hDfy3myIwQx8eOtaNHdswmSWcvydtN/U7xoYVo3YtgFEiCOH26ISiMrBK4X7?=
 =?us-ascii?Q?ziDjb7M6E29IgL/7jPZ259c5OUB8AVPdLon4FhLvsHC6GWe8ABKTrPItp9ic?=
 =?us-ascii?Q?IRccQX9eGK4yz0QG7qQcnLiNa3gkWRu6LvPyPktqo/dQzqUb01ONrcSO8qUG?=
 =?us-ascii?Q?ZM3qxS0sY1MkjMyXxgN7Ge5zrtsXVuoTSKeP8zxxozBRa4+3riRYuN5wkYr8?=
 =?us-ascii?Q?aZuUc71OshJk4Lh8lHOrCyUai1CGtyOka1ckSwdTt8d/vtNqvANZDoLhdGca?=
 =?us-ascii?Q?PKZv3A5bV3Md6qwww0XdAwNL8QlD1IJZk0mc/Mp+9r2DcZJYHAQMQVHd1HCw?=
 =?us-ascii?Q?Qo4ST4aRx1Vozfii1dHfqFvJ0FL0D6G7NuUtEIBpO8+sW9aJRwPYYtt0F0i/?=
 =?us-ascii?Q?k8yAnTyADRTSMT0qVIqoQ+B8mC3vaWIbAt6ulpkpQ2S5EnHgXeZqWcjxfOKU?=
 =?us-ascii?Q?/f7Tyqqb1WWXw5G+lfdwD6J1pJdPrJyRAIkbcbjAo1FPyFuz2tk245RTPQmj?=
 =?us-ascii?Q?f7NNNVm6bk8m2LbW3YHCbkTTx858PjhW7Pbzm7Y94FbNDDQO23HJ2Mn9ruyG?=
 =?us-ascii?Q?ZWqa8fD76Fyp9jqSoTnjzh8Xq9cJIEXV3NZGKH+Y+IbTZ90UxE5hHhsbNjJ4?=
 =?us-ascii?Q?JTZ8xC3mjHkb5Zcen2YaoJqxauMzcGFLrWmweqW/N6CgBQrGAyUCihavW0UE?=
 =?us-ascii?Q?y1SIWexAMFwmAT3cdp6usT5wZL4OSTPy46P57e3cphLJTZ4TVc+TFmJTTn/p?=
 =?us-ascii?Q?CyrkIzP6zE1PU6BI5HvcujX1R5V3cfEAlpPxbeMdGlQ2JOxJfrmP6eRmbiR+?=
 =?us-ascii?Q?QUmjtw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74b4bd6-5e4c-4a95-bc57-08db3520d504
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 15:25:33.4635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbRn199O+dhgIa0hOCpQFcmWptd39BJ1veEw2KCC28lo+bPbMxvAdFM4GtGGBdoa8e1SsdnuAR7KCaZAPqtR4vwAa9lUE0WhaNZDbm7qQts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5886
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 05:23:02PM -0500, Shenwei Wang wrote:
> The patch addresses an issue with the reset logic on the i.MX93 SoC, which
> requires configuration of the correct interface speed under RMII mode to
> complete the reset. The patch implements a fix_soc_reset function and uses
> it specifically for the i.MX93 SoCs.
> 
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

