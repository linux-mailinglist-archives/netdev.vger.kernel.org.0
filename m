Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF20D4CED5C
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 20:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbiCFTXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 14:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbiCFTXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 14:23:37 -0500
Received: from v-zimmta03.u-bordeaux.fr (v-zimmta03.u-bordeaux.fr [147.210.215.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F012899F;
        Sun,  6 Mar 2022 11:22:41 -0800 (PST)
Received: from v-zimmta03.u-bordeaux.fr (localhost [127.0.0.1])
        by v-zimmta03.u-bordeaux.fr (Postfix) with ESMTP id 3C04B1800F22;
        Sun,  6 Mar 2022 20:22:39 +0100 (CET)
Received: from begin (lfbn-bor-1-255-114.w90-50.abo.wanadoo.fr [90.50.98.114])
        by v-zimmta03.u-bordeaux.fr (Postfix) with ESMTPSA id E09751800F20;
        Sun,  6 Mar 2022 20:22:38 +0100 (CET)
Received: from samy by begin with local (Exim 4.95)
        (envelope-from <samuel.thibault@labri.fr>)
        id 1nQwSk-0010iI-DQ;
        Sun, 06 Mar 2022 20:22:38 +0100
Date:   Sun, 6 Mar 2022 20:22:38 +0100
From:   Samuel Thibault <samuel.thibault@labri.fr>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     willemb@google.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] SO_ZEROCOPY should rather return -ENOPROTOOPT
Message-ID: <20220306192238.fbvp2t32fsemqssf@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@labri.fr>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        willemb@google.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
References: <20220301144453.snstwdjy3kmpi4zf@begin>
 <CA+FuTSfi1aXiBr-fOQ+8XJPjCCTnqTicW2A3OUVfNHurfDL3jA@mail.gmail.com>
 <20220301150028.romzjw2b4aczl7kf@begin>
 <CA+FuTSeZw228fsDj+YoSpu5sLaXsp+uR+N+qHrzZ4e3yMWhPKw@mail.gmail.com>
 <20220301152017.jkx7amcbfqkoojin@begin>
 <CA+FuTSfVBVr_q6p+HcBL4NAX4z2BS0ZNaSfFF0yxO3QqeNX75Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfVBVr_q6p+HcBL4NAX4z2BS0ZNaSfFF0yxO3QqeNX75Q@mail.gmail.com>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-AV-Checked: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Willem de Bruijn, le mar. 01 mars 2022 10:21:41 -0500, a ecrit:
> > > > > > @@ -1377,9 +1377,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
> > > > > >                         if (!(sk_is_tcp(sk) ||
> > > > > >                               (sk->sk_type == SOCK_DGRAM &&
> > > > > >                                sk->sk_protocol == IPPROTO_UDP)))
> > > > > > -                               ret = -ENOTSUPP;
> > > > > > +                               ret = -ENOPROTOOPT;
> > > > > >                 } else if (sk->sk_family != PF_RDS) {
> > > > > > -                       ret = -ENOTSUPP;
> > > > > > +                       ret = -ENOPROTOOPT;
> > > > > >                 }
> > > > > >                 if (!ret) {
> > > > > >                         if (val < 0 || val > 1)
> > > > >
> > > > > That should have been a public error code. Perhaps rather EOPNOTSUPP.
> > > > >
> > > > > The problem with a change now is that it will confuse existing
> > > > > applications that check for -524 (ENOTSUPP).
> > > >
> > > > They were not supposed to hardcord -524...
> > > >
> > > > Actually, they already had to check against EOPNOTSUPP to support older
> > > > kernels, so EOPNOTSUPP is not supposed to pose a problem.
> > >
> > > Which older kernels returned EOPNOTSUPP on SO_ZEROCOPY?
> >
> > Sorry, bad copy/paste, I meant ENOPROTOOPT.
> 
> Same point though, right? These are not legacy concerns, but specific
> to applications written to SO_ZEROCOPY.
> 
> I expect that most will just ignore the exact error code and will work
> with either.

Ok, so, is this an Acked-by: you? :)

Samuel
