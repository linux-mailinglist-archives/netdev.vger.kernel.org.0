Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3332C62F9C4
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiKRP4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbiKRP4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:56:22 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140085.outbound.protection.outlook.com [40.107.14.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236967D50A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:56:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVzZRlA2J0dafvMr+58Ff7nB3QC9sJoZixr4Obt5lrw7MsaH/4Vy/VGzzGSNCEhmm5HWafTTzPvZsCeCbyHz8J4TL1Xpdp2DBBdqa7Hf2KNClf0J29vpNJKiN1CO1dxhF2T0Al2FxlOv2Z2WIYwpMMAXVkM9pzA49v5v/Qg9Udsn+7YCA5B+QsMayo3H/91Gx+Q90yG4y0in0Bpq3mMtu5UJeJWBfAlf0T57CDeSucafwqCo9xd85M8W6yjs9o9PNm96CBnKbhoMyhVhou/6YX1SHPUlVwf+yoLBeqafQhhPvQNvzJgmz5Sam1foajnSGC/0y93IWd2Zq3RX5ZFJIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZSjXpGnns8RoueOzVepDIC+dINf6iDwR9Yr3VnO4xo=;
 b=JsyG1Uuahvm20gT4DXjOhv4W50JhvWmL79WOdquxcf3QBjQj2mILXRUg95vkkZRQEU7ISIXvvgWecobU6ckjI6f0KSdDBN3ti9TG/+5izIF+u1t5nPSWH0EYHaetG6spx1DBrNc06AuOEen/MtzQLp0Y0gvWJYWECiueG2Fc9oRHGn4YT4jGRx8CijPYWMHSGYI/MNqPnUKYCl4he6wciiYivUW+hch8y+o9FjjTyf088H9+L6jLybblJ7NTZLv+0bxTYRqPipFpJumZNIuq0/5g3WhU2gjrHjza3FImRp4apv/RwwHcGOQxdd41YdMfK+qKXuwm924P8CAB3jc5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZSjXpGnns8RoueOzVepDIC+dINf6iDwR9Yr3VnO4xo=;
 b=MX6MSTD5rzxKLhWzbFXUFLEIzY9muPRPO+UuobLOPlE30ZS2v5S57U6YkbxL95iZdP81sE7Z9VeTaSeCJ53BmtY/K2TTv4L10lkqq7jUaZAFrnEVCz40zVpufrW8ZDLZ5CIvZZHLkXy35q6TvjQkgD+fAu0p0n9uYD1jUj/naTs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS1PR04MB9455.eurprd04.prod.outlook.com (2603:10a6:20b:4d8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Fri, 18 Nov
 2022 15:56:18 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c%6]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 15:56:18 +0000
Date:   Fri, 18 Nov 2022 17:56:14 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 2/8] net: phylink: introduce generic method
 to query PHY in-band autoneg capability
Message-ID: <20221118155614.uswrmo65ap4i3hih@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
 <4a039a07-ab73-efa3-96d5-d109438f4575@seco.com>
 <20221118154241.w52x6dhg6tydqlfm@skbuf>
 <0e921aaa-6e71-ba16-faf7-70a4bac5be23@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e921aaa-6e71-ba16-faf7-70a4bac5be23@seco.com>
X-ClientProxiedBy: AS4P189CA0033.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::6) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS1PR04MB9455:EE_
X-MS-Office365-Filtering-Correlation-Id: 076e29a2-bc4d-40d9-ef6b-08dac97d6d86
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfhQNplo4lW51Jzdjc0oNduwUCSehkBBS/U9jan9PG4pcpd0CHSQ0pQXBXsneNCTUG6gRMTTwKR8sB5GIehvJXOcer8URX/yTAmEGSChUexS+yiK80kNH+HRm+/zu2DQuOwldzPjr3BwzsAa3nORZ6T2cIPbMJlpFPbN0+UNYo9XFyuwn0UrJbEeXoF8ZxnS0NDi6HHNUfELV8qeR45ZrWR83kIE/zn1zxXMLQvr8vTokpPpLtoFfIzckS2en6/i5Wa5VGKuwIMaXx3xyJ7sjxTEfczhexbz/KpzQDdn0l2QcqyoVFQ4gPxllkiJaPxNEYBSMNuI7IUPa0Q2PuO6zPx5Hssfe0tGXfRISuB5H78rjaf5kz+EbnTmv5nESWla4Ug4aeBW00HPKL8Q7HQrt4X2ldrdhxtdHOIKFeZUVobXXfg1S3f9O7Avmpp/hgFh+8rv+i7otwlJhEhKSXn28qj/HOK751vFHfYj0cBKu9ZNvpSsx7dV0CHv00A01EWveM+V/4Z+I/zP+IYKv1U0a+tzft44lEv7Qgs2hok0c6k8NAMHyPcASJdEUS0eqcNDyqo5q0rVsb1Q8j7mhAQP+AooUJEz6wogFUUd2ddWfUI85hGKK2DDBi9lEfztbL/cdBDxddJDisK4CaXsN+Gf2OLSxTQTcJ8s2MTkO2a76e6z9i7sJRsPIxZ2+tjaEJR0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(86362001)(38100700002)(316002)(6512007)(44832011)(41300700001)(8936002)(66556008)(4326008)(4744005)(5660300002)(7416002)(83380400001)(1076003)(26005)(186003)(9686003)(2906002)(8676002)(66946007)(66476007)(6486002)(6916009)(478600001)(6666004)(54906003)(33716001)(6506007)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ETuwxIJb+XsaQyN+EFniRhwnC4ay7D+wfdWQhQi3e7ug/tTN8U10HZWHYRbF?=
 =?us-ascii?Q?vWjsJEfLL5fh5F8HKBscb4XNj2i5Mb44olGz2h3RaJtFBC3TUqMiwx+OFBn4?=
 =?us-ascii?Q?LpXgvsSBhAcsAHBSfrp/Buy4LZ7Ei6D8jNiuwKoHdAh06SyX3bC28t8pUDV5?=
 =?us-ascii?Q?riy8e9f/gamu8VHrXp0ghIZw+l7tM3QwTmGtzubafDfQSSLQOKsRTaeipAH8?=
 =?us-ascii?Q?AwPgT/kSVYjHdhpJj63nsonv1e4fezY33k99VpjjyIvNoGp7gfpaie6/SM6T?=
 =?us-ascii?Q?KlK0W19jS7JdTf6LMmIwsCK9r7ftvfoLhzxYx5t+LiwGqZt3Qmx5hIaz3tDQ?=
 =?us-ascii?Q?iYFajgYg8ynGc/usMEx9kn8ULl9Hbr8RsF8ZLoBJEoweVtPyMCT6t0YFyGla?=
 =?us-ascii?Q?nlGT3s+CAD2S7O1wqNazQN8/VSjhvRqoKY5vTLlLqrt5Pt4jGSS0uDJVrgR1?=
 =?us-ascii?Q?le3FBuDgjzVgCoA6QhHbloTd1ebRXUya87z2oeJgXMYNgL1Z/ZVALM6Idpwd?=
 =?us-ascii?Q?7my48wMNQhSHC0y6oz4Ug22rcMwC/mJH/l3xLVTPsJAlMh82f1YiOLYUfKz6?=
 =?us-ascii?Q?8e2e8d2Ad5aif5wh0O/HyRCyBxGLScsJXTOkkf8rwCEtow4hSRXZ3szmG077?=
 =?us-ascii?Q?gNctPx/ViZW9I2qSUSQEfttlrdW2CLbTGouEOyhMX0MFy0WFqcQfgFpTU0Fe?=
 =?us-ascii?Q?pDWy79WbuRzpM1nA1A8fQ3EHqpbQjPGH1NEudNHY4MS6SF2tXDv8qmKpzsYe?=
 =?us-ascii?Q?7WyAcwF2lC+f4J3gQv+R5rVYDWBa1g5XojFckOrv0XARn4iZ+u0MrL9GxP1G?=
 =?us-ascii?Q?MOrLeA2nLKNg07e97Ad3jljtV7jQkJcL+4tmK9w/9LWvxw3lEwZ6M/1tLSSL?=
 =?us-ascii?Q?7/1/PfSqxVgV69MgHKfFibf9ggZB58nrb3Y8p1/252S0MHHqG+8f8Jxb04/5?=
 =?us-ascii?Q?1EinlkPTrBy+mHtLTtYXvOp5xGqrtQcZwuDhqwmwMPb8O3ztAqsdfiKJe1on?=
 =?us-ascii?Q?qkfO93LPOfNg1kE+0nKR3CUwdX4/cmgFhWmbdgOsy/aTGsjQPdykw8hgFswA?=
 =?us-ascii?Q?B4SjUkdaFEY4TxuH26/TQCQuYHLekgIta7SRSHpsjRVlyyCMbjx8yebEPogF?=
 =?us-ascii?Q?SSSsN9S3DBK9EG62Qp4487gkYafgXi7rvvoD7DG7Zwf9OmxDcZ8bJNmYdCaN?=
 =?us-ascii?Q?o27lzjuNWTQnC13r1FpS1lfTI6RWeUlsMiHGR0ws1lYEA+qKwtwhDUJj67cP?=
 =?us-ascii?Q?oFYanP9Wbb1LXdDsuhU3TXZ3aLN8e3hNqUOJXiPLSE49+4RbknVzkle3ZWqw?=
 =?us-ascii?Q?33DpzJDd0PWXCsb8o7lUMxRhNgTk7/vuZhflXkzmGg+wpefkAcZiXo1e6Uqk?=
 =?us-ascii?Q?MEYdtN9JwT9ZG+7zFFFbmLvnERX7/064yb4zM66Csf0iCBhbRrd77rXt7Wa8?=
 =?us-ascii?Q?eBxjecoqqOqYor/agMre+zRA3JpZ6nMK7wwULKq1+JQMOBDG6b/Bvk3wWoy1?=
 =?us-ascii?Q?+UIuulY1q82sIoqEPJXyGRsL1xFZKoYEJEqG/KerEZsN2LVHt3sst4jCl5P/?=
 =?us-ascii?Q?4bfqAopvcNFeTYvLJpKS4uOG3I+2QSK4ejNJgq3mmL+9FD2qgnv9Zn77sEsi?=
 =?us-ascii?Q?8A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076e29a2-bc4d-40d9-ef6b-08dac97d6d86
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 15:56:18.3094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSOnVP37aah9qyvZecdQ5NL4R26tcfNwrK5H8D7GyoWk4BenUs1Ow5Bgq4LczUN9YiVQKYKF67fsbB1gIQBiyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9455
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 10:49:30AM -0500, Sean Anderson wrote:
> If we have the opportunity, we should try to make invalid return codes
> inexpressible. If we remove the extra bit, then all the combinations we
> would like to have:
> 
> - I don't know what I support
> - In-band must be enabled
> - In-band must be disabled
> - I can support either
> 
> are exactly the combinations supported by the underlying data.

So the change request is to make the enum look like this?

enum phy_an_inband {
	PHY_AN_INBAND_UNKNOWN		= 0,
	PHY_AN_INBAND_OFF		= BIT(0),
	PHY_AN_INBAND_ON		= BIT(1),
};
