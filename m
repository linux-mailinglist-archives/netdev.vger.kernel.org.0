Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829D3186C1
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 10:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfEIIZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 04:25:19 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:49662 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725822AbfEIIZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 04:25:18 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A2061C00FF;
        Thu,  9 May 2019 08:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557390321; bh=QpFuzC5ceXosrmcLY4vec6CxMTx1UXydL2qAHJ6XHx4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Y3Eph6wWsOakV82OSBZQ+TZb86vDoabAKUfRFRcpxMwByuuktGkqUcPMueNSOVnX7
         c14J4mqG+aatKLi1rhITjC1C2i+vuR/g53SMS3GXg1Z/Yf+JM34Krf3Do8dmrkvUH+
         X8UZwnRuZBpKi+Cmi17gnuF6lDApp4N4pvKdYKZMkCXTSjfUbjAtXW8DFPFS+aFKkr
         +b93xqc7DeiIJsHXQLy/Lbv0O4w5zwBPh7L12UdAOFTeErVRkMlFYGu33d1QloB6jc
         7a8HwEveXm1+FPX62XEtcGdtXEk1CJ3bnkTFbiZnqDXTmlWlUgRreYD3uylL6SSM/p
         srWzlSxM+dgFw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8AEFDA02F0;
        Thu,  9 May 2019 08:25:16 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 9 May 2019 01:25:16 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Thu,
 9 May 2019 10:25:14 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 10/11] net: stmmac: Introduce selftests support
Thread-Topic: [PATCH net-next 10/11] net: stmmac: Introduce selftests support
Thread-Index: AQHVBXLbzVq8jQ4wOEqKi4j/REzHDqZh7/UAgACEXjA=
Date:   Thu, 9 May 2019 08:25:14 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B47AB21@DE02WEMBXB.internal.synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <be9099bbf8783b210dc9034a8b82219984f03250.1557300602.git.joabreu@synopsys.com>
 <20190509022330.GA23758@lunn.ch>
In-Reply-To: <20190509022330.GA23758@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, May 09, 2019 at 03:23:30

> > +static int stmmac_test_eee(struct stmmac_priv *priv)
> > +{
> > +	struct stmmac_extra_stats *initial, *final;
> > +	int timeout =3D 100;
> > +	int ret;
> > +
> > +	ret =3D stmmac_test_loopback(priv);
> > +	if (ret)
> > +		goto out_free_final;
> > +
> > +	/* We have no traffic in the line so, sooner or later it will go LPI =
*/
> > +	while (--timeout) {
> > +		memcpy(final, &priv->xstats, sizeof(*final));
> > +
> > +		if (final->irq_tx_path_in_lpi_mode_n >
> > +		    initial->irq_tx_path_in_lpi_mode_n)
> > +			break;
> > +		msleep(100);
> > +	}
> > +
> > +	if (!timeout) {
> > +		ret =3D -ETIMEDOUT;
> > +		goto out_free_final;
> > +	}
>=20
> Retries would be a better name than timeout.

Ok.

>=20
> Also, 100 * 100 ms seems like a long time.

Ah, yeah. I will adjust to 0.5 or maybe 1 sec max.

>=20
> > +static int stmmac_filter_check(struct stmmac_priv *priv)
> > +{
> > +	if (!(priv->dev->flags & IFF_PROMISC))
> > +		return 0;
> > +
> > +	netdev_warn(priv->dev, "Test can't be run in promiscuous mode!\n");
> > +	return 1;
>=20
> Maybe return EOPNOTSUPP here,

Ok.

>=20
> > +}
> > +
> > +static int stmmac_test_hfilt(struct stmmac_priv *priv)
> > +{
> > +	unsigned char gd_addr[ETH_ALEN] =3D {0x01, 0x0c, 0xcd, 0x04, 0x00, 0x=
00};
> > +	unsigned char bd_addr[ETH_ALEN] =3D {0x06, 0x07, 0x08, 0x09, 0x0a, 0x=
0b};
>=20
> What does gd and bd mean?

Good and Bad :D

>=20
> > +	struct stmmac_packet_attrs attr =3D { };
> > +	int ret;
> > +
> > +	if (stmmac_filter_check(priv))
> > +		return -EOPNOTSUPP;
>=20
> and just return the error code from the call.
>=20
> > +
> > +	ret =3D dev_mc_add(priv->dev, gd_addr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	attr.dst =3D gd_addr;
> > +
> > +	/* Shall receive packet */
> > +	ret =3D __stmmac_test_loopback(priv, &attr);
> > +	if (ret)
> > +		goto cleanup;
> > +
> > +	attr.dst =3D bd_addr;
> > +
> > +	/* Shall NOT receive packet */
> > +	ret =3D __stmmac_test_loopback(priv, &attr);
> > +	ret =3D !ret;
>=20
> What is this test testing? gd is a multicast, where as bd is not.  I
> expect the hardware treats multicast different to unicast. So it would
> make more sense to test two different multicast addresses, one which
> has been added via dev_mc_addr, and one that has not?

Hmm, yeah makes sense. I will adjust.

>=20
> > +
> > +cleanup:
> > +	dev_mc_del(priv->dev, gd_addr);
> > +	return ret;
> > +}
> > +
> > +static int stmmac_test_pfilt(struct stmmac_priv *priv)
> > +{
> > +	unsigned char gd_addr[ETH_ALEN] =3D {0x01, 0x02, 0x03, 0x04, 0x05, 0x=
06};
> > +	unsigned char bd_addr[ETH_ALEN] =3D {0x06, 0x07, 0x08, 0x09, 0x0a, 0x=
0b};
> > +	struct stmmac_packet_attrs attr =3D { };
> > +	int ret;
> > +
> > +	if (stmmac_filter_check(priv))
> > +		return -EOPNOTSUPP;
> > +
> > +	ret =3D dev_uc_add(priv->dev, gd_addr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	attr.dst =3D gd_addr;
> > +
> > +	/* Shall receive packet */
> > +	ret =3D __stmmac_test_loopback(priv, &attr);
> > +	if (ret)
> > +		goto cleanup;
>=20
> gb is a multicast address. Does dev_uc_add() return an error? If it
> does not we should not expect it to actually work, since a multicast
> address should not match a unicast address?

It doesn't return an error and it does calls the set_filter callback in=20
netdev. I will adjust to use unicast address.

> You also seem to be missing a test for adding a unicast address via
> dev_uc_add() and receiving packets for that address, but not receiving
> multicast packets.

Hmm, what if interface was already configured to receive Multicast before=20
running the tests ?

>=20
> > +static const struct stmmac_test {
> > +	char name[ETH_GSTRING_LEN];
> > +	int lb;
> > +	int (*fn)(struct stmmac_priv *priv);
> > +} stmmac_selftests[] =3D {
> > +	{
> > +		.name =3D "MAC Loopback         ",
> > +		.lb =3D STMMAC_LOOPBACK_MAC,
> > +		.fn =3D stmmac_test_loopback,
>=20
> stmmac_test_mac_loopback might be a better name.

Ok.

Thanks for the review!

Thanks,
Jose Miguel Abreu
