Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0C34779F1
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbhLPRDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:03:09 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:7315
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239925AbhLPRDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 12:03:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+Rt7WCyPEhPpU04QXY2fkqUlaZCtZs0Czz4dq8PCwNyn0wY3wveTV7DrkKY+0sH6N3gHW8GnKz8C4HJ+jIsymrk8jXBHLqsSm+M9clkrCKC/q1JUAPZfQHYA8epvYGpJcixJywNEtRfqYpXPjB5heXW7VCDiQR5I4ub4rqbZ6Vdhp7lIVjoJb6T1HxqHmAi/ZnhWQKyR26eB15s7m61SbHCE5WSLIKLRMVMuTV0lx9pCROP+za5CuUrvdM3grduph4FNlSmz8yWJSsfbDHgNxerljdP1zGoiUWJNgQPiGOK5jOXZtLivqBPrVXKybXYGK5CkVEuhpuMqhK6uEcbzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wKXn33dI8/EJUztqgzQAUKCVQykKNN+FjSBv1riCwQ=;
 b=hDpz1uFchSb/hfvfQ+v9LnjYFogvZWyqBU//kiT7vN8KRAl2a4BEaA+NDf6FWOMpxNArdSGJL4uKAwf20+UKNdzWZ4XgWA6x8wLrjLvGQnDRwVpeujCQdav8keDgEdk2qfNZ08WFmBV9J9WNdI8G24MVh7h1Yqj7K36Exa9oFtq6Zxb9JJgeDLlLw0RO4rJihIk81kqQg4VLC1r+guPBqN7MLKxnvTeaeJvBrVVYniPwYhlaTA43+TI/3hpuC6mPQlsiCScafDgIVz+E7cXjx4lJg8sjTmbbQuTZhdNN3TRqJXcBntkXVP6nqd1xiWsUonvn2r6If4g9RZLtN/rWTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wKXn33dI8/EJUztqgzQAUKCVQykKNN+FjSBv1riCwQ=;
 b=f1Z/uqGRsv8fDJ/6aFthCfVjnxOPOhnkFlVGYUmGq+5NXnjOS10TQMuj6Bvl31bEfLt3kJqfKovCIUYqd2rmIzjhiqLSSJXjvp6ESqBcH6nIosR80vcUs9BoREhebaVNunypwl/lbwRRBdkCROORYBDuU304VQwOXfELdaPY3Y0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0302MB2631.eurprd03.prod.outlook.com (2603:10a6:4:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 17:03:01 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 17:03:01 +0000
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
Message-ID: <1a9de385-1eb9-510b-25f5-d970adfb124b@seco.com>
Date:   Thu, 16 Dec 2021 12:02:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YblA4E/InIAa0U1U@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::39) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ac3eb23-c16b-4c75-562e-08d9c0b5ea67
X-MS-TrafficTypeDiagnostic: DB6PR0302MB2631:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0302MB2631F7F5BA25CB8E70395B5E96779@DB6PR0302MB2631.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0H9ZtpIoMHXls9eg30CVNLhCSFXnyf/6PSNRDpt2arp+0A3+vBx8Ez75HzjELdkm5lQ6wY6hhEaRBo/2QtA5QugrqCRgUOI9oEtdnqwVHeJog2z1WtT2zIdWXUcZtyhnjFwv+qB5FrOEjb7gr7xOWWwTPPwPCNF8Yz8UyAUeNIIGuy95EdM9QkCMHw2Hzew6pdthr4+7SADQWmvXg3qxLtPMDobI01/Xdr9sHt7msN40AHijLob6YqLPoOwrp72HrfMkscEYo4qfi3lfI7Ojm4hC2b0yiVhw7xCLxwRGNk4DOtz/A+H/aGfrE57Zrrb0blpzGsUqFcccYv107DnLOye6CTrgDvSQqssvfJ4lrYya1MKN3HtY3uy0hbKCWL/oEQ8+JQnLdxzehJVXVKWQJCocuQyNsMclQandU3wpcuK8Ae1X3bwdK+Mjbsb/cbV99hvSD3YEh61QoTI9qj+qqpD6iOJVHG8iieukJYa6Vzo1h1uDHDm9w6nYiiNOXK10DxNvolf4QwTB4L8nU+czXJowuZ7s7Ma9oWZjG958gLczYD0yN/K5tAQVaL3aeFI5Rd5yZVQYDnO7KSjj0YymXG2F/WG0ipROfuD2CDLd3lnH8mffBXfcz3zx4s40TBy54emyNB30n1eGMU6B7lNbysdY/21V6Myw/14soLwRq0GU7+389OfBrjkraONe0+wq6rtF69uL2xi8FfgBuoDg8ucFPGTcYhmB+QXB3DhUGph4KsYEVax9D3fz91VFKgqq1A1v78X86Rvl8dk45snILA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(186003)(38350700002)(6916009)(26005)(2906002)(6486002)(54906003)(66556008)(66946007)(31686004)(66476007)(44832011)(8936002)(52116002)(4326008)(83380400001)(8676002)(6666004)(508600001)(6506007)(316002)(5660300002)(31696002)(7416002)(2616005)(53546011)(36756003)(6512007)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzJkcnA3aUlCNzlNaXgzUm03blBhN1Q2eHFSRnFPcDE1NVZ5RFVIbWplT2Qw?=
 =?utf-8?B?NUtNQTRQdWVKVlEwSGUyQml5K3Z0MEc3RUN5NnMwMCtiZlhPT3lRTTQxWEE0?=
 =?utf-8?B?S3l1b0d0d09wcmJqeUlSaER5WGpYc2JsOHZTbGZOVE4yNGJ6U3h4R3R3VTA0?=
 =?utf-8?B?SnI5cjlSZnJ3cDRFT0Z3WmRkRUIzM2JJaEFJRG5qNVZISjd1Si9PQkxydll2?=
 =?utf-8?B?S21QeElnSElxY0UyRHF1T0Izd05kYlJXYzRkbTFJdU12Q0ZUUlEzdFh5TWVH?=
 =?utf-8?B?LzArbUNhSkxkMTNUTnhjSmtPRmxpd1dpbEQ5SGs4UlFtWnp6anhkS3V4bTJI?=
 =?utf-8?B?M0ROQlc4L2pGR0wyQzNFbUxXYWU4VnFaWjU1TTdYWEhUT0pZOU9GalNaNkc1?=
 =?utf-8?B?RGRoOXRVOFFlRFlEYW5VOUVpemFYdWZwbzlpR1ZRYm1KZ2JhL2RmUUlHcU1h?=
 =?utf-8?B?Ync2MlVkalJKYXM2czZQVTNmZE9pQTg1RnZJNmZnemVsUDZQY3JYeGpHQWxx?=
 =?utf-8?B?ZEdEdkc5U1pmN1FvaFF2dFJxWklrdkh5Z0FyT0Y1TG1udjF3U2ZYZjgxSWZv?=
 =?utf-8?B?WG5wY2VyY0VxbnR6T0xvU056c3I0YU9nVitNTHFTbkVUeTVCVWMydFcwQmlL?=
 =?utf-8?B?RnVyV051UUJ5ZHNDVFMxNUhiNktVNXVLQk9hK2l0Q05uTnhlWjROK3pwOVZa?=
 =?utf-8?B?SHIrRVdCVHFob3RRKzcxVEVHaFU3THAwZ1RWbXlGK1JMbFlIbFM4SkF5SUUr?=
 =?utf-8?B?bUtHMnRNQjlzTGgzbU5IQUVsV1Y0anZYY0srd1JMUGl6SXBnS0JIc3BCSkIr?=
 =?utf-8?B?SmlkTzJGRVowbGlnVE5Zb3JjcEw1djQxRHh0b3VuYS9WOEFJOEhjbmtHN01N?=
 =?utf-8?B?S2VKYjBhNWIrZ0VhODI2T0YwdzFsYk5TU0JaKzF0YWN2dktDTFhrS0JldTZF?=
 =?utf-8?B?Uk5FYUswMWhaeElTMHNJWDc5TmlMZFVsOVBQTlBoYW92cUltQ21vbFdqOWJi?=
 =?utf-8?B?eFppUmlFSGllT1hRWHBrUkhlMS9IaTg2eWRLUUVpbElSTXZ5NTdvelgvbElV?=
 =?utf-8?B?YVRUUk5lWHN6ZkxpNWhndmNaaGNuUFh2V2loTjR6OEN4T1ZFbHIyck9uTVkw?=
 =?utf-8?B?RmFpQ2ZlREVYcDY0dUcvSmFkYk43UWNyWUVSVkUxUCtMSzdKemY5VHkyeWV1?=
 =?utf-8?B?Nkp0bzdpcHp0THBZWHpsRW5acTlkazM3Zm9YTGU5N0h1aTVVejhSbFZ5R3Yx?=
 =?utf-8?B?YWdHclpHZEQ5Q1RqMzdJSW5ZMDBqbStCRkpKOWdYWVVMMDEzUmNSK3lWSDlD?=
 =?utf-8?B?NWdDWGxMcU9Wb0c1RUs4L1JSaHBpQyt1b3M4K29TeGQ2cWI1eXFEN21Fb05r?=
 =?utf-8?B?SERDdnltWEdITnJrdFN2M3ZxT1owdEZBdEZ5bmhkN1N2bUFKRWZlMUxtdXpF?=
 =?utf-8?B?NjhuM25qVzRNL3RQMnNsSFUxM1VPTncwQStIVlVBMGltVDdaUTNkdXJBVEZU?=
 =?utf-8?B?aWlGWmEzMHNSWEVuVkdQL2dsWmhkc2dwTGtBaXdocWdhYSttdG9uYTdCZisy?=
 =?utf-8?B?K2Q4T1dnRjNQU0FnTWF5SjN2ZGlqZENmSDhRR09qWW9sT0RSbHczVEJXYWo0?=
 =?utf-8?B?N1F3YndNL0REM1JIcVZObEhXWVUrbzI3SDRHRmFvTGpUeWpOQk9MWkxhbytV?=
 =?utf-8?B?M3ludjdnSFdNN0xseGxoYUM1bzlicS80VTNtZjV3V2RTRk5icDZoTytrMU5r?=
 =?utf-8?B?UERHbThZeDVWcUhDVmFKRGdKMGtJUWFkc3RubWE2ZVVUbjh0b2V1NThqSzhK?=
 =?utf-8?B?S3NZOVdBMEcrVnpDUCtTNnRmcHhYM2UvRERZZWZDMG5JeHFiMk5BdWQyTkl3?=
 =?utf-8?B?cVU0N0ppb29iR3hQTlV2Sm8ra0JSVkdTSlpEa2hNSVdISDJWa2k1NzFMT1Rq?=
 =?utf-8?B?Qno5cnplYTE0czY1d1RCQnlnVVBMMU1lNEdCcHB2bkVDRDZGc2YyZDFpRHJ3?=
 =?utf-8?B?bnZORGdCdDl4V0JBUDdMQXJPQS9UYmY5TmZOczlzb21xY0V1U2s5RE1TbkF1?=
 =?utf-8?B?L1Ixd1puUzg4citxMUEyOVI3MXNHTTRWSFFySG9jejBSTkFrajB0M21CQ0pY?=
 =?utf-8?B?MzhabittaFNiL21kalVxcElUMVFubmsyb1hySysyQ2VXN3daMGRUSDcrNTI3?=
 =?utf-8?Q?JLNGTNcGgtJDjGY6aE+VGeE=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac3eb23-c16b-4c75-562e-08d9c0b5ea67
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 17:03:00.8937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMGqTkqhRX2a+gOQTBUuJ6jwd/aFsjaHCgmYwcjlPEJl9YpY8E7ffDUUEYFtpV8k4xzdoduhpb1Hq2fWODDsDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0302MB2631
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/21 8:12 PM, Russell King (Oracle) wrote:
> On Wed, Dec 15, 2021 at 12:49:14AM +0000, Russell King (Oracle) wrote:
>> On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
>> > Ok, so let me clarify my understanding. Perhaps this can be eliminated
>> > through a different approach.
>> >
>> > When I read the datasheet for mvneta (which hopefully has the same
>> > logic here, since I could not find a datasheet for an mvpp2 device), I
>> > noticed that the Pause_Adv bit said
>> >
>> > > It is valid only if flow control mode is defined by Auto-Negotiation
>> > > (as defined by the <AnFcEn> bit).
>> >
>> > Which I interpreted to mean that if AnFcEn was clear, then no flow
>> > control was advertised. But perhaps it instead means that the logic is
>> > something like
>> >
>> > if (AnFcEn)
>> > 	Config_Reg.PAUSE = Pause_Adv;
>> > else
>> > 	Config_Reg.PAUSE = SetFcEn;
>> >
>> > which would mean that we can just clear AnFcEn in link_up if the
>> > autonegotiated pause settings are different from the configured pause
>> > settings.
>>
>> Having actually played with this hardware quite a bit and observed what
>> it sends, what it implements for advertising is:
>>
>> 	Config_Reg.PAUSE = Pause_Adv;

So the above note from the datasheet about Pause_Adv not being valid is
incorrect?

>> Config_Reg gets sent over the 1000BASE-X link to the link partner, and
>> we receive Remote_Reg from the link partner.
>>
>> Then, the hardware implements:
>>
>> 	if (AnFcEn)
>> 		MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
>> 	else
>> 		MAC_PAUSE = SetFcEn;
>>
>> In otherwords, AnFcEn controls whether the result of autonegotiation
>> or the value of SetFcEn controls whether the MAC enables symmetric
>> pause mode.
>
> I should also note that in the Port Status register,
>
> 	TxFcEn = RxFcEn = MAC_PAUSE;
>
> So, the status register bits follow SetFcEn when AnFcEn is disabled.
>
> However, these bits are the only way to report the result of the
> negotiation, which is why we use them to report back whether flow
> control was enabled in mvneta_pcs_get_state(). These bits will be
> ignored by phylink when ethtool -A has disabled pause negotiation,
> and in that situation there is no way as I said to be able to read
> the negotiation result.

Ok, how about

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b1cce4425296..9b41d8ee71fb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6226,8 +6226,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
                          * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
                          * manually controls the GMAC pause modes.
                          */
-                       if (permit_pause_to_mac)
-                               val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
+                       val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;

                         /* Configure advertisement bits */
                         mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
@@ -6525,6 +6524,9 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
                 }
         } else {
                 if (!phylink_autoneg_inband(mode)) {
+                       bool cur_tx_pause, cur_rx_pause;
+                       u32 status0 = readl(port->base + MVPP2_GMAC_STATUS0);
+
                         val = MVPP2_GMAC_FORCE_LINK_PASS;

                         if (speed == SPEED_1000 || speed == SPEED_2500)
@@ -6535,11 +6537,18 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
                         if (duplex == DUPLEX_FULL)
                                 val |= MVPP2_GMAC_CONFIG_FULL_DUPLEX;

+                       cur_tx_pause = status0 & MVPP2_GMAC_STATUS0_TX_PAUSE;
+                       cur_rx_pause = status0 & MVPP2_GMAC_STATUS0_RX_PAUSE;
+                       if (tx_pause == cur_tx_pause &&
+                           rx_pause == cur_rx_pause)
+                               val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
+
                         mvpp2_modify(port->base + MVPP2_GMAC_AUTONEG_CONFIG,
                                      MVPP2_GMAC_FORCE_LINK_DOWN |
                                      MVPP2_GMAC_FORCE_LINK_PASS |
                                      MVPP2_GMAC_CONFIG_MII_SPEED |
                                      MVPP2_GMAC_CONFIG_GMII_SPEED |
+                                    MVPP2_GMAC_FLOW_CTRL_AUTONEG |
                                      MVPP2_GMAC_CONFIG_FULL_DUPLEX, val);
                 }
---

When we have MLO_PAUSE_AN, this is the same as before. For the other
case, consider the scenario where someone disables pause
autonegotiation, and then plugs in the cable. Here, we get the
negotiated pause from pcs_get_state, but it is overridden by
phylink_apply_manual_flow in phylink_resolve. Then, link_up may clear
AnFcEn, depending on if the pause mode matches. If it matches, then
future link_up events will look like what just happened. If it doesn't,
then we will ignore the negotiated pause mode for future link_up events
(that is, the result of pcs_get_state will not be what was negotiated).
This is OK, because we discard the result of negotiation anyway. If
someone enables pause autonegotiation again, then
phylink_ethtool_set_pauseparam will call phylink_change_inband_advert,
which call phylink_mac_pcs_an_restart since AnFcEn will be set again.

The downside to the above approach is that when MLO_PAUSE_AN is cleared
and we have had to clear AnFcEn, calling pcs_config will always trigger
autonegotiation to restart, even for no-op changes which would not
otherwise trigger a restart. I think this scenario is unlikely enough
not to be a big deal. Lastly, this also depends on

	Config_Reg.PAUSE = Pause_Adv;

or at the very least, anything which is not

if (AnFcEn)
	Config_Reg.PAUSE = Pause_Adv;
else
	Config_Reg.PAUSE = 0;

> permit_pause_to_mac exists precisely because of the limitions of this
> hardware, and having it costs virtually nothing to other network
> drivers... except a parameter that others ignore.
>
> If we don't have permit_pause_to_mac in pcs_config() then we need to
> have it passed to the link_up() methods instead. There is no other
> option (other than breaking mvneta and mvpp2) here than to make the
> state of ethtool -A ... autoneg on|off known to the hardware.

Well, the original patch is primarily motivated by the terrible naming
and documentation regarding this parameter. I was only able to determine
the purpose of this parameter by reading the mvpp2 driver and consulting
the A370 datasheet. I think if it is possible to eliminate this
parameter (such as with the above patch), we should do so, since it will
make the API cleaner and easier to understand. Failing that, I will
submit a patch to improve the documentation (and perhaps rename the
parameter to something more descriptive).

--Sean
