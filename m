Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69F06E8214
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjDSTq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjDSTqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:46:22 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E7E2735
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=//1tYW5OFMpifX+7K0BVWzqdE/MdauvUsV93Is9MMiE=;
        t=1681933575; x=1683143175; b=N9E0Oz1SATXgDRFIA//v5PoYfwQWZ2XUZHnOtm6x0CK9SFI
        x56S5WnrlvyL5FFQFmJ/Biix3sIcTMdHYW0ewXTVIGol79i6AjXHsakGMcNfrUnLXQY4kbORypei/
        QvE1bM/5MaB7/k96a8LZgLcko1x7fdQznx2JkqN3b44RbKIFtsKOr5lTiaJ9kakCysDRXnfA2ec57
        gMCKvXIvNM0Newn5Wgcr6k5RnlHTRSP2CqalJC+YHdnu0jGbZW3xzp0SH+8Q+uFXauudQBZbeo9U9
        R2hmfw+ZgW4Hv7QEhKO24e5k6P3O6FLsNGj+6kys8/Mu/XYfA4x5zgXpCcyxTQIA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ppDkh-002gE9-0R;
        Wed, 19 Apr 2023 21:46:03 +0200
Message-ID: <5bab80687cfc0a641b8110530bc1277e6cbf00e6.camel@sipsolutions.net>
Subject: Re: [PATCH v1 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     bspencer@blackberry.com, christophe-h.ricard@st.com,
        davem@davemloft.net, dsahern@gmail.com, edumazet@google.com,
        kaber@trash.net, kuba@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org
Date:   Wed, 19 Apr 2023 21:46:02 +0200
In-Reply-To: <20230419175258.37172-1-kuniyu@amazon.com>
References: <d098026456c8393463e6cf33195edc19369c220b.camel@sipsolutions.net>
         <20230419175258.37172-1-kuniyu@amazon.com>
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

On Wed, 2023-04-19 at 10:52 -0700, Kuniyuki Iwashima wrote:

> > So I guess here we can argue either
> >  1) keep writing len to 4 and set 4 bytes of the output
> >  2) keep the length as is and set all bytes of the output
> >=20
> > but (2) gets confusing if you say used 6 bytes buffer as input? I mean,
> > yeah, I'd really hope nobody does that.
> >=20
> > If Jakub is feeling adventurous maybe we should attempt to see if we
> > break anything by accepting only =3D=3D sizeof(int) rather than >=3D ..=
. :-)
>=20
> Yes, this is another thing I concerned.  I thought we would have the
> same report if we didn't clear the high 32 bits when a user passed u64.
>=20
> If we want to avoid it, we have to use u64 as val in netlink_getsockopt()=
.
> This is even broken for a strange user who passes u128 though :P

Yeah ... hence I'm saying we shouldn't bother.

> > So my 2 cents:
> >  * I wouldn't remove the checks that the size is at least sizeof(int)
> >  * I'd - even if it's not strictly backwards compatible - think about
> >    restricting to *exactly* sizeof(int), which would make the issue
> >    with the copy_to_user() go away as well (**)
> >  * if we don't restrict the input length, then need to be much more
> >    careful about the copy_to_user() I think, but then what if someone
> >    specifies something really huge as the size?
>=20
> I'm fine either, but I would prefer the latter using u64 for val and
> set limit for len as sizeof(u64).
>=20

That doesn't actually work on big endian, if you have a u64 value 1
that's 00 00 00 00 00 00 00 01, now if you just copy_to_user() that to
an int value (that should've been used) you only get 00 00 00 00 out ...
I guess with the semantics we could technically set it to ff ... ff, but
then there's probably _someone_ out there who expects only 0 or 1 in an
int, or something? So that means to allow a value larger than int
(smaller isn't allowed now) you'd actually have to write some additional
tricky code that checks what the size is and writes it accordingly ...
or just like now writes only the 4 bytes out and sets optlen, but I
suspects that really only works today anyway because everyone uses an
int as documented (and smaller won't work).

So I still think it's better to at least try to just say it _has_ to be
exactly an int, and write that out - and failing that, keep the
behaviour we have today, but hopefully that won't be needed.

johannes
