Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83BA6D54A1
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbjDCWQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjDCWQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:16:51 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2081.outbound.protection.outlook.com [40.107.7.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C5C26A2
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:16:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8g5JzIK0wGTAahRcSHbOj+U+JfohAjPVVbWufVJfI5kWot82Ei15A9PFwmYym+u/B7pUMy5/l5xLZHXhLL2yTyVmQb6gMG8lFWcq2VkCGJOMSlHqIBLssPfCzpS/ThZhq5AEk/qD0upvYNwh6The98azrmaDsrVIVHWd/lNCgoGxrXY6n6zaBAxTzkZXte7Wh3KO6Mi/MWjPewcPy2BQXHD+DYqm1nQHHaLHsgcmEfZNjxX9L9KCr0x8ULgk7evH3+aTvXU0r0vurKBTYOMJAcw7m00kjJBT/Uq20z5PPclViSu62moJTgR0B/Xm3ZVO6ZfbhpDQdDL/gEsqm3LOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jocy0mwBWjtJI4uYhC8QENQ7MrSTTy1uTe+bWj3QF+0=;
 b=J/7/0pwMeaF4dZgozXb0FWJIZyiu60NukVGBWqYuO6MxYu6E/4b+CKdlpT5ayKeKH58ILk2aVeZyZ0vbvHNj6ZHvyWYeYDcH/ZPIH7saQ5f8xiGUT+C/NvHU+QgrE1kdBJZQd7pDVpP69XvcjhO/bj8ZcwbzbcxaV4JbhqMBn/vQ+Qr8Ymbqp6N/6H3Af6pjvpHf0fgfW+7+qi6Njk0NGS5TWECZBCEYxUZdoSbOf2ufVAE6+BFpJSyGCh9XeNSAlq9gss50H2nrk94J2K16+yOq8BGV6/5D6EvW2ybUAbyx03tDt0/C4VfryPXABXgAg0sFMCWV4/dGeuuZ9cHu8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jocy0mwBWjtJI4uYhC8QENQ7MrSTTy1uTe+bWj3QF+0=;
 b=Z7ij6jEvF/xk3sQThR4M7ix+eyyhY3oVKTjsCS0vlhF4Xo0QkiOQjdNgdJZZBMJjE4kHHgtKD/Y1K4UbqDHCfHhCOkO4L1kSFEDMiFibSeXL3GETLTDf7pQ+u/vILDvYkeUd58RylssbNvRGYjWpQyOZbV8qiQnU9JmscdQxMkU=
Received: from AS8PR04MB9176.eurprd04.prod.outlook.com (2603:10a6:20b:44b::7)
 by DU0PR04MB9495.eurprd04.prod.outlook.com (2603:10a6:10:32f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 22:16:46 +0000
Received: from AS8PR04MB9176.eurprd04.prod.outlook.com
 ([fe80::f829:2515:23f4:87b5]) by AS8PR04MB9176.eurprd04.prod.outlook.com
 ([fe80::f829:2515:23f4:87b5%9]) with mapi id 15.20.6254.035; Mon, 3 Apr 2023
 22:16:46 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v5 1/2] net: stmmac: add support for platform
 specific reset
Thread-Topic: [EXT] Re: [PATCH v5 1/2] net: stmmac: add support for platform
 specific reset
Thread-Index: AQHZZkBkrKNMECxq30yLxNh6ONN7Gq8Z/mgAgAAjznA=
Date:   Mon, 3 Apr 2023 22:16:46 +0000
Message-ID: <AS8PR04MB91769E3A7396555DCAB43CC089929@AS8PR04MB9176.eurprd04.prod.outlook.com>
References: <20230403152408.238530-1-shenwei.wang@nxp.com>
 <ZCst4PvQ+dlZEbgl@corigine.com>
In-Reply-To: <ZCst4PvQ+dlZEbgl@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB9176:EE_|DU0PR04MB9495:EE_
x-ms-office365-filtering-correlation-id: 36160c8d-2dd7-4c02-91d1-08db34911d28
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PzPTkoeraKiLxHhoFrW7TSnMsQRlP+7kO2ilBcRztxxxuTKTE5cmjGSOIEzha9KPqhw2JNiniBeZMVdOB24E6dDqzNB+UqV8bAMC/rJesVRx0a3iR0hlqup6SgsSnHQJY/v8RWoNc5srHoVPrv0WAgSKtGrMxRk9jQiR0nZ9HNleoHlyfV997lsJAKHW0fqiAFNkOJtOAsnGoSytTKeczoLoDNDbU3MlHS4vqLVWCqaPkCfcsMY7n2LSjwQmoVP4S0NLdjfUcsCd5tfgefjZOB63KTA+4IfCb/N8CdWy5MEut0hmMPo96HGamiLahXakFDdCjTqa5pswhPlCPL3ArjsBtRV6MyjE7Hxvs31Ti9sc9DVPKkk05kas+jkuqpnULwfIK/cg+1nz4JMXmjlG7uteWKztQ3SsFdcZm4i1yBzX1f7IF1VRpf6YI+gY9D2ZGS1SpwmsNbTR8Z39man1U2aH5a54X4oXTQiXYhsl9Gko3elPsPttQLKsTYLQcgYl0i+6L8xrDNr3KneGPg7XHnvoS34Ozwf7GJl6O1hD+6H2zjco2BTOTiXStSG7NLe21p38JXFBiByP6UervdnZugvZZjKtdr8sqlukxW7Uqs0zTqwp+tVyarCkk8HcR8Ed
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9176.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(44832011)(478600001)(55016003)(186003)(71200400001)(53546011)(33656002)(26005)(55236004)(9686003)(6506007)(7696005)(2906002)(83380400001)(86362001)(54906003)(52536014)(66476007)(66556008)(66946007)(76116006)(64756008)(66446008)(8936002)(7416002)(5660300002)(8676002)(41300700001)(38100700002)(122000001)(6916009)(316002)(4326008)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZJ5iGRRTLGqmiNgh4hDmfuO+GNA2YsJgbtSP7hezHHzv/8vhZHSbRJcxdINN?=
 =?us-ascii?Q?bbO+jdAhuotH5aEArxt9YZ27QjKnmAcQi8NWJxKPQdkDos2BGVPmg9D+3cIN?=
 =?us-ascii?Q?LG9PMWDucoIDizC4SYwCRSWnL2EtvK8sjzIohG0EHiFDMqsQ6P8fHLmm1rs0?=
 =?us-ascii?Q?Qaq/+TCdXYwSYJcMeEZr76aE6lvwJq+UYn9NtpETxsb5QFezPO16ILfGs5qK?=
 =?us-ascii?Q?v3cgsuzy76GYHu9DkKY/xdf8Ujc3ahewwh+B/DrJ8N3hUAn5HHn8wOURukbf?=
 =?us-ascii?Q?hwhfH4Ml8uwgnHIHOAk1k45EJ0yU6EGbBPMJqeuVXz0K8q/oAlyS8JZFskqi?=
 =?us-ascii?Q?+bVbwJ/UDJY7xtCWz54XvT/WT9DHOTjyHmoLLEStPUBg0iol8cwthWlGakC4?=
 =?us-ascii?Q?NgCCBKAeEGWZxubSaKpraHltPfs28shxjqRjBzVvS+QaxzCnkd9hVIiR/FKI?=
 =?us-ascii?Q?ZfcyIc+m61twQ+XZx9K8wXEcUsUrJPNgMsS68uvH/McTW9tgvvM+LS0xmdsm?=
 =?us-ascii?Q?jAShLKFZeO3a89SIA6lVKxUqeJh79GhNAl0M5VTArz0KVzkvpbMwJ0XHrAyF?=
 =?us-ascii?Q?K+/M1bOTE1ZEqaowxVobPCv0LxC/+4IQig6rQ89ZjQ5unJ5uervYQUI/XbLc?=
 =?us-ascii?Q?CnidoJQ0QAM1AATNLgYSVxi9BKpid71Y/fLAEDHO3B3+AmolU++T7rnp+qHT?=
 =?us-ascii?Q?8oFyrBPDpFDysjQtp5qgEGsFVyd60oZh6edDGwn8fImZlsVCXJP95zF1gWOo?=
 =?us-ascii?Q?MuHFxL8Q/5jil93Ntn9vjWM90bCXPu59eCgeCqUX3MeWKB7FYQ/RxKBu0JRd?=
 =?us-ascii?Q?MqsSoPm86Sp0UZzc28iTBmKCIrPArKYP666NF2SP/tKKUUQrM6SR3RnxPrON?=
 =?us-ascii?Q?+zT+gLKUqJo97be/wP5dt8fNqomJrfm/UY9uAWr+dy0B+XkY+5cU/kk+n0rK?=
 =?us-ascii?Q?5exFBYQchsx1G/v+LZNkgz/q9VMb3jWB+qnX0ku7+8FY0Iub0MvbuX0Yvuln?=
 =?us-ascii?Q?JGr8asv3tvkNmZbBzonXFzznCEVLXG94x5c1GXTquCr0wez92jgedw1RJdIf?=
 =?us-ascii?Q?rXNZ3IvhIMcr1yqE88VMyXPGQUXipraJFoq3r/258XELyVbW/HIlx0qlQc0O?=
 =?us-ascii?Q?iaLuJFvQfWi7IQAS+9CWF5k+K4JAKnXWoGDmpd7R7dAqbxkUEzMVgOWOzFfT?=
 =?us-ascii?Q?+UteQl+vaBnCUMiAUET04NDmYFQOXEx3B4clyQQlv8NRiYUsIhaEvGyUHYGW?=
 =?us-ascii?Q?wCPKlJaQuioZIyLCNEbQGu97rc7yxwqpz2xUJbvCrGlG9QiVE+URudBaem+3?=
 =?us-ascii?Q?IjohMhvfRsmaQ7FauS7Va3sv1phRjqBHwc/OrmhcP3Qniz1pfjfr1VvKLFiL?=
 =?us-ascii?Q?mw4qNP0U5HjJ1jWBINjKlNAvcccgP+5HDvwndc+cxryrceYyQAPn3clr7cwB?=
 =?us-ascii?Q?HQBkU9UXQTYJ/wbXgDtH1jcVngdNw4tVzaK1CEe8cXbzrUM8dGvTLEZjUPnE?=
 =?us-ascii?Q?7Zdmakf5iyZxaX4wZS5Fev9wwtuZOsAAVP7nGYSa8WoGw0pmijYXb27f2nJQ?=
 =?us-ascii?Q?kH6CPtu6isM3dIA8oE4do96+cjXNe2LIT65BPe/I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9176.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36160c8d-2dd7-4c02-91d1-08db34911d28
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 22:16:46.7141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1PEV1quwh7DHzbRGLyic/IYvCpYNjQGwBtdqcGuqeBrTzchJVHOhidHpcCe8f7H0t2KC/3raZovSA9BW4lKw6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9495
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Monday, April 3, 2023 2:50 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Shawn Guo <shawnguo@kernel.org>; Sascha Hauer
> <s.hauer@pengutronix.de>; Pengutronix Kernel Team <kernel@pengutronix.de>=
;
> Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> <alexandre.torgue@foss.st.com>; Jose Abreu <joabreu@synopsys.com>; Fabio
> Estevam <festevam@gmail.com>; dl-linux-imx <linux-imx@nxp.com>; Maxime
> Coquelin <mcoquelin.stm32@gmail.com>; Wong Vee Khee
> <veekhee@apple.com>; Kurt Kanzenbach <kurt@linutronix.de>; Mohammad
> Athari Bin Ismail <mohammad.athari.ismail@intel.com>; Andrey Konovalov
> <andrey.konovalov@linaro.org>; Jochen Henneberg <jh@henneberg-
> systemdesign.com>; Tan Tee Min <tee.min.tan@linux.intel.com>;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-stm32=
@st-
> md-mailman.stormreply.com; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v5 1/2] net: stmmac: add support for platform s=
pecific
> reset
>=20
> Caution: EXT Email
>=20
> On Mon, Apr 03, 2023 at 10:24:07AM -0500, Shenwei Wang wrote:
> > This patch adds support for platform-specific reset logic in the
> > stmmac driver. Some SoCs require a different reset mechanism than the
> > standard dwmac IP reset. To support these platforms, a new function
> > pointer 'fix_soc_reset' is added to the plat_stmmacenet_data structure.
> > The stmmac_reset in hwif.h is modified to call the 'fix_soc_reset'
> > function if it exists. This enables the driver to use the
> > platform-specific reset logic when necessary.
> >
> > Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> > ---
> >  v5:
> >   - add the missing __iomem tag in the stmmac_reset definition.
> >
> >  drivers/net/ethernet/stmicro/stmmac/hwif.c | 10 ++++++++++
> > drivers/net/ethernet/stmicro/stmmac/hwif.h |  3 +--
> >  include/linux/stmmac.h                     |  1 +
> >  3 files changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c
> > b/drivers/net/ethernet/stmicro/stmmac/hwif.c
> > index bb7114f970f8..0eefa697ffe8 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
> > @@ -87,6 +87,16 @@ static int stmmac_dwxlgmac_quirks(struct stmmac_priv
> *priv)
> >       return 0;
> >  }
> >
> > +int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr) {
> > +     struct plat_stmmacenet_data *plat =3D priv ? priv->plat : NULL;
>=20
> Here the case where priv is NULL is handled.
>=20
> > +
> > +     if (plat && plat->fix_soc_reset)
> > +             return plat->fix_soc_reset(plat, ioaddr);
> > +
> > +     return stmmac_do_callback(priv, dma, reset, ioaddr);
>=20
> But this will dereference priv unconditionally.
>=20

The original macro implementation assumes that the priv pointer will not be=
 NULL. However, adding=20
an extra condition check for priv in the stmmac_reset() function can ensure=
 that the code is more=20
robust and secure.

Thanks,
Shenwei

> I think perhaps this is code that I suggested.
> If so, sorry about not noticing this then.
>=20
> > +}
> > +
> >  static const struct stmmac_hwif_entry {
> >       bool gmac;
> >       bool gmac4;
>=20
> ...
