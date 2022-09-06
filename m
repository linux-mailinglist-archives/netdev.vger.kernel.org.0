Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF715AEE34
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiIFOzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239682AbiIFOzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:55:07 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-ve1eur02on060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe06::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A49A4B0B
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 07:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIJO9OVPSGaAwOxnryjoH2Og3KIm4eBVqkmLucP+jVw4O4JfHmmPcxTfaeoXWeN+01jb+RomGls71Eehxz0yQbdXMWIDDdW0MyM5iNnlCX6gUDAAkM2b5Scj2M8Csl5JYFbUBbrpcjmfoOdbRfpIBL7sf+t/id5MFF45pis6L+RqCP7H3LZfFdY+1m11eN+nNV5l+hRkLwTCCfTBNGuUvVN3lAntHfawPMBsZdKkKjf+hRCjZNZaanhho2Lv5F7srSupkr8ZB1W8rIosQ55ksEfxjx7a9QyD9U2pepFJMa+YyG9Gsh2vTCJLs3pgaqCRmBnOwk7h0jcVeOZ+dtAttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5fIfTH+uktsgwh+9ZGMdQPLduFcj2I2CMIjFQIGeP4=;
 b=k77ONTPWtMPkA5InthwtRWjNpM05AdzV8KIBnvtcTSOGmNGanimtufSa/KrhF1ehalgEBxk/Bz5wFMXNmQeSuVk+PAQS3gijjmEz9+M1aFTxVbotKm4oY1KWDP54Xfp0Lqq5wpT17dRJIaNp+tA8O7/Uuz6UgQLW39RVL2WbXOWXQN4Pj6dR0trm3rw21R1t1E103Ya1FTC3WVBsZt2XykSkuk2Q45dy1+GmE68/yyvXrWQfn0+/5MdBog0yUdzGcfWtmd31zJpcNSoZoUULS+HfUVO6HMsmKPTApSvqEyJ8HScWX7ECuOOCKdSzlLzM9vU/vaOKjFoFjGWI4coDFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5fIfTH+uktsgwh+9ZGMdQPLduFcj2I2CMIjFQIGeP4=;
 b=nxEUVjV/N2htI3RbKUo2JICV8J+Zj2ph2hrUnY/W45ZJK0M44Pvf3lT6VvVrMAFW6mCR+2C3+6+hY6UMzN3igPuU5/pDK+77J34XKIzlG0DrBOkO/jg+VBYfpZ45X6c6QAVoeFQJNx3gkLJztLAFwnr3VLm4dksIm4ajP8uNbvU=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DB7PR04MB4379.eurprd04.prod.outlook.com (2603:10a6:5:34::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 14:09:35 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::b9df:164b:d457:e8c0]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::b9df:164b:d457:e8c0%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 14:09:35 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net] net: phy: aquantia: wait for the suspend/resume
 operations to finish
Thread-Topic: [PATCH v2 net] net: phy: aquantia: wait for the suspend/resume
 operations to finish
Thread-Index: AQHYwfFP91zpDKqPzkuCbkKiI1MEpK3SYFwAgAAQVQA=
Date:   Tue, 6 Sep 2022 14:09:35 +0000
Message-ID: <20220906140934.vtxddfvtdlom563l@skbuf>
References: <20220906130451.1483448-1-ioana.ciornei@nxp.com>
 <YxdG6r0pF7NSW+EJ@lunn.ch>
In-Reply-To: <YxdG6r0pF7NSW+EJ@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 333433c4-65ec-4dee-af56-08da90116da3
x-ms-traffictypediagnostic: DB7PR04MB4379:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EnZieU0jvhlftOSoto5yPA9olQ6ylLgvmXGHSRGigMYN13O0bEypuulfq+8qeDFvp0Tin3aIKkZ3gm5rL4z/cN6V77NvOtWBiVJMBWSNZCzyp+vBmVpAeMo7ucvv0W24kUSPhLWRjGQfE5R95wU3gYHhZ5uRiWcgxEZ14VSs1CWcioHrMnl5eO6sa3Wnuh8evuCRmv+FSTZIKujuz7zsSVlsZ/Sn7K3dZf/1KLv7FT3ZtKUK4fmbHQ1G34Rq9ooSCRp7Ye4A/7hkYtFwPXUX7RR4iBGPwNp6h4wjzVx+UWbUbToES+qJcoLJC/hyzaM69dQVk3OgE8Ap3SoP/nkIjeKuJjfQH48MiZ+eZGCpr+WXFtdjw7sZIiHJazl3n/Wae4fyTzimhrgoI1vn0YETLWA9TCjwBYgETDvyAQ2/q8TScxYZ7/x9xY+/S/GL4tfr0HLKj2mcGgdSoaGtllPkJ5bdkJ7Y3vSNop60ld0h1nTzRYjoZREJL2ATMjI8Ernss+ja4YNXEog7r8CcqUnhtdre55iFBYExVTGnREy8nxFqzK0Yb43K1z4VtTjYayp9GMbHoA2jS+1W7OVTMOyB2J2X+ANJi1jAmIjDjrtO0L8h62q6xtr8VuKbG2Eb06MTPZHk/DY/RMyR7JqU8ePploodNL/viaKzAkiKRegvrcA6YGddqRYLauaKLLo+tpFHfuNJxYgwlE4Fiav1BhyzGc9YfjyV0uP9pbKEarnkqoy1IiiQuxZWgv88YMbZuJEKkrA1khstzk2B1jkXiX2j5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(366004)(39860400002)(396003)(346002)(136003)(316002)(44832011)(5660300002)(91956017)(6916009)(66476007)(66556008)(66446008)(66946007)(8936002)(2906002)(64756008)(8676002)(54906003)(4326008)(76116006)(478600001)(71200400001)(41300700001)(6512007)(9686003)(6486002)(26005)(186003)(1076003)(86362001)(6506007)(38100700002)(33716001)(122000001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VC4rpmMFxzwm+ZH4vb3Ay1l9sTlnFYPHAdcYXOz+DMdrMzVePyhZNf86NOs3?=
 =?us-ascii?Q?81gOGqNyc0uptQOYor7jrrg7cmaTr3bz+luAfO8/3syHgUXmr2aBuhCnHOjk?=
 =?us-ascii?Q?kzPJkg2T4JdFyrwz2ZC66rEOlxH6N8rk350ZhEdF48Fc1SaRw/8jI1jKcwyA?=
 =?us-ascii?Q?S/af2CGSv2EAUH8YSDqNVKc/pjL/KiqPkbH6Y1F8pYB6olIiPl29XFA/+MjT?=
 =?us-ascii?Q?0VG0HKdf9jA1iSAosvvBsd6q9wTBzr55JocxYXqyk92GVivpsZRZCU9tOfR4?=
 =?us-ascii?Q?cDIpWf03DQSJYYVzdTlroctLxFSaM+7N+icCzuEsdZ/yljmRkv+s5HBM7P8T?=
 =?us-ascii?Q?i8elUcI5C8fjxzH/044nTLgpdtLwahEI30W0i7tvTkfH1KWbpMNIbymXIx2F?=
 =?us-ascii?Q?6MlrS0h7ZbzbSJaH+4u6vBRocqURhF2mQacSnHcPJ2iIElIbbO1KMaJiO5xk?=
 =?us-ascii?Q?FXhCaaYCzEpiFR8/d7YbJz78FvGHMNY0juC7xy+HDuTevP6VNLyncfuZoUCP?=
 =?us-ascii?Q?1Hbihltz/t4pDoDo7POt0Kbbw1usbE5rnmBDBrwmIzslMtAd2Ek7LE+OvI3Y?=
 =?us-ascii?Q?XNwYCAGcVtxlNyAiQTOnqmg8R7BKgVoqYJSoKoUsEi1Ijnp9thctqzVLVB/b?=
 =?us-ascii?Q?cZy9U5syxbfLrgLZL+s6NZYoGEFsLF4PUexTblnR9UMlkS1nGZcI7VqODGbJ?=
 =?us-ascii?Q?4naw6es+DEs+dLTnEoUHNvPBHRTVIbZY8udXnXSTBmkJJlDTUMwjJ5aLaYkh?=
 =?us-ascii?Q?r8OEesGPpHpHgi9ymhV8zCDRUXTmihL/KssPQyppZ/vI+Y4ra/bWNQx9IdGI?=
 =?us-ascii?Q?bDM4zwNTj5G/p+W1QZbQm2YmpoMa6r2+0rateEeeFEgdAdUbLldk+957ZOMw?=
 =?us-ascii?Q?TWqTwRtQPKJQX7nr44OaA7WogMwDJKBk6m92iU2jmwYlSW5yAnFT+OBZODun?=
 =?us-ascii?Q?FzDdoG3M8+/gD2f5unp/i0901lEsKUsVCyiMsVxvMk+/xDxMSZGCoF4UIURB?=
 =?us-ascii?Q?FhhVU+LepRcGUBo4CQoVL29frV1/TWvhxLCbYgb/wrHauVBMXJqHBn+18i4K?=
 =?us-ascii?Q?hxCxqqimFLre6jlIEhijFe2VOljQGa/Er8IruuykZiryKjmQ0kb51Bcssg5O?=
 =?us-ascii?Q?fKeR3fzZoYmjo1VMWKjGelbvP46JL5mIGlkfWcmJMm2WPmsNTRpRw4NrKZFP?=
 =?us-ascii?Q?GmzzEG7dWYBxZ43/B/IIfbgUQLgbLv9NVtt/EO31CJR8MGv56TCKevcp3sr4?=
 =?us-ascii?Q?JoG+57o4zMXhx6NSiTBytFKkzhHFL9CBlwpn+nqJaEeCQ2G0ymvuPCxmtk1K?=
 =?us-ascii?Q?7g5pzhcuasX5Ixi66ZFFhp+f3lelzBWu17YQzTKx3A+g2h2Y0Z4U6aNLmnM8?=
 =?us-ascii?Q?Ej+q4Y5+KWaYcClczSW0zXa8a40rvsUQVpggiUzn5zTBTvmM380pBFyZHCCA?=
 =?us-ascii?Q?QGX2Ia0ldX6DBrNl0V/ozoDKzifvLKjxbAT6jDgL7/y1XD8aIihdYT4hzQ+v?=
 =?us-ascii?Q?3bQBLyeWsDKV5YOQFupc/3/8iPHJy8NXEIzbvrI9lUCop4kJHawdQMJNh+05?=
 =?us-ascii?Q?kM1XqOBNpwliyaLBcXTZvaB1jjxB0V93ixLmOaGydTOzJJnLWktN+OqK55i9?=
 =?us-ascii?Q?zA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ED15E45A5EFFA3469016A199638B9AC6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 333433c4-65ec-4dee-af56-08da90116da3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 14:09:35.4165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LcCG8kYkn05kvsY6cVvXJEA1qbC4seXV7DlF91FJtBTU34taexuK4xMcjVzMS4Wp1Db8wMjzx4FzzIpdRoQu3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4379
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 03:11:06PM +0200, Andrew Lunn wrote:
> > +static int aqr107_wait_processor_intensive_op(struct phy_device *phyde=
v)
> > +{
> > +	int val, err;
> > +
> > +	/* The datasheet notes to wait at least 1ms after issuing a
> > +	 * processor intensive operation before checking.
> > +	 * We cannot use the 'sleep_before_read' parameter of read_poll_timeo=
ut
> > +	 * because that just determines the maximum time slept, not the minim=
um.
> > +	 */
> > +	usleep_range(1000, 5000);
> > +
> > +	err =3D phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
> > +					VEND1_GLOBAL_GEN_STAT2, val,
> > +					!(val & VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG),
> > +					AQR107_OP_IN_PROG_SLEEP,
> > +					AQR107_OP_IN_PROG_TIMEOUT, false);
> > +	if (err) {
> > +		phydev_err(phydev, "timeout: processor-intensive MDIO operation\n");
> > +		return err;
> > +	}
> > +
> > +	return 0;
>=20
> nitpick: You could simplify this to:
>=20
> > +	if (err)
> > +		phydev_err(phydev, "timeout: processor-intensive MDIO operation\n");
> > +
> > +	return err;
> > +}
>=20

I would prefer to leave it as it is. I know that in this particular case
we could spare the braces but in general I am not so keen of this form
since if there is more to add to the function, it would force us to also
re-add the return statement.

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
>     Andrew

Thanks,
Ioana=
