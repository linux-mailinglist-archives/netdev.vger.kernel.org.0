Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20E56C27EA
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 03:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCUCO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 22:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCUCO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 22:14:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2115.outbound.protection.outlook.com [40.107.244.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A56F126FA;
        Mon, 20 Mar 2023 19:14:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9MxZBe3yXuvHWTmoyiarBiDzkTYQ177ewa48UvfQz7aPy7NnBHHpdBwGpnXrc8p7qBlmxLDdWTl5RfmDeEexqkF1+A4ndksKySumaQLnUUZqAH+dwTqepiTOdPHuxnfE4uEetW3z6YA2zOvhCNEZoN6MAM91TvUcgr6uNvaWEIe+QXtxzTU7ucX7E4hgcB8+dhVUrkk73Y/BH4ejM0t7SWY2oBBAdvBTDlmzVY2a1n+kqNhlaxA6ZnTW9jMwM+eYiMbJml0XHaN7fhXljUpcAZkADQcDwTMSNm+0a8fdZbIE807XBjYsAEuF+nr6cCND+UAJefN5kQvbm75fVAXiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9TkPO83+F1CUsliZKud2koHXNtW4Lh5bVCt2+MU1Lk=;
 b=lVPSfgN4lRvaSObj4hBdmXy9ELlN9d+vTv/nMXiap2dPZrW3jDLUSOlDUA7BvxmWvFUOL/AQHxs8jymXlv2J0yq3O8i0K8tL4Rpjd6EoUT8iPzLZJ7x0WC3OkdJTLRHQ7vqEb88xvbblQ7/WJnDt+20OI6kB2fb3Aacd0F4vbvJQpkYyQ6b/fRmb43S/DXriabfMONkv4IWejGsTV4zjMzAlwCuqa+gXC40hRiFDM1ONNxT3Wo3xy5B1OIt7iVWAZtOKN2dEoLKuY+dODTIu6dOzv+4zwMofnETl1nRaSVQBDQt1AMt0IetgN5rIpvuBXtk56nZXelzr6CZcdY15Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9TkPO83+F1CUsliZKud2koHXNtW4Lh5bVCt2+MU1Lk=;
 b=YkQ4vchYWyUFovfdZdIcrsqhsxg32hVDeMrCaZiR1sqQHArfvSOVPhGuVygZBcuogamh8fsmaJCPybqiLKJvYsxM3F+BqIR0vDz8OhkqT27PrxKkKm32TaEl5Mxkft9c0p1h7hbI5MRS0TK8cdhnLT/GrZGGsBnuj0LD4LSiBls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4772.namprd10.prod.outlook.com
 (2603:10b6:303:94::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 02:14:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.036; Tue, 21 Mar 2023
 02:14:23 +0000
Date:   Mon, 20 Mar 2023 19:14:18 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] net: mscc: ocelot: fix stats region batching
Message-ID: <ZBkS+oLNkFAjcDBn@euler>
References: <20230321010325.897817-1-vladimir.oltean@nxp.com>
 <20230321010325.897817-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321010325.897817-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: BY5PR16CA0011.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CO1PR10MB4772:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a1f24a6-5aa5-4ad5-2eda-08db29b1fc94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bA0y1X1njteaGMlK1Bkz3NnjX5iKPourL8uJjbLEMhdkg5JBCShiMEO7FQOVk8re+17+RaGy6Z1Z+ggNCOybxEMFulYvU7s++2stavjYwrLp3JHJbIDUkUQ6W+mSFdv3BfA3Yyfz2xjjNldk2hQdu+pmrjLrOlIj/EgZoEyZSMPMWLVqva1ZpNl0H6asHfBSr3JCkuKpmH6oCILe+V6aYjQ/EFQiTcIG63OvhdwhrlD4lrpy5WXgbBtP8yw5FHKdlrRAfYOG61knjXWaqoJc1qacrgI5J59p3QucfsXP+jgN776zYCkyQk71x3Umc0YeYEVSGSLo+NiVoWsAKZovlZ8YPTIMuNb2L5GimpM6gDkdyyz3Es1fRMkvqQkhWfJ5BDetJMlBuqNthf82+tKRjDocS3U58vLMGuVnX+kCc1bjdfrNPg4eZwkbFnzrIFGQKNdJBtIRzMDsvE1FjPiw0WdMeqhEQmgBHYojtqBJqN/NQ306Xh7xRecqiIEbocwFxit6htKeYchOn40mhzKQ4EZTX35dZlxv3vcRj7ULnLnteateo+LteLyKDIQDmTM/d2FC5s+19ME7bQUu0Vbedsq3Biqm/TNfZrKOlksx9k/fAWbriU0DXzUJ+gjlUmy7Xyr3UNrfqpxXbSDI0F5bh2UH+jkn60iEZdyXFu5ZLiWe5xEIhfUt19H2hV7dGJAF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(346002)(39840400004)(366004)(376002)(136003)(451199018)(33716001)(316002)(66556008)(86362001)(83380400001)(9686003)(8936002)(6506007)(6512007)(26005)(41300700001)(186003)(2906002)(66946007)(8676002)(4326008)(6916009)(66476007)(6666004)(44832011)(38100700002)(6486002)(5660300002)(54906003)(7416002)(478600001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fr8akqCjz8J358JRtmVFkf4AzGGwYFlPOuSN3a6KAyg8otjbVmla3vDlJlwQ?=
 =?us-ascii?Q?AmOuNzGvS0MlXOtsFiEynx+e/tUWoUbRML7KRDjaOJp/En0FgHmS9pLIu75w?=
 =?us-ascii?Q?tqKf7qzp6/eRQWOCWC/OEUNcKZqHYkBxAehi3GlWTMrUZdw6JWbfX6ujJB8b?=
 =?us-ascii?Q?XGYx5Fbo4Hu44z1mVnHGO1f/pH5PApl+IgloAn9Yc1cCyR3BGJ49d4I+zoJR?=
 =?us-ascii?Q?59H8IKxpqN/4kCQLWX34jFu8/EebfriK8kTQ2IBdf0VlakUIgEb1ahTx+Djo?=
 =?us-ascii?Q?Tf115xHX2DsbO8y4dWkyPftkVJLOGNo+9s8KOnCzZUf+coN7KeZBZuw8WVBN?=
 =?us-ascii?Q?DD5XIXx1kNmlBGnsXGLAtONTRPzRkT91l/o/rNkc8Y5PgCn714qeipwA7xUk?=
 =?us-ascii?Q?VaSaZHeP7HdTaeKgCd3wjm71dcbsXfiQMhsGDpuv4n4qmsGWPV5JlgVoh4yC?=
 =?us-ascii?Q?xBCLwaMVf4EaGS+1HabuEidy4pn6JPduoKJwQMBmbHYwBUW7b6hFAP1hBE7Q?=
 =?us-ascii?Q?GA4kYvDvHncW0hIUxSDC2Ww8jSbINRn7SmH9iHVIxJsF4KtQNfz6MWxsf294?=
 =?us-ascii?Q?7SurXxMAh1D4JF7Eq8gB/2vKsHu2s0KW96xVwXi4NIN4L69wfKXj5mWdYdYY?=
 =?us-ascii?Q?7C9UhQFc8Nwha7m7qDbI/bEgaxmaTn6ho+RT9mc/XfpG7e9/jc3Uhd0rv4Mz?=
 =?us-ascii?Q?fl8sNEvxhLkf04wAzQq0yx+efqwMe1shgr2Ug5xl2jasV70y3x5MsYkoZEbm?=
 =?us-ascii?Q?HLiyvJL9TX/0mOyAodhidBFIIBgnnxKp63lRlOEN+TMCL9R9+4IF0/tMCt8L?=
 =?us-ascii?Q?v40GTN9A9C5NOi5dIFLlpq8TN+EVc9LjqPD6vNLliLznvac8SKBl7xISPxSA?=
 =?us-ascii?Q?qO7pFYP347tGr44cFt/0Q/+vZ4YhIPZHdmPYDi+p8g7fUZY61MBwcU18vlJA?=
 =?us-ascii?Q?A6hateTt7VmyXtZqmEXKIRBYcN2/WI1Qe+BlGdD7BcWGuqq+Z7wsdnA7DzFK?=
 =?us-ascii?Q?r6DCgWAAHj0tQ2x95do4+rsXmZxiGxv1XgxOUfYD7qr8YJ7v5WwsHh1GsVVW?=
 =?us-ascii?Q?ce5ah06QtEpzvXRLNC44PQPQ/bGjJ783O3izlgX1K+rrY9KrdY30N0jl4QkB?=
 =?us-ascii?Q?AAwu2w57EoBz7ocsNXWdWfqhaIu/It3fEeO47z4aQy3Lh9tZdQa3xuaBamCV?=
 =?us-ascii?Q?Pe7vjOo0j/XuA6ZP5Hn+DY6gspmDYQdUT8EBYczrSpgjtFQNgX2iczHCHphA?=
 =?us-ascii?Q?Xh75oLkweusupRWm/q3FdPL7nBKKRa66zvb7MOtqnDOUNcYKw56VCOz0ATxx?=
 =?us-ascii?Q?6TVnOa/ByJrpUrYgkhpSCS1EYDjy/fX7Uu6hwI0y3kAXmABKKcQ//oRmlRhB?=
 =?us-ascii?Q?VUIqRIj/dxYLA41lKVuwOjg/MznC9jCAirddGx+Iiu4P/4rp6XFCbij3aVM8?=
 =?us-ascii?Q?VL2xFmD+PyaylGCZtKgao4Z0YOV2X9U3UyDPZjc+TYA0pQTpPo5STOH5ALxt?=
 =?us-ascii?Q?FIV9CkA1I04izJFqsRV1AktO1dIKzN3QLebMikD/UhSQwcI/oCzDDLkhKfB6?=
 =?us-ascii?Q?JZrrnU8AQBdGmaqk5FpBeB1I4Dl7MpW/tBqW9bC4xWvr3uZxZ6IG7DCYKfag?=
 =?us-ascii?Q?ImAJEEu6njnsTT5jYD1rttc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a1f24a6-5aa5-4ad5-2eda-08db29b1fc94
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 02:14:22.8608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qr3euK3eJq691aNUKfKhbziuSNDX0qLxVGA3xHIQWhv7A54i8K3g5H6xdiC3Xs1Q6yejdZODBYohXBiPcKffTtqpxLv6QmTEwaRJoM2miY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4772
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 03:03:23AM +0200, Vladimir Oltean wrote:
> The blamed commit changed struct ocelot_stat_layout :: "u32 offset" to
> "u32 reg".
> 
> However, "u32 reg" is not quite a register address, but an enum
> ocelot_reg, which in itself encodes an enum ocelot_target target in the
> upper bits, and an index into the ocelot->map[target][] array in the
> lower bits.
> 
> So, whereas the previous code comparison between stats_layout[i].offset
> and last + 1 was correct (because those "offsets" at the time were
> 32-bit relative addresses), the new code, comparing layout[i].reg to
> last + 4 is not correct, because the "reg" here is an enum/index, not an
> actual register address.
> 
> What we want to compare are indeed register addresses, but to do that,
> we need to actually go through the same motions as
> __ocelot_bulk_read_ix() itself.
> 
> With this bug, all statistics counters are deemed by
> ocelot_prepare_stats_regions() as constituting their own region.
> (Truncated) log on VSC9959 (Felix) below (prints added by me):
> 
> Before:
> 
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x000]
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x001]
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x002]
> ...
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x041]
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x042]
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x080]
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x081]
> ...
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x0ac]
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x100]
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x101]
> ...
> region of 1 contiguous counters starting with SYS:STAT:CNT[0x111]
> 
> After:
> 
> region of 67 contiguous counters starting with SYS:STAT:CNT[0x000]
> region of 45 contiguous counters starting with SYS:STAT:CNT[0x080]
> region of 18 contiguous counters starting with SYS:STAT:CNT[0x100]

Yes, I verified this with:
`trace-cmd record -p function_graph -l ocelot_* sleep 3`

Before the patch series, on the VSC7512 a call to
ocelot_port_update_stats() takes about 14ms, with many calls to
ocelot_spi_regmap_bus_read().

After the patch series, the calls take about 2ms, with four calls to
ocelot_spi_regmap_bus_read().

Acked-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>

