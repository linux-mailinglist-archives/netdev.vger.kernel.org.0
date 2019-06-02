Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5110732343
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 14:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfFBMYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 08:24:49 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44705 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfFBMYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 08:24:48 -0400
Received: by mail-lf1-f67.google.com with SMTP id r15so11402171lfm.11
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 05:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d9XL3Kdg/XwAAZpeQtzVh3EdhTNcfgE61MkHiEb6f6I=;
        b=eIiL2pGuoT1uPZ6iXK+26kX3ON9RbP1IPb/stloJPcBPj9Zo94HojRPxXy/OkFOiPK
         X9H9+xcdJRrG5OhcVzQf2kFWuTRAl5KXardR/13k2qRA9L3/8mMVGyJhfmvfa1CKQ5lZ
         kXMSBhJU+EcziEfH4B1bkn1X38iaVN/7RnDp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d9XL3Kdg/XwAAZpeQtzVh3EdhTNcfgE61MkHiEb6f6I=;
        b=JBydQ6LJXWN/Bmv7N5PzWMF45u+GQKnnK1sZE/RN4NrBCKbW5cqZTdzqNfVvBLMkYm
         +IM7WhjAYdP7J55QwdmUjwTh6HpDDstoJIdw3khWLQ/hBPgtDGQszl0vkn3mesRVN7mS
         STmHH8NJai/yWTy11LUg0WizXCytdjmrV4u3MwZLRU/biDeqA78tZEXSUcDBa+X2OUcz
         JUyq1WDkdiHEmRpQ0udhJaqK/nbPDWVcNs0Yt9UbHj8ygNhNYJPoylfgcZDoqaNbwOLS
         0uJYSDD97w3QBx1O0e/Cx+yrGy8QkSVG9miJGyJzQnfE865J2ODGku7+yHoW0JynQ2gC
         eIPA==
X-Gm-Message-State: APjAAAX5B1XOEGFD0snsEoaBRta7I3Mxm63CCX6f4oiWa49TgnPfsF71
        By6kfTVxPKoKba0ef7Ev1wzic2e/OtQDlFShnYA2Qw==
X-Google-Smtp-Source: APXvYqx4YBeHBoQTcjTH8I7UAKp3m6GHYEI6h8xOHmlpzR1QFhMBG6BANgkDDCynETKbf79fFNw+DGqbIxcWNN3SHnE=
X-Received: by 2002:ac2:4544:: with SMTP id j4mr10902247lfm.176.1559478286535;
 Sun, 02 Jun 2019 05:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190601222738.6856-1-joel@joelfernandes.org> <20190601222738.6856-3-joel@joelfernandes.org>
 <20190602070014.GA543@amd> <CAEXW_YT3t4Hb6wKsjXPGng+YbA5rhNRa7OSdZwdN4AKGfVkX3g@mail.gmail.com>
In-Reply-To: <CAEXW_YT3t4Hb6wKsjXPGng+YbA5rhNRa7OSdZwdN4AKGfVkX3g@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Sun, 2 Jun 2019 08:24:35 -0400
Message-ID: <CAEXW_YSM2wwah2Q7LKmUO1Dp7GG62ciQA1nZ7GLw3m6cyuXXTw@mail.gmail.com>
Subject: Re: [RFC 2/6] ipv4: add lockdep condition to fix for_each_entry
To:     Pavel Machek <pavel@denx.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Neil Brown <neilb@suse.com>, netdev <netdev@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zilstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu <rcu@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 2, 2019 at 8:20 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Sun, Jun 2, 2019 at 3:00 AM Pavel Machek <pavel@denx.de> wrote:
> >
> > On Sat 2019-06-01 18:27:34, Joel Fernandes (Google) wrote:
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> >
> > This really needs to be merged to previous patch, you can't break
> > compilation in middle of series...
> >
> > Or probably you need hlist_for_each_entry_rcu_lockdep() macro with
> > additional argument, and switch users to it.
>
> Good point. I can also just add a temporary transition macro, and then
> remove it in the last patch. That way no new macro is needed.

Actually, no. There is no compilation break so I did not follow what
you mean. The fourth argument to the hlist_for_each_entry_rcu is
optional. The only thing that happens is new lockdep warnings will
arise which later parts of the series fix by passing in that fourth
argument.
