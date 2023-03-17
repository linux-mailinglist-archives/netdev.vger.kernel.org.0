Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02986BE5CF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCQJnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCQJnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:43:11 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2066.outbound.protection.outlook.com [40.107.6.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1A4279BE;
        Fri, 17 Mar 2023 02:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An75RazFWajlZ0Ymx4PlW2YTnUJKZ9vyxBREfYhjMEQdSEFH6Yxp2pe1hwyNzd7NsGcWcVE4H34iUt3RPbDxxkgV3Tdh03soO9b7V/XeLUpOg71V5zUj6hqZqlKl9eO++5GzJddN3SYkc/3qTtMXuA5xjjMwkjAbAxbkZJOfEAX1RQj9CAUmIhhGGXB/rKQOEaX5cTvVNaek8yTdQNmJa5891mOn137pCjPqjOQgQR0tezGQ2l3FGl0cTxdFIGRxYC4zk2TCgFx/pUxMmZx79WFiRPQCIQ4a30tF6BMR1d22isoVSJWbMxZIIweV5wn/GgUHqANdrlBCaMklWqd6Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcg+zYXYPDE+EpEnuLVLwy1kHNZUSsc5/+QeBXy4B80=;
 b=h38wORIQZu0TwOFvyVtj8kHanpKnexhVhgLL/uVWHRaPYA8MmQ2uGZX6LQ5rFRX0QqfVJwrk5L1IzXGME6T8VPpKei4T3cqz4yRpdb/RnnN4XB5Y41G20GiIkkhvH4buvE9cz2LK5pXYfRqfW6b8pFVB1o8ibArP2JSDZGs6YkeV5PsmjTL5CxmoQ+uCY19Dvxn+GN8ygfPkhch54DNOjDuMLroeBKqlWB99WwPhfh0wZstFiKmovkDeq9pW+uAC7DwrIC7JyMGf7hc9Oj3SNtsJ0EuYjvl3oakzrn5r0yUWesUnnMf6YJJwOrruylBZbABl5UpfJEFzs98MwKwUyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcg+zYXYPDE+EpEnuLVLwy1kHNZUSsc5/+QeBXy4B80=;
 b=jkijTsr4nAoF5YUHxWI8c19eUGibtmzL3ym2Wo9R/zNrWsi0yaJrdJrwbp81BD7Ql/z001d4otmwJ9JJglrGd4+01lN2OkwyPfBkkngBoPKTuoQhnLx6fZx7wA4k+9ZIfuyyFwFaDYPTjd+OWOMBVGo590OEW12JYtPYrPRVgaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by AS8PR04MB9126.eurprd04.prod.outlook.com (2603:10a6:20b:449::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 09:43:08 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 09:43:08 +0000
Date:   Fri, 17 Mar 2023 11:43:03 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 0/4] KSZ DSA driver: xMII speed
 adjustment and partial reg_fields conversion
Message-ID: <20230317094303.2ws3iktef74266i2@skbuf>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
 <20230317060220.GC13320@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317060220.GC13320@pengutronix.de>
X-ClientProxiedBy: VI1P195CA0013.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::23) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|AS8PR04MB9126:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d3967e-e745-4dff-dd12-08db26cc039d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/gyK8j7UGdW82GxQLwBnKwSNnmRT8fOq0U8B7BY+E3B8c06m3O4FpHkElvzMBkklS7b2X6rcLsou/jQgdfYmXDRz8HfHe3rSFzwYIPAum2WVrXjTAn4guaTJZ3p9FfMF3dPX+eiIYxqYQWAdLrgDft47OJKAzy9LBG6kiNKK7I9992v7JEyyNrdrWVLOgPi7oazbxZpB6ZM14EYLLsu7iyl+I3ZX8dcH4K18h73TbJ3QltmivClS4EJcJ9MVFfZvzzFfPypvChPzSWQjAQPSiHHDXWltiDv6mW8P2x+HEDRZHHxmXQtSkW39N8pZ7wFtZv4vuz9K5ZmZl1tH7DcdcuOj9mz47nJ/4/QqPBrSQZpqnLx3xxEenf0FJpyAA+K6XMnjtRIz0zzqYa2k5jOYV4wU6FaQywqFjUh/r/nuNU1QMzSfibFGInEaFxAgslBpJioolHaj4Ro9HupLeEijPejNhIA+XQmvnxI2CQ42cdswMNdnUCIqHcY9BvCSgnuAwlC7yb4LHQbZMD8n/H5PwInTvc8/hQTLXIyb5ve3KlNMWzq4/i+wKO0c9CePM+z6tN1A2ARpWb1q15KfOBHAyax9J0gUxLK8c84ekxh8IgoDAbuo2w+L8m9IVTaipAPiIZICCntgCTrEwlswPQQCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199018)(6666004)(1076003)(26005)(6512007)(6506007)(44832011)(7416002)(86362001)(186003)(9686003)(33716001)(6486002)(54906003)(38100700002)(316002)(478600001)(2906002)(66556008)(66946007)(66476007)(4744005)(4326008)(8676002)(6916009)(5660300002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XhwiZSiZiwxnxOkgIVXnKorJ8KQUWMJ/dKI45fZ5elfdyFGK6rj/KYEOJm1t?=
 =?us-ascii?Q?Sx193lVzuibetefZ4xB/ql3unjcMX3/HIHdGg81rEqGG1oj9kFpsAtr+9UUn?=
 =?us-ascii?Q?o5h+HNQl6NbLHdDUu+8xOBTPOsHkp+X5SC2sgVV6/FmL5KiOyIHfojU0GIMO?=
 =?us-ascii?Q?zI1NsiJl6EkLBr3bboIaUWqvg7IEbbin2VWMmd9LI/q+J474fRrhzVyC2pYK?=
 =?us-ascii?Q?OCg1fDqchWs6hcvv0ZPzJwAXLP38r/mOZx/yTqpsbiBfyIbqWYgiqYK1u+I2?=
 =?us-ascii?Q?ZqVQWU5iGt0UMKyfJXGxDcq7QJAgIfi7v9SCI6zB6ySwxIL974+e2fHj88Zz?=
 =?us-ascii?Q?bcs/WJPRUQxFvRCptQ78Fpl1ZmwAQas8CwUoWIEDZ8hudfCmuDsoTj23Srn1?=
 =?us-ascii?Q?NJrwHg2TeaJ+3t27czZZuHzafGzO8Lu2D75q7eGj2BagfWfmUWpwAye8DGJm?=
 =?us-ascii?Q?t0t86vK3g4n8Tnb9Q5vPF++ygpey0eM+l7EfmJJp4tpmc5fpxg3fjZYa21Nq?=
 =?us-ascii?Q?NjKJM/cCTwINp72gv1O8PRS13Z8ZTjuyJ9pW2X2N+vVCUAf3dF+dFi6GhkFn?=
 =?us-ascii?Q?3pkkRenEE7od/wGbWPKdnXXCkTtgSsC6WWjeH+KalBoPCwlX3t5SVIWBbfsi?=
 =?us-ascii?Q?wefEHrSg90S7hk9VoNwaGcD3nkcEUuRb4QKLvL9wFdn87bXYrgymrTYCO3hu?=
 =?us-ascii?Q?uUdIffLLk4JqoKHHeKZcBvddC7VWSttS0YtNhymrKV/F6gV/rv/8O/tJqr0W?=
 =?us-ascii?Q?ZJ9sF3qh7DqL0NsPdN299i5Ndw5Gjb379N6fJbL8E3t8w+Ea9b+/eKIZKaZQ?=
 =?us-ascii?Q?YsoHvXuX9uAPD/yp9HdXK/F+mUajOispiqbEQp3COa+6MbAI9GEXe6YQAftN?=
 =?us-ascii?Q?hDylmn3FF3I88Mcn7+XoAb0HcnXVkzEeU2o3GsjzMbEDpJgeMTt2YxXxw+Jz?=
 =?us-ascii?Q?DZwHCsjG+waoT1B5iICKK3UOEanXFEQcBOESRtayop45mvb41As/3VZo+Vpb?=
 =?us-ascii?Q?bl69HzjFoWnY5onKWgGSPkNzuGfbIbiZU8Lumd7uiyMajIs5AaOoqcOWb3cj?=
 =?us-ascii?Q?CpO+L2A1GZTlAbz4bR1CyVCrELV09kcH+Tie//CeSYAWiAB7Krtxz0ofX8dY?=
 =?us-ascii?Q?3efwrfOrqat+uOQVvtgMunkWbvsXusUCV6ki9j9i7i8KCznWbwnIP2mOW75y?=
 =?us-ascii?Q?ypL8bQm3eXNIcGZmpOwLSTEVPH+QXH1KQMZQL6trW7PNzExSTfi3EwoFqu1j?=
 =?us-ascii?Q?+MTfUqgp9ssxq2hp9CImiF5PMqpS0hmC/ahgkKn/bFqlD58v5FaOmbIPtXUR?=
 =?us-ascii?Q?E1J60CtQMrlBiYUXgEO9/OI0kdEdqxJyEu5Li0fZ5bgEh4dMp4S4SdSZE46Q?=
 =?us-ascii?Q?+WtK17Kya3MFYM/4drwA7Ehnw82SdZSNHc9tsGdr+2MzlPilGGxlqPlL97CP?=
 =?us-ascii?Q?xiE2rWojZ71OVl0pCtVeVdx7SujsBY3Tw1jfnzt3gFGyxmXifpLInmmB4G9h?=
 =?us-ascii?Q?/Gx+J2yXr79lT1//8KjmNl1bg/rp4I5+c/cygcmDas3bisPDlOELwTnNSYnm?=
 =?us-ascii?Q?HVv0MuwxXCd7X9NY07zB0WOIRiTbW8wA2WWu1Pi9e1FO/6NCpfz851ZivKUz?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d3967e-e745-4dff-dd12-08db26cc039d
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 09:43:08.1261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M078cCfflMQTC5F2HUq3LCl45mGVvTjwkwFq+bxjbjA2Ku7YnSvY2Rwby4FLe1CqC8M0EFMhao34j29/304m/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 07:02:20AM +0100, Oleksij Rempel wrote:
> I can test it on KSZ8873, but currently it is not compiling on top of net-next.

That's my fault. I reset my defconfig, and looks like that only kept
CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON=y, disabling all the individual
KSZ drivers. I will leave comments inline where changes are necessary.
