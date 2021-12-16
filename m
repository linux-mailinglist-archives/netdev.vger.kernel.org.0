Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D426D477628
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhLPPmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:42:16 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:21793
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232607AbhLPPmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 10:42:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBYlSRDh6OgRryTCMAQ9fhdQ3iIjAFiby22FXLRZl4KyVq1aCyGoqo7LnTG4BnR+pyzCXKGcDNJCZnyFi4nNbI+ddaZj5hbya0LrKpzWg8Ok/c4Pzmty5ceUJPHRKLVfQ1zYaFOKQ6qEP6TuqmTfeHbOuTNRhOOsWJN/yXaSBTWWPCwX0+7hkZD5+w4Iaz5kakEsT3OksjnKtfY0/5vQFDMmuyWBtjlDa+35ztEJfU0XX4QCPuBJwYMeMf1Tjjv57mYCkhrvhEYf9kminG5BqfDtwbpN4/Ip3/3izgqA1mQFVQb3RYcjT22dUcnjuCT75rwPNjjVgZBjWpj4c2IRiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rR5EApAn3bSgwrmmNkh9oVaWZha4DqnFZVSWPtAy28=;
 b=g5zML+a/mcJm+I/LN0AaQ95v82PugKMG/78dCWjCHXZzLJ9OECv5KQiC7Z7d+eGX3j0V7jPP00HwDvjihD2O4bAqX2NIL6X9jsGDoADKSZkamsNUYYlkJU2UUagb4j+/cQQXgunw/QE6KjdqwFY7tstDaH3hDoozk2TigIQcX+sh4XVgDWl6fBmR4PN6sx62jnMJ/LJQpE5fmyUzfTmJehtBN5UXtmha1RacoLwrJO4D3qN8AE/BYV1V9fgjGsb6/wcXlDsVbfZ/vKJsA7r2Pa7kEASWjsAAHeuYHaGMHeSMrKRryraxNpdTCNqU03DBPFhdRQxokHfRCUsiTVuotw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rR5EApAn3bSgwrmmNkh9oVaWZha4DqnFZVSWPtAy28=;
 b=Y65/qd6pXIzBCgzHC/g2TOAPD2nG27KkSw7U3RrcLeyOWkxzzNhAibUcC2TOfJjHQw7+u84QKQ720Pi1Mpro1NVG3mzBr79JHFUTYgTnqxd+4yUSGwD1pJtDLBpQW6RUPM6hId/ORs0xg7sdZLWTd0r8vUhsUmDyQTUfagzd4Lc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBAPR03MB6408.eurprd03.prod.outlook.com (2603:10a6:10:194::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 15:42:13 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 15:42:13 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next 2/7] net: phylink: add pcs_validate() method
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
 <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
 <0d7361a9-ea74-ce75-b5e0-904596fbefd1@seco.com>
 <YbkoWsMPgw5RsQCo@shell.armlinux.org.uk>
 <3a3716a1-54be-e218-5c1e-a794b208aa53@seco.com>
 <Ybk3kuKyynGQYjzh@shell.armlinux.org.uk>
Message-ID: <99059dd8-808d-ddaf-3e65-85b1f7652b7d@seco.com>
Date:   Thu, 16 Dec 2021 10:42:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Ybk3kuKyynGQYjzh@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAP220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::34) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca5b5622-1f35-4c52-f508-08d9c0aaa167
X-MS-TrafficTypeDiagnostic: DBAPR03MB6408:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB640845214D8CFF509E76E70696779@DBAPR03MB6408.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQuEQgV9q5VOyay3GxjkfkjffigBSEeo3R784esKpUT/uULEBIEiLKw4WFPL8noeoweYg2VrtIHd6nfnn0i0WKzAWqjh6K1fS66QaawH4xMpt5PHG5cDZK4vY8Yow8SNEXtfnY022SeEelO+GjL+VMV6QScKYNyDY90G5FzGuS+SXjlaeZ+ik/cKJqb1fkKDwbIf0PaD3w7ZIvghF6ZbttAD7/msiQe7CjvncC82/GJYFI9Gd65+ULq4TEbUqcPj31LgzydlQxw428npNVO8O5QrGXU9idQ6LIuhn9Ct/N9CWnIPE10IiuiFGFvbg2I2dpk3sy3ZBa+X7KtolGrdGXZdk+SWxJDilBz8SQ5m40faOvAawNi//uwl81AZgLJipm5PZHj6nk2mjmzoI6TtRAphng03bzb5r8eXQmIFly95u1654oIQQCT2DcdqzYwU1hZQ/2zyKnILlXDlXt4EPP1wRoHmjRfUNkWAaAkV91F+nmI/UxK4uwlwxj8xQUVbgbS2sw5yujloq1hbNmpFQKXkijuxUS2dOIoT2zkDhyTGAEqEI61u00tZFxAq70rcyam6234bknAu5+r9fTttNmv93vF2EtpvApE06oxB6F/JZBPD5x4tE8q4Z3mYg8oQKudL3xsJrAmRMBTrzs+jt6dn2p6EairY6CKMDNjOWEv1GCpO/Fkwxx3MHq8DTtph/W/cpfTytmRc/SjWbUYT59sPXvkmBzBvHbGf1vOd6vehOmZUVILtYCXApOMhib050DtGA8+wdRnId0H7YmG5Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(31686004)(66946007)(6506007)(316002)(26005)(83380400001)(186003)(31696002)(2906002)(5660300002)(508600001)(6916009)(52116002)(66476007)(8936002)(6486002)(38350700002)(44832011)(66556008)(6666004)(36756003)(54906003)(6512007)(2616005)(4326008)(38100700002)(8676002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y01PNkJTQk1oZDM3eUZFbGtGbU9yb1NLZk9LaTV3OHZtajVlY1BKWjhEVDZ2?=
 =?utf-8?B?UUwrMXhIOENmL3VENkt2SWdVbnpGRmttSldnenF4MlJNN0w3cVZvRDBEN1dq?=
 =?utf-8?B?ZGRneGpqNkRxRHg2c2ZnOFQwenBGbDM1RXdlQlhHdkxLR1phbzlFUGplcVEy?=
 =?utf-8?B?S0ZJYnFYNWMrOXBkcitBMDNtK3ovTkRjRmRpVEVYc2VZWGJWTnc3VklCTnBh?=
 =?utf-8?B?cS9CMHZGaXBKbWxmNlJxZUlzWXA2bm9TczRIMmEyZlNiMGw5a0IvQXhWenBu?=
 =?utf-8?B?d2RFT1ZKT0FXc2ZjU2ppUVlLZVcvZnNxL0RoOFdDZGhiLzIzdHBBaGRNbVZ0?=
 =?utf-8?B?WXdDa2NPNm01WnV2STVNVHhNN3ZFYjJLRDdaV3NUeFlPSDhKaTFuMDdtQ2Fu?=
 =?utf-8?B?czVkVkpqRjN5b011Nkw3MEFjMm5BR3crSmFjeU9SSUF5Rlk0Y0Nqc3VhbUlZ?=
 =?utf-8?B?a3djSVlNRTZ1UDFEUDJSSDIyWnF6Z2NBTjIvdE0rcktDMElLV2IyWWZoMWlH?=
 =?utf-8?B?L1hwY1hVNkxwdGFXTnd0UjF0VGZxc01abm5rZms3a21LVXo3RTdyRXd5aEpk?=
 =?utf-8?B?R3BjRHcwSXlUcWFvWVVtK3dZQXNRdnB0NUtaUURsQzF0YU9wRFZOK0swZUty?=
 =?utf-8?B?N0F4YU5xZC9tVm1RYkU4eXE5eGtucURZQytmUGdWME1VVlBGZHFUMThPQ0hn?=
 =?utf-8?B?TkNkTTVaQmJrUWdxRFFrNk8rc1FVQ3NXcU84ekJhNUNNd0lpcGtUK253L29Q?=
 =?utf-8?B?cWJqMnc0QStwaG5wMDZGcENNL3YzUExlM3Jma0dYM21iRm9MMHByckxqWjBT?=
 =?utf-8?B?RXMrY3NYUU5VZFR2NFJvZGYybjRxeUFPNU9mZ05kbVU5Y2JSTGtLRWdoSGhj?=
 =?utf-8?B?T3d5UlNhYW9DM0VrYWFCNXBsSEU1alFmdXlLRkhzRldFVlZrQngrcC9NTGhK?=
 =?utf-8?B?aWJoNmpmOCtxRmEvdm1xZXhRZ1VyWHQxaDNqZVZUMHpsNnRORzVxcVY0azJC?=
 =?utf-8?B?MVI2NXlEdnExSXlOQVpSQnBBWDQraG96KzNLUklXeVF6c3V5Q0p1NjMyYWtY?=
 =?utf-8?B?OUVOKy9IL3dvZFdKNHBIQ3hnVXlZQjF5NWhxSjMxSDV4M1E3TDk0WWwvZExD?=
 =?utf-8?B?WlVtYUxwQVRnOWZqVzRENlJBVG81NHhrMmsrYXc5eEE3Vko3cVZiTS83VkNx?=
 =?utf-8?B?U1dtL0w0NExBUDNYZkxoWk1EUlRIOXVialczZjJSaUtUelEzWmxDbURpV0Nl?=
 =?utf-8?B?dkNncklEa201Wm5jdW83NlphaG93SjVaTjliRmxZRHdVaWN2cnJYcERlRFNq?=
 =?utf-8?B?SkV4cERaSnR3RlVPZ3BjUDMrNVoxbGNVbTkzR3NBSXFRKy8rUU1ISzNSQnV4?=
 =?utf-8?B?V0g4dzNBRzNNcDl2SlF4TWw3VHNmZ2tUaXZYa01IQjJtY1BEVmtXYnNvbDBF?=
 =?utf-8?B?L1pmclNROFdBbXViVkhpMXdIam9FWjN3SEhmTFRCMVJnTWVZNFQvZEx0NTYr?=
 =?utf-8?B?WjlublllNThEa1VxendTNSs0ZUxtVXlUNHN1Wm04ekZMSWJjY3pyQzdvMnVH?=
 =?utf-8?B?MUNQL01wMUxaaUpJR1BmYVNldFBOTFpyTUVvSEQrclNYM2RRM2FOWEQ0OGE3?=
 =?utf-8?B?dnpXVytmVUtKcWxKNmp4SjFTVnBkZGFEblRTUzc3UVBIWVJadUFuTEJReGJD?=
 =?utf-8?B?MnMrWTY2eWVOd3lxOFJ3OVZ2RnBvZi9jSkN4cFhhNTZybGlEMEcrdlRpK0R3?=
 =?utf-8?B?ZiswRk9sM2xwQ3dabStzTzVTQU5VYXpGRzNFNmdvdDNEUTJtcVhtZk5ucDVT?=
 =?utf-8?B?RkxWb3FmWTdFbGE1akx0Y21GTjltNGphcklnYmZUVHUzQkhyb0FrcmtRVHpn?=
 =?utf-8?B?WTNQcVhuaEFlcXFsZXVDdWN1TUppOWtoVEtMOHUvdTM1Y2kvclczV0I5Tm9B?=
 =?utf-8?B?T1lqandiQXQ0b1YyTit0K2JFck9vUHM1QVRyNStTMUNiMy9SZ2VVMkRlNzZl?=
 =?utf-8?B?MlA4S3RiWHdPakZFaG9BeEcwM1VrdldrTWZJa0t2dytkNjVGbW1TenRCVktH?=
 =?utf-8?B?ZXQyK2NOd1NFYS9MTC8zamxhdEdTSUZZdjdJcGxJRmVhOVQ3VGw3ZXNBcHgx?=
 =?utf-8?B?a2M2anJnNXNHaDh6dC9QRElQVU00NG5XZ1A1TjF5M2JlU29aRGdySDU4TzhM?=
 =?utf-8?Q?KD3IpWQ6LUlJq24CS8Qap3M=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5b5622-1f35-4c52-f508-08d9c0aaa167
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 15:42:13.6013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hP+qGGoiPsZqYtHXl7Rv1XkF06QV99oUORbct/rsJ34/p/muOuhgGwCYQ5rra0cPdqt5vfRzOEOowspX6AWKCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/21 7:32 PM, Russell King (Oracle) wrote:
> On Tue, Dec 14, 2021 at 06:54:16PM -0500, Sean Anderson wrote:
>> On 12/14/21 6:27 PM, Russell King (Oracle) wrote:
>> > On Tue, Dec 14, 2021 at 02:49:13PM -0500, Sean Anderson wrote:
>> > > Hi Russell,
>> > >
>> > > On 12/14/21 9:48 AM, Russell King (Oracle) wrote:
>> > > > Add a hook for PCS to validate the link parameters. This avoids MAC
>> > > > drivers having to have knowledge of their PCS in their validate()
>> > > > method, thereby allowing several MAC drivers to be simplfied.
>> > > >
>> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> > > > ---
>> > > >   drivers/net/phy/phylink.c | 31 +++++++++++++++++++++++++++++++
>> > > >   include/linux/phylink.h   | 20 ++++++++++++++++++++
>> > > >   2 files changed, 51 insertions(+)
>> > > >
>> > > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> > > > index c7035d65e159..420201858564 100644
>> > > > --- a/drivers/net/phy/phylink.c
>> > > > +++ b/drivers/net/phy/phylink.c
>> > > > @@ -424,13 +424,44 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
>> > > >   					struct phylink_link_state *state)
>> > > >   {
>> > > >   	struct phylink_pcs *pcs;
>> > > > +	int ret;
>> > > >
>> > > > +	/* Get the PCS for this interface mode */
>> > > >   	if (pl->mac_ops->mac_select_pcs) {
>> > > >   		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
>> > > >   		if (IS_ERR(pcs))
>> > > >   			return PTR_ERR(pcs);
>> > > > +	} else {
>> > > > +		pcs = pl->pcs;
>> > > > +	}
>> > > > +
>> > > > +	if (pcs) {
>> > > > +		/* The PCS, if present, must be setup before phylink_create()
>> > > > +		 * has been called. If the ops is not initialised, print an
>> > > > +		 * error and backtrace rather than oopsing the kernel.
>> > > > +		 */
>> > > > +		if (!pcs->ops) {
>> > > > +			phylink_err(pl, "interface %s: uninitialised PCS\n",
>> > > > +				    phy_modes(state->interface));
>> > > > +			dump_stack();
>> > > > +			return -EINVAL;
>> > > > +		}
>> > > > +
>> > > > +		/* Validate the link parameters with the PCS */
>> > > > +		if (pcs->ops->pcs_validate) {
>> > > > +			ret = pcs->ops->pcs_validate(pcs, supported, state);
>> > >
>> > > I wonder if we can add a pcs->supported_interfaces. That would let me
>> > > write something like
>> >
>> > I have two arguments against that:
>> >
>> > 1) Given that .mac_select_pcs should not return a PCS that is not
>> >     appropriate for the provided state->interface, I don't see what
>> >     use having a supported_interfaces member in the PCS would give.
>> >     All that phylink would end up doing is validating that the MAC
>> >     was giving us a sane PCS.
>>
>> The MAC may not know what the PCS can support. For example, the xilinx
>> PCS/PMA can be configured to support 1000BASE-X, SGMII, both, or
>> neither. How else should the mac find out what is supported?
>
> I'll reply by asking a more relevant question at this point.
>
> If we've asked for a PCS for 1000BASE-X via .mac_select_pcs() and a
> PCS is returned that does not support 1000BASE-X, what happens then?
> The system level says 1000BASE-X was supported when it isn't...
> That to me sounds like bug.

Well, there are two ways to approach this, IMO, and both involve some
kind of supported_interfaces bitmap. The underlying constraint here is
that the MAC doesn't really know/care at compile-time what the PCS
supports.

- The MAC always returns the external PCS, since that is what the user
   configured. In this case, the PCS is responsible for ensuring that the
   interface is supported. If phylink does not do this check, then it
   must be done in pcs_validate().
- The MAC inspects the PCS's supported_interfaces bitmap, and only
   returns it from mac_select_pcs if it matches.

Sure, if the user says

	pcs-handle = <&my_1000basex_only_pcs>;
	phy-mode = "sgmii";

then this is a misconfiguration, but it is something which we have to
catch, and which the MAC shouldn't detect without additional
information.

>> > 2) In the case of a static PCS (in other words, one attached just
>> >     after phylink_create_pcs()) the PCS is known at creation time,
>> >     so limiting phylink_config.supported_interfaces according to the
>> >     single attached interface seems sane, rather than phylink having
>> >     to repeatedly recalculate the bitwise-and between both
>> >     supported_interface masks.
>> >
>> > > static int xilinx_pcs_validate(struct phylink_pcs *pcs,
>> > > 			       unsigned long *supported,
>> > > 			       struct phylink_link_state *state)
>> > > {
>> > > 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>> > >
>> > > 	phylink_set_port_modes(mask);
>> > > 	phylink_set(mask, Autoneg);
>> > > 	phylink_get_linkmodes(mask, state->interface,
>> > > 			      MAC_10FD | MAC_100FD | MAC_1000FD);
>> > >
>> > > 	linkmode_and(supported, supported, mask);
>> > > }
>> >
>> > This would be buggy - doesn't the PCS allow pause frames through?
>>
>> Yes. I noticed this after writing my above email :)
>>
>> > I already have a conversion for axienet in my tree, and it doesn't
>> > need a pcs_validate() implementation. I'll provide it below.
>> >
>> > > And of course, the above could become phylink_pcs_validate_generic with
>> > > the addition of a pcs->pcs_capabilities member.
>> > >
>> > > The only wrinkle is that we need to handle PHY_INTERFACE_MODE_NA,
>> > > because of the pcs = pl->pcs assignment above. This would require doing
>> > > the phylink_validate_any dance again.
>> >
>> > Why do you think PHY_INTERFACE_MODE_NA needs handling? If this is not
>> > set in phylink_config.supported_interfaces (which it should never be)
>> > then none of the validation will be called with this.
>>
>> If the MAC has no supported_interfaces and calls phylink_set_pcs, but
>> does not implement mac_select_pcs, then you can have something like
>>
>>     phylink_validate(NA)
>>         phylink_validate_mac_and_pcs(NA)
>>             pcs = pl->pcs;
>>             pcs->ops->pcs_validate(NA)
>>                 phylink_get_linkmodes(NA)
>>                 /* returns just Pause and Asym_Pause linkmodes */
>>             /* nonzero, so pcs_validate thinks it's fine */
>>     /* phylink_validate returns 0, but there are no valid interfaces */
>
> No, you don't end up in that situation, because phylink_validate() will
> not return 0. It will return -EINVAL. We are not checking for an empty
> supported mask, we are checking for a supported mask that contains no
> linkmodes - this is an important difference between linkmode_empty()
> and phylink_is_empty_linkmode(). The former checks for the linkmode
> bitmap containing all zeros, the latter doesn't care about the media
> bits, autoneg, pause or asympause linkmode bits. If all other bits are
> zero, it returns true, causing phylink_validate_mac_and_pcs() to return
> -EINVAL.

OK, then there should be no issue here.

--Sean
