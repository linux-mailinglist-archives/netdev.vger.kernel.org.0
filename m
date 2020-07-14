Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06308220111
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 01:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgGNXiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 19:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgGNXiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 19:38:06 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC93FC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 16:38:06 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k6so330185ili.6
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 16:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nynTDq8M69d+wnFYdulp6Kg0JtB4Pi37vPLUwgE3r2c=;
        b=Sy1+nN1IDzUD4wS82Rah2UU6pophu/5+zIUqMZXpQP9lmvglrc4nW57/DknsreMled
         qcrbUNteHPUlpfEza35kR2Lqoepy82fU2F65NwO23EM+s1MkE7gJjLpTVIhFT56I+Pcd
         olnigKc7rQJR3TQTIvXI3xIrdwgZV8VkkiS6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nynTDq8M69d+wnFYdulp6Kg0JtB4Pi37vPLUwgE3r2c=;
        b=ihku2POrC2UtWNe/Dhvyim9jbP65femsUWHmGmZ0b44r/FuPmOJQxF4/9FfUDYp0Ll
         wT/JV6K2i1wvWaCEkPCZ+HB5A/2Y8ERYHTlzeF3C77YYCHH739Sp09CvsrRkMTtTGFQ5
         4y2vj5K8JB8NIm8WTUE95xU0whVPZrgq6f5J7t73qzaeZKQ7jCGkyvfYqZkR8OwYzEA2
         ArybmrDQec2Lfe6X34uZftO6mBbtkoxDAuwLZxn5LqfVXTqnDpSJUdWXgzW0onGmNF6G
         7gvnGgbCTGghgDCtHUugmrsrXrWZfwBz0HZx9HA/lnPbZ3wRYwVYGoVXALN5h2kcVnac
         FOlw==
X-Gm-Message-State: AOAM530MGq4mUBC3ZmPhr/ve45y7aDuxmPphOdLY7M3XTNvqQQWQOJjV
        Rdn9Y4FCan40A8hDo2EzASsiiJpe4jIGPyz2XYFKf2DT4eoe
X-Google-Smtp-Source: ABdhPJwfZogh8p3WStOiCkURDoRb0620ofijg8uJLrVm+SIfPtcdSd7vDZUME0R+uFjEA9/loSXzZggSBPgEH8QurJk=
X-Received: by 2002:a05:6e02:bcd:: with SMTP id c13mr6820007ilu.184.1594769885899;
 Tue, 14 Jul 2020 16:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200710005055.8439-1-julien@cumulusnetworks.com> <20200713075445.33aca679@hermes.lan>
In-Reply-To: <20200713075445.33aca679@hermes.lan>
From:   Julien Fortin <julien@cumulusnetworks.com>
Date:   Wed, 15 Jul 2020 01:37:54 +0200
Message-ID: <CAM_1_Kzyef1cBFO3a2iF+Je7DP-WVNwS4rP3NzjHgOzA6rx_eQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next master] bridge: fdb show: fix fdb entry
 state output for json context
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 4:54 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 10 Jul 2020 02:50:55 +0200
> Julien Fortin <julien@cumulusnetworks.com> wrote:
>
> > From: Julien Fortin <julien@cumulusnetworks.com>
> >
> > bridge json fdb show is printing an incorrect / non-machine readable
> > value, when using -j (json output) we are expecting machine readable
> > data that shouldn't require special handling/parsing.
> >
> > $ bridge -j fdb show | \
> > python -c \
> > 'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),indent=4))'
> > [
> >     {
> >         "master": "br0",
> >         "mac": "56:23:28:4f:4f:e5",
> >         "flags": [],
> >         "ifname": "vx0",
> >         "state": "state=0x80"  <<<<<<<<< with the patch: "state": "0x80"
> >     }
> > ]
> >
> > Fixes: c7c1a1ef51aea7c ("bridge: colorize output and use JSON print library")
> > Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
> > ---
> >  bridge/fdb.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/bridge/fdb.c b/bridge/fdb.c
> > index d2247e80..198c51d1 100644
> > --- a/bridge/fdb.c
> > +++ b/bridge/fdb.c
> > @@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
> >       if (s & NUD_REACHABLE)
> >               return "";
> >
> > -     sprintf(buf, "state=%#x", s);
> > +     if (is_json_context())
> > +             sprintf(buf, "%#x", s);
> > +     else
> > +             sprintf(buf, "state=%#x", s);
> >       return buf;
> >  }
> >
>
> Printing in non JSON case was also wrong.
> i.e.
>               ...  state state=0x80
> should be:
>               ... state 0x80
>
> Let's do that.
>
>
> The state=xxx value only shows up if the FDB entry has a value bridge command
> doesn't understand. The bridge command needs to be able to display the new flag values.
>
> Please fixup the two patches and resubmit to iproute2

I'll resubmit a patch for this specific issue, to handle both json and
non-json case correctly but i don't think it's necessary to resubmit
"bridge: fdb get: add missing json init (new_json_obj)" as it's a
different issue.

(re-sending without html)
