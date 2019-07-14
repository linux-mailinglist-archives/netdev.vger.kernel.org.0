Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19E667F7E
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfGNO6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 10:58:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43265 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbfGNO6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 10:58:33 -0400
Received: by mail-lj1-f195.google.com with SMTP id 16so13648712ljv.10
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 07:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8BpHvv1vIpr8Yfic66erizLIYwp5jRBT9lXbnlXoDg=;
        b=sA0l6OeC2+YLuJzKy/dgqt8+65OWenNTvD6VWlrmqYpj6BB8Tlo8+4se7FbA/L3qEd
         +KVviGowXapsB6tPN5c5yVHmNjVUMLUEIwgAXSrXnRinaj7Mk7MlUOL+qlntSlE4CMWU
         i7j6T7PltEpPzpDeQcd0kEJrDvAXoWuZTcBSrDpFbAuJl9HxeIAT99fp2t0gNqiz5KbM
         eFMoR61pfnSgsgOZBGhdYtbzmNKk1nZXaqcrWc3QXNP0jTaVrBkU0TLn9jxWHm9Vjj0s
         V+JWRTagzcpcrswzJ6PzvMN7p7U8v2ERm1FiChrpUZh3lUjMbwjPg94OvmgTSBbhirxs
         qevw==
X-Gm-Message-State: APjAAAW+duWij1AEcFcW3UeqQYJ3lvnPyZtNn8aFecOICns80TL2jWWN
        bvHTnykiqxrUYn8dWWltSNijJoAyPyP0xPi4P7FCtOyPKnc=
X-Google-Smtp-Source: APXvYqzo0PqxzRiquhbTt6ZS1fenW+YS0aA+0ZLt7Z81V+xJYPAd1Zgl2Af1hO01RYqNnbYqDZOkGXXcTqd9XrkK5ys=
X-Received: by 2002:a2e:89ca:: with SMTP id c10mr11249917ljk.106.1563116310482;
 Sun, 14 Jul 2019 07:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190709204040.17746-1-mcroce@redhat.com> <20190709143758.695a65bc@hermes.lan>
 <CAGnkfhz+p1o_yHxk2jkY9ggNwLSO-Jk4BcxPuWhSHw1YXoJsSw@mail.gmail.com>
In-Reply-To: <CAGnkfhz+p1o_yHxk2jkY9ggNwLSO-Jk4BcxPuWhSHw1YXoJsSw@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sun, 14 Jul 2019 16:57:54 +0200
Message-ID: <CAGnkfhyyJJR0frmO7Z+bviu6xYnJVitw-G0Nzgv9UQ2PYO1goA@mail.gmail.com>
Subject: Re: [PATCH iproute2] utils: don't match empty strings as prefixes
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 1:18 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Tue, Jul 9, 2019 at 11:38 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Tue,  9 Jul 2019 22:40:40 +0200
> > Matteo Croce <mcroce@redhat.com> wrote:
> >
> > > iproute has an utility function which checks if a string is a prefix for
> > > another one, to allow use of abbreviated commands, e.g. 'addr' or 'a'
> > > instead of 'address'.
> > >
> > > This routine unfortunately considers an empty string as prefix
> > > of any pattern, leading to undefined behaviour when an empty
> > > argument is passed to ip:
> > >
> > >     # ip ''
> > >     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
> > >         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> > >         inet 127.0.0.1/8 scope host lo
> > >            valid_lft forever preferred_lft forever
> > >         inet6 ::1/128 scope host
> > >            valid_lft forever preferred_lft forever
> > >
> > >     # tc ''
> > >     qdisc noqueue 0: dev lo root refcnt 2
> > >
> > >     # ip address add 192.0.2.0/24 '' 198.51.100.1 dev dummy0
> > >     # ip addr show dev dummy0
> > >     6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
> > >         link/ether 02:9d:5e:e9:3f:c0 brd ff:ff:ff:ff:ff:ff
> > >         inet 192.0.2.0/24 brd 198.51.100.1 scope global dummy0
> > >            valid_lft forever preferred_lft forever
> > >
> > > Rewrite matches() so it takes care of an empty input, and doesn't
> > > scan the input strings three times: the actual implementation
> > > does 2 strlen and a memcpy to accomplish the same task.
> > >
> > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > ---
> > >  include/utils.h |  2 +-
> > >  lib/utils.c     | 14 +++++++++-----
> > >  2 files changed, 10 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/include/utils.h b/include/utils.h
> > > index 927fdc17..f4d12abb 100644
> > > --- a/include/utils.h
> > > +++ b/include/utils.h
> > > @@ -198,7 +198,7 @@ int nodev(const char *dev);
> > >  int check_ifname(const char *);
> > >  int get_ifname(char *, const char *);
> > >  const char *get_ifname_rta(int ifindex, const struct rtattr *rta);
> > > -int matches(const char *arg, const char *pattern);
> > > +int matches(const char *prefix, const char *string);
> > >  int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits);
> > >  int inet_addr_match_rta(const inet_prefix *m, const struct rtattr *rta);
> > >
> > > diff --git a/lib/utils.c b/lib/utils.c
> > > index be0f11b0..73ce19bb 100644
> > > --- a/lib/utils.c
> > > +++ b/lib/utils.c
> > > @@ -887,13 +887,17 @@ const char *get_ifname_rta(int ifindex, const struct rtattr *rta)
> > >       return name;
> > >  }
> > >
> > > -int matches(const char *cmd, const char *pattern)
> > > +/* Check if 'prefix' is a non empty prefix of 'string' */
> > > +int matches(const char *prefix, const char *string)
> > >  {
> > > -     int len = strlen(cmd);
> > > +     if (!*prefix)
> > > +             return 1;
> > > +     while(*string && *prefix == *string) {
> > > +             prefix++;
> > > +             string++;
> > > +     }
> > >
> > > -     if (len > strlen(pattern))
> > > -             return -1;
> > > -     return memcmp(pattern, cmd, len);
> > > +     return *prefix;
> > >  }
> > >
> > >  int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits)
> >
> > ERROR: space required before the open parenthesis '('
> > #134: FILE: lib/utils.c:895:
> > +       while(*string && *prefix == *string) {
> >
> > total: 1 errors, 1 warnings, 30 lines checked
> >
> > The empty prefix string is a bug and should not be allowed.
> > Also return value should be same as old code (yours isn't).
> >
> >
> >
>
> The old return value was the difference between the first pair of
> bytes, according to the memcmp manpage.
> All calls only checks if the matches() return value is 0 or not 0:
>
> iproute2$ git grep 'matches(' |grep -v -e '== 0' -e '= 0' -e '!matches('
> include/utils.h:int matches(const char *prefix, const char *string);
> include/xtables.h:extern void xtables_register_matches(struct
> xtables_match *, unsigned int);
> lib/color.c:    if (matches(dup, "-color"))
> lib/utils.c:int matches(const char *prefix, const char *string)
> tc/tc.c:                if (matches(argv[0], iter->c))
>
> Is it a problem if it returns a non negative value for non matching strings?
>
> Regards,
>
>
> --
> Matteo Croce
> per aspera ad upstream

Hi Stephen,

should I send a v2 which keeps the old behaviour, even if noone checks
for all the values?
Just to clarify, the old behaviour of matches(cmd, pattern) was:

-1 if len(cmd) > len(pattern)
0 if pattern is equal to cmd
0 if pattern starts with cmd
< 0 if pattern is alphabetically lower than cmd
> 0 if pattern is alphabetically higher than cmd

Regards,
-- 
Matteo Croce
per aspera ad upstream
