Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945466A49C8
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjB0Scj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjB0Scf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:32:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1836C1EBE2;
        Mon, 27 Feb 2023 10:32:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EB1460F04;
        Mon, 27 Feb 2023 18:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDAFC4339B;
        Mon, 27 Feb 2023 18:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677522751;
        bh=weS85/lOsn/LMYJaFWTKyZTGqxtEczoWbtTju5iXwJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qfRPiNBzo42N5MKvg8gwdgA2gOBA1u1hItWtosOvdX8lLBx2lza4eYBP1SkcD0bWv
         5dfH3+YQCXjUL0Ijs6ZcXpMvhG4VBZtvIaepRFmynP86tRhGPzouK2UlKdL+5lJmDt
         kV/uwMTejzrWB2wtq5vDJ9Qp4o+ruBpvHndiAJvaPKL6rtQ7hrhe8NNCvvaehejXwu
         RSKtLFcCF1r3eopsu1zdeCVjl9j/31RvVs3P4lngTXvQDwtPkTatUvQQ7dYJ/4notV
         H5tmLDW35o8aL23TUnspLI4ZwphXkl+bBgUl2vmvlQJDRh54lqnfCyu2abaURVoyQ3
         udmAOppWsYc6A==
Date:   Mon, 27 Feb 2023 20:32:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] scm: fix MSG_CTRUNC setting condition for
 SO_PASSSEC
Message-ID: <Y/z3OtIA+25GjjH2@unreal>
References: <20230226201730.515449-1-aleksandr.mikhalitsyn@canonical.com>
 <Y/x8H4qCNsj4mEkA@unreal>
 <CAEivzxeorZoiE4VmJ45CoF4ZRoW3B+rkT0ufX7y1bxn510yzPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEivzxeorZoiE4VmJ45CoF4ZRoW3B+rkT0ufX7y1bxn510yzPQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:55:04AM +0100, Aleksandr Mikhalitsyn wrote:
> On Mon, Feb 27, 2023 at 10:47 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Sun, Feb 26, 2023 at 09:17:30PM +0100, Alexander Mikhalitsyn wrote:
> > > Currently, we set MSG_CTRUNC flag is we have no
> > > msg_control buffer provided and SO_PASSCRED is set
> > > or if we have pending SCM_RIGHTS.
> > >
> > > For some reason we have no corresponding check for
> > > SO_PASSSEC.
> > >
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> > > ---
> > >  include/net/scm.h | 13 ++++++++++++-
> > >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > Is it a bugfix? If yes, it needs Fixes line.
> 
> It's from 1da177e4c3 ("Linux-2.6.12-rc2") times :)
> I wasn't sure that it's correct to put the "Fixes" tag on such an old
> and big commit. Will do. Thanks!
> 
> >
> > >
> > > diff --git a/include/net/scm.h b/include/net/scm.h
> > > index 1ce365f4c256..585adc1346bd 100644
> > > --- a/include/net/scm.h
> > > +++ b/include/net/scm.h
> > > @@ -105,16 +105,27 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
> > >               }
> > >       }
> > >  }
> > > +
> > > +static inline bool scm_has_secdata(struct socket *sock)
> > > +{
> > > +     return test_bit(SOCK_PASSSEC, &sock->flags);
> > > +}
> > >  #else
> > >  static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
> > >  { }
> > > +
> > > +static inline bool scm_has_secdata(struct socket *sock)
> > > +{
> > > +     return false;
> > > +}
> > >  #endif /* CONFIG_SECURITY_NETWORK */
> >
> > There is no need in this ifdef, just test bit directly.
> 
> The problem is that even if the kernel is compiled without
> CONFIG_SECURITY_NETWORK
> userspace can still set the SO_PASSSEC option. IMHO it's better not to
> set MSG_CTRUNC
> if CONFIG_SECURITY_NETWORK is disabled, msg_control is not set but
> SO_PASSSEC is enabled.
> Because in this case SCM_SECURITY will never be sent. Please correct
> me if I'm wrong.

I don't know enough in this area to say if it is wrong or not.
My remark was due to the situation where user sets some bit which is
going to be ignored silently. It will be much cleaner do not set it
if CONFIG_SECURITY_NETWORK is disabled instead of masking its usage.

Thanks

> 
> Kind regards,
> Alex
> 
> >
> > >
> > >  static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
> > >                               struct scm_cookie *scm, int flags)
> > >  {
> > >       if (!msg->msg_control) {
> > > -             if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp)
> > > +             if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> > > +                 scm_has_secdata(sock))
> > >                       msg->msg_flags |= MSG_CTRUNC;
> > >               scm_destroy(scm);
> > >               return;
> > > --
> > > 2.34.1
> > >
