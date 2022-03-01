Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061DB4C8E9C
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiCAPJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiCAPJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:09:06 -0500
X-Greylist: delayed 473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 07:08:24 PST
Received: from v-zimmta03.u-bordeaux.fr (v-zimmta03.u-bordeaux.fr [147.210.215.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF0D5D67C
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 07:08:24 -0800 (PST)
Received: from v-zimmta03.u-bordeaux.fr (localhost [127.0.0.1])
        by v-zimmta03.u-bordeaux.fr (Postfix) with ESMTP id 0844C1800A88;
        Tue,  1 Mar 2022 16:00:29 +0100 (CET)
Received: from begin (nat-inria-interne-54-gw-02-bso.bordeaux.inria.fr [194.199.1.54])
        by v-zimmta03.u-bordeaux.fr (Postfix) with ESMTPSA id AB9541800A86;
        Tue,  1 Mar 2022 16:00:28 +0100 (CET)
Received: from samy by begin with local (Exim 4.95)
        (envelope-from <samuel.thibault@labri.fr>)
        id 1nP3zI-00BqZC-Fw;
        Tue, 01 Mar 2022 16:00:28 +0100
Date:   Tue, 1 Mar 2022 16:00:28 +0100
From:   Samuel Thibault <samuel.thibault@labri.fr>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     willemb@google.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] SO_ZEROCOPY should rather return -ENOPROTOOPT
Message-ID: <20220301150028.romzjw2b4aczl7kf@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@labri.fr>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        willemb@google.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
References: <20220301144453.snstwdjy3kmpi4zf@begin>
 <CA+FuTSfi1aXiBr-fOQ+8XJPjCCTnqTicW2A3OUVfNHurfDL3jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfi1aXiBr-fOQ+8XJPjCCTnqTicW2A3OUVfNHurfDL3jA@mail.gmail.com>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-AV-Checked: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn, le mar. 01 mars 2022 09:51:45 -0500, a ecrit:
> On Tue, Mar 1, 2022 at 9:44 AM Samuel Thibault <samuel.thibault@labri.fr> wrote:
> >
> > ENOTSUPP is documented as "should never be seen by user programs", and
> > is not exposed in <errno.h>, so applications cannot safely check against
> > it. We should rather return the well-known -ENOPROTOOPT.
> >
> > Signed-off-by: Samuel Thibault <samuel.thibault@labri.fr>
> >
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 4ff806d71921..6e5b84194d56 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1377,9 +1377,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
> >                         if (!(sk_is_tcp(sk) ||
> >                               (sk->sk_type == SOCK_DGRAM &&
> >                                sk->sk_protocol == IPPROTO_UDP)))
> > -                               ret = -ENOTSUPP;
> > +                               ret = -ENOPROTOOPT;
> >                 } else if (sk->sk_family != PF_RDS) {
> > -                       ret = -ENOTSUPP;
> > +                       ret = -ENOPROTOOPT;
> >                 }
> >                 if (!ret) {
> >                         if (val < 0 || val > 1)
> 
> That should have been a public error code. Perhaps rather EOPNOTSUPP.
> 
> The problem with a change now is that it will confuse existing
> applications that check for -524 (ENOTSUPP).

They were not supposed to hardcord -524...

Actually, they already had to check against EOPNOTSUPP to support older
kernels, so EOPNOTSUPP is not supposed to pose a problem.

Samuel
