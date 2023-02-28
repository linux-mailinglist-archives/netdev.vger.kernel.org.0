Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D686A5B02
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 15:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjB1Opu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 09:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB1Opt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 09:45:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F118CA29;
        Tue, 28 Feb 2023 06:45:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FA0661137;
        Tue, 28 Feb 2023 14:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CFEC433EF;
        Tue, 28 Feb 2023 14:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677595546;
        bh=hQDgOCq4TEsrkw8p1yiXndRHnEKYWMMTcXjOqKrEePQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NHnd+YNRKkeZ5G1kJF1QOJjar3hsAurwIScVuhaTAUBYSQIfMV+acPW4ITXqZuEKQ
         GHnAk5zMfTCSM+dtlTrGC/mj+Kz98cdyIvypiTOZrOvg9E53h9Z4ziHkVa+hZbkbP0
         iAtKmU+ZEtUBMvyYNbm/zPm2pp6sZivHaKhq3a5tFHew5R+siNnJUVd5izJ/n+wD8Q
         7nFfrlHVWYe9RWt+BfIwCC3ek7N8n/VA+Tg+X1j4hW+MRmivSwMb0CaHybSS3Us2JS
         nCRdoXfT2nMIk2lFlphuedquwB1PUaihQ+B1OSPgEwzzxQNvG4HZOsyeZksXB0/+9z
         93rS+YbpZ7mig==
Date:   Tue, 28 Feb 2023 16:45:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] scm: fix MSG_CTRUNC setting condition for
 SO_PASSSEC
Message-ID: <Y/4Tlu7q2gNbcExT@unreal>
References: <20230226201730.515449-1-aleksandr.mikhalitsyn@canonical.com>
 <Y/x8H4qCNsj4mEkA@unreal>
 <CAEivzxeorZoiE4VmJ45CoF4ZRoW3B+rkT0ufX7y1bxn510yzPQ@mail.gmail.com>
 <Y/z3OtIA+25GjjH2@unreal>
 <CAEivzxemz8SDr2_NAvgi6XdzA12d5_3ZOmJ=1FF8VMbaGLdVng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEivzxemz8SDr2_NAvgi6XdzA12d5_3ZOmJ=1FF8VMbaGLdVng@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 11:06:12AM +0100, Aleksandr Mikhalitsyn wrote:
> On Mon, Feb 27, 2023 at 7:32 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Feb 27, 2023 at 10:55:04AM +0100, Aleksandr Mikhalitsyn wrote:
> > > On Mon, Feb 27, 2023 at 10:47 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Sun, Feb 26, 2023 at 09:17:30PM +0100, Alexander Mikhalitsyn wrote:
> > > > > Currently, we set MSG_CTRUNC flag is we have no
> > > > > msg_control buffer provided and SO_PASSCRED is set
> > > > > or if we have pending SCM_RIGHTS.
> > > > >
> > > > > For some reason we have no corresponding check for
> > > > > SO_PASSSEC.
> > > > >
> > > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> > > > > ---
> > > > >  include/net/scm.h | 13 ++++++++++++-
> > > > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > > >
> > > > Is it a bugfix? If yes, it needs Fixes line.
> > >
> > > It's from 1da177e4c3 ("Linux-2.6.12-rc2") times :)
> > > I wasn't sure that it's correct to put the "Fixes" tag on such an old
> > > and big commit. Will do. Thanks!
> > >
> > > >
> > > > >
> > > > > diff --git a/include/net/scm.h b/include/net/scm.h
> > > > > index 1ce365f4c256..585adc1346bd 100644
> > > > > --- a/include/net/scm.h
> > > > > +++ b/include/net/scm.h
> > > > > @@ -105,16 +105,27 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
> > > > >               }
> > > > >       }
> > > > >  }
> > > > > +
> > > > > +static inline bool scm_has_secdata(struct socket *sock)
> > > > > +{
> > > > > +     return test_bit(SOCK_PASSSEC, &sock->flags);
> > > > > +}
> > > > >  #else
> > > > >  static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
> > > > >  { }
> > > > > +
> > > > > +static inline bool scm_has_secdata(struct socket *sock)
> > > > > +{
> > > > > +     return false;
> > > > > +}
> > > > >  #endif /* CONFIG_SECURITY_NETWORK */
> > > >
> > > > There is no need in this ifdef, just test bit directly.
> > >
> > > The problem is that even if the kernel is compiled without
> > > CONFIG_SECURITY_NETWORK
> > > userspace can still set the SO_PASSSEC option. IMHO it's better not to
> > > set MSG_CTRUNC
> > > if CONFIG_SECURITY_NETWORK is disabled, msg_control is not set but
> > > SO_PASSSEC is enabled.
> > > Because in this case SCM_SECURITY will never be sent. Please correct
> > > me if I'm wrong.
> >
> > I don't know enough in this area to say if it is wrong or not.
> > My remark was due to the situation where user sets some bit which is
> > going to be ignored silently. It will be much cleaner do not set it
> > if CONFIG_SECURITY_NETWORK is disabled instead of masking its usage.
> 
> Hi Leon,
> 
> I agree with you, but IMHO then it looks more correct to return -EOPNOTSUPP on
> setsockopt(fd, SO_PASSSEC, ...) if CONFIG_SECURITY_NETWORK is disabled.
> But such a change may break things.
> 
> Okay, anyway I'll wait until net-next will be opened and present a
> patch with a more
> detailed description and Fixes tag. Speaking about this problem with
> CONFIG_SECURITY_NETWORK
> if you insist that it will be more correct then I'm ready to fix it too.

I won't insist on anything, most likely Eric will comment if you need to
fix it.

Thanks

> 
> Thanks,
> Alex
> 
> >
> > Thanks
> >
> > >
> > > Kind regards,
> > > Alex
> > >
> > > >
> > > > >
> > > > >  static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
> > > > >                               struct scm_cookie *scm, int flags)
> > > > >  {
> > > > >       if (!msg->msg_control) {
> > > > > -             if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp)
> > > > > +             if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> > > > > +                 scm_has_secdata(sock))
> > > > >                       msg->msg_flags |= MSG_CTRUNC;
> > > > >               scm_destroy(scm);
> > > > >               return;
> > > > > --
> > > > > 2.34.1
> > > > >
