Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13206A3EE4
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjB0J5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjB0J5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:57:11 -0500
Received: from ocelot.miegl.cz (ocelot.miegl.cz [195.201.216.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42091CF60;
        Mon, 27 Feb 2023 01:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=miegl.cz; s=dkim;
        t=1677491823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EEgFqYreOAbd5d/AfWjIpth5dvxJuzD8COIGV7jYZwU=;
        b=RxUxd7Wt2zkk3+1dNqfjpIvdOAC6iyCZWPS8EOBSvMkM8ZEkPItCnc6t1Q2OhMXbfWsM7V
        gcIV78qXbYDd/VN5Jqv/o4oVT6ClGHTMYmYbhw59jqTV5dZX1ht25Tdo51QG0/Ezj3QQXL
        1F0czrxnJ4fDhVJj/PWGLnapI2tAWIxgAW1j8wfia39qZJtqXhW2OUFDL4sbD/8o3jA00H
        DMzai/vJWutZzAvbujNzyyfOQc9tNxDDmz8jVCuDpYXtD8BB2v3ovKAPo54QIzjFkPtjZE
        fKkxDT1DsX3iiQ7aKSl24hMzNAgWmZnwusoWZcv4pMzXlB/jhRawqlTEpOTqEQ==
MIME-Version: 1.0
Date:   Mon, 27 Feb 2023 09:57:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.16.0
From:   "Josef Miegl" <josef@miegl.cz>
Message-ID: <79dee14b9b96d5916a8652456b78c7a5@miegl.cz>
Subject: Re: [PATCH v2 0/1] net: geneve: accept every ethertype
To:     "Eyal Birger" <eyal.birger@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAHsH6GtArNCyA3UAJbSYYD86fb2QxskbSoNQo2RVHQzKC643zg@mail.gmail.com>
References: <CAHsH6GtArNCyA3UAJbSYYD86fb2QxskbSoNQo2RVHQzKC643zg@mail.gmail.com>
 <20230227074104.42153-1-josef@miegl.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

February 27, 2023 10:30 AM, "Eyal Birger" <eyal.birger@gmail.com> wrote:

> Hi,
>=20
>=20On Mon, Feb 27, 2023 at 10:19 AM Josef Miegl <josef@miegl.cz> wrote:
>=20
>>=20The Geneve encapsulation, as defined in RFC 8926, has a Protocol Typ=
e
>> field, which states the Ethertype of the payload appearing after the
>> Geneve header.
>>=20
>>=20Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protoc=
ol")
>> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
>> use of other Ethertypes than Ethernet. However, for a reason not known
>> to me, it imposed a restriction that prohibits receiving payloads othe=
r
>> than IPv4, IPv6 and Ethernet.
>=20
>=20FWIW I added support for IPv4/IPv6 because these are the use cases I =
had
> and could validate. I don't know what problems could arise from support=
ing
> all possible ethertypes and can't test that.

Yeah, I am hoping someone knowledgeable will tell whether this is a good
or bad idea. However I think that if any problem could arise, this is not
the place to artificially restrict payload types and potentional safeguar=
ding
should be done somewhere down the packet chain.

I can't imagine adding a payload Ethertype every time someone needs a
specific use-case would be a good idea.

>> This patch removes this restriction, making it possible to receive any
>> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
>> set.
>=20
>=20This seems like an addition not a bugfix so personally seems like it =
should
> be targeting net-next (which is currently closed afaik).

One could say the receive function should have behaved like that, the
transmit function already encapsulates every possible Ethertype and
IFLA_GENEVE_INNER_PROTO_INHERIT doesn't sound like it should be limited t=
o
IPv4 and IPv6.

If no further modifications down the packet chain are required, I'd say i=
t's
50/50. However I haven't contributed to the Linux kernel ever before, so =
I
really have no clue as to how things go.

> Eyal.
>=20
>>=20This is especially useful if one wants to encapsulate MPLS, because =
with
>> this patch the control-plane traffic (IP, LLC) and the data-plane
>> traffic (MPLS) can be encapsulated without an Ethernet frame, making
>> lightweight overlay networks a possibility.
>>=20
>>=20Changes in v2:
>> - added a cover letter
>> - lines no longer exceed 80 columns
>>=20
>>=20Josef Miegl (1):
>> net: geneve: accept every ethertype
>>=20
>>=20drivers/net/geneve.c | 15 ++++-----------
>> 1 file changed, 4 insertions(+), 11 deletions(-)
>>=20
>>=20--
>> 2.37.1
