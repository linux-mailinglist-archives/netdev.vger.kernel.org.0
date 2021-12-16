Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BD4477B85
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 19:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbhLPS3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 13:29:31 -0500
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:9213
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231582AbhLPS32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 13:29:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlHHgcfZsgRDu3n5MnK/LbNM4q+UuHY/6V7wrZMgVynaE/ivuNfnfsoUIylD+KzOfSRjP7w+Y/enoV2y6m77ogGLyyNXuaW+PzESfxKyNyN9dijXkwO1MxW0FIoD1xZYBuXvwFbhL5PkMwiIEppVazR6z1NJWteDk5Idjm3KVdUphZV4BoVVdmc7XBsNtcr7tH31ofeUcIpJLh8u8DzkuyL1Txw+8kA9IR6jvhnKa+n34L3oZI8ww9CLtXuySTglXo5uZqpGiFmW9F2UAwj+RggB6i7EzfRh0kj+/Mfp/SPWWN/qTSq1VH4vqylTDZMqHay76bkm1UhDs3KNOU45eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEhcHKgbopkoWn+R3PIl4DZVKuvlAIJYW0qKescMOWk=;
 b=eSu7FljoSUotRE88V1DwjLyoMcfHoznt61FoTz8pblQ6qigQ/Pxq7XqmhhROLsxO85Kjf7Dh3ZyJH1Ul6MxE9w7p0rvaDgQVHZv60QKFNH+A9m/0vAxpmywAccqr1U1CR/dGaUSD4hRwC9BQcB37dbdWzvjoylQqNozqpwcZwvASHXj2zk6NT8AvceaKngfLEFcoYEQH8Evg9KX7HVW4YFyWF7KG+nfbwnmnrVy0JKO00xLIlObAhVuTwJCjuiG0K/ZZKRDohD1vBaX0pDNmCwnj+sxLMMyY9QbzkdCIoQe3iavU/i5I3u5vCMwOJWHC2U/gTgOlSoNgGiyYPPTh6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEhcHKgbopkoWn+R3PIl4DZVKuvlAIJYW0qKescMOWk=;
 b=2UTDjwawJHCI6UIpY6yHSIFV/Oh70vbOiq9ksmuDyBcqV4g+SAx3V0/LuZ+MojMEUJI52/s8842qWcJK8jNkxlJAfvRc98Bx2gQYi4AZcpuE4RyLkCcCq6gUla9BUoPw5Q3/TvAXnfJzS0hC8dAjEbEIuPQZ+Y4sg/pqYbRliRY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 18:29:25 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 18:29:24 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH] net: phylink: Pass state to pcs_config
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20211214233450.1488736-1-sean.anderson@seco.com>
 <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
 <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
 <Ybk7iuxdin69MjTo@shell.armlinux.org.uk>
 <YblA4E/InIAa0U1U@shell.armlinux.org.uk>
 <1a9de385-1eb9-510b-25f5-d970adfb124b@seco.com>
 <Ybt2syzCpjVDGQy7@shell.armlinux.org.uk>
 <9ce793d7-8361-be07-e6b9-1ecc4e3ff8e5@seco.com>
 <Ybt/9Kc+XJYYecQF@shell.armlinux.org.uk>
Message-ID: <26875713-a024-b848-24fb-bbd772446f49@seco.com>
Date:   Thu, 16 Dec 2021 13:29:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Ybt/9Kc+XJYYecQF@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:208:236::27) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16b1c155-e6a6-49a0-c2f5-08d9c0c1fc5e
X-MS-TrafficTypeDiagnostic: DB7PR03MB4523:EE_
X-Microsoft-Antispam-PRVS: <DB7PR03MB4523EF7C4734C0D1804CC55496779@DB7PR03MB4523.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hO3QZ2P7Wb8AgKp+7d4bgDULGAHkho1NXL6mXBAF3djwcE4rdkhciYAvfqBu2p7j6rp6eBNGaTH5oqlsTW/zYs5ng2hLemMxUE9C22JM16HNyenycNM4WL0MmaimM1IsE0kWDQhslXQpYnjnaWjuGttSWSSLZNvFgWfDQziuliP3zzvaqq9gH3lUbs4GYQFkK70k0UyXeX+CXeq/DluYK0mTY1vHNumf1OP7FEUq9BMmUWnPLxsGuZW4AgHvVyaNyyRLbJ2uUlNdldxsBrN7AkaEJBJEVbf/dSDr2egeFIr0eSRLXiuPk1bs3XLIB8tPIIL57sshxxlFFPaHPWoAZiKiBMG4d2vHmgdIMgLyafLNDtdMXxmDuxu4u1v03IsXoxHCrYSIBVZmMtKz9LNHXrMZUdobQcmRXDlyBjSFinx1T2gwaAL5Tvh99Hx4ImK1cOW1mcn6NhgsA2B7gp6x4vQnXNUZsj1//jQglvqD7FevP+v6EvazTGk1qQq1d17CYtDWXRzfgaa8amyAbhclKNJCZDjmAH0dzxp7Nk7zXrnlYJqR7ZAfyGTO2SrWJ2uv4sXWI6KmOKvso3MnB5EDlnn8IzYA0N8TW+J/8Ec3+xUhuGRS9a/V2sJaOxT9hzlG9wdpmXm7QEE5GiJcoRMVlPTu7uc+q/exinNgDx/zV6ldoq27a1OfDJW8Qq1QNgOjhR6dDMSe0TLcYw4JVXUq3CEtclfidhV8VrC5OPGLcmTdgwEQ75X6S0mjBO1jxzAgHdSewoJy2Tsbr0rnBsQr1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(4326008)(316002)(66946007)(31696002)(66476007)(6512007)(186003)(2616005)(38100700002)(5660300002)(6666004)(83380400001)(6916009)(6506007)(26005)(8676002)(44832011)(52116002)(38350700002)(54906003)(86362001)(508600001)(7416002)(8936002)(2906002)(31686004)(53546011)(66556008)(6486002)(30864003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWV1a210MjNKV0xHWDluRTNJSnkvTzRaZXhaNCt0Tkg5Uk5PYVMyM1FqbGF4?=
 =?utf-8?B?Tnl2eHhNajFMb3ZmOVNSVXRNMVNSR1JJRGNVUVR4K0JuZnY5MDgwYUZ3NWcz?=
 =?utf-8?B?WHJiTi9nQkN4TXJLM29WVzR5Z1lrU2dqaTVPK2g3a0dFSGdxUnd5M2w5bkVY?=
 =?utf-8?B?VHZEUFZzRmVERU9UZ2ZWWUIvUE8vUjRsZFhxOThFNXZEWmgyV1huajMzNTM5?=
 =?utf-8?B?SEhsam5heU4xd1BNVGpkQ0M1ZklreThFcXowK3BxeU5mODF2ZXVMMVQzR2cv?=
 =?utf-8?B?ZXNGT0RhYnk0SGxya0VqclBkSStvQ3k4OUwvNGNsU2RhSTkxY01EU3hyY0do?=
 =?utf-8?B?RlFENy8rQjROcE1UU1NNQ3VOQ3lOMi9JM3JaUTZsV0Y0VXZTQlNNWVBhN3lF?=
 =?utf-8?B?QkI1YXFYV1QwcTYwMHRWcFpnWWQ1dksyWW1DSXRqRGdDYzRxTm1HTzlkRDU1?=
 =?utf-8?B?a2Fudk1EK3FSUU00UTRlZ2J1N0lKUk43NEgxUXJOM1NDNlBBbDJwajNrYk5r?=
 =?utf-8?B?K2Qzb081WnpXSEgwY0MyVWRnZE0vcGFpbmJHb2EzRGxCZDREaEJKMTcramx3?=
 =?utf-8?B?TlFBWjBMUlZ0OHNVRHZrcWxYNjBnMGhiYTFpczIyMzg4aUMwdk1ucFM2OUhN?=
 =?utf-8?B?bnBsWFJFTmZFam44QXJoN29tVlVPOS94MG5hUWRQbWNpMEF5dXVzVzVpanc5?=
 =?utf-8?B?YUVwbmRSQlZidTFiSldUdFp3SEx3TStwaS9MQXBwYlVNdVZSd0IyejR2N3NX?=
 =?utf-8?B?cHE2aGV5aGpxMnlrZ1Z2VTRZR3dISlJiQ1ByeXYvMVpiUEo2cHF6VXFVODhu?=
 =?utf-8?B?Z29FZmZvcHBHNnp5OXZjUFlYY3VyajQrdi90YXRRWWJHNnpHaUpRTXJuN1RV?=
 =?utf-8?B?dUo0MmliUVNaWGpseDdwUzhlZExxaTMyL3I0T0xtN0p4bVNJRXZMV0t6QUlF?=
 =?utf-8?B?WWdPUUduYzlHRy9Qd1VvR0d6dnFKajd3Y3c1UDRYYU54eDllSTZRbXFHODh2?=
 =?utf-8?B?d1ZGQmEyeEZHdTJ4bURuN3h0Tit2S2dnUDZ1bW9vTmRTdkphSVgvOTloK21J?=
 =?utf-8?B?SzVqbzUxemptWVdzRXVnTEpMVDFTaFBIcWkvWWVYZ2c3SHlueVNPUU1aT1JQ?=
 =?utf-8?B?VW16R0plOHMvWXZtSW9aMUxNempYeml2L2E3NkowSWFFeERSd3FDNkVFNmhj?=
 =?utf-8?B?UnhwdWo5dVlaT0F1c3lKUHZnYmtFZkJrMVpDVVZmcDNTVUhtSWFzS1lvc3Jo?=
 =?utf-8?B?T3ZKMUZqY2wrV3dvY1BsY2JJSHp3SXVwaWs1cnVpczBuR01na1JwTW15c2dG?=
 =?utf-8?B?cjM3ai9QdUlMZGdSWGhPckx0aXN5YnoxTzRXVmVwY3JqZldKSFpiT3p5b3hn?=
 =?utf-8?B?MENmTWlTVld0a0Y5c0ZuWkhiQys0UUVNSzFoTGRPQm0yamNTS2UrT0dtandi?=
 =?utf-8?B?NkVuRmorZXV6ZzlMd3VtaXdDcmlRSFIxeUpibjJPeG9KcTdtaWRHZ3JIUkdE?=
 =?utf-8?B?NDZMVy92WjRweDNCZjEyZU5rYVFYd2QvK0lSbldDQUNyNXVtdnlFOTJVa1Rt?=
 =?utf-8?B?VjdPVjY5VTRYRkUrMzZEaHZoTXNkZFdSc3Bub3hZSVRWU3J1QVR5dnJZUDRy?=
 =?utf-8?B?TS9Pb0p6MWhOSWt1WGszSU9lelJOUVRIZkZIMGVLd2pXTWg4ODBoU0E1aDFT?=
 =?utf-8?B?UHQ4dnRtUDYrRERxOTdZdEJyQlptRXkxUm0xd2lLb0hQRi91dVRCbkI0Sy9H?=
 =?utf-8?B?TEZUUjFGSCtmdjdoOHNRMHdsRWFOUVZ0dnJWKzR1YVMwbVhBZm14czF0MEUx?=
 =?utf-8?B?dnRBOTN4Q2lnMzVKT1UwZ3FvMk51Z3hRQzVxZkVJV2VrK0d3ajNDUEtUTENS?=
 =?utf-8?B?L2Zjb3VoeGRXWWtNWHF5ZlNZWXdxR0N3dFo0d2JOL3RDRmpjZlNmSktiWDlo?=
 =?utf-8?B?emM5a3grR3c3UjRyUGlzWUQ2NzMwSExWbXRoLzF3a1ZYNjlCTG5TaTA1eXdP?=
 =?utf-8?B?dndkN1IyY3RJd1NQSkF0SUdLSmJReXJydVhqT1pKbjVJMFNjRWdTUXA5R1JL?=
 =?utf-8?B?ZnpGdGM4WWxoa2hPR3JOM0dyR2tBT0tpZkNSQ0hxUGxjSjVSTkt6Qjk0anZa?=
 =?utf-8?B?eVFDNGtDdUhTdE9SZ2t2eElHTHdCNUdSK2NBV1dCM0ZXM2ovVDQrektTejEr?=
 =?utf-8?Q?KiCx5yepUumU8uVRwOfnzFA=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b1c155-e6a6-49a0-c2f5-08d9c0c1fc5e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 18:29:24.7024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26yandVyOnvOj/1ShR++lyKYhvyczNPcQ/rGOvMvASIc5TTNvw0UZI+JfMbRs1eug5sb6Kr1EgbBCBVy03j0fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4523
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/21 1:05 PM, Russell King (Oracle) wrote:
> On Thu, Dec 16, 2021 at 12:51:33PM -0500, Sean Anderson wrote:
>> On 12/16/21 12:26 PM, Russell King (Oracle) wrote:
>> > On Thu, Dec 16, 2021 at 12:02:55PM -0500, Sean Anderson wrote:
>> > > On 12/14/21 8:12 PM, Russell King (Oracle) wrote:
>> > > > On Wed, Dec 15, 2021 at 12:49:14AM +0000, Russell King (Oracle) wrote:
>> > > > > On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
>> > > > > > Ok, so let me clarify my understanding. Perhaps this can be eliminated
>> > > > > > through a different approach.
>> > > > > >
>> > > > > > When I read the datasheet for mvneta (which hopefully has the same
>> > > > > > logic here, since I could not find a datasheet for an mvpp2 device), I
>> > > > > > noticed that the Pause_Adv bit said
>> > > > > >
>> > > > > > > It is valid only if flow control mode is defined by Auto-Negotiation
>> > > > > > > (as defined by the <AnFcEn> bit).
>> > > > > >
>> > > > > > Which I interpreted to mean that if AnFcEn was clear, then no flow
>> > > > > > control was advertised. But perhaps it instead means that the logic is
>> > > > > > something like
>> > > > > >
>> > > > > > if (AnFcEn)
>> > > > > > 	Config_Reg.PAUSE = Pause_Adv;
>> > > > > > else
>> > > > > > 	Config_Reg.PAUSE = SetFcEn;
>> > > > > >
>> > > > > > which would mean that we can just clear AnFcEn in link_up if the
>> > > > > > autonegotiated pause settings are different from the configured pause
>> > > > > > settings.
>> > > > >
>> > > > > Having actually played with this hardware quite a bit and observed what
>> > > > > it sends, what it implements for advertising is:
>> > > > >
>> > > > > 	Config_Reg.PAUSE = Pause_Adv;
>> > >
>> > > So the above note from the datasheet about Pause_Adv not being valid is
>> > > incorrect?
>> > >
>> > > > > Config_Reg gets sent over the 1000BASE-X link to the link partner, and
>> > > > > we receive Remote_Reg from the link partner.
>> > > > >
>> > > > > Then, the hardware implements:
>> > > > >
>> > > > > 	if (AnFcEn)
>> > > > > 		MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
>> > > > > 	else
>> > > > > 		MAC_PAUSE = SetFcEn;
>> > > > >
>> > > > > In otherwords, AnFcEn controls whether the result of autonegotiation
>> > > > > or the value of SetFcEn controls whether the MAC enables symmetric
>> > > > > pause mode.
>> > > >
>> > > > I should also note that in the Port Status register,
>> > > >
>> > > > 	TxFcEn = RxFcEn = MAC_PAUSE;
>> > > >
>> > > > So, the status register bits follow SetFcEn when AnFcEn is disabled.
>> > > >
>> > > > However, these bits are the only way to report the result of the
>> > > > negotiation, which is why we use them to report back whether flow
>> > > > control was enabled in mvneta_pcs_get_state(). These bits will be
>> > > > ignored by phylink when ethtool -A has disabled pause negotiation,
>> > > > and in that situation there is no way as I said to be able to read
>> > > > the negotiation result.
>> > >
>> > > Ok, how about
>> > >
>> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> > > index b1cce4425296..9b41d8ee71fb 100644
>> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> > > @@ -6226,8 +6226,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>> > >                          * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
>> > >                          * manually controls the GMAC pause modes.
>> > >                          */
>> > > -                       if (permit_pause_to_mac)
>> > > -                               val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
>> > > +                       val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
>> > >
>> > >                         /* Configure advertisement bits */
>> > >                         mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
>> > > @@ -6525,6 +6524,9 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>> > >                 }
>> > >         } else {
>> > >                 if (!phylink_autoneg_inband(mode)) {
>> > > +                       bool cur_tx_pause, cur_rx_pause;
>> > > +                       u32 status0 = readl(port->base + MVPP2_GMAC_STATUS0);
>> > > +
>> > >                         val = MVPP2_GMAC_FORCE_LINK_PASS;
>> > >
>> > >                         if (speed == SPEED_1000 || speed == SPEED_2500)
>> > > @@ -6535,11 +6537,18 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>> > >                         if (duplex == DUPLEX_FULL)
>> > >                                 val |= MVPP2_GMAC_CONFIG_FULL_DUPLEX;
>> > >
>> > > +                       cur_tx_pause = status0 & MVPP2_GMAC_STATUS0_TX_PAUSE;
>> > > +                       cur_rx_pause = status0 & MVPP2_GMAC_STATUS0_RX_PAUSE;
>> >
>> > I think you haven't understood everything I've said. These status bits
>> > report what the MAC is doing. They do not reflect what was negotiated
>> > _unless_ MVPP2_GMAC_FLOW_CTRL_AUTONEG was set.
>> >
>> > So, if we clear MVPP2_GMAC_FLOW_CTRL_AUTONEG, these bits will follow
>> > MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN and MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN.
>> >
>> > Let's say we apply this patch. tx/rx pause are negotiated and enabled.
>> > So cur_tx_pause and cur_rx_pause are both true.
>> >
>> > We change the pause settings, forcing tx pause only. This causes
>> > pcs_config to be called which sets MVPP2_GMAC_FLOW_CTRL_AUTONEG, and
>> > then link_up gets called with the differing settings. We clear
>> > MVPP2_GMAC_FLOW_CTRL_AUTONEG and force the pause settings. We now
>> > have the status register containing MVPP2_GMAC_STATUS0_TX_PAUSE set
>> > but MVPP2_GMAC_STATUS0_RX_PAUSE clear.
>> >
>> > The link goes down e.g. because the remote end has changed and comes
>> > back. We read the status register and see MVPP2_GMAC_STATUS0_TX_PAUSE
>> > is set and MVPP2_GMAC_STATUS0_RX_PAUSE is still clear. tx_pause is
>> > true and rx_pause is false. These agree with the settings, so we
>> > then set MVPP2_GMAC_FLOW_CTRL_AUTONEG.
>> >
>> > If the link goes down and up again, then this cycle repeats - the
>> > status register will now have both MVPP2_GMAC_STATUS0_TX_PAUSE and
>> > MVPP2_GMAC_STATUS0_RX_PAUSE set, so we clear
>> > MVPP2_GMAC_FLOW_CTRL_AUTONEG. If the link goes down/up again, we flip
>> > back to re-enabling MVPP2_GMAC_FLOW_CTRL_AUTONEG.
>>
>> The toggling is not really a problem, since we always correct the pause
>> mode as soon as we notice.
>
> When do we "notice" ? We don't regularly poll on these platforms, we
> rely on interrupts.

When the link comes back up again.

>> The real issue would be if we don't notice
>> because the link went down and back up in between calls to
>> phylink_resolve.
>
> Err no. If the link goes down and back up, one of the things the code
> is structured to ensure is that phylink_resolve gets called, _and_ that
> we will see a link-down-link-up.

Great. Then the above will work fine. Because we always set the pause
mode in mac_link_up, it's OK to have the pause be incorrect in the time
between when it comes up and when mac_link_up is called. The result of
the pause from get_state will not be what was negotiated, but that is OK
because we discard it anyway.

> The only time that isn't guaranteed is when using a polled driver where
> the link state does not latched-fail (or where the hardware does
> latch-fail but someone has decided "let's double-read the status
> register to get the current state".)

I wasn't aware of whether this platform used interrupts or polling.

>> That could be fixed by verifying that the result of
>> pcs_get_state matches what was configured.
>
> So we need to introduce mvneta and mvpp2 specific code into phylink to
> do that, because for everything else, what we get from pcs_get_state
> is the _resolved_ information.
>
>> But perhaps the solution is to move this parameter to mac_link_up. That
>> would eliminate this toggling. And this parameter really is about the
>> MAC in the first case.
>
> Maybe, but we still have this parameter.

I think it would be much better if it was in mac_link_up and not in
pcs_ops, because fundamentally it is configuration for the MAC and not
the PCS.

>> > I don't like having it either, but I've thought about it for a long
>> > time and haven't found any other acceptable solution.
>> >
>> > To me, the parameter name describes _exactly_ what it's about. It's
>> > about the PCS being permitted to forward the pause status to the MAC.
>> > Hence "permit" "pause" "to" "mac" and the PCS context comes from the
>> > fact that this is a PCS function. I really don't see what could be
>> > clearer about the name... and I get the impression this is a bit of
>> > a storm in a tea cup.
>>
>> Well first off, the PCS typically has no ability to delegate/permit
>> anything to the MAC. So it is already unclear what the verb is.
>
> In the classical model of ethernet that is completely true - there is
> no coupling that communicates the link parameters between the PCS and
> MAC. mvpp2 and mvneta annoyingly do not implement the classical model
> though.

Right. But the default perspective for any implementer reading through
the documentation will be of the classical model. So even if this
parameter is intended for use with a marvell model, it needs to be
framed in this classical model so that implementers can understand it.

>> Next,
>> since this is pcs_config, one would think this has something to do with
>> pause advertisement. But in fact it has nothing to do with it. In fact,
>> this parameter only has an effect once mac_link_up comes around. I
>> suggest something like use_autonegotiated_pause. This makes it clear
>> that this is about the result of autonegotation.
>
> I could be devils advocate here and claim that
> "use_autonegotiated_pause" is meaningless to a MAC because in the
> classical model, the MAC doesn't have any way to know what the
> negotiated pause was. So where does this "pause" come from.
>
> So it's just the same problem, doesn't solve anything, and we just have
> a different opinion on naming and where something should be.

I think my primary issue with the name is that it is named after its
purpose in the marvell hardware, and not after the user setting. That
is, we have something like

	if (pause_autonegotiation_enabled())
		permit_pause_to_mac()

So the generic interface should be named after the condition and not
the body.

If this parameter got moved to mac_link_up, I think the following would
be good:

@autonegotiated_pause: This indicates whether the pause settings are a
result of autonegotiation or whether they were manually configured. Some
MACs are tightly coupled to their PCSs and have a hardware
implementation of linkmode_resolve_pause() which sets their pause mode
based on the autonegotiated pause mode. For these MACs, disabling this
hardware implementation may inhibit their ability to determine the
autonegotiated pause mode, so it should only be disabled when the pause
mode was manually set. MACs which do not have this feature/limitation
should ignore this parameter.

--Sean
