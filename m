Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C856DC578
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 12:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjDJKAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 06:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDJKAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 06:00:30 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA934DD
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 03:00:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9WOxMS/fHjiabuaSJ78um0vPYumLHhJaBaWX9lE/csdpHPwiZu2OoNdeh/u34sxamet5BQCjBlo9th9qRBb5Pzvz/7EPy2T8CJwWs5NZru/CaQy+28c2URat9Aq4pbAJqEn/aJ3MYat3ep7+ObaPjt1lD5bRQSjbooep/082nuch/j/QBNN40EflBwq53+kbktqUyofmIw1zNLa8kPU2E2dbrK9T1vsJv48n9BJarp0boocXWwxRRJRYVOOqhKIDgPqnYxoAg/jPPVWgAJSkVf1ScJaQwEMfy4MHHYV60Gn9aujbmmD+aCargqnpn704STwgJzZpgBGS+H3NCUadA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbivYiQAWk+v9kLkOgwEhMU2kApt0FrPStabFMduBr0=;
 b=Ue+PUQhI7nD1T/QK8xIHQ/X5h7EiXISBU39/tByPtQvSbi7guOK/Du5Qj6gwfllphhXSyQGtQnuOHAXhUmHLqPzCHzUWfRAyHMY+co1xHfrOVcTQJqVrwUzHok5aA0ZjIOJb2HZCzmaeKv7CxRPdJgRXvLlUFtfl/bIiQR7b5xTMswtLeS1CmtQ4v1O3C8l2YX7mkLkUjfnCQus6OYmZZRpbTWYc7Xil5Gb2GAMIu4wd5uJHAToe04OV/N0qFZE/j2Qm/C2Pr2FOZQKBqVK0bjAD/8gFFiCJwqafMzDUoeoDq3+cLhqLU4a1INiFJ7/jFl1KJE4S8NMFtekQuZqOoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbivYiQAWk+v9kLkOgwEhMU2kApt0FrPStabFMduBr0=;
 b=DHr0MclZZRzCtjm4QYrGClBT1QrzthX5CiAv7YmJLY8OZFd3I+Bppb83g8E9pZNHaO4/ic4vGFMupKamz3ImTtsPvH0Sc6jz0T+WXccaUuMkROS7X70q2XytxW49l2pzr7D86861LtqS43Vl3s5+duf4x4e1Uc4pyeOcLvwp2YU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8125.eurprd04.prod.outlook.com (2603:10a6:102:1cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 10:00:16 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Mon, 10 Apr 2023
 10:00:16 +0000
Date:   Mon, 10 Apr 2023 13:00:12 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <20230410100012.esudvvyik3ck7urr@skbuf>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
X-ClientProxiedBy: VI1PR09CA0161.eurprd09.prod.outlook.com
 (2603:10a6:800:120::15) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8125:EE_
X-MS-Office365-Filtering-Correlation-Id: d4121df7-af2b-4ec6-19a7-08db39aa6279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KSlzEowmUBNwA6bNSjyOOU72XsU9iMxE8fdhbZk7i45bbJ+wTUlvvnimrjlX1ux1QxSELQinqNlsotcQTI3r8gHLgeyHLdRtLNrXBbBba9RdjgLuLy/u+yEIGC84B3CgflZX6nPgfT+DurcPy1G+SkKeGDgMvqcA/4+zaOBxfuIp5s0lTrjmGd9lGI4ZKgU9qtkXf3ZMPrV9FoP/bFcsF1hsI5xrPAYZyKuPFuxvizVvOI+8V5+Z9JMjiNdNHoRG1stciZqd1QldptlZEOBw640cNDX1AcqX9yc95Q69o1CmA4MAVO+e81JVMUPGWCtiO9SgS5Orb6hGuCzojdH0LNGJt7El7JJLs6PsymMSvDdeo547l9GsI+nbBjcsOunKmTx7FxFDDYEgXG3insZsb/gZxIj7KQfl1aKSSvdeQh6C0O24neRitnGIkDnpSgetU0V/DAZ9XhHH30S8oC3E0dJAnlPmGqLPZWeCJUgPv9+jhJ8XJwv2wzm3O+FbzjANml/cvigtFD4p1jcnLcouq1BtTom1FRDJsdy++6cw8InYh8QOzShtXjwgvHa8O95g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(86362001)(316002)(110136005)(41300700001)(8676002)(66556008)(4326008)(6486002)(478600001)(66946007)(66476007)(54906003)(33716001)(5660300002)(44832011)(2906002)(8936002)(38100700002)(186003)(6666004)(6506007)(1076003)(26005)(9686003)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uocVMXUsJFX/lEur/t90JVCWAQIT3Rutgby/pNHXTrr8yT3qVBBOVrWsd6Xf?=
 =?us-ascii?Q?K3gEcubdqkm6GMmRJjjzAnYugu/f3BviIXG1+TJ62tHiwl/3l+kujqGD7WrI?=
 =?us-ascii?Q?Qjpa4o4thigW6t0KHVk63MxE1zgxrkU4T0gBQrsSKDs4hwcb/tQLOm1Uqt/2?=
 =?us-ascii?Q?3KOao6RvEEAutNO2UsvMjXkmpDYdJHV7mB8UtyTUduQcXxsrSsr1vdODJ7G7?=
 =?us-ascii?Q?URPA8AmHC9GHLFqdp+6iBvMeEWMLDhtcucnycExtSTsmQBu9sdJGjgkDCajl?=
 =?us-ascii?Q?IJQocAypeZSN5KAK2eDcD6NDWyLV8TgMhMnpRVUJ7b3T++8fRLyM/y4qHTyP?=
 =?us-ascii?Q?nNhcyHImGJhv7R/j3XJqM5xfNB/ywztRLVPPOVHughmboh55C3gB921gDbuZ?=
 =?us-ascii?Q?nyLXntkQfeBsUHXZhFxXNdxBeo++K/sheAnuKVKaq2QlXXnpyN/0kKc6uYNp?=
 =?us-ascii?Q?JiQ/6wQ37wA/n1hy4pp1VqQE4b5VUphQh+e0m3yb1vH483pmfACYN4HunR7L?=
 =?us-ascii?Q?OBDUuRX0kgO51pbNJbnLa4FZ/ZEeFh7Mp2FxW7H34vTZEIUKkkkcsJc4lozA?=
 =?us-ascii?Q?PRNdIllV9X9NoJmchwSTCbAyvKqp+0Em73VvOSMROuJlbQWu7DHucW/X7TEC?=
 =?us-ascii?Q?9meOEv8lL5tibAql8ar8wUJkDPYYPf9vjR7BuHx9TZ4YfnwOSAOzrCJGte6q?=
 =?us-ascii?Q?/ToYk6KwDXXk0/Y/BfF023Ek71XrH+YntzAelpDUdyVXF5WOPe9g8curQEeM?=
 =?us-ascii?Q?TP4R+7q35VkQ9fV9PxdAWAiqYTZQO1Kkz6E3V9LZ+Cusrl0IUz2ZhFTVkwt6?=
 =?us-ascii?Q?pGTT9WhTWqHBuV5SsMsdMSPSsDXNUtpul1MNiwpCcXKoPckGSbdd5zjdPXy9?=
 =?us-ascii?Q?ttWefbWcjc1TXvakPl7PLtFcbcFqUgNeW+a1SuOPN6D0S11OTuk6xFbYRwNe?=
 =?us-ascii?Q?56Z/LyKhaKCJhJQToJCl1QYbLlu5OmjUeJ+RBu8QMyy5f2jr1KEmJxu4rF6C?=
 =?us-ascii?Q?HDjJ5P2j6DKVXr7czFdp0tJQ1qTKVdZwqTXk1MqY2YtsdATXhdVAo4QWrsk/?=
 =?us-ascii?Q?OrYkZYm+qsIlWScuvinvnvyjZc0J+mhWyaQA/L6AdrVbR6W8PoIqCkX6MNBJ?=
 =?us-ascii?Q?cuyPabKyvRxZEKWGY12S7YsEfp+LrMBnABMa9oCWxgbBmmE5fH8bmo0Zt9Ja?=
 =?us-ascii?Q?cJEKZsvlfwoWFNmjH+2cmU+f4Cx8N8WUBR9CZfMv3IxOhLQTiolYH9HigZ//?=
 =?us-ascii?Q?c8Y+rFbOyej3yUK1xShYlNPLkrepOUmvlBMCBERtNfGu57Gv1w3s3PFPWWS3?=
 =?us-ascii?Q?VxeULZjoUX1GyaPDcJwx8cIcCFBSlMLGQqRykgW1Bpxge1244K6dPuphp6oU?=
 =?us-ascii?Q?A3mJzmKRX+b+KHB4qHKjIFbWypBq/HNtIC2+Aq+VP2CysChAna86t4WY1LXs?=
 =?us-ascii?Q?GmTKKlAMvLIok7UZt/FXEbQNmCnhane0JE1qY+WV3a6wgM1pZHLS3ArC8OP3?=
 =?us-ascii?Q?PKbkfyTXEFBqKIF9q7muEPdPn1Ig4HU2iIM8LUEyW3TIrzxc6WzJ6prXA+EP?=
 =?us-ascii?Q?ltvEsNngvX/2hgMwjRG41C6uYEsBzUUhko6bFvGGzpdzq2H5uwNOvUcKu7aM?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4121df7-af2b-4ec6-19a7-08db39aa6279
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 10:00:16.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53lsa0gm5+h/2vjqXn//je+8glVmBDt1SDbvKhXDqFnX4DzcrgOCf6C9ghjiqV2CAJY5OG+/VJpZG9D7Pu5vNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8125
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:10:31PM +0200, Andrew Lunn wrote:
> On Fri, Apr 07, 2023 at 06:41:59PM +0300, Vladimir Oltean wrote:
> > In theory, an MII MAC-to-MAC connection should have phy-mode = "mii" on
> > one end and phy-mode = "rev-mii" on the other, right?
> 
> In theory, yes. As far as i understand, it makes a difference to where
> the clock comes from. rev-mii is a clock provider i think.
> 
> But from what i understand of the code, and the silicon, this property
> is going to be ignored, whatever value you give it. phy-mode is only
> used and respected when the port can support 1000Base-X, SGMII, and
> above, or use its built in PHY. For MII, GMII, RMII, RGMII the port
> setting is determined by strapping resistors.
> 
> The DSA core however does care that there is a phy-mode, even if it is
> ignored. I hope after these patches land we can turn that check into
> enforce mode, and that then unlocks Russell to make phylink
> improvement.

Actually, looking at mv88e6xxx_translate_cmode() right now, I guess it's
not exactly true that the value is going to be ignored, whatever it is.
A CMODE of MV88E6XXX_PORT_STS_CMODE_MII_PHY is not going to be translated
into "rev-mii", but into "mii", same as MV88E6XXX_PORT_STS_CMODE_MII.
Same for MV88E6XXX_PORT_STS_CMODE_RMII_PHY ("rmii" and not "rev-rmii").
So, when given "rev-mii" or "rev-rmii" as phy modes in the device tree,
the generic phylink validation procedure should reject them for being
unsupported.

This means either the patch set moves forward with v1, or the driver is
fixed to accept the dedicated PHY modes for PHY roles.

Russell, what do you think?
