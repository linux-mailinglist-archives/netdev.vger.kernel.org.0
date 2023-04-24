Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25516EC6A5
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 09:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjDXHAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 03:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDXHAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 03:00:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A2410C
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 00:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Gc0hEj1SHp5x4qDYLRuYO18kIcpmAupIcPP+XWlqNMA=;
        t=1682319610; x=1683529210; b=JJUhDRymsfMdZRMOYcfM8V1bFtt0BGHbHKn3q7q1XikHIYo
        nWshVfY1gCQ5gkaLMth3QCRbun5/4NwS7J/4WjtxQQHKUC26IzvfLalCdfhP7zv248zsb7OPM5OFO
        k/TVBVCeT1ug0N6yJNgfMZuf839v9MSPOB/rJEfyeYnoCk9isy+oLZX4i7hAtsSsScRHD/WnSQb7A
        Pohutw+Zp6p7zA3rT1FcMdU3R2Svz4tyxmY/To8sN7AAf29yAN/NmAjaC5jbzKwpHPijkbWMFKBvd
        NPb0R6sDPnvqIlKMk7t8eSBQa/eGPIb7k6pseyUN01ZSqYDMEa84rscZa9fKLDvw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pqqB0-0078Hx-32;
        Mon, 24 Apr 2023 08:59:55 +0200
Message-ID: <030b67dad5a96685f984082fd8fda08dfe0be985.camel@sipsolutions.net>
Subject: Re: [PATCH v3 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Ahern <dsahern@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Christophe Ricard <christophe-h.ricard@st.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Brad Spencer <bspencer@blackberry.com>
Date:   Mon, 24 Apr 2023 08:59:53 +0200
In-Reply-To: <226bfa8b-afe1-179a-5763-376e80ebe038@gmail.com>
References: <20230421185255.94606-1-kuniyu@amazon.com>
         <226bfa8b-afe1-179a-5763-376e80ebe038@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-04-22 at 15:57 +0000, David Ahern wrote:
> On 4/21/23 12:52 PM, Kuniyuki Iwashima wrote:
> > diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> > index f365dfdd672d..9b6eb28e6e94 100644
> > --- a/net/netlink/af_netlink.c
> > +++ b/net/netlink/af_netlink.c
> > @@ -1742,7 +1742,8 @@ static int netlink_getsockopt(struct socket *sock=
, int level, int optname,
> >  {
> >       struct sock *sk =3D sock->sk;
> >       struct netlink_sock *nlk =3D nlk_sk(sk);
> > -     int len, val, err;
> > +     unsigned int flag;
> > +     int len, val;
>=20
> len is not initialized here ...
>=20
> >=20
> >       if (level !=3D SOL_NETLINK)
> >               return -ENOPROTOOPT;
> > @@ -1754,39 +1755,17 @@ static int netlink_getsockopt(struct socket *so=
ck, int level, int optname,
> >=20
> >       switch (optname) {

It's initialized in the context here:

        if (get_user(len, optlen))
                return -EFAULT;
        if (len < 0)
                return -EINVAL;

> >       default:
> > -             err =3D -ENOPROTOOPT;
> > +             return -ENOPROTOOPT;
> >       }
> > -     return err;
> > +
> > +     if (len < sizeof(int))
>=20
> and then check len here.

so that's OK. Note how the checks that were there before also were
before the len assignments :)

> > +             return -EINVAL;
>=20
> seems like this chunk (len < sizeof(int)) is not needed.

It is, if we get here we need at least the int size for the flags.

johannes
