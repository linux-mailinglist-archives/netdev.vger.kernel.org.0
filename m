Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257E9642E8C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiLERUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiLERTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:19:52 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2071.outbound.protection.outlook.com [40.107.6.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06336B49A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:19:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i68mp+90reRWnJAxg9V0MNzPDk+IwLcV8hSPkZ3YqVfIF3oem+bAmnYCJlih+5xz7M6J2HJc8JsyCnWBKhLdB7cezftW+gmWdz5TUlhuGhPKi/GEkZ2BO7MAiw2+5P0Cl1mBNhGYowj4+hxCHiYzo4eeFP8Pr86RnEsVs6goWSfaUJTiVxfRrc6Wo7XYk17K0Ixu3FG98gtxwI+ficrwAPLBlb07rn0/c0Y+KvrUAmE//U5xAXzEuaGAQdFjmzyRG30hx51YxFbQq3a/jPzefCJQYFJHZDhxrwFlu1r3PCQIxH2p6oWvPMC3i0ZAKZSKkAhPKYx6bpy/4LlNMZar9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdvPPchvfnrcCmHRuVOxVqU9RKLpcp8xsqy+dP/7fSQ=;
 b=TeC7CEWB2l1yN+AIgN5eNo0s9Q8HSNDDgFEc3rPPtcroxsDQ6dExrsqoJfwhgiNy41rQfZ2HfgqVwouRY7TroBWTh59GYdYFf6QzHElhk74xuK4/hOXjILZOHJsGSX+XDhMSnkoR3Y8TaoDDxrNJkcz1gR76I3ni9PBfMhUUg5ZO1e4T12jyuiQpJ8Iwva0iZf0oBqHTc+KLSv4cgTsRGrnuQJ5UcgMgJtOoxWKs4vAIJtrRDCnytHxSQZbVJNxGwzoK0/WkNOHmgTyPAl9+2ByvCtb1BeWoZJ9t0e8hdymhmxtfxv027CMfzbAZZ3RXybbm9gQkhxHSNf32CQrsVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdvPPchvfnrcCmHRuVOxVqU9RKLpcp8xsqy+dP/7fSQ=;
 b=BhR8aman51SKjTlYtQGQUfVhPAekLOK2hupx7SFsO+RnZpTKQrmSSg4QMBC6CZti/vlQc967a+tztrR6fNjgPtC/jM0QpGRTcofVuk5/RCb6o4PRmEpxbSe/K96oHBdNNGXr0RsdfN40EiO2CD1ONi3D4o8JuzEvD2RfQvvZ9bA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Mon, 5 Dec
 2022 17:19:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Mon, 5 Dec 2022
 17:19:49 +0000
Date:   Mon, 5 Dec 2022 19:19:45 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Kochetkov <fido_max@inbox.ru>
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
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>,
        Maxim Kiselev <bigunclemax@gmail.com>
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
Message-ID: <20221205171945.t7kvgryhxffpqckd@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <1edc2a6a-d827-91fc-0941-b8b8cbfdf76b@inbox.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1edc2a6a-d827-91fc-0941-b8b8cbfdf76b@inbox.ru>
X-ClientProxiedBy: BE0P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e424b69-4cea-4a0c-7002-08dad6e4ea2b
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMBFExRl1dDtnHvFSMmGcjwEVA4ykH61E1I961aKpSF7xu50rjp3KCLT5mNFmv32DKgqw1AE95GI1bu5xgK2yyF9DPXOX6rhif0lieEYgifr+ubO0+CYuJ5AZ4Cp9W6sF3TqyfpUikS64GDHMZNXaEjWuxE9zpseq/yQGtvcExc+WuDCgLMqJzjwlPsjn1YJCrTB12XgVuyNf2P2gAhxIb99jaQEdIqy3Ya16llGYfKFgZGe1+p6JneBQe1iou2Z/YavLiIUtCzh2suizxFon3XaydzqkDsqI2xwn3IHkG5n/POw/jwz4C4h8n42Rt4YXWg8+7xgHFWIgFxax8MDy8hSvfCaZRaKM+Qx5qtG4X0Ja9Vs7Wst8rYFKEhsaHRlM2EbNjN8u8Cpb8DKAohvq0uiTFYWF+I9drUUbfkEONYa5mVdp46Zp8/UW76dPhFKY5zmFcbDC1UmQKCq4iHI+EQdIH9hWZV4x8sFpW/q9bdnZMdQjMEv3iFe+hv90ch5SVrgIAs5IPVWjfmZsoTK9aoewZx49phTOGKS5ktkpR1+E9vcirK9Tu/I+Gd2Gj8hWdqu9tS4iDl685u4Z5odjYUQrSVw7ZHs8PwR2MzWFF4XcoNniTmr29kzZEu1Mm2GdzyQ4a5fPfrIo58Jc0ITig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(2906002)(83380400001)(558084003)(66946007)(41300700001)(186003)(1076003)(86362001)(66476007)(38100700002)(26005)(6512007)(9686003)(33716001)(44832011)(5660300002)(7416002)(66556008)(8676002)(8936002)(4326008)(316002)(478600001)(6666004)(6486002)(6916009)(54906003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TkGFH356fiZLOnrVgFs3QEUxLyHmdFytPsgvT4kwqJ/Gemd5l/letpLqwMQQ?=
 =?us-ascii?Q?a+DKxtGSxrJNBsxx41iDT+Y24xkYfAa9mGDJ2wErgPNwUh3MtLz0OOdFeMgi?=
 =?us-ascii?Q?h7DMQcbORYZZbK+0Imq2DG0gYFq80A5YcjjrzlJIu4aGVC1Su5zraoccL7KO?=
 =?us-ascii?Q?rnxY4s9tbaqPgXktRvXIvGbwzh1BjtR0uO/xKmHVjEdDeaVJrO53HDRJTyLX?=
 =?us-ascii?Q?lifZOhxTYy6LT5EseF5K2Es07qwrNrN//9vLjvCDwBoT73/JPoZ4gL0aIN5C?=
 =?us-ascii?Q?TjJdq0ItATF8MTbK/vB8cUMA+bjAUw+z8N/ujIa32KJ1oMYgpY8RJuZ2Dm1Q?=
 =?us-ascii?Q?yphiWL7SB5ZNJ6jo1rfMG5cRXwqGR9WdxPL60KOMLBnjjyLum/IFFdXm4n0k?=
 =?us-ascii?Q?XuKVg13IA2UQqAT2Ml0eo4nMsHBziaFir2/1E611gESavOXnqmOPJmrzkrYc?=
 =?us-ascii?Q?4qtXrOs5TiCQjYZ1BdmkqGH1e2UIGDsjgSYE9588nhqvSrKDankIxnm07h6/?=
 =?us-ascii?Q?FyDA1IJ0upXnBoJ4b36Qv8XJNfbSROvmbcWIv51UGVycb19Ev3/qmxuh019c?=
 =?us-ascii?Q?52RCWjKxrN0xtaWyGdLOSev2L53vqKKEFsgn2yN6XYlIoaylujfTBOY5RUvZ?=
 =?us-ascii?Q?p5gG6IjxxKLizZ07EHJzl7GFxS0jvR5YvHcNH/9v4keJYZMGAoiU5YBqmyzl?=
 =?us-ascii?Q?G5yolVzZdOP/MVKRYJAkpG2Jvf4oZPN0jhR9yKUaAtQbKhJDnNMkXskV+E7P?=
 =?us-ascii?Q?rWbMHJo3WJ4AEiNLzj07bEs3nPVTpt7VMnejdCv/JVa2qmT1HVpGCMMPP+1c?=
 =?us-ascii?Q?jBSioFUI1+lfroO2yvRaJANTAosiyc0ds0DPZ0MHU890UAxf+zda8jtMFUv6?=
 =?us-ascii?Q?EG/RyLlkGTzbcs5JVq1ygZGbIs5XqY3qMBkB76bbIjzW2jdXuSKAlC6fNlZs?=
 =?us-ascii?Q?O0urzZwU4Kquhzc1LzO52cs6vxO24vaWYof3Kft9e2PRVlNP8TzfqpWIEOjr?=
 =?us-ascii?Q?wkaUCG9UMtRiaqE6cCxQ6ZKfk4WBoBTVkMpnIe/BijHg2ZmH1mw/x9NiFYzf?=
 =?us-ascii?Q?9hwf4nYlTxQUUx9/T92yN/oHUBHjz5uE2V79wnO8lyVh/naRE9NNZ/DLKB5L?=
 =?us-ascii?Q?Exn6w3Tt9UY369dBIKwGsaNGZr2vKP1kI6QZs9zoPnl3yCHzkWgzkuRXZF/A?=
 =?us-ascii?Q?e+thORjnl47is15V0lgnx/vHEi0KZsd6cNbWskACpY0WgF93Nurc9y2eqVAF?=
 =?us-ascii?Q?uybf2NDK5cB214a3n4XoNYcXxE1DIaEPzIi84k7REydfIyeWV0VDwy+ldwqr?=
 =?us-ascii?Q?RH+PALrNKU66/tvesd9Zllz9ZNkcoTGj6mTxd+F+MH6Ib4s4F4fpvYudpz3V?=
 =?us-ascii?Q?JxtjcPxs3YWoqDZd8ZMy/ziQh6owg4XQiM0hGnYqFh+FLZmTohUs8+26V0VO?=
 =?us-ascii?Q?Dq2XEqCBGdJvPSbxVe1880zJAHPnJkzULc2CuTIJ7KOTg7SxXenSH/gmWOqW?=
 =?us-ascii?Q?oq+Fk8gO6wijqz5swERQDW6vQrRhzdAdsci3Rey4MnVA+pH/Iyxeaw1uYmLe?=
 =?us-ascii?Q?3+KonmVv0EogWZiJoNAgwShybN0R5PUDQsPE9xhhLb+UiVED7yoLe6GOlqVF?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e424b69-4cea-4a0c-7002-08dad6e4ea2b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 17:19:49.7980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8Tj4HK013DeI4lrSnbWAzWjtyR+3L0oTI7a+Esojv7U+7nvMO3hb38bhbS/WHEcMI4GEkSvTSFoejn6ynurMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 03:16:19PM +0300, Maxim Kochetkov wrote:
> Hi!
> 
> Please add Maxim Kiselev <bigunclemax@gmail.com> to the CC in next versions.
> Because I have no more access to T1040 SoC. Maxim can help with testing.

Ok, thanks for your contribution to the T1040 switch driver.
