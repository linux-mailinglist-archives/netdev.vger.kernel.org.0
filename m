Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9658B614351
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiKACji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKACjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:39:36 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2094.outbound.protection.outlook.com [40.107.102.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6B2178A4;
        Mon, 31 Oct 2022 19:39:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbPnyHcjPK/5cpyXtSTfvMwoMTtiI6vRtWXBLkqjYcdor+ioHIuyd56N89SEuRMwelDn6Twt0DetZOYOUuIv3p7o4ufiQ4cXJBDaXZwRYUhFaa4lAQsdq6hYCCHe/r1/vDSJ93udxf4mezQfILlgXZ2ubs/MJlMe803NAz/UO6J0RtxVzEgYIEz0sOyF2Dos3PAbnXr9UEuqJiV9PmjsKh7Qoaou6W1OED9gyGbL1iJWolAKJpQOLEFO3PCwFw7daUFXAZaPMn/TLKrwEVg1vYuZ/H7/QUT52/ul404k8lTbFg5nApLUYTIZ1MpohBB5buZrsnYpboPh1op3ppH3Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VpA6EkdyBszS8fGlzsTF9Ec2VZKMRigF3bYHmhoDLkY=;
 b=KZ8XgtckGNgSE3KmFGvVPHob3TdZnqWvI3SA7koo0x3iWuAa+QRICjSPR4OaoZZXjdi2hnfVA12q2DJnxFbrESz1STeZBNuF38cwyUtG/L+fb18OxwSWsOihzkHG0SeyxBlE6jh6tzDFzvbQBLzQw6GmWH1CFjw9SL6K9FI3x93gx439AzP+B6j14rk+ZzbXMOsN0DVAD8FNrunPvWy0lpacr6+GlwtFLeHju3g6BMeetUJYUpzZwxLY04ASE03hbxw8FygjZ8tSTTxVu8UbRwoGdrxdvzGjDESvHF0JyHzyGldvIbDMR99TU1P7s7kf78unwtDQq0s7MCuvkabjyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpA6EkdyBszS8fGlzsTF9Ec2VZKMRigF3bYHmhoDLkY=;
 b=FSxqGxaXrq3bGv89LpBaKQ+X14VI5FGLwgPAV0ZhHS+kIcpL4i03/fRkTZCobOu3hl6lfiJB7gk0yjcoWrMEX9zKEKMFXVV6/A42d/mwrKp5SROKGZVuc9THBvHU3uXg5Cf7HljuXnAIMUss7+91r5DIjuTm9EWOM4bPt9bwu2Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5177.namprd10.prod.outlook.com
 (2603:10b6:610:df::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 02:39:31 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.016; Tue, 1 Nov 2022
 02:39:31 +0000
Date:   Mon, 31 Oct 2022 19:39:23 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC v4 net-next 12/17] mfd: ocelot: add shared resource names
 for switch functionality
Message-ID: <Y2CG29z9TroiQ/kr@COLIN-DESKTOP1.localdomain>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
 <20221008185152.2411007-13-colin.foster@in-advantage.com>
 <Y1+Wxaub15XveooC@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y1+Wxaub15XveooC@google.com>
X-ClientProxiedBy: SJ0PR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:a03:334::10) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5177:EE_
X-MS-Office365-Filtering-Correlation-Id: 13d9b4a6-4f2c-4cdb-ab0f-08dabbb24de3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDjms9SRzQoGzwlgoLqCFPDATaPmK2ZdU4vaWjEGirBdDq/w6C31zpyM2qh9WLVTQiQoIN1JlJJ5qyf6uYkguGFSAdDBAdjEGDC3mW6WhPJc2KbFcgvurEV0uJpo32hSp63Yw7lV7ngOOU6bcRZ+HoaWWFqGBzGpBDWs6zltrO6HnYfFx3r/txUZW3kzXMRX40af8NZlkXxzNbZK8e6PlZyqqMEZD2YgKzE/f9t15eqdz2QpyMVggBRReAo5aSuaZoRUk+X46UmUCN1J8HZLsKQ4U4Jd5AXiGNlEQ7VvkdsNT1iG4Xrm3ou28qsJ6Gn5fL58F6UQ5o4FnyWaO3QJy02lsYXBtQhHEDjXXVbJRu6pY3KmMXGul1ZwPFcF5HHv1Iw7A3Sm6sBSYYfkiaBy4HVHUlGXMxo7m/4S+/INr6mCwd/l3AVaD1I/Q1R58DFDe5xaQ9uYRvh74Y1mJHraQUf4ntCQXO6uPTSOicISbIG3y7/TdJ9tuYemr/VuN852mI9aweSuTs/exlETEevmeRHdTmJd8vFCL+R2F5bjSCRp7puS+xoyEeb6IfOURfb90x7O7moG0wALVPgH9kJnkWPMaQ9q9Da/ULcF/0b/0vrvDSJsru4MGCBZJ2aa+L+eXcozf9v0HGGDNzI4qL2bJ6lo9Jtl98tCFgKcGG1TiGKHkc3oVfjkajSHF764d2ltjGmojRYo3KORgz+k0+IANg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(39840400004)(376002)(451199015)(41300700001)(6916009)(8936002)(54906003)(5660300002)(316002)(6486002)(478600001)(44832011)(86362001)(7416002)(2906002)(38100700002)(6506007)(9686003)(26005)(6512007)(6666004)(186003)(4326008)(66556008)(66476007)(66946007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1ZyUCswRUVFMmQrSkVaYUx6alZWN3ErSWx0RXBaRTBKVEhYcDUweFdBaWxx?=
 =?utf-8?B?VGh4UkJxSGJ4M2J6ZjF4cXQ2dVBweTZKUW1hdHhjckxWUkVDaGhNZnJ6SlNh?=
 =?utf-8?B?TDVuMVAxVlRVS200dDRLa3EvY2FJd0VDOXlkbjNxQUFJcGZZZ3VuUGNxVUw3?=
 =?utf-8?B?VjB2MUlHY25BemRjMG1NeGQzM3lrNUNuREh5amVzOVVlUjJSNjJxdC8rU3FD?=
 =?utf-8?B?OVpMVHlQZDRPdU43NDNGRDgram15TXVuVTNTOHFudjVEbzVhdHJLUmJUREh1?=
 =?utf-8?B?VDd3cG5zOHYrQTBwZ0UxL3ZJb00rR1l3dnJ4TmpLdTMyMWkvTDhjSFUyUjR6?=
 =?utf-8?B?RUh6Q3ZLVUQ2M295aEV0cHppSjNQaVkyZ2dLRmx1blF3aFlXdTVmYlNXeU91?=
 =?utf-8?B?Z1dMTXVyMDlwTkpOSHFvcGkvOE1ueGQwcTJoRUpMQUxEOFFpdjIyZjdYaXhr?=
 =?utf-8?B?VzlqNkZ6VURueHBqdkdHckxEWEZtNTlpQXVDcVlRTnFDTThJbFkwY1g3YUJP?=
 =?utf-8?B?QUJPZ3NqanNtWTEzc2lmQ1dJWk5YMnNqWHZ4cEF6OUxSRjEzc0lPWVJqY2xJ?=
 =?utf-8?B?UXIxTDM1b0NBTkpqcktmNTJ6aGNJdmR2eUYxNXZ4MDNadHF2VldHNEFpL28r?=
 =?utf-8?B?R0NFcnN4SGNzRlpQRzY1c0gyREFWTmhSdmE5c0Q5a2xwWk9pUUx3aksrZCtG?=
 =?utf-8?B?WDA0NkFuYVQxdm9peFVCQU1Ib0JlditibTJ1QVVjUEgxRnYwcEVROHN0MUti?=
 =?utf-8?B?d3ovYUR3MGFhNVJ6V0Z4dWcxTXlSN0pJUXR2OTRBZUd0SnIwOFhPN0xvRnVx?=
 =?utf-8?B?ZEYzY3l3RWlYV0huVGNBSkFqbjMvbnlQT293MmNTQU5sQmwzNDlWOG9leG1p?=
 =?utf-8?B?WDlLb2E0NDB5SEdwekN3emNidytXUTJDM2o3YXZIcHVvRlc4VU1mTGNEVFl3?=
 =?utf-8?B?N05GNHdCZkhrWDJVNHVNR1liT3dTNzNYVmdHTWZkaXBheXJhRlJVb05mTXVu?=
 =?utf-8?B?ZlY4QlJ1ZEthYi95aXUzZjZDU2w3RFgvcGd3cjA5eUZweVMxdktjZzNoWWZz?=
 =?utf-8?B?ZWVranFnMG1GQm5kVk5VUEcwS2gwMlNUc0pxajh2alFvcDZpUWtYaXZLc2w1?=
 =?utf-8?B?KzlzV2QyOGN5ZWY1OTlSaHBoNnZNV1B0KzBjTmQ1YlhJOHFRZVliTmN2MW55?=
 =?utf-8?B?TFdHS3RnZnBnV3dDVExKdFJjL0VwYlEzcXVja3daZXB0bFFsZWJUQ0pKQU1E?=
 =?utf-8?B?SHhIeXhvZENkNW1mTWlBT002NWVkakorYlJCdHJrZktZdGsyT3k5Q2tUdFhJ?=
 =?utf-8?B?N3JrbmVsL3JnckZ3YWYvVmllNVpVSTlzZWNTSXZibUNPM2t1RXd6SUhOWjRF?=
 =?utf-8?B?RTNkRlZwVW9za2VuU1dLbGdGeldkNHFIZ0hBU2VnSU9XK3IvWE5zQUlxbHIy?=
 =?utf-8?B?T0xLamxEZnIvRFk1VTJSTU9RZktFWHBVdkV5SzNFM1dVZDIzWlBxR0xRV2VR?=
 =?utf-8?B?cjdWaHJXRyt1amdaakY0a3IybHFDSGNCYjArU2hBYUNZVGFVNWZTeFdpNG9a?=
 =?utf-8?B?UlBOWXozSzZEcVpkZ25pUUhuYW40bnJiYWwrRWlmTUYvOVE2eGpPVkluL2hM?=
 =?utf-8?B?UEpBVDNXSnNqc1BueDY3L1FYMDZuS1hkUHVKQi84M0NaTnNiVXpzeWZIbzM2?=
 =?utf-8?B?ME5nT3g0K2gwQ0hlQjFsQ3dETTUyMUVhVGM3WVFEQ1lyYjNuZ3FCbUNvWS84?=
 =?utf-8?B?czVacU1VMys5cUY1ekxuMTQ2Q3duN0pSbmN1TWVZTDVva2gyQTNkVkkyckx1?=
 =?utf-8?B?cVZsN25JVHhlTmU1cWR4dHVxdHNxWkNXbmgremx5RjYwcVUwRVJCbysvbHhR?=
 =?utf-8?B?MEpEMkJnU0VMZ29rb3RTdkxTdWgrY0JnOWVBSHVvU08vcUhGa2hjRlhnYk9w?=
 =?utf-8?B?NDE2TGRERFpIRlZ4SzVKOTlCZ1lhVzgxYi82Q3luNjRoWllLYUJMRDVXRmVH?=
 =?utf-8?B?L2JpUkpobFkydTV2L203QXRCc0YwYXFncXowdU5EUWRQUXhiVkdHZnRrODNI?=
 =?utf-8?B?eTFDbmVRUXI3R0Y0empLVWJBMUp5V2RkVXpIbGpJZ2Q0cUFrSm5kemxjREZM?=
 =?utf-8?B?cFQ4OHppS1hnSW9ucFR0ZFRrRlJsa2gvc3E4eElXUGZlMDM4S3M2KzdmT1l1?=
 =?utf-8?B?cVE9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d9b4a6-4f2c-4cdb-ab0f-08dabbb24de3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 02:39:31.3247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUZUf0Mps2jzCl3ag6iDQhO+eTf5bAO8kug0q9lSQz0QdLjtoWJyxOgj1t5gtfMBI+oUZYjx1pD4UeO4rXi4SDg61Du6TRhNDhHkWKjwOhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5177
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lee,

On Mon, Oct 31, 2022 at 09:35:01AM +0000, Lee Jones wrote:
> On Sat, 08 Oct 2022, Colin Foster wrote:
> 
> > The switch portion of the Ocelot chip relies on several resources. Define
> > the resource names here, so they can be referenced by both the switch
> > driver and the MFD.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> > 
> > v4
> >     * New patch. Previous versions had entire structures shared,
> >       this only requires that the names be shared.
> > 
> > ---
> >  include/linux/mfd/ocelot.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> > index dd72073d2d4f..b80f2f5ff1d6 100644
> > --- a/include/linux/mfd/ocelot.h
> > +++ b/include/linux/mfd/ocelot.h
> > @@ -13,6 +13,15 @@
> >  
> >  struct resource;
> >  
> > +#define OCELOT_RES_NAME_ANA	"ana"
> > +#define OCELOT_RES_NAME_QS	"qs"
> > +#define OCELOT_RES_NAME_QSYS	"qsys"
> > +#define OCELOT_RES_NAME_REW	"rew"
> > +#define OCELOT_RES_NAME_SYS	"sys"
> > +#define OCELOT_RES_NAME_S0	"s0"
> > +#define OCELOT_RES_NAME_S1	"s1"
> > +#define OCELOT_RES_NAME_S2	"s2"
> 
> I've never been a fan of defining name strings.
> 
> The end of the define name is identical to the resource names.
> 
> This also makes grepping that much harder for little gain.

I defined them here because they'll be directly used in multiple files.
In this case, drivers/net/dsa/ocelot/ocelot_ext.c uses all these defines
as well as drivers/mfd/ocelot-core.c. Future patch sets will also
utilize other resource names by string as well...

But I'll plan to drop this patch next round unless someone disagrees.

Thanks for the feedback!

> 
> -- 
> Lee Jones [李琼斯]
