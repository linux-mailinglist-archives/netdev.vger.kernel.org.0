Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26562494A3
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgHSFuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:50:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36142 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgHSFuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:50:39 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597816236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OKxc51lwhBQgaUAHhxQRNWoYK6hZVfpxGkm1xmSz8zA=;
        b=lqb+yyzfgiec8Xq87VR/kHTuSgdebHPbmmNqMqberp6GfJMWDieS3TIWKmtl8z9kv9Kn7r
        k56VKn05lea90BISxxdFZu3ssJj195poxEBGJTIhzP7JOJM3PJNx9hiUxvZly0xGZy5xUS
        EcQ75xgjXUSKiVeJvGz3Ige5chXmrSWcleSt7kOT7lFV6C9x4UFrKmk4BHikE3SYTfqUq0
        AaKkQIsXYC4QdXmIcN6VqIVQnLDhdtRisXk+dWJreo3I/mTj87bwkKBMTjjVpG248OGHdY
        9jFLuN6b6J2odw68bEdpX8EZm4IhVQNwT7VXJxpHiyQtfWzb4oKr6dads/8hSA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597816236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OKxc51lwhBQgaUAHhxQRNWoYK6hZVfpxGkm1xmSz8zA=;
        b=THlUccMaQOhuan3tF4NDMXA5ZoZBdCWsLTHa8ZMtFBPk7Ogu+Q0pSqly8m3YEjJ8mHhlNr
        5m3qfKSedk8MR4DQ==
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v4 2/9] ptp: Add generic ptp message type function
In-Reply-To: <20200818104004.GA1551@shell.armlinux.org.uk>
References: <20200818103251.20421-1-kurt@linutronix.de> <20200818103251.20421-3-kurt@linutronix.de> <20200818104004.GA1551@shell.armlinux.org.uk>
Date:   Wed, 19 Aug 2020 07:50:25 +0200
Message-ID: <87lfibb2vy.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Aug 18 2020, Russell King wrote:
> On Tue, Aug 18, 2020 at 12:32:44PM +0200, Kurt Kanzenbach wrote:
>> The message type is located at different offsets within the ptp header d=
epending
>> on the ptp version (v1 or v2). Therefore, drivers which also deal with p=
tp v1
>> have some code for it.
>>=20
>> Extract this into a helper function for drivers to be used.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> Reviewed-by: Richard Cochran <richardcochran@gmail.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  include/linux/ptp_classify.h | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>=20
>> diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
>> index 996f31e8f35d..39bad015d1d6 100644
>> --- a/include/linux/ptp_classify.h
>> +++ b/include/linux/ptp_classify.h
>> @@ -96,6 +96,31 @@ unsigned int ptp_classify_raw(const struct sk_buff *s=
kb);
>>   */
>>  struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int t=
ype);
>>=20=20
>> +/**
>> + * ptp_get_msgtype - Extract ptp message type from given header
>> + * @hdr: ptp header
>> + * @type: type of the packet (see ptp_classify_raw())
>> + *
>> + * This function returns the message type for a given ptp header. It ta=
kes care
>> + * of the different ptp header versions (v1 or v2).
>> + *
>> + * Return: The message type
>> + */
>> +static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
>> +				 unsigned int type)
>> +{
>> +	u8 msgtype;
>> +
>> +	if (unlikely(type & PTP_CLASS_V1)) {
>> +		/* msg type is located at the control field for ptp v1 */
>> +		msgtype =3D hdr->control;
>> +	} else {
>> +		msgtype =3D hdr->tsmt & 0x0f;
>> +	}
>> +
>> +	return msgtype;
>> +}
>
> Are there 256 different message types in V1?

There are only a few messages in PTP V1. But, the control field which
indicates the message type is a byte whereas in PTP v2 it's a nibble.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl88vaEACgkQeSpbgcuY
8KbaaQ//f0iVrFrLatNW/FHV6WYW0DMiKTtNWMx1jo+35gvs35fmmPrgx4mUDH3P
m6r7IkYsLS0w/ZrAJTIEtM10JFdlOa1nAKO2AQmzgsMy56aGHyNt7IkwsuYsJOi3
uvpQPXg0UG7E/+m6soBGHzUWjlghqD2nkUOvyP13De4mvwWpzpRW8ISKRJS5IQy9
cFgoXrcQfgfn6cRdjSbSF3K25DgYwA3p6hBOFVHl1irTetkCMacNMVwdbF1h0Asg
S/L64kODgn/OFf6/ijbIBmaha5Tg9/KYbWQpVtnCIl54MYhN75x/MFavyTWUQdPG
x5nm5oD15mL+2y+cywp2UvGyGkcrb0XR8QlHc4Tbf2hhlnx807fFQio4bO5G8XHa
w/QeIxyDhDI9Mu3OAqeCEuWlqNasmtWzmnM3z/IR626BYswF7g8Mq8tgzz6ZyFKs
vj3u2LjmukjlIv6+RZ4Tg7t9WmaJ/ixCmYWq4gASqbKP5R8T0ErIkPvnJGo4vGHI
r3ucPeJW8WyJ7/libznl+YaU6cIKIvHHOUWljXzqm1hxc6o4rFqGLr6v0IHd7cu5
VrQNAcu6Pp1wuwD5iAwHwGTTtkdekI9xR2wuGTJodI62F6qsTd4Cf6ci6dfGCgV7
CCxDbNJt1uMouaTuxSegK3qCnrP9+JtySGTX+SbqHUtDgiWP+9Q=
=M0DK
-----END PGP SIGNATURE-----
--=-=-=--
