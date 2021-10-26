Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0298743B829
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237806AbhJZRa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:30:56 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:41729
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237794AbhJZRar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:30:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AT8JhaLxHU10PDYBVRjJdmaAs4ONllBGub0isk/AeRCTU7Hd20gHTCl037lTawtZwhflpDjGGVj6KmDmazlEVaNb7NhuallUTa+aBr51fN1FiwBee7YJ/2sBlfNX5EWP55XXgNdtc2PmwyimeZgs3Pj7ONOC+oaP6XcZcc1uoBn/DtbdOAVLv89wFqYQG5F8uamWkoevDfOsyCWGPb9sJ+mDnC6C30CmUS0tvNwXWQLJB5j9QUdllGEed3zEDqdri9e5sZ1O9pCWLygsxB1qUH1EFt1YWBY6qEc0f2jaHwB1wqLWmeL0yZ/f30M1YDEd8yg9WxL/bKbXA97Oqvlh9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trC+fGzt9mDQeB+UvMDHBbYIAiF1L9eP6dsfTdnItsM=;
 b=MFEV85ZBTtKvfViDZiO9eTWlSPWH+YpXLEezEqdp4bNtBFL1EeOZp422zmOotrSx3BBcY8SFiJ+oC2VNqkGRaCRyeyfVOAXmh2mtbX8jGpbnkPkT8q5E0uh9+1kGvY4Z1rc+Ba+syjFa0Zlmk8rBHviusnqdmOOEWBd8X/QVzhksXTtaWVBqQbmS53Y4g8YtoOECo27Jd6RgW3BnXg53BfGatgFnknH1EeNODNN6HMAfGNgHL0lpNSdjE0mTmun2QOdB3OoPVdh38kWiFgJ6mQy6h5MKX7lxMFGMDcmhKXIN7+PdOdtb59IpX3/YB9mYmFQQLB+IJd0gHQZii5d97g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trC+fGzt9mDQeB+UvMDHBbYIAiF1L9eP6dsfTdnItsM=;
 b=aI0wOGAgdQy6nCc2Wa10VvlUWZH9iBuo+u/WZLlIdYswanD7io08U2UaYMkZWI2cQ0RTJ8fQrrRgOwtNmnQ3QxqoQw2q6jPpGYR6yo8Y1S4ErFb8UM/vmCh7om4m3PKtnfRD4mPML2jOq2+lHkk08DR2i/AvWMl65xAzdseEIaw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7515.eurprd03.prod.outlook.com (2603:10a6:10:22a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 17:28:20 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 17:28:20 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
 <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
 <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
 <YXg1F7cGOEjd2a+c@shell.armlinux.org.uk>
Message-ID: <61d9f92e-78d8-5d14-50d1-1ed886ec0e17@seco.com>
Date:   Tue, 26 Oct 2021 13:28:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YXg1F7cGOEjd2a+c@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR19CA0017.namprd19.prod.outlook.com (2603:10b6:208:178::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 26 Oct 2021 17:28:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76c01e5d-0067-4b70-9896-08d998a60116
X-MS-TrafficTypeDiagnostic: DB9PR03MB7515:
X-Microsoft-Antispam-PRVS: <DB9PR03MB75151C59785907BE1FE6038B96849@DB9PR03MB7515.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8YOYqWp0cea4U/s468YvFgOYhGyF1Pjcpg+7Kt/g5nnLVMUHJybOHlrPIL+T4Oq3y3TBsv/v+vhexIp9qV0984RzwZ1RuHm4dGTckg62jGhN3FIfTTLSuCnxtu5C5FuuPX4Dc2CzAhrz8IjZ7AlsCnYAunhecRt6y99PWs7MRrLexcaVBjHguqbAaNMlq4YgVEoWOmQvwCqqsLYRRvsDTF4YLgs/Dj8q8ZAueeRBi+JX88AzY7a4uWZNFmRW9RFhwcu5tSsFFtBWv8qncRJf3m4MZJJMCYcZy/mnU5ecTKEI4jCaghpieAY6gfeOnZAUiuSb0mK9C6/R9m5bzmiQXgnLXJbBs0GmWtglwMDTZMi8BLeHN7txxB4OCDk/ZoUtlSMHX4Ze8WGpRBe+c/c0amSZfwgPnn+dgDYYZNl9qFs35MeqAN9fFb0VhcQHSvrsaseFqg2uenfWw4Pa0/aawL/EQwAGaQPASWZndurIg5YFmFtnWdTnyXpAbHsVUmYOTG1GoivGIzOz6Xl0Nvwq+KfU5rwS3NVlJu2ZH13TZdLzpGpuO9Dfsl/CuXqUAAA6LvN7YGA0s2UxN4BcnlbTQvPgTgP9YcXVBLIq/uOuKDEww0Q3dQnqEUn88hZgfOShoDmbvZVPig1hG6OluAVaR74B0DjtMtPZEDpxO4QfKD5O8LfQb8OyMWpGLxlzn/5SNjNDvkoozmXSVTBGvUQnk7VGeMHQpnUAWMt3zZ5sqi/qwQmUrTGl0u3qShyaNeveASLsMAM/pg67EAevl1u97QVlwE4ZPpqYBKaqQmW9eJoCSOFuflYMhb/MA2orjhctP7NyPUaluNGuiiqrWCtc6OZber55IJwliXMbo61Qxqo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(956004)(31696002)(966005)(8676002)(2906002)(36756003)(6486002)(83380400001)(38350700002)(4326008)(31686004)(52116002)(186003)(86362001)(66946007)(8936002)(6666004)(38100700002)(66476007)(16576012)(5660300002)(54906003)(44832011)(508600001)(110136005)(26005)(66556008)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWhNZkNtVUlzeEJKd21Fb0tiU25YL2ZLYTdsQTk5Q2NCQXRhenJIc1J3bUZG?=
 =?utf-8?B?WDdlZVVwamFZWDFtamJ2c1YxNVF4WnJHOUw1QUlnaVptV291VVRDVnZyV3h2?=
 =?utf-8?B?TEZodzFPN3dUd3N6M0dDYXZrb2lTYXN1SlZiOFJON1U2bDNhcXVSV0tndGky?=
 =?utf-8?B?WGxnZEpWYkRadzQ4Q2RRNGVlL29rc0daK0JDOXFCTEVxclhXaVlLQ2lXQ3p5?=
 =?utf-8?B?Y2hCeDI3MDRzWFJWZDIzZ1NRWTlrZnl2bTFpUkFEODJGNWN1elFkOGdMWW96?=
 =?utf-8?B?Vk5MMFJLU3grcmtSck16NXJCcHhmeks2MHJWd3BHOGRNM2pmNkVsTCs0Z0N2?=
 =?utf-8?B?OUhBZ3hPdXlZTFJhZHpZSEdYY2I4bWwyN1ZSY0ZCOTU4ZUZLQVNTaEhrcTBq?=
 =?utf-8?B?UjlMZjg2QUpjNUZFSmR5MGFKYkMrenQ5RGFmL1kyWnY2ZWtHdXBhUzJCL3F4?=
 =?utf-8?B?ZVl0NU5vVVprVTB3c0VZZzdDZ1lPcWlXNFZrREpZUUc1WDVRNjZUdGtGM0M0?=
 =?utf-8?B?K3ZkRUtJVjF3RU1JcFVyVHk1UlluTWZyOVVISnZIMFlUazNENEZZNUM3QjB0?=
 =?utf-8?B?RFRIWTFWSFlRWUVMaW5vOXRWUklER29RZS95NndRVzUzRXk2ZXU1ZThNUnFO?=
 =?utf-8?B?cHJlVnFLeEpxR0ZXdmd0b0pmOFRFTU80RGRIcEpUQWlaTzkwK3dPM2NjOGpB?=
 =?utf-8?B?OSsxU3VOS0lpWmZtcHhielA5LzVZUFFNR2J0T3I5MzZoRzlGa3k1dy9lSU4x?=
 =?utf-8?B?S1VuOWtnTktzSi9TZDNRNlk2SlVrSkZqaHg2eWgvRHdrUlk2NUJORThocTJa?=
 =?utf-8?B?TUlJK2FMNG1iNmF1T0hYTXBGdXFtb0pSaldlN3IyeXVVM2o1cUhKbHhPV2dN?=
 =?utf-8?B?TFNSYXEyUHZvem0vRUlic200QXB5Mmp3cDRaZUFUY1lQNW5OV2tuMW5RV29i?=
 =?utf-8?B?UzVmajB6SFViNDZpcWx1ci9GZVVTWjFPMVpqbm5rQVZZUm9yanFFdFVqT0JG?=
 =?utf-8?B?K3p0V2t5Y3RLdDBtVklYWGN5V1gvdy9zdGZyVDNxS1hYR0dOQ0Npdit4dTU2?=
 =?utf-8?B?L0ora2JSTW5OdkJURStNNExXdk9xMTNGblBHMDJXYVl5TDJSalpudmlnNVdp?=
 =?utf-8?B?ZlpqWVQyamVybmxxMTk0bGlEcFVrMUN3ODVieHg0UHBKR2s3UUZMUW10SGVY?=
 =?utf-8?B?eXJwdVRtTGl5amthaWVtQ25UTjJOUnRQeGZaOXJDOTBNdzJSY3A2am16MUVv?=
 =?utf-8?B?OHcvM1E0TE9uNmZ4L25zMFRsZEhTT2lsSWFTNzhvcithVXVvdEZIblFEWU1W?=
 =?utf-8?B?WDR6OFBWd3lnMXBFTUpjOTUxRXRrWDdvVlJEZlFpR1psQmtGeFlmeWV3aGJY?=
 =?utf-8?B?d1hxbExsektycm1XSFJhOGUyVnI3YTVVRkk2dXg3VVJuTFNjekR6cXI4SmRD?=
 =?utf-8?B?Vld2UVVDRFVKNlRJQjhESFlzUkdGM3BjWkY1bFpLSi9CS0VLc0QwVWVtK3Fw?=
 =?utf-8?B?MjQzS3FaY2MydTJJK1NBYnd1VTlTVFlhSW41aUR4Z0dJSHIrL0NYM3NWY1hM?=
 =?utf-8?B?YmFsRWFpRjMxcnJlUGFBRUVPbk1WRy9pSXNGdWlkRm1Rd0lMYXFHTVdEeFNP?=
 =?utf-8?B?eG9OV1NKWVU2ZDFKUkJsaGFvRDVzL0NZZExzMURPcHlvSlcrdG93MnBhZDA3?=
 =?utf-8?B?aERjMmlWZGQ1RHdsV2VMaS9XeFZxdS9FUmRvWER2WHB3Tk5rREYydzU5MUV2?=
 =?utf-8?B?b0ZjRFlEV1FrM040Vk1KdUZINkU1UWZTZWh5aDk3U3BSWHlwRHVVWk53REUx?=
 =?utf-8?B?MElkSGdwUWZBTjV2WFBVOTlBTUhtWWFGcUxKRkxROUQrcDhPVFBqd1VKbjJY?=
 =?utf-8?B?MWhsdlhpRG04OS9CQmRYdmYxTzRINEJTbjhsVWlFQm5qaDNzSVlDNWljZVdT?=
 =?utf-8?B?bWRqeW1FcG4vb0dZUGhsNDdqL1phQy9pTURoMzMzdWdid2xSUzNqUTJNb1l4?=
 =?utf-8?B?MTR1T1E2cG1QZXRVWDNWaVpZUVQ5Z1hqVk9HNVhFaGFGOVhWNjVLdSs2ODRG?=
 =?utf-8?B?dElzY1gxaUVRVk5rYUZSb2N2Ymh1czZJeVpZSVVjZURqVEs3QUpnTDJpZEpp?=
 =?utf-8?B?bnA5N0xyTG5mQW5LclNPYjBxdk53N204SGFJUlc2MzJQdGMrbm1NQmpsZWNk?=
 =?utf-8?Q?ShgYWkHR/EERVPli/ydxFHk=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c01e5d-0067-4b70-9896-08d998a60116
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:28:20.1236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFjzwAvdkBE9YrfRhwHjv10ex8W8u79Tb32zUKAarRqZ10mJLyKCuJE+7BvlCjdu4ct72uw+HPBBz1Qb55CVmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7515
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/21 1:04 PM, Russell King (Oracle) wrote:
> On Tue, Oct 26, 2021 at 06:37:18PM +0200, Nicolas Ferre wrote:
>> I like it as well. Thanks a lot for these enhancements.
> 
> So, would this work - have I understood all these capability flags
> correctly? To aid this process, I've included the resulting code
> below as well as the diff.
> 
> Should we only be setting have_10g if _all_ of MACB_CAPS_HIGH_SPEED,
> MACB_CAPS_PCS, and MACB_CAPS_GIGABIT_MODE_AVAILABLE are set and we
> have gem, or is what I have below sufficient (does it matter if
> MACB_CAPS_PCS is clear?)
> 
> static void macb_validate(struct phylink_config *config,
> 			  unsigned long *supported,
> 			  struct phylink_link_state *state)
> {
> 	struct net_device *ndev = to_net_dev(config->dev);
> 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> 	bool have_1g = false, have_10g = false;
> 	struct macb *bp = netdev_priv(ndev);
> 
> 	if (macb_is_gem(bp) &&
> 	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
> 		if (bp->caps & MACB_CAPS_PCS)
> 			have_1g = true;
> 		if (bp->caps & MACB_CAPS_HIGH_SPEED)
> 			have_10g = true;
> 	}

This is incorrect. (R)GMII does not need a PCS. Only SGMII needs one. So it really should be

  	if (macb_is_gem(bp) &&
  	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
  	 	have_1g = true;
  		if (bp->caps & MACB_CAPS_PCS)
  			have_sgmii = true;
  		if (bp->caps & MACB_CAPS_HIGH_SPEED)
  			have_10g = true;
  	}

> 
> 	switch (state->interface) {
> 	case PHY_INTERFACE_MODE_NA:
> 	case PHY_INTERFACE_MODE_MII:
> 	case PHY_INTERFACE_MODE_RMII:
> 		break;
> 
> 	case PHY_INTERFACE_MODE_GMII:
> 	case PHY_INTERFACE_MODE_RGMII:
> 	case PHY_INTERFACE_MODE_RGMII_ID:
> 	case PHY_INTERFACE_MODE_RGMII_RXID:
> 	case PHY_INTERFACE_MODE_RGMII_TXID:
> 	case PHY_INTERFACE_MODE_SGMII:

And then SGMII needs its own case here.

> 		if (!have_1g) {
> 			linkmode_zero(supported);
> 			return;
> 		}
> 		break;
> 
> 	case PHY_INTERFACE_MODE_10GBASER:
> 		if (!have_10g) {
> 			linkmode_zero(supported);
> 			return;
> 		}
> 		break;
> 
> 	default:
> 		linkmode_zero(supported);
> 		return;
> 	}
> 
> 	phylink_set_port_modes(mask);
> 	phylink_set(mask, Autoneg);
> 	phylink_set(mask, Asym_Pause);
> 
> 	switch (state->interface) {
> 	case PHY_INTERFACE_MODE_NA:
> 	case PHY_INTERFACE_MODE_10GBASER:
> 		if (have_10g) {
> 			phylink_set_10g_modes(mask);
> 			phylink_set(mask, 10000baseKR_Full);
> 		}
> 		if (state->interface != PHY_INTERFACE_MODE_NA)
> 			break;
> 		fallthrough;
> 
> 	case PHY_INTERFACE_MODE_GMII:
> 	case PHY_INTERFACE_MODE_RGMII:
> 	case PHY_INTERFACE_MODE_RGMII_ID:
> 	case PHY_INTERFACE_MODE_RGMII_RXID:
> 	case PHY_INTERFACE_MODE_RGMII_TXID:
> 	case PHY_INTERFACE_MODE_SGMII:
> 		if (have_1g) {
> 			phylink_set(mask, 1000baseT_Full);
> 			phylink_set(mask, 1000baseX_Full);
> 
> 			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
> 				phylink_set(mask, 1000baseT_Half);
> 		}
> 		fallthrough;

Actually, according to the Zynq UltraScale+ Devices Register Reference [1], the PCS does not support 10/100. So should SGMII even fall through here?

[1] https://www.xilinx.com/html_docs/registers/ug1087/gem___pcs_control.html

> 
> 	default:
> 		phylink_set(mask, 10baseT_Half);
> 		phylink_set(mask, 10baseT_Full);
> 		phylink_set(mask, 100baseT_Half);
> 		phylink_set(mask, 100baseT_Full);
> 		break;
> 	}
> 
> 	linkmode_and(supported, supported, mask);
> 	linkmode_and(state->advertising, state->advertising, mask);
> }
> 
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 309371abfe23..36fcd5563a71 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -512,30 +512,43 @@ static void macb_validate(struct phylink_config *config,
>   {
>   	struct net_device *ndev = to_net_dev(config->dev);
>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +	bool have_1g = false, have_10g = false;
>   	struct macb *bp = netdev_priv(ndev);
>   
> -	/* We only support MII, RMII, GMII, RGMII & SGMII. */
> -	if (state->interface != PHY_INTERFACE_MODE_NA &&
> -	    state->interface != PHY_INTERFACE_MODE_MII &&
> -	    state->interface != PHY_INTERFACE_MODE_RMII &&
> -	    state->interface != PHY_INTERFACE_MODE_GMII &&
> -	    state->interface != PHY_INTERFACE_MODE_SGMII &&
> -	    state->interface != PHY_INTERFACE_MODE_10GBASER &&
> -	    !phy_interface_mode_is_rgmii(state->interface)) {
> -		linkmode_zero(supported);
> -		return;
> +	if (macb_is_gem(bp) &&
> +	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
> +		if (bp->caps & MACB_CAPS_PCS)
> +			have_1g = true;
> +		if (bp->caps & MACB_CAPS_HIGH_SPEED)
> +			have_10g = true;
>   	}
>   
> -	if (!macb_is_gem(bp) &&
> -	    (state->interface == PHY_INTERFACE_MODE_GMII ||
> -	     phy_interface_mode_is_rgmii(state->interface))) {
> -		linkmode_zero(supported);
> -		return;
> -	}
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_NA:
> +	case PHY_INTERFACE_MODE_MII:
> +	case PHY_INTERFACE_MODE_RMII:
> +		break;
> +
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_SGMII:
> +		if (!have_1g) {
> +			linkmode_zero(supported);
> +			return;
> +		}
> +		break;
> +
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		if (!have_10g) {
> +			linkmode_zero(supported);
> +			return;
> +		}
> +		break;
>   
> -	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
> -	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
> -	      bp->caps & MACB_CAPS_PCS)) {
> +	default:
>   		linkmode_zero(supported);
>   		return;
>   	}
> @@ -544,32 +557,40 @@ static void macb_validate(struct phylink_config *config,
>   	phylink_set(mask, Autoneg);
>   	phylink_set(mask, Asym_Pause);
>   
> -	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
> -	    (state->interface == PHY_INTERFACE_MODE_NA ||
> -	     state->interface == PHY_INTERFACE_MODE_10GBASER)) {
> -		phylink_set_10g_modes(mask);
> -		phylink_set(mask, 10000baseKR_Full);
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_NA:
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		if (have_10g) {
> +			phylink_set_10g_modes(mask);
> +			phylink_set(mask, 10000baseKR_Full);
> +		}
>   		if (state->interface != PHY_INTERFACE_MODE_NA)
> -			goto out;
> -	}
> +			break;
> +		fallthrough;
> +
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_SGMII:
> +		if (have_1g) {
> +			phylink_set(mask, 1000baseT_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +
> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
> +				phylink_set(mask, 1000baseT_Half);
> +		}
> +		fallthrough;
>   
> -	phylink_set(mask, 10baseT_Half);
> -	phylink_set(mask, 10baseT_Full);
> -	phylink_set(mask, 100baseT_Half);
> -	phylink_set(mask, 100baseT_Full);
> -
> -	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
> -	    (state->interface == PHY_INTERFACE_MODE_NA ||
> -	     state->interface == PHY_INTERFACE_MODE_GMII ||
> -	     state->interface == PHY_INTERFACE_MODE_SGMII ||
> -	     phy_interface_mode_is_rgmii(state->interface))) {
> -		phylink_set(mask, 1000baseT_Full);
> -		phylink_set(mask, 1000baseX_Full);
> -
> -		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
> -			phylink_set(mask, 1000baseT_Half);
> +	default:
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);
> +		break;
>   	}
> -out:
> +
>   	linkmode_and(supported, supported, mask);
>   	linkmode_and(state->advertising, state->advertising, mask);
>   }
> 
