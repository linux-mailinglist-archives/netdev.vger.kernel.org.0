Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCAEC7FF95
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405145AbfHBR3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:29:39 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46063 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388134AbfHBR3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:29:39 -0400
Received: by mail-ed1-f66.google.com with SMTP id x19so67197806eda.12
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 10:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=925wOT0zRicaW31VDYfFokG4lw2cyM9TLlE2C2gWCSc=;
        b=oXbvxqVmUCgipS4N9xbyrnvrvmspRJ6dbUG2yReCGiHtxjtRLYKO1eUtrX/JTpkar0
         CvRMhZc8RrR/o4SXb1krIMJXFDJ+UGxcB6E/Kixg7fKgHLnkHZYqkmCZ8mfzakzoxGeh
         Qr2NP2dHG4X3IyJVGw6k+2uUWvJ4ngc09wt+8iflAGSu6Q83Io+MlMdleTFe+BGyrgkJ
         m/bxdLfJ2bvtM2TIaeBbW76GZwLq0LpSQNQBAQyNDiQhnneQkpnAs+sv1ywrLSTVcHkN
         DJ/lP59hw7VkosoN01pmJUm6ku6rEWHdNx0R5/bZfGrEwIDf/MpVTCVwTh/IIF2GRwTX
         UODQ==
X-Gm-Message-State: APjAAAXJNMS6QMa4SBgCm+aN8AyzFJ9nARsyS87SkNHpNvDcuGgsiTRl
        TMUKXG2FhRA8phWgMzrYbxzmBM2GMq/sm48/kvfMb1vt
X-Google-Smtp-Source: APXvYqx3cffA5MgnPE2zlrlibAFhq74X+6pTLBQU1EF3e0vVDhp4v15jkcVQLcv+96gYjpYP2Ed0mImHTSy7IJ2TZzE=
X-Received: by 2002:a50:ec0e:: with SMTP id g14mr80852825edr.210.1564766977194;
 Fri, 02 Aug 2019 10:29:37 -0700 (PDT)
MIME-Version: 1.0
References: <7090709d3ddace589952a128fb62f6603e2da9e8.1564653511.git.aclaudi@redhat.com>
 <20190801081620.6b25d23c@hermes.lan> <CAPpH65wSxeXGQc+r+7W_LRZR=vjnL2bXfub1U10vt-Gni67+kQ@mail.gmail.com>
 <20190802084933.10992569@hermes.lan>
In-Reply-To: <20190802084933.10992569@hermes.lan>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Fri, 2 Aug 2019 19:30:39 +0200
Message-ID: <CAPpH65wMUeRM05UNdwQqHOCUtxwbxVArsqbY=Yi-PP=cnxxc0w@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] ip tunnel: add json output
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 5:49 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 2 Aug 2019 13:14:15 +0200
> Andrea Claudi <aclaudi@redhat.com> wrote:
>
> > On Thu, Aug 1, 2019 at 5:16 PM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > >
> > > On Thu,  1 Aug 2019 12:12:58 +0200
> > > Andrea Claudi <aclaudi@redhat.com> wrote:
> > >
> > > > Add json support on iptunnel and ip6tunnel.
> > > > The plain text output format should remain the same.
> > > >
> > > > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > > > ---
> > > >  ip/ip6tunnel.c | 82 +++++++++++++++++++++++++++++++--------------
> > > >  ip/iptunnel.c  | 90 +++++++++++++++++++++++++++++++++-----------------
> > > >  ip/tunnel.c    | 42 +++++++++++++++++------
> > > >  3 files changed, 148 insertions(+), 66 deletions(-)
> > > >
> > > > diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
> > > > index d7684a673fdc4..f2b9710c1320f 100644
> > > > --- a/ip/ip6tunnel.c
> > > > +++ b/ip/ip6tunnel.c
> > > > @@ -71,57 +71,90 @@ static void usage(void)
> > > >  static void print_tunnel(const void *t)
> > > >  {
> > > >       const struct ip6_tnl_parm2 *p = t;
> > > > -     char s1[1024];
> > > > -     char s2[1024];
> > > > +     SPRINT_BUF(b1);
> > > >
> > > >       /* Do not use format_host() for local addr,
> > > >        * symbolic name will not be useful.
> > > >        */
> > > > -     printf("%s: %s/ipv6 remote %s local %s",
> > > > -            p->name,
> > > > -            tnl_strproto(p->proto),
> > > > -            format_host_r(AF_INET6, 16, &p->raddr, s1, sizeof(s1)),
> > > > -            rt_addr_n2a_r(AF_INET6, 16, &p->laddr, s2, sizeof(s2)));
> > > > +     open_json_object(NULL);
> > > > +     print_string(PRINT_ANY, "ifname", "%s: ", p->name);
> > >
> > > Print this using color for interface name?
> >
> > Thanks for the suggestion, I can do the same also for remote and local
> > addresses?
> >
> > >
> > >
> > > > +     snprintf(b1, sizeof(b1), "%s/ipv6", tnl_strproto(p->proto));
> > > > +     print_string(PRINT_ANY, "mode", "%s ", b1);
> > > > +     print_string(PRINT_ANY,
> > > > +                  "remote",
> > > > +                  "remote %s ",
> > > > +                  format_host_r(AF_INET6, 16, &p->raddr, b1, sizeof(b1)));
> > > > +     print_string(PRINT_ANY,
> > > > +                  "local",
> > > > +                  "local %s",
> > > > +                  rt_addr_n2a_r(AF_INET6, 16, &p->laddr, b1, sizeof(b1)));
> > > > +
> > > >       if (p->link) {
> > > >               const char *n = ll_index_to_name(p->link);
> > > >
> > > >               if (n)
> > > > -                     printf(" dev %s", n);
> > > > +                     print_string(PRINT_ANY, "link", " dev %s", n);
> > > >       }
> > > >
> > > >       if (p->flags & IP6_TNL_F_IGN_ENCAP_LIMIT)
> > > > -             printf(" encaplimit none");
> > > > +             print_bool(PRINT_ANY,
> > > > +                        "ip6_tnl_f_ign_encap_limit",
> > > > +                        " encaplimit none",
> > > > +                        true);
> > >
> > > For flags like this, print_null is more typical JSON than a boolean
> > > value. Null is better for presence flag. Bool is better if both true and
> > > false are printed.
> >
> > Using print_null json JSON output becomes:
> >
> >   {
> >     "ifname": "gre2",
> >     "mode": "gre/ipv6",
> >     "remote": "fd::1",
> >     "local": "::",
> >     "ip6_tnl_f_ign_encap_limit": null,
> >     "hoplimit": 64,
> >     "tclass": "0x00",
> >     "flowlabel": "0x00000",
> >     "flowinfo": "0x00000000",
> >     "flags": []
> >   }
> >
> > Which seems a bit confusing to me (what does the "null" value means?).
> > Using print_null we also introduce an inconsistency with the JSON
> > output of ip/link_gre6.c and ip/link_ip6tnl.c.
> > I would prefer to use print_bool and print out
> > ip6_tnl_f_ign_encap_limit both when true and false, patching both
> > files above to do the same. WDYT?
>
> JSON has several ways to represent the same type of flag value.
> Since JSON always has key/value. Null is used to indicate something is present and
> in that case the value is unnecessary, which is what the null field was meant for.
>

Thanks for the clarification, Stephen.
I'll submit a v2 with print_null and I'll fix cases similar to the one
you highlighted above in subsequent patches.
