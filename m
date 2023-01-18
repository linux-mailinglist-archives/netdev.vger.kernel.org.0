Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F207A671AAF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjARLcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjARLcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:32:00 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2081.outbound.protection.outlook.com [40.107.7.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C4849543
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:51:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWdKa/JMJsZJ9HWLoNBqbzYfkULVOQf6mYd1alRUGsMHZEVSB7faMVbYAjvnfdX5MlsOkIiTkmLQ9Squqbvi+WEP/bQUHIwqVr129cUIpGpa6EGQ31s+Anbf8WYNxnOlljPAdhhIsa3BY6ArNjypbPV3uwtpI0aqR56A3QsII0hDMg4i8tcvPMhLftLaacuga4pUueMT3nhrfLTAUQz5TTscLiSYcg++dsH17wr5Wgh9xWPY3V04OtthtnWriUVI6VHHx4BeDjgdI5Uw5/DsBURnPadYv9Llock2mzKn9Ei+qIUeEbMnBw9GpqRTIgrJjaNAHzeTpix97IUERKMN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KdFZDruw0H48NIDl0S+9XMOWDyQTRFgfFgoS10Sz3+Y=;
 b=HdbQ5bPuDGIfb1izmmvOjYKHisHzsR6v17rzJ2PYbALxIuqum+my2WCkcayAGB85bSNuZWrO6ElxXaPgGQqR4+26V6WMSRdXGr2jlQUObbHRwGUL19VkZVkJAsNAvakAVeYfiMP7AmR3B5NRVnlx3EZ6wo2EkIYK8OHWqtmbJ53AVrwfMpDN1QefBuA036OFRtO2p3WXvxflo9UGcGYjnkOQlCQKBEm3MIKD6oHFZsaLpH9rmIoBHUMiMBIwAWmAepT4G9Jw/LqRWwxTYVxGhYmQlZ6OVUUO//Ebr8h90ImgZjzMZbVyMN4yGdsguwZbLMhO59WSCU28M3XgcWf9nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdFZDruw0H48NIDl0S+9XMOWDyQTRFgfFgoS10Sz3+Y=;
 b=rGW3h0WWpt/ps/NX94BO+oQ4ikW14ALGdVh6yKCvEiAlKMAc8hqaVtGAT2HIEdNigA34FCSSbekYIl1waOVx8qQBXAOcg8xcClZ46tNE0uMBLju6IwpdskgYsWAXK9ZGbWdLSxA15ZCjUV24jYzt+MlYDZGcbZ/XJIgC8jBY+O0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8488.eurprd04.prod.outlook.com (2603:10a6:20b:41b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 10:51:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 10:51:45 +0000
Date:   Wed, 18 Jan 2023 12:51:42 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH net-next 09/12] net: enetc: implement ring
 reconfiguration procedure for PTP RX timestamping
Message-ID: <20230118105142.srez4wnqfwtqmx2s@skbuf>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
 <20230117230234.2950873-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230117230234.2950873-10-vladimir.oltean@nxp.com>
X-ClientProxiedBy: BE0P281CA0016.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: f67d28ef-3d59-4567-1f3f-08daf941fdb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r2s15QOgHESdxkmnUktOQbb9bHKEihSfrEgp7S9liTceJHV4lKglzfl9vAMvfq1ajQ2eGb1pki5xNqUsj5Y0672mCsdD0L8NJdyiInl3EbLEcCH58275YxtKvJysf8O4S2y0d9dahJJqcrqJak00Parh6Qd86RODedHBBOznJhJboxwOcM3SHkLRkllxQK5zyYSbBceA20AGwrB2CyoApnoMU6PI/puiMyitbPvVY7pxxkLtLAnv0nRte7sDZ+Fl3xEdXJpxxYDYBi4bpvJNmkA2UV1Bvfr+6bFG/URevvL7rsRY1D853k6RuoF3ww+eS0SAI6A9dZJ6n0K7xEZxI72YMTXJ8m7uLKE68SHlOLSaq+igZPJmyFRB4YORKVDyEx7CiABySnr0aGGDv9aZE3u8CB07lGhpuigDWf2YSKM3uL4ZDuS4OvQXi+m9i5W+nKUuI+EefYAKjHQj193AH5mc5IUsIw42UsxjQCBWEZkYWGMliHLem+nhhitxpWFOjma1Jl8ljYb1Q0WvZz5qppsOGVjFKfjm7bxHc7J8Zbw5QPxlsHYGa5eWwJgCAnrkqQ960aZIsGBYZKr3ju8xfekIsDnG79FJ3QYvdnbU9cfWaPPcg+4uRUp1WhFtCVxp0wlAHRGSdsdSCXg7GBhNEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199015)(83380400001)(38100700002)(8936002)(316002)(86362001)(5660300002)(6916009)(4326008)(2906002)(8676002)(44832011)(66556008)(66476007)(66946007)(41300700001)(9686003)(26005)(6506007)(186003)(1076003)(6512007)(54906003)(6666004)(6486002)(478600001)(33716001)(66899015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUtjZU9SS0svaXRCbTIyQkVFbldSMUZrbE1EZm01QUcrN0NFS3dHbFFNNHl0?=
 =?utf-8?B?R1FOS1hIU0x1enI0UjZYcjZCTUpMTnc1eThUL0xsNEtnTFVNcm12WmE1NE5k?=
 =?utf-8?B?NjFJbDRVSGlCYURsbGsyRE1nOUwyVGpLTDhaR2pXMWVoKzZTUG82YU0yMDJw?=
 =?utf-8?B?d1luWXhtbnJ5QSsvdDhUWnY4b3RrUjdOTTRrVXdTc2ZkdVpYdjlaTURVOHZO?=
 =?utf-8?B?MEkzZHg5bnNVZVE4anBwZzZ3VFlDQS9acU96ZXYxbWZDeVI1Y2c5Q1NXVEox?=
 =?utf-8?B?RjBCOHFaRG9XOWs0bmF1Vlh6ejBVYWJXYmFQTFdyWEV3eS84MWhabG1XOTRr?=
 =?utf-8?B?S29kNXU2QTd4Y2xZNGY4d1ROSXF3eGw1Z3l4ZGpPMTZlTlBZKzN1UmpxZDZD?=
 =?utf-8?B?b0pZc0F6SXVSai9vWkRuaTRUOUtWNy9KWXYrcG9WcFhPZFo5dmVuWnBUNmc4?=
 =?utf-8?B?a1JsRHYvbjk4d3ltU2VwbkMwODU1eGNyRWZaWklSUzFrZUROa3pHRWJyQ3pG?=
 =?utf-8?B?Z2gxTCt2SnAxcWVvWGM1U0RtWjBUVy9HUVVKWW1BT0xmNitpL0hhVjVEZTBX?=
 =?utf-8?B?RW5YRGs1bWxsRXpnMmwxSFlrR3ZNeHlxcE53RktyU2hRQmtaaXhzNEdJMUgv?=
 =?utf-8?B?VWNVTmhNRmVXTmd0dERWeDhxTFJKcHJUOEovQnN5TmpHU3FHVEw3VWp6aytW?=
 =?utf-8?B?SDZmTjUvdkhNa3Y3aXM3ZnprTytXSnA5NXphZzBkUEtJby9UOFhLOWdXZlZS?=
 =?utf-8?B?NzB6RW9jcFlNYkdydU9LT3JjNG5XNzhpbThmcElzb2dPWkhuRHdWeU9zVURw?=
 =?utf-8?B?K1RXR2xabk1KbkhqM3ZQNHVwVWRNeGJ4WUZGOE9GVEx1d1JwOTdDMnZER1du?=
 =?utf-8?B?SWJjL3dHR29lcVlPTnZjVFhkY01rWktjOU5oY0NFd1RSRkx1Wk5NM2wxY0dk?=
 =?utf-8?B?N1gyZTMvam1CQlRHU2VpWGFlME5JdER4TU4yTXZoMDBYaVAxK0xkQk9kNFJF?=
 =?utf-8?B?OGFTMHdqeFo2VzhiUmQ3MDBraE51MHlZOU1mdjljQVVPeStBNW00NkVWQ3lZ?=
 =?utf-8?B?KzRvdGpsQW41N3BJM2luOURpZzFpR0NycldtOWtPYXBjT2djelN1QTRweHJH?=
 =?utf-8?B?NTd1MmdYVjRjd0FtUjdRZkpCbjk2OGRSbEdCbUMydlFtbm4zUnBQNHdON1di?=
 =?utf-8?B?YStzd282NGlWY3Q5bkNkTlJjQ3RBMldnWkorV1lOZ05sZ2FOT1N5NzVKVE9j?=
 =?utf-8?B?ME1PNExrTDc2VjZtMHJScCtXbEZ6bjhCZlNFZEhSbGhpMGpUODVXaHNaUTZk?=
 =?utf-8?B?UlR2aWJ2aDJaNWdCYWF2bmEyUkhRbnluTHgzVnFrSkRNRTFqa0QvREQ3djJC?=
 =?utf-8?B?WUJOYVRsZnR2Y1dvL0diR0M0RUkxcThzaFR3enNVVGJVRjQvclA4VW51UllC?=
 =?utf-8?B?ekJpdTVrdWkvUytVWjQ2VGxuSG15eGVkMllsbTgwL0czdVBvUHVpaFJBbEdw?=
 =?utf-8?B?UGVIMVJ1Y3JuaEQ3QzROL3dMeHZJekh5aWlOUXVROW5tR0ZVSnp1OVBtdlRU?=
 =?utf-8?B?ZUlGVERyQXpISVppREtTbVMwR2wrVFAzdjJtM0xsOEF4SVZPb0FsYTRJR2s1?=
 =?utf-8?B?TldRbDZCcWJyREljSGRuelJpcTBPOUQrRCtWMjhDOWV0bnFMajZJcFdrOXJu?=
 =?utf-8?B?b216RDgwTEREdlNQSXoxeTNBU1lnaExHQ2Y1Vmp4TURIV1lSZnAwL2Fad2FS?=
 =?utf-8?B?ekNCSXc3bHBYZlgyUE1wdUZWcVd0K0RWTGRnclJRV3VaZjg1TzEyNmduSEVw?=
 =?utf-8?B?eDl0elpsS01wMnhiZVRDbmNoUEpZYWdtUng2WkErUEE4UGdDT1VzV084MGh6?=
 =?utf-8?B?cXp6cUtiRlNSMGx3NDg4ZWtvQ1NRN3NEamQ3cGx5RTVSTHM3WEphMGZ6ckpZ?=
 =?utf-8?B?LzNsdGR4SWl0d1V4N1VVejB2ZHBsVlBqbUloZ2FMYmxHVy9Ganh3QmduNGVD?=
 =?utf-8?B?YXNmaDR5Z1V6SjlzRVZsUGRoc2NMa0UvWk5xVnBwQnc0bGNNajZYakQ4S2Vq?=
 =?utf-8?B?cFg5MDc1ZUlGdDJlZWJKSDJDQ0ZNdE5NaUlaUmZ6YUNsNGxHc2Q2RWRCdjVV?=
 =?utf-8?B?RHRaVWxQeEpzRWV3Z0d4MloyaFpBd3gxOEZwaGhOaWx6VFZCRFVVdENlZWRH?=
 =?utf-8?B?K2c9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67d28ef-3d59-4567-1f3f-08daf941fdb2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 10:51:45.3345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCFvviHgeQSOanyKxp3iMYtWZ3t2d1h5cyNgEMILZiDPUp8NXVcrMFH8XcAiTKTFoq28XNwTNHB3rZtfNmOn6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8488
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 01:02:31AM +0200, Vladimir Oltean wrote:
> The crude enetc_stop() -> enetc_open() mechanism suffers from 2
> problems:
> 
> 1. improper error checking
> 2. it involves phylink_stop() -> phylink_start() which loses the link
> 
> Right now, the driver is prepared to offer a better alternative: a ring
> reconfiguration procedure which takes the RX BD size (normal or
> extended) as argument. It allocates new resources (failing if that
> fails), stops the traffic, and assigns the new resources to the rings.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

There is a transient build warning here which I didn't notice at home:

../drivers/net/ethernet/freescale/enetc/enetc.c:2492:12: warning: ‘enetc_reconfigure’ defined but not used [-Wunused-function]
 2492 | static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended)
      |            ^~~~~~~~~~~~~~~~~

because enetc_hwtstamp_set() (the caller of enetc_reconfigure()) is
apparently under #ifdef CONFIG_FSL_ENETC_PTP_CLOCK.

A later patch also uses enetc_reconfigure() from enetc_setup_xdp_prog(),
which isn't conditionally compiled, so the warning goes away.

What do the experts think, resend or leave it as is?
