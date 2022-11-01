Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FC2614A29
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiKAL7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKAL7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:59:31 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80078.outbound.protection.outlook.com [40.107.8.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3D8AB
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:59:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG43e0VvoWZnhen3DKG30/T+AI/FCHq2/mCo/DIhbljqzu/p9dUFMdRyj6nzxaaqwDZbdSetMD5JLOEEYgCMe8plD24lAsroMamX15wY05UGCHMDcHqufFHwTvO1jos64TQTUc9vUe/kPrHOwz5GEp6NcKW9wntXdyV/Ieu8PiqWv3JIB1D9K5QzWX/3lEZocMHC9r3vvoLpQkp02P0K1en0ewLdQcphbR4GvUq7kZo67cvwFiFYTuq5GWGjMjxExN5lLhaVDMSu2vJ8zUmYUO1bxEwLIT8D33qiCtEYmxt1mVDDw/jmaNA1SlyPqkmYG2/kko7bxcT6Z5miHzbzaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qiEcuGI2he732yOW7xlR94fYbbtzF7gSXQBaIElJ5k=;
 b=N++qQ4CPZeTYFLsb5qaR4Fm0QwELNmDlRSrmjpd7KCO2l38knVui6+Q6BNN8EsqZbqD8emu8S+VXa2c2oLz3U9ImvoGgGzpY4ZbTiQ5RJgKfedcFkCi32R/CxQ0s22mjCjrfoP2H6gkby+HoQm7cpXEeSghXLLZ+yWpqDDJ+CcFVfSNB3LVWEZWVw6OwFqYZFcgIgjYLSB9uyDx/keTUpot6LEnW6ueA7mZj73j5+P+w6Mm3xesXoSPZ3LV2UPbxGZxIt3aMLXxKHMxTlIFtKklEHW8KBqB8IoReMmJdX7unh+8F5XUMowiYiq2D9FmI+NEh91iY639wuIJBCjZzMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qiEcuGI2he732yOW7xlR94fYbbtzF7gSXQBaIElJ5k=;
 b=SytGnPwyZS5Djzl2xX0V8GxCXBpuyyReBCvJ/MzpAmsHXGYLZVIOxtOuMCMx3risCknflXKmSZlG54U6/AKwfdbFWF1w5Zw70rVOwTH5h/bGQjeI03QgMP/IkRWwV8fa5eEgnuD5ajmaoaAK4vse+l3ar3+7g8gXOybIJZOuadI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7604.eurprd04.prod.outlook.com (2603:10a6:20b:287::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 11:59:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 11:59:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Topic: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Index: AQHY7efc5i1n/1Oz0kGxX/wEp9VJma4p9viA
Date:   Tue, 1 Nov 2022 11:59:27 +0000
Message-ID: <20221101115927.pqg3levft55ysz5f@skbuf>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
In-Reply-To: <20221101114806.1186516-5-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM9PR04MB7604:EE_
x-ms-office365-filtering-correlation-id: c42bb8e0-717b-42f9-b2e8-08dabc00871d
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ce8uWyarFpxlKiByuJkTZZiw9gp0NHSQYuE7L9N0PEXbPxlc09+wuUJxv8RwLoV+IJvvRaoc+FNoKHm02jfiDZA/+QT5vI3Mj6dfEec6PH5y3kt+hblPT7f/EFLNX5BAk9DXxBZ0L43438tYNmjIRESJzVcZp/Fr4ANsG7vanTNSOmKcpEO4W7qT+SJOfPDO8qqj4XCTkYpbcOnUfXw8SR0o+okwf4lgX8+UxR8YRTgPbpLxslQQ/eqC1TteGMyQ6CRrapuqNHEt1Xp3XNftZ1Sle4uZwqKMgz+uimobtGeVDfxzxq2zf9IaPi9jcSacBIbh9s9uDRfBaxP8J8YlYG4kuUMB8KU1RTqExY5qzS60FWZOMVcFzrQjKgLD2M0igZ9m7wfUCJuw1CCgvGbVYXlvYzwQJnvQMSPnM2Hl5k0xLn74dGuAKSvn4BfTFh9Te64k2oONHplVmMPN+haW6va2amBDE72nUoY87oUSy8mlupfCF+Prc0UGWA9/9IUWogXBwGtc8ipmEFsd4/hplxbBo6ilKBgS/ocMggkz+7gEbtti09Se7BlLb5s502T8QF2gTblH0U43A99fQhDNQIjpLbKht+4MbXYBuZZGTn+bfp34OT1gYXk/fib8R7tttgq4GZROrQ765kg43WhxgGSUNfKrG8Qv1Fg01OMUYNzvHWCEaRWVT9szmR8yv3LP7xGSiz7eEepkoSyE5kpPouQWQbQNB6zTNbgcpiX/riO6h4U4TphtoAxyW159Xurw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199015)(41300700001)(66946007)(66476007)(4326008)(8676002)(64756008)(76116006)(6506007)(66446008)(66556008)(54906003)(6916009)(91956017)(316002)(38100700002)(83380400001)(122000001)(26005)(5660300002)(6512007)(8936002)(7416002)(86362001)(9686003)(33716001)(186003)(44832011)(2906002)(1076003)(6486002)(71200400001)(478600001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ke/SwhCKhDwGHvjW1zkC8i7HOiEtfCTKznkHjLwl/c9zKougHEt4LtXHo2Wm?=
 =?us-ascii?Q?DDLrDbtLaBHNr/IwuVrBRmkuo4sDABUkcnRyI91V5USrmyffl203aLv0XESO?=
 =?us-ascii?Q?8HE7wS90jd9b3txJ2r2AfvcesnaEmmnzRo8W5IOc0k2KQY+xOPp/ED66fFWE?=
 =?us-ascii?Q?8wV5VGsa34eA53dIB0SZ0lx6zaJYFNcH6y8Z2IVeUVQ5ZrnUaeZdxkOwePVg?=
 =?us-ascii?Q?CXRa99PDp+Dn0Vtwkk6FeSVDAW+CuiCYphwDaOXP5gdmW7CZy4b4SSYXseED?=
 =?us-ascii?Q?P6w5SRURWXzlZ5si2/QweTYMdCl8a2ovNmDIK1SfUepCL78Mln3B6E+7YNIn?=
 =?us-ascii?Q?14M1Cc9ZSSSe3p3F07m+1U9CYJ0wV58DLIbq04sh8YFHFKUx7IlfhomzMrE1?=
 =?us-ascii?Q?L0gtx7ahQiAsBlP0Z7AhGC+OrPOacKwEf9RTPDX5M4y5oIufHS1n9R/M5axh?=
 =?us-ascii?Q?ICdiZ+/GTFDQi5XDBhbBkzhRcfZ0EiGJIsebpxCh3RZ2XArOfLSZkcx3Gffd?=
 =?us-ascii?Q?hfKSEhbYGrnpCGKFlr5AgNXYIzGMEcqiiGUAK67zdqUtJ8HZCQuUMCGVCywb?=
 =?us-ascii?Q?Hd5kqpcEqJ/yFJArDTFWeJExXmVgnLQE4SUNjyb9MQ4Mi/PJnDwDhJvw3j/E?=
 =?us-ascii?Q?QgRDDVDdVzHdFStqqpjjGiqHTm0Z6ux9iHeT19MMva8ITSEqeTpoHz7+689I?=
 =?us-ascii?Q?9S1DWVH+1rsHbPvrRF0Lr/mmQpX30lcCdB/E8uH4vb6Eak9a81y4IakuzZb2?=
 =?us-ascii?Q?RQq/6lHbQ3fm+K0v1N2+7o0UL14zgiXLCj0XZzM1zaoIcdqXDTQxKa6Gn7Mt?=
 =?us-ascii?Q?nWyhh2dPRZSCG7CKZKNbcxmUNz8X7RSVy2kOWbGDY/iol11j1WpL2ZxMoQ4D?=
 =?us-ascii?Q?xPjv5DLsviwwIQ1aMcEAGXv91CHXtrlJMyTxeeyDB06efxyhJfgZwE6wx/+W?=
 =?us-ascii?Q?iRBERRxHu1hZUPQ907OtfRAgRAFxwCTT1waRGHFMW4T5A0Z2lvQTRkFWMeUP?=
 =?us-ascii?Q?ymUahUwLBloWgY+yE4ScgteMBZBiTNZ0ZgyWW0RT7B+1v38A6k+EhcJFEvTq?=
 =?us-ascii?Q?UMEzop1A6E6uI0TnK4HHmq98i0MvCKTrOH5Du9HYRSLKDkXgGCcAYTpBYlv9?=
 =?us-ascii?Q?ewwhbTbjDCaDoFMNgFzf708SBHeSL2PoYAs2fFDTi0njIXGXH+GV6tCtfAAU?=
 =?us-ascii?Q?iBI4s3AYUkTw7PEcqhrMWkQH1SwajnY5z0L9Ad1gRB4otG8LMiibPEHXr3s/?=
 =?us-ascii?Q?+XgR5U/JXxKShDt0Ndrn7bs3OuV8AbKnV5gSP5d0rl80WLEk7PeK6gsgQJmv?=
 =?us-ascii?Q?G3KYWcXRpFLPoA8aFJAJw3nLKR+jJz6OozbK0I0Zv/2B6HPpJzZ/ADF8vUud?=
 =?us-ascii?Q?xQuwpLCKhHi4Bds5xUCKEQroPAOcdFUG2WajVbCAjNZOUa426DE0NdFXj5HJ?=
 =?us-ascii?Q?9ZL0nQhPplzLVZ7eS20DY1lLbu3khxMf2+3vvHvjLW2c3xD56YsXVs5uvg2G?=
 =?us-ascii?Q?5BaDCwDm2s5erxRiF2RsGDAclLQcL6oPoaNbPRte875Qffeyt8NYTMSbMnh2?=
 =?us-ascii?Q?oToIvej793yHn7+Nizn245kMjPEPQYp/Xp/fgpmcje0wt5yAAgffH5/XFAj9?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6EE40EB70F178742B006FD159EBAD8F8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c42bb8e0-717b-42f9-b2e8-08dabc00871d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 11:59:27.9082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: epPP3HddwIOj5tXsJfQRCKs/TrtNV1UX6zvbjRSbFCTfbHau03ubn88ui0PMp15g5oMbiOhpwURNvV7a2p6w5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7604
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 01:48:06PM +0200, Vladimir Oltean wrote:
> Not all DSA drivers provide config->mac_capabilities, for example
> mv88e6060, lan9303 and vsc73xx don't. However, there have been users of
> those drivers on recent kernels and no one reported that they fail to
> establish a link, so I'm guessing that they work (somehow). But I must
> admit I don't understand why phylink_generic_validate() works when
> mac_capabilities=3D0. Anyway, these drivers did not provide a
> phylink_validate() method before and do not provide one now, so nothing
> changes for them.

> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 208168276995..6e417cdcdb7b 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1532,22 +1532,6 @@ static struct phy_device *dsa_port_get_phy_device(=
struct dsa_port *dp)
>  	return phydev;
>  }
> =20
> -static void dsa_port_phylink_validate(struct phylink_config *config,
> -				      unsigned long *supported,
> -				      struct phylink_link_state *state)
> -{
> -	struct dsa_port *dp =3D container_of(config, struct dsa_port, pl_config=
);
> -	struct dsa_switch *ds =3D dp->ds;
> -
> -	if (!ds->ops->phylink_validate) {
> -		if (config->mac_capabilities)
> -			phylink_generic_validate(config, supported, state);

Ah, I think I was reading the code wrong, now I think I understand how
phylink_generic_validate() works when config->mac_capabilities=3D0:
it doesn't; it just wasn't called by the old code.

It will be called after my patch though, so this will break things. I
guess we'll still need a "custom" phylink_validate() which does
something approximating this?

static void dsa_port_phylink_validate(struct phylink_config *config,
				      unsigned long *supported,
				      struct phylink_link_state *state)
{
	if (config->mac_capabilities) // avoid breaking drivers which don't set th=
is
		phylink_generic_validate(config, supported, state);
}

or what else would be preferred?

> -		return;
> -	}
> -
> -	ds->ops->phylink_validate(ds, dp->index, supported, state);
> -}

In any case, please don't merge this as-is, and sorry for realizing the
breakage after the fact.=
