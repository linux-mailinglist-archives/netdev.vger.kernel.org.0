Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E174411E4
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 02:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhKABtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 21:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhKABtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 21:49:20 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3C0C061714;
        Sun, 31 Oct 2021 18:46:47 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id s1so13211555qta.13;
        Sun, 31 Oct 2021 18:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQzW9FOFGCtdGxPb7IFZ+bArAFYHt9WKC/Ll9XJG/Qs=;
        b=Qz980rF9X01xG8ESB4yJI4njGSt9fiC/Wve5yU8IXr8x+hko7N0fI0wixAUw9ajsy7
         ClPBPxEI4juCW347mY11baf8OjMm3Dd+ORzrEOH+rPOYfxZlIAdIhQlpWnY9IwNGggK7
         syxcGpeQUoU5VJbmJU+Bacrv+qfgz/Tx9/AKTKdusR2KrDfdkenZyT0lgR0pQ3dovxIc
         swbdclg3lsqZ5rrLd16zw95UQ3MBtGkIlJT2/2m3v8AhlHrML6mtt/1opA/5DMqJXCQd
         sgo2kLiy8wjGE4qH9UZUoKeFs8UMhiVMCvpPNuKmD6rqR3KPsFIBx2R0fMNIvEb6LiTQ
         BMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQzW9FOFGCtdGxPb7IFZ+bArAFYHt9WKC/Ll9XJG/Qs=;
        b=JFvzsAOlpjRa2cMDIMrMJ3KfJI+o0b3Jie1IKA85AcOlF0FvRy8sSgPPXPj5i0sATE
         UEjeRKCi022Uqhc1S1/r+XgPwlFtWBh4ATlxOxFZlOSgWJC4ho3AF44u50Y5jTgWLKQZ
         w/KuYBZ0stkYdLmGEFKK+42isZC+i/NRC1s3DJiFBeo7yHpbch9/UrJTmwDZHoHvRrpc
         zRV0Tco6DNRiBX79qVcq/WIMhoULi2iSsJNo7W8x/t/EZqg3vUMkhkuhPHmNv/o6HyRO
         2uRlQMhFgKnqMVRBIKYm595TNmayvYFdN8JrMtzKLX+RwZ1X6UHQvWCg+WGw5U3D7OLf
         GgWw==
X-Gm-Message-State: AOAM5339rbK6+FPBiuu7RUw1F8gkbpEIIb4925DWmEe8EeKUdDNPsBzR
        rUzwSJgkco08Ek+/QAT2dYuzPdyjJPnQezJHNEvk6zq4
X-Google-Smtp-Source: ABdhPJwh4ySFpphCb8iKgLWd9whJqGmrAaECcwfh2nGFTs3RFsAfe7dRdnBlzOt5dnNuTnvhg8QEIIt9aaTChN6KkiE=
X-Received: by 2002:ac8:7d47:: with SMTP id h7mr26590292qtb.92.1635731206729;
 Sun, 31 Oct 2021 18:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211030064049.9992-1-xingwu.yang@gmail.com> <e2699ba8-e733-2c71-584a-138746511f4@ssi.bg>
 <3fa86627-969-cf6-9de0-25721c9f3964@ssi.bg>
In-Reply-To: <3fa86627-969-cf6-9de0-25721c9f3964@ssi.bg>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Mon, 1 Nov 2021 09:46:35 +0800
Message-ID: <CA+7U5JuMocD3r1RAp4uNeLsi9zDB24GdX3SucLY06WzqBOjyag@mail.gmail.com>
Subject: Re: [PATCH nf-next v4] netfilter: ipvs: Fix reuse connection if RS
 weight is 0
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Chuanqi Liu <legend050709@qq.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ok, I will do that

On Sat, Oct 30, 2021 at 9:51 PM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Sat, 30 Oct 2021, Julian Anastasov wrote:
>
> > On Sat, 30 Oct 2021, yangxingwu wrote:
> >
> > > We are changing expire_nodest_conn to work even for reused connections when
> > > conn_reuse_mode=0 but without affecting the controlled and persistent
> > > connections during the graceful termination period while server is with
> > > weight=0.
> > >
> > > Fixes: d752c3645717 ("ipvs: allow rescheduling of new connections when port
> > > reuse is detected")
> > > Co-developed-by: Chuanqi Liu <legend050709@qq.com>
> > > Signed-off-by: Chuanqi Liu <legend050709@qq.com>
> > > Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> >
> >       Looks good to me, thanks!
> >
> > Acked-by: Julian Anastasov <ja@ssi.bg>
>
> NACK for v4.
>
>         May be we should not include the !cp->control changes
> in this patch, it is better to reschedule as it was done
> before, the new connection will get the needed real server
> depending on the rules in ip_vs_check_template().
>
>         So, please send v5 with cp->control changes removed,
> updated commit message and Fixes tag without line wrap.
>
> >       Simon, Pablo, may be you can change Fixes tag to be
> > on one line before applying.
> >
> > > ---
> > >  Documentation/networking/ipvs-sysctl.rst |  3 +--
> > >  net/netfilter/ipvs/ip_vs_core.c          | 12 ++++--------
> > >  2 files changed, 5 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
> > > index 2afccc63856e..1cfbf1add2fc 100644
> > > --- a/Documentation/networking/ipvs-sysctl.rst
> > > +++ b/Documentation/networking/ipvs-sysctl.rst
> > > @@ -37,8 +37,7 @@ conn_reuse_mode - INTEGER
> > >
> > >     0: disable any special handling on port reuse. The new
> > >     connection will be delivered to the same real server that was
> > > -   servicing the previous connection. This will effectively
> > > -   disable expire_nodest_conn.
> > > +   servicing the previous connection.
> > >
> > >     bit 1: enable rescheduling of new connections when it is safe.
> > >     That is, whenever expire_nodest_conn and for TCP sockets, when
> > > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > > index 128690c512df..ce6ceb55822b 100644
> > > --- a/net/netfilter/ipvs/ip_vs_core.c
> > > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > > @@ -1100,10 +1100,6 @@ static inline bool is_new_conn(const struct sk_buff *skb,
> > >  static inline bool is_new_conn_expected(const struct ip_vs_conn *cp,
> > >                                     int conn_reuse_mode)
> > >  {
> > > -   /* Controlled (FTP DATA or persistence)? */
> > > -   if (cp->control)
> > > -           return false;
> > > -
> > >     switch (cp->protocol) {
> > >     case IPPROTO_TCP:
> > >             return (cp->state == IP_VS_TCP_S_TIME_WAIT) ||
> > > @@ -1964,7 +1960,6 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
> > >     struct ip_vs_proto_data *pd;
> > >     struct ip_vs_conn *cp;
> > >     int ret, pkts;
> > > -   int conn_reuse_mode;
> > >     struct sock *sk;
> > >
> > >     /* Already marked as IPVS request or reply? */
> > > @@ -2041,15 +2036,16 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
> > >     cp = INDIRECT_CALL_1(pp->conn_in_get, ip_vs_conn_in_get_proto,
> > >                          ipvs, af, skb, &iph);
> > >
> > > -   conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
> > > -   if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
> > > +   if (!iph.fragoffs && is_new_conn(skb, &iph) && cp && !cp->control) {
> > >             bool old_ct = false, resched = false;
> > > +           int conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
> > >
> > >             if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
> > >                 unlikely(!atomic_read(&cp->dest->weight))) {
> > >                     resched = true;
> > >                     old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> > > -           } else if (is_new_conn_expected(cp, conn_reuse_mode)) {
> > > +           } else if (conn_reuse_mode &&
> > > +                      is_new_conn_expected(cp, conn_reuse_mode)) {
> > >                     old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> > >                     if (!atomic_read(&cp->n_control)) {
> > >                             resched = true;
> > > --
> > > 2.30.2
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
