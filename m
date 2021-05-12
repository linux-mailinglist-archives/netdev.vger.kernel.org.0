Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A808E37BE1C
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 15:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhELNXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 09:23:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhELNW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 09:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620825711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dtvrIv0gd9IsJeuZT9VIJXOOFa9yzPvKusGPJfLQ7f4=;
        b=A9HOWi9KmzFFBTNqyY4ed5tNzt6Z/G0TAo1zXJQ+9ORQz1SNXSd6gmCqma9xc6OSYNDqmh
        9QWsaMp1odA6cfPYSDGeRB3et+tqYOA0Ql6EFRefzo9/O0Ge/5sDJ8igY2qZ3+vNqXLV+F
        YeaGoGlJv7AFYoY30h7ZGxBft5bGNvY=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-bZouRFW1Ou6uEZ_csDtunQ-1; Wed, 12 May 2021 09:21:49 -0400
X-MC-Unique: bZouRFW1Ou6uEZ_csDtunQ-1
Received: by mail-yb1-f198.google.com with SMTP id l9-20020a5b0b890000b02904f7fb53ca12so28106048ybq.15
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 06:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dtvrIv0gd9IsJeuZT9VIJXOOFa9yzPvKusGPJfLQ7f4=;
        b=QeDFNOpA4CtFap5y8Q2xKVRipZ4Z+qV3Ino2UGHYXZnRtq4ctpCPWY84UQuiCfn4RH
         RZAdpVrjKxAlQV0ah85iqWO+fx9k0iGDLpAfookvajPVTnsqeJeHKxmci+mQkejg50Nx
         VrBcs87Utwn+T63yLd+FsbNIaIZnvMjF4M1ojH1FexG7O1jI43HvYPLLrt5QqNdvM9q7
         o5zjjloVu3qA4Jicu31e9DziwLeJ1g7CXUY86JGTFmkPj4au7Sidvwepv7b+5/Am2YK4
         fh/CX3Bd7WH88JtyVNzr30abSIVOtWXAzRlq7Z9rb3BpGcQq82Ufhqkq4bdI/1B69Jj4
         mDHQ==
X-Gm-Message-State: AOAM533PsCwYAQnk/ZYmw2dH8krmw4YI72sucg02GONQB6s7kP45ISKB
        VgVm2+NA2iahl8+LG7qHwHemXbYQGColDMg/+0ybL9eHhj/khovhMXzyrhWcedAx9N+T/jONLQU
        4MPVz1//oYvCkJC5H243aVRwsOsU3VOfF
X-Received: by 2002:a25:6983:: with SMTP id e125mr46782761ybc.81.1620825709174;
        Wed, 12 May 2021 06:21:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmv2Qjn6VYEo9c/oXPEmu6i04CA+M1aunHQiWM6u48mJ31LcpQnTbka787MtlSpRVc8GFLI9xcdcVeHkvyMsg=
X-Received: by 2002:a25:6983:: with SMTP id e125mr46782731ybc.81.1620825708981;
 Wed, 12 May 2021 06:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210507114048.138933-1-omosnace@redhat.com> <a8d138a6-1d34-1457-9266-4abeddb6fdba@schaufler-ca.com>
In-Reply-To: <a8d138a6-1d34-1457-9266-4abeddb6fdba@schaufler-ca.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 12 May 2021 15:21:37 +0200
Message-ID: <CAFqZXNtr1YjzRg7fTm+j=0oZF+7C5xEu5J0mCZynP-dgEzvyUg@mail.gmail.com>
Subject: Re: [PATCH] lockdown,selinux: fix bogus SELinux lockdown permission checks
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 8, 2021 at 12:17 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 5/7/2021 4:40 AM, Ondrej Mosnacek wrote:
> > Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> > lockdown") added an implementation of the locked_down LSM hook to
> > SELinux, with the aim to restrict which domains are allowed to perform
> > operations that would breach lockdown.
> >
> > However, in several places the security_locked_down() hook is called in
> > situations where the current task isn't doing any action that would
> > directly breach lockdown, leading to SELinux checks that are basically
> > bogus.
> >
> > Since in most of these situations converting the callers such that
> > security_locked_down() is called in a context where the current task
> > would be meaningful for SELinux is impossible or very non-trivial (and
> > could lead to TOCTOU issues for the classic Lockdown LSM
> > implementation), fix this by adding a separate hook
> > security_locked_down_globally()
>
> This is a poor solution to the stated problem. Rather than adding
> a new hook you should add the task as a parameter to the existing hook
> and let the security modules do as they will based on its value.
> If the caller does not have an appropriate task it should pass NULL.
> The lockdown LSM can ignore the task value and SELinux can make its
> own decision based on the task value passed.

The problem with that approach is that all callers would then need to
be updated and I intended to keep the patch small as I'd like it to go
to stable kernels as well.

But it does seem to be a better long-term solution - would it work for
you (and whichever maintainer would be taking the patch(es)) if I just
added another patch that refactors it to use the task parameter?

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

