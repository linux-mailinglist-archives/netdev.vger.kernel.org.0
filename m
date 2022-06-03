Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF47453C3EA
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbiFCFCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236793AbiFCFCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:02:46 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91E0E90
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 22:02:43 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-30c2f288f13so71477767b3.7
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 22:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TXRGKDjuV3Bq9ZbA8Leir/RfHu2gALAHKQulLEnomsI=;
        b=AY6SxYD/GJaxEBNjI5eveAfUfzOJdwNus4n71rq5wRm/WDpxW6IB9b4Z8B3mq/toJ4
         zDYQ+3vMBo1KWzMekk8z1A7zet8bjk7udKZfQR7tj1pQtThQdyfuaz7p+HzzWiptxqh1
         IC93JJOXfri274h2pzBkXM0k6f/64IePTIkf5F/gQ8k/CLUhkbxCBabl3tUFcoZgkOea
         4S68PgaL0kyngFR4iAwD3nGjICdUjtoSt8a92Fp/gDEq9/6nncDZmPmTcLC8lwm+n/bh
         tK2L3arsM8XIA3+GCI0xeHICfb3WUmWcrGfjeqM+D6hs2H+m89GxPdz6xPMph77UkVEK
         BaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TXRGKDjuV3Bq9ZbA8Leir/RfHu2gALAHKQulLEnomsI=;
        b=pb8qKqg3Tapf9P2wq5DpQ22SWGdiCRLe2w4W3gDXmsmAsR2e+9Q9y6EaZVSwoegSxS
         b8Z9Q/9YTDyM4OzCamOpvatYnizG329dsJSLLK7oTpKBy9iP4d/n5wrvpqTPwnU+QZtH
         4LgqQN6e2siKcJquiYP+nrL667pX8l6R3PyXlSEHAsCez5n+eX9bMgJOtvm/LI0PoPGZ
         b8WyuNBeH+CU51Ju7QsziOKs5Ssmf2QnlakFWX+HVEAs2fxXtS6Evfsd4GVSIIzJ1p6w
         PwJlSyyczz9CRaJdwT+9vlYcHWL/spljnEk675xdLwDNisjREvHD6m2sYgr9nC9jx+ks
         8l9w==
X-Gm-Message-State: AOAM530q0iNwGnVB52qINBsYwc65i8B0zhSK0AU5CbQSys6EYaHBJRT8
        uy6piDhKJsQpDKRQEDR4ZOFAKJ9PCSPyex1UZAg=
X-Google-Smtp-Source: ABdhPJxclF07TQNT5k3EUClkJUqIhaL9T2VHu2UbStFG5809gUfCZ6EP18v45pt+vYFH+EeuOJ6RVm74DJT9rUMGLjk=
X-Received: by 2002:a81:1d16:0:b0:30c:ed7e:6cd6 with SMTP id
 d22-20020a811d16000000b0030ced7e6cd6mr9515653ywd.30.1654232563013; Thu, 02
 Jun 2022 22:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220528004820.5916-1-CFSworks@gmail.com> <c1c7a1207986d4ad9e80a301fe5e1415631949a9.camel@redhat.com>
In-Reply-To: <c1c7a1207986d4ad9e80a301fe5e1415631949a9.camel@redhat.com>
From:   Sam Edwards <cfsworks@gmail.com>
Date:   Thu, 2 Jun 2022 23:02:31 -0600
Message-ID: <CAH5Ym4iS=d+dUAg+85wmRJv+jV=Cet=UtN1pNWejMV5fdPVprA@mail.gmail.com>
Subject: Re: [PATCH v2] ipv6/addrconf: fix timing bug in tempaddr regen
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Since this is a periodic routine, it receives coverage as the system
runs normally. If we're concerned about protecting this change from
regressions and/or through the merge process, some kind of automated
test might be in order, but right now the way to test it is to leave
the system up, with tempaddrs enabled, on a IPv6 SLAAC network, for
several multiples of the temp_prefered_lft. Though the way I see it,
that suggests that a selftest to do just that may be inappropriate
here: one of the rules for selftests is "Don=E2=80=99t take too long."

I can shorten that long line, though do note that my Signed-off-by tag
is correct. That is the canonical capitalization of my email address!
:)

Thanks and see you when net-next is open,
Sam

On Tue, May 31, 2022 at 1:50 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Fri, 2022-05-27 at 18:48 -0600, Sam Edwards wrote:
> > The addrconf_verify_rtnl() function uses a big if/elseif/elseif/... blo=
ck
> > to categorize each address by what type of attention it needs.  An
> > about-to-expire (RFC 4941) temporary address is one such category, but =
the
> > previous elseif branch catches addresses that have already run out thei=
r
> > prefered_lft.  This means that if addrconf_verify_rtnl() fails to run i=
n
> > the necessary time window (i.e. REGEN_ADVANCE time units before the end=
 of
> > the prefered_lft), the temporary address will never be regenerated, and=
 no
> > temporary addresses will be available until each one's valid_lft runs o=
ut
> > and manage_tempaddrs() begins anew.
> >
> > Fix this by moving the entire temporary address regeneration case out o=
f
> > that block.  That block is supposed to implement the "destructive" part=
 of
> > an address's lifecycle, and regenerating a fresh temporary address is n=
ot,
> > semantically speaking, actually tied to any particular lifecycle stage.
> > The age test is also changed from `age >=3D prefered_lft - regen_advanc=
e`
> > to `age + regen_advance >=3D prefered_lft` instead, to ensure no underf=
low
> > occurs if the system administrator increases the regen_advance to a val=
ue
> > greater than the already-set prefered_lft.
> >
> > Note that this does not fix the problem of addrconf_verify_rtnl() somet=
imes
> > not running in time, resulting in the race condition described in RFC 4=
941
> > section 3.4 - it only ensures that the address is regenerated.  Fixing =
THAT
> > problem may require either using jiffies instead of seconds for all tim=
e
> > arithmetic here, or always rounding up when regen_advance is converted =
to
> > seconds.
> >
> > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > ---
> >  net/ipv6/addrconf.c | 62 ++++++++++++++++++++++++---------------------
> >  1 file changed, 33 insertions(+), 29 deletions(-)
> >
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index b22504176588..57aa46cb85b7 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -4507,6 +4507,39 @@ static void addrconf_verify_rtnl(struct net *net=
)
> >                       /* We try to batch several events at once. */
> >                       age =3D (now - ifp->tstamp + ADDRCONF_TIMER_FUZZ_=
MINUS) / HZ;
> >
> > +                     if ((ifp->flags&IFA_F_TEMPORARY) &&
> > +                         !(ifp->flags&IFA_F_TENTATIVE) &&
> > +                         ifp->prefered_lft !=3D INFINITY_LIFE_TIME &&
> > +                         !ifp->regen_count && ifp->ifpub) {
> > +                             /* This is a non-regenerated temporary ad=
dr. */
> > +
> > +                             unsigned long regen_advance =3D ifp->idev=
->cnf.regen_max_retry *
> > +                                     ifp->idev->cnf.dad_transmits *
> > +                                     max(NEIGH_VAR(ifp->idev->nd_parms=
, RETRANS_TIME), HZ/100) / HZ;
> > +
> > +                             if (age + regen_advance >=3D ifp->prefere=
d_lft) {
> > +                                     struct inet6_ifaddr *ifpub =3D if=
p->ifpub;
> > +                                     if (time_before(ifp->tstamp + ifp=
->prefered_lft * HZ, next))
> > +                                             next =3D ifp->tstamp + if=
p->prefered_lft * HZ;
> > +
> > +                                     ifp->regen_count++;
> > +                                     in6_ifa_hold(ifp);
> > +                                     in6_ifa_hold(ifpub);
> > +                                     spin_unlock(&ifp->lock);
> > +
> > +                                     spin_lock(&ifpub->lock);
> > +                                     ifpub->regen_count =3D 0;
> > +                                     spin_unlock(&ifpub->lock);
> > +                                     rcu_read_unlock_bh();
> > +                                     ipv6_create_tempaddr(ifpub, true)=
;
> > +                                     in6_ifa_put(ifpub);
> > +                                     in6_ifa_put(ifp);
> > +                                     rcu_read_lock_bh();
> > +                                     goto restart;
> > +                             } else if (time_before(ifp->tstamp + ifp-=
>prefered_lft * HZ - regen_advance * HZ, next))
> > +                                     next =3D ifp->tstamp + ifp->prefe=
red_lft * HZ - regen_advance * HZ;
> > +                     }
> > +
> >                       if (ifp->valid_lft !=3D INFINITY_LIFE_TIME &&
> >                           age >=3D ifp->valid_lft) {
> >                               spin_unlock(&ifp->lock);
> > @@ -4540,35 +4573,6 @@ static void addrconf_verify_rtnl(struct net *net=
)
> >                                       in6_ifa_put(ifp);
> >                                       goto restart;
> >                               }
> > -                     } else if ((ifp->flags&IFA_F_TEMPORARY) &&
> > -                                !(ifp->flags&IFA_F_TENTATIVE)) {
> > -                             unsigned long regen_advance =3D ifp->idev=
->cnf.regen_max_retry *
> > -                                     ifp->idev->cnf.dad_transmits *
> > -                                     max(NEIGH_VAR(ifp->idev->nd_parms=
, RETRANS_TIME), HZ/100) / HZ;
> > -
> > -                             if (age >=3D ifp->prefered_lft - regen_ad=
vance) {
> > -                                     struct inet6_ifaddr *ifpub =3D if=
p->ifpub;
> > -                                     if (time_before(ifp->tstamp + ifp=
->prefered_lft * HZ, next))
> > -                                             next =3D ifp->tstamp + if=
p->prefered_lft * HZ;
> > -                                     if (!ifp->regen_count && ifpub) {
> > -                                             ifp->regen_count++;
> > -                                             in6_ifa_hold(ifp);
> > -                                             in6_ifa_hold(ifpub);
> > -                                             spin_unlock(&ifp->lock);
> > -
> > -                                             spin_lock(&ifpub->lock);
> > -                                             ifpub->regen_count =3D 0;
> > -                                             spin_unlock(&ifpub->lock)=
;
> > -                                             rcu_read_unlock_bh();
> > -                                             ipv6_create_tempaddr(ifpu=
b, true);
> > -                                             in6_ifa_put(ifpub);
> > -                                             in6_ifa_put(ifp);
> > -                                             rcu_read_lock_bh();
> > -                                             goto restart;
> > -                                     }
> > -                             } else if (time_before(ifp->tstamp + ifp-=
>prefered_lft * HZ - regen_advance * HZ, next))
> > -                                     next =3D ifp->tstamp + ifp->prefe=
red_lft * HZ - regen_advance * HZ;
> > -                             spin_unlock(&ifp->lock);
> >                       } else {
> >                               /* ifp->prefered_lft <=3D ifp->valid_lft =
*/
> >                               if (time_before(ifp->tstamp + ifp->prefer=
ed_lft * HZ, next))
>
> The change looks correct to me, but it feels potentially
> dangerous/impacting currently correct behaviours - especially
> considering the lack of selftests for this code-path.
>
> This looks like net-next material, and net-next is currently close. I
> suggest to add a self-test verifying the tmp address regeneration and
> expiration - I'm not sure how complext that will be, sorry - and re-
> post when net-next re-opens.
> While at that, please fix your SoB tag (there is a case mismatch with
> the sender address) and it would be probably nice to shorten the line
> exceeding the 100 chars limit.
>
> Thanks,
>
> Paolo
>
