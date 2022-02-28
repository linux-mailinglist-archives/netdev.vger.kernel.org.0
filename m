Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890F64C77F0
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240009AbiB1SgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbiB1Sfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:35:44 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2090.outbound.protection.outlook.com [40.107.223.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB71AD109;
        Mon, 28 Feb 2022 10:21:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0sYV2bkcTDAj74s8fZ7XdAd9larSv665PWFehIponH/z5SnFI1FGiIL6WvGt3X1sBgcZBWZiILaADMrm+ZFK7niM9rwVqeYaNnJXCSCnItGLReS7FceWbUYwusUtRR7rfDmN5pqhpOow0idXId+NMEMKRFp8l7rQ/RF4gGUKy4VTJQnnVSZSc4bF45DpFAWUJU/tKZ64Y/S5lixUBHXKfD8Wgr7MOBYgw4hu9sPt0glByKEWHh0tCTbeL4lLqgokyJUQboUEQ2FCtvgzt+O+8Gn5Vnmkud5wsK9/L1qLpnAU6ZW1UE6Qmq8YD6k6B4+OrOXyvFzvBjUd+yZNJZlPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQRTixIgHbCdUurR0BisyFa2aW6qzCKsvWTn1lJksxY=;
 b=eYvmeD+wx+SwhQHRjId1lbTlEb9+dIB+FAQXdgwkaCtx8pyl9CXjhJN4FjYdLHbtuljd+rueD89AyNtHkgVScogMcPPcFA6nRD+A/q1S9fat/pubwwQ4zTP+3yqaVO1GnRCXCA5diM4X46Mu7QP166fl+FUc40/w41diJynX0nAQKqThhjyBTEw0asl+0cDBuUe7USv4X7QKku2Y3tQbmVBT1Cs1mrRfb1pZOwM+gXsmEGGZL7C8Msqmay1HXOZr8O/XiINayAKJEOZxxiXfctjkLvOi57xKtq+oT9LuEFKTODYlHVu6biGgvoCzWI0UQb9AgEyAq/akLpi18nz6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQRTixIgHbCdUurR0BisyFa2aW6qzCKsvWTn1lJksxY=;
 b=ZaFw3/fa0OMn6of66YFKsFUHqU2U8iUGZaLcjQbAwn3QoV6n94m2IxnMW1jT/goNPuGThnJMuaRoy1I/QWWhzBhsLffJCwJw9JiAUfKgZYUxxMYwoXj+CtH2BSu18QSEAxFAIHSUDOgxx9/1sH1bYH9LcLUk3NCJxlkCUB0v8Jc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2160.namprd10.prod.outlook.com
 (2603:10b6:301:36::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 18:21:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 18:21:24 +0000
Date:   Mon, 28 Feb 2022 10:21:30 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 1/1] net: dsa: felix: remove
 prevalidate_phy_mode interface
Message-ID: <20220228182130.GA6816@COLIN-DESKTOP1.localdomain>
References: <20220226223650.4129751-1-colin.foster@in-advantage.com>
 <20220228114634.izmpym7x6kvjjvq6@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228114634.izmpym7x6kvjjvq6@skbuf>
X-ClientProxiedBy: MW4PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:303:8f::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7dffe7c-04e0-4072-1e03-08d9fae7204a
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2160:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB216084CA85341A57AB0DD653A4019@MWHPR1001MB2160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EYIrs7tveOIwfMo+mjbVsbYHNZkWR4RvQNtFpxU8VQYHIDTryBPwVkM1dith0WYWVUcTLD8U8RokgSaTIXH2sd6H9u/CGFUy+KNkFLlvOLO22OcV/3Kf3+26kgAYpEXNdNfQ6REr9ix7TelxeGcKdAA0e6UjDPEcW0qMf333qULAT/BKJlvC/IOw9o+eopuvf1MhQATXgDc1bEFqEXSBURw55Hlk+6ngMLiV0ymsf68wSXBVvxXCHQw3t8C+km0THmMRa6PKecZwdxP9dazV/bUSgasTOxwOc2DR/XhBrAPxsFxvXSR4fJxEnI6GImEEv1YjCRp5QKmDho3lzUpXdngf6i4oQAf8nSwqym43HR6t7rsDXvcValsz8HZR4KZT7nNYM1T6Fuz5SDyCDNFZhCV7c7xkyBaRIXtrh2z6me/uT/7MVQ3m/2iFlu7IPOEzoGN2gl0bYLL4AytC6AUQpjrk0o3hHkKhRson/ZB6tb10fdjljORRFuSR3Mjbjrgvcnd1hBqGKF5hMYBOJCBTmOO7BZqV3PvvNOaA45Go3brSDWV4UUEAtVq0vrlLklxtFVZ9srwQTzs5i0i4OtC2WytuDUV8eZtlmWsjzbyZamwARxYC/Ki2MqD81UcXKqs40H+ZmB3671bV6CUSJlED4peRPpPDJOnearnrxYy2ncmY+xnYMoHsT2YBkmoqJf3nEytcrO16aUBiYZVJNJ8A4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39830400003)(376002)(346002)(366004)(42606007)(136003)(186003)(66946007)(66476007)(66556008)(8676002)(83380400001)(6666004)(316002)(33656002)(6512007)(9686003)(52116002)(6506007)(6486002)(7416002)(26005)(44832011)(4744005)(5660300002)(6916009)(508600001)(38100700002)(38350700002)(4326008)(1076003)(8936002)(86362001)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dDCulCPg8vDhHLbN1FtWQsYedJz8dnECuDIIlZioVS6jMJaiOQ5WW8/PdZ6Q?=
 =?us-ascii?Q?NzKHCI87msLnsjWgbnZNz9BEO9msOaTC/UTqiIygT521NkX/RQ9xbzKy6UsX?=
 =?us-ascii?Q?c2luoSopjidKizcYz1LHQrVhgjriOu6Eo24wKEnKrgLcYJ3bS6dHm0YC39wo?=
 =?us-ascii?Q?UFiZuovYDr1XEa/qUlqzF9kAbeXaZYF++Jp+B7pPMRiZc14e9t5WtpO4uAes?=
 =?us-ascii?Q?zIvOCPtqoQa2TotJgan86nujZfi3y0BVmdNP5mG0YIKSY4ZEMUWT8B3BGxYw?=
 =?us-ascii?Q?F6LZLM/jKZc1LVbq61CIWPyOF8gUJ95T5em8S1Tg9U3YvGTbAyv4FhOeDwsj?=
 =?us-ascii?Q?9v3TWfTpoj21U1fyJwmP1dyE7XGmeMTpT8BiofC8M7IPbfAKqWXocum95kZg?=
 =?us-ascii?Q?TyaQchkDqAUKBhLblEwmxlhN9y3d4nTNgf2DtXt/B4WZ1wpifUnh11KaXGdE?=
 =?us-ascii?Q?sI9EqvV8224VWN+UqPSBZzUThBYKYfdsOK4CtugqAbWSH8x+/EAN20aIpiIN?=
 =?us-ascii?Q?ULw0td/sw75S2R0QwvTjlz+e1WPA7JTRQy8wcoU+84ccyy57egVwYYjSf/1I?=
 =?us-ascii?Q?mTPaxQFFdWIky2SgBfoZ+mtI3x6lIcAtqSGzBoJG6Ztsxuhpytm2rFvSsTUv?=
 =?us-ascii?Q?bK5sgWrkTvloxw1D18bI5cik++14FvTIlDJMWxLgDh9zm300TpOgqOyGZIP+?=
 =?us-ascii?Q?N2LTEciEaOatJYp8GoBU9ogKxyplpxh+DMpjf7dGpsd20i3z+p2J8kXm7goN?=
 =?us-ascii?Q?8XPd55mtEPNhY0egnyeCqRnucQ+soth5Q4935E0h/eJD3B4Sa0MGcwEbecMF?=
 =?us-ascii?Q?O8lcSm5FYNWeSXjoZ2fzWiCVRyvb+D0idG+boMJ8I7NUXNp+ytzI+KnQTo04?=
 =?us-ascii?Q?eRYg/B+6vZaD0OaIfsmy8Om9nUHTqk2ecxHoPBIt6JQQVQPTzgEFQYH0+y3K?=
 =?us-ascii?Q?Ga/vASgxhTuGC3qSJF80iOE+XCzbV7vslSrPfeQVtHQs1Ybt++i2xYGFSCwE?=
 =?us-ascii?Q?MQqbOZ3xGU1RRABMD7MctjKxR8CzVyP/chFAB630UvhP0Ign7BwrlUNYFqmN?=
 =?us-ascii?Q?OkIpqkajwn5chTJPTIa+5bOTQUmWGSNCmRvBhLxL1tmgWCZdMBwQ+w0h2wam?=
 =?us-ascii?Q?/vYEzGEm4nP+ePmHR1Xin+92R5pYMVtxR6u2rPtzwTyXwjAruYnUGHVd0l+7?=
 =?us-ascii?Q?BGJFlNpoReTysiebBPEGvs+1sTf9BY17aoDGKQdLLaRfquSPDTFn96phTfYS?=
 =?us-ascii?Q?P8ge41P+gLid0XBz8T2EVwVcmX+gYKaviNpyldsV5qQQDJKRlWQuy3OgrKfg?=
 =?us-ascii?Q?+ohi/1pY5lk8BBrb3XGqYbdxA0woSCgTXaMn4wuVoMg31sVz8mNgkSIjSZ2l?=
 =?us-ascii?Q?Qn6guBe+/Jgwij/fIb0bhy5l2yrGVYEv2X3R5TR1qQKWz5B1gRWaOQPkVqkT?=
 =?us-ascii?Q?wi+UC7P72RsVAOHLe7+FXLHhtQqEuN4lWXgpBmhTmnmIUBxfaiWstV4E1uaQ?=
 =?us-ascii?Q?VbAKr8baVC3qcJ8ZeWMUpv1zR6LBMR/fMjq2YdGUUk7NuDl3sQSMZaAHyFfT?=
 =?us-ascii?Q?SWP/o1+d3Iz7yPgfOEi8d7c58wFmYGsc/br9/SFGhCzlp7rf9gYp6MMgH942?=
 =?us-ascii?Q?MfRKgQH1zHIsw7UAliTQIUJDG16stDaXJuWuWxhDyVHovsvOQR3iRhiryxFs?=
 =?us-ascii?Q?FWvCkg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7dffe7c-04e0-4072-1e03-08d9fae7204a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 18:21:23.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Be9B8QZBQ33wsib8Kecv+bP+F5h0RScqeEa9R1rXBO0GkPL30sEWxxejm0rY+DuyIS93HIIqGzsN8Pc8PSdZEfzgmDrzPv2QYGa+9QUvzhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2160
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 11:46:35AM +0000, Vladimir Oltean wrote:
> On Sat, Feb 26, 2022 at 02:36:50PM -0800, Colin Foster wrote:
> > All users of the felix driver were creating their own prevalidate_phy_mode
> > function. The same logic can be performed in a more general way by using a
> > simple array of bit fields.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks Vladimir!

I realized I didn't respond to your feedback email from my last patch
set. My apologies - I had shifted my focus to the MFD infrastructure
changes. I hope to be able to send a new RFC soon with all improvements
both you and Lee suggested.
