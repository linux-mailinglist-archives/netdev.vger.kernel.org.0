Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC75D5ADCE
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 01:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfF2XsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 19:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfF2XsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 19:48:06 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1688D21773
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 23:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561852085;
        bh=/Z9JxHM/U8pOR2q9Q111pLKFbaSLjxZI1rBO4UNXjGs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DhmTf41Y2AuaabsMozTRzHIZvaRyAuQnNAVsjlAdX17h5VfZCAAt73CqYND0OuWLT
         Lq4O6ZKNaaR2s6Xde+Jhb4vpZSxaF7h0FlO1NZ6Zu41SuIQF4k0VerykHuEEWED+Xa
         1d9VWfWJonrnFa53poGTxTuBHSXOqSfoVPIl25NE=
Received: by mail-wm1-f48.google.com with SMTP id x15so12387089wmj.3
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 16:48:05 -0700 (PDT)
X-Gm-Message-State: APjAAAUx8TyFBFoHmrmLeO59/U30ivDy11GLtoHpDdMSLxj0/Ul16sLN
        L2QLROomyol3I0cVtXadu9FoutSprHJAEaX2B8kuHw==
X-Google-Smtp-Source: APXvYqwPvmJHkMRl329cQ9T4D/2dboMc6Y5O8FWBmYdZc9xtZrbDnQPOXbb072fAhtMQs+QCOGRqxnm2IlTbXokTVhU=
X-Received: by 2002:a1c:1a56:: with SMTP id a83mr12548344wma.161.1561852083701;
 Sat, 29 Jun 2019 16:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-25-matthewgarrett@google.com> <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
 <alpine.LRH.2.21.1906270621080.28132@namei.org> <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
 <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov> <CALCETrXwt43w6rQY6zt0J_3HOaad=+E5PushJNdSOZDBuaYV+Q@mail.gmail.com>
 <CACdnJuuy7-tkj86njAqtdJ3dUMu-2T8a2y8DC3fMKBK0z9J6ag@mail.gmail.com>
In-Reply-To: <CACdnJuuy7-tkj86njAqtdJ3dUMu-2T8a2y8DC3fMKBK0z9J6ag@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 29 Jun 2019 16:47:52 -0700
X-Gmail-Original-Message-ID: <CALCETrUzGfB2EO0eUpan3b4qyUPmkTZ-7dMuLqu_bmnY-ry=SA@mail.gmail.com>
Message-ID: <CALCETrUzGfB2EO0eUpan3b4qyUPmkTZ-7dMuLqu_bmnY-ry=SA@mail.gmail.com>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
To:     Matthew Garrett <mjg59@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        linux-security@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Chun-Yi Lee <jlee@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 11:47 AM Matthew Garrett <mjg59@google.com> wrote:
>
> On Thu, Jun 27, 2019 at 4:27 PM Andy Lutomirski <luto@kernel.org> wrote:
> > They're really quite similar in my mind.  Certainly some things in the
> > "integrity" category give absolutely trivial control over the kernel
> > (e.g. modules) while others make it quite challenging (ioperm), but
> > the end result is very similar.  And quite a few "confidentiality"
> > things genuinely do allow all kernel memory to be read.
> >
> > I agree that finer-grained distinctions could be useful. My concern is
> > that it's a tradeoff, and the other end of the tradeoff is an ABI
> > stability issue.  If someone decides down the road that some feature
> > that is currently "integrity" can be split into a narrow "integrity"
> > feature and a "confidentiality" feature then, if the user policy knows
> > about the individual features, there's a risk of breaking people's
> > systems.  If we keep the fine-grained control, do we have a clear
> > compatibility story?
>
> My preference right now is to retain the fine-grained aspect of things
> in the internal API, simply because it'll be more annoying to add it
> back later if we want to. I don't want to expose it via the Lockdown
> user facing API for the reasons you've described, but it's not
> impossible that another LSM would find a way to do this reasonably.
> Does it seem reasonable to punt this discussion out to the point where
> another LSM tries to do something with this information, based on the
> implementation they're attempting?

I think I can get behind this, as long as it's clear to LSM authors
that this list is only a little bit stable.  I can certainly see the
use for the fine-grained info being available for auditing.
