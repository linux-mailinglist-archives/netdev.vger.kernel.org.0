Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09986D9BD5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239709AbjDFPId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239714AbjDFPIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:08:17 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2110.outbound.protection.outlook.com [40.107.95.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45406116
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 08:07:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0sOLBr5rkTHSICZF5NzoB0fbvPX+DrxCPvb6JK9KjSyYGyzf9SoSG50/WydCqn4cyY3HhucnHkWBRbtKBlV1lpUhkzj+eNgiwmcqJSipI+e2kN9XzvZxls78Zv3ky5UBqkGJRfsDXYhrSXjIbLBN2dCpEXsGEYeKMtaWw+dJhntuza7FfqczQgRzlY//HaIN3+l1Q8oGYqfT+aRRv8QC30CwH6ao0VeL6Dv7CgGbiHKbEFh8bBSp4uhKBuRLQm/3wMcqV7LPhNRc2nuWOr6q1zyJ7i0rBVjarshTyiluzODqt8MXcqaR74UE7dxw7hIU72D2ynlB4VPLqpWUNFjwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYSYZ00RBvxkkSlimJ1VtAyORHKM6qJhxv7r464xRRA=;
 b=G7x6H3F7JXIL8/dsiFzmYAVaxNTWb+0l0jUVH1t3nEqtVtTZ47yR75l/i09GVHCV47O4R90CWozpyJ87sLABDhZ2mcC8x0gXmRD00YOy9P+2BJhE1KtPuLcg71/p3iTBkLghRQNiv/tpO+nfgs7dFOM966KKMDvw015AZ2fEKzg5/z+9qPw3pxlynnNPDQ4/VNxoWSXSK0rO3/afZp3OQqS2RQeDjxLx3iIcPodQqGba0fOVNB5S+1ZQyVlr55l3rATHG6+S2ZS4cCd9jKo/4c/7UNk+WdscUQxL3l+jx096XhEHFz6aKS4w4U55J+WxqLt6JmbaUbv6N6hHT+eWsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYSYZ00RBvxkkSlimJ1VtAyORHKM6qJhxv7r464xRRA=;
 b=eY4vDRdRYFC1BVEz8ByIlKA0t6rCNHYEWc7NaeXAAkhHH7Hib61WpC6ecNJC4r87lvIXINKApMvPmkF7lwOZZxayeOkgiGxHI/GpTicuIpQYzt7ZFvsLl4RxLYJYKDZtLpvaXQk5DJkzqRSjXMXepzTKcCcjhrTyaM/MtDYXnU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3639.namprd13.prod.outlook.com (2603:10b6:610:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 15:07:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 15:07:35 +0000
Date:   Thu, 6 Apr 2023 17:07:28 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next] net: stmmac: remove set but unused mask in
 stmmac_ethtool_set_link_ksettings()
Message-ID: <ZC7gMPN9gZMj3ZW0@corigine.com>
References: <20230406125412.48790-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406125412.48790-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM3PR05CA0155.eurprd05.prod.outlook.com
 (2603:10a6:207:3::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3639:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c567401-e41a-4e94-caa6-08db36b0a727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fH6G8ROdB4nOGxklO0/8BztdI247x66epHTZhYxDNo/46R5XU2Yh6FCubei0IFtrdesHUzoY02BCPPWEx19ibFA8n1J37DacgzRy8xKi3EkYPG3AKwZx7pQSd9fFpNiCak0uAsk3dOyk0LDVUZhbN2hxQIicY0Rd0YEKqGBJ71mVgtx1UTEiBu7Q+hMaGoXeTob7+O0i2xN4iF14zymolCUR6YY3dx+jxgFXUGH0y0Fasqyq+rIEz2tBb+t/mIv7/Z2ryL31i5/SIWoo9wUmhXJg+6tCy5BEzmHn6CMd2wlilfX4rXvBIhEdMPKESNlmy0XUsxLBQRWL3NNJdbB9HRod3gfuObIUDKXAjP3BaaIYbdFyCbPYsOFsLrR705lTJKfYxbC4VZ9cMInDWXCHp3pYDYmTjYhVwv48kvg+s+3Yyj8+6MfTQUDBqU2gk9jFWI53YrV/khybr9hP+ZgO03ZKabSUR7NxOOs039tiIH1iSledSWI+2jdoLfpa13AKne847OzXEXrY4bpCfG6zld0s4DWKbkog4+JzyjwQoEcCkSybz9Zbj1OdSJ397bwr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39840400004)(396003)(346002)(366004)(451199021)(316002)(7416002)(5660300002)(54906003)(6486002)(478600001)(8936002)(41300700001)(4326008)(66476007)(6916009)(8676002)(66556008)(66946007)(44832011)(6666004)(6506007)(2906002)(6512007)(186003)(2616005)(558084003)(86362001)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WtMH44n8XsLEljkek26TmzBMJBDf37pLTVxIBcwqHfQj21hB5LYcu9JLhIeX?=
 =?us-ascii?Q?Ii8B/mwylcsSUK3lkLAIFigFzEI7SO+HKbmhuh9W+zSYYcDsNSgfEGkI+c/Y?=
 =?us-ascii?Q?H2aSei3EHelWadJ/HwjcWc3/rnRia4FjYNphlXtgjsf4+anWNTu6Z23T9kpS?=
 =?us-ascii?Q?YGTyPK5dTTiVmDLUaJmdPFYJ/xM9iJQ5GI7qxaM+JENt7cq5yAQ2NR6DRwPx?=
 =?us-ascii?Q?DRywo2DUYEyPw00ZcalLYh9+HO+AXpgl0hKtI90791503or3FviHvTmpYIpL?=
 =?us-ascii?Q?r/u9HIkuNO/e7JAq9Duk5W5pj+MrXvaMVbVWGm0pwjaHCl5a0gM9H6Vruxan?=
 =?us-ascii?Q?ftINbgZd8JA6x6+UWoYzO4WGZuu+SYWIp2Tl8sPDsjK7t0F+uMjAon99fDBL?=
 =?us-ascii?Q?LbaJMJAKPbsq2L/PVjJ+hX1HVHTp33P5OsoYOiytJ0f7yDPjC+6HFePtZ3j+?=
 =?us-ascii?Q?QOQrEFOHn4t9lehojaX4sgsGaPOsazxYi3x1ymfqvzEV8AYHzIb+CzMr3Jun?=
 =?us-ascii?Q?6KicibTq4aEKwZS1Z509ulbqCuIcyqqBQAQywdsv468bmh97CRLTRDL52P4e?=
 =?us-ascii?Q?5eAYHW6RNwZ7QUsbkEpIqnzsYAWKq/RRZQpAWVfIGjqXf0Ee1QiRsv/qusjh?=
 =?us-ascii?Q?cewllpwxokBNOHjhWzBK3nKQpuMQvxUe+sR/g626PUQoKUUBeaKKcb6R54Bi?=
 =?us-ascii?Q?/F904NMTMEia2wWadQvF/fv/l+vSFQ+75wpjM3tZ1xA2K/5gZLv5qPHwkcpQ?=
 =?us-ascii?Q?nUvVg3eEhdUs7ifV8PQvBVyqoIYl9m6kFGtZNSogpDBv3L1u8SKxbO/4pCv/?=
 =?us-ascii?Q?+UCIM2v2m0rILS2iq/yA8E2VemMBnx0Wzl2VfGcSgxkWjZWosZkzf2hbsYVz?=
 =?us-ascii?Q?ri85Tb9YGpz4t084PmgPI5RiGYX6KIJvxMTAPCgGn0iVBPtHVyXhzQXbNNHM?=
 =?us-ascii?Q?BoaxMrNgZslYqRl4wp53lHRLsZbZIiOXchFLabHgFBqDbhZJv8cPQ4yXfq+0?=
 =?us-ascii?Q?58BbnA19H3gBFV5GdG8tr+3Y8iYux/owlbdRfRMR5a9a1hORmqIv5LPkKuXL?=
 =?us-ascii?Q?kmE2RMFvjgBbxz7J4zYX3BcRzRUvpFwgiYereJ2sjTRfQ3Z9E7q1906Ub+Cj?=
 =?us-ascii?Q?0Vp1DzL3a1qKnnB7jt0kQFWxGlzZ6KdCaQSjzqvxkuZq9PrLT1xx/WvyOO8W?=
 =?us-ascii?Q?GgLdfjSqvcbU2DSn/RxV0mVcL0uRPeDTvVjsGsKzSLtaNQc5j7HtBegXb37Z?=
 =?us-ascii?Q?Bv72m3QBPHcX5N9eX3pDBT0aORl2sPHL4nFx8bEii3E1LzZtCY0hSNBfqJqb?=
 =?us-ascii?Q?pZ9G5e/zCqqokBVnJcQV2hXROPhYpXX6vixMe6kKuig8eiWYeGCL6NhJDkbD?=
 =?us-ascii?Q?ENPYhrIphnLTfj65n53EsUgV/ommPHuIjBZjWI5pIVy5npmzHMItj8iopL8R?=
 =?us-ascii?Q?ZrlsI182q61u5wqfMh5Ic5jUMlK7nsZrL/XN8aOI79q5QgmWUa+PpRV/An4g?=
 =?us-ascii?Q?L8I95qatDcvuOEDtb2gXlJ8wX79MSd6Pp4dmXSkjHn4YkK/47TITJsEILwt7?=
 =?us-ascii?Q?WnQhYrMtqZpKgMpBgUUFlf508fKOIYPX3oXWmQVcD0ZTVxeB1nmE0FAHihS0?=
 =?us-ascii?Q?tnD9lnJlTONxGu3PrpsJQXYFBuCV0NkIONWjJ4kbi5wpo6XCFKYfTQbEHdzA?=
 =?us-ascii?Q?P7vGYw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c567401-e41a-4e94-caa6-08db36b0a727
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 15:07:35.3070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yH45Bn9Pl6jG6EW79BC6TeHl0bM2JBJtqzBhSuyXcU7NxTZN+Sd301CrG8KNhULj6J2xrpZsnHhGigLhw55kad7Ag+xcVkA8VJmMdZB6O0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3639
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 03:54:12PM +0300, Vladimir Oltean wrote:
> This was never used since the commit that added it - e58bb43f5e43
> ("stmmac: initial support to manage pcs modes").
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

