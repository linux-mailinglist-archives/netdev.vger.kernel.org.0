Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BAE64399
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGJIcK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Jul 2019 04:32:10 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35988 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfGJIcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:32:10 -0400
Received: by mail-ed1-f66.google.com with SMTP id k21so1368054edq.3
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 01:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=szF7FqwUgzf/Ka1JcPIDgfZlkwR+2rbCwKHlkw7YyPc=;
        b=hU98XaqtZXNSuHZrnMsAfmVrpCIbxtmFbt5lyZXhlW/z1LqObtcjjv4r18bWmx/eE/
         oPW6hWqBXMFv33oMfXT56HFpC0eRxh7kXErimmx2dRzXexN5pSX8QQnEZNkUPzF9+GcF
         AOWTfeReHA3iQ3n30pQ9lRYTU/MtOBlpuBIqZyMSU0cIYynsJaS/GVfQxkG+u6T9B6TL
         l7e+HCRwyrOl/JPbTsmKIIWt9/XPF7tEpKrIXfOpwnT8T2u/ELtuK/7IUCg9CgOjsvWA
         F5esC/H6aDXr26V/ItASQoXXLxLQgx07z8kDgOEW+lV19Ptj91au4P1bFL0SbQgthK+K
         YOAA==
X-Gm-Message-State: APjAAAV09Qt2e1zpEyZjG8ylr7Kj7p0vdjdSk0HFzxqZtZIfKr03E9PY
        stj5YQANTL916BOYzHO8xSYb/U55xrYlIpdiPZJeaQ==
X-Google-Smtp-Source: APXvYqz2hAaQTWTs/cRfW+OJn6TdZSBKxpf5+JaarVKKZyPuHx4aHsAo85nZV/BHVXdYrRzzqoafhTEuFtKm/UGLbmw=
X-Received: by 2002:a17:906:6bc4:: with SMTP id t4mr25383097ejs.256.1562747527727;
 Wed, 10 Jul 2019 01:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562667648.git.aclaudi@redhat.com> <dfb76d0e40b0158cf6a87ae9558b256915d73f6f.1562667648.git.aclaudi@redhat.com>
 <CAF2d9jhiUk0Jpz54EbA+3Fyf-cMniRHZrpktu57yZ+tX+QsuEQ@mail.gmail.com>
In-Reply-To: <CAF2d9jhiUk0Jpz54EbA+3Fyf-cMniRHZrpktu57yZ+tX+QsuEQ@mail.gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Wed, 10 Jul 2019 10:33:01 +0200
Message-ID: <CAPpH65yDsY_FpBvXfSiw=HVEvgL6n3a0nqA3JEbgpB=5kKfXeA@mail.gmail.com>
Subject: Re: [PATCH iproute2 2/2] ip tunnel: warn when changing IPv6 tunnel
 without tunnel name
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 12:15 AM Mahesh Bandewar (महेश बंडेवार)
<maheshb@google.com> wrote:
>
> On Tue, Jul 9, 2019 at 6:16 AM Andrea Claudi <aclaudi@redhat.com> wrote:
> >
> > Tunnel change fails if a tunnel name is not specified while using
> > 'ip -6 tunnel change'. However, no warning message is printed and
> > no error code is returned.
> >
> > $ ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote fd::2 tos inherit ttl 127 encaplimit none dev dummy0
> > $ ip -6 tunnel change dev dummy0 local 2001:1234::1 remote 2001:1234::2
> > $ ip -6 tunnel show ip6tnl1
> > ip6tnl1: gre/ipv6 remote fd::2 local fd::1 dev dummy0 encaplimit none hoplimit 127 tclass inherit flowlabel 0x00000 (flowinfo 0x00000000)
> >
> > This commit checks if tunnel interface name is equal to an empty
> > string: in this case, it prints a warning message to the user.
> > It intentionally avoids to return an error to not break existing
> > script setup.
> >
> > This is the output after this commit:
> > $ ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote fd::2 tos inherit ttl 127 encaplimit none dev dummy0
> > $ ip -6 tunnel change dev dummy0 local 2001:1234::1 remote 2001:1234::2
> > Tunnel interface name not specified
> > $ ip -6 tunnel show ip6tnl1
> > ip6tnl1: gre/ipv6 remote fd::2 local fd::1 dev dummy0 encaplimit none hoplimit 127 tclass inherit flowlabel 0x00000 (flowinfo 0x00000000)
> >
> > Reviewed-by: Matteo Croce <mcroce@redhat.com>
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
>
> I tried your patch and the commands that I posted in my (previous) patch.
>

Hi Mahesh,
Thank you for taking the time to review my patch.

> Here is the output after reverting my patch and applying your patch
>
> <show command>
> ------------------------
> vm0:/tmp# ./ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote
> fd::2 tos inherit ttl 127 encaplimit none
> vm0:/tmp# ./ip -6 tunnel show dev ip6tnl1
> vm0:/tmp# echo $?
> 0
>
> here the output is NULL and return code is 0. This is wrong and I
> would expect to see the tunnel info (as displayed in 'ip -6 tunnel
> show ip6tnl1')

It seems to me there is a bit of misunderstanding here. Looking at man
page for ip tunnel:

dev NAME
       bind the tunnel to the device NAME so that tunneled packets
will only be routed via this device and will not be able to escape to
another device when the route to endpoint changes.

From what I read, dev parameter should not be used as an alias to the
tunnel device, but to indicate the device to which the tunnel should
be binded.
As such, ip -6 tunnel show dev <name> is a legitimate query that must
show the tunnel device(s) binded to <name> interface.
With the query ip -6 tunnel show <name> you instead obtain the tunnel itself.

By the way, the proper selector for the tunnel device name is the
default "name" parameter. From the man page:

name NAME (default)
       select the tunnel device name.

For example:
$ ip -6 tunnel show name ip6tnl0
ip6tnl0: ipv6/ipv6 remote :: local :: encaplimit 0 hoplimit inherit
tclass 0x00 flowlabel 0x00000 (flowinfo 0x00000000)

> <change command>
> lpaa10:/tmp# ip -6 tunnel change dev ip6tnl1 local 2001:1234::1 remote
> 2001:1234::2 encaplimit none ttl 127 tos inherit allow-localremote
> lpaa10:/tmp# echo $?
> 0
> lpaa10:/tmp# ip -6 tunnel show dev ip6tnl1
> lpaa10:/tmp# ip -6 tunnel show ip6tnl1
> ip6tnl1: gre/ipv6 remote fd::2 local fd::1 encaplimit none hoplimit
> 127 tclass inherit flowlabel 0x00000 (flowinfo 0x00000000)
>
> the change command appeared to be successful but change wasn't applied
> (expecting the allow-localremote to be present on the tunnel).

As you can read from the commit message, here I am not changing the
return code intentionally to not break existing script setup.
However, I can easily change this to return an error code in a v2.

> ---
> >  ip/ip6tunnel.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
> > index 999408ed801b1..e3da11eb4518e 100644
> > --- a/ip/ip6tunnel.c
> > +++ b/ip/ip6tunnel.c
> > @@ -386,6 +386,9 @@ static int do_add(int cmd, int argc, char **argv)
> >         if (parse_args(argc, argv, cmd, &p) < 0)
> >                 return -1;
> >
> > +       if (!*p.name)
> > +               fprintf(stderr, "Tunnel interface name not specified\n");
> > +
> >         if (p.proto == IPPROTO_GRE)
> >                 basedev = "ip6gre0";
> >         else if (p.i_flags & VTI_ISVTI)
> > --
> > 2.20.1
> >

Regards,
Andrea
