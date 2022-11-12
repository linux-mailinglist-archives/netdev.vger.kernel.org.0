Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A034626AF4
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiKLSGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 13:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiKLSGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 13:06:04 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2129.outbound.protection.outlook.com [40.107.243.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25DB13F01;
        Sat, 12 Nov 2022 10:06:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMl1Z8qcc1Lz2SHllSd1pBdoCyO02K5BLrNxHTwhLq66c6ieScHOmVjSVWNJpahqnyzQltpVVt25bqyJjDyN698pvZqwZ98ptA2Ve1zuDF47I6jfRq17EO42itFWUw8GWlubHXhK0CcWuMjZM3xIqMnDffAdAzxT72LYjJNtRqWh92PMblgxX9JZ/OOIPvGcCTFSQnDy7DT1lMGayrp5uiqsStb+EhqXq4cAoc4wclppeoeXiyX45I6Ju821A45vrYazbpPXRKeO99uLb9oDRMofvxBKcF3QSNfFjAJUwUKINGc7meLo4XtiigRUPtNEQS0GiYV4BmgrOhVNjweS2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQzW2BT3sFbE3UbQKQHsyl7nVQjhuLZ2akqRuwxKG4o=;
 b=PdHK/O7cVHKiWqRSPlvPPNb1BEhIKoQZjTjwOy10TegijT3NkJ3EPgCQTpOBnd2AUSZfHzeVefXcc8U6/ciTgwQUpB3qom9YpdczIQkqcktTYGZGr59vo5mQswbB22U5Xsm43dhSx+qGbaXRSjJy1i79zp/2KocHF9FJtnacgOr8Fv22MoXLBXFv9tJXmzajJqOuwWPHMN19UHVKXPQ38kXHs1SolDg/n+S+dQlT1b0Y/IAZvborTuLfUZsZFsAujEbNGuiyZefbLWrhXe2FVMO5rQn77AHTl2Q8u/byh/2quEomDj130k8x+HpO0Z4lHX4ejKL7flE33PoXwdq5Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQzW2BT3sFbE3UbQKQHsyl7nVQjhuLZ2akqRuwxKG4o=;
 b=EjpTwPfh00FjM4O3w3js1GY/MhB5M31JNSN0j8vpkUFP7XP0yJewhMR2++kBInskGGPKdLNgfdLw5Nx3y9gc3ePyXCcFiYB6l/Jm8EmtEY8iJrdJ8ehT2y+MELFucBZVd8e0ZkwhhNq4qwxfFpobnjFFH2IMHUKeK6ydbId6aJY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB4222.namprd10.prod.outlook.com
 (2603:10b6:208:198::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Sat, 12 Nov
 2022 18:05:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5813.016; Sat, 12 Nov 2022
 18:05:58 +0000
Date:   Sat, 12 Nov 2022 10:05:54 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant
 stats_layout pointers
Message-ID: <Y2/ggp8Gme9WFlZL@euler>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
 <20221111204924.1442282-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111204924.1442282-2-colin.foster@in-advantage.com>
X-ClientProxiedBy: SJ0P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::27) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MN2PR10MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 9696d07a-c6db-4fc6-b648-08dac4d88cd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m1XD+3/Zzh2WgVUeY/I+i5RVICRX1Lj6u9YK9MFU/Fi0/qEDXDR9FE/qTx1Kid36clSOAmWZXgW+hZubFN4nkcwflfWmMMbTTd0rsvdJvTNUsrCP1/7K+GjQ8B6y8wU/G4hhu6NiWzBKS0+n7aU1zMAtYC0W5X6/EVKqC4EaeJBmm7QQ1glCGjO8S1O084YpErbvUB9dJD0oS9hypxn0ianPTvUDB99R6RUFgTebd4aPf8ymPTCCzOZwJ53ig+3rhOjzAklAVwzoZ34sT3C/DWUZqupqT55hJeXVtD35dzEGr0nJ+5qNsT5ZwsO8G1lzHYUHE6YQKHWer5SgIouO8c2j4lYd+dZ0aseN+M7/VxCvaCCs7BcqFErUU8cv38Ckql3fLk/P746U/d5Sw3hI4ekLqkuyITSrOaVaoLk30Fauu2823sUI+a/9+lAT6dRkc9zSDhJGzn48Ybbh4ADbK1N6aQ9iueDkcPaEL9OPzd2SMlI4Ap6yNDD79/6paPH6J5KIASyiViPxfVX7sDtV84Ztxfi7zo4V6I37OZd4pTBva6VSRNbMmJL8wBlP++Jb6jqHjU/2Cw3pzCMLyt9s9ZyTkH3b0mKTr/lanDgLFiADPCWAcVHB/gomuU6onvqRt1NWACNKapNxMAbu9yefX6/x+zroiXJciEWr9HrZ+So8X01I7yMnbBF/ef1/BhJQ+tV45Kafec0siavzWYi2XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(376002)(366004)(136003)(346002)(39830400003)(451199015)(86362001)(6512007)(9686003)(4326008)(8676002)(66476007)(66556008)(66946007)(44832011)(2906002)(26005)(5660300002)(6666004)(6506007)(8936002)(4744005)(7416002)(41300700001)(186003)(33716001)(38100700002)(316002)(6486002)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jbqwa6c7vI3L2M0z6vf3R7gOR3FtIdbWc2dCYLcEMJ5OQRrFeyDak3tyYCzG?=
 =?us-ascii?Q?RMkUUhvHyOJPPyxn0YIgURtsevgRKvIpVvUEA7CO9Tz5G9Lrgg1lxQvOjOiR?=
 =?us-ascii?Q?dvye4NGbec+3dfdYKFdAv8ZkqAfwBXjwLTqcpFQYXrxl+kp92Le9KgSrBSSF?=
 =?us-ascii?Q?cswh/dM5AQVf56XLx1+0LZ2YmUbINbAxb1CRV3u4d4b5+Yedk602LG3HZPjz?=
 =?us-ascii?Q?8RU48kzbOkS4WPIBzGq2Wr5BEQKADjcl1rtPGNrVv+xq/N+VEUSoh702OIbR?=
 =?us-ascii?Q?kk3F+5L10K9hf7xlbxgHDUlYTko+DmNdZWrz7y7ec3Mv5jLKov7eLoKcKcrl?=
 =?us-ascii?Q?ZvT4RyV9XfX0G9kChUthvDwAjlhQG++iVv9Dk+vDrWGThBE49WX6E3cGu8Yb?=
 =?us-ascii?Q?Mbv29J1Rnq5L8qjxEPzJRYu1DuXEYeNLRuX11Pa0y/KuxRH/WztxZJrDpu2Y?=
 =?us-ascii?Q?f04Z/VTzcNNoParEoP8uFekqkWwQWMHVdhKZmBvFe9KWp70m19WAH2XxxhlV?=
 =?us-ascii?Q?EzbBBWfQ08cui6LfzobionKr+USQmJSoYK368+38XP/cgLAT/CefhVXM+Sw5?=
 =?us-ascii?Q?+5UOdI9zjJhr1FGbrKc1PuKHyH2GBt5F317dgR46YwK/CM9Lm+4V9hDyulyh?=
 =?us-ascii?Q?7pHvNCgvmZB8D6fG0ppl90y+ZNlZZfydfUSMMbE9KCs5iIuPsol0q96DFt6Y?=
 =?us-ascii?Q?nJnS1rVuMQ/IxF9BeN5JNwt3dIaY/OQ+eXSRQbBmjs2Ea9jLMF6Oaxt+Lq5t?=
 =?us-ascii?Q?EM4mwinRjsqkCq2/6KKY2ZeA7YZkk7SCyO2ZEPbFHrrQZHSDdYdXnuWtTyYa?=
 =?us-ascii?Q?CmgAqD2Qm2iV0Gxp/BBLG1sXTJDFWYjKk9bc2aF2RtKjs0jYEDQVJgSR9px6?=
 =?us-ascii?Q?BsoJdMeNXq5g1rCl7oHzbzSdYNm5IJA8c/mXgct+3hrwHrv+nVX+Xr0HgbjD?=
 =?us-ascii?Q?VQfTu/aAK6daY+zKz79MJd+0XhhpRrqgaOdikUy/T1QmKH8oavXSoiPUXFDX?=
 =?us-ascii?Q?EQdtMNbpxtt5op1CZRU8q6mEiggq/JjcSYBoZeb0DMWMksjNyzqaz08WkSLU?=
 =?us-ascii?Q?rPpUb+XXlfWH+ryIU6zii7hAKn3Zm/mlbn5Ol874yYCSRTpXo+OGCV5ak3GE?=
 =?us-ascii?Q?iP3vHAlaUWMpuPi0Tw2vzMUXjgPNRXRh4BuVltjGPpMETxOmIPWYMMsmuKFJ?=
 =?us-ascii?Q?SPal24EeLcUKucuJdK32oqEta4Z6PLPDyiGvvscsoVru61VzbNAUmgOnaFYd?=
 =?us-ascii?Q?mTOWFJefwzCF1bJsxXYmMPtFbpy1fyjcsclpMkCJfF9hTgASw/ZputM/1n08?=
 =?us-ascii?Q?2Xakg+iSPbLnUhQXumr8eLB8oD9YDTDJD4waskR6vJYlO25y8Gy7InnD2rna?=
 =?us-ascii?Q?pVvLoPiP2DXS7Rxbhuj3Lx4+OKDLnBR4BEvsgDPqACcPo25wu0IEFhu9G7LZ?=
 =?us-ascii?Q?wgXMZ0YHmv6KciYfVd/B1pf+Z1vJ7q4y9C5IjMxV4tZ+xEvnglKWdjlmc9Uk?=
 =?us-ascii?Q?s+OMu71lbC+CLqhC3loAfbWEW/sRjmPuKdQjqpPeA8W4k+zmW+4NKPVlhJCg?=
 =?us-ascii?Q?fj64IkZs0n4Ib2gaWgksm8bb59xBQ1FdMp1wCvOw4lYLzSQZE4gz053FSz62?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9696d07a-c6db-4fc6-b648-08dac4d88cd7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2022 18:05:58.3304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bl+iy8omRbawbTQKK6aeU4zTq7rDn+uLy8zEOwFG5PGPP+ePe6nN5PlPkpiw+eXSFYeV0KsrNdFb3oxihgSmgu4+EJKcTe5tzL3K7ZSvgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4222
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 12:49:23PM -0800, Colin Foster wrote:
> Ever since commit 4d1d157fb6a4 ("net: mscc: ocelot: share the common stat
> definitions between all drivers") the stats_layout entry in ocelot and
> felix drivers have become redundant. Remove the unnecessary code.

Oops - I didn't remove the unused struct from ocelot_vsc7514.c.
That'll be in v2.

