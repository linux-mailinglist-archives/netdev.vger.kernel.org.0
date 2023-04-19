Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC26E73D6
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 09:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjDSHS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 03:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjDSHS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 03:18:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199E55AC
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 00:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=lvIc+jNzPQTNPjplmHA4GZk5cB9ZCmrec4kXoEhBHBE=;
        t=1681888689; x=1683098289; b=grpjWtwbA62QwEORUNrs1btXy+XZC4vUdskPUswkoIcXxLl
        +IzBtHMidfvrygJ1u6h61YWB+8MM82A4/RaRhPh94tc3jyG4wWCjYUWpQIEeiyz+nZVUN+Rg3NEUl
        H20apSYr7B7i/MqR9baBgxoBr7O0qdP/rbdQmqOFOk1YxhqlvrTsVzOkKdwcz3Incb6Gc0HBLgucb
        Iw2ksUJgDfs7wUoAgII+xOA7asxok0x9g4xTeZHPqyjkL2bdWQ3cYIMDqIR87d2EomCcwuuY6ZTzF
        kQK4L8qmaP/BmuaQa/0OGts21u7k3yBzSEYh6eOwTo4IkS0kBS4wUdj08WEKE3yw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pp24R-002SIN-05;
        Wed, 19 Apr 2023 09:17:39 +0200
Message-ID: <d098026456c8393463e6cf33195edc19369c220b.camel@sipsolutions.net>
Subject: Re: [PATCH v1 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Christophe Ricard <christophe-h.ricard@st.com>,
        David Ahern <dsahern@gmail.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Brad Spencer <bspencer@blackberry.com>
Date:   Wed, 19 Apr 2023 09:17:37 +0200
In-Reply-To: <20230419004246.25770-1-kuniyu@amazon.com>
References: <20230419004246.25770-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-19 at 00:42 +0000, Kuniyuki Iwashima wrote:
> Brad Spencer provided a detailed report that when calling getsockopt()
> for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
> options require more than int as length.
>=20
> The options return a flag value that fits into 1 byte, but such behaviour
> confuses users who do not strictly check the value as char.

Yeah that's iffy. I guess nobody really leaves it uninitialized.

> Currently, netlink_getsockopt() uses put_user() to copy data to optlen an=
d
> optval, but put_user() casts the data based on the pointer, char *optval.
> So, only 1 byte is set to optval.

Which also means it only ever sets to "1" on little endian systems, on
big endian it would set to "0x0100'0000" (if initialized to 0 first),
right?

> To avoid this behaviour, we need to use copy_to_user() or cast optval for
> put_user().

Right.

> Now getsockopt() accepts char as optval as the flags are only 1 byte.

Personally, I don't think we should allow his. We document (*) and check
this as taking an int, and while it would _fit_, I don't really think
it's a good idea to weaken this and allow different types.
I don't see value in it either, certainly not now since nobody can be
using it, and not really in the future either since you're not going to
pack these things in memory, and having an int vs. char on the stack
really makes basically no difference.
And when we start seeing code that actually uses this, it'll just be
more things to support in the userspace API, be more confusing with
socket options that aren't just flags, etc.

IOW, I think you should keep the size checks.


(*) man 7 netlink:
"Unless otherwise noted, optval is a pointer to an int."


> @@ -1754,39 +1754,17 @@ static int netlink_getsockopt(struct socket *sock=
, int level, int optname,
>=20
>         switch (optname) {
>         case NETLINK_PKTINFO:
> -               if (len < sizeof(int))
> -                       return -EINVAL;
> -               len =3D sizeof(int);

On the other hand, this is actually accepting say a u64 now, and then
sets only 4 bytes of it, though at least it also sets the size to what
it wrote out.

So I guess here we can argue either
 1) keep writing len to 4 and set 4 bytes of the output
 2) keep the length as is and set all bytes of the output

but (2) gets confusing if you say used 6 bytes buffer as input? I mean,
yeah, I'd really hope nobody does that.

If Jakub is feeling adventurous maybe we should attempt to see if we
break anything by accepting only =3D=3D sizeof(int) rather than >=3D ... :-=
)


> +       if (put_user(len, optlen) ||

You never change len now, so there's no point writing it back? Or do we
somehow need to make sure this is writable? But what for?

> +           copy_to_user(optval, &val, len))

There's some magic in copy_to_user() now, but I don't think it will save
you here - to me this seems really wrong now because 'len' is controlled
by the user, and sizeof(val) is only 4 bytes - so wouldn't this overrun
even in the case I mentioned above where the user used a u64 and 'len'
is actually 8, not 4?=20

Also, as Jakub points out, even in the case where len *is* 4, you've now
changed the behaviour on big endian.

I think that's probably *fine* since the bug meant you basically had to
initialise to 0 and then check the entire value though, but maybe that
warrants some discussion in the commit log.

So my 2 cents:
 * I wouldn't remove the checks that the size is at least sizeof(int)
 * I'd - even if it's not strictly backwards compatible - think about
   restricting to *exactly* sizeof(int), which would make the issue
   with the copy_to_user() go away as well (**)
 * if we don't restrict the input length, then need to be much more
   careful about the copy_to_user() I think, but then what if someone
   specifies something really huge as the size?


(**) I only worry slightly that today somebody could've used an
uninitialised value as the optlen and gotten away with it, but I hope
that's not the case, that'd be a strange pattern, and if you ever hit 0
it fails anyway. I'm not really worried someone explicitly wanted to use
a bigger buffer.


johannes

