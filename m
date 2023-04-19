Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1156E8218
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjDSTrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDSTrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:47:51 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19025FFA
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=gY/c7vqJLTiq7QAIpEp8Q1nJa2AF866bT22FcfMvSME=;
        t=1681933659; x=1683143259; b=vdTL3VfXQdbLKR5shpl/TMqhmR4ze4I5wynaImUNtN/+KcT
        osVCHUYXgV7/uM6Gio64TexPXl0k6uukBGdgcFwyyMjHLDeNucyWWuvOqFdruUmbwkvy+AtC8MfZx
        C/g7FKRaNjXEAv7uyhUEkNSLn9/Zo85CHDnW0XPK+wl7sv264VV1u0RySQS2h2ep2OuJ+UbMKmLC7
        VMDI7fkbv2TU/pgOhxcyGMLtYtukbFjQzcVakIIjJMaEXMoSxqFBCboddEg6ubIDKFKmGVp8vD1+V
        zst86e3cg7jTPNP/4d/c1RY9Smn32lxZqfGBCdgcjBaxt6aYRqi2D45p7+sEUlyg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ppDm6-002gFP-0T;
        Wed, 19 Apr 2023 21:47:30 +0200
Message-ID: <e0ec2ca90c10529c597c6c936109e9c73cc55c31.camel@sipsolutions.net>
Subject: Re: [PATCH v1 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     bspencer@blackberry.com, christophe-h.ricard@st.com,
        davem@davemloft.net, dsahern@gmail.com, edumazet@google.com,
        kaber@trash.net, kuba@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org
Date:   Wed, 19 Apr 2023 21:47:29 +0200
In-Reply-To: <5bab80687cfc0a641b8110530bc1277e6cbf00e6.camel@sipsolutions.net>
References: <d098026456c8393463e6cf33195edc19369c220b.camel@sipsolutions.net>
         <20230419175258.37172-1-kuniyu@amazon.com>
         <5bab80687cfc0a641b8110530bc1277e6cbf00e6.camel@sipsolutions.net>
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

On Wed, 2023-04-19 at 21:46 +0200, Johannes Berg wrote:
>=20
> > > So my 2 cents:
> > >  * I wouldn't remove the checks that the size is at least sizeof(int)
> > >  * I'd - even if it's not strictly backwards compatible - think about
> > >    restricting to *exactly* sizeof(int), which would make the issue
> > >    with the copy_to_user() go away as well (**)
> > >  * if we don't restrict the input length, then need to be much more
> > >    careful about the copy_to_user() I think, but then what if someone
> > >    specifies something really huge as the size?
> >=20
> > I'm fine either, but I would prefer the latter using u64 for val and
> > set limit for len as sizeof(u64).
> >=20
>=20
> That doesn't actually work on big endian,

[snip]

and come to think of it, that also makes the code in your patch now only
work for 'char' or 'short' on little endian, which is again another
tricky gotcha, and also there another argument for not allowing that?

johannes
