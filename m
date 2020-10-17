Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459DB2914DF
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 00:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439608AbgJQWBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 18:01:10 -0400
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:43712
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439595AbgJQWBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 18:01:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVOz2I2w4ow6KzgY+Yn0Zg8qTZiG/oj1Ez6WB5lKWJNceGk/t2pXuceqgRcaILTzZ3e1wr5QOIFy+jEZMDokShCdDeQPmcuD8i4QieVEPO61/YTGSSzsaC0mFFfnsgLeh8eR5vTs+o+BsyMoZH/nDl9bskbiQ1Fxlfu00ImNSUujBtf1Q+as7oJre64Z6MDxWpIM99aM+H4xumYM3O7hcXY4e4venR4r3Ey8Kkq+GM4Jn/f6zU+HLFfAzTsJIxS57DUNL5Mn2lYc52p2oaRCIXEwxhcOGEjbD1ANLnoJzpVhTJF3kXbOb5GrEGuQ3Go0hzJzZWn4pqKHJraPTpehdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fDHtpx4wddZCiQXy26wfuSdbd4EUChUkYF+i+wEKm4=;
 b=Me2lizh8NtlwptmnmpCZblHWoZSpud2CyluG/kdpX/MR/If+t2QD0fcLiIKkqhdTFXbcfO1/cSaAF441l0S/Jh6wLNl10ue7H3mXxuKZIEJd2cNxPN6XJViGGBmVSjJkKnreZu3ZfiywQSRdxKqrXnn9qIYnsaij+KIFXSq2pknBy1QcTfrIA89VWJ6E74kCS1n7aXq0f06hAFC0Qh144DfkqKydbe3i3BpMayX8yDXcOHuEcoGRzDnFAFd/624NCBtPAIOtoqk0MU58bFnEQRoTrspu7AUHXWULhw8ms+5nOSS4wBMYpuIuMHlZjpbXQscD7vPyXu4mB+F9WhChAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fDHtpx4wddZCiQXy26wfuSdbd4EUChUkYF+i+wEKm4=;
 b=KEJ0a+MxQ3inRZPQLF7kDpleD3vL138E9/hFzcGBXugBe5ACgfD/sDVTr6CdHxuH9XL4p1ISdplwp/Awqpc1lmyhQ+FzlVf0mLWbqMfBIaaXD/G/MnYvW707WEZaVDgOj9LLotRybgfVhsUdWbtsksC863XfMSg9BpdZzHqnLks=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6509.eurprd04.prod.outlook.com (2603:10a6:803:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Sat, 17 Oct
 2020 22:01:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 22:01:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2WRVElJamqkEeHVtfDsj9ayamcWGgA
Date:   Sat, 17 Oct 2020 22:01:05 +0000
Message-ID: <20201017220104.wejlxn2a4seefkfv@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
In-Reply-To: <20201017213611.2557565-3-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 49decc23-a255-4548-bd72-08d872e82575
x-ms-traffictypediagnostic: VE1PR04MB6509:
x-microsoft-antispam-prvs: <VE1PR04MB6509D3DF615963BC8E7B2E52E0000@VE1PR04MB6509.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h/FXm7wV8RW61T4HMkcUyrwantxCZS2IWozInJgNjrIVMzfbEQXnI8k1+NjTGt5w+Gus3qFkP/4O5GxbzZbR30BIrC3CvsePvo8k3okgWGIF2fedhmJUndBqYAsPnWq/eeiF80jepiVFut9Qjba+N8JkZl7TVFh3jLal9A+YudOhMSqe6uiwzujFuUplSMs95UeCdkcTo+rOmTuDR/PIi7174qe1NJYMFA/hbTg4asKLHTyMUjfVJAbXFHT45GgPQ0YWokrgHt+1rjUBZmFSGNbLaKLDKHsdzGXjKPkG/PyWEoMQ9GOGX/pwpJzFZyd/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(39850400004)(346002)(136003)(376002)(396003)(66476007)(64756008)(66556008)(66446008)(44832011)(9686003)(4326008)(83380400001)(71200400001)(1076003)(6486002)(6506007)(54906003)(2906002)(6916009)(76116006)(26005)(6512007)(478600001)(33716001)(86362001)(5660300002)(91956017)(8676002)(316002)(186003)(66946007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Ss05DgjYMw4LnRZQga03/xlcnKZTRxaRdBuUmyOa8xQdBS/bW2isp6O+0w7J7YwcvL5vdw4NQqg3xPtKqttY1L2qjxvakwbRyF/mL82jMAQDya3MVxQoLaF8xZeZ9Gdn9tp9yoQavqF4DEERPk5Ff64M0UDU0hHOY0Wjjs/Q9C/H3tQfbqUMTTN/LWOhRPowc7efhYCSuR7kRlNKIBJU+AQPDPgP+9P/dcdmboYX97HN6OiE5HsgtB1hP5GDqh7LQ/ZbTWuZUmhuCXV0oVtzeDQa72ERpgiYFKbpJTBryY4P0uAmDLxXfJiBxjWZBDbdzTwfU9KpUgAAMYCEaakENYEtF6ogtRCiD/7kJ6WuPqX5gGjqdS0tn+syGFl9MjLDm91fY6eV3DEKOV4ncjfC9L4TbfoRwx+p+xwlnfAMCFhEmjd0CKryFCCN3Hknvf7iWkaxJ9JjBFues/M7Yc63aOSuBQGl4gfvzburnUGV4J2XImtCWSVb/LTGB+GnUi53Op+XvwN2G9iMsxvOypPqBtjevlZtyqbFq4uhl4PVg8D1CwDaaSbR4vDhyqduoLqd+R9CWrqlnorTRhH8Ph4BYlgMjnCffgKGR5aiIQAJy5Ci/c1tO1lpsVQOnpSpT7OGOggcLScGEB9pHnXxi6dA/Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF23647F2FD9B948ABD896A82404C9F4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49decc23-a255-4548-bd72-08d872e82575
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 22:01:05.7968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W+N3xkmS63pjVZQYIkbj6qt9Af29fvAdlitJLwXIInEr0D3AY1/7naWzB7BU+ZaY7bVFrr78vi02LTUDf7XnEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 12:36:00AM +0300, Vladimir Oltean wrote:
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index d4326940233c..790f5c8deb13 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -548,6 +548,36 @@ netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, str=
uct net_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(dsa_enqueue_skb);
> =20
> +static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)

I forgot to actually pad the skb here, if it's a tail tagger, silly me.
The following changes should do the trick.

> +{
> +	struct net_device *master =3D dsa_slave_to_master(dev);

The addition of master->needed_headroom and master->needed_tailroom used
to be here, that's why this unused variable is here.

> +	struct dsa_slave_priv *p =3D netdev_priv(dev);
> +	struct dsa_slave_stats *e;
> +	int headroom, tailroom;
	int padlen =3D 0, err;
> +
> +	headroom =3D dev->needed_headroom;
> +	tailroom =3D dev->needed_tailroom;
> +	/* For tail taggers, we need to pad short frames ourselves, to ensure
> +	 * that the tail tag does not fail at its role of being at the end of
> +	 * the packet, once the master interface pads the frame.
> +	 */
> +	if (unlikely(tailroom && skb->len < ETH_ZLEN))
> +		tailroom +=3D ETH_ZLEN - skb->len;
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		padlen =3D ETH_ZLEN - skb->len;
	tailroom +=3D padlen;
> +
> +	if (likely(skb_headroom(skb) >=3D headroom &&
> +		   skb_tailroom(skb) >=3D tailroom) &&
> +		   !skb_cloned(skb))
> +		/* No reallocation needed, yay! */
> +		return 0;
> +
> +	e =3D this_cpu_ptr(p->extra_stats);
> +	u64_stats_update_begin(&e->syncp);
> +	e->tx_reallocs++;
> +	u64_stats_update_end(&e->syncp);
> +
> +	return pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	err =3D pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
	if (err < 0 || !padlen)
		return err;

	return __skb_put_padto(skb, padlen, false);
> +}
> +
>  static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device=
 *dev)
>  {
>  	struct dsa_slave_priv *p =3D netdev_priv(dev);
> @@ -567,6 +597,11 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *sk=
b, struct net_device *dev)
>  	 */
>  	dsa_skb_tx_timestamp(p, skb);
> =20
> +	if (dsa_realloc_skb(skb, dev)) {
> +		kfree_skb(skb);
> +		return NETDEV_TX_OK;
> +	}
> +
>  	/* Transmit function may have to reallocate the original SKB,
>  	 * in which case it must have freed it. Only free it here on error.
>  	 */
> @@ -1802,6 +1837,14 @@ int dsa_slave_create(struct dsa_port *port)
>  	slave_dev->netdev_ops =3D &dsa_slave_netdev_ops;
>  	if (ds->ops->port_max_mtu)
>  		slave_dev->max_mtu =3D ds->ops->port_max_mtu(ds, port->index);
> +	/* Try to save one extra realloc later in the TX path (in the master)
> +	 * by also inheriting the master's needed headroom and tailroom.
> +	 * The 8021q driver also does this.
> +	 */

Also, this comment is bogus given the current code. It should be removed
from here, and...

> +	if (cpu_dp->tag_ops->tail_tag)
> +		slave_dev->needed_tailroom =3D cpu_dp->tag_ops->overhead;
> +	else
> +		slave_dev->needed_headroom =3D cpu_dp->tag_ops->overhead;
...put here, along with:
	slave_dev->needed_headroom +=3D master->needed_headroom;
	slave_dev->needed_tailroom +=3D master->needed_tailroom;
>  	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
> =20
>  	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
> --=20
> 2.25.1
> =
