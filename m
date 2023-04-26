Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D236EF432
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 14:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbjDZMVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 08:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240277AbjDZMVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 08:21:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DEA2D4D;
        Wed, 26 Apr 2023 05:21:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0ACs4GKigRVtB5eVDr6PvUnZ8aIbuwz6ZE6A94KHSqwBXDgx0SE8XSJ+jjg8HWBeHsFJYkOAYDq6YoObhaMUvAX+CmIeU2JRnVrblYWSpKLRgbUek8eTVWTPN4XF0UdFJtxUbCrV4FMfQ3cp80eDYVmSk7KKviYVKvCAgx4V6AJBhjkxVGi/A4rOB1vgEF8EMz/vFnkjKDn+RIFblIe23cBazFczQ2Cw0i0gfgWuFypQEPlFm3AFlm7eO1Keu0IImBRXFi9GLhNvm+RJuloKKo57n1GVB9S+sgTVAWPOigWI5512z14DmwQhxPAeMc9YULyLIM89Vq2HESERKaxyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ks1Xtyp2I75eeP4Dlb9p1Kc6y3+bEIAikIuodCyVkGw=;
 b=HhMHnSGXf6VMMT6ZMxgjnR3+VSt7QtgaGtffHSZCQ8pVf7gRS5Z8M8ks55yxxCKH+CAYyC1IMMGzcowjgX96M0tcBKqPkCqgVUVcGqGbj7M9FYgrPrnyaDX7Ub3niyDJhh9w95m727/1CFDYLGnMQ7f9nZW/5VnmClI3nX7QLi2OlR70PdjqHpco6v7CG6EkmpUqVlhcGfQoCi4pCc3Vi9tswKTE2bZ/Lvpj52zsK+9CEyLLICMFuiJ+fHFru91P3ut2on1WWEASx4hkKmP5NgUHmrKv4YVujNKYadeF40rorRMopKfLllutRXxZQOCJjC1kP9idbQSinikR4m6ytw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ks1Xtyp2I75eeP4Dlb9p1Kc6y3+bEIAikIuodCyVkGw=;
 b=NnBlGKnQXFBYv3waNgeqccAO1xXjvbbzXNAjpfb6Ujm3DCOx3Tu9k3IpoCutXHtysCFfx6LHrxKcMP3HPZCslG5NTvp34ygh5fScnTFsQG7QHSkRTlFyU5ONBRhUVnvhsKx9DNbJLgOKq6jhMfWqXO41yuxMKiFcmOlpzhwjogw=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by PH7PR12MB6720.namprd12.prod.outlook.com (2603:10b6:510:1b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 12:21:47 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1%6]) with mapi id 15.20.6340.020; Wed, 26 Apr 2023
 12:21:47 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "wsa+renesas@sang-engineering.com" <wsa+renesas@sang-engineering.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Subject: RE: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02
 with RGMII tuning
Thread-Topic: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02
 with RGMII tuning
Thread-Index: AQHZeCv6AGCFWckldUa9v4r2nKGr6K89cUQagAAJECA=
Date:   Wed, 26 Apr 2023 12:21:47 +0000
Message-ID: <BYAPR12MB47738A21AE76E4CDEE28DFFF9E659@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
 <20230426111809.s647kol4dmas46io@skbuf>
In-Reply-To: <20230426111809.s647kol4dmas46io@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|PH7PR12MB6720:EE_
x-ms-office365-filtering-correlation-id: cfaafd5d-4fa5-477e-a8cf-08db4650ce06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lSfTVVZC2bcviO6AR2pcvO1OF91QviSZ9ZhYby1DxfpnfGYgT9QHuiktlzdXRojQ2OkrCxwT6AcS35LBFZzwgCucQWWUWyHsnVd4uWogKosIVKpIjunlkhU59MBr2Yej8AccDKA//e8AnaPUb3aF+6wSmd65WwMtBM4+fb4pUdtHCgdL3J2EbQxOHYpLxkq/Z90nvY9W+pYMqQ0xTN5wJbbG/g8zhkNa4t+GDuDNme6t84aaQ9SXuwJlSHbxGkp/+cd1NmS7uvmDRBlTX3tfigmo/VEl3l15GCrNguZYSr1t8iQLC745IChpLY0HJpFpoScY/tKxEcj/H029lYWAjURpyPzxZU2f4//TGHnMkW9MZ74Nd0VUzfUlTmqoyh2AaQUkGfUGgcQmP2YqXUSDF2+neWg6/bqmvD0hxaWTFrCjwFhUaWvTeUvyfgEWBfVSjobKFLUXQqv+gsqiMN6ODhp05xxujMomA+EcwKSEI9utxW5+X0nNjTUH2hij9Ip7a6MTcK9v81Y0AEO5sSvdAWyen8qTqjhO4apnya4rAJYtHqNeOwl1SH6ChzRktWfNIUdLOsCkwiNmwV3v8UZY/xF2MlaoS+vSXBYHS3k25xkI7dyRst8E1tAZ3fyptj/E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(71200400001)(7696005)(55016003)(2906002)(6506007)(53546011)(4326008)(41300700001)(6916009)(9686003)(66946007)(8936002)(66476007)(66556008)(64756008)(66446008)(76116006)(26005)(186003)(316002)(478600001)(54906003)(7416002)(5660300002)(8676002)(52536014)(38070700005)(122000001)(38100700002)(86362001)(33656002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AOsRYKjrQTMJlrXbclRV0cz/ws7DQKqkgDzFdf8HI86I0z17YRxUWZPUmNPk?=
 =?us-ascii?Q?rw/Pz0dWpbDf4g1D/lQ/a2PDntA3V2W+vPvy9G3KRrI09uyiheSRwnpPDW7Z?=
 =?us-ascii?Q?lTjBVOdPrgY8Hgz4yQLHDYRnVw+zD9Eob8VPKJ8O4ufPYezK3gYiEBFwyfrl?=
 =?us-ascii?Q?yCqst0XcY/6hFjnGc7OFpYgeJu1uu0ouUSSNkV4eJZyXrO7y3tLfappONsSa?=
 =?us-ascii?Q?46U+ZAkEBcpJ2R7V01IML3FjhJ0cvjo5d6QrT5ii/Q5EgKOeBqLDASZ05TOe?=
 =?us-ascii?Q?e9pdl+e5gj8Z/hwZwKH3G5Y3bvmF4bZmF/nfOpuaWF538nOkW2Vch26NsPlZ?=
 =?us-ascii?Q?5LsqHaZwZ5PVkaUkytft6pKBtLW788UQvtEvfxNEefKVSmHCNhWB5H8QQ1Qu?=
 =?us-ascii?Q?7uFUY9rV0y1TafnEgOtk57qdUO5F7L2MIkonGfOvAuEmaRpaEWwKsJYgTBUY?=
 =?us-ascii?Q?zloizyCEd2eZZxXOoVZejUdfoAS9lDyehlcDX349IcHKr03HDpaQFTtoVqe5?=
 =?us-ascii?Q?MR4rZyGebNKeePtEznHZ3/kVtyT5PKY4LKiy8oAIc2lEoTRZGBcFmsTFIKN5?=
 =?us-ascii?Q?ts4utJBnVMo3TfzJ/1/16XYsqQlAm2HrOIHmqaDAUL7iK84E5qkq/wsRpEBE?=
 =?us-ascii?Q?Zfjt7bWPF/w3e3SYwpvGJ6mhAp2I10tKz/KO3+05xKjoSFZZ3a9DLbiH/7D4?=
 =?us-ascii?Q?tgBFWrM2inMUOtMbsYHDR3C9Bra/7zqnwtbzvynWAkPYOCRcGE98I+sAOcHN?=
 =?us-ascii?Q?2hk9al6dyNLMVeEQ2VmAqfVOhgrQcpWwdKLM1sq3vVdTcnIkX86qSylrQ83O?=
 =?us-ascii?Q?qDtUsldrIWBaU2t7DtWtXu/AtcmHb/SdwkDmbMjAA3LscKoG0Tvyf3N2rVwn?=
 =?us-ascii?Q?gS4NKJuUS6Y4FbHMqsCpiWECjTfexIPlwoY0mOolbUxd5XwzvPEWRzfNiCFt?=
 =?us-ascii?Q?6T2BzUbc+YWURm4pkHwkSoQgjxWR9bijnTzvT1t+70kp/rneJ+EOfaB8CEQA?=
 =?us-ascii?Q?cXaxN6kwL2d9d1h13h+vy9Nk9p6a93S9YN2Ikhs7VTeYU1xTmOqX2SQeqI2Y?=
 =?us-ascii?Q?rHtV9iUayUND2M9DjKkV4QOTTZIcyhfJddc36wjbcCbXGcnAwnqAMi+pw1rh?=
 =?us-ascii?Q?ZfyyXvht4yew3jDKDVh/ZWemai1oF/JquE76ZRYaflMhySFei1U/vhDkb48/?=
 =?us-ascii?Q?Jy4WrnLCQEOmAHotMEu4Wnf59EX7EB3X8+/AYDN3VAZXBEOACoM9FqQJBijc?=
 =?us-ascii?Q?5LHqVN5X0JVzxtm5o6NSoWX5Go+4t+fqG6a1TQHjRCRA6LyMis36W8+6adLM?=
 =?us-ascii?Q?JPcKHEumJ9muexbxdyJIdbLSNYI3I0Py/Ia/XnZ7AlEqi4ojpfSHZBJN/3xh?=
 =?us-ascii?Q?imBaliPe8UR/jfwOV8mZq8/cxGiZu0No44z2pkKzNNI0CTDjLpVIjaaulWTq?=
 =?us-ascii?Q?fZ94omuKdBap9S+NdPp0lnij6SprtTHJY8Ul3TeMGh5ieOk5oRKEWUHoi9Nb?=
 =?us-ascii?Q?ZtlChdYuyGerf66D5Huv/aepcF4BxfyyurE9PFgDAUR51d8nZ3ZtUvoxokNQ?=
 =?us-ascii?Q?/Jy7pJ++3rdgdm3M7WI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfaafd5d-4fa5-477e-a8cf-08db4650ce06
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 12:21:47.0749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: izUGSJThpOwmlZFdmRxjxdS1kPrKfIlz2XpaKRylnkraJMhEblyrbZgeM7SMkX/R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6720
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, April 26, 2023 4:48 PM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: robh+dt@kernel.org; andrew@lunn.ch; hkallweit1@gmail.com;
> linux@armlinux.org.uk; davem@davemloft.net; kuba@kernel.org;
> edumazet@google.com; pabeni@redhat.com; wsa+renesas@sang-
> engineering.com; krzysztof.kozlowski+dt@linaro.org;
> simon.horman@corigine.com; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> harinikatakamlinux@gmail.com; Simek, Michal <michal.simek@amd.com>;
> Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_0=
2
> with RGMII tuning
>=20
> On Wed, Apr 26, 2023 at 04:13:13PM +0530, Harini Katakam wrote:
> > From: Harini Katakam <harini.katakam@xilinx.com>
> >
> > Add support for VSC8531_02 (Rev 2) device.
> > Add support for optional RGMII RX and TX delay tuning via devicetree.
> > The hierarchy is:
> > - Retain the defaul 0.2ns delay when RGMII tuning is not set.
> > - Retain the default 2ns delay when RGMII tuning is set and DT delay
> > property is NOT specified.
> > - Use the DT delay value when RGMII tuning is set and a DT delay
> > property is specified.
> >
> > Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> > Signed-off-by: Radhey Shyam Pandey
> <radhey.shyam.pandey@xilinx.com>
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > ---
<snip>
> > @@ -532,10 +533,10 @@ static int vsc85xx_rgmii_set_skews(struct
> phy_device *phydev, u32 rgmii_cntl,
> >
> >  	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
> >  	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
> > -		reg_val |=3D RGMII_CLK_DELAY_2_0_NS <<
> rgmii_rx_delay_pos;
> > +		reg_val |=3D vsc8531->rx_delay << rgmii_rx_delay_pos;
> >  	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID ||
> >  	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
> > -		reg_val |=3D RGMII_CLK_DELAY_2_0_NS <<
> rgmii_tx_delay_pos;
> > +		reg_val |=3D vsc8531->tx_delay << rgmii_tx_delay_pos;
> >
> >  	rc =3D phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
> >  			      rgmii_cntl,
> > @@ -1812,6 +1813,15 @@ static int vsc85xx_config_init(struct phy_device
> *phydev)
> >  {
> >  	int rc, i, phy_id;
> >  	struct vsc8531_private *vsc8531 =3D phydev->priv;
> > +	struct device_node *of_node =3D phydev->mdio.dev.of_node;
> > +
> > +	vsc8531->rx_delay =3D RGMII_CLK_DELAY_2_0_NS;
> > +	rc =3D of_property_read_u32(of_node, "mscc,rx-delay",
> > +				  &vsc8531->rx_delay);
> > +
> > +	vsc8531->tx_delay =3D RGMII_CLK_DELAY_2_0_NS;
> > +	rc =3D of_property_read_u32(of_node, "mscc,tx-delay",
> > +				  &vsc8531->tx_delay);
>=20
> Since the dt-bindings document says "If this property is present then
> the PHY applies the RX|TX delay", then I guess the precedence as applied
> by vsc85xx_rgmii_set_skews() should be different. The RX delays should
> be applied based on rx-internal-delay-ps (if present) regardless of
> phy-mode, or set to RGMII_CLK_DELAY_2_0_NS if we are in the rgmii-rxid ph=
y_get_internal_delay
> or rgmii-id modes. Similar for tx.

Thanks for the review.
The intention is to have the following precedence (I'll rephrase the commit=
 if required)
-> If phy-mode is rgmii, current behavior persists for all devices
-> If phy-mode is rgmii-id/rgmii-rxid/rgmii-txid, current behavior persists=
 for all devices
(i.e. delay of RGMII_CLK_DELAY_2_0_NS)
-> If phy-mode is rgmii-id/rgmii-rxid/rgmii-txid AND rx-internal-delay-ps/t=
x-internal-delay-ps
is defined, then the value from DT is considered instead of 2ns. (NOT irres=
pective of phy-mode)

I'm checking the phy drivers that use phy_get_internal_delay and the descri=
ption phy-mode
in ethernet-controller.yaml and rx/tx-internal-delay-ps in ethernet-phy.yam=
l. It does look like
the above is allowed. Please do let me know otherwise.

I will re-spin the series using phy_get_internal_delay.

Regards,
Harini
