Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5BC596DD1
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbiHQLxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbiHQLxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:53:00 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2076.outbound.protection.outlook.com [40.107.105.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670497D1DF
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 04:52:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFbSV/cJIGpMdvZ74oA8w6SshQaAk7O5jFJf0bwvI3HsGdXVtPR49XTirI+Z0M3msOZPiBsJOIhDWVopRobCaUMd1gafypRBTsCFtpfHNXdxrdvrOWX3XLoOBjdpczVe+LvfPfhU37M2djb/am+Dy0ShcjUktBmMsw2pJ1YQBVcnKrf5y5tW3PL7yp6rLoAmLuuySN5M3cLWi24TF6A85dB58cKUOnWrv1ZxVCxI5oO9XRKQA2g0CRNTrKTWUo+hKYDapiBkO+IEiAJxv7rZ0/wgefD8A9/2DO1FoeU9sQKwdm8zfti5uRQt/PBaQsTxvAFbQWXrF3SCFh1Mao3iXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rYtQ7pYDw67HYLyfJYVsL6mokHwMYHvXPK0UugEb2k=;
 b=dJ+d8qtQ4NSwF3ELKPwm6495evUsi1HcQzwfQJVbxY+PvWrxo76vdhPGZySSixpVo8fzDqfYjE9xNKtIs2zyEGJWYH6Mz1vSNzH4MkEJPJ6LQ2065JAuOk9l9YXqlmiWOAR4MFG/wDuO3Hdl56hPtzssUdEFm7NbmS6vauMOLELs0hOXhop7ApeMVtDs2Hwb7U2t+LK14K8i1kZW4WJnp5Q6sFB/NyeSqBdvvLkRVKbbJFsUP9bx4hgNRaAbGqq4yb8EJ37DXS9HiOcL1D1lX3dYXYiFU8KLx9v6Tmxze+C7dI+iHFSRM+PxwY4z5pB/rpocjddWFWsz1lDGWcMa1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rYtQ7pYDw67HYLyfJYVsL6mokHwMYHvXPK0UugEb2k=;
 b=qwQKy+458/Jkye0qv0QvcyEocUFI1pDxdHBM7SzjEDupclyY0WFfhIJJOwDtaltPnHO1hD2hDlQ3cPu/HBFSJ/TOlZMs162fNSImzZUJ7tN1fbKqa3AJIZBH6sCzoyk/Z7Un9gM2KUV6Pxk8weCtcrskLVyHRcQng1hn05TWnVI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB6PR0401MB2342.eurprd04.prod.outlook.com (2603:10a6:4:4e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 11:52:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 11:52:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 1/7] net: ethtool: netlink: introduce
 ethnl_update_bool()
Thread-Topic: [RFC PATCH net-next 1/7] net: ethtool: netlink: introduce
 ethnl_update_bool()
Thread-Index: AQHYsb+nQu/MJjl7Nki6Sbr6EcT4f62y9SuAgAAHHAA=
Date:   Wed, 17 Aug 2022 11:52:57 +0000
Message-ID: <20220817115256.4zzcj3bg3mrlwejk@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-2-vladimir.oltean@nxp.com>
 <20220817112729.4aniwysblnarakwx@lion.mk-sys.cz>
In-Reply-To: <20220817112729.4aniwysblnarakwx@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41e9dc37-995b-4119-4e60-08da804706cc
x-ms-traffictypediagnostic: DB6PR0401MB2342:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xCh7BBCNaH/7xrWbdWq9YX1IB/68zhmloffV9dgcXEZWmbEVPd+byWx6c1AmENG4vPJoJLcNer3Ksa639kUPZwp4ufgG3FuIkDLods+To2ML11xGP9/50GFl5CsMfodZsVp4X43Rblck7r7l0PdWhVXBuO0eQAf/y95LleI6vMqbULobVAtVYHCfqTehbMX/rP1kNZ2qsA8gh9zRWuc/mXDNoj7hmCzY4qqt1mK4Nw31+Lo42YUn/p5i07R6alZmgXRwnGC95/CQCM5uwCmgiXbMPKdHOWkyGauataht9Xq5TZS3i4Q6AZkXzG5nf9YwbXy9agIb3IAAMKOXSTBDm+7RMmKlGMq6c1hKqvYsNOOoCgFD1gQ+2hFDox6XYSbUNaej94tzxvQoZ/aX74c/KWyC2nDRIQcdavcXKWbG+cVJcI480AMdJryaMpUqgNuijx3m/vD5EsDtm+O/nuaeWCuJrrSD1tdeK5hvk2jDwhEt7/DQ+5IjMVemtqtzoG+WXAsrnnYgPEU+1BlLBAME4P0S9uipla72hVYLyYkp1Q3DJ7Qym4+K+UDou0fE49h0CCvsyDAO0W3PNZ/mnnUYpGcT4RFsQp6zfGTdu7mbjL7LEwvyHUsaMDu05DxY5EJduaQCKucshExZ2JDiV97OwOenRvYeSiAEoA/7hvAtPMXoND0vkvwJQDnWy17u5yNnwBCv7jUF8f4bhormaJ5XqN3eHfF+lAh6Z22sw0wzVFrQUd9MS4jx8l1ur+cawQvdeDKS/fMCfDGWKy9EmnF1yd26NbI5pJDnuiDaF5Xjuq4GfHYtYxpRj35+qFZJPP40
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(366004)(39860400002)(376002)(136003)(346002)(8676002)(76116006)(54906003)(316002)(4326008)(66946007)(33716001)(66476007)(66446008)(8936002)(38100700002)(44832011)(122000001)(6916009)(66556008)(64756008)(5660300002)(2906002)(26005)(38070700005)(6506007)(186003)(71200400001)(41300700001)(478600001)(9686003)(4744005)(86362001)(83380400001)(6486002)(6512007)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XK4jLTY5h7zJMmn1pT7/Eb2H+b8ecgemaSnqXJTPXq/TDUbUz8IX8ecnPHyu?=
 =?us-ascii?Q?0TkjS2hh74ykygYPV9pO8rTFULqwaCP5kzNbKdgS6QgY5ZycSDsbI1obx36x?=
 =?us-ascii?Q?j2W+vm4ASs6x5+IJlYH5zlLQ5Aw3yqotd8iwndr5T6M+xb2nLATKU2K0ZUPv?=
 =?us-ascii?Q?0vvRMK9+jjeXJCqLaH/4fVzq/zVmpJrjoACCnC4+7L05zBDv3DOle0GZE1d3?=
 =?us-ascii?Q?tBvJ7xzHW/EMZJ0WFP30ShD2QOtiXNUZi050W2Riy/FBSXL9L7ol12vidbDV?=
 =?us-ascii?Q?tvvDEr5hAYO6wU5IyY7Xna3aD7dUAgKP40cQ0Q333MsjCDraCqyP3VVaGWTI?=
 =?us-ascii?Q?II5DdidSjllhweMX9R1RcL42WelKpdr+65IYR/lLIwVsFW44om08w1agDPjF?=
 =?us-ascii?Q?BilMvy2czXqK77pybo3gRLcEhM0f0Kdw9mc+PkqLkRYLGHlKYe7K5YB5mvAF?=
 =?us-ascii?Q?e8kapcrEZ6CblVHRAGcklGxi9WPvs5rkzhp9oihSvhJbnxQlwrsAtbfhpv7S?=
 =?us-ascii?Q?/inqgi+0pR6zIw2DHx198Xh5IqCxnG8riew0Sf3Rzx73qrSDXgcF9RSrt+Vj?=
 =?us-ascii?Q?paZVO+JoT7VSx1d3+H2kI/ElLcLKJF7skAlr65cw5sY+VXoJZPfM8Yk8jNHe?=
 =?us-ascii?Q?h57gVBpPk76b2plOE3gaaeufdaJsnav5laqIabmEf4FIuZGyczxhXnSoKERe?=
 =?us-ascii?Q?LmG3Y21n5NM+zdk7KqPqMjCUZ7lTZOgxP7xeLjeKLPXlOsrYc35DdwWa+vcH?=
 =?us-ascii?Q?j7epFoTaD8MYtr6FXB5Yy5MlfOA9fjiapP17iLXjAirMTqdXdxZjt0OqnrPa?=
 =?us-ascii?Q?ays12ZNSgs0tEajtJ5YcWi91P+JzoAt3/Xa+dmZVXz7sHwugUSL+cEpWaW3j?=
 =?us-ascii?Q?ubnK/bVwZwyt99Qov0ELl6H/6vc2Ur8oBNWc60PIqYIM2cZ2xpJKh6XCbFdB?=
 =?us-ascii?Q?/C7mycYf5Wb10vLf8U1aoK9BfSkEG4jMUbD0br4y574I2oQUhPIo0v0qqdGl?=
 =?us-ascii?Q?z0Fpgr7gXBaGRdELV/4E/2vIh3bUzWd3MtSXZh/7P331Rv29dVBdehYHo6qT?=
 =?us-ascii?Q?XfhsY9zxQLY5q8jAiovhFnXcsQLHDrG5dftvtvFgI4yJMeTX/rI0JtpF6gLT?=
 =?us-ascii?Q?8eOyvATgldiH+5sE2e9p820azV0cno252bqrPJsC+b9wjxFFQx0m31wxiaLR?=
 =?us-ascii?Q?R70B4r18QLccIlvTOjfsY2ilYcen3XERG8cSgVkWLcUxR7M25ZOOqkx+N0ms?=
 =?us-ascii?Q?mhAgG10RQuCzLqpP3eCQnuYQ05kkc29Q2wz40OxoSQSXWFykKwI5dM67Xx5N?=
 =?us-ascii?Q?XFgpWVDqK4ZU1rvsb8uaqKoN9Awbs2gd2IkBpEB+u14pgCjRv2y9ApImNYNP?=
 =?us-ascii?Q?fSbudqnetKZp6zdZi+SGr+EtOWAgTpfNitf5B0BC2YlPVCexv24j64QjsAsK?=
 =?us-ascii?Q?4nAea/GKsNW42FHjoF2SkoH1dfDIXik3gomTRrW42spI6ZdbAdpZdQceuWnL?=
 =?us-ascii?Q?cTFpggD2Sy4cocEvtrZnYQyo6glVNPGjqMAHqwmL1c83G754rWHqy6mMtFyd?=
 =?us-ascii?Q?wC47CgF86OQwXTYDfQGqyP90YykbYl72EEePaXk4dPStVVaY0cgdkrHmsRM+?=
 =?us-ascii?Q?+w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D964557478DC1F4DB226E708862777D2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e9dc37-995b-4119-4e60-08da804706cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 11:52:57.1276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IH/lvLEWKFmGk+R3mg9x23eXlFIoIpuqugKN4EGdSjOEUgIHaTvj8chrTCLYq1tsEwZfgZB6GFGzE1RvC510aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 01:27:29PM +0200, Michal Kubecek wrote:
> On Wed, Aug 17, 2022 at 01:29:14AM +0300, Vladimir Oltean wrote:
> > For a reason I can't really understand, ethnl_update_bool32() exists,
> > but the plain function that operates on a boolean value kept in an
> > actual u8 netlink attribute doesn't.
>=20
> I can explain that: at the moment these helpers were introduced, only
> members of traditional structures shared with ioctl interface were
> updated and all attributes which were booleans logically were
> represented as u32 in them so that no other helper was needed back then.

Thanks, but the internal data structures of the kernel did not
necessitate boolean netlink attributes to be promoted to u32 just
because the ioctl interface did it that way; or did they?

Or otherwise said, is there a technical requirement that if a boolean is
passed to the kernel as u32 via ioctl, it should be passed as u32 via
netlink too?=
