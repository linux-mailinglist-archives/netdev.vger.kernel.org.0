Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE41474C46
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbhLNTtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:49:21 -0500
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:13376
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234594AbhLNTtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 14:49:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFMmA2LMMzw/UyiBqvD/zycKeFTp8+CBdi9bJZluGrD5i9s29tvaLAmcUlC+zVkuf7pwvZe3UwWr31ZO4SXoyIg0VzMutLyLcvhb6WOAYiK70do5R9FlUZfGt5k5VD1JweqFHSh4gY5mNOf6AMHqII7+ZvE1HEhgrlVnIyEnt1EIt3qkOcgFfyooGBdlpbOa96PF43xnj9fFGGuuQlFkqgfD0PjV1U6puMdYjLC1tRmKhkECnMakdgnikDuPPnRqS58BXnnkyG9mwxrfyeFM4QgpLOfMz/SwDgcYDdbZe/G2/hE47es4LxtYcm5GOucPeJr1KWz7TVsG/JTbdB1Rjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpiFS0GI98h7d7ddxPxkdC87+HDy7p4z/3tmzRdBZes=;
 b=Ac7iQ1VOUjTiet+lEfYm/sze3o9kPWKGyd4qwbnI77J+HtNIfjmPDI79bPgTRhE3buYRd1FWQimO+3uFOpdcZw1FzA14aE6p1rZH67/JLDjSfPo3vsHb9H9YgKCp8qkEoSojpo7Quj++/2OemXOOSXHDMrU/xCW/k4GIqDVHRRb4qUJ6gvdnlIe6dqobRGfXmqKIV4SDHsKEHELgk7VSns488MVl6pD0NwJ7rloWJx1+gtApW+iJDAgyjEnU8sUKdUf3QokNRaafxT+eDBC6gcAPXTjEZ7waTOsGHTuvswyd9M7/K119cXU2zsh9ecMYpeYLxmSOGR778iGQv3LPjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpiFS0GI98h7d7ddxPxkdC87+HDy7p4z/3tmzRdBZes=;
 b=TXiLnRC9UBRYsQ/mfgFhczmsJjhTeJIogx9RDJw4bEIQo3G3MLiREuoqcbnHK8Z5eOCQGQQdifMGYgZoc8I+LZN5FXcEFX28BI/Ljrlld0+Q2VF5vfKmkSzUUX7zW/7lT3+k813Rn6M3+LUVc/6vrjCiLkcxdLVGM7/P/MO5Y2o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB6201.eurprd03.prod.outlook.com (2603:10a6:10:13f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 19:49:17 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 19:49:17 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next 2/7] net: phylink: add pcs_validate() method
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
 <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
Message-ID: <0d7361a9-ea74-ce75-b5e0-904596fbefd1@seco.com>
Date:   Tue, 14 Dec 2021 14:49:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:208:32a::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da330494-c4ff-490e-1473-08d9bf3ad067
X-MS-TrafficTypeDiagnostic: DB8PR03MB6201:EE_
X-Microsoft-Antispam-PRVS: <DB8PR03MB6201C5F33569CD9423CCDDC496759@DB8PR03MB6201.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TnSuFgzKap0bYkJ2tK/IjTnd8bO8TErGSwLG4PYvgFsOhy8I3YfYC4w9BZUXkFHjVdIE1P8wAZLpuhqgLJtNrdNB4Vfs0Nr6zlJVeZADr90QHoMyKuvDl55RiZEJ5uZ95bTlRsCra1vwnvg5hC2gFh5mqoqQ/M5djdURK2jbpAg59N5fno8ZKbFOw8SzFlmfMg4z/5m4K2nflsqoHMfdcuS46srae6eeaS44eD7mj0ThrmPwMu1ebiS+00eawrgOkx0zS2cMYMc0tlndTYF5iLRzr5OsfSHDE9b4w/i7QkMUv0HtbCxZ/izgTdodhei/saz+LTmiZ/rJxtNUwk+mupYYLj1yFS5rXxkQq1HLMqDyuTesHFn3x3m91OdCwCOE3h0Wc3cA5v1bugbA46hOYOC0LXTuUgQjtAQS+Ur/XQwcTAR9sxZmxpX3H14m8Jz6Py9rgqGfDiWI2mug2DA8ckoZ0Q+JJ93EE2qP/5cmchIEXYwKXBLGZsl7IZzIaBICGRrQKTF/h6fhQJzrNUJNGKQxj4UWz5PoBFrVZ0AncEPLc807XPPh9HvifC7P+gIqFyNYK15DOj+W9TOqMshEqjFWSM78PdaVzTQHJvzvp5uZ4Njaa1JzAGUtrWq8L39ZoowSXveS6TiERUpPcbjR/UnhhxwlVMQy+m09cnSlVc6ZkoDRTPWG2eW3Z7JS9Mhz3AJAAnEt8uMS+6pnWdiBVmBglFFZDuHQNliRn+0vIdlpHdcekz7FvRE7eaxXR84sW56/sYgp3Qme2tjF8rDV9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(66946007)(6506007)(6486002)(53546011)(38350700002)(66556008)(52116002)(26005)(83380400001)(316002)(186003)(66476007)(6666004)(31696002)(2906002)(110136005)(54906003)(38100700002)(86362001)(44832011)(508600001)(8676002)(6512007)(31686004)(36756003)(2616005)(5660300002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnUxRmZCdVJhOTRPZ2JLYzQzdmRDaDNBQTJWTFdpV0RTeEFSTndCSnBxWGNt?=
 =?utf-8?B?SU4wbmZBamlGTHJGMGJ3UGJjbE83ZE8vQ21IY0FubHl0S3NKTklxVjVNOXZF?=
 =?utf-8?B?MVNqYUZ6aWVCeWQwZFA2eFJYZXB0QlprSk5Ed09NdE53VUU1dDVoeFFwVzJL?=
 =?utf-8?B?Si9FcHlUN2Q3bXFoNXYyQTZhNGFRSkREUVI3L2pUTCtqZ1lMeW1RUVJtSVNK?=
 =?utf-8?B?L3RSZkNWb2FQZFFuN3hLNEdQNEpObjM0ZDFUc2t1c0NVWWdZaHFYUnQwanpP?=
 =?utf-8?B?QmgrWUlaMUovenhhc2g1K2VtMzhYeG8ySmNCZnd5Ylo4ZUMwMGdQSFVzVEtP?=
 =?utf-8?B?bEVqaEZLaHpXV25zN0EzZGhkT0w4ZTdyWUU3VVZkTlgzUkJ3RkN2M0RYdEMv?=
 =?utf-8?B?blNObVpWVTFIdGJCZmx2cXVoU1RzV2NBeUU3QzRkTVlkWFhyOUxBWlpleUlD?=
 =?utf-8?B?ZzFicGg5bXBHUVFvdzVoSy92YmdrYmR4aHRRWnpIVmkvMTUwUThkZmt2TzJN?=
 =?utf-8?B?eWxSd2ZqL2gwY2Mwb1cwdnVzdDR3cUhBdVM3dGJNUStHTXZWd3JZTmlvVHVh?=
 =?utf-8?B?ZmpuMXVHemZ6VkFMOUxHSVFKZTdKK0k3MWswRGNJc2k4ZGVLcmZIeXNSZWtB?=
 =?utf-8?B?Q2Vyc1J4R0JMZkxkUk5ROFRtVkVIV1o2Z2FGUUlIMHFWZ2RQNEx1WjBnbXF1?=
 =?utf-8?B?cGZ0d0F1S284VWN2b0hFaWZlcVJJcTVKZzZqTS8xWkFxT0w1cGRVemhWM2pT?=
 =?utf-8?B?azVtOHppYjczR1YxdG43eHRwNG8zMFd5Y0tCeGN1MzlZZjhONHYyN21OaDNR?=
 =?utf-8?B?eFI5NjNpOVg1VG9QV3hMVndSUXJMUExDQVk5U0JmRHN0K3dwS1FXc1BrWWQ4?=
 =?utf-8?B?YnR4c3FYdlFzT2d6TUU3T05IR0tkaDF2NW5QanV4UXpKdDFkd1hNZlh1MzlF?=
 =?utf-8?B?UGFrbkhnOE9RVWlVRWlMQ2NqNFNhaWlVNUYwZ25TbzhlUUhaaE45RjR2TXhH?=
 =?utf-8?B?aHZrTHRtZmlUc3V5STRxUHpHWTJXNk1qbVYwWlVXSitOeWRxOXQzdHBIVXh3?=
 =?utf-8?B?S25vOVZCdUFpUldaYnhOdHlpTThGNzl4aSszZ0xuMUxBQ2V0ekdPY0NkeE0z?=
 =?utf-8?B?VmpCRytIMkNXTFE1dzMvUnBVTTRWY0s2L1NDdHhuSmdkKzJwbk9Zbi9vM3VB?=
 =?utf-8?B?QjI1WmRTY2RZRUtTYW01SWd1VW9IcUpoRUJBK1BsVGd0N0pyWjRjNHcvTDdk?=
 =?utf-8?B?czc1QlpsRVVCNDlkbzRsNU1pdHJ6M1dtV3NyU0ZiT1dQS3NkQ2tEQ1BicjlS?=
 =?utf-8?B?VitXUmovSXpUcmRtdHJSM3ZlaG50eVZEeXNjcTYvaTFkajRRc2UyTlRzNXk1?=
 =?utf-8?B?eVptV1RSNXRybmVZU3BuR2NNY3p4R0VPMkVqd0l1VUFsMC9oL002ZmJBY2xx?=
 =?utf-8?B?UTk3QTczY3RqdTFWakczUVhGNTRTaUNIbjQxOHVsRXlERStKeHZ4bnROUnI4?=
 =?utf-8?B?VXN3T1RNYUkya0hUU1pFME1yV3lSdyt5aDRZanRSZUM4aHl0S2JFL0RMWFli?=
 =?utf-8?B?Y0s4VVNvMEgzSURDMTdSRlV5bUF5MDNlVHhnYWFFRzlwc08vN29TMHRkOS9k?=
 =?utf-8?B?eEliQ2s0SjkvY3g5elJSSjUzU1pUMUdXM0xOUmhzbHZUbWRyZGM0YTg4SjhG?=
 =?utf-8?B?cmNPYlpxb1NwZE56K3QxQWVYaExuL29RcTNFZGgwdzNybUgxMHhsZVM4bE8w?=
 =?utf-8?B?L1ltc1poUnFXL2VhSERkdXFKNnZEbzJlSXpVMzk2TFd5Qm03QTBONWp4anF5?=
 =?utf-8?B?OEhVSUJNdjNURFZUWmkvMisxVTlpdE51ZXQ3VlJvQ0d2LzNqekI2MWRvZWYw?=
 =?utf-8?B?Y3dETGxNeXZqLy9PTkk5SmhRM0ZjMTJBK29rTnVKZGVZcG5yQ29uZ0FyM1Zz?=
 =?utf-8?B?U3lqRzc5aGtDbittdzExdW1mcG9iUmUwRXIzcTdhWXVrWHZhNDJMYXlqd0xv?=
 =?utf-8?B?cHZpdmdRNUl2eGhEWVNyOXdGNDdpdlhUSlpuTFZiSWtMWHVHTzMwSytjblRC?=
 =?utf-8?B?WTR2cTFUZXlsLzNjWmVWMXZjM2VsNS9HT2crQkE1aEJyb0tWSGg1OVB1WFdj?=
 =?utf-8?B?eUlOZUxMZUd2YlE5USszaDRsSWcxUHlPTlNicTd6a1pEV3ByOHRCc2xlendh?=
 =?utf-8?Q?YqU6FT7zN0VKCNGEp9okuqs=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da330494-c4ff-490e-1473-08d9bf3ad067
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 19:49:17.6239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPjB5F/XxjdbFooNQsif416668xuXbSldm3Pk+5q8b1g+/4LyaOGU/6E9quP5uTv5u5tD0wraku5zFhRUGUtUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6201
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 12/14/21 9:48 AM, Russell King (Oracle) wrote:
> Add a hook for PCS to validate the link parameters. This avoids MAC
> drivers having to have knowledge of their PCS in their validate()
> method, thereby allowing several MAC drivers to be simplfied.
>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/phy/phylink.c | 31 +++++++++++++++++++++++++++++++
>   include/linux/phylink.h   | 20 ++++++++++++++++++++
>   2 files changed, 51 insertions(+)
>
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index c7035d65e159..420201858564 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -424,13 +424,44 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
>   					struct phylink_link_state *state)
>   {
>   	struct phylink_pcs *pcs;
> +	int ret;
>
> +	/* Get the PCS for this interface mode */
>   	if (pl->mac_ops->mac_select_pcs) {
>   		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
>   		if (IS_ERR(pcs))
>   			return PTR_ERR(pcs);
> +	} else {
> +		pcs = pl->pcs;
> +	}
> +
> +	if (pcs) {
> +		/* The PCS, if present, must be setup before phylink_create()
> +		 * has been called. If the ops is not initialised, print an
> +		 * error and backtrace rather than oopsing the kernel.
> +		 */
> +		if (!pcs->ops) {
> +			phylink_err(pl, "interface %s: uninitialised PCS\n",
> +				    phy_modes(state->interface));
> +			dump_stack();
> +			return -EINVAL;
> +		}
> +
> +		/* Validate the link parameters with the PCS */
> +		if (pcs->ops->pcs_validate) {
> +			ret = pcs->ops->pcs_validate(pcs, supported, state);

I wonder if we can add a pcs->supported_interfaces. That would let me
write something like

static int xilinx_pcs_validate(struct phylink_pcs *pcs,
			       unsigned long *supported,
			       struct phylink_link_state *state)
{
	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };

	phylink_set_port_modes(mask);
	phylink_set(mask, Autoneg);
	phylink_get_linkmodes(mask, state->interface,
			      MAC_10FD | MAC_100FD | MAC_1000FD);

	linkmode_and(supported, supported, mask);
}

And of course, the above could become phylink_pcs_validate_generic with
the addition of a pcs->pcs_capabilities member.

The only wrinkle is that we need to handle PHY_INTERFACE_MODE_NA,
because of the pcs = pl->pcs assignment above. This would require doing
the phylink_validate_any dance again.

Maybe the best way is to stick

	if (state->interface == PHY_INTERFACE_MODE_NA)
		return -EINVAL;

at the top of phylink_pcs_validate_generic (perhaps with a warning).
That would catch any MACs who use a PCS which wants the MAC to have
supported_interfaces.

> +			if (ret < 0 || phylink_is_empty_linkmode(supported))
> +				return -EINVAL;
> +
> +			/* Ensure the advertising mask is a subset of the
> +			 * supported mask.
> +			 */
> +			linkmode_and(state->advertising, state->advertising,
> +				     supported);
> +		}
>   	}
>
> +	/* Then validate the link parameters with the MAC */
>   	pl->mac_ops->validate(pl->config, supported, state);

Shouldn't the PCS stuff happen here? Later in the series, you do things
like

	if (phy_interface_mode_is_8023z(state->interface) &&
	    !phylink_test(state->advertising, Autoneg))
		return -EINVAL;

but there's nothing to stop a mac validate from coming along and saying
"we don't support autonegotiation".

--Sean
