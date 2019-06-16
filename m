Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9DD473B8
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 10:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfFPIEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 04:04:49 -0400
Received: from pb-smtp21.pobox.com ([173.228.157.53]:60056 "EHLO
        pb-smtp21.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfFPIEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 04:04:49 -0400
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 05E9F73E8C;
        Sun, 16 Jun 2019 04:04:47 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:from
        :to:references:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=cgxn1jT/DK8u
        eMTCLAlHp993ZKk=; b=BZF6YgSfdEdhhLKGMWGahvp3teDGYigM31ldhl5Qx4qI
        ENQmxLPM4Qkpbhkz1jZikXJ9MhQFSwEKk8ixsTPX3vv2j86lel2sN9uO83bOx/eu
        l04sGX38lTI4hG6VWHQnvrEbtTGoxf0PnRvENmqq7OFBCMNPnf/dAhAwiU5eIcs=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
        :references:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=TL5/qK
        ZBmU8yhdMrwzOU19ULQuPMdqLruOboUoe/ViEEGqHw+AU5IOqydvnbHHUrleUgit
        XhBz4wZwU2ZAVmY5BfwvPfHBz3M5lJv1d/F4FppzWOBA0zZa8/MXHQgNqmgO49mT
        5plb21EO2EBTEQgguJ5fbELsWx/lf8evsu7tM=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id F21DD73E8B;
        Sun, 16 Jun 2019 04:04:46 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
Received: from [192.168.1.134] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp21.pobox.com (Postfix) with ESMTPSA id 103CF73E8A;
        Sun, 16 Jun 2019 04:04:44 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
Subject: Re: Understanding Ethernet Architecture (I/O --> MDIO --> MII vs I/O
 --> MAC) for mt7620 (OpenWRT)
From:   Daniel Santos <daniel.santos@pobox.com>
To:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        openwrt-devel <openwrt-devel@lists.openwrt.org>,
        John Crispin <blogic@openwrt.org>,
        Michael Lee <igvtee@gmail.com>, netdev@vger.kernel.org
References: <2766c2b3-3262-78f5-d736-990aaa385eeb@pobox.com>
Message-ID: <6f21e283-60ef-7e0f-359b-fbd547ea7e2a@pobox.com>
Date:   Sun, 16 Jun 2019 03:03:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2766c2b3-3262-78f5-d736-990aaa385eeb@pobox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 66C1DCFE-900D-11E9-A67F-8D86F504CC47-06139138!pb-smtp21.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ah hah! I've found my answer on page 340 (414. PIAC: PHY Indirect Access
Control(offset:0x7004)) and in mt7620_gsw_config:

static int mt7620_gsw_config(struct fe_priv *priv)
{
	struct mt7620_gsw *gsw =3D (struct mt7620_gsw *) priv->soc->swpriv;

	/* is the mt7530 internal or external */
	if (priv->mii_bus && mdiobus_get_phy(priv->mii_bus, 0x1f)) {
		mt7530_probe(priv->dev, gsw->base, NULL, 0);
		mt7530_probe(priv->dev, NULL, priv->mii_bus, 1);
	} else {
		mt7530_probe(priv->dev, gsw->base, NULL, 1);
	}

	return 0;
}

So priv->mii_bus is non-null when the chip's network hardware is
external because the similarly (and confusingly) named mt7530 is only
the switch hardware, where as the mt7620 is a full =C2=B5C that has an mt=
7530
integrated into it.=C2=A0 Which leads me to the question of what "GSW"
means?=C2=A0 This is the name of the hardware that has the PIAC register,=
 but
nowhere in the data sheet or programming guide can I find a definition.

Thanks,
Daniel


On 6/14/19 5:53 PM, Daniel Santos wrote:
> Hello,
>
> I'm still fairly new to Ethernet drivers and there are a lot of
> interesting pieces.=C2=A0 What I need help with is understanding MDIO -=
->
> (R)MII vs direct I/O to the MAC (e.g., via ioread32, iowrite32).=C2=A0 =
Why is
> there not always a struct mii_bus to talk to this hardware?=C2=A0 Is it
> because the PHY and/or MAC hardware sometimes attached via an MDIO
> device and sometimes directly to the I/O bus?=C2=A0 Or does some type o=
f
> "indirect access" need to be enabled for that to work?
>
> I might be trying to do something that's unnecessary however, I'm not
> sure yet.=C2=A0 I need to add functionality to change a port's
> auto-negotiate, duplex, etc.=C2=A0 I'm adding it to the swconfig first =
and
> then will look at adding it for DSA afterwards.=C2=A0 When I run "swcon=
fig
> dev switch0 port 0 show", the current mt7530 / mt7620 driver is queryin=
g
> the MAC status register (at base + 0x3008 + 0x100 * port, described on
> pages 323-324 of the MT7620 Programming Guide), so I implemented the
> "set" functionality by modifying the MAC's control register (offset
> 0x3000 on page 321), but it doesn't seem to change anything.=C2=A0 So I
> figured maybe I need to modify the MII interface's control register for
> the port (page 350), but upon debugging I can see that the struct
> mii_bus *bus member is NULL.
>
> So should I be able to change it via the MAC's control register and
> something else is wrong?=C2=A0 Why is there no struct mii_bus?=C2=A0 Ca=
n I talk to
> the MII hardware in some other way?
>
> Thanks,
> Daniel
>
> https://download.villagetelco.org/hardware/MT7620/MT7620_ProgrammingGui=
de.pdf
>

