Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97AB66793E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbjALP3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjALP2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:28:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3034FD5D
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:21:14 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673536873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=81fdmIDOKEpQUuJCNLx9f4fsWVxoz85PZzHPAPKpm5c=;
        b=srxwD8VPdYPDg41s0LCzg0mbj76LOsHKsU4bMrOlTkiZVFUhwu+5oagsMFywExbPbHKE15
        ADVbM/0GlBxiPjHuy/QcuT5CFRgsG51qiPYKVF8tjTxWym2t63AFDwfPBzn6RcWeyJBKqQ
        2bELHZJW/izcutOLv/yHoRguVbFEm1zzTkG5xVCF40xHxSgOv+lN6Cpj0zJHepBtM2C3SI
        dKH03a+ItdSOIt1+EWBPtG7nvEKIKA1iVyemVLmazTSv7id1u7eYfZXi1Y0iZPJgCWRqR1
        j2fYJzHubCTjhw+XxrEyz9xFkDhUEDR5qCh+8UugdcKMps2UEtaNzKP+ek5UzQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673536873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=81fdmIDOKEpQUuJCNLx9f4fsWVxoz85PZzHPAPKpm5c=;
        b=O6AU1BuzNrwn5H7HgZiA8gDh6cPhqEK8BAEvFRUtruIVoYMyZk248muE7F8NnClQMuHqts
        l5FG7Eo//ZhALpBQ==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: Enable PTP receive for
 mv88e6390
In-Reply-To: <Y8AGFJlQBEhTqQs7@lunn.ch>
References: <20230112091224.43116-1-kurt@linutronix.de>
 <Y8AGFJlQBEhTqQs7@lunn.ch>
Date:   Thu, 12 Jan 2023 16:21:11 +0100
Message-ID: <87k01rrd7c.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Jan 12 2023, Andrew Lunn wrote:
> On Thu, Jan 12, 2023 at 10:12:24AM +0100, Kurt Kanzenbach wrote:
>> The switch receives management traffic such as STP and LLDP. However, PTP
>> messages are not received, only transmitted.
>>=20
>> Ideally, the switch would trap all PTP messages to the management CPU. T=
his
>> particular switch has a PTP block which identifies PTP messages and trap=
s them
>> to a dedicated port. There is a register to program this destination. Th=
is is
>> not used at the moment.
>>=20
>> Therefore, program it to the same port as the MGMT traffic is trapped to=
. This
>> allows to receive PTP messages as soon as timestamping is enabled.
>>=20
>> In addition, the datasheet mentions that this register is not valid e.g.=
, for
>> 6190 variants. So, add a new PTP operation which is only added for the b=
oth 6390
>> devices.
>
> I assume this also works for the 6290? Please could you also update
> its _ops structure?

According to the datasheet, yes. I'll add this one, too.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPAJWcTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgji6EACSXRFI7gJCEYTMx6U6EW8934Yyzepo
TDPvq85nwkqlskmfcwXiLJyQCWcMvPfw/Y/ulbXSAaGC/OJ9ETHGG3VmEi2Fm565
KJWEbhgRszsgb9SJw5BMt0wdikgWbZ4kPybzxpC+GKQLO3qxsyNF6XQJieaDxk3k
t3d3zK37ZcW6cNfTbWl02JthBzA5pQiIqUsH6laWACug/oHQNt+aFdbe6J4snnph
tRhFGi35A+UGa6H8ggoECVzKfb81R5R87TmAN2L86SeuWj2sp/V9uEFevuIz6JEu
7XHGRafMukEQDvWJaSz0iPsHhyXtrm4f1DufhkNIybmJB1fCSnC+IFCa6V8/lXWR
sirRaDk/IWpm9YCJUgGkOGSpEqIPDCERqoJs6OGfYhWoCbnoS99nCD6KlSlfMEPS
JIrW7Hf6Pagy7d4sg8jucpglaYYm2B1tV5mpVUpbqvZHhxNFiRxUIbASxfpQ8IWB
UVQ9mQ70HZ1vXyXVgcyR5KcdrpGSDJDcKtCJXD8F1BMd0jJdM9Ko9WNczIB0ul4x
r4l2D+sldsluuiNQqPKXcl1Qpn6XfBlm5tczgEKpOoJ1RRZUBsn8G4RYb7Wx3w7t
QBOpaNiprrd9LkQHuCcMJ2+DqBnpBADIykU/QWNBUD00+QCB6cOQhnZmlh7Wg3bo
liQbk4UgRRhhFg==
=Yr/g
-----END PGP SIGNATURE-----
--=-=-=--
