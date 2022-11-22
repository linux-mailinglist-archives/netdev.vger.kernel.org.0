Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC626633911
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiKVJwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiKVJwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:52:38 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2062.outbound.protection.outlook.com [40.107.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE4A91
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:52:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PexxWe+kecReFGFNCRxyTi7LeQNT4v2ty9tIauHV0Tcy1T3OCeM79BgqmXCtps8AuewIbCa+Cs64nTeSbmLCGt1OgG1obekuLDNLQGkKNCs0dUJ050MDLYPg4scCvMuLUcFAT022+wvCfJ99n7eFWwTDWax2bDa/M5XMeskG+P9B3osVrHlbXMQ+ltqc9mi0Ma93Nc3hXWn735EM4iCWlaSjwB6lSfT501ahkCnXUeLRvLhvpHVhq6j6rKyplYRyiyICgAldheGUxvxRVb12zAS8oU61jN86D1/FJZNLdn8unN3HAGWdCi2M/ulsmLdA+MzXxLdIRjT3gCLKUNg1eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+4IWZ0BNXMmf9RfaSq8HeANEGNn6c9XNjo8Q59Brq4=;
 b=dH+kOo+GuX7gLTmb4mk7R1MrgsdD9pC6qowe9g+ByjzjK4PfgEQqz4ysaNcd4eflmt51kXrmGoyppICj3mr+PJ1C61QB3iwGSNJ5FLskaOysnS6AM5k0/SA8LjZNScDuivm9rCIO4F7H4TR+nHpq97kx8Dz6dchiem+SD+8HRBKTKTwI9oQOSC4z1gXcYqINth5I70hXK0bObRKNV0TfMQSmfozOdX4GzpS75AWEizAq9hFKovt16nsjTht52qP9eeCaqmQg2qlU829tVlJsWoDxImX34zjslswVQwgc7v6A9RrpsRUGYQ4ZTUxl2AKN3utXRo2vuf7NLEGr9pOQ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+4IWZ0BNXMmf9RfaSq8HeANEGNn6c9XNjo8Q59Brq4=;
 b=JZ6Mw9xlpOVvRn1Oe/o+4I33RTp6dsqCgeD/e10uvp9B3BQZeLMgekxPdg4e4+nbpJzKS2CxrZGWB14RdnXvFjqf252JU2fbT7t8IL8EC2fB0kLLkhQKj/pBlytzF+EgcTd4l9vXeW1NoX37CivTmZNdrPRlH+f9rmhJbsXkjUk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9080.eurprd04.prod.outlook.com (2603:10a6:20b:447::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 09:52:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 09:52:33 +0000
Date:   Tue, 22 Nov 2022 11:52:29 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 2/8] net: phylink: introduce generic method
 to query PHY in-band autoneg capability
Message-ID: <20221122095229.najh6ghek653dls4@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
 <Y3yUoNwyJRQViyOY@shell.armlinux.org.uk>
 <20221122094131.jkgy5thhrlio4425@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122094131.jkgy5thhrlio4425@skbuf>
X-ClientProxiedBy: FR3P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9080:EE_
X-MS-Office365-Filtering-Correlation-Id: 2538fc8d-adba-4f5d-47e7-08dacc6f471e
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0/x9HNxwIVm3vZ11uy97ENhyYkGHNTkgPT5yIoiM9N50mkUCh/hLc4HtSRbdN3aGFo9/4jeHaTbNHMg6GUOwtEtH71So6hUIquwm5shYQ9qdb6+FIiFvAAJFEhfm6jHEj31/bILOdMl2vPAMNuZj6CtX/GWmPn0hAqn8lo/cWWT/CILj53ikd33t79Vyn1ixcltH+1X3vLJ3qqkjjCK4D8csrJE//he0altIQZiFD4hbHC9WneIykJnPyGSbZka9vs/RO3yqoonnooam2KhqR7sI0YceQL1HVw6GrIL7nKSy3NIIYFfeQRpWzC2Xmk8TWX5Cz4EIxnVvt3X06ELL2WcJvCW1n8LXfgPi8liJuLWLHY20j2P4TLA3F+xH8koRZodXYEuCCqyufHgmWTXzx15PHhBD3TlYfPjE3/F+0rFrQeN9f7gDqpW32PTimW4Yp5WyAwau8ZECi92vbj5SnDttJ6ng/C0DZ3zktJAkbpJBMfJySmqcU7axluXNPWzMxG8Kne+NBqpBF4DzCzrSGQBb/lbsbbfmMlO+TQ+zCBcZGDTI8vtFiiobut/2udThS522Ch1gChZqgvN+RzERZ304s2Eh88BCzolbiG3DHB9avWVJEP+fZknU9sQO2c988BErctaLPy+7+O2d4Uz5WyXGLSfLpjyGOgezKSACHLdm/JnVg1jptoLYlSv9mM9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(1076003)(6512007)(9686003)(186003)(4744005)(38100700002)(2906002)(44832011)(7416002)(5660300002)(26005)(33716001)(6506007)(6916009)(66556008)(54906003)(6486002)(8676002)(478600001)(66946007)(316002)(6666004)(8936002)(4326008)(41300700001)(66476007)(86362001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DY6e2OUAXXvCRoxwYNyIF3wJ/qfcShJFx6VmkMiBAlVqhzV0GId5NShwY99l?=
 =?us-ascii?Q?DyQ38I6XkKszbmsESpt+EjyGLgpMHrEgFeDYvi3pCOVHqerfHXBeJaQVOVmd?=
 =?us-ascii?Q?bO9xTEODir60LWLA8NC/rqU8bJo5SxImTlISY4xJxOLZJKd5zS3/ewgt/KTf?=
 =?us-ascii?Q?8hSpmqWFpEoDjzkwbqCCYoxQ9WnXbb96m/yMbFQW4WfQNfpIYHdtviMHJcG6?=
 =?us-ascii?Q?EfxgOaPiJ29/KU0zSj9lvbYxhm3n1KEQRmAo6wsAVIXXALWQZAAE9Im7L0u3?=
 =?us-ascii?Q?VzEBKRQBp6pfv11EcnJygJU9pYRYVHaLYgarCSlO+3iKA5ZSi8/dfKYWh2Nn?=
 =?us-ascii?Q?Cl1oHp9pOZnvaCbCe4Irlg/E+rc/Q4f24cgz6M/2PjsO4VD3Tiouyjpprr8s?=
 =?us-ascii?Q?xdtUdLieuNWzh6bOKqBpn6OoTt4uClMhpsnFQH04LNCamfp0ab+YUrbyFuwU?=
 =?us-ascii?Q?XYbPsiLV6/UElv26c9I6hihGhg2wJ482ocaejJqwpQpoTtI5CagIHuHbAzKy?=
 =?us-ascii?Q?QSHZJnjGOa7e+bumY0XZB/9VVemlXkeNYsaNtOvydNxrAc3OL7pjZFifE01R?=
 =?us-ascii?Q?eRPsWD37x6kLO9hMymYjlRk7dZwknP+WHiXdmrsAGVV7NAlFJLlyCJ0csmoL?=
 =?us-ascii?Q?9qU9O/EjLgO0Cqk6w3hkQlzMJg4cGCpMDYORxcxqH7B+tdYqXT4nwz2yTiwL?=
 =?us-ascii?Q?Mrf6LZT86tKVP2B8+Ub/tWraBOVX/6jowkEqy7n7XPAJNjv3afISTyoMJE0k?=
 =?us-ascii?Q?Ux7LUmxWpDOSlrHP7DfYbUiSH6HUWwiPREmG9DfJAna0vOH549DmqUskaqCn?=
 =?us-ascii?Q?gZfbw1DQ2rdRRVjofTtIMddGcIVRvJrDvA656L3FWTTsaUk0yGJgUib+qAGG?=
 =?us-ascii?Q?YHVG8zLuKOFratjiJ/RT3iaWz/lmfmkFpeCzO7YmwA/eCtv0qmYcegc2JToC?=
 =?us-ascii?Q?Eac11mS1rtqcRC4rSznPigxjzo37cbPOmCW/YtEq7QHuoFntubafLnllf0ng?=
 =?us-ascii?Q?kRYbPsXr/rBrXFod8d7DNqP12KoK++BdBqzfCud+zRwc7gCECQ0jnjjmxVYb?=
 =?us-ascii?Q?grA9z9oTmKtRbEXNZSweYLwsBgzG1hpZvTv4nliSlOVR+T657nxGmsTFNqhe?=
 =?us-ascii?Q?HVrjqz8flRgJsRWKiQmj+vPvgghhx5u485rl4lgTimnV1iVnlLCYmmnXRY1G?=
 =?us-ascii?Q?PK6U3NVYtObeIqx8P0oLfxD2HohLUU9Ng1/36VQTgUa5nIrn7hmJqRHUNZ24?=
 =?us-ascii?Q?JCTQNhFLNF6FrcGiJ4VfqJYrAoVoJcw/mya5C2+R64UBNqTBxSl7VgVvgGO5?=
 =?us-ascii?Q?OIgZkYT6tunvZvw6nDEmzuUCZC/BsHHA4TStNc2470v8nvLMUszYKIr6rHJo?=
 =?us-ascii?Q?HaOv9Z9DTFrjy5TX70bd+TtO2p26usP9tUvFQ2Ao3zQBT3EyLcd9bcbld9s9?=
 =?us-ascii?Q?IHRKx9Qe61uty0yRgWtVMktpu7SAdLG4pW+as4s5I84y5Uc7NaP3DwGpdZiu?=
 =?us-ascii?Q?Mk6puElmR65xGw6BQAuHshqrkKrpHHm5Jaxr89GAZtPWBCeFrn0HA9JKJdjy?=
 =?us-ascii?Q?zt3Zf6jqMGyQz0dKR9oZWaPLAHS5ThyGbLoC3VTmo/GMEdCsGuuzIlqCIaAF?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2538fc8d-adba-4f5d-47e7-08dacc6f471e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 09:52:33.4043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmntjQ1XJLfN5xyILHiXQU5QgASylBVFtKig3TwbEMlKLPkQfxWVzIe1x68BXGnIVz8bpHaz8ZZZaHWijfidlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9080
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 11:41:31AM +0200, Vladimir Oltean wrote:
> Maybe it would be useful in itself if the MAC cannot support MLO_AN_INBAND,
> like the Lynx PCS in 2500base-x, and the PHY only reports PHY_AN_INBAND_ON |
> PHY_AN_INBAND_ON_TIMEOUT (hypothetical example). Phylink would pick
> PHY_AN_INBAND_ON_TIMEOUT.

There's a separate but very much related issue which is that phylink
doesn't know that the Lynx PCS doesn't support MLO_AN_INBAND with
2500base-x. So it couldn't make the determination to select
PHY_AN_INBAND_ON_TIMEOUT rather than PHY_AN_INBAND_ON right now.
