Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFE65FC2C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 08:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjAFHfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 02:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjAFHeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 02:34:44 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2107.outbound.protection.outlook.com [40.107.113.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDE472D3D;
        Thu,  5 Jan 2023 23:34:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZgnZKbNTyrYwmdKtSlFR/FknRa0peQtm+QGNHPdEcWGFm59MOlAdeXOC87T+e0qk6M0wwXg2npUb1VZUYNYGVx2ba+4h9V+WO0TKr9xUIQwEB8Jaj+4OXwBqRAGHm73IZLNb8+WbKwmDTMxL+icMdukj4UwNnsOMFuzRnZMB+AaFsBldcwa28wTmtsRQ2vLbV2p7tvBZ2n9VhkEXQf8jwjzQFyMNF7T509eD4N0kHJ1gsV0z0vydzhl1AMrmEw79BYxruZM041CfQIw4Cofa2VPCxcdtllu/GmVuyl+jqK09VDy8t3nx2uCutjfXRotR9aF0NM4CsTSxb52OxriyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCwa+9ljuIWw/NbOqbkuKtRvdAxIFTyD6TLPFardCsk=;
 b=OyeY9u3b6KrWwkoggS7jpua5FvXaJo0XpKdigkDvlaPBRl+iiUudodP2AlqngTwo4tikuL0NSj2EsBRnAKJaPv5xWAhkcnYa2ReFmmzOgA8o0kmNaKJTFGQPyg3rEF/OaPRsStcr0K7yNR1ZZ07mK/bexZuYbPG1CylwEuLCf0g30N1RB0THruwPbPC8HX3l3yp2SSgSfBoYat5YGWQzovDqLXurKiDRQcm+ZyfhuJfPLttXyDUJkhRR6chk/wJZ3ci6PKiKoAm5i+7bPFInwmbyNQm5lu8Hzd9Db56um32SO2luRbnHc3y0To8mTwpmT5OtMK6+XrqFWxCBXly5mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCwa+9ljuIWw/NbOqbkuKtRvdAxIFTyD6TLPFardCsk=;
 b=YkVnU53cEBLLUyDdi8kvYOx9K+MwHHGdE5yUfTa5nbPbaBIJ3UePkUqMuKINjIfHdvRI1AChv3eHN03S/GImKuNNcYOEQXAyPmdDMxkCGWT+rtq5D0YIFjVSi8swMBmzTRwrhnezUllZxW8nB98fkohzQBW1EgNJl16f43zAvY4=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB10065.jpnprd01.prod.outlook.com
 (2603:1096:400:1e2::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 07:34:38 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 07:34:38 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Thread-Topic: [PATCH net-next 3/3] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Thread-Index: AQHZGPm1/+eneNmBlU6Hj6ptyK83kq6MgTcAgASLkVA=
Date:   Fri, 6 Jan 2023 07:34:38 +0000
Message-ID: <TYBPR01MB5341112B776054C9D1E0FE26D8FB9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com>
 <20221226071425.3895915-4-yoshihiro.shimoda.uh@renesas.com>
 <Y7P7sJk4PZ1eLWDZ@shell.armlinux.org.uk>
In-Reply-To: <Y7P7sJk4PZ1eLWDZ@shell.armlinux.org.uk>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB10065:EE_
x-ms-office365-filtering-correlation-id: 3c44aed2-c64b-440f-679f-08daefb877b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3O2dOdyXbLqqUnqSl4/soQ6h3y4X9erAvytL5NwQRVjCiSjrzTCV1kFnPy+rj8twBtMZ2tgPFRUjlXdckpQfP3k8N37Rkwe8MkDABZUQOO8e2M9SaojbVeuXmV6FpBuRN9LZW5UafTkbhlfm0JgRWBr/+hWD1S+nxYITiqcUOfAoUz/6+GKwb2FEx55b62bPovZMKjx08tBKMY+9CE8sI3T0Y+ZSUQ1TPhgI6R3TFppGn3QReLmhbhhY0ERAJZpCm+o8oRyW5aeVniWflkMr12XjzvhunUV5ShU1fDbH+4IciLMbYxsfI0DZ5wMYgjbxRo7KnwQYSJS4BEHVFohOnUPBKpHOIrYo7zo3COsndUB0odSmiYLSgZ/phgwAyZdtUUD0Gq8n6hTOuR9zlPXxYScoSEvNf+mqnbYQEBft/0bA+at4wy1Dgng+3CP7Wv8oZ5kmVbeehcUQ1whNFNkcpaJYLCuPBU9X69yRiIWhe7VLi7cCrh2q7h0iTVrHK2vRNMaa0wHGe+Pz61Syoyzad13oQeVyK61ax5TwI6gK3YceDTfRiVlelpA2kmhSHjseo9I83AZtjfpQzsFcZQrPITwbcl3IRZgG0pMnIPZcNzjxfBUVErRodaCkHizGP/iVbQCJ7+8iVcj7IVUQcHtyvQhkNfCH6wRLFDezUxb/ZSKUd2tX8R2GXAnRFVXF5AghmDpSrswU2v3AKkDSLPeZtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(33656002)(2906002)(38100700002)(5660300002)(8936002)(122000001)(52536014)(41300700001)(38070700005)(86362001)(71200400001)(6916009)(66946007)(54906003)(66556008)(76116006)(478600001)(7696005)(55016003)(64756008)(66446008)(66476007)(26005)(4326008)(186003)(9686003)(8676002)(6506007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0mujy4BP5TBNbkbzIZVUYltNxqek8jLZK76BaEqElaVscqdIAhgfbWWPPL4a?=
 =?us-ascii?Q?whbkndAnxdoI96eeBFbquMuYdgAMG8YMBrR259IhL0aPMtoqwtcWHoZy68pJ?=
 =?us-ascii?Q?+Rbs8AdpTFtZow/ZmLvE7Lz+3VUwTddKMD+3DoFr+eRm8wO+/g+tWtc5VUGK?=
 =?us-ascii?Q?6JZXxoO1k0H1sAj4bCL4uwO8JCaR2HvGL/tKglgCOnRjYtSgHXKnfj9Ta0z6?=
 =?us-ascii?Q?ZDlqvZwq5S2Zrn7W1g9eeXMBhUBxUESXOBDcFgSYcOeDKZ1NBFI8M0bGQRLZ?=
 =?us-ascii?Q?Ptsd4yPdvlJk1lo0CCGxddis2F5HQhwQXICn7TidGFGGRnmLpngA7/7BUOqm?=
 =?us-ascii?Q?2KzG0o2Bq75Elq7J3sME6lUQjF4nyCQx0aB/CaV8VN5G8Rb6fx+GnZQtw2wE?=
 =?us-ascii?Q?fBM8A/qMNvDFjCfDI7w2i4KiHQeq/4gGs20W7ay/be+77UgRIw3YRcjVJ/uL?=
 =?us-ascii?Q?N1j/uBJKIse0cw8194RCvtQtqyrIJYZTFeZrNa8A9XHBSyfWpuEqzb4zMTWm?=
 =?us-ascii?Q?OsAdtlvCKkLCpHrEHpEc+Y9E/OHMMv2Gy7V1REXbjxWB9DCsKPd4ovSxeGE0?=
 =?us-ascii?Q?IMMhD7k9kR7Ransa6W0n5ZBB0nJ8EpNYbM6CIFgLjqLIsD9LfN7skYPEXFv8?=
 =?us-ascii?Q?Y4mgPyHuL0LbNmi/B0rJz8j8NSY2RtYEQKFim/kuAu0VXkxUNEkVlaknGH8+?=
 =?us-ascii?Q?3uE+jZCbv90ujDHtMk8j7OdJyFqjzrX5N8hyOC/OqT3pAc9RJmbNI8rUnhhb?=
 =?us-ascii?Q?pSgcZs2f7RbyTqdQuq72t0yRoGkyuj/m5v8gXG+gK8HEcSX1qbDVQgMIdNm1?=
 =?us-ascii?Q?wfY3ukmc8+vRxmlo8yvjBcADgtWxOQ7dylRBdonEf8VOWGDh1Rg6tU/IC5Z6?=
 =?us-ascii?Q?6ax0f8F3Zp4ddZAjNJRdm65+10anZRNU65ybjAHUbt2GlDGQ9Podpwkwu+qh?=
 =?us-ascii?Q?4mMoowoByWqyLLalNB/kk5wPtOXajZmlzqWbMDzZqxlrzshlXGyaC4+FDDa1?=
 =?us-ascii?Q?CKwc/j8yiCxl5Hx009y56QcjYnMz036XuI8USqkDQdNPFsmB4SM4Gk489d2c?=
 =?us-ascii?Q?EmsSDMDBPjjdFDkQRvdjcGGSmDuUMr/8KWomktWld3MySBRCUOtvBm3zWtR5?=
 =?us-ascii?Q?a4Pbzo79NdUNjQ8jZVCmsmo+SnmuY+DEX2ZZYKcKffN0KV1SiZhztgheEGDW?=
 =?us-ascii?Q?Ln7xGxcN8S3FnUeM0+Ew6HqoztbSCPVoHTeaQIMH4EF0yi33ODXBtj0w/XS0?=
 =?us-ascii?Q?HOlmtjw80h2tPVJHpyXJlJYMTigYUHcBx+S66tSC2Jbo3yEro9o35hQ1krZK?=
 =?us-ascii?Q?0r7KECT6kqk+ySzGsuOptj1ws/AyF0+zbBlIyDB7YMEmlZDWmhTTCIqKpYeG?=
 =?us-ascii?Q?8De+gQyTUpXHvIsLmSRgSL1n4yHArYv/aegJ6V6hjiZx2mdiQ98p30J2wktg?=
 =?us-ascii?Q?lqlztXm3RkEghT4TgLxs7x7vxBrPDk7cbpckMC7cY+jRsluFuuRilVBGFBaH?=
 =?us-ascii?Q?a/qRewFAlUD7wR1KFOyUd+cwBqScmCH5ImxBi8lZ7etcwzyPUDIcsWSTK7YZ?=
 =?us-ascii?Q?eXoi6RK8UPTn48bbz8Q4Xu8wHaa6Mkn7NzTJcGkxEriURTooaL1AjA0bDqcn?=
 =?us-ascii?Q?qQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c44aed2-c64b-440f-679f-08daefb877b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2023 07:34:38.7054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qz/sEUFYjnwZCmn0fbXIuPT0Q5CQpThXD+3LeFCfAsmLvQJ61AHNs8jfLxvwN9k0TTeYcbQ1dNnuR2igbRN2kiOqGTNlYOfY94b3YV1C3udgTofupaaht5xch+FZ8kjj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10065
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

> From: Russell King, Sent: Tuesday, January 3, 2023 6:56 PM
>=20
> On Mon, Dec 26, 2022 at 04:14:25PM +0900, Yoshihiro Shimoda wrote:
> > Some Ethernet PHYs (like marvell10g) will decide the host interface
> > mode by the media-side speed. So, the rswitch driver needs to
> > initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
> > after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver has
> > .init() for initializing all ports and .power_on() for initializing
> > each port. So, add phy_power_{on,off} calling for it.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/ethernet/renesas/rswitch.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ether=
net/renesas/rswitch.c
> > index ca79ee168206..2f335c95f5a8 100644
> > --- a/drivers/net/ethernet/renesas/rswitch.c
> > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > @@ -1180,6 +1180,10 @@ static void rswitch_mac_link_down(struct phylink=
_config *config,
> >  				  unsigned int mode,
> >  				  phy_interface_t interface)
> >  {
> > +	struct net_device *ndev =3D to_net_dev(config->dev);
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +
> > +	phy_power_off(rdev->serdes);
> >  }
> >
> >  static void rswitch_mac_link_up(struct phylink_config *config,
> > @@ -1187,7 +1191,11 @@ static void rswitch_mac_link_up(struct phylink_c=
onfig *config,
> >  				phy_interface_t interface, int speed,
> >  				int duplex, bool tx_pause, bool rx_pause)
> >  {
> > +	struct net_device *ndev =3D to_net_dev(config->dev);
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +
> >  	/* Current hardware cannot change speed at runtime */
> > +	phy_power_on(rdev->serdes);
> >  }
> >
> >  static const struct phylink_mac_ops rswitch_phylink_ops =3D {
>=20
> This looks to me like it will break anyone using an in-band link,
> where the link status comes from the PCS behind the series that
> you're now powering down and up.

Thank you for your review!
To be honest, I didn't know about "an in-band link". So, I studied a little=
,
and then I might understand about your comments. However, I still don't
understand whether this hardware (rswitch) can support the "in-band link" o=
r not.
This seems to need a special hardware feature for "in-band link" and
only software cannot support it, IIUC.
# Unfortunately, this hardware's datasheet cannot be in public for now thou=
gh...

Anyway, I'll add a condition which this driver cannot support MLO_AN_INBAND
to avoid a problem by someone for now.

Best regards,
Yoshihiro Shimoda

