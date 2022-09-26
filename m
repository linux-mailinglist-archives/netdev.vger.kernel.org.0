Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7EA5E9BB7
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiIZIMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiIZIMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:12:19 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2127.outbound.protection.outlook.com [40.107.114.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93CC222AD;
        Mon, 26 Sep 2022 01:12:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf8GsqDCDjvZ8E+Pz1K1OYEClO0tAUA3MIEzGiFkq0wveaBcDuwEweKidE/pdzUL3eCUioaVMD+GQsneh9hyK6vgAfQUpN0xLVkaL4QQ34VzNmWSc00Hj+FP8v/O/mBpbfRnve/nIM1LKK22ulJDZf2eA7NSJ2UumBajrSUe7eftNx9xF/guay0TzerfbrF+HX0nZb1KjecXtK3kV1QrDb2TsPmFkUXkKSCrcH5s48RCeTeU18nOwDkLtNqaLgd6U3IVAwptC3q2RobszySF9dXSp0Q6op5FYCrp4T7mH6FdQy70EVJ4+dgUMgT+YQW734rFxPvaKgbS+sNuWy5eiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JewN34PpSacUBqEcaTaF0FxHMyDvH7WNDcTY1zXiwY=;
 b=H2B4um9Hp9NX7l+3cKJu9x2014jVTsuAMMqR4gL79j8LV6DtP751u21lXfYmZ6bxYi+fA++ZIALWra7rEd9AN8qWTbQzgGcmNjrWxebvR3OuHEDTXLF6RfZu9zeRf9Sooh7RttH7C07CNaRaqi0ZLyZoPPi4jxT5oHOr8FrNPeYcMOmkSIxMVKsGJsVx3BUADtzuE/bCbBs/1esuvaMbDtD2sMdJyVhmvCOoKApCYgcj2CBbxw6GGbIUtNU3Gh1l3vtaf2wuUumDixtSWiCMOQSWfzX2ytY6YkNQYo3C8cQXekCggHAQpBawalbVwNVNCqv6Lo65YALaqVMQLqncuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JewN34PpSacUBqEcaTaF0FxHMyDvH7WNDcTY1zXiwY=;
 b=oLb6HHJjbxs7EFg0F/UaCjRg5PzCpx3CJwe01SF7JSG1cXiHuCLsunKlglxABTONI180mfrEFhrGBUezou80aBuz4Qw7enN2AT8Ei68a3DukniR3EPfMHzAKREQ04vaVzgDj0ATW1jd6Smhpb2bYBMAjv3DulVVf4PsJYp67HhY=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OSZPR01MB8734.jpnprd01.prod.outlook.com
 (2603:1096:604:15f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 08:12:14 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 08:12:14 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Thread-Index: AQHYzkQbCGZNTw1MNUuaNx/SR8stKK3s/34AgARIsfA=
Date:   Mon, 26 Sep 2022 08:12:14 +0000
Message-ID: <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
In-Reply-To: <Yy2wivbzUA2zroqy@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OSZPR01MB8734:EE_
x-ms-office365-filtering-correlation-id: 4e3278fc-8bd9-4897-25c2-08da9f96d1f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TjnQlqquyrdINSOGWjdPfwSRQEVSf7BlzaBX3DuhtcBr4C7ZZiTyAep9yyXMor4GoP+PPrLWRGe8WYPN8QP9rSHT66e+Jil4fBUDo+QUFgT9za62GTmuP+GZ+e9FtOHko9ty0Hrvq93IVf1GUELGj5CBC/AYF9YHV9dgg0ozV/MWJhm4wX9G/Ybpb4Jm/QMMVgG4niXp8kOYu4hMBzx/+Feyo+o6eRmHjyYFBEOwSgaN7CRiXQDD/fTfT/pcvt2FDHDWK7u7rIuz6aD2O+TPre71kcQTGV4K6g0W3/DFJFN7YZbkMWObSnoOg729jCNedcbNZIPmFTT6BpdwLzvV1CpAx5PLWpAN2mdsWW8+4oWu2MEtGiATV8jvW7Ejwb46Gs4zePQwCBhl4Zqk7wIP4oMAaLGfFLm7dN8aoEcBxmTHzs/d/ypHfXcNxQUIwFFCrWNhMcxFxaKyuDNCmlpjBN8zMBoE/kDZkA7074cBEVTskIJD7Hb78UxIco3eONT6japbHtRyD/m/Zikm3LXB8gsj8YW8W3DYKl1g/fw0YtnPLpiCR4rLdV6bSq0cke8aVODq+DeAUWgOHUxNrHqgsvlZyjmPl599yGOBnWBW9bYoM4b7+HK88Mt4db3JAHDvkymVPcedMJ8+paIpoTDeNkpYxDTf5OK71i4gaE6EKz2WgJHn8UpKYT0s4wzGoMbR+fPlDn5rxJAKtPtJd3J78W98TWP3QZeQNwh8uR4r+fi2RWmkY9wUbWTMXmztMeC1dwOSkk6fDVOQT1k+A17ISw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(6916009)(54906003)(33656002)(66899012)(86362001)(186003)(7416002)(38070700005)(5660300002)(38100700002)(122000001)(83380400001)(316002)(41300700001)(6506007)(9686003)(478600001)(66476007)(4326008)(76116006)(66946007)(71200400001)(66556008)(7696005)(8676002)(64756008)(66446008)(8936002)(55016003)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+SGsv6RC4ixBc1OojmklDgNXRqCWt5MNVToxIj89g2txpMvlPAz23U/AmllN?=
 =?us-ascii?Q?RZQ11vNnBCNT51qOAGFxlqyqyJc4hirXAd68J+K/1GOJdhGg36DFI0EwBVyU?=
 =?us-ascii?Q?tfFf1Emabf4qQhmHblTBYCOkzODV4+J9Ru1wO9hozx0kJJGbw402WYm/zI6h?=
 =?us-ascii?Q?SD3XhHqBv0VigI2EHKIMMCUtmkklALmkcxIGcYmcamxS0NGOm+eEZzDYxKSb?=
 =?us-ascii?Q?6ka9i87vYDXnap8rXSbxFgqBX44h1OJrlrTlzJ9ywPHgKy+CcaADBtpf/Ep3?=
 =?us-ascii?Q?4twRXLPObc5y+esEXpc8EFc5p2EMrEjwF0o1FgtpmR9mnvDHJIsyLYbN5sLu?=
 =?us-ascii?Q?ngEDf96LaKA3N+dxfmzf0R3M9tPejIwd7GtGUn/LMCXPYAX7j10zUQUc/ceE?=
 =?us-ascii?Q?by8ZKKvzmyxO0wslB2YlSELQuH0s3MqHuI8zA8zBkW/8BIUXNX1te6C84GqX?=
 =?us-ascii?Q?6YH+AMYn4tRo6M1rwtDNQUMOg6KEMw5rg597H/NvmO2tadBTcw910hk6cwGo?=
 =?us-ascii?Q?RXlPm3/M1iJU3vUtT9rUuu24cpyjiByjMcrAQ7W5LTfCDBocBWL7YRgkXSlt?=
 =?us-ascii?Q?tTmAkoUTfimL6REnjJTE0Lo8YRdsZBTBjNs3P2J1LMZ1EQ8e+GcPBzcwIj2L?=
 =?us-ascii?Q?vTPmhr6DIo5QdnkJ/AS4BjxN5IhF+l/KeS2Fxsw77woHtCnBqA6fFUJaerwG?=
 =?us-ascii?Q?38eZxYZG0R5G1VgH1bnetlhOT+fkebtdjas/zRJ+PlnIpCEPYTmvBWIri0pA?=
 =?us-ascii?Q?eEluqr16EtgFrQdgXmIDm+ZpTZXT03xjq9wCaNuSe7WAqBj0MmKaemf8MKGb?=
 =?us-ascii?Q?dTZnwaLWtHUWJMIF7/9yjMSsiwCz3xJwFpeuu4QhsBWShYUftwdfb1TrkmNq?=
 =?us-ascii?Q?njm/lX5QZskunLj91HhynvGbsHtokzkNk+zpWUscfI6lneQsPuVlzkamN+tF?=
 =?us-ascii?Q?iEX0SKSUxKNlRir0qxSypd1E51cuFearCtS+iZx4LYsALPvaojOv2niX8V+3?=
 =?us-ascii?Q?9HRGO7y9QYjwzKh/evF7ljri3itKzdWCq0LNj/tEJZvokveK8wnv89VqnhPu?=
 =?us-ascii?Q?ARfNRtsKo9Eu82VlG+RP+TukvgD9hsR2yjKnOf96U7p6nmA5LVqjHjfJWF9g?=
 =?us-ascii?Q?6+ENo2w/oQMAxSsHldc4IXI+hfbaeX6FAgsr2OMs+WTbmZHMGWnQhZaeDBDK?=
 =?us-ascii?Q?x/6W2xWAT+qnXtHugelJjhaL35PaX/kmWj0VgkicjlObPue0bWyLH2koPgYs?=
 =?us-ascii?Q?DJjlZ8LD0XlxwCMPNKW7GwDNjG/94BxN/fQrh5kgpcpyLuTv23EnNu3ulDgX?=
 =?us-ascii?Q?OcRCohBS0of36CaBFUkRFewxeJtaataj+oGCWFKZi0mOgGCLyPKpsElg4Nj8?=
 =?us-ascii?Q?w9KTrnysiQLjqQnLgp19jfNRuJDkCPAgV/+dRO0/lvlhuYjwDVQMhjPOpbuv?=
 =?us-ascii?Q?CxwhywfHaCyBGs0qM9Y9pbMhmwtbju8hvtMrw3lZiGkGc45QrzBPOR+sk6ID?=
 =?us-ascii?Q?+htwEWxSmY090V+sr4RLsRBSMf06yxdpkfEaTJK1A6bxG4ZDC7TBydJ4nZm2?=
 =?us-ascii?Q?F35O8X353As3ZJ5AcnYWESuXInzCS0rRDRCmSlvYD8U4mKfY21jPprwbuqs5?=
 =?us-ascii?Q?yEOHFcEmOT+Y2qwUzq3ExGcud8/jzMQLN3IIxzGXrEYHdch38bO6VGqb3LDt?=
 =?us-ascii?Q?rpfchw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3278fc-8bd9-4897-25c2-08da9f96d1f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 08:12:14.2711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zo8CLNaMc3NOLQBJ1oLYGutwLbvUfEF89/OMS23xVIfwest5Myj65Ai5kXuyHu/OTuR5CMffTRpaeZPUQFEmN8csYVBrw+IMcU9XQgwI1GZKiL/cEU7JWC7kqc8iWsf+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8734
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn, Sent: Friday, September 23, 2022 10:12 PM
>=20
> > +/* Forwarding engine block (MFWD) */
> > +static void rswitch_fwd_init(struct rswitch_private *priv)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < RSWITCH_NUM_HW; i++) {
> > +		iowrite32(FWPC0_DEFAULT, priv->addr + FWPC0(i));
> > +		iowrite32(0, priv->addr + FWPBFC(i));
> > +	}
>=20
> What is RSWITCH_NUM_HW?

I think the name is unclear...
Anyway, this hardware has 3 ethernet ports and 2 CPU ports.
So that the RSWITCH_NUM_HW is 5. Perhaps, RSWITCH_NUM_ALL_PORTS
is better name.

Perhaps, since the current driver supports 1 ethernet port and 1 CPU port o=
nly,
I should modify this driver for the current condition strictly.

> > +
> > +	for (i =3D 0; i < RSWITCH_NUM_ETHA; i++) {
>=20
> RSWITCH_NUM_ETHA appears to be the number of ports?

Yes, this is number of ethernet ports.

> > +static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, =
int rate)
> > +{
> > +	u32 gwgrlulc, gwgrlc;
> > +
> > +	switch (rate) {
> > +	case 1000:
> > +		gwgrlulc =3D 0x0000005f;
> > +		gwgrlc =3D 0x00010260;
> > +		break;
> > +	default:
> > +		dev_err(&priv->pdev->dev, "%s: This rate is not supported (%d)\n", _=
_func__, rate);
> > +		return;
> > +	}
>=20
> Is this setting the Mbps between the switch matrix and the CPU? Why
> limit the rate? Especially if you have 3 ports, would not 3000 make
> sense?

This is needed to avoid about 10% packets loss when the hardware sends data
because the hardware will send much data if the limit is not set.

> > +static void rswitch_get_data_irq_status(struct rswitch_private *priv, =
u32 *dis)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
> > +		dis[i] =3D ioread32(priv->addr + GWDIS(i));
> > +		dis[i] &=3D ioread32(priv->addr + GWDIE(i));
> > +	}
> > +}
> > +
> > +static void rswitch_enadis_data_irq(struct rswitch_private *priv, int =
index, bool enable)
> > +{
> > +	u32 offs =3D enable ? GWDIE(index / 32) : GWDID(index / 32);
> > +
> > +	iowrite32(BIT(index % 32), priv->addr + offs);
> > +}
> > +
> > +static void rswitch_ack_data_irq(struct rswitch_private *priv, int ind=
ex)
> > +{
> > +	u32 offs =3D GWDIS(index / 32);
> > +
> > +	iowrite32(BIT(index % 32), priv->addr + offs);
> > +}
> > +
> > +static bool rswitch_is_chain_rxed(struct rswitch_gwca_chain *c)
> > +{
> > +	struct rswitch_ext_ts_desc *desc;
> > +	int entry;
> > +
> > +	entry =3D c->dirty % c->num_ring;
> > +	desc =3D &c->ts_ring[entry];
> > +
> > +	if ((desc->die_dt & DT_MASK) !=3D DT_FEMPTY)
> > +		return true;
> > +
> > +	return false;
>=20
> Is a chain a queue? Also known as a ring?

Yes.

> The naming is different to
> most drivers, which is making this harder to understand. Ideally, you
> want to follow the basic naming the majority of other drivers use.

I got it. I'll rename them.
=20
> > +}
> > +
> > +static int rswitch_gwca_chain_alloc_skb(struct rswitch_gwca_chain *c,
> > +					int start, int num)
> > +{
> > +	int i, index;
> > +
> > +	for (i =3D start; i < (start + num); i++) {
> > +		index =3D i % c->num_ring;
>=20
> Why this? Would it not make more sense to validate that start + num <
> num_ring? It seems like bad parameters passed here could destroy some
> other skb in the ring?

The descriptor indexes (c->cur and c->dirty) are just counters so that
the index is always calculated by that. This implementation is similar
with other drivers/net/ethernet/renesas/ drivers. However, as you mentioned
above, this is not majority, I think...

Also, I realized that the function will cause an issue because the types of
c->cur and c->dirty are u32, but the type of start is int.

I'll fix the indexes handling.

> More naming... Here you use num_ring, not num_chain. Try to be
> consistent. Also, num_ring makes my think of ring 7 of 9 rings. When
> this actually appears to be the size of the ring. So c->ring_size
> would be a better name.

Yes, the num_ring means the size of the ring. So, I'll rename it as your su=
ggestion.

> > +		if (c->skb[index])
> > +			continue;
> > +		c->skb[index] =3D dev_alloc_skb(PKT_BUF_SZ + RSWITCH_ALIGN - 1);
> > +		if (!c->skb[index])
> > +			goto err;
> > +		skb_reserve(c->skb[index], NET_IP_ALIGN);
>=20
> netdev_alloc_skb_ip_align()?

Yes. I'll use it. Thanks!

> > +static void rswitch_gwca_chain_free(struct net_device *ndev,
> > +				    struct rswitch_gwca_chain *c)
> > +{
> > +	int i;
> > +
> > +	if (c->gptp) {
> > +		dma_free_coherent(ndev->dev.parent,
> > +				  sizeof(struct rswitch_ext_ts_desc) *
> > +				  (c->num_ring + 1), c->ts_ring, c->ring_dma);
> > +		c->ts_ring =3D NULL;
> > +	} else {
> > +		dma_free_coherent(ndev->dev.parent,
> > +				  sizeof(struct rswitch_ext_desc) *
> > +				  (c->num_ring + 1), c->ring, c->ring_dma);
> > +		c->ring =3D NULL;
> > +	}
> > +
> > +	if (!c->dir_tx) {
> > +		for (i =3D 0; i < c->num_ring; i++)
> > +			dev_kfree_skb(c->skb[i]);
> > +	}
> > +
> > +	kfree(c->skb);
> > +	c->skb =3D NULL;
>=20
> When i see code like this, i wonder why an API call like
> dev_kfree_skb() is not being used. I would suggest reaming this to
> something other than skb, which has a very well understood meaning.

Perhaps, c->skbs is better name than just c->skb.

> > +static bool rswitch_rx(struct net_device *ndev, int *quota)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct rswitch_gwca_chain *c =3D rdev->rx_chain;
> > +	int entry =3D c->cur % c->num_ring;
> > +	struct rswitch_ext_ts_desc *desc;
> > +	int limit, boguscnt, num, ret;
> > +	struct sk_buff *skb;
> > +	dma_addr_t dma_addr;
> > +	u16 pkt_len;
> > +
> > +	boguscnt =3D min_t(int, c->dirty + c->num_ring - c->cur, *quota);
> > +	limit =3D boguscnt;
> > +
> > +	desc =3D &c->ts_ring[entry];
> > +	while ((desc->die_dt & DT_MASK) !=3D DT_FEMPTY) {
> > +		dma_rmb();
> > +		pkt_len =3D le16_to_cpu(desc->info_ds) & RX_DS;
> > +		if (--boguscnt < 0)
> > +			break;
>=20
> Why the barrier, read the length and then decide to break out of the
> loop?

Thank you for pointed it out. I should decrement/check boguscnt
before the barrier and read the length.

> > +static int rswitch_open(struct net_device *ndev)
> > +{
> > +	struct rswitch_device *rdev =3D netdev_priv(ndev);
> > +	struct device_node *phy;
> > +	int err =3D 0;
> > +
> > +	if (rdev->etha) {
>=20
> Can this happen? What would a netdev without an etha mean?

This cannot happen now. So, I'll drop it.
(I intended to create a netdev without an etha as a virtual device.
 But the current driver doesn't have such a feature.)

Best regards,
Yoshihiro Shimoda

>     Andrew
