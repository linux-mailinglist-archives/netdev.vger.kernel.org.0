Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD563194FEB
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgC0EHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:07:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37257 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgC0EHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 00:07:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id w10so9863789wrm.4;
        Thu, 26 Mar 2020 21:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YX65zythoDx4rq5zfhZVOrummghEiI9mFLTousONSTE=;
        b=qDeuNBHLpA/cXFGvfJGASUvSO04qco9u7pONXpW//q+cFiMzISU+EwohLGI3C5aMCM
         b0Z6nxtGdpVutsj5L8yvXkKKrkIGPMhl61yjnIRPXtDvlpQ/Pa6VfNzzv1Ikcbhm2L1C
         b+9Cm/39WVQ23rVV0NoA9WBgceTsR03KxZ6r0ZXG55qgLzBWYXKnKqRh8koEXWFTc7hL
         xe3PXNGI7ChqvxXp3pdfetOqK1Wnan1fCVVauBOzKuDxf2p3e1EuzcR0wUUANu+6SYcV
         l3ak2Udu9oMU881V3rL+SujylK5P2JK7sBJaNijqvjHB9Tz6tKekxC8G6G7g8dZCUXaa
         py/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YX65zythoDx4rq5zfhZVOrummghEiI9mFLTousONSTE=;
        b=RSsbKagh1Gwlqck2ymhjk9y1IKYGj5bBPX4O74CH+vIpV78/bqlfXhQsWK0JjNNR67
         6wHQvd+QpkhwCjFruJoUROagpdf3qP0P57D7zrjSBKuS5/yTAtZKQ9vCtmAUO3GglQlq
         zIDNL3PIjMtrL1g4x+8PhmJS1d/ctog6rvUFWflRvMZAOSkBVQrW3fdprA6fjMUdT6wf
         vS6X7oDn23TiatHptE/UUcwrZS9B7yYAV9BALVd1/LaNdWjUeEDsS4I+nDIpYp62zblC
         JLum19TcjdZ//l8bga9CGuNa/IJSWXBs2nufGWYXp7Vyx0mttRzmlGrvlpg+KPagcjlz
         TyNQ==
X-Gm-Message-State: ANhLgQ0yz8c5yZsanTxr3UxELiT9sWQgxatHenDdXpDMknmo0Vaax34H
        NGx5pvOm/BwPeeXzDRxl9aLfcZrxSclRpI/Otls=
X-Google-Smtp-Source: ADFU+vs04GY0l4aFrqYog4KsG5dcF7T+JVKiN0EOnmtjc4f5PqZ64I0S8V+ffULonRM3nK353AxgpgAC8nOc1Mp421Q=
X-Received: by 2002:a5d:5447:: with SMTP id w7mr12596342wrv.299.1585282049791;
 Thu, 26 Mar 2020 21:07:29 -0700 (PDT)
MIME-Version: 1.0
References: <d6baf212bdd7c54df847e0b5117406419c993a4f.1585182887.git.mleitner@redhat.com>
In-Reply-To: <d6baf212bdd7c54df847e0b5117406419c993a4f.1585182887.git.mleitner@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 27 Mar 2020 12:10:45 +0800
Message-ID: <CADvbK_ex9A=ZSuREVu-62rVuUz_znzzTcAzBJWmPba98pqnNTw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix possibly using a bad saddr with a given dst
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Jin Meng <meng.a.jin@nokia-sbell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 7:48 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Under certain circumstances, depending on the order of addresses on the
> interfaces, it could be that sctp_v[46]_get_dst() would return a dst
> with a mismatched struct flowi.
>
> For example, if when walking through the bind addresses and the first
> one is not a match, it saves the dst as a fallback (added in
> 410f03831c07), but not the flowi. Then if the next one is also not a
> match, the previous dst will be returned but with the flowi information
> for the 2nd address, which is wrong.
>
> The fix is to use a locally stored flowi that can be used for such
> attempts, and copy it to the parameter only in case it is a possible
> match, together with the corresponding dst entry.
>
> The patch updates IPv6 code mostly just to be in sync. Even though the issue
> is also present there, it fallback is not expected to work with IPv6.
>
> Fixes: 410f03831c07 ("sctp: add routing output fallback")
> Reported-by: Jin Meng <meng.a.jin@nokia-sbell.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/ipv6.c     | 20 ++++++++++++++------
>  net/sctp/protocol.c | 28 +++++++++++++++++++---------
>  2 files changed, 33 insertions(+), 15 deletions(-)
>
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index bc734cfaa29eb6acf2b09d641fc6b740595bfcec..c87af430107ae444d9eb293d96f9423730a72033 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -228,7 +228,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>  {
>         struct sctp_association *asoc = t->asoc;
>         struct dst_entry *dst = NULL;
> -       struct flowi6 *fl6 = &fl->u.ip6;
> +       struct flowi _fl;
> +       struct flowi6 *fl6 = &_fl.u.ip6;
>         struct sctp_bind_addr *bp;
>         struct ipv6_pinfo *np = inet6_sk(sk);
>         struct sctp_sockaddr_entry *laddr;
> @@ -238,7 +239,7 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>         enum sctp_scope scope;
>         __u8 matchlen = 0;
>
> -       memset(fl6, 0, sizeof(struct flowi6));
> +       memset(&_fl, 0, sizeof(_fl));
>         fl6->daddr = daddr->v6.sin6_addr;
>         fl6->fl6_dport = daddr->v6.sin6_port;
>         fl6->flowi6_proto = IPPROTO_SCTP;
> @@ -276,8 +277,11 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>         rcu_read_unlock();
>
>         dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
> -       if (!asoc || saddr)
> +       if (!asoc || saddr) {
> +               t->dst = dst;
> +               memcpy(fl, &_fl, sizeof(_fl));
>                 goto out;
> +       }
>
>         bp = &asoc->base.bind_addr;
>         scope = sctp_scope(daddr);
> @@ -300,6 +304,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>                         if ((laddr->a.sa.sa_family == AF_INET6) &&
>                             (sctp_v6_cmp_addr(&dst_saddr, &laddr->a))) {
>                                 rcu_read_unlock();
> +                               t->dst = dst;
> +                               memcpy(fl, &_fl, sizeof(_fl));
>                                 goto out;
>                         }
>                 }
> @@ -338,6 +344,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>                         if (!IS_ERR_OR_NULL(dst))
>                                 dst_release(dst);
>                         dst = bdst;
> +                       t->dst = dst;
> +                       memcpy(fl, &_fl, sizeof(_fl));
>                         break;
>                 }
>
> @@ -351,6 +359,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>                         dst_release(dst);
>                 dst = bdst;
>                 matchlen = bmatchlen;
> +               t->dst = dst;
> +               memcpy(fl, &_fl, sizeof(_fl));
>         }
>         rcu_read_unlock();
>
> @@ -359,14 +369,12 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>                 struct rt6_info *rt;
>
>                 rt = (struct rt6_info *)dst;
> -               t->dst = dst;
>                 t->dst_cookie = rt6_get_cookie(rt);
>                 pr_debug("rt6_dst:%pI6/%d rt6_src:%pI6\n",
>                          &rt->rt6i_dst.addr, rt->rt6i_dst.plen,
> -                        &fl6->saddr);
> +                        &fl->u.ip6.saddr);
>         } else {
>                 t->dst = NULL;
> -
>                 pr_debug("no route\n");
>         }
>  }
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 78af2fcf90cc50cdfca6e7c91bd63dd841eb5ec2..092d1afdee0d23cd974210839310fbf406dd443f 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -409,7 +409,8 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>  {
>         struct sctp_association *asoc = t->asoc;
>         struct rtable *rt;
> -       struct flowi4 *fl4 = &fl->u.ip4;
> +       struct flowi _fl;
> +       struct flowi4 *fl4 = &_fl.u.ip4;
>         struct sctp_bind_addr *bp;
>         struct sctp_sockaddr_entry *laddr;
>         struct dst_entry *dst = NULL;
> @@ -419,7 +420,7 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>
>         if (t->dscp & SCTP_DSCP_SET_MASK)
>                 tos = t->dscp & SCTP_DSCP_VAL_MASK;
> -       memset(fl4, 0x0, sizeof(struct flowi4));
> +       memset(&_fl, 0x0, sizeof(_fl));
>         fl4->daddr  = daddr->v4.sin_addr.s_addr;
>         fl4->fl4_dport = daddr->v4.sin_port;
>         fl4->flowi4_proto = IPPROTO_SCTP;
> @@ -438,8 +439,11 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>                  &fl4->saddr);
>
>         rt = ip_route_output_key(sock_net(sk), fl4);
> -       if (!IS_ERR(rt))
> +       if (!IS_ERR(rt)) {
>                 dst = &rt->dst;
> +               t->dst = dst;
> +               memcpy(fl, &_fl, sizeof(_fl));
> +       }
>
>         /* If there is no association or if a source address is passed, no
>          * more validation is required.
> @@ -502,27 +506,33 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>                 odev = __ip_dev_find(sock_net(sk), laddr->a.v4.sin_addr.s_addr,
>                                      false);
>                 if (!odev || odev->ifindex != fl4->flowi4_oif) {
> -                       if (!dst)
> +                       if (!dst) {
>                                 dst = &rt->dst;
> -                       else
> +                               t->dst = dst;
> +                               memcpy(fl, &_fl, sizeof(_fl));
> +                       } else {
>                                 dst_release(&rt->dst);
> +                       }
>                         continue;
>                 }
>
>                 dst_release(dst);
>                 dst = &rt->dst;
> +               t->dst = dst;
> +               memcpy(fl, &_fl, sizeof(_fl));
>                 break;
>         }
>
>  out_unlock:
>         rcu_read_unlock();
>  out:
> -       t->dst = dst;
> -       if (dst)
> +       if (dst) {
>                 pr_debug("rt_dst:%pI4, rt_src:%pI4\n",
> -                        &fl4->daddr, &fl4->saddr);
> -       else
> +                        &fl->u.ip4.daddr, &fl->u.ip4.saddr);
> +       } else {
> +               t->dst = NULL;
>                 pr_debug("no route\n");
> +       }
>  }
>
>  /* For v4, the source address is cached in the route entry(dst). So no need
> --
> 2.25.1
>
Tested-by: Xin Long <lucien.xin@gmail.com>
