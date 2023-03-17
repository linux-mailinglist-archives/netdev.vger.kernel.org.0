Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73BA6BED34
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjCQPpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCQPpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:45:50 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2077.outbound.protection.outlook.com [40.107.6.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4174D42D
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:45:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMAZElqkvTwT8Se4dzi9UcApSmDyOAiIfUTEcUSawM3OvP+R1JI8MJfg4ywuV3LEgBjBbPKRSCHPqLFhJVtmV+R2oZg1nVtrEtCjp42LU7RfKF3GRseSsY++yoBGTsCBZsPj0TIhtinm0Sx9wL/rONCFVoiWJ/1IaRX3+/ek7WhP0EWpzpdsNv9jOwgjHuww6TsShN778uqixLaRmbVNKDR5UwmuvWIUZX/ugAVZ4E4Xkw3U7Dh63wglKikKg2wKS+gQtplqFiXLBr78l6aqfYLP1DcC27CoTXreO3HCkCXJ4QWaQ6VtvMeY6eyK1m7iChOmSKcnn+ixZ0v/1Avnwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nT6ftFhglicpFtfgkdZi1Sl7nqccSvFUJu16+SkvkB8=;
 b=Nbmhz1BaIRLwGm63FI1mYET36psMn0D7kBPh1A1WlDGoDVmEL6SxiOOqk4GxS25gFSsOXc7TpNfKaVXCHclXWa4OfHp9KIDdieTmaDCh0+AEmU5KDf7mJmvfgoKtXXWSzr8XeYUTuCVG7MB3vvnytcIt07Ti9FIgmiAzHEPZ/I7OCulvK5riB7fQ+a5lVGGKTMETEmQ7Hz470UKbeqxSREENyofKGKiFeh1GyfYkVmLZ2QGsuN6XjzxiBTvqpYwfEbILfKY+VNlUPFfvaheRl4RlkR0K3ZKE0q9sKPTWaTInLtVaw/f3qF/tq/8o91QPwyODbux7PlFeYAZjDzIq5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nT6ftFhglicpFtfgkdZi1Sl7nqccSvFUJu16+SkvkB8=;
 b=oXZmchvEMMBiAnFDwdpn4wZ+JM87y6f67iLRZN11hcDvICmKTA4T2VmnVjt/claL5j+n8zLwsmPinOwNmURqoqq4iYesoIu2sHJtxPMFJHY34ES2c09CRqrTYt2+hPu7OT0JyvmJaB6T0yAsLwe0KAm9ld0LnF5JVX+pmKHAX+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by DB9PR04MB9867.eurprd04.prod.outlook.com (2603:10a6:10:4c0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Fri, 17 Mar
 2023 15:45:45 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 15:45:45 +0000
Date:   Fri, 17 Mar 2023 17:45:41 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Message-ID: <20230317154541.e74slo6bqh573ge7@skbuf>
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com>
 <20230213113907.j5t5zldlwea3mh7d@skbuf>
 <87sff8bgkm.fsf@nvidia.com>
 <87y1nxq7dk.fsf@nvidia.com>
 <87ttykreky.fsf@nvidia.com>
 <871qlnqt7k.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qlnqt7k.fsf@nvidia.com>
X-ClientProxiedBy: VI1PR0701CA0061.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::23) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|DB9PR04MB9867:EE_
X-MS-Office365-Filtering-Correlation-Id: 313f8f6c-e926-4f56-0064-08db26feabca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CiyPazXhi0xJvSzxLH2NXKUSsWUd5pMwE4x+YqL2x2Il9CeUlQ1v062rjAkKJ2zrbst2tzIVEWS55VCgvDN+sNLY8YOUc3XIjixUlSbTlGbIxzsWXn8xdXAQKsxX+zzcgGi39ptTwCXeul1uFZgg+cT3Xrpzew/7Q9eLfh8Y4/OAMXU14QUZ+11PUcCwgIhEhf0kf8tUj98DiOgRxvxE5pl2YIWogOLT61NYhBuCPXmSmBh8qTtYLY8j4FjHqRKqCUldCuQ2H+UHs0YPfxV5kt1VqsnlN6e0eZuGlZ93NFtXzK8FZkIbjidabjHjeWpyUDoOCdXOQbs6N9KQL6iZF0LpG4hR519eIE32kNmQ5Usk243Aky/gH/o5XW00ADK2r7JyhSxHg/JnBTNxNmI6cYnxMxEJWVoSiaA5tzJKS+/t/xWdoIZwVOyeapllP9jLLjrJOhxYhXVUtvi2de+MikxuzPe/13/jJUNVKeX3j2PVKf08asrLoEBr3K0uWX9UD9y6am+c1Qja2bf7psPit8Tt1kru5ujmgpFmEj1YzE3LAWHM+XUquO7fQmLDD1wVvD0AkoUbYLKS1TrnY3bEa9/7LMgIatfgyFNLnf+d5IplmzDLNFVHnpvYyhbQBnoO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199018)(86362001)(8676002)(38100700002)(44832011)(8936002)(2906002)(41300700001)(5660300002)(4326008)(9686003)(26005)(1076003)(6512007)(186003)(33716001)(6506007)(316002)(83380400001)(6486002)(66556008)(66946007)(966005)(478600001)(6916009)(66476007)(6666004)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y4LZe3R0qfbAVOiwBprGcgmGeGQydpvCX+21HeRdGukAvb5EppdTUvHpwXCJ?=
 =?us-ascii?Q?VNp+Q/D0SINsbM+kScRQrDqlVK+Ecuia0DoqwXUdBxQxFbXQ8IauZQ8spFis?=
 =?us-ascii?Q?9uZW5xR+YK6nq+WaXzuWPcg94536wNmOxTqiL/+e7OI4M4LZcMa+1SfalZra?=
 =?us-ascii?Q?sS0qGHzil+KnCn1+jmjHNOfqyQ3J8gC2iAGq7Utp/bidjLWvg5VWwTqJ9vyl?=
 =?us-ascii?Q?psDZpPuWIBgZhFdIQ0XeKSlqn9RH6oOI8Ye5eN1XrLn6YAXnhrrPjyBSIcqE?=
 =?us-ascii?Q?eRXDPHn73NE68RKuk1QoKKlxsgtXdVHEe4tCXTlrx4j54SvE9Laiyj+c1l5W?=
 =?us-ascii?Q?i2ToUkiw4VXwo2dJzg767/+O9RDehnL++QDBMy3HgvQ9U17h49OSnxCkNHx8?=
 =?us-ascii?Q?7CxlStEthi2cPr8kvXNoUytX7sbtl3m7183mBYu8OTPega9omZnaCzJE4BkZ?=
 =?us-ascii?Q?WAuoqx0Y9BagmoyL5GkIVUWoZcmS5Iq8Dkiqjb+hDP2WmzBgYwEFuN3MlcAV?=
 =?us-ascii?Q?YyyHhmCe0Gpry83PA2IKIGiP8P100rrVNZ0sH0r4dMxZs2fomzr5XcvIAyRl?=
 =?us-ascii?Q?TMz5+0FBRkLsr5btCbs5Fq54M0Um0bjr/BQgnDOdjTChoBfb+2eJL0wRTpLw?=
 =?us-ascii?Q?KyExhsmN7DbP+Yx0kWI9/m/SxL//atcRKbNZBdnMcsKROFaTHAG+BICvLfdR?=
 =?us-ascii?Q?i0m79GcI/UPZSHN1pLaxq7topXDYc0Pz196UM3lVpW19jhPkOwrXKO2fme21?=
 =?us-ascii?Q?7ivOpYKymtYqxs+73CnDH+CMenuDx7nqWxwbvHHuxY7apMiFy1g44ms1NdRK?=
 =?us-ascii?Q?GOIZmjE9e02NPL6A0uqbyMWPLmi5k/DQX/Ox5I7AoyWUcVWnnVwRZTnyvLzq?=
 =?us-ascii?Q?5gq7rn4C9Uyt90wPyw2CzKRDAx0P5J2K4P1PzvZHOJgnKKRCjrCHSqgHKOA0?=
 =?us-ascii?Q?/PESuQQ2cDQluPOl/qjtyMccLkWFagMdqMBUawyIcYtoHrty5kVrIj2y6/F0?=
 =?us-ascii?Q?BAtHy+W+pc78TYRCdbBGuGwTKchaLldm2g2C5YC2BjspLrHqLjvfu9rJcwir?=
 =?us-ascii?Q?A32wahnBeJPs3CS6Y3nFEFPQ/p/zlEYgtTxzXXfmP4eMeHbPz8ICfzKgu3dU?=
 =?us-ascii?Q?RYEN+Vwkl+HLEok7Vt1jQZL4/tjTXuTQkiBFEKP9iHz6yp7O+mTXoNsZ/uEI?=
 =?us-ascii?Q?l8cl7MQK+Sxl/ZkoOy1NYKc70JJnWGJ3ZlMIb5zETPUAoBjtFEsA4CtuIptS?=
 =?us-ascii?Q?m+3r1lpcQR1NWp9HssSeKSPnndp7J+qsTzuBsgJli/P3PTUQjOZ+Y52n+/Ff?=
 =?us-ascii?Q?fyRpno1D0uNfgB0/vGzGHo1zuTnxFCYS6aMVbzUJhEzQwksryVxnlA4Dy4H2?=
 =?us-ascii?Q?jpYTXPmxFIclyfDS/aqXJ86vGWjHDncyUO3GvRDWIKC07ezkv1n4/Go3CHoE?=
 =?us-ascii?Q?2sFup6xgzPKkc4S0iT/ci77dvdqkBU4+FxD1JXFupxlRFx25RKcT8H7IdzGd?=
 =?us-ascii?Q?nLTYGkBbIa1eKvjZjwx9yL2u69gnjv9VT+qGN0PcSN/aejDRTARnBQQzJSVl?=
 =?us-ascii?Q?pPzdT3inOPYMjIs5K+NtzNwQNETYW8A1YqYyJaegLDC46PVcthOzQd/4DTQw?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313f8f6c-e926-4f56-0064-08db26feabca
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 15:45:45.0310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z11Mr0HAeF+W4T99qMSljs0qMFQiuPCkLe3srihk3bg2sGK0WDBQV8xdRCIU0IlPu+7xDJG3i4C1zDZZrj10HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9867
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 04:35:58PM +0100, Petr Machata wrote:
> 
> Petr Machata <petrm@nvidia.com> writes:
> 
> > Petr Machata <petrm@nvidia.com> writes:
> >
> >> Petr Machata <petrm@nvidia.com> writes:
> >>
> >>> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
> >>>
> >>>> diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> >>>> index c6ce0b448bf3..bf57400e14ee 100755
> >>>> --- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> >>>> +++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> >>>> @@ -2,7 +2,7 @@
> >>>>  # SPDX-License-Identifier: GPL-2.0
> >>>>  
> >>>>  source qos_lib.sh
> >>>> -bail_on_lldpad
> >>>> +bail_on_lldpad "configure DCB" "configure Qdiscs"
> >>>
> >>> ... lib.sh isn't sourced at this point yet. `source
> >>> $lib_dir/sch_tbf_ets.sh' brings that in later in the file, so the bail
> >>> would need to be below that. But if it is, it won't run until after the
> >>> test, which is useless.
> >
> > I added a shim as shown below. Comments welcome. Your patch then needs a
> > bit of adaptation, plus I've dropped all the now-useless imports of
> > qos_lib.sh. I'll pass this through our regression, and if nothing
> > explodes, I'll point you at a branch tomorrow, and you can make the two
> > patches a part of your larger patchset?
> 
> (I only pushed this to our regression today. The patches are the top two
> ones here:
> 
>     https://github.com/pmachata/linux_mlxsw/commits/petrm_selftests_bail_on_lldpad_move
> 
> I'll let you know on Monday whether anything exploded in regression.)

Thanks.

Side question. Your bail_on_lldpad logic wants to avoid lldpad from
being involved at all in the selftest. In my case, I want to make sure
that the service is disabled system-wide, so that the selftest can start
it by itself. Is that the best way to make use of lldpad in general in
the kselftest framework?
