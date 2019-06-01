Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C12D318E7
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 03:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfFABn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 21:43:56 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41844 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFABnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 21:43:55 -0400
Received: by mail-lj1-f196.google.com with SMTP id s21so646035lji.8
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 18:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jlr9qLL9Vgy0gBgXQ4/IDkCeMqnCFC9akEvCKd6pcyk=;
        b=IVZ5ehzB6ICtTECBvev1+6YDAck4uWc1fNoix/YTnUZqH/f+EZ/+QzfGrUTUDdClhR
         1KHV1xkvvlRHxORE8XZ2B55j3aYNSi+nU7sf2SYlOVVn1g7zyimhWIwMdKHEufwqcYp/
         dEhzv92KcAA1bg53LMIWyNfSAYz2QMto+1hW9OE/TTjbXZEJCuvWP+YNJsEBOpxlWQew
         +bSYcSWzdi0qFF0n7/GVAt9AjPfvkk1zKgB6A10GoAFZijkFL1uCWGCAZmtRw5239rC0
         WsbaKlX0nu3M545pgNlE1qm8mvbUKmYyrcPsC78j4EFKJKvyw4IOxt/9LZ0t3kWxg0of
         Lo3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jlr9qLL9Vgy0gBgXQ4/IDkCeMqnCFC9akEvCKd6pcyk=;
        b=LnZmVpDovMEOoQK3Huslv7dHY5L19HKzDhEzfvX/ds7lI0QJ31MAx8WHCilzXJWLj5
         vuE1gNA9AvO5MMJX7/QwYMn/NwYNV4Ok5JPxfNKGCv3T4oUgQ55iOX3ozTMY4mI4maaM
         SUp3h84ow7oBRr/jO01qtBs/6Kb14d34LHyrrmoiOUNI8tSSr/RjTU3JO5cEqYAb7TSJ
         O5oP3JOx9TViDmlIFIqYtklhKSsa8BvxEL+5XbD26XH2GwxTEdKe+NuKNrxit6wanVnR
         umtbryO5zXIGiVKrO4j3IPhmgwkXKNqgdnpnC7xFaX+3zaZFbsJxYDIXWYONojJKUrL/
         zTTA==
X-Gm-Message-State: APjAAAXdljKsGyDMkbKUWjiwG98/Wv/dHXBbwT3VtWyXfXglwARujIb1
        pCBNIf1WgPK108ZaJybzyCyrS5w6IRGdshJlO3k=
X-Google-Smtp-Source: APXvYqzlsf//pVpSmUOSuwFVmk1vYklv7DGK8tKh4y+ea4A5HdMzHgSdhRBlInwGpO5rJCz6ns2PXqPY6cs0leugv80=
X-Received: by 2002:a2e:5b52:: with SMTP id p79mr7652647ljb.208.1559353433988;
 Fri, 31 May 2019 18:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190507091118.24324-1-liuhangbin@gmail.com> <20190508.093541.1274244477886053907.davem@davemloft.net>
In-Reply-To: <20190508.093541.1274244477886053907.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 31 May 2019 18:43:42 -0700
Message-ID: <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
To:     David Miller <davem@davemloft.net>,
        Lorenzo Colitti <lorenzo@google.com>, astrachan@google.com,
        Greg KH <greg@kroah.com>
Cc:     liuhangbin@gmail.com, Linux NetDev <netdev@vger.kernel.org>,
        mateusz.bajorski@nokia.com, dsa@cumulusnetworks.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI, this userspace visible change in behaviour breaks Android.

We rely on being able to add a rule and either have a dup be created
(in which case we'll remove it later) or have it fail with EEXIST (in
which case we won't remove it later).

Returning 0 makes atomically changing a rule difficult.

Please revert.

On Wed, May 8, 2019 at 9:39 AM David Miller <davem@davemloft.net> wrote:
>
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Tue,  7 May 2019 17:11:18 +0800
>
> > With commit 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to
> > fib_nl_newrule") we now able to check if a rule already exists. But this
> > only works with iproute2. For other tools like libnl, NetworkManager,
> > it still could add duplicate rules with only NLM_F_CREATE flag, like
> >
> > [localhost ~ ]# ip rule
> > 0:      from all lookup local
> > 32766:  from all lookup main
> > 32767:  from all lookup default
> > 100000: from 192.168.7.5 lookup 5
> > 100000: from 192.168.7.5 lookup 5
> >
> > As it doesn't make sense to create two duplicate rules, let's just return
> > 0 if the rule exists.
> >
> > Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
> > Reported-by: Thomas Haller <thaller@redhat.com>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>
> Applied and queued up for -stable, thanks.
