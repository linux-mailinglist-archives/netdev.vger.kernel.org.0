Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0229610E4E
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJ1KWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJ1KWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:22:48 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2125.outbound.protection.outlook.com [40.107.113.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9BD1CB530;
        Fri, 28 Oct 2022 03:22:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqG5VS08FhdDbm1j+0/6dUSFrQERk1jDvWBXAFbjrHkR6NImZ6gZ+0g2Q9HVyhnt7tF/YM5pJKqhprRj7ThylVS+fAlJpV3+2XHPP7QJFFuJx9EWQma9m12lzr+/y0L8+feQ5zmpMyqAHpW2pWufebX0vg7jOtrDiHXHOQLyWSP3IRIM2XpHXP+ovV2Y94vS1DJBVoPaSfoyVxeVbTtgbPI1p8Sr8jPThZ/6drN01ULlg99gx0kQqb1QG+hkkXydlYBtk+6rUs1MSazcywR0+mHMxf7t19LsXdo8s40vE6R/Ocsrztwo2DJokBmzh7MpED7EaPviQYCWZ1uUb2TGKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cunr44wdgGFmBcmdcxj3+qHNicGMyqpxCmBguiWG+0s=;
 b=VJvUFPfId/HDZu/hYg30l9QpuHFDYSZwKws7nKNccvRviGh0kAWfZIcb35WSJq/UTomEhfyx3v/hXB3jxd+uVarBL7pEXuJM1uQd8DQpSp+AgL61VWkcslDqGBSdG1S6CqOPeFpabHTRUARuf/b/5bahmoKKBdNLTlqMTqxt8Dvu+Qxbo2Vd3iQaOn/Un6DFM0bxCiiq2wvBVu2nsb5othXoPplCQfFqPL68n7TY39vef+rOf/oDGJFSqYtTPTVRVJkZBPzDzHJ2YpzWoeCystxYb32djfTnv0WDyzrr2E0KJWCME7r1+nK9o56VGNDsmitQ4b0mvhgUs/UWVLWNsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cunr44wdgGFmBcmdcxj3+qHNicGMyqpxCmBguiWG+0s=;
 b=mORrW9yS5RZjfBr3hadD5sT2OXDxY8J8kYcjaMHyyqvtnRFrrFcn1vLqebdaSfqFjESBkH4DwovwiroHeJcmSO8iB5WQgoKbFE+uBwl29t2k/2sErNuCdIisNo1Xcgm0aOjlh/3WsNd2vsn2s68JOjDswyAGST3D/Qx0NDGDIAA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB9755.jpnprd01.prod.outlook.com (2603:1096:604:1ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 10:22:43 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2%3]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 10:22:43 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?iso-8859-1?Q?Stefan_M=E4tje?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Thread-Index: AQHY6d1KzPu6u6sBIkGlqmouWtJppq4jl88AgAACl0A=
Date:   Fri, 28 Oct 2022 10:22:43 +0000
Message-ID: <OS0PR01MB5922F247211151F4A84B001686329@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
 <20221027082158.95895-7-biju.das.jz@bp.renesas.com>
 <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
In-Reply-To: <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB9755:EE_
x-ms-office365-filtering-correlation-id: 14b7e18c-d834-42c0-6b09-08dab8ce59d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ifn2W77CVWxoowflfk9mhsI1zkzM6wvSMJsYVyn+ZUx47KY0HRFs/35R5frzB1+cpRaokfGSXXOsz+ZF+Zrmbz+LgA1YTFxrhsGtDwA4cqw//KvtYIFfVZGtbIGPk4VCXlS1xTlBBbuGEsCJ8sfFUNQhiVcaxI4y1Uv1rAR0GZs5ruGFjOkOAdaMrGfxbLX/G/eAte6+fcXIrSgEGtNHLIoxHVMZZbskTJcDwEZIcM+A54o/fBSVWlUsfmN7oBmfNogjO/pfKmdTL2KWgefrR1my21P/hxLHkJ4X3fGfC7sDEoXzBid1QNU29OYpz3ldRdcws6JXt58Ak16hEtcWlcO9dp6kfIJCJIj4fOiPC7ElUU5JfNVjnTQ+eSyeJwgDhp+ufxmBVt8l/6W9Ua1f9y+H3we24zsxM7ALZh7z/DEbKtO6apeWNWP9wcHszMaLDhNGvRhObXh7m+J+ocknVPILo72f1uYISLUON5mV20mqC/CvZv/+AY5G8K30pTf31Y5mtQYUTOgPaKK+z96UXQ2weNdg2lOIxmLEunzcGBbDoRjrhTvVmYrAapamzLgKEhR1K+waDfPy05mOxQsxvfc64hYEqJmaAClkaZxWkQeMo/KUiZQfpbRD9Qv1It+LpA6OBNRShVC6MsPfibqFo4ANNGsRfjojs+E2EOAwM1EY6OEx7JRrLFChtSpdUvESyVUg+L6QJ4oPyJiiCxDwGnjH92clCeALeKPVZVuEBeESJ3SIA0yCgW3LYmOVHBaxf8j9yePpa8V94RC4nlb8iA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(33656002)(478600001)(38070700005)(7696005)(53546011)(6506007)(71200400001)(52536014)(26005)(8936002)(9686003)(6916009)(316002)(8676002)(86362001)(54906003)(4326008)(66476007)(66946007)(66446008)(76116006)(64756008)(41300700001)(66556008)(7416002)(38100700002)(55016003)(83380400001)(2906002)(122000001)(186003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?fCCVhvTATJ6HLwiAQZ6inrFz/IK11LjBOwnENJFHvs5myTov1GeQazSQmC?=
 =?iso-8859-1?Q?mhvObLsjqR0KTsTJ/w6/QeFTBcR9FvVk1Yx5lT7DMJoDHfIO0cqGbWD4r3?=
 =?iso-8859-1?Q?jmM7JBHPdYh1k+R6Q4mywWrX3ot+c161KY+fvLOLNekkKm9B0IwvTJbhpp?=
 =?iso-8859-1?Q?fjSgEMs52uvCEvcioxzRLJ/HXfAwQ/cE2/5givrglgWmZW39XiFU8Ol8ie?=
 =?iso-8859-1?Q?D5clUirf8vL0lpTm+cFHGs1NxfOZew0W+23U8h9jGYASZjPSyoEADN6TPF?=
 =?iso-8859-1?Q?a4P/7s2PzkXjpEbqPk4t712UYKLykm+sbcjog2d8JlAske6X8cALhhPz/c?=
 =?iso-8859-1?Q?XtJ8q8VWOYCrQOFbXCUH1PmjM290a+0R/EZydfyNbOcr+Fzq4v2Q3QmhYW?=
 =?iso-8859-1?Q?R0ssImG1S1eKqsoGaUVMg/WuKXWRfpw5ALLYGMGd0QF/cJkfmMeQiQDfvP?=
 =?iso-8859-1?Q?05pLhwNhlr16x3/rWdAdKYEMMoI9yoW87LVeyoReydz6QwuBFAL3nfa4Bn?=
 =?iso-8859-1?Q?KctjOQbjue4PzNdcw8ZTiiSTZRvTFLWOFon4wJtRQEPTWedC4IOSdH1kNA?=
 =?iso-8859-1?Q?aRq1+3sSElBgeFXP64UN5ZGB3b1GMhnI1m25ZOY+B/kY0yNWKG8p9rNcgC?=
 =?iso-8859-1?Q?yBOygWBK/KIJKtcMaYRzHnOBV+MfMsenzh8Si5ygh1+pQPgA5BsgX62KiE?=
 =?iso-8859-1?Q?HFflF0aAggvefZvfi9b6jE7okMaBE1RGLni/AwlUMz7YCbkqWdxDU7axps?=
 =?iso-8859-1?Q?7vf985L94GBzacht7K3e3ICfKFWPy/G2nsCP/lTZmWRBxQFT6bZ7Mkk4bA?=
 =?iso-8859-1?Q?uxy2TfzF+qJEgm1I9r+9R258dRk1ODEXNN/Ud2K+9mjNnzYSobdT+ohfoL?=
 =?iso-8859-1?Q?HesvVW1IGOGXNvL40Ok/P+g7DGUpAf5xQxr9RZkP5z91lbZ7dZlFl7Y1AE?=
 =?iso-8859-1?Q?fCNb5KN1KXkZewgRyiu9+khsoaqvgubhX+zLnq2ze6uD1drxlnAWt9x5Qd?=
 =?iso-8859-1?Q?aHLnrzzP5vmwqlih7i7jpW6LsF1N7dH9ZevplOza7rhEv9dBF20bMvhbCX?=
 =?iso-8859-1?Q?hzn02XjN7UJEtHRBNrWq9pto+Sk/qmIMj7HJrTwcn5B2OlKRIv62/UZgJ7?=
 =?iso-8859-1?Q?Yc6idENPe8xVVFS4a8Z19ck9TLyrtxTXbvc41BEHAOUkU22ot6+gwIeP/s?=
 =?iso-8859-1?Q?ns1RSDc1OyIsd5FQbUXjnCcDMBwrlekzacErGOXVSzfywMSYdrhto9kgMn?=
 =?iso-8859-1?Q?Mai/Mj/SG63giq3nlNsMcz1OpUY//etB6cpwpBhTwj+CN1sdXFy1hLKcx7?=
 =?iso-8859-1?Q?vz9zB6+pqU37YONeQPjdfXJUVIdYDWDsa7YHZF7LX+A2XJJojUQpxOPOyU?=
 =?iso-8859-1?Q?4ajHC+h68MggGERmNt6LnEMPE/lCbTDzymSYxiAL0QhloBd/xywhUCsf07?=
 =?iso-8859-1?Q?7F0PI12YWyIV1vqmxLbfiqo4679NkO+jYts3kbISppEeD6P1OPqJaY7yON?=
 =?iso-8859-1?Q?iB9tJyb/gkPJfJfead19DRrYgajMdiuDGZNvC1T8NwYHXxUqtqbfwPkR+P?=
 =?iso-8859-1?Q?X5buKW9whzIIOb77yqN9fYJgRWiKD6xGcp0iRSUMzcZBjtngxWMJ9EMN0w?=
 =?iso-8859-1?Q?Zknlp+c9JwidIirMibd8DJQEvyJC0zBo2sULEq7ylAEZl6dsuG8HWkzw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b7e18c-d834-42c0-6b09-08dab8ce59d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 10:22:43.5785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fieD4xa+YKLbDiflaE3itFc5TanPh54mq+s22v0pyFG7KkYZVhITma9v6ZRaaFMw4upZ23bXOt2Hw3IgJyyVDlYwb2aH8fQyNsWMgx8XaTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9755
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

> Subject: Re: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to
> struct rcar_canfd_hw_info
>=20
> Hi Biju,
>=20
> On Thu, Oct 27, 2022 at 10:22 AM Biju Das <biju.das.jz@bp.renesas.com>
> wrote:
> > R-Car has ECC error flags in global error interrupts whereas it is
> not
> > available on RZ/G2L.
> >
> > Add has_gerfl_eef to struct rcar_canfd_hw_info so that rcar_canfd_
> > global_error() will process ECC errors only for R-Car.
> >
> > whilst, this patch fixes the below checkpatch warnings
> >   CHECK: Unnecessary parentheses around 'ch =3D=3D 0'
> >   CHECK: Unnecessary parentheses around 'ch =3D=3D 1'
> >
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>=20
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>=20
> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
> > @@ -955,13 +958,15 @@ static void rcar_canfd_global_error(struct
> net_device *ndev)
> >         u32 ridx =3D ch + RCANFD_RFFIFO_IDX;
> >
> >         gerfl =3D rcar_canfd_read(priv->base, RCANFD_GERFL);
> > -       if ((gerfl & RCANFD_GERFL_EEF0) && (ch =3D=3D 0)) {
> > -               netdev_dbg(ndev, "Ch0: ECC Error flag\n");
> > -               stats->tx_dropped++;
> > -       }
> > -       if ((gerfl & RCANFD_GERFL_EEF1) && (ch =3D=3D 1)) {
> > -               netdev_dbg(ndev, "Ch1: ECC Error flag\n");
> > -               stats->tx_dropped++;
> > +       if (gpriv->info->has_gerfl_eef) {
> > +               if ((gerfl & RCANFD_GERFL_EEF0) && ch =3D=3D 0) {
> > +                       netdev_dbg(ndev, "Ch0: ECC Error flag\n");
> > +                       stats->tx_dropped++;
> > +               }
> > +               if ((gerfl & RCANFD_GERFL_EEF1) && ch =3D=3D 1) {
> > +                       netdev_dbg(ndev, "Ch1: ECC Error flag\n");
> > +                       stats->tx_dropped++;
> > +               }
>=20
> BTW, this fails to check the ECC error flags for channels 2-7 on R-Car
> V3U, which is a pre-existing problem.  As that is a bug, I have sent a
> fix[1], which unfortunately conflicts with your patch. Sorry for that.
>=20
> >         }
> >         if (gerfl & RCANFD_GERFL_MES) {
> >                 sts =3D rcar_canfd_read(priv->base,
>=20
> [1] "[PATCH] can: rcar_canfd: Add missing ECC error checks for
> channels 2-7"

OK. I will rebase with this patch.

Cheers,
Biju
