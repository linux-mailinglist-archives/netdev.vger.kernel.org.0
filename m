Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8B35B5D29
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiILPbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiILPbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:31:39 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2135.outbound.protection.outlook.com [40.107.212.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91F524F26;
        Mon, 12 Sep 2022 08:31:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZqiwc7kfTbjT/Hsahp8H3xj1TxWcdoOCAo2Vzdx02ui1pu393gDPmWaEJTKGqcpkKFaNreBQ0NFQCxF5fvsRVhmWeOxXgswvQg4ixhTCBA0LmdVCZ+9GtLcFoeMjPlyBm+axKhpOu0Jb2agrqh7MNgOrSOnj46PLPTcHIV7t60JeQWbnn7NqbDtFiw79yU6bRLknwCd23cUltMWfDt0s7QxhZ12tBcfQe6uMunYkMoBW7g08teNCABtI7kTIhRX0vFroS/+NTfs1uuTbdnzcmxWIJU4Xo289tmEDjtlXnaaApvFMADXc3FraAA3xybIejXrjxcWUY9PhmBwRlaTmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMM4aQ2qOlOdRMnOVuDDxHRke6Xf4+isFUh2fSYcH8A=;
 b=V84q4r6zYDbphlSvSGHKzR1KvKxIzL2IhCoQyGEPFUYlqBsd6xH6kRw+wiHJxhUCZoHOl3myFDEuSUk9QKya5oj3AXbU9xfrPe/o6q5tzL3lLAzq608Cn3k44U3+PrdCO1Bf5Zqd6yZXg5+TbayFDy0IQo44f+c2+2UDAJ2h9Io7uJQJQ1d2lvCIeGhJuYhjFf6FbrNJpztFKUnbmJzCgTJ/X9h4DX+ZTFcsJe7I1zHpPN9uetFcYxjH1/QqyHd5G6ov4Hmi+ENh34IwZt0JFhuR60CdaEkbI7k/5RvX7PgCfLqq+wQ35O49LyZ+cG9c47tSgGHDxWK9zgU2fuuG9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMM4aQ2qOlOdRMnOVuDDxHRke6Xf4+isFUh2fSYcH8A=;
 b=spi56oFRDV1eCou4TB2Jx8cja89C4OsZkktzxgxGXP6fHIxgICwJLUxmL0u2CCsOzSBzErmdfQFqjTSPOPNmDynLUaKIFOKsusS/lccq6jFo0UCq3yu7ceuQ7acl+nPvvZxPszjhHubScV1pcdb2ipFZwjkMY4EZLau0J5zuKR4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH8PR10MB6600.namprd10.prod.outlook.com
 (2603:10b6:510:223::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 15:31:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Mon, 12 Sep 2022
 15:31:35 +0000
Date:   Mon, 12 Sep 2022 08:31:30 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <Yx9Q0mJyriAocj3L@colin-ia-desktop>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <Yx8PIsInsR7oQqgh@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yx8PIsInsR7oQqgh@google.com>
X-ClientProxiedBy: SJ0PR05CA0174.namprd05.prod.outlook.com
 (2603:10b6:a03:339::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b41d6e5d-f957-4248-a870-08da94d3e086
X-MS-TrafficTypeDiagnostic: PH8PR10MB6600:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/M2KZBd6ZpYBANnv6OK937mv+dFDa0Zd29eZK4RDZ8pLorerUKMu5OQfD5SIKFCiG+SeUMGWP1kMG2twyPfH3hZ0lG0BOw8cPJImkUWJxMcX9lCRVwHhTeTXtifwxtIrLSGMc2h74APyjCiAwWFSyvT4VzaIiH+QazRNeZ2v1O7oWvyGvG1fYglLaAsSnlyT252ZMtxTHTna99U3Cfovr6boPFA6SFP6aJsGS9T+h/IOCgrpxb2Sp88J8p/wyF0/aIwPIskKfiRzGJEwmKBrClBVkRiDndnAm0spNNmmItmRrAUvmCQujq4984cDyMb6GTXs6MLWRz4aIDlBrxTdzjdamAWXZ9MiIgZyHnSCZJHMywFPrxoCIQgSnr7/oRMrjhlpfRSVXJ35Vma3GahtGW3v8VJIIBhSJF3xrJqsIBMRlHN1gnr53h0P1iQnjm02nBpScPm2c0GTnxkyrgXl6YP+ERI2YTz4aW0/sQ8Rtb55+B1hVvvG3m52XUyJMzFvC1nKgVQLuy4NBi1qO/+olu7ImGedv5hMFjGheEDodia3SYWsN12ZZ0tnGCXrA6jCCcUGiiDjXuoZ//Idn6zIHdt3knBRgHqxNtIPunbS0IUzloQ4HNcxMibtSrfhRFvPx5xsR+TZNekt2WhngFV1mQ0/+1wjMpoWnM5tTSIO1XMKRyfR2wGu/7EG6lUTVC3Q4aSM6Rb/lxZ00uevC+y+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39840400004)(366004)(376002)(346002)(136003)(396003)(4326008)(38100700002)(66476007)(66946007)(66556008)(8676002)(86362001)(83380400001)(6512007)(9686003)(41300700001)(6506007)(478600001)(6486002)(6666004)(316002)(33716001)(54906003)(6916009)(2906002)(44832011)(186003)(26005)(5660300002)(7416002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVhVSGZsMmlFNHROU1pVR2dGVFlROTNkdzNOZjNtYzdlK0lrNnErOHpDNzFr?=
 =?utf-8?B?d1hmZWpjTithaGNadW1VMzNkaU5GR092ZExkOGVYT2tNN3NLc2tNaDBCVkd4?=
 =?utf-8?B?dkFvV0hNdENEc2hqVUcrY3BMeFhST04xMVBDeUxKTTE0WUJ1ZkRTVkkvYXVB?=
 =?utf-8?B?U1ZncC93R2orM2JqQ0pOYmZEV1VhVkNyN1dCcnl3L3Y4OUUza0w2NnJFZFdy?=
 =?utf-8?B?em9ZWFRXZ2d1TVk3bHpZVllxYmR0ajJ6NWliZHdxM0ZjS0hTRHZNRnQ5SmRh?=
 =?utf-8?B?SU5mSG1YRmp5ZHpHOElSa2Q5MzVJU3B5bGQxMHMzV3ZmVUd1UnA0Q3k3dXp4?=
 =?utf-8?B?N2RHblN3amtwVDdtZGZFOXVuQithMGVTeXpQK1hkR2VkTnBSRWliMHZSZVEz?=
 =?utf-8?B?U2VEZENEY3VGM09kOW1uV1pFenU5NzFCNlRxa1dDTUs5RkRWY3l6MS9tVVVl?=
 =?utf-8?B?WWdOZkpvcXk5VklNdmZ0VVlPa1JMaDFTYWVJNGZraVYyaXA2bm14QVVuQUVB?=
 =?utf-8?B?dWNQUVRlVklsVkwwTkJaQlU3Um5GczJpRnkwNlY2QllZUENwNUNNVjlOaGdl?=
 =?utf-8?B?bllEOCtvYXRQOWhXcFlTeko3ZmtUenZoSVVDeU5tSjQ5VGdhcFNqM0U5QWlT?=
 =?utf-8?B?Vk1rUGx4Qk9lVXVXNFdlcTVUMElIUkllVnVPeEpOdHhLb0ZWZkJqemhweE95?=
 =?utf-8?B?RS8yd1QyMmtLZWZMVk9peW1FUVR3NTA5bEFQK0JleWRkT1I0L2c4dnBGM3pF?=
 =?utf-8?B?ekp5K0RwZ0FxM3FKR05NTkVEUWVEZ3hRWXZWa0tUenRva3FOZysrek05OXlD?=
 =?utf-8?B?UzlUd1F3QmQvUUhpSFpVdDVoVkVEK3czK25rWE51ZFNUVCtLVHRMTDJlMytt?=
 =?utf-8?B?dVFxRko0YzFEaHpWWW1Tam9JN2dLcXBrVHgyR1JKaWgyMVZ4Yzd4WXI5bGtS?=
 =?utf-8?B?MjJLUDdpQldrNGpZWHlIQzUvd3hrYVJDVDA0SEYvRzJBTFg0SDJJdnJmcUVV?=
 =?utf-8?B?NGREbU9oYjhtbUpHQmQ3YUkxT2ZJdXRCclo4VTFvcmU0WldYOEQvMnlPeDVy?=
 =?utf-8?B?akJqdm9oTkhvV0FDYVB5VWVjb3B4RUhLM05DWkpVeGIwVCtZVTIzQ1NNSzZ3?=
 =?utf-8?B?UFFZQlRySHlNSUgxZjVkd2VoM2xBT3YwRWx6b2VPWDhUbzRNZm5odEh0ZGJM?=
 =?utf-8?B?VmxwdmhLMzFYK29PTmQ2T0pIOHRnODF2VTJ6ZllZeEpVVWxBS2VmaUdXbGxo?=
 =?utf-8?B?TkQzMEJZY0dzZGZrelFJSktTaFg0RjJlNFE2cWl6MHkrczFDTE13K1RaUXlV?=
 =?utf-8?B?MExicy9ubGxLYlREZWVtR1F2NVJ6aFpLWEVmVnQyLzlRc3FJRW90MTFldEMx?=
 =?utf-8?B?cHE5VjhYWVVPaTdSd3dtd2dURWtWRE9iK2FBNmJ2UTJjRElYa3YvZi9tZWdR?=
 =?utf-8?B?YU1EY3ZLdW1iR3ZOQTFyRGRRUloxQnRzZ1REYmdRbDJrVkV3RDhsMzhDRWhw?=
 =?utf-8?B?NTQrdkpkR2tXNi9QN1Bvb2JxVTlROW1DUXlSZ1hJc2h3QVZ1M01xNWxtdGZl?=
 =?utf-8?B?cFR3RGhPSXlZYkFRMWNMako5TnlvV2FBSmFoQ0RjQW9TNnFqUXR6bU1aNHV3?=
 =?utf-8?B?c3N0T1VUcENiY1puTWYyYmZvT25LbVNMRXNYUUtSN0hMZW9EUi94MjR0azh3?=
 =?utf-8?B?T0dUS2pvS2FBT2NHZG5FNGtMSWF6ZlcvY2cweE9NUjhhMFdVN3FUcHNmNHBa?=
 =?utf-8?B?cU5NcVJVY2c4ZmNVSkJ5bkw4eWZZNUlPUXRQdkYxVTNVZEZ6VEVaQzM1OEtI?=
 =?utf-8?B?NWkwZDhYUHY3d1oreWpTOHlNSHU4WjJBSnEvVyt2VDlLUUNMSitpb0xFdXdC?=
 =?utf-8?B?cEZhcnhwY1ltTVR0K1lTTGZlak1FMWxXc29QS204MElQaFUyalJSa2lyLy9p?=
 =?utf-8?B?T0g0Rm1BU1lXMTY0TGcxTFd2Z0FhOGJZRDFET2F4YWRJa1lqK29vS2hqdGJw?=
 =?utf-8?B?TFRTUEYrME44Z3lkU1I3Zis1bWwycm1CZmFJcHNnQ0dlOHVrVG5LTkNDSi9X?=
 =?utf-8?B?ZUorTFJtN0dlMlJhVXlzMWF1QkNoL2k2RGxCOWxVb2pyTHVOblg0R2dHTHQz?=
 =?utf-8?B?eHhaaUk3dHlzTk9CVTVrcDZBa0tSSUQrTFlJSktLc3lwWDl6VHprSi9QQXBz?=
 =?utf-8?B?Vmc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41d6e5d-f957-4248-a870-08da94d3e086
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 15:31:35.5715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPZRt+SJ/gCFGKdjHMaiYWdEJNhb4TDtt/n6lpZOg63VrguwysweHNRYg9r+dMZUi018BqeAkFn185YeGhirAme3rMlKxAE8gJVGfyXgo48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6600
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 11:51:14AM +0100, Lee Jones wrote:
> On Sun, 11 Sep 2022, Colin Foster wrote:
> 
> > Add control of an external VSC7512 chip by way of the ocelot-mfd interface.
> > 
> > Currently the four copper phy ports are fully functional. Communication to
> > external phys is also functional, but the SGMII / QSGMII interfaces are
> > currently non-functional.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> > 
> > v1 from previous RFC:
> >     * Remove unnecessary byteorder and kconfig header includes.
> >     * Create OCELOT_EXT_PORT_MODE_SERDES macro to match vsc9959.
> >     * Utilize readx_poll_timeout for SYS_RESET_CFG_MEM_INIT.
> >     * *_io_res struct arrays have been moved to the MFD files.
> >     * Changes to utilize phylink_generic_validate() have been squashed.
> >     * dev_err_probe() is used in the probe function.
> >     * Make ocelot_ext_switch_of_match static.
> >     * Relocate ocelot_ext_ops structure to be next to vsc7512_info, to
> >       match what was done in other felix drivers.
> >     * Utilize dev_get_regmap() instead of the obsolete
> >       ocelot_init_regmap_from_resource() routine.
> > 
> > ---
> >  drivers/mfd/ocelot-core.c           |   3 +
> >  drivers/net/dsa/ocelot/Kconfig      |  14 ++
> >  drivers/net/dsa/ocelot/Makefile     |   5 +
> >  drivers/net/dsa/ocelot/ocelot_ext.c | 254 ++++++++++++++++++++++++++++
> >  include/soc/mscc/ocelot.h           |   2 +
> >  5 files changed, 278 insertions(+)
> >  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
> > 
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > index aa7fa21b354c..b7b9f6855f74 100644
> > --- a/drivers/mfd/ocelot-core.c
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -188,6 +188,9 @@ static const struct mfd_cell vsc7512_devs[] = {
> >  		.use_of_reg = true,
> >  		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> >  		.resources = vsc7512_miim1_resources,
> > +	}, {
> > +		.name = "ocelot-ext-switch",
> > +		.of_compatible = "mscc,vsc7512-ext-switch",
> >  	},
> >  };
> 
> Please separate this out into its own patch.

I'll do that.

> 
> -- 
> Lee Jones [李琼斯]
