Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06E95ECF3C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 23:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiI0VX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 17:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiI0VXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 17:23:24 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70055.outbound.protection.outlook.com [40.107.7.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9551E7680;
        Tue, 27 Sep 2022 14:23:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIiinirGkfwx/Wd9D2nN8BwhEd6NlVQYviJ2w6VeeTfGZEhCqRwjNTghSfVAUXqORHQe5LPmUcnA2oO5yrZm+0F09Qh8lvGGpj0HsBZKkwjIqX+zX63tyxTaY49ODmS3vukVKnP3rKui+i88BZsy0m3VDkssICvEuHqYFif7pYPAJHdeX+f1NMT5iwRvkB+HOsqz+yCDwIrHeiihxIwkLQkbzp4J+RIrRn+cIQN3pZPOjiHKSI/n//wwez9BBF1sNJw8A0kxJelW1M5Nc9u0L0JLPLwTBNUZs0WKf4bdfMRM7qMQU7moBi7LxEA+VM5v8DD2hqmm03gp8XcSMM+5Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxyu/JsVO8FNzCymtW6FoKhBeEronRGZ7cpMCgg1B1U=;
 b=mIKIXejLQyChpMhzuUtsVgjv+g+/P7Tg+ugOYK4Ns9mMqlmZIWOyc/tMm2XMKp081QyMa0LCijEbod7aGFPuZgmlCP5Xpzsaw29GUxA6yFN9zGjBFHe6jdEh6GrcVwVdD6GJGq27zmSlk/xWyZtKUn2dh1r0Bol6JGlOjEfzrapjiIn2ReWzS2l4hn3BxzcX+G7Vs5flXGaQTx+ziNHqN99P+N6jCnV66ixuN6RZEbnquGtBFlD8dYB2e4ZGGoVTXIc0FNNg8p7l+VMCuiRQAHGZHgv74dFGeOZ9ZBRtzzeje4CMjF26YNmvy4b/vZ6WYu9Q8FEb0L2x6wYa5ECc3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxyu/JsVO8FNzCymtW6FoKhBeEronRGZ7cpMCgg1B1U=;
 b=C9Pdtxq74ViOIv5OE4M7+mXNPTf0UMetdSy0GK0vwHkWJsLhVRE0tE0TmBVbr5wEC+ZMMl8vvy3XXR9XU0Ox1Up37mNzXlBE09ikQBarln4DmhvpJwmRageS08BAGdfoxVf3TPAKV5RAK6UTt6wCwtmocsdVUkN7v+tmbWOAvss=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7200.eurprd04.prod.outlook.com (2603:10a6:800:12d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 21:23:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 21:23:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 01/12] net/sched: taprio: allow user input of
 per-tc max SDU
Thread-Topic: [PATCH v2 net-next 01/12] net/sched: taprio: allow user input of
 per-tc max SDU
Thread-Index: AQHYz2o0SHeyglH9xEqJb2YB0CkMDK3yMQqAgAE2X4CAADdFAIAAMTeA
Date:   Tue, 27 Sep 2022 21:23:19 +0000
Message-ID: <20220927212319.pc75hlhsw7s6es6p@skbuf>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
 <20220923163310.3192733-2-vladimir.oltean@nxp.com>
 <20220926133829.6bb62b8a@kernel.org> <20220927150921.ffjdliwljccusxad@skbuf>
 <20220927112710.5fc7720f@kernel.org>
In-Reply-To: <20220927112710.5fc7720f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|VI1PR04MB7200:EE_
x-ms-office365-filtering-correlation-id: 8d0cd036-cea4-4687-7ac8-08daa0ce8029
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tf8kmJSoEJ7oJsef/aWYRU2u46aLzoYWMkVRV0Hq2OlFOEsPKYU8Rhmog0ZEnzF30MRZNza11EycB1FT92SaWKwiU27c4U3n7mu0oaWjEh0pc/K11e1uCxyDxVaDhkUP9Zsr2zyXAg1Qhf3l7RIH1efZrYORkGH1SeEKK2R8bnNIjxkvPb17FulBM818txp9mZpucuto966qvVfoXhNfI9OMEewEpuQv5RaFXWq0sEUGLMmw/Q7s3dbUj6T+vQoHw+iUHUMJKVU6dnbm57mK43Ngql1v8Vjl7KOZ5KFcE068muLZDMq4cd2PWTNVT5HeLORWQWOFnJ2UGghnHM2GWQYgUtps3fX0w+qCRVPZCgpZgOuu7Bz8l9+X2b1QT86Q47nZcz5V3j4a4LK1dp86mct2qt4iXWmNMG1NdoOHcH0Nv+GqS+dHhY6veA/6leiNuy3kAlH+9suiyrcppKArEXyz6AWnH0ex0YrY0Oiw/nkWQV/SGsTPM8KRCjjcnaReNMVgKAe0iVYcGKr6yft+FTrhozhs3hNgtG4ouvN/dKkF4Odk+wpBADz6sFB1YiqMnlToqpmcWMUd1F+D8Y10UqQe4oxDQCJE786HwgNC7I2AMNfX1ZNBwuUHRCs73oCqBaXRtMW8cdQTwLgxQ+pLePTAnJX7It07LVAsNV1zik8rIhT3GsrUl0VVjqu6JH3mLZKXmlCsPIabLLLuMaohN8wjGZvlugecnoC5SsqKDGo7t0ECvcnfMBpe0a24AWODRYAlRfmLGJjDOCDFZDaNoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199015)(38070700005)(76116006)(8676002)(91956017)(66556008)(66476007)(86362001)(66946007)(64756008)(66446008)(122000001)(33716001)(38100700002)(8936002)(6506007)(41300700001)(6486002)(478600001)(9686003)(316002)(6916009)(54906003)(26005)(44832011)(71200400001)(6512007)(83380400001)(5660300002)(7416002)(186003)(1076003)(2906002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pCcCHYsQl0F8oPuF7TYWOX5+I/la3uolMNKLfGbWLKLrfh2wIFkEetwntvPx?=
 =?us-ascii?Q?LyU7eyak8sdZqgVF7E74suNOJegpEj97DHs8Mz5vPl6Tz7rCSo9mQAh8J3uY?=
 =?us-ascii?Q?ay+ONkU6VMf3G+WQO2LsHBBcSDMYNh9T5VnF/Bpa9dxoICu1F8ER8pkhCVjE?=
 =?us-ascii?Q?ObGv0imnV1RbgqBBQuUq3Rr2p45aIqKfl/WDFnvdv237n0S6mbTBYhF/nY6Y?=
 =?us-ascii?Q?KcARzJEnxOc2HKQPB3H3hevbKnHfvgkPvZHeAIUYO9fbzj2DHprbf8viF1vC?=
 =?us-ascii?Q?ZiWfNiutUcF5CyQq53ZtC7adU2+EjarEHKd1gkK96oxuM4sbXRV9yJ8mMhUr?=
 =?us-ascii?Q?CaBQEmAOkCNztCn33h+0d7uutp8nSq37UqWLT0BqC8VKDfUENkow4+md80qt?=
 =?us-ascii?Q?QF8uDuJe5Hp1GeCbVIRt5YjOw+rTXQ0Zhtt4IHtiK/PHvOowDEtD79OQZISS?=
 =?us-ascii?Q?JjE5bM+sI45P7jVzY4zN6arEj6EAbNxKmAzFHSl8GENjkvtIhh5Int6qvKBF?=
 =?us-ascii?Q?MqLsBgdct8tfQ7nN97ku+0+wCM1EV0OFyDXFyy7HJB8qU8Si+pa1vJbVYzVz?=
 =?us-ascii?Q?MLKySbiF5Net0sCVeRlxCpnQPNv9jCNBD+I7QIfScJrbXXcn/A655LzrjAyU?=
 =?us-ascii?Q?xF/P1bTfN3gLT0ljXhOmCB4rVEHNkm2Vd5jhl/9y9v+yGAFDxI1eEyy7L2lQ?=
 =?us-ascii?Q?UgHtbnxBwTbQtyq0nXbaV2Inhtq8cLHQDIT8qtHLIUg8c2e3lnXPDBI2jRdB?=
 =?us-ascii?Q?atr8cWOekR/yMLwD3NDqZ73Y4L1UyRebb3Rx2MFySSz9ZeX5kDbq5l2tk4xv?=
 =?us-ascii?Q?429UdANwrcp5cY/YSPvhBDd3yrm1ly1OXKWKUc7OsdbbGWgpNRLcXk66rKxI?=
 =?us-ascii?Q?QNmwKzmc6WV1DXvvcMebhuD9/+HeuVsRx5XOufpsT4V6DzMpLG7o9BFgGMVu?=
 =?us-ascii?Q?MeGsF2CAEyFQ4xjBcNKZl7LrXEA3yFcVxCWzz3BTgzBfZHG8prcSKwheIxrB?=
 =?us-ascii?Q?sZGLSb2DR3GgO0k0va4CUIRIrPB+OIv8K+UHG0q0yrIqacvMSyJpe3ggvX+X?=
 =?us-ascii?Q?kKTTDsj+T68Db3yW1WLynkEh70Ubi0pDr7nqV97wygYRujhpBt4cj9/gF5b2?=
 =?us-ascii?Q?RuheOvBMUUI/5Y00LqKm/XxHUsRi2CCtXIbfE2GGc6A5/eNTFcAbSLj34jxm?=
 =?us-ascii?Q?M4JCkgksPOn28e5WVt0gSbnNP6hNVwVBDPgrkGj7m9vz8BQQuDVp/WgVpmnn?=
 =?us-ascii?Q?Acui4XLzB6lGyINvW711azsE2IfF6z8hjwa/8RKA7LejautSlF/moZU3k0JJ?=
 =?us-ascii?Q?o7zUu3ekUUNhKJUrmviVinVvDgUJ37GVhbXTuyCgN4Pgk4g09OC5ErB0EGgY?=
 =?us-ascii?Q?d/FN+ITOsf42GYYkCd44cIC454EISWgqbqucWAk7fSKlE/yy4Lu3/BOhXKBi?=
 =?us-ascii?Q?MCvfVATm/U5hoyKhZASHzfIGP6DRerNIQ/pRNrPkU1Xj5SuzrBN0W7kmQbBD?=
 =?us-ascii?Q?yUPRRoPcpJkf0jT8EMgd1k70QEILLdiK2cL+ulVbfNB/8gljkJOggERbLcur?=
 =?us-ascii?Q?gdhYD/+0DwnWfUuIy/hZQjl+uSkwZs7fRy0Han6JiEX8l8iKHU4JWuJ3UsXx?=
 =?us-ascii?Q?eg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0E2028FFA1217D4D9E11097DD11F702C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0cd036-cea4-4687-7ac8-08daa0ce8029
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 21:23:20.0099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7YKlToVxDeV9RzrPPpvfOrbEFYyFPSr/dB+KHzqeBDvpBbjKo2HPV5BqrEh/dcuxRUc4GDFMuJuFjYFb3voY9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7200
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:27:10AM -0700, Jakub Kicinski wrote:
> I know, that's what I expected you'd say :(
> You'd need a reverse parser which is a PITA to do unless you have
> clearly specified bindings.

I think you're underestimating the problem, it's worse than PITA. My A
still hurts and yet I couldn't find any way in which reverse parsing the
bad netlink attribute is in any way practical in iproute2, other than
doing it to prove a point that it's possible.

> I'd rather you kept the code as is than make precedent for adding both
> string and machine readable. If we do that people will try to stay on
> the safe side and always add both.
>
> The machine readable format is carries all the information you need.

Nope, the question "What range?" still isn't answered via the machine
readable format. Just "What integer?".

> It's just the user space is not clever enough to read it which is,
> well, solvable.

You should come work at NXP, we love people who keep a healthy dose of
unnecessary complexity in things :)

Sometimes, "not clever enough" is just fine.=
