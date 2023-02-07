Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CDF68D6F0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjBGMkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjBGMkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:40:05 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2055.outbound.protection.outlook.com [40.107.7.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898DC1EBC5;
        Tue,  7 Feb 2023 04:40:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXfn368j7GA0wiut9ITNOHm4iTOFaStYSIOYoIaQSaBHHPcZIUmjK3rO+M6A92RCx40kkxhgdCM2uOM7lKt3sqpz0kHyQFi4r7lm8f0WN3Y9Spe0A7BbwVfiX2DnMr+QOfoOEGzBvHdYGBNStjDI2SgbGcIpb/ozI52aXIChrOrHv659xoXZnqM6UZETjhRKVoAS3ubLQ1bqKonu1idSuTebpS017vJyGrtWVQ7L+h90lpFH0I+4ueD/bCofO7KwshHZJLgjXF2Ap8Zrz2aY+KMEuaNiMX8sGtIerpKSfEHuBvNh6PJ7rhVqnM9pEOqFutUE4EBwofy7ohZ/PU/8yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JRczBktnn2FtmOXNN48i1slL0Txn4bFCkEV3njRP04=;
 b=nPx/hQFmjnmn4KRnnZrXGn+wYtsmX88MZzcQ97H5murx2Qm27ICSGusUjhUmC+vSMa9lG/vmaO1e3VYiexX4iE4BGUO9yVQv1eOP/8lyRRnZQFJWq+w+4O8uR4rWvTgxgZ47fnO+HyjtR5CVj+4TfRRl98ND/79213begFdw0605f8OqXbCTn3QBzjoZBPDX41qKg2qV6Va6laF9oUMK2ZBzkJ13PgEFmyU5uUruWTVlqvtnjDnlLGBIKmjOaKYXatDUYRuAzmY1Jp8Jcp8ia7nwjZ3uPi9YAe7gY1DN50nlwwDsjgpd83w0EFWvCgclIDOanQKRgsSaKWT3BrWXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JRczBktnn2FtmOXNN48i1slL0Txn4bFCkEV3njRP04=;
 b=REcZURD2AWPNWPyRqbFJhqK9Oq1Tq3KFaSY7z3vZjBQX2R7jMlZAtnlN5Qlmw7tCa69cR8dNau3KGiHOoK/NfaYnEnsC/Xnq3bjrhHvCN28nu5nBgY3Np2hZ4K2eAPXY9eap5XBLCL4gL+B+oqiVYZiEad6XTzCsqwAXUDO46d4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7021.eurprd04.prod.outlook.com (2603:10a6:800:127::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 12:39:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 12:39:58 +0000
Date:   Tue, 7 Feb 2023 14:39:52 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, richard@routerhints.com
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
Message-ID: <20230207123952.r2r7tnama3vcr7vt@skbuf>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
 <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
 <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
 <20230206174627.mv4ljr4gtkpr7w55@skbuf>
 <c4c90e6576f1bc4ef9d634edda5862c5f003ae3c.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4c90e6576f1bc4ef9d634edda5862c5f003ae3c.camel@redhat.com>
X-ClientProxiedBy: AM0PR02CA0113.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7021:EE_
X-MS-Office365-Filtering-Correlation-Id: 76407186-5e67-4c7e-afe3-08db09086bb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJI3DtPALIvn/DKTcQ1CrwP37hmO+beop/WXXJaGx1Co7p/jE4PZMIN4PJ6fVdON8zwiADU5+6ffeAfYuRaRWcsUng7577ecEkcic/UUoTWj3t12GrsQPoCsM34EmI+62a1e70escr6EoVj8fdEgSobeLpDn5pakBwTHJbQesL+NJvJZT4WSwaQMWpoKnRbJJHWMYnDoMbv7h2A7n/A7y+/CHEqfQ08UMmNs6Oj+6wc5BiR8UJqQzDgpIxotXBI3DVtb3Su9nrqSvM2CJcnewkW6DT3F2QRQwECkLH/ZHuU60sdetNW+by4wFpSw2Wt2FwshxPAzMRjfPEzYlTKoEQ4o7eT512Gg1Pp1woecG4CFJtYOtnF7kWbRGcS6Sx9ZxYhRXZuNxhRJsdIN36QN1z5esnFkwbtH4yaJlfnYWAKcywJcBC7+oJC5sDHzPLzvL+FQ/4hLmyASeYWgOHW4q/JnfrZE+Hqvf2CBebalPb54nl+T3XN9t6nD89eD5ovEYKIwmVlnFqU0Z+xBpl2EnS0v38xtjeWq2uBi3zSHusiKUEZz8G8/0BlEhbSMm2jxLnWoj3JY6A6rExk7Z4fhtYF5EmODaVlzz3uF4N5pQ7rIlGVYJr/lmPqBoZa+gVJj67lRoJf1dYChNoYTnuI05A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(316002)(8936002)(66556008)(66476007)(4326008)(8676002)(6916009)(66946007)(4744005)(44832011)(5660300002)(41300700001)(38100700002)(7416002)(1076003)(6666004)(6506007)(6486002)(9686003)(26005)(478600001)(6512007)(86362001)(33716001)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q+ywLf6gXz/tevE8nGQytpDNq+aZzTEVvv6z0DWc6FKCoUJdE+4w2fQ8nBlr?=
 =?us-ascii?Q?UjAu09ZQ6LTyDWloOmV442fpIexqLGlU15qLs6bPCPDlUw9WOmfQRIatCc7o?=
 =?us-ascii?Q?gzEs1o6VkDMxsd3w3Bn0nisaBQZhWjDWEgYVHt95Mx3y5U8DVmxxffi76fb3?=
 =?us-ascii?Q?6WSW11cofz4HzSLCIGmNd010YmUL0unXDY4l91/LGiuF34MSdmk5cggzdxwU?=
 =?us-ascii?Q?xfKFSauV3DAHNjwSGpA2sUc3VboGXFYxnBDq+KlRM3+vKthBMNoau0XhaEC7?=
 =?us-ascii?Q?8RJJshUb9B8eT4Ct0YFVtPA2JqARpa83u2eM43xs2jrC+5P+LUVBGnV4wofB?=
 =?us-ascii?Q?hghIYcVB8xFlHoWFo+whfT/O5dnldwtVph7hRzEjUrwSh12fAGAdivJPD/0V?=
 =?us-ascii?Q?RO0NIk9pwLW98swgEb6Vl7fRfLmixJKMSpICqCa/a8RZRoDYCWzejz5d0gIq?=
 =?us-ascii?Q?xNBSZkSluQMqv/b/3dxAAK64WDSDmPpKgYAOeIWQlVn1dWtFa3xnb9JHqITj?=
 =?us-ascii?Q?6P0KDffMSnxo+Rae4Q/zllZIucmsHa/FiDnxaSl/YQlt7o5B9CijAnjZNKEw?=
 =?us-ascii?Q?J6fn7sl6QhUahSixmbidWUcSD1lbjKFsB9aGZlKsNQaYOjn97ZleoaeM8nud?=
 =?us-ascii?Q?ii20Eu4ji4sXuTaFFP/Cm6szcZ96pJEXX0Ukkn5PTE5nd3XYSOavKI7k5x5A?=
 =?us-ascii?Q?nRtSwh7ScxwocelFQayZjNIXSeHRlHOLLv9SxfnOOFZoOgbMvevR1kpMbtHB?=
 =?us-ascii?Q?kvNF7Cs6s5O8oLfYrRwXoOe4vC3ftYoNh/LCMRJ6LLTxXb0rQKEcscDoGCZg?=
 =?us-ascii?Q?a8G8YOSzIQ0eDVxtJQY4AAeso8qecuoNdgQ3WZQNsXcwWWq0dcGH6LJWi/tb?=
 =?us-ascii?Q?UHhopjU/cHulKG3gpY35mib4c/oVGwP1jmwA59F+Zlyyjpmqa8t40wBmeKsA?=
 =?us-ascii?Q?dZGPr7T97fuV86LJcXkXSy5MyNC0B+VkFGXJ25f3gPIXPEn9XXzikvu1gYpn?=
 =?us-ascii?Q?B7ydHqyw86tp97EhS27FP8AC8EzNvgmmLm4+F468DKtVYnxR/G3ux4y4QzbJ?=
 =?us-ascii?Q?7nsxEL7XqEguCEREDBiPGDqiLDbRY0VjAdeh59J0hC3oJG2Dt/oxpp4wlFav?=
 =?us-ascii?Q?MNs1rnWG889ky+2EdE7+TW9sSwJTzJLBUpwvKXGJrEu4W7ty5GtMaNDxov5u?=
 =?us-ascii?Q?gkRU1BS1DZZa2f1jwuDAvUOvBqZEQJgX9JrjQ94zx5jTz0Jfy30cQWNngSNK?=
 =?us-ascii?Q?ddYxK8Ic9ruqT9twQcPK6s2PdWMNvXHfTTqrJsCZ1/0TgXrUCelKhNdrwSQq?=
 =?us-ascii?Q?qzQaZEzCs0cN+SnVTimnk/3Em0tFRzH3SEj6B9DdleMgIv0ZqFBU+akJ1O2A?=
 =?us-ascii?Q?Q8x7xWEeifwWHZ5IQY81u/r6Fam1beHK38FkRK4wM3J6fxMf0xsyP2SMtoXG?=
 =?us-ascii?Q?8Ie4o26tq6kMsZIzvqrYzpDXZh7iw1v1gaq4rublwVa9W7XdlTulurR++PoR?=
 =?us-ascii?Q?6b38hndw+FUPCNQg1i4bpvFeaHeEW86l76yuRFQfhGWH6S2KlQbd8EZn5G2E?=
 =?us-ascii?Q?gn1UirT/fbvEkwuYPovGGGQ/qGaN+klC8XdkXvCs3HRjOVNMvUoMjvyBi9AD?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76407186-5e67-4c7e-afe3-08db09086bb9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 12:39:57.8526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+lQYMnre43lqmQakZilXTX7LgwJnieh6pPVttuJpzSNYPzLM5VtMPE/fzlFXEp4cKafSpcPvQ6qTy7MGkiMFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7021
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On Tue, Feb 07, 2023 at 11:56:13AM +0100, Paolo Abeni wrote:
> Thank you Vladimir for the quick turn-around! 
> 
> For future case, please avoid replying with new patches - tag area
> included - to existing patch/thread, as it confuses tag propagation,
> thanks!

Ah, yes, I see (and thanks for fixing it up).

Although I need to ask, since I think I made legitimate use of the tools
given to me. What should I have done instead? Post an RFC patch (even
though I didn't know whether it worked or not) in a thread separate to
the debugging session? I didn't want to diverge from the thread reporting
the issue. Maybe we should have started a new thread, decoupled from the
patch?
