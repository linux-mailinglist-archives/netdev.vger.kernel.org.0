Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F2651C8E1
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 21:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350282AbiEETZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 15:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238070AbiEETZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 15:25:53 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2044.outbound.protection.outlook.com [40.107.21.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E6E532FC
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 12:22:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4utvs9prnyFWL/4GMHNbRHJB7dhATtZUTx7a4T+k00MJ7EAodUTSKSk1RXiS1ImBMbj01h+ECMdguhk0mGpzkJnLvMPpFOzgQQFbSACk4+y4XG7ine+kP15FzefGrG3cDcLti5q7eyfNGw9mZNGxV1Ham35/vDxY3+BmABF3h4uJ5mepTW5u5huR33lhotIeB3KK2k3e0Ir+zanN0cT2EVWS7xx7tZXjqjsJ2rQHCbzWIiATrUPi0Jf9noycdWbQ9iRw3MbwwxmVALXvJjvUD3wdif5Fyp+22He9DSGB91OjqDvGo6JUePvHfNqiAxagT/CZfqZRTvScXjiBxeufQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrSW7e1BKqctdLzMoG7pIWEHoevy7NZ9HFYZ+gZVXhU=;
 b=Ii0wwp7Cuz7/Pu++HdWw+/WvTLuNdh9bgkGPFcP9vR6wFPZfernCKbqBez5/bGM8sqtBBoXOdlJIXnrLPSCzskMlbSfFN+Is3UU1makfoZGLH+EUqA4i/d3f2FBHLRgS1P8a7RZ/r70ojmh+meQeEWnZhNBGXHv57BwIUst0y4/WNya+D+UITMMJf0Fou0Vyfe8MJTF7bQgog0dsezu0+Cw0k6GGpIj71f5iJx3mOFR1GJwYGeWF+oykz0OAr0xt+z1JD7RUV9QD2T3hUzdguRHyv1VgbkCezZkWTNW6RlKWKPXwVt6wKT36JWkIfhS2zPdp551xXEv016FmpNO5qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrSW7e1BKqctdLzMoG7pIWEHoevy7NZ9HFYZ+gZVXhU=;
 b=c8fFEg2g/wDfnJsEk6DZeMWT77/6m1/M/N0SibGValXxSgN3Yu/458SyKojFkRD7CsIAalk6Qn8AypitnCc7BlpGsWaLi/Q5zpbcgHvvbyqHrRl/qHjgte1qOmhvM17BTahzfKRi/HTjsfZfrDkFn1uSHO+d7YfFVJjEkT/hSGM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5146.eurprd04.prod.outlook.com (2603:10a6:10:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Thu, 5 May
 2022 19:22:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 19:22:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [RFC PATCH net] net/sched: taprio: account for L1 overhead when
 calculating transmit time
Thread-Topic: [RFC PATCH net] net/sched: taprio: account for L1 overhead when
 calculating transmit time
Thread-Index: AQHYYJnB8bP1vE+k80yEOJUfchIIPq0QiRkAgAAghIA=
Date:   Thu, 5 May 2022 19:22:08 +0000
Message-ID: <20220505192207.li47vyo74tizucuy@skbuf>
References: <20220505160357.298794-1-vladimir.oltean@nxp.com>
 <87bkwbj3hj.fsf@intel.com>
In-Reply-To: <87bkwbj3hj.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c0cec8f-d369-4c56-6131-08da2ecc8c41
x-ms-traffictypediagnostic: DB7PR04MB5146:EE_
x-microsoft-antispam-prvs: <DB7PR04MB5146EF08A7C47EDAC2C8F49AE0C29@DB7PR04MB5146.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /qFmfUVcPEI22J5CUezk8I9K3hqZO+/ca9MNL88E3vRa1TlfKx+xpD0lzM0ClOimg+p39/fCJf4uncb4xuD2TVhyQuDFlINMrjwZIiNaFL/0wQ/nejhzaYajyo8nDVs7UX14+sPF85dTsMyL6SEytk1hTQLv8rf8lRC4LiEQCpmM1wmMUweNM955Krg2aYMlacKm9Q+4WaZebawplD06LE+4shFpJIpKDyb9Fcsk1NAXCcuVcyuUqsFq5FisEPvnqha5i36jQEMIJqBk8XLoRAtxgzosEqL6jZWnWdtMVXhYjb/kzaZ8t83L2ZNdWeE8TGJSzjv6HGCWpCHxH20UgejjuIULS24gkq/sLptfi+BeKtFbs+22XiiQYeTSKcJIBP5x8UN00THVOwj2Ilo4X3q2V6nWk/cpYW1gj/yf0lPqA4bTCIZ8Ahv7pVGnFwo/L8FQx6/6gW3gWuEK6Wo0svC7dot1JpxUqhFGAkt70dOUy5ic5M5n6hzXqF0rsV3CqWby9gz5/rR7hfVrLQ5TdwwU2TIBlbSEnUwRI1RKfwMRTWq3zbtCm9K490hW2vEDySQJ59cX9Lyw92vUwhx1gy6hBqGke7SNX0zAu3fGL1b3FGIVPI50G3SjLElPoB6fEQtIdw/Fg4Wn8SMtA8J479Tmn4gE8wFbWvBQL3fIrBN9U8p6ciboddLpJ7o6EcuGGUYnNXG3sbIdgAhNnK6SwR4vqNbZdQfirE+1zsgKxC1XR0GOrzjcGEGADpbnVCdd/fI7MVoExYqN9o8iLCMM1jRs3JyCXLr77mWnfoD7BAo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(33716001)(316002)(966005)(8936002)(83380400001)(76116006)(64756008)(91956017)(8676002)(4326008)(66446008)(66556008)(44832011)(66476007)(66946007)(508600001)(54906003)(6486002)(71200400001)(6916009)(5660300002)(6512007)(6506007)(9686003)(15650500001)(2906002)(1076003)(26005)(186003)(38070700005)(38100700002)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rk/lody8f3EHwlXEqldoY5i79KYH5ySINJcvCH3CmkuXl9qwlQe1XHn9QiOc?=
 =?us-ascii?Q?gbzqPAL+WVauFcGYKLohAYY6RKaXHcbVe6rSvnuW1nn/cID5jb3i8jrh+Qwh?=
 =?us-ascii?Q?Hza6SGlSWp7xvRQ+1p2spTPAhmYYL9UXo2cnenj7NGGo4W5M07u1+gpKuMGr?=
 =?us-ascii?Q?oPNDF9DzVhajZfDCrjtjIy64pF3jDp+rjhwAExL0pQiXwazzUWqLejLOgQQ9?=
 =?us-ascii?Q?UvkgA62NqBFZegYxASX8TdQkZ9dMMCwx0EmF9N/8hmecJNX4RsK8ymL7GoN8?=
 =?us-ascii?Q?JChlc5FTna4P6/zRfA/MrhB+dUKcD6IWwu9h5qyQ+MSOmF4qhr3xVglVPmxE?=
 =?us-ascii?Q?agjEyFfJcALevcIx2vZ8GQDGi8zK2yh5/w9l2qWn7vJFvt44qAKvSMXwMkLm?=
 =?us-ascii?Q?hjXgx+t5+cohKsKPVKVEu1GNtkPooUkuDsotma/2FEdmxTi0wp/BJhCr8h63?=
 =?us-ascii?Q?mwADCnXD6Bfm2e16SKZAgaOkV8UjjRykU9/ZAP6Wh6zNlwDabtJWaBIxedwD?=
 =?us-ascii?Q?x1ocmZMNIEbRVJJvjoD42tLWTo8O/xgXxFfbarwLCidXwfrnNSXmlH6jx077?=
 =?us-ascii?Q?UyHKsNUa+4XaiCzvrfScRiOHDqlEUr8G5pdqdv6z60UTlP8Zm63XLN+VIC4O?=
 =?us-ascii?Q?1gmCkgmaR6cCaVG+pe0mkMHznsNGulFmXRci6SVtdovvYstdiCs9YWjiH4e/?=
 =?us-ascii?Q?R25rgEfpBbuwKCOvGa6mt3mfZa+ZutQpaM4VYJOBv7Dr6E7J6nFynvq7bpwY?=
 =?us-ascii?Q?HfawK1+WCIUoEObrUo3VmB6whNIhv88IllCjdAkQKU+t2POfTlJNjkH6dDyu?=
 =?us-ascii?Q?8K+L3/UBYUuGpJ6jTNsThptjByHvcXoW/1MHl5GHHPIYSGvl2jzXXB9Wo9wS?=
 =?us-ascii?Q?q2uuTCEPF4Es6J1rTx7tQJAaTDj//AkSp9fbcqkCQYbn0x7jDdhB4Y/GKWdc?=
 =?us-ascii?Q?VOjmAFO4zlhJImoV+vfMNjv2VsGU96tZSow4Vg0ZKwPbJQ52DPG3jppE2e2D?=
 =?us-ascii?Q?aydEi2wMhxEW5w/39jNFn2h2coPJ20FxNybuUB9qeKuhhFxMlyknT5cxjvet?=
 =?us-ascii?Q?WBLaIfPcFsEXUUEZUGf3Yi//uJ2uzz7aNNmCkiT/mg8EHgH49xe8vrSLr2Wi?=
 =?us-ascii?Q?oHgPxSGCfpIZxGQW7JxUc8HBJMtq1HDqM4a1rkr5bJ2EHSMQBhNdPgQRXY/Q?=
 =?us-ascii?Q?RRDHVjzJhslycA4X394nwO0qwsOFbJkQ+3QdFcmxM8Cqw2HidhaWhXejbGk7?=
 =?us-ascii?Q?GF/QOFvrEZaPyCep7qzl97VX2u1MGOstn5rKpxHOBMMh2+KDV6UEVt16L8vS?=
 =?us-ascii?Q?H9yVMHLeD4APqbev14q8V7RYv39uFtGwe0kXgYWU1vhzefm/Q6/FPp8oPJ6k?=
 =?us-ascii?Q?jkW7IfbN45a32NPD4X3j0ZZWUndWn9wxOKW0aRmLhKCS9+PBYJERta3wP5FT?=
 =?us-ascii?Q?OQ3K1Ue5nDkJZBvf6/kJOUYj/2EHl+pubnwjq3H1NTpl/7ggUsXV/3Sge+Ir?=
 =?us-ascii?Q?A8OVDP1Km9Fh2yHW0SCqrlDSCe/I42BnOYtp6aalTYCAtd79XTBPNBlW1Mhj?=
 =?us-ascii?Q?WMnqZPMiHEjgoH+6hih31NtkNMHuKgiKcK/IxXQw0t/hAu+sfz+4bxbhog7q?=
 =?us-ascii?Q?I0NENYKyWgbZ+9OufcSHcPAQ5PM+xOm1n8KLFNM7TP4XLDsvqGVy+ucHjoYL?=
 =?us-ascii?Q?fWSS9MKQV3x1QichOBMYroS0wOne0huYh7iYDZDOPIFnaKxA1r3BplTIk7pD?=
 =?us-ascii?Q?6ty72BIH2rT8a5jPxoUp3Rhy6f3fc50=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4AAAF1178C8FE46800038BEB16697D6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0cec8f-d369-4c56-6131-08da2ecc8c41
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 19:22:08.7491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gycYb1jOvkAyJCaFKOr8K0leCcGrNff+aDRmAmD/JscOx8txYMGf5SPP4m85/8IOeG9oU1oPNQl3rZU/TfNYOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5146
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 10:25:44AM -0700, Vinicius Costa Gomes wrote:
> Hi Vladimir,
>=20
> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
>=20
> > The taprio scheduler underestimates the packet transmission time, which
> > means that packets can be scheduled for transmission in time slots in
> > which they are never going to fit.
> >
> > When this function was added in commit 4cfd5779bd6e ("taprio: Add
> > support for txtime-assist mode"), the only implication was that time
> > triggered packets would overrun its time slot and eat from the next one=
,
> > because with txtime-assist there isn't really any emulation of a "gate
> > close" event that would stop a packet from being transmitted.
> >
> > However, commit b5b73b26b3ca ("taprio: Fix allowing too small
> > intervals") started using this function too, in all modes of operation
> > (software, txtime-assist and full offload). So we now accept time slots
> > which we know we won't be ever able to fulfill.
> >
> > It's difficult to say which issue is more pressing, I'd say both are
> > visible with testing, even though the second would be more obvious
> > because of a black&white result (trying to send small packets in an
> > insufficiently large window blocks the queue).
> >
> > Issue found through code inspection, the code was not even compile
> > tested.
> >
> > The L1 overhead chosen here is an approximation, because various networ=
k
> > equipment has configurable IFG, however I don't think Linux is aware of
> > this.
>=20
> When testing CBS, I remember using tc-stab:=20
>=20
> https://man7.org/linux/man-pages/man8/tc-stab.8.html
>=20
> To set the 'overhead' to some value.
>=20
> That value should be used in the calculation.
>=20
> I agree that it's not ideal, in the ideal world we would have a way to
> retrieve the link overhead from the netdevice. But I would think that it
> gets complicated really quickly when using netdevices that are not
> Ethernet-based.

Interesting. So because the majority of length_to_duration() calls take
qdisc_pkt_len(skb) as argument, a user-supplied overhead is taken into
account. The exception is the bare ETH_ZLEN. For that, we'd have to
change the prototype of __qdisc_calculate_pkt_len to return an int, and
change qdisc_calculate_pkt_len like this:

static inline void qdisc_calculate_pkt_len(struct sk_buff *skb,
					   const struct Qdisc *sch)
{
#ifdef CONFIG_NET_SCHED
	struct qdisc_size_table *stab =3D rcu_dereference_bh(sch->stab);

	if (stab)
		qdisc_skb_cb(skb)->pkt_len =3D __qdisc_calculate_pkt_len(skb->len, stab);
#endif
}

then we would use __qdisc_calculate_pkt_len(ETH_ZLEN, rtnl_dereference(q->r=
oot->stab)).
Again completely untested.

Also, maybe the dependency on tc-stab for correct operation at least in
txtime assist mode should be mentioned in the man page, maybe? I don't
think it's completely obvious.=
