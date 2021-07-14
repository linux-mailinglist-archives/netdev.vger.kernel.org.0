Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA1C3C7B9C
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 04:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237474AbhGNCV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 22:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237370AbhGNCVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 22:21:55 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC61C0613DD;
        Tue, 13 Jul 2021 19:19:03 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id hc15so652452ejc.4;
        Tue, 13 Jul 2021 19:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zp6zsGwDAeX6wMArIHCu+0y40oH8ooEC9/7FEkdTzGw=;
        b=f/2n8iV4brqzHT4q325dwfGkaEAbRoWfZxC31W5f/r0XcQB6uIhv5cg9EbdCFPOTJU
         QV8QaFle31jZEerVppTBRVzEQLnM84YvvUgp8jawaOhdmXd8Ev8F+DFACmm3hrwW4T4S
         cECjX3DxB8P6/VBVa6Be6ESvMlmU61C0iSMYeSsdLDItS+3h6ORbDbtpxkOaJgJKMbSg
         oL0Qk6jwaMXUpIyeeidYecUpn3oZ22jSB5hOFwVaDV5HIgRE8dTI4RG9IbUiwZyA0tdf
         e5ZfJEPq78y20KPYr/wR6tjeYSVsr/b0nDBDJSYeRb3NjCcdb6paz5We03R8f7+2lRFp
         ImQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zp6zsGwDAeX6wMArIHCu+0y40oH8ooEC9/7FEkdTzGw=;
        b=JGatSXnDaFquIVL5JZ90mBhfNznwtCX/jQXywEBebo5mUIXUKUEqTmgHj7OdcKvUgj
         L7UktbtystidIVVK5mTbXSqeTUhw5y09KutcCP1ncTDezhkWc32vBpe965XjhGos4diX
         IiBWWwhc5eatwwfluLwAGyykhL2TRQWorNfRQUuhKyYYGsub+onIkRnEVRdzwhtPyCaK
         JukpH96MLyji7TY33NUD3q1JMUJ1UYfq5xyKbB2ouLcZ9wbiQlOL6oMV32jl3fPWoF8u
         T8P5TAZyk0ayfuG4zaaVfia/fy51Vk0gmdPnfbUK4Om1Skxr/DBJpQnAEv5FMP7BIiPG
         hKIw==
X-Gm-Message-State: AOAM53336kvFisTGriPUVzczKOUIuoS+P3cBwL500qwqbMtw7VTQUdCV
        8BcI5+RWouaUABBvHesFi3MWAiLAV0HSJAl/CS8=
X-Google-Smtp-Source: ABdhPJwzqK3h1FusW+AYXsGKy9t8rxUxASyN5ptDK02Eo9a01Qk4VvhzOwiF6ope51b5YbpqWT9IY6pLKIpFPNE/B9c=
X-Received: by 2002:a17:906:4784:: with SMTP id cw4mr9350494ejc.160.1626229142481;
 Tue, 13 Jul 2021 19:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210713130344.473646-1-mudongliangabcd@gmail.com>
 <20210713132059.GB11179@breakpoint.cc> <CAD-N9QV7pt3PCzUK2r03aB_URU5Auu+quC+DJpc=46hjkceBNg@mail.gmail.com>
 <20210713153115.GC11179@breakpoint.cc>
In-Reply-To: <20210713153115.GC11179@breakpoint.cc>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 14 Jul 2021 10:18:36 +0800
Message-ID: <CAD-N9QWmNYPkim_KrnUfvNhErUZaJqwGH-_3QvivVEvg+KnHjA@mail.gmail.com>
Subject: Re: [PATCH v2] audit: fix memory leak in nf_tables_commit
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        syzbot <syzkaller@googlegroups.com>,
        kernel test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 11:31 PM Florian Westphal <fw@strlen.de> wrote:
>
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > +static void nf_tables_commit_free(struct list_head *adl)
> > >
> > > nf_tables_commit_audit_free?
> >
> > What do you mean? Modify the name of newly added function to
> > nf_tables_commit_audit_free?
>
> Yes, this function is audit related, and it does the inverse
> of existing '...audit_alloc'.

Hi Florian,

I double-check the patch, and it seems there is no need to send a
followup patch (nf-next).

I will send a v3 patch with the new function name.

Best regards
Dongliang Mu
