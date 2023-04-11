Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1C66DD984
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjDKLjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDKLjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:39:05 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2078.outbound.protection.outlook.com [40.107.104.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ECF35A6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:39:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcZ73yp+4jJQeb102THhnaxPdy7WQcazAbbWT+h/QtV0tGrp7KdqJyl/4SjETw1pFBvwSFqqOr5VuKl5cO0zmTS/ENb78WKfBCU2Na54rlDBQsAf7ESB6PevBCZgnbjaF1y3E8QrUUYbW3JrjiAXeJ6xxRBZE+mhnlokqErH7p5AdoQm/aowbGOJZJW4RMerRholQKb3jfz7MejNR3zRa7XmsI2kZoqDx4Diowel2Pt2IxhxHX6De4jGiTAneQuCQ7YXn+W5/Z3UGdtogswPUX/aajtIRNXm6FLIwcez6qiX0a5NbHgXjpRat24hNkV8qqkpQGzOc3W6U9Slov9Eog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cI8shi0GZmw0Uu/5DqZ0Uaa1SEo4KgCtxFX1HBPBJk=;
 b=FE+e2xclI398Uym5nrAnEQ58XYQeby0HGCBsUL4ZCBjRhu1nC8WQJN83IcFkRJqe1SD8axfXGoOANTrHvLB9ndq8qBmuuDahJ6V0dAcirckKVeFflxq1TtShCj04GCcOkgz5ZhMZPViTmCLcR+r9J+08Zw55MndqjB0O8TnHBx0C+kt1JIKb3l1qXRkZobeD3v9rBbvQJbockC0tdlTq/IlAIVcP4Zj38OgxF6NSHwqv60E6cL96m1plEs9dhnKcbma2fbZY5IAA5OoxPNNxjoKPYoA6EZIU7BS57MVxdL/sdBRMAAsW15tqSJKDe9xnEbnIx0EQ2E7DxtXdNFNExA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cI8shi0GZmw0Uu/5DqZ0Uaa1SEo4KgCtxFX1HBPBJk=;
 b=T5Nt0rHpvEQgiVXtDjLo8B3kw2D0tQtZGTSGvA8M8XcF5C4UkoKQ85x35oFB6Z9+WJ7M7lNRkZZZT5/CHJFKdcgCa3+Ra9vMgslqIFsqqKTF4WuVRFK+bF2PtG4op9p5IWYp1qR8qHEiHii8HbpcdxwNYjCDPk/KhMoWAIF5Sw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 11:39:01 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Tue, 11 Apr 2023
 11:39:01 +0000
Date:   Tue, 11 Apr 2023 14:38:57 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Correct cmode to
 PHY_INTERFACE_
Message-ID: <20230411113857.f4i7drf7573r6vmg@skbuf>
References: <20230411023541.2372609-1-andrew@lunn.ch>
 <20230411023541.2372609-1-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411023541.2372609-1-andrew@lunn.ch>
 <20230411023541.2372609-1-andrew@lunn.ch>
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB7300:EE_
X-MS-Office365-Filtering-Correlation-Id: 22dc4632-9a78-4d18-023f-08db3a81581e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Icr495QSE2t8hlJZSORum5KZsEMcNcVj554QfeV+d8s2Ole+WCjeXaVpaYqx3RGou5NIHcmmSfUJJ/imyypbMaPI3dOI7AMvjct9A7Ffp9+HyM5Ex+XT0EOripXxm1tQWQYPHtCkCjOPhVKp3TC+GDmLRTZcZrAAkdE2SCKuxbzMW3YYMW+6eq3xbqnazfEi9LpQKUTju2/eFPkxtGeXKX3dxhRf4yaddQNYOVT3wIIGXSjshkp67rZaqlWyhSbkLkvyKsT7s8oCdg2UBci8/6tW2jlkSa03Z8lTES9jRMo8+GRXS23GUMhXWkMAef8FcS+23Lcq2y3OKQE30WouVghXgyG6T0h15oZUSuQ3g1QTwk3vz23V0Qq+RMRj1r0GppBqyFCz9lB9OkP5Hnk9u9MPOR5e6fjOY4/fxfpA1cV/EzcxXM8CLR2W1AsNfoABoueR+NSZOcI5fwuYKZZ4lEgEeVNB5Bfy6hOSVKzgya1BKzeSK16AlZFj7pocpNk2nFfojo3tu6qxLVLeeE+wdQ3f298BGRDcvY00hm6LApIthPHyqPE/InJL9m81uYgr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(9686003)(26005)(6506007)(186003)(44832011)(54906003)(6486002)(2906002)(5660300002)(33716001)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(6666004)(8936002)(66556008)(38100700002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ri0RoTm8raLMqmEcdY+31ZupzMmNIjfIdqAY+E+XsSBnvuz4FrgPB9bJjtK7?=
 =?us-ascii?Q?ddJp5HWymxjPRfRey/oCfwsM7R3dyAkYG9odNXtd0b9gKXOgKHMfSgNCKIs1?=
 =?us-ascii?Q?RVr5iOnlkXHAS+tejCq0rdl0cBvcic/qhv5GejCE67XXIBiBG8IcjxoeGwtd?=
 =?us-ascii?Q?ZUpDdY+Vh/i3A8kV1FJOse2JgkZiS6G3RJywenZl9SzFZdsGtcuGWG81kuh7?=
 =?us-ascii?Q?2d+2a++JyEptHe7mbe4bx8Kgfa3vAjkQRHr55m+RLVbXfSYCBbEQY0qggDw8?=
 =?us-ascii?Q?s2Cg8KjiuU37XeDsmOOgsR6d3c5y7NBrLVHExuVqpudmlD1IzGL7g+QPaRSc?=
 =?us-ascii?Q?qKzk3lbhVRvqlvfe2VkFRrPjbibJqG23hD2DMopvJiKDipHIlUBOCdoy8OAD?=
 =?us-ascii?Q?YJUlcNGlRT7b1qVVPnIrlwiNwGjp5WAIsmYzd9WbhQTv845mfCm/mrarz9js?=
 =?us-ascii?Q?WFhzXnSyzw7j0iz3ZMOlXDIIfU/NwNifKiTsyUslslri2bhwNGuvk/t03J8y?=
 =?us-ascii?Q?Kb5ZUkNmjUnmuWxdcd3eY0pvSz4YniTuC41GRZlxIW6EFuj9WTF00FCFtcwn?=
 =?us-ascii?Q?NHnGJJTHGkKFDL6Nng+1GtxYqsvAtUbT+ESQlDUK/+n4XG2uhaLN3OqgVk/d?=
 =?us-ascii?Q?zwvVwl43gPwxPE4hMNMsi9kKrO+2fnUAk6J00K7LhnY46LDW63HirkG6U0J1?=
 =?us-ascii?Q?mGfcj/csnx/LWmS/loBydNqmPNTnPZI+HrCyRbMOe/UW/a6ZdCtkvA9zd0Mf?=
 =?us-ascii?Q?JNWrDKZFYKAfX9QCOtgS+5R+MSTghhstSp2f6AALy+OISUGQA9ervRfeQQ4E?=
 =?us-ascii?Q?GdO9+5bZA9p2ORWLgUZGS4C26yHZ4vasvStT1kJkK8G/9y6ys6WpHpyGoz1U?=
 =?us-ascii?Q?5tvOewBbANDJEZcmUk0QNEU+0xpi7QlgJrlzjMqK0lVZZLJJ2t50kRarPDbk?=
 =?us-ascii?Q?zP5Ep/iyQPyc29okrvYuxckUxYImvjlZZoJJNBzH7xXuLGoUe8TCSLIrfgmH?=
 =?us-ascii?Q?POFyBfhxH8AsQO/Z984A4h5jvrDXedSFbWczdL5ONHqzRvuqWgLhH+JaiiG/?=
 =?us-ascii?Q?O2Dze8bwHkJsa+DMa0w0QERHnJ83RXqF4XuyHryxf6VFLq4TLMSFNKjqgS/u?=
 =?us-ascii?Q?i2U4CYV20EaliX6A3LI2tPnp4dWunFZF/d+kThtXdi+gUbYMKG//kyxo5wnS?=
 =?us-ascii?Q?lb1BnIfX2TfpVfBRH7Ibs33JFkk0l+R4xPLA/C5JSMrecmkzTOjztm+DNAsN?=
 =?us-ascii?Q?wKupL+rYg1xjZzheBrHiyVLxjgHsWP5mZk68gbFan4MpjqcCIylULBXEa3Up?=
 =?us-ascii?Q?hDwhs4dunhejmhloKD9870cPRQjH2w0OS1EPHhPJKC+Ha7S22o+Z1ruH/oLD?=
 =?us-ascii?Q?CY9on4nz28xtUgwIaBUWpuC/w4WCVIRcuvnLylBH85u7Yg8Po/tvdM66DG03?=
 =?us-ascii?Q?S5ker02p0JayF8gjDQ4ceEmift30JSYdE5U/nrPFHb2WCem9S7FBFkPx1Cgj?=
 =?us-ascii?Q?OP62C+SBoz87ct7FucJO0LWrF2CPSI5PfCKnLTeVB9RKJf10fhBvt4Y2n8dE?=
 =?us-ascii?Q?N1NOtlnd4spoFQQbhYJMtB8PrS9/jPwNJqB+5W0uSwCvcAuQxPtqEIViTuSC?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22dc4632-9a78-4d18-023f-08db3a81581e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 11:39:00.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxK2xi68BnROesNUfDej8cGvcGxN3/DFXpGgPGlKVl/brIqHIwtWZFhYh7qkkbKFbHyrzewR3Pzr1khO7lTKDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7300
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 04:35:41AM +0200, Andrew Lunn wrote:
> The switch can either take the MAC or the PHY role in an MII or RMII
> link. There are distinct PHY_INTERFACE_ macros for these two roles.
> Correct the mapping so that the `REV` version is used for the PHY
> role.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> 
> Since this has not caused any known issues so far, i decided to not
> add a Fixes: tag and submit for net.
> 
>  drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 62a126402983..ffe6a88f94ce 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -611,10 +611,10 @@ static void mv88e6185_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
>  }
>  
>  static const u8 mv88e6xxx_phy_interface_modes[] = {
> -	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_MII,
> +	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_REVMII,
>  	[MV88E6XXX_PORT_STS_CMODE_MII]		= PHY_INTERFACE_MODE_MII,
>  	[MV88E6XXX_PORT_STS_CMODE_GMII]		= PHY_INTERFACE_MODE_GMII,
> -	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_RMII,
> +	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_REVRMII,
>  	[MV88E6XXX_PORT_STS_CMODE_RMII]		= PHY_INTERFACE_MODE_RMII,
>  	[MV88E6XXX_PORT_STS_CMODE_100BASEX]	= PHY_INTERFACE_MODE_100BASEX,
>  	[MV88E6XXX_PORT_STS_CMODE_1000BASEX]	= PHY_INTERFACE_MODE_1000BASEX,
> -- 
> 2.40.0
>
