Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F64622FD32
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgG0XZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgG0XZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 19:25:49 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F681C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:25:49 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l17so18843159iok.7
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ul6OG5AcyM9q1mi7Ptad8xTbwNUTplojUbpuQmVnOns=;
        b=IPa1kzP5ylvOjB10fuF6IEq885IGogjYVDb9kpeYpNKZVof0od0BcRsCGjG93WvhZF
         XFpKcVArTG+IOG8IDmCHPzWgzo6h/Ovka5+IOqMCWgsN2K2extLFdRVXmSX5AyVE7Ler
         oUeIWUZAo9ZSZlboKQK4hUuTzVlX7OzSkMl/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ul6OG5AcyM9q1mi7Ptad8xTbwNUTplojUbpuQmVnOns=;
        b=q78KQG+b/bogqZOaKIBmyr/bjAkHJlKFFJgvGYy0BDlcitwuD8+xzJ3vwnXQZRexDm
         jjCqL/hOq25yYvFHfoEi1VszT4tsN3ScxDXJqLPurQ41IOy3e2wlTBftSyVGygxjHBOw
         DHfX3RRmJ2qnoM4Sbj2MK7GOsJJQICdcbkfx5ZTWEAAIuNjqGyu0YNfnk1jDhhcNxn0T
         56JdjkwJjogltdNYLoAo+4q/AJMoQukENITHbVNIqUmPAX37NlvEclgLO7OSCYmE5Szs
         XiiAzuaWq5iAcu2d+MY6UBro+orw1sxySsYzV9PynkJGod7IMrKGl7yV44B2zgyicIxm
         YCRA==
X-Gm-Message-State: AOAM532ggvSSQuBA0qSByrAFt7Yg4tjlN+/U8sJwBwb5OPOzvRkhwZZj
        ZiTEn3INw9MXwlLvapklf1bsQRuYpYTdi4aoLYWc
X-Google-Smtp-Source: ABdhPJwxtoIRaMqJXNzMSbASUGjLtcFW/eeOzkWEbrzbg/6KTN3tLOLaoQWh9UCKEqFsoeHfxvtEFrbXlLFRCSNa+ps=
X-Received: by 2002:a02:840e:: with SMTP id k14mr28736959jah.133.1595892348918;
 Mon, 27 Jul 2020 16:25:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200727162009.7618-1-julien@cumulusnetworks.com> <20200727093027.467da3a7@hermes.lan>
In-Reply-To: <20200727093027.467da3a7@hermes.lan>
From:   Julien Fortin <julien@cumulusnetworks.com>
Date:   Tue, 28 Jul 2020 01:25:38 +0200
Message-ID: <CAM_1_KxDbSqaUWr4apTs4ydizTiohm7_L=B=0mZxeMX=nNEwzA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next master v2] bridge: fdb show: fix fdb entry
 state output (+ add json support)
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 6:30 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 27 Jul 2020 18:20:09 +0200
> Julien Fortin <julien@cumulusnetworks.com> wrote:
>
> > diff --git a/bridge/fdb.c b/bridge/fdb.c
> > index d1f8afbe..765f4e51 100644
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
> > +             sprintf(buf, "state %#x", s)
>
> Please keep the "state=%#x" for the non JSON case.
> No need to change output format.

My v1 patch (see below) kept the "state=" but you asked me to remove
it and re-submit.

diff --git a/bridge/fdb.c b/bridge/fdb.c
index d2247e80..198c51d1 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
        if (s & NUD_REACHABLE)
                return "";

-       sprintf(buf, "state=%#x", s);
+       if (is_json_context())
+               sprintf(buf, "%#x", s);
+       else
+               sprintf(buf, "state=%#x", s);
        return buf;
 }
