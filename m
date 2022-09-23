Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B745E7306
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIWEiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiIWEiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:38:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2133.outbound.protection.outlook.com [40.107.223.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FDF122A5F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:38:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMdWIh5ZvROQIHXR98R6OsO/1fujL2xy8FUnK+VVtFw2rAd5lESWIrD1C4WH9JWfYYH3vjKwskhptRSF5XhkWUG/XbH/3co4E6RVl3qO790y1uhFC0Y/PM7+SgAKCYE/j72QeCzSGTBd0KgGJtaPOnGwDkSobYXVkM3HRDhHQmpFjicc+BALHGViGd1+upXlqkIwpv5ziMb5mvAU51LyOBEzfl0UaxIddqDlttQdeRWl1NqrPYIU28TdFH0RITwuaofcwLXrVoR3YQ3CSJQaAEXKcpfg2tYy267qWIdAEF330D42clekX4aUNJsb/LhRV1faMcPnMx2oam+x3rM9Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tG97vdcCDDsHQn4CiRQ5W/O0YQIeWIFSLecYWG8ua8=;
 b=OFVT6TCICWaLnrq9gAwcomCdxQW3viTZpMfO12SurDAZz9AYFa9OEivhXM1/GWQJQocH8Z7ClPe5vU7F+at9+bKqyRccI+2MSOE0K6s4dVvpeWDD/POj3tnEIzc1mZUB5cnQ14dV+g7RrVPk7oFFitNQQ+TFzEpjNyf+lywcS/SfhC8K/jMIRI2r7bNwq26gGsmKW0JV6GKIXo3xlnCx6U3vf1eFiUiVCUDhJ1WpRRmRwG10dYqRE6JDTvQKfvDlXWaHUzFM3iFgu9cNUnbJHUoc6Zq702N5L/BL6xTe8xmzBzUczLyWGGDy9Sip3ECuT4XhqE/3RXMO8dyJFJFKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tG97vdcCDDsHQn4CiRQ5W/O0YQIeWIFSLecYWG8ua8=;
 b=Rj3IMY5RkSxLL4/+xOgjW3y4qPq7H8QsqvtHVMrNp26MOO0IsrwexcHowiq4Ef9PaBk3T0SROA8rCRSZTfe5/Zp/oZWoYDz2rFT4IpMdsl8jKPBeNINGPX/+fqAHeQVzyuxwnw7bsPNkYqOC5Qw5Tn/Xc5wbpIDL+8/eBEuJV3A=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by CO6PR13MB5370.namprd13.prod.outlook.com (2603:10b6:303:14d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Fri, 23 Sep
 2022 04:37:58 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be%6]) with mapi id 15.20.5676.009; Fri, 23 Sep 2022
 04:37:58 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: RE: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Thread-Topic: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Thread-Index: AQHYzbN5AcsGOm08oUOGbZxFfyT2B63sNGUAgAA5DfA=
Date:   Fri, 23 Sep 2022 04:37:58 +0000
Message-ID: <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-3-simon.horman@corigine.com>
 <20220922180040.50dd1af0@kernel.org>
In-Reply-To: <20220922180040.50dd1af0@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|CO6PR13MB5370:EE_
x-ms-office365-filtering-correlation-id: 47cd7865-e5f3-47f1-249d-08da9d1d642a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7C5iJfPTtgCicdIPgfJpOJOeJDhlbWGSb5dbgBH5HS4NIRPGYUynLQtN7AHxc4BrCzRQZFT3EuqXZS9ZUwSR03uM2BZvHAG6s9RMlfUcdF/+HFzmk4RS61m0hdQxoCJ19z1TosEQp59Gzi7cM/Ux2POD7u0sWjdqxS2uXo2wYM84tduu/GTN2DTNOy2l4gZ2UP8pS0/meaBE+x/JbP+RI7CDeppBRDysELO2ZsA9pTIN2E9Vv4VqHaCg4qSgidqNpBMvJwreWLtDl2t0JUe0e8+obwC3UYmAIIDZw4UcFlR1Gn1oHb3jh2VZxDMm5z8k7qB8XaalOZp9p9J1oX+ISLpqjkGPnbSVfw9q+gfEpoV3fjIkFBBkS2qSoelbwWMAjQYda89c09BD7gTKBJviGN23MDtg0WGYryDgQGRNqxSlqPz+RHyeezHCvs/MLC8auQahmdFGwtA4Dt8hFWEYhvlAeV4BbA/yK8Kvph0elNrZFCkH1nu9Pe5/zynzIPBvsooHKxfJzu6V+JIPgw7KtHPYuxhBHC/HyrtwjQAjK1mfdCABhIOAFzxJ5nnqocEIhKW6altHG8jzsjvJEzPg/HGHifHHX5pz47E2Tpz+19B/uC71fHd4Si/x3saXWl7yo0XLlKcdCObKJU8yDt+WwEOP+BsehjRj3zWTw7ssvjexrL+W8XZsa1Ymf7Vp6+CTJ1Crfk/EHNvuFO9xGYCdrwGDyP7qF21kWBA22+5RXXHB737OphKl8/bZyGWB7612lKf62Z6PrV3ZiFl+UvI8Vr3xpfyCLfJKEGy+Q6XaIoagkpUFKcEONujmBXdy+dmp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39830400003)(376002)(136003)(366004)(451199015)(8936002)(122000001)(38070700005)(83380400001)(38100700002)(6506007)(107886003)(9686003)(7696005)(2906002)(26005)(5660300002)(71200400001)(186003)(478600001)(66946007)(52536014)(54906003)(66446008)(6636002)(316002)(64756008)(86362001)(44832011)(41300700001)(66476007)(76116006)(8676002)(4326008)(55016003)(110136005)(33656002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5dVBdcZZX81coneFiF6avO4bjyR4u9dNUbFVt6Bi32R3egfnavvVdmpgdBu5?=
 =?us-ascii?Q?vEaG8ymQU9+eTT15G0vjUS2+6qzWe0V7NBELclTk/ubcCSNweuar/73bOnl8?=
 =?us-ascii?Q?uDo/m6ovyUURInC67Gqr8zjUjR2ArjJnIkiThtFNFi28jJadxq2ygGw3phbU?=
 =?us-ascii?Q?x8Jh2idsbQtdJAmi67icULfqp0NnrKtkevAMPXO5ugzHHSSit3qiAtCKDGEj?=
 =?us-ascii?Q?Cr+olEjjPeDuhr9e8zSjjKM/SM6dcDSjgeglxwgIaPrvKgMzOmgoBPVwUa7x?=
 =?us-ascii?Q?AcMVhjud6elmCQAvi21u58VspFitK259DSxv/wxH5EclJ13qoOmDHkco7Z/4?=
 =?us-ascii?Q?DArvuUf1TuEsuzRzr8o1Ntm/0WiM6GFxzeohP3CwD91p02YM1WnAExmCZCuY?=
 =?us-ascii?Q?faWOkuQ3BgUgxTu8lvgDKOpyrwwKbRfFw6R4oL9VldZsX83InxdzGkxtuRhh?=
 =?us-ascii?Q?9Y5cZtj1mzTc4FXEv5wFVMjG4rFPWj0bNdEAhkTs9D5/GrnM9xwPleRuGvgK?=
 =?us-ascii?Q?4mMubVtBuXA9TAXz2QYUrnYohYkqexlqAdNnv6yEIz/zHt9yCxxhBkXTKJ6J?=
 =?us-ascii?Q?3mHei1FaF23JHOaOtPM6Gjc0H7JVpU3Kyeyy6MyV5USGUHqnhNu2zbRFh7YN?=
 =?us-ascii?Q?eJMOgxPE+zSZ+WheDvfLQF390QaSitY5MAlHPnD1pAS0OQ40SqEvGLvqpzTW?=
 =?us-ascii?Q?3P+XtRchzamEHwofy+fsG06ua7OjYFrq8NDn7SUEhl1s8AxN4wLWPvzGxy3+?=
 =?us-ascii?Q?4UNAkb/VK5pBfdBsfvD9PIOzQxYqmy98Fa8i22X/8ov0wsD8aLbEDwFVUiHp?=
 =?us-ascii?Q?CkiT+5r5IqLwJ5Iufge6frlc7P4Bi4IYULmmwYShVc8+qoTEcYQ2MUXK0Txn?=
 =?us-ascii?Q?qtZkM6xOLdI4kXcT9VM83Fm1+VMat99J8rHpeF1fk25GsqzDWMS6gtcLMJt4?=
 =?us-ascii?Q?9U/zM4vwkM9Z5WWX9UOXYPMg0UXkzoa5RVe+VBylgjaf0hnenNJlb2W9vOGc?=
 =?us-ascii?Q?9HKzgyEY193+bklemoGuJVQXHrDCvUbXrtTHjlhBtJAy+Bk9COOn3uCDc9JP?=
 =?us-ascii?Q?hIQmzupEdfETH/gIlMC9hZWOPN/WmbC1VUL6Bl+09x8RZgk04BKxBL5iWVUd?=
 =?us-ascii?Q?K1AO5OkAMCPq8XW6ezpXV6TtBjCBuEK7QQD9QnLbleFw683EjUyqd/jKTjAQ?=
 =?us-ascii?Q?MaC/NCK0APTmGQndOwhPAofAaS8lJqCLJf4FxBh16D2T872+wKkFumtheY/i?=
 =?us-ascii?Q?kSBSRrhiV9uCR+ViF6G6Blgq1CYGBVv8Gs4n22WXhQ+TFDzWX9g9ciVv0cxQ?=
 =?us-ascii?Q?3eG6xLqD/ahgqz42lEq9hY4FURFor6ukwekplyQPIIguUOiT9gf4VAdhlepP?=
 =?us-ascii?Q?jb+MPRYp3tQBbvnSnouVAZyIBnCMW28oXbDJ7s8Y9i0FhuBw+aIYCfchVmqW?=
 =?us-ascii?Q?zduExMieZ8e/k1gzTxBjLmkc5QN1RfshP7Dok5zxMOxwpU18dm8PtzrX8osD?=
 =?us-ascii?Q?G+OQnVIK+KOmlqqLAxjBDCRBk4cz3I4XSoOIbztLaASZdELKIwAZSJr6z78P?=
 =?us-ascii?Q?w9png61UKCf644UOzyGvOFS5+ptHEzsJkY21nojd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47cd7865-e5f3-47f1-249d-08da9d1d642a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 04:37:58.5817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CFhuICxZJKLX6h/K5ESHAsR75xmAxqIK2ahNaKdKticcJXDowket0O+1yUY1MEqufCOjPb3NXAbvVeUghRW8MoGkweCwSX2LDevpePB+rIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5370
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 18:00:40 -0700 Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 14:12:34 +0200 Simon Horman wrote:
> > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> >
> > Report the auto negotiation capability if it's supported
> > in management firmware, and advertise it if it's enabled.
> >
> > Changing FEC to mode other than auto or changing port
> > speed is not allowed when autoneg is enabled. And FEC mode
> > is enforced into auto mode when enabling link autoneg.
> >
> > The ethtool <intf> command displays the auto-neg capability:
>=20
> > +				goto err_bad_set;
> > +		}
>=20
> Please refactor this to avoid the extra indentation

Will do.

>=20
> > +	if (eth_port->supp_aneg && eth_port->aneg =3D=3D NFP_ANEG_AUTO &&
> fec !=3D NFP_FEC_AUTO_BIT) {
> > +		netdev_err(netdev, "Only auto mode is allowed when link
> autoneg is enabled.\n");
> > +		return -EINVAL;
> > +	}
>=20
> Autoneg and AUTO fec are two completely different things.
> There was a long thread on AUTO recently.. :(

Yes, you're right, will remove this limitation.

>=20
> > +		/* Not a fatal error, no need to return error to stop driver
> from loading */
> >  		nfp_warn(pf->cpp, "HWinfo(sp_indiff=3D%d) set failed: %d\n",
> sp_indiff, err);
> > +		err =3D 0;
>=20
> This should be a separate commit, it seems

Will separate it.

>=20
> >
> >  	nfp_nsp_close(nsp);
> >  	return err;
> > @@ -331,7 +334,23 @@ static int nfp_net_pf_cfg_nsp(struct nfp_pf *pf,
> bool sp_indiff)
> >
> >  static int nfp_net_pf_init_nsp(struct nfp_pf *pf)
> >  {
> > -	return nfp_net_pf_cfg_nsp(pf, pf->sp_indiff);
> > +	int err;
> > +
> > +	err =3D nfp_net_pf_cfg_nsp(pf, pf->sp_indiff);
> > +	if (!err) {
> > +		struct nfp_port *port;
> > +
> > +		/* The eth ports need be refreshed after nsp is configured,
> > +		 * since the eth table state may change, e.g. aneg_supp field.
>=20
> No idea why, tho
>=20
> > +		 * Only `CHANGED` bit is set here in case nsp needs some
> time
> > +		 * to process the configuration.
>=20
> I can't parse what this is saying but doesn't look good

I think this comment is clear enough. In previous ` nfp_net_pf_cfg_nsp`, hw=
info "sp_indiff" is=20
configured into Management firmware(NSP), and it decides if autoneg is supp=
orted or not and
updates eth table accordingly. And only `CHANGED` flag is set here so that =
with some delay driver
can get the updated eth table instead of stale info.

>=20
> > +		 */
> > +		list_for_each_entry(port, &pf->ports, port_list)
> > +			if (__nfp_port_get_eth_port(port))
> > +				set_bit(NFP_PORT_CHANGED, &port->flags);
> > +	}
> > +
> > +	return err;
> >  }
