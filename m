Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E9B63E4E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 01:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfGIXTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 19:19:33 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44141 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIXTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 19:19:33 -0400
Received: by mail-lf1-f68.google.com with SMTP id r15so198422lfm.11
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 16:19:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ft+jHBciVYxDrRFiK8w1c/uzct7JzZrQ0AUuMwhMvn0=;
        b=Yw7U0pNOvkvPKaHIDnKKScGlB9Dg73GKetwD6Hr7/+UoECwP6eh52dWdAeQayM0Cw5
         m894mHSur3ZdtwkPVa4Ka5rUptlRBJTXVKd4LGYZMXu5cIwR1l7TP7T4jAjOZNIKf+Eb
         43ZBFQXG7DavFZv5uSF0a02sctk4Bbo5Y/ayBoIWo84amfSQt38QcDn7YbtsQhxTm0hp
         MAPlT1dIXXPRAtRPIgQg/GLXshEF4M1YMH0+Dfznqgk0vMikzEJgjTCIisJMviqqmQw3
         sYOxQkGYPFLuMxsVE/zH1W21/iXtnua4Sc+su1+AJB38T1c4+0c+JkWBN9u5MxhUEv2B
         gupg==
X-Gm-Message-State: APjAAAVJdleKlwqDUmZW7UWdTGnIQ3IqiEK/XGDcOUye9TZh+E7+mtvY
        iliGgBxtG4IeA0u/rxPuSOInlQDKfFh0K4mVmZC1dN51KJ8=
X-Google-Smtp-Source: APXvYqyvI6O94W1xajnAjogBXqSxS33RrxGFDZMwCs9vWLvTgwrTmbRiUsAoiCjd+loL8qhWm//KlCW8x34M5qsSc0Y=
X-Received: by 2002:ac2:4466:: with SMTP id y6mr8654254lfl.0.1562714371298;
 Tue, 09 Jul 2019 16:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190709204040.17746-1-mcroce@redhat.com> <20190709143758.695a65bc@hermes.lan>
In-Reply-To: <20190709143758.695a65bc@hermes.lan>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 10 Jul 2019 01:18:55 +0200
Message-ID: <CAGnkfhz+p1o_yHxk2jkY9ggNwLSO-Jk4BcxPuWhSHw1YXoJsSw@mail.gmail.com>
Subject: Re: [PATCH iproute2] utils: don't match empty strings as prefixes
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 11:38 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue,  9 Jul 2019 22:40:40 +0200
> Matteo Croce <mcroce@redhat.com> wrote:
>
> > iproute has an utility function which checks if a string is a prefix for
> > another one, to allow use of abbreviated commands, e.g. 'addr' or 'a'
> > instead of 'address'.
> >
> > This routine unfortunately considers an empty string as prefix
> > of any pattern, leading to undefined behaviour when an empty
> > argument is passed to ip:
> >
> >     # ip ''
> >     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
> >         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> >         inet 127.0.0.1/8 scope host lo
> >            valid_lft forever preferred_lft forever
> >         inet6 ::1/128 scope host
> >            valid_lft forever preferred_lft forever
> >
> >     # tc ''
> >     qdisc noqueue 0: dev lo root refcnt 2
> >
> >     # ip address add 192.0.2.0/24 '' 198.51.100.1 dev dummy0
> >     # ip addr show dev dummy0
> >     6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
> >         link/ether 02:9d:5e:e9:3f:c0 brd ff:ff:ff:ff:ff:ff
> >         inet 192.0.2.0/24 brd 198.51.100.1 scope global dummy0
> >            valid_lft forever preferred_lft forever
> >
> > Rewrite matches() so it takes care of an empty input, and doesn't
> > scan the input strings three times: the actual implementation
> > does 2 strlen and a memcpy to accomplish the same task.
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > ---
> >  include/utils.h |  2 +-
> >  lib/utils.c     | 14 +++++++++-----
> >  2 files changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/utils.h b/include/utils.h
> > index 927fdc17..f4d12abb 100644
> > --- a/include/utils.h
> > +++ b/include/utils.h
> > @@ -198,7 +198,7 @@ int nodev(const char *dev);
> >  int check_ifname(const char *);
> >  int get_ifname(char *, const char *);
> >  const char *get_ifname_rta(int ifindex, const struct rtattr *rta);
> > -int matches(const char *arg, const char *pattern);
> > +int matches(const char *prefix, const char *string);
> >  int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits);
> >  int inet_addr_match_rta(const inet_prefix *m, const struct rtattr *rta);
> >
> > diff --git a/lib/utils.c b/lib/utils.c
> > index be0f11b0..73ce19bb 100644
> > --- a/lib/utils.c
> > +++ b/lib/utils.c
> > @@ -887,13 +887,17 @@ const char *get_ifname_rta(int ifindex, const struct rtattr *rta)
> >       return name;
> >  }
> >
> > -int matches(const char *cmd, const char *pattern)
> > +/* Check if 'prefix' is a non empty prefix of 'string' */
> > +int matches(const char *prefix, const char *string)
> >  {
> > -     int len = strlen(cmd);
> > +     if (!*prefix)
> > +             return 1;
> > +     while(*string && *prefix == *string) {
> > +             prefix++;
> > +             string++;
> > +     }
> >
> > -     if (len > strlen(pattern))
> > -             return -1;
> > -     return memcmp(pattern, cmd, len);
> > +     return *prefix;
> >  }
> >
> >  int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits)
>
> ERROR: space required before the open parenthesis '('
> #134: FILE: lib/utils.c:895:
> +       while(*string && *prefix == *string) {
>
> total: 1 errors, 1 warnings, 30 lines checked
>
> The empty prefix string is a bug and should not be allowed.
> Also return value should be same as old code (yours isn't).
>
>
>

The old return value was the difference between the first pair of
bytes, according to the memcmp manpage.
All calls only checks if the matches() return value is 0 or not 0:

iproute2$ git grep 'matches(' |grep -v -e '== 0' -e '= 0' -e '!matches('
include/utils.h:int matches(const char *prefix, const char *string);
include/xtables.h:extern void xtables_register_matches(struct
xtables_match *, unsigned int);
lib/color.c:    if (matches(dup, "-color"))
lib/utils.c:int matches(const char *prefix, const char *string)
tc/tc.c:                if (matches(argv[0], iter->c))

Is it a problem if it returns a non negative value for non matching strings?

Regards,


--
Matteo Croce
per aspera ad upstream
