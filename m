Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1A868C7DC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBFUmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBFUmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:42:37 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0969B3AA3;
        Mon,  6 Feb 2023 12:42:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRYS7kMwaG+GQfkxuKjeiVgy5nvmo9quILsqM1eiLgHE4ATCtoKS1kY8ofNXxyCS/Iji96Z4jV21nEeERJPTwViZXF9onhjZzqlS26KiJ255lrdHfn554ZGuDMhEzlBGNhxxHuUydiX0RWEQ5hKoOHQpWqYc5p738ed+FCVRHVkl6WMqKIwcau3pJOJsJcw83w7rQi/utrYDL4nptZ7XCVpjmle8Q9UL/7NLmsCrGDUXMQkBT1jky6Nscx1vnCUQoJPTE8VFxa/IBHUU+4jhkjdpqJOnU/unGWTTd/V3c7FQbARSfKMY8ESbfaig/F2Kmid/+vC9vAqEMkkitUFZLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9joVZm7UgwgYJ1HM23tOhpqYb5UxdPz6bOdKopV5e7k=;
 b=SEDtx99eMGMl3m2Q8o55Yb5OX205Bo/sTAHVLHrydFgR7oWp1WHfdkPGXll2+V+FJsUiY07AMKeOkpLwRE0JRHvXpfbVgbJytLAXv++xWofxiTjd6TaAExveJqWTLIGefukaiZc+oAKtAsX3pPxOkmvfq/RBcxwLEJolov41sRsgxkkBX8wJdRYm8o+KqeIcKKKrIBEqa73gpIyZ8be86mJbeIbnoaiAAdwNKL7snmPNGQurjBToYHCIsNBgmyKLvp7xIiHqXkKUpnD6mR5+GjPYnxg5+yLwJbcH+rKTn5LR2AGqHRgp+7c+6scJJrNnX3cKy2T6bLdyhfVyN5Mfnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9joVZm7UgwgYJ1HM23tOhpqYb5UxdPz6bOdKopV5e7k=;
 b=ZA2WaYqKC9ovP3Jbe3kB20roejvwyYtu6vXW/4bF3k9j4sOaQ84xt7tHCwD4Tv9pkqFvnB6FGODL12zHLFwMTosX21Jc0yceWqCTiDW+dfzOd3etCrGnPyXMs2dFyaLkEo6gnGqa5ou+hNLmPuUwGu59k9mLed/MDZTMfTBtdOQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9437.eurprd04.prod.outlook.com (2603:10a6:102:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Mon, 6 Feb
 2023 20:42:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 20:42:33 +0000
Date:   Mon, 6 Feb 2023 22:42:28 +0200
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
Message-ID: <20230206204228.sa45cvco6bltidwq@skbuf>
References: <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
 <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
 <20230206174627.mv4ljr4gtkpr7w55@skbuf>
 <5e474cb7-446c-d44a-47f6-f679ae121335@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
 <20230206203335.6uxfiylftyktut5u@skbuf>
 <4ee5df8d-618b-db78-9c14-17a45e383b67@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ee5df8d-618b-db78-9c14-17a45e383b67@arinc9.com>
X-ClientProxiedBy: AS4P191CA0012.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB9437:EE_
X-MS-Office365-Filtering-Correlation-Id: a3522f80-2881-40e4-bf0b-08db0882ac32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZFI8eUkEc1bTL+Gx+HiwUGJAOhoOD44lnSn1HWTklsCrpHv4qPtq47ImGPMDMAsSpWLSqHYek+G4Lwhx3h/AU+y9NwhU+Aam+eFiW0vpsn77ndPQl0l59eoyC0l9YzYMFVHwaMZuPwFhj1MR3zem5YrZ3+tlJq1zi54rrM8+jtUukez7FWSz+pggt/5Kgk5D86epekfssZQCgT59TTsRBU2aOH1tQP+A2J6Bo4XsiNwsWtsw2lxFUb/IDN8rq0SrEImG1U9sEvSezP34/nzoC8+3m7CCE77tPzNTTE/EX0xTzwGLU7p0NaoOV9+rkBLi2gE2auc/o9AQa13CKsk+l3LylK3THthEN/ZzuyvKFnaJ6q3rmaB5jfppqkf81zMAmRBcTVdzhDpMRMeASXiIAPBW7GBvYfeI9BKeMlChLTU613QL2WjPdWaoZ/m9CfRXTXRC3kpeZq06rioqblrPkM4y6lc6Yg0xjq6AB/6Ii+/dRgkXeZrqkM7Gsh3Csg54Nlz8US89Bckn27RUaHxni1vyMwecA8oEYGTpFgfNSugsxHauPh/qOmvclK+0rSl/A6r20/y4veL5x+Aqu7fAa52dbQTv3UF2L6/6MyYn/Qz7G5P5Lw3uRnRbm8xRkwij3f0DkJXllHqxFfeKUWsiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199018)(1076003)(66476007)(66556008)(316002)(54906003)(66946007)(9686003)(41300700001)(6916009)(7416002)(33716001)(2906002)(86362001)(8676002)(38100700002)(26005)(53546011)(478600001)(6512007)(4326008)(186003)(44832011)(83380400001)(5660300002)(8936002)(6506007)(6666004)(66574015)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkM2RVBjNDNmbENGaVdUZW5IQkR4U0JtNjlpei9OYVNEb3RQbEZCdlVEMU5U?=
 =?utf-8?B?VzRldm1vWDhCNGF5cWxDRUx2Um1vSysvL0JYdTlXUklnaC9vREhadVFBZlBT?=
 =?utf-8?B?d0dQNWR0RlNnVi9pV2JBemNJL2M3MGgvTFBiM0p2Y3ZnR2ZqYnRsWnlPZTNX?=
 =?utf-8?B?T3gvOTBJWkN6U0RYS3F1MkJOc2VHNS9ZcXBjblJVbUJEVE5QZkw3cWwyOWFr?=
 =?utf-8?B?c0ZVN1hCSVBzZGwxVjJqZ3VaTVAwZGFjT2szdzVqTlhxVWpvZHBmTlZPVG4z?=
 =?utf-8?B?WmRVZFpScHVNVFpuQTJadWIxclMxNmhHWmQrdnpBTEJwQmFZOW5RUEZQS1VR?=
 =?utf-8?B?ZkZMYlpseFNUZ1NnTlFyd1M3TDgreko3VmJPekJEcEp0dEQwaHUxamNDVFVz?=
 =?utf-8?B?MjJ3S2dFMm0vdi9seVVZdjNrRXhFMlp5UHNzdVlwWmp6L3NRbHB1aTcxa3Jv?=
 =?utf-8?B?TVR1VTJGSTFRck56cXk0RDRwcHZvam9QWXY2UjFsVDd5WVRieVBYSU02alN1?=
 =?utf-8?B?TFI4dUdPL2pWRVErWWxSczVFSlFCbmlmRXhvSmxNNk5yYzNSanRkTXg2UGpn?=
 =?utf-8?B?VjBSMmUzQVZxNC9waWFLMmtSVHFGUS8xWVVRVlphTk1TaUdnciszMncxQ3Uz?=
 =?utf-8?B?ZlhSOCtaYWFxNVZndGxtbncrN3JMZlRSampuNTFMQmxObmtNOGdwNVlSdkNW?=
 =?utf-8?B?L21HL2pPbDBTclN5elJXaDJaaWkwcWJjdmY4Q1B6MUoxZkFuZWtuSllRR3kw?=
 =?utf-8?B?TUcxNFpuMGFuYU1VU2RKVmFyaVAybXl4WUM5bi85bXg0UnRLU0tLTytpMG4y?=
 =?utf-8?B?WURYVnRMMWVJYUxQNC82K1ErUHhESzRSdmRKU1MzZUplQ0tDZDVQcm9aZFBw?=
 =?utf-8?B?VFpIbWgvek9MZS9NRGFLMytCV3BXaGptWUJpZU01bnEya203V3ZSVjRpL3BD?=
 =?utf-8?B?NXpyVk5LYWVBU1FGNVBLWnZvRkN5S040b3NvaGNkei9WWERoTFVaZVBNcjVr?=
 =?utf-8?B?d1JhZTN0K21JdE9FTTlXenNBaU02ejNBbmE2L1IzSHE0eTkxQUp3TmF0OFA5?=
 =?utf-8?B?Y1pLMjlvUFVKRU5EQUYrS29mRWxFWjFJNnl1OGtHVHQwNzhCckJWdFFhKy8v?=
 =?utf-8?B?eUk5YVJQQ3Vubk1pbzhDM3MzTzFTTXFENkFuaEhrVWZJellLcjkvTkFWVVhk?=
 =?utf-8?B?V2hoU2kyUzA4NXI3YTk3MHlJQkpQaTVtY0VjcEdqK01IeFlRbDJZcmdhZ2s3?=
 =?utf-8?B?b1FBYVNFdG5mdVVWRnMwaElrK1JSUWFUdE1HSFV1V1JPWnRJbWhqYTg2RHVJ?=
 =?utf-8?B?Mm9VSEk5Vms1ZkI0eW1pMldmckhtOTJVTTVBL3FxU2dCK2VGMEhGdFVDZ3kz?=
 =?utf-8?B?RFZERGRiZTU5TkZNV1NVNWxwUGxBM3NoTmdqU0w5czQ0VGhZWWZYVGJ4eVJp?=
 =?utf-8?B?Unl5ZzBSVUNBR0p1eXRreG9FejdxdGpTWmRhZjlTY3h1dmNNb0RZbG1DODIy?=
 =?utf-8?B?YTYvYnA0VzlQeENhYy9VbThhWjBSRlBCakNRVnlDakl3bzBDOFA1eGo2ekJJ?=
 =?utf-8?B?Tjg5WHRXS3VhS0FIVDArOW5EemdYL2dtd1hwNmJ0MXQwRUZ4b0dxQmJGbWVw?=
 =?utf-8?B?dkNMRVBlanRZczRuZmVKeXBJT2lTT0Vudm54YjRjdkZUZkhJZnFyL0J5a1lH?=
 =?utf-8?B?M2J0bTY4NXpoN1REUFRMVENpRElMWXNjZkw4VTQwcm0rQnpHU1lzWGRmWDA1?=
 =?utf-8?B?ZUdCeWtkSml5QVJqSjhDSEtIUU9PMmczQVhkOU9ReUNBdEZNM2RjQm0rbjNL?=
 =?utf-8?B?TUdJZkRrRmJhTnBWV1orUndtcFI0NzVsWks4QnJVS3llOHdWYSttaWZNdzhP?=
 =?utf-8?B?NW5PMXRoYS9TdnQvNW9xN043OGhZZWR0MzlyeWJGSXdvOU1tSHdBdnhmSkJS?=
 =?utf-8?B?TlpFdngxY2tjMTU5N294RlM3YjNkaFBjWkdxNEpkMllpdys3R3ZZWjdnL3dk?=
 =?utf-8?B?OGtmT1hjemFxcGFKb3ptYTkrZS9jQkdiOU5GamhuUHdpOG9PUHBmQzlxZGtP?=
 =?utf-8?B?ZVdvbVpYc1R3QVo0MHhIMnd5Q0twdkloenRuSk9tL2VqeEhCNTZTa0crNjVq?=
 =?utf-8?B?cEdubUNNaUN3dk5kNXhhWHVxYXFzY2ozUU5oakZPQjd5dkJ4NHdJMjhhWmFP?=
 =?utf-8?B?bXc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3522f80-2881-40e4-bf0b-08db0882ac32
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 20:42:33.3334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6iFOw9dihZ7eaUJW2UhV2x7qsOyFgVx5ZxRjipOOP0OSzUm/pRIn8RoTMQB/j9rCNcceQ/yptDJTAoHNy3rhkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9437
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 11:35:50PM +0300, Arınç ÜNAL wrote:
> On 06/02/2023 23:33, Vladimir Oltean wrote:
> > On Mon, Feb 06, 2023 at 10:41:47PM +0300, Arınç ÜNAL wrote:
> > > One last thing. Specific to MT7530 switch in MT7621 SoC, if port@5 is the
> > > only CPU port defined on the devicetree, frames sent from DSA master appears
> > > malformed on the user port. Packet capture on computer connected to the user
> > > port is attached.
> > > 
> > > The ARP frames on the pcapng file are received on the DSA master, I captured
> > > them with tcpdump, and put it in the attachments. Then I start pinging from
> > > the DSA master and the malformed frames appear on the pcapng file.
> > > 
> > > It'd be great if you could take a look this final issue.
> > 
> > What phy-mode does port@5 use when it doesn't work? What about the DSA master?
> 
> It's rgmii on port@5 and gmac1.

What kind of RGMII? Plain "rgmii" on both ends, with no internal delays?
With RGMII, somebody must add a skew to the clock signal relative to the
data signals, so that setup/hold times at the other end are not violated.
Either the transmitter or the receiver can add RGMII delays in each
direction of communication, but someone must do it, and no more than one
entity should do it.

So my question would be: could you retry after replacing phy-mode = "rgmii"
with phy-mode = "rgmii-id" on port@5? And if that doesn't change anything
(unlikely but possible), also try "rgmii-txid" and "rgmii-rxid" in port@5?
Don't change the phy-mode on gmac1.
