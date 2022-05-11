Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915CF5240A7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348520AbiEKXRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243277AbiEKXRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:17:52 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70072.outbound.protection.outlook.com [40.107.7.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DEC52535
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:17:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5Byv5p/9XX3U+mvcz2PdHf+5lANcAos57SJZASFgypuAQFVt8bCYVbb1vtc7CZ9iYJy7S/q1iHSiwhSp3Y4AaZJC7Z8XoUiJML4SWxNGyv5U0/Tuf4ql5f4ZidG9X01L2waMIV5Rk/giBQAYjBULVRF+x1m4hBL0LFeaZQVq8YKhT5EkZDZOR2AZWs6XqefN/IoE9AssZux+ZoGmPNnG6ZYtImZ5n6gLo62GvFLu9dDIHxh/W+4RIR4phi4Z92MH6dNOLtHiiY8YsHbzHAlPOXdRNgbkmyS1jjAQhFvu3cUl5Zukr4CfbK0KIhR7fj2yeyRhFfZrkfE3wW8yRbRmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFbXgbcmwkvqPTexqO/+TTNhT1GHmZdTKuoEldaMKdU=;
 b=fTxR/S2Hn0UB8t6xdLk8pTdCDOzKPSdN9kRs1PrkrxYcBueIpWOxZBIHmXo5XOB0VJtzcd2ylueQDKqREaLzAE6ilzhpdY6UES57hyYHkpBFVDzZwdtJSwAZM+RYg4EvhBiHbXK7BrDQjZMYEv89AWo8mOJcw9fTcFiKr9nDQOwym7eiJfq58YSDkQ70fDP96ycMCZyDlQjiiNffW7RpMTHOKbEQVffbTBiGXBvF0+Ny4YoYgtUBXUBXC8OPqgHncjyWmEc5hxeshnjjK4xws6hsLk+yRFCewRX5s8DkRAIui09v9Wdu3lBNyUf7MNxHTIph1DIkSEEkg2P7boJBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFbXgbcmwkvqPTexqO/+TTNhT1GHmZdTKuoEldaMKdU=;
 b=salaa3g6JvDgtrAJpcggHNz8fbRl+nUdi3PSogu3Sf6+gmJqIQ5r3NQJcqozG8cpaSSsyBqijfGlxJjBILl54rdqNI3Izy42K4Q2T5LE2FPeCbzUerqaLhs8aGpLlIGaa4aRlxTtMXuttyPEfhjwXQ+4JkAEHkK2fzWK9TZmT5w=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6083.eurprd04.prod.outlook.com (2603:10a6:208:141::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 23:17:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 23:17:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window drops
Thread-Topic: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Thread-Index: AQHYZIwYAyud9yi3kkettoRjyMxmN60aQ40AgAAIaICAAAR6AIAAAR2A
Date:   Wed, 11 May 2022 23:17:46 +0000
Message-ID: <20220511231745.4olqfvxiz4qm5oht@skbuf>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
 <20220510163615.6096-3-vladimir.oltean@nxp.com>
 <20220511152740.63883ddf@kernel.org> <20220511225745.xgrhiaghckrcxdaj@skbuf>
 <20220511161346.69c76869@kernel.org>
In-Reply-To: <20220511161346.69c76869@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15c6fe79-5148-4c30-e027-08da33a47584
x-ms-traffictypediagnostic: AM0PR04MB6083:EE_
x-microsoft-antispam-prvs: <AM0PR04MB60837FE474CD35606604C284E0C89@AM0PR04MB6083.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hFS263gduzXd30aNYh8fWHkwPdz/UydoxK1JQGOJoJ15FxY8KyGQw4SEy+eel1xq5HRflAWgGGHZ3c0Du5Vpl24zMeUKG3+FLMtr9RWZG6Uu99yavsvZUC9TQ8/ci560IXppMi0jdRkNbAwCqG8kpNv+NLyZKDcN/x6jzcsKBeuNBkLFFeJqpniC349/9z1YSW5wgnFkD7z7ibTkpj42ttcsxcY/OxtWD43Ww2oVcFyooKUevjsTXvsSq+BDcNPhhGGW83JtAQ8GglF30J7g3XTl+AA8ZfnsvPa7BxMYvsq6/5kNzJvFQzs48XYJZTEhNa3J+hO01uJnAVH2qmNX2R5B4g+AGAZpYRmr7tMJDS7Ngum+EvDbokKhIQBHvMi2papinTKRF52pxIlBO7SrV+GvQ85Ty9wNYI0158iQlMgfByxWhh6F90d52TgKK1qYV9/KjDNCZqutixz/fZ9fHVp8nS/8cXRYvp605lJQ2uioS1O1+RX08dkhWvUSWBUXbppWA7hCeayzHUIIyMjJoKOn6WCv9qhG0M+DOkuiP81g9/3US52JpqQBZDdOMyo6a2QqfCff1x0K5ztBQGrM5oL5cSY9mQkYQ4StXNt3EFrYbHeSEyNKoHkgZaHWsEvYOILKJjO6nWeb9q5qZj0wihhn6DCrczC4qgdMfiYdayJ4j5qARxp3umTQxp6Xs0k9rsbnE1HIUhEPKaEyg/4XbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(8936002)(44832011)(4326008)(8676002)(66446008)(91956017)(76116006)(66946007)(66476007)(71200400001)(33716001)(122000001)(6486002)(64756008)(66556008)(2906002)(6916009)(54906003)(86362001)(6506007)(38100700002)(38070700005)(26005)(5660300002)(1076003)(6512007)(186003)(9686003)(4744005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KchQvFGn67yco6jl3GKNb8zeonowejyOAThaNrIJtkP3rM8yQfxjDAYWE0Kt?=
 =?us-ascii?Q?MQCdOOuz/NrNXZZA4qoc9b1ZcDatTMPiKY/Xn7jpvdcr3/wzF+/kOAt8tNbl?=
 =?us-ascii?Q?vpxk23KSHwyaJs/ScEBtissfnt93f73AFwTOr1p0dTIYJvBUM0qRvX6obTqw?=
 =?us-ascii?Q?SWinln3Od0+lZs9LOZWk1yesnvQpoiuv6FOY8ktLvvEiRvnVbVWLn0kBi9mo?=
 =?us-ascii?Q?oDfZOvwN8FsiopD+FNiufXG5sbwaL40uAunSF1Db5YT7NfN1Jeot9OAzhEfi?=
 =?us-ascii?Q?QukSohFaQiWyAhFtjZMNyd1MHPFYNUgVDUuQULMqSuAFQ4y6LIA/bO6LlLWw?=
 =?us-ascii?Q?800q1DZ83l81Hc0mQO/AteCbfq85rH0R8IdbQbdruHx59zVXwg4paVFFamhc?=
 =?us-ascii?Q?TE4VtT6htQvE96r+p91s7DJP5/gD2gPwYK1T5x6uZ6yih3aCl1TsL7LH1RUw?=
 =?us-ascii?Q?ZfbjbCLahfzjaU9i928Jh4ErAZf2ympKcE5rJhbCFpL3w+XpfIesGS1s0g21?=
 =?us-ascii?Q?SWMr2j/7mN4V6I0SF6dmXYMGyZeesbTLOo1RSnpxbQQW5bsVVfvhsKonqR2b?=
 =?us-ascii?Q?gb3GzJ0TwUQkR8+cAHxY5gY624ZnmAvlTh0siH+jm8xLn9GQRf6lRAfx03yk?=
 =?us-ascii?Q?01MCSQp9Twp6TwLHBuY0IXN0emyKE/W9uzAX+pKfjATGEYE9nU1kOKiA5GFx?=
 =?us-ascii?Q?urdG+EpL1DADECsfnRZ+kvRMfVvQewZG4jQ2YwWHEVx1Zxb1KjsQqsuozbxC?=
 =?us-ascii?Q?lAqyO0IB2b9y8Xy0NsJEUbySwI/KCJ/TZjLTOrNtDLPK8L6Uyw+gtF8jytMQ?=
 =?us-ascii?Q?kzGYBASFa3bdd9xrIiF7ZBpFnyZSH5VXpBNaDMS0XOYdW4ZCLgYiXCL520/I?=
 =?us-ascii?Q?Ip7/xHMCvVVUk1ApJpCiftitRnQSTqPJUApGa9dK07d3D2/J0d9bOx4/29XO?=
 =?us-ascii?Q?6dyKN944C01fM3VZ2vhdz6gVStIzD759E7YRYW+m1i8nPwRIEnQOnUM/Bet9?=
 =?us-ascii?Q?pb4Eq5Q7VBtio0z1xPPD63wT4ZUOcWBHYtUxKGLZQ4v/EERZEwTTCYv+WsOX?=
 =?us-ascii?Q?5mgEE90WqXa/0gRQng5v4Ut0Uvujy/aVO1szvBRXODWQCr2Np5Ug/u9HN09z?=
 =?us-ascii?Q?vydEnH1F1CfNd6hoaG6RS8CuRFSiCAmKuB4GfdkjNbweqVbvteVtZXzZLrZ+?=
 =?us-ascii?Q?uaMpNnrHH4P8HPLFiGF0Sx5Ef1A+uQIktEW1tCtv0JsgmpYgtBPdUrtgLcr5?=
 =?us-ascii?Q?AZvSYtS6tva28NZkjzdwylUnrAT+0dhk3TUAgk2qZ3gWyzXkhKtamOs1U3fP?=
 =?us-ascii?Q?DLISrp/+2K1g4RhOhbSI5iTWFH+CUwTD/WOfPOX2iie7vLzqqefkFgmvaRcB?=
 =?us-ascii?Q?LI6ox7E4+YlVlMx3fybUDiGHtP6/iNnGLC/V3YyVKkGlE+iEeZhGGQm+s80f?=
 =?us-ascii?Q?6LRx7YKDsZ04fy1Viz0J9Nm6xAD+9PGy/7migLoge0IUHKey6q0GKRNNSdiT?=
 =?us-ascii?Q?U1zIAp1hz/hDHG/P0SG2NhaHUfCMyHf92ILBsAlvnEsw9WrpJLLETWxRFU8A?=
 =?us-ascii?Q?Loh7zxVRMOpzWil0AfNtHf5zwUSXinhJ6qeDKhL9b5zwudRXOjdHyBXh4eHJ?=
 =?us-ascii?Q?W1Y4EFN1m5xa+3zyyv+5Vn0X6yWJnz+04+YMQ0H36Fqo09PPJhvNdWYgEGwM?=
 =?us-ascii?Q?8ol/CqCXbaXOR4458E9b/uLneVkF/44b0yisIAZj51dNAXsllyPvZ8m/TD1k?=
 =?us-ascii?Q?weUg/O514PZgOijxZmallaxNFY1RJ/0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4AD2FEAD722A8E4A9626492B7AE53AFF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c6fe79-5148-4c30-e027-08da33a47584
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 23:17:46.5173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5JFRTIKw5ZBqFsaSjNjAhdpIXa4thBJMzR8S+y9MUiAeWYIeilkzCZ++69/PxFFZKJpdRQGfg50RxyzDhqu78Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6083
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 04:13:46PM -0700, Jakub Kicinski wrote:
> On Wed, 11 May 2022 22:57:46 +0000 Vladimir Oltean wrote:
> > The only entry that is a counter in the Scheduled Traffic MIB is Transm=
issionOverrun,
> > but that isn't what this is. Instead, this would be a TransmissionOverr=
unAvoidedByDropping,
> > for which there appears to be no standardization.
>=20
> TransmissionOversized? There's no standardization in terms of IEEE but
> the semantics seem pretty clear right? The packet is longer than the
> entire window so it can never go out?

Yes, so what are you saying? Become the ad-hoc standards body for
scheduled traffic?=
