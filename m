Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B3F68C7B1
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjBFUdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBFUdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:33:44 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2060.outbound.protection.outlook.com [40.107.104.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1234A12076;
        Mon,  6 Feb 2023 12:33:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iK392bIxjK/Sg/9D2WhcUh6qXg6Dpdu86ZXtV54UlykUQ8i5rn9Ob2GIZ1Sr0u6Bbj262WdOJAHUtSDgJcMFcLRE5aih5YlarUhd31VdyaVvFfrr2AhfSgTCJWYQhhttV2kZYfKJrGx2F1NigkXuLlLyLYA05DyPZA9xb7lY/geQgZREuUakijUz3Gz7TgGCGcSA5nbtLz5fVpqisv8pGJbl8AE3BNW+305eo0pMv6bDNsCTyHULEwX7AVMBB3DaKi2BLSF15Nj87o8iJEjH/T9QN0ICsMjYvbQu9DPV/tXmizQKbaZ6tZR05MhUUBRStTI21lg4EAykhPt32qMqdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeC7JPAqx9zZtwQRn7NbRa1nsXFYiZLnx9XTfjVW+g0=;
 b=inAp2O0Ba7F4Qwn3OSVBE8twX/8ObvcOaURGP/czirkZ9Wo6waazXxTagI/oyteoYLcAOZX48hpJw+Hxqjk9/nOOThW4Cs1TpNApV/3DjpjIFZACnOaiRd8i50zDDbOiLM1ok7BazNjrakBiPMKb1i4RSqzDv3v8Xom5/kRD5hlGw+tRsfSLp/QoausBRSPUtAu1mizd6U9Fv3+uxntTy6603FqxV9xyTkTfG//51+bvpsXo7gaWE2UKidL4OYjb8fKLZOYSDR4WnOFn/NR/3eIM1NkBEbEwZjtJ2veH2/WFR4GLOA3Ux08iIOBPFsRr8kKxUszCLdfXBJs020EuTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FeC7JPAqx9zZtwQRn7NbRa1nsXFYiZLnx9XTfjVW+g0=;
 b=roDHK/FFGEUbmYIQ3yQhNhEMy28Zk0ccscsEGxON8uFnmjvJGtPjMg3+G6dVWsu67uyLJJO4uYFiv2LGHqE+kFRoHHVRA6l9/Xaddkcrx/QHgiZBOlIdIWq/gCoQP4ZJ9YnDeOFWePyGTlhHaWTE5dAe98EVlyhNgh3C4khKukA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7304.eurprd04.prod.outlook.com (2603:10a6:10:1ab::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Mon, 6 Feb
 2023 20:33:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 20:33:40 +0000
Date:   Mon, 6 Feb 2023 22:33:35 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
Message-ID: <20230206203335.6uxfiylftyktut5u@skbuf>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
 <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
 <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
 <20230206174627.mv4ljr4gtkpr7w55@skbuf>
 <5e474cb7-446c-d44a-47f6-f679ae121335@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
X-ClientProxiedBy: AM0P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBAPR04MB7304:EE_
X-MS-Office365-Filtering-Correlation-Id: 3547a517-c27e-4c43-a0a0-08db08816e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /oJSTCb/7flLX6T4D2wFTwObJCOGLtmKQYJeoxR/pcWYxZM6S+QgWQW9//7C43+wHZfrqpFG4e4B4a8hWf88OZl1vIuIWuvYpEsaH2qDuspawDYcjmT+J1bucoGrD0W91QLI3NKwg4DO0cc2Y6M5m6HTOEyJkL791fWXGgGpA1PQpj8rnRUebvCJkFvbvrXPZD8HrgKXaSU8gy0s3edwyNuoMPpDl/gPS5Hh7RMPgNl5ANTQvfuxLMMIy4bpZAqadPij6aE/w39nRS7W+tqWHE8JXv6h+kunHMMuKykFP91JX7MiQVmzOe+ISe6rwwPTWH3MCTzIdeJiOE5mRo41YoOoEl/u9I7c6gi0Hvgc5oP0t5cMYUCaJVI9YPFMo15JySRCg8LcOlzyujgdyPjU013kJIVgOpk7YOe0IZDt6kZQtJz237sbHRqJjvwnH5s/z9Ut1F3wKEF1AtABPjzxzX4pTMuBIFNb2YUNHiR45l2TM1GbY3W1dvkjCxPU3TicdSdRZMVRvZKvYT7/fLvMs9M2DsZ8b9FNKY0ZVSiTbuXnceOtfl1pnU3KVH9zkxZ/CFuXHLlMAO+DLuqNFpDbuPT/3Vh0tFcuiPEIwCxLwstlLCY+6Krx9SgE0JRnS6Mb8jRXkpF0p9JnGzqYfVvHqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199018)(4744005)(44832011)(38100700002)(2906002)(54906003)(7416002)(33716001)(86362001)(6666004)(9686003)(26005)(6512007)(186003)(6506007)(478600001)(1076003)(6486002)(8676002)(41300700001)(8936002)(66556008)(66476007)(316002)(66946007)(6916009)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzRFVy9mRGxBL2pLNisvbHNQWE5NVllmaWVhMUhnb01IUm1QRUd5RXlOeHl5?=
 =?utf-8?B?ZlcraUIyeUMvV1hpNXZFZHp2K0F1eUU1dUJjRU4zR1puNmJaRUx5cXZ3dVFs?=
 =?utf-8?B?b1ZJZnd5VVZFVmVSV3l3cDRYdTRYNTNDNjhwblhyZWk1eHFoQ1IxYnQ0cHRh?=
 =?utf-8?B?VFg2WGZnS3NMN2xmY3A2WWNVWWNWalhIYWNnendFdnNmckV1N2czVVhVS1RX?=
 =?utf-8?B?ZVBVcG9BdHRSaHlHTjY1WVNKQVBTZlZsYjVFcnJxM3lMME9rWGh5aGJMYTZa?=
 =?utf-8?B?THVpaDM2UStpVFg5SUN1ODQwRWlZYVlibElEdy9SRkEwU0pCYWttb21IUVcw?=
 =?utf-8?B?WStjUkkwYXZDeE9TUjdTMjRCeDJiaXBKaVp1aVR0VDZ2Nnl0dzJkYk5wT1pr?=
 =?utf-8?B?d25oa2hJYk11dS9FSnloY1dsbzVzcGRFSC9hdzFoV3FOZkxRYXRZaVJ2YVlX?=
 =?utf-8?B?N2V5MkNoTmxWSjEyZzdmUDg4c3IyTmFFZEp5SGhmWjRwU0RlSFpyR0hDd0Er?=
 =?utf-8?B?S1ZpNmRzZE5LbnY3eGxuUHQ2eWxiNWMrK2ZSbkR1c0pPQmJXMmZJK3ZqN1NJ?=
 =?utf-8?B?OXhVZW5XTGVqR2I0TzdyaDlUNnoyT21wRGlYNFNwUUpadElzUHJuTkNVOFhP?=
 =?utf-8?B?bUZkSlZ6NktiWGc2MTFaTUlvMXNuNTV6NGl3a0VJck5PeDB4TlE0WWFXcU9V?=
 =?utf-8?B?K1J0TnVRUzRlRitObzA2UUZGSGxSeEIxWTMzQWljR1dnSHo5M1BFdlVWZzA1?=
 =?utf-8?B?RkE3RFo1dXh5SUdkRm5VNEpzTWRoVzNGRmpzc0thWTRJSXY3TTEwSVd3WldE?=
 =?utf-8?B?NVF0NFZTT1dvbkZ2MVJ0aDY5WURZa0tSc052QllmeHFLdnBoNURGMmxuRjBp?=
 =?utf-8?B?MlJQVG5oY0IrNUNHMDU4b0tuY0FQK2Vobm1mSUdyNWJSTUIzWEJtbHZZcVF0?=
 =?utf-8?B?c29kYWdYSUZ6Y1hkU2JBODUwSGRBb2wxMHB5WjZqcGt4SERUVG9xUVN4WnBM?=
 =?utf-8?B?aHJuVWw4Z0VUK2NKSVBQZkQvbHRWOVFqUlcwNXhSUGFyK2grbjNFYUoyZTNm?=
 =?utf-8?B?bVE4M2xIZUtjM0d6OVpuNmVzZ3ZvcmpVenNsaGxSQ3NRUFdSaUMzQ1N4STBr?=
 =?utf-8?B?YUtvZjhCSW4zamdsL054N0dGdGJTOVkwd00xUWR2d3BQd0JiU0srWUJxTU1W?=
 =?utf-8?B?ZkgrUXZUZXhPdnprVG1mM21zd3lPRC9kNmVzOTRmY1dIakU5a2xCTm00eVJm?=
 =?utf-8?B?NUxxRXh0YUMzQXkrNWI4VnZmdjR1QXJ6Uml4NDkvb3lMZG5iZ2dXSVAwRGN1?=
 =?utf-8?B?d0VMTlNuUkRwa20zcUFGcWptbWVPQzdrZHU3V2RSWE8vWWh1ZkZoK0xaUGhX?=
 =?utf-8?B?cE1od2tpdTM2MVU5aFBSa0N0SXRNUTdUcmN1c0lmRHZLUUhXOGxXWFVEWm5I?=
 =?utf-8?B?VUFOUXVud2YvRGNoZjdqUDVXbVNhTGMrUzB1VEJwcjNqOTFTVUVXWTE1MTRP?=
 =?utf-8?B?MDR3OFowbFB5N0x1eHJoaGxnVGlRVktvblBOQlBtVElrdGJmVHBUUmJEeWx1?=
 =?utf-8?B?anR6R2hYUTlOZjg2VVZjVHNKVWovL2ZNMndWNDlWYktmd0hOd0ZHdVp2T0xP?=
 =?utf-8?B?dHZ1bnhwR0liYXppT1FpTzh2U2NFeUJEcVFUQnlYWFY3MmtMYkpoTENRd2Rz?=
 =?utf-8?B?TUdySXJIQTU0YmpWVUp6Q25nMkhra0hGSG9FVXBKMWt4akl6NXg0WkVvK0RU?=
 =?utf-8?B?WkhxcHl0VDdmWkFlQlJiNlRTRTBZUXlyUU9yRU1GbGZmb3l6Tk1Vb2FKOGlT?=
 =?utf-8?B?dWVUL3paVWxwanZwSThGZFM4b3IxaE1NRFBqY0dPcklYd21OOHgxdkp3VndJ?=
 =?utf-8?B?VUZ2YUdFb1lUSnpRTGM4TUE4SDJyT0hRWG93YWhEYTBhRDlYOGNvMnRhbUNa?=
 =?utf-8?B?dU0wcC84aVQrcC9SOHFiZ1R1Vlp1YVVaSSs3dnRQeS9DM2Zpd0hOdGxzdkk4?=
 =?utf-8?B?YUR4UEtEMkJhVk9XeEg5bDdFN0VUdHhOQnpzaW5sQlBJU2hZM3R5aUpFbnFW?=
 =?utf-8?B?cmZTeGpyQzUxUUhKcHhWT3d2V21ibmpKWDVUbmsvS04vS3Z4M0VJUkUzOEcr?=
 =?utf-8?B?bVczOC9GbUxkWStUdFNWMEI4Ris4YTVjMnBYemR2ZzloU0VlQ1QrS0EwUS9Y?=
 =?utf-8?B?MVE9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3547a517-c27e-4c43-a0a0-08db08816e5e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 20:33:40.1368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5cye8bTLlbcXxB6fA7wUHlzk9OLchBCu1g1jpkg7B+hFmEgclAPWtuEQiim2Yp7UnFRFTWh/GtG0SQ28OQPgKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 10:41:47PM +0300, Arınç ÜNAL wrote:
> One last thing. Specific to MT7530 switch in MT7621 SoC, if port@5 is the
> only CPU port defined on the devicetree, frames sent from DSA master appears
> malformed on the user port. Packet capture on computer connected to the user
> port is attached.
> 
> The ARP frames on the pcapng file are received on the DSA master, I captured
> them with tcpdump, and put it in the attachments. Then I start pinging from
> the DSA master and the malformed frames appear on the pcapng file.
> 
> It'd be great if you could take a look this final issue.

What phy-mode does port@5 use when it doesn't work? What about the DSA master?
