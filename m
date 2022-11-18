Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575AF62F9DA
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbiKRQAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbiKRQAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:00:42 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60066.outbound.protection.outlook.com [40.107.6.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817FD62C3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 08:00:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRgGFdsdFCk9nYbJjtdRdLubmi0ISM82yCtVOPZ/zuAYwiE+xU6RDsUNk5oo/adCXjawyOoFFaughB8R86DKz5ZBtBAEZshbUKNgfsxDfTjsxZ3nvIOmeI0E58sjQgB6JkbbSDldyx/IaozUIBf1e9b6VU9svPbK8M97y0M0xkZD3sLcnJN2wci9bF991xVYQETDU7Cs+YZ36ewl1qR1hitRsSZsYp2V50VJ1Qu5WXtCO0Upm3KzYd+9pS9gPOD0P7IyiC+VEeBJuPP1nm12ncdxggBFg6i1UVFvmI0xQDDhfMzABniEU4ODrm3Y3J7oAHZfafLHKmzUHOgbEiYDdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1B+iscKw9wQZqAeLUKvtafGesabvyN94c8sd8oeL0Z4=;
 b=jlbs7t0KX9lmm6BE+GnXQGCU8tevkE4XDJ7ZQ3T2mOfYUbHlA/5oLD5ncxQrFqq/qfXRO0qY3pCAX8errveW0rY6QeE5+61KqYQNw4b/xRlbXb9FxfWf4kLHY686AWTTw4gu+Us/BeQaMkdeEUsKD5kSZ3ZdI2OSjqwqN4Lq+oMjvGEDVr3Bm8X//YVL9JDrbDIB+JomMaFfRPAyG0nV9YF3zWcK4q9mpDy6aGlifCDOJqC3dvSjzrqc3GWLZ5oY3aYUf9ovN3O/LDLl48u3W3jvFCyJmPAW5LMLBnZAnaFUVBhen75WCjgE9rSjc8ianGmywsy7J5rUY/4+7wmEEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1B+iscKw9wQZqAeLUKvtafGesabvyN94c8sd8oeL0Z4=;
 b=FANdRjg3HOCAouziCjIb2SbxNZO+Na+lyAcK1VTV9lHJLQqDxskYN3AHjDR+fUNfdIQ3TIq+HsBXpqcv0Fo0/7wTx2bZ42qtmSZ+mgPhjrEZM306+aUmn9A3/d7LIfwxf6Q0mmLgO1HxcIGozq2xLMWap5MrvFfK1pp8DeDeh0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS8PR04MB8675.eurprd04.prod.outlook.com (2603:10a6:20b:42a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.15; Fri, 18 Nov
 2022 16:00:35 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c%6]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 16:00:35 +0000
Date:   Fri, 18 Nov 2022 18:00:32 +0200
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
Message-ID: <20221118160032.mpj33vwzuh3ymlii@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
 <4a039a07-ab73-efa3-96d5-d109438f4575@seco.com>
 <20221118154241.w52x6dhg6tydqlfm@skbuf>
 <0e921aaa-6e71-ba16-faf7-70a4bac5be23@seco.com>
 <20221118155614.uswrmo65ap4i3hih@skbuf>
 <495daec3-8bda-cbb3-3cf2-7c07256dd14a@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495daec3-8bda-cbb3-3cf2-7c07256dd14a@seco.com>
X-ClientProxiedBy: AM4PR05CA0014.eurprd05.prod.outlook.com (2603:10a6:205::27)
 To AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS8PR04MB8675:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a02d2d-c49b-4b6d-f92f-08dac97e0797
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PcDRdkhukY9nPOvnclOPmiCxty7/GVbFPTI46g1qHkjVqtKI9bkbdQzrnFajoTfT/ovZT8VCDYnqHzvF+ObTaTxmeAt3su1Yx2xXRmUVqqPRszyW8JUEaeYM7wpzDk5gv1qjknuNPJfYLMtEojDsIib2MrPurQ/C1AciVFB3rbdCkA7gJz7k+55QWBqHnDi7Q/PWlvCPZDQrPH+1Lr0zx+rV6j9l1qt+kg8V+eVYQ1bN04P8vO9nfef3j0qhXgVHE/04+7mL3XtC4cPlDxIZdKwL2QJb3KGfBsR79P0ueFuhJtNgY3GBMB13pJStbF5dPsnbfFy5c1KZHtcBk/P9Y823AEIikI7l964oQYej89WFi5u5u/78ZpLvAxecqJ2nC2vDtuSeUg7B8ZzfSsLDIGgoGPBEiuNQA+3vR7Bbas/TUCDiXDujDbDZ39CtkIamYS4Kxh2cMRVIWglXSJpnM8SwKedEL7A14b4vCmOJSYvn7m1nDAstH/3SshfWdAywgqhcEp/UYpnV5n2AEW7pvVbjk5b0KZJXSjhV5gOqhytiwXORqopwQdAukuuraLy4j4UfgSxevXLJM564MG2PbNFuNh5Apg4yt79gbDb3qebC/tNik+dk8cYIb8N4LZITHg4VT2BeIjOrb+lRXP97ffBtsES+ZhYgFw17Si+eYoRnJ51ICbP7spx/BOIgTDUd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(86362001)(83380400001)(1076003)(66946007)(8936002)(38100700002)(7416002)(4326008)(4744005)(2906002)(6506007)(44832011)(8676002)(66556008)(33716001)(41300700001)(5660300002)(66476007)(26005)(53546011)(6512007)(9686003)(6666004)(186003)(6916009)(54906003)(478600001)(6486002)(316002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PFSu3foMrdgYd2PQowkyGwm2Gx8gPnpjsND2GxrNCL0taAC/1HHE1YSeJWej?=
 =?us-ascii?Q?iXbQdzr2d+GHleB0nedVbejzRAunszwpGUZunxN/bVJI8zSxuuvukE6rggL9?=
 =?us-ascii?Q?aNKVQutfUK63cHKrgP80knXWIWcmg6dScKLMuoVjKoHFWifJJ61SS9yoCJAm?=
 =?us-ascii?Q?5vQZPAzDiK3LdF5cVj5RbEIYJiFPViwiyI1hgIamT4NtbhjDBGejTX9uk/Nv?=
 =?us-ascii?Q?O11X5Dam6j+TBV2SaxFL0ePfCZ4iQW1Ybp8IlD6aV3ALC/IKLIIAu5EgLiE2?=
 =?us-ascii?Q?n6t7ohcruBUBCuIll0PsBgf+UhduWH755OfFva9ljyhKXPn/jSGI+/5VhCIN?=
 =?us-ascii?Q?spG94eG5tQR9oLcELjMxeh5CbW+dmBbhfxQfCqcRyDMH55e5XmFTxuIIkO95?=
 =?us-ascii?Q?J1HKkwc+tpTIDC/9vx7ahIRZRAF7eheM25JaVPoWkOPwQ+q6EXcWbiA1AKgI?=
 =?us-ascii?Q?PzkElgx5A2bu1hSwQykA3q6nKPC/y33PafzsLdZH8bywjjxJxy9P2V0RmPnO?=
 =?us-ascii?Q?/t8rpzD15ioNNlpNk3BGXHZ2bYyuOqpkxcqT/TFaK5Muc4f0mNrQkKheVQ6u?=
 =?us-ascii?Q?snEaeIl13o3MfLqgpMcbHcigYjmevuqjtzYgIM3nFf3icz95PcxfkX+1CQfZ?=
 =?us-ascii?Q?aBK5wg+a4F5hMu6BOW2leU5VS31ttOeEtQU/vmSrRiDTC5m1VbGFlMIFOh6L?=
 =?us-ascii?Q?W9EHvzBWelQzFAnTaGISy9twbmWVPhSxTtJxn3T83olgH8oPml89Loomufgc?=
 =?us-ascii?Q?bYrguX2fPljRM/v/wZhmC3UQKyhe8gF7MJLAPHmah4WdMT1WtxMSE5QbxE8y?=
 =?us-ascii?Q?SRUryMx25UXUVg5wDKsmA8T6Asmlf8Lwad8SEk7/iF3mGePowSzourlyZfu6?=
 =?us-ascii?Q?srTRTwrE259WeEkYnahjVqNCigjTFb2KpGgydW4WqkDfHTdz+Qsr5pkh8Z9e?=
 =?us-ascii?Q?QOSnF7TAyJb0hORmS8qFnTxvsG8jNS6feIqhNH1mRoGqhvhHGZidHXJjaYsk?=
 =?us-ascii?Q?y+RDQRc731RFQ11fXMqbuC6VVhKVpY2sf6MSvw/I5WEy1lQvSpn9MBDV8auG?=
 =?us-ascii?Q?kyTGKoMV22GFBNQah4nJOh6sBvh6Vlh5zR7C3Fi9l3+Ge+N6gmff20uc7DsO?=
 =?us-ascii?Q?xS5bYCcQYCHRPTx9SuPfSqd152/OtOdCm+6wiZZ07YQAg2poD1hkd7TTufX2?=
 =?us-ascii?Q?xqcu5doMUwX9t2QITGkjNtv+O+YQttDjjfDr67E8dT8tRV3CBwULztwnwFCF?=
 =?us-ascii?Q?xKtOrloj1bad5MuIMkThzobtQULd01/lGbUvFT6PnxG2Kr0o0WdHsRNL4yt0?=
 =?us-ascii?Q?92Ke9wNfUSAKKASoPykvgzPzQyVRETFF1REvRE+CX7ubm6kdTlNMDrMGDmei?=
 =?us-ascii?Q?nF3Mw+2qBFS0j/8gwjQlwMtraNPnR/cAKuBiWFU0JAGfBxYZFekLJQttZNRy?=
 =?us-ascii?Q?2/6jj3KmoohKoOZ6aKwlmmFsmIhu6hw2eSTlPJa5tlY64e/2Nl9RN+lC8N7/?=
 =?us-ascii?Q?6rRftDBPcVpgh1gCXpBtax4HneW9+YMyQDWPDSECKcvP/cdZxmHih/Ub6toq?=
 =?us-ascii?Q?1gy0wX1ISQ8KKr/lO3vvUzR+rhAdeFmUmQy2ErLKPDB4SKH+uEbWpnuq9Upr?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a02d2d-c49b-4b6d-f92f-08dac97e0797
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 16:00:35.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dpSXeIi/EUj0F412N79RsgBxxTnes5/pGZka5mkcyBCbaG0hrGSaJ1KzEPkAA6gytPM/NYRyQnFnFFR7OhZSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8675
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 10:57:13AM -0500, Sean Anderson wrote:
> On 11/18/22 10:56, Vladimir Oltean wrote:
> > So the change request is to make the enum look like this?
> > 
> > enum phy_an_inband {
> > 	PHY_AN_INBAND_UNKNOWN		= 0,
> > 	PHY_AN_INBAND_OFF		= BIT(0),
> > 	PHY_AN_INBAND_ON		= BIT(1),
> > };
> 
> Yes.

Ok, I'll make this change and wait for more feedback, and if nothing
else, will resubmit on Monday.
