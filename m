Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F07599CF5
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349059AbiHSNiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348710AbiHSNiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:38:05 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2095.outbound.protection.outlook.com [40.107.101.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F216FF5CC0
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 06:38:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRGASDXQkGwjRmyV6P+4Qk4LQNGIc2D++5ixVwv/ZehnRpFngJBSsIvyD7slK/gKqbOSF0RvK49m44F4DjZoSNGpITak5NTjVE7E8+FovtK7wIg5zdd1pmFqh+gRVDqDq/bAUap7eBAahb+aciUBNAsn/Mhbo77W4RlvoUxnXTLYqJSfOAOASMlAFr5eLl+4jNZF0wdforzSaADAE1xiReQ++WCUO4f1ozaahsgJ0zbCeqxcg5SA5eiLb8OgAjx4hbS/hOpkDO3U3pQuW+xiG3k2i0z6Wj0TFToEQsSVIfrN9l0k9hjKtbXk20FIgdcy9pFlwPXg/3PgGaBE1BSb+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZg/k7lAH6mlW0pMYw5sb61JJHOBY6FMW3jw5BZqGzQ=;
 b=M3LiO8mvUEXEwjIcJZcS3NHZE97B889SjeUeiFGvX+TIxuo8eRiX8S4R+X4ScZL31ujQPSLgC968tupMKmCNqazHnnEnhCQSpzu/bEBhR3Yd9p1yW3+uRC8zWZwjBpxEJq7o3YLIQUJSfqMi1//4SMdKtXFXOYkyd30qPVqo3ysDP0pMACUHdcFWIHHztb9xYxiPza/qY53Mq6hwr1q0J5mHg7pxEx3G3+yQQHMUxCeaL4dE4uRD9eEXdCgPcxkGmwgyvu85NknpnzVA1QHyHoE75JC8r1qZi9eoyV1E2PcMX/J5rUSd1s/NWMhj9g1upx2b3KF6bcWorhYtBnZi3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZg/k7lAH6mlW0pMYw5sb61JJHOBY6FMW3jw5BZqGzQ=;
 b=fcHqNakxqX1uQaRMazbTtC/e/i0kUUf8zuVAqcl/blx6mI+pBETWkoMXDqPyITmwkKnjbdSqVth3avKtcQyTFuqTJeiUAr9Yrtzmh838G7aKXZBrbI0aMOofsEMr5ah/3Htqm0HmSwcrsi6+IvaneeoZM4BR1zsVJRfdBjqYiVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN6PR10MB1780.namprd10.prod.outlook.com
 (2603:10b6:405:a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Fri, 19 Aug
 2022 13:38:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Fri, 19 Aug 2022
 13:38:01 +0000
Date:   Fri, 19 Aug 2022 06:37:56 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Message-ID: <Yv+SNHDXrl3KyaRA@euler>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
 <20220818135256.2763602-9-vladimir.oltean@nxp.com>
 <20220818205856.1ab7f5d1@kernel.org>
 <20220819110623.aivnyw7wunfdndav@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110623.aivnyw7wunfdndav@skbuf>
X-ClientProxiedBy: SJ0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99a40573-c613-4c9d-7df4-08da81e808f7
X-MS-TrafficTypeDiagnostic: BN6PR10MB1780:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h5ECarimFLe//3Em3Z1nyK0LHSKZsqpLPJxnYZB/xPwGt0BX2qEj/MoWPMMZ3zMvAB53uStf0CSFmOXKCGFU2uYoQwWHoEwxO9JZujxz1MKCDTCYdLPnAHKKuaU/kkK9NBQ2An1QcepYwK201Cp+ADGfayQSxET2Hg085uf8M4STMXb5/LrWokyynCMHngnaWrpcG+ldblZpS0WgsZ7q507RIP0lnq/AUvjf+OfmvxXAvQwOhHF+qxyBoFPeuzeWmy27CYum/yp7PRXcSpHLZTqxis0gvAf72ujk1taaEsKO8bPNDPBpPGHoMcEZaT9FiPl2jvsE0KCkkhi11UcgixITY7uiYgkfZzzt9f14KT2nnNlZ8DZNmpJRBTXt3Ul0hbZNTGo3BXYtY8AHa56He/rDIwKQ2LBf/sj24/zGmgUzC+keaAJug1v1zLDfOh4ZI6QkjzvWnY4hDB1cumePWuNYdCGjr2HOnPi0XO/o5L8JC5JNnGaTjW4S5++19zxQKDMB/3Jg4xG+HxQwvR58Hm1KSvpZIvK1t+DN02b40GJJ+qPO7Owpw8bh/FZJ4jJfkk761b7ssO42BWhkaOG/iHWcoq9efsUHddeqkyuEbHyW+6uO0e86DZbDLqaGppymJv8f2Qnzp+9mhw5AhuWXkZVTDEwq+SM900XqBf6cJ5odVaOfRi+Onw7/Pyvebor5DB7xRTR06yNitbwK606vIrzgcGCZR4rgFgpROrBAn6T2on+KB37l6zywtF3SBeI/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(376002)(346002)(39830400003)(136003)(4326008)(4744005)(7416002)(44832011)(478600001)(6666004)(316002)(54906003)(41300700001)(6916009)(66946007)(8676002)(66556008)(6486002)(2906002)(8936002)(66476007)(186003)(86362001)(26005)(6506007)(38100700002)(9686003)(5660300002)(83380400001)(6512007)(33716001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QJ6kQwTmytgK2tAMGXjxpLdTKba4iY0tOYBwg8SJwgzr7HOumNnR5CSHaq/9?=
 =?us-ascii?Q?L4hIr0ZHtwhvUPZ7CMZZEmShBydrV13CwCEVSuyG9VqcNZCZ4LLxrWdC0ilq?=
 =?us-ascii?Q?5DnHh2VXXTNvRJgzwJ+CF9pvUtHFjYX/oom7++d1SVx7u5flPeN8UYGHLMHA?=
 =?us-ascii?Q?MnvrRhiIIvaSN+h/oOHqIXhTOiPvJnIb/KYemeuN6S0yOKgesc6X88bosoJV?=
 =?us-ascii?Q?39+HTcfR7ioc+nQgHsTnY0AcrFm4U/qxApZjHLzONvOClicKvF4JgSc9lE7h?=
 =?us-ascii?Q?fED4fc8PA1F7m+Tt/jKBhhpmY90GZJroI61oLf1wliBLsia/WoU3WHvmd5xR?=
 =?us-ascii?Q?2kyUdfeEJ9FDJ0FGg+9wNKMf+bmebm5eqba5dXroaZ974s9P8kPV8HSWl+pC?=
 =?us-ascii?Q?9qDzy8KKejkkrf+jR4qUHKHUxTmb9UHGwYV2CcaQw7SRofSMesDadZhb19P9?=
 =?us-ascii?Q?2V60MsgDafEYrJw0WqpMjBGTNKE4GlfJ5BqL8YNMZCc/nBbl+u1mRAl4+ZWJ?=
 =?us-ascii?Q?2RgTqIxnjS6PEUxn15MeQ0FycqLMkBYjhPB9FPoEEJKsA1flZFxMj6gX45lr?=
 =?us-ascii?Q?hofIR0XOtaZUcEbF+oGtOjzMYAKoqNeL3Ak2bdiEhfh8/NnuZ6lBjhWMNNhH?=
 =?us-ascii?Q?cWbvu9iD/zQ2mx9PmJ8XD1I2xvTOCRCgixOgmhlVzG4kWo+Wy6CqNWfj2KuI?=
 =?us-ascii?Q?oY/GnH5zAGMzwpetS1Jl/pB37LE4RRQJD0DhohMHvYW99jyBH7VRYNzDXzPi?=
 =?us-ascii?Q?JxPkt/MbLUY0NREnFYinB714g8sXrc6fhXQhc2mo3KFqdhzd5UmWzA7K/8MN?=
 =?us-ascii?Q?ucn4Ql8K4Oh0t8ZcxtF9Zxz0GUJzQ1zZAEyaMi2KTXhTZIwXoxRyDmfMGBRx?=
 =?us-ascii?Q?S+bR3/35KOxDrdt25Pq1runIRGTzsxTt5jCvJPKvH7fCQ8SauvGAGy1zoU8d?=
 =?us-ascii?Q?Tc8B6MdZ+qFB507RHl6+VSFDaVE6Sg6Jb5gltpSGTMrISX4Kf4JcxaoraRGU?=
 =?us-ascii?Q?ukbvCNu21ncPnPwYfHwEcbdcC2NwDcwLwla7Rpmk3fMwARf440JWy36ivsvB?=
 =?us-ascii?Q?DeVX9fCcbhee90yU/4tOPgMj8WB6ElaQ69DfmnWh1LicTfGlPrC8SyjnfnFF?=
 =?us-ascii?Q?Hek3M3KZXcGjsDnSvOXHTR3Mlw2ljv8bnwfx1+g40nxSuTai/x+50Cy7j4Ty?=
 =?us-ascii?Q?O23xrKQ7QuVrCbTs4A5vOTyhWokCXPq+WOZUxj50ZV02a4VmNFFvOJBv7bQf?=
 =?us-ascii?Q?2C657rof7zvALQajcTe/aOc39EIuNb2Qy3zV5Oi8gKKPqaHwCN4gwAq7iLJ4?=
 =?us-ascii?Q?ftCIdpM2Sqp7Lwo8RB/e8yxW+TfjeIsrptyZDIK4ieo80zAXpw9YkCfVEMj4?=
 =?us-ascii?Q?sv8OWFVlCv0K9RflJFmC4iROQxMC7tdvDRRSwgdEKnWoVINNzmYeC5Vz+61S?=
 =?us-ascii?Q?ReUUQAegDsusLHYLAGjQfNrm1RhECn95mkHtuKmVXQInjRd0iJpMNCAkv7Dx?=
 =?us-ascii?Q?/KKfLzoJlrI8749u2zQjG0Rbrp5/AjV0Ylx3k142kzncTvRnqp6CoXHY+xAq?=
 =?us-ascii?Q?ATXZCP+zkjvUJd0UHxO5DvNGcBKg+PGZXLcxiSTlYGcGpSzKZa8ra3YcqNUY?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a40573-c613-4c9d-7df4-08da81e808f7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 13:38:01.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sakRnHsKg0scSNOv/HWOsiDyqSupmytIt5YsbT9RyM98OVjVODRbEsHgKMzURPYO//3D2hR5hN6ZCDi558EpOQBKEDyhiYkz0M4mpnvsqfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1780
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 11:06:23AM +0000, Vladimir Oltean wrote:
> On Thu, Aug 18, 2022 at 08:58:56PM -0700, Jakub Kicinski wrote:
> > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/ocelot/mscc_seville.ko] undefined!
> 
> Damn, I forgot EXPORT_SYMBOL_GPL()....
> Since I see you've marked the patches as changes requested already, I'll
> go ahead and resubmit.

Any reason not to use the _NS() variants?
