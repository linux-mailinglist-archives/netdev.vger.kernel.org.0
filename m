Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D92761744D3
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 05:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgB2ECQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 23:02:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43598 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgB2ECQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 23:02:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id e10so4151292wrr.10
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 20:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U3/FZKx6L8Q08jTmbSx0oGLnqltCqMCplv25d8moljU=;
        b=u7iSFj436wN6MQy3DeLBB35LUAjwFG/7SWJaA7P+mz7Ts1R6SKm7E/7eapveSp2UDQ
         DXGrm8NhWOQ+exdaNPZTB6KOhVWEsBdObHewsr1nThi2sBC5UYg1W6ivHaTveAZHzMrC
         +og09biKQ8HEwVVX1pY59WflpX2VgVpKok5pDoBlhuGht+Ra9YNnaCaJuja6/yTDngj4
         1yM/UPktXNeDFGDDDSHPJD1ojbzvITyD5mzy12q76K83hoRFu0TQ3yTbQlyX3vbletbA
         zTOvnT8OeltrlpYpHfBJ+c98moN9kVRqcUiqj9OY+eZ82zGtiBrh4E7CUgBwHOgVT+eH
         C6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U3/FZKx6L8Q08jTmbSx0oGLnqltCqMCplv25d8moljU=;
        b=NwbK0BDBaaJ1WSggEGD7dZvj57sV/v3A5JYlYV0Dhgg/asT6TaWBwYXN9FZb8tIos4
         7ayjGwgxK369LCWVW89P+wZuiK2h5G4sNasMyhMcd/X+d5c/etmKm/hwiImFP3O4uhmm
         wcRoZzsO1XY67QXIqodeZni1ApT1q70TJObBlx/urKq+dbfi2fWx5W6kOV4tDnVWFy02
         qeVteCwB/NgI/+TjA7ulHsqsO78+0LL7O/ftiDiIWlAwIn5Cfb1pvHiIeqFs/jascHtu
         By3l230U7ioeUA9DoM5rIPOSvzwHSRhFrAGiZ7E0wtrjw5PcLgajtMj1wHzC1LVBqjOh
         OCWg==
X-Gm-Message-State: APjAAAUD+mQWGcvKFjtvGjELZggiLxjnqQOjl7jl3jtQHZP+ubeK/RJA
        2NWABDCRBKRi9Y7G6DdjtdmC605iFVPQOsW+pwM=
X-Google-Smtp-Source: APXvYqzk7d7tOyduB+JDH8H87neiv8iFZgKuquwpGZSjc9dOyBz2sz3EMKO/V53e0g7EMHtJePF9u28u4JurBClZnKU=
X-Received: by 2002:adf:ec0e:: with SMTP id x14mr7787928wrn.270.1582948934331;
 Fri, 28 Feb 2020 20:02:14 -0800 (PST)
MIME-Version: 1.0
References: <6d87af76cc3c311647c961e2f94e026bb15869d8.1582556221.git.lucien.xin@gmail.com>
 <20200228135154.61960560@hermes.lan>
In-Reply-To: <20200228135154.61960560@hermes.lan>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 29 Feb 2020 12:03:57 +0800
Message-ID: <CADvbK_eR=s6ctXK7UwXCKddyeSDSRZx3Ok+qy_ZJ_4vxkXN9bA@mail.gmail.com>
Subject: Re: [PATCH iproute2] xfrm: not try to delete ipcomp states when using deleteall
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 29, 2020 at 5:51 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 24 Feb 2020 09:57:01 -0500
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > In kernel space, ipcomp(sub) states used by main states are not
> > allowed to be deleted by users, they would be freed only when
> > all main states are destroyed and no one uses them.
> >
> > In user space, ip xfrm sta deleteall doesn't filter these ipcomp
> > states out, and it causes errors:
> >
> >   # ip xfrm state add src 192.168.0.1 dst 192.168.0.2 spi 0x1000 \
> >       proto comp comp deflate mode tunnel sel src 192.168.0.1 dst \
> >       192.168.0.2 proto gre
> >   # ip xfrm sta deleteall
> >   Failed to send delete-all request
> >   : Operation not permitted
> >
> > This patch is to fix it by filtering ipcomp states with a check
> > xsinfo->id.proto == IPPROTO_IPIP.
> >
> > Fixes: c7699875bee0 ("Import patch ipxfrm-20040707_2.diff")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
>
> Wow that has been broken for a long time, does anyone use this?
I don't know, it was just found in our testcase.
