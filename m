Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7445525EC2F
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 04:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIFCqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 22:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728662AbgIFCqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 22:46:13 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389C5C061755
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 19:46:11 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id q21so9492260edv.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 19:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fZqDWW5vNAoJJAbX0kuyb7Ud5+qbw+9T/B7X+7yryh8=;
        b=DmhPGb7AyMoKvO+EZ6qSA6y0mbdaxr6Hf+3iisa/FrUxspdnpBXYMQLIrBlGXFwX/I
         msIH1xrcZozf6lMLykq8tZh1ognEbytLSE67zNmMiBFjNvGt923/zAuglw0hFw87dbRc
         A1nyUIALkitD3VJq/qWFJuvK+ZkX1gzGCVZ+BrlG+poI90JAyIDZaw4uM0Ck9giFZ+Gg
         F6AfmR4omPmNAUbd9YHfF7akFNYhRd5gAvcLH1JH7gjnFQE9VKaNDBHNXkVikQ+++umT
         2W6r1to8acOWY7IG4HMbK5dMFncajEXDc1z81RDr8E9youj5oQovA0CzpF8j+MGWg1Y0
         VZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fZqDWW5vNAoJJAbX0kuyb7Ud5+qbw+9T/B7X+7yryh8=;
        b=fEGeOb4KwMEMfU/qN9FBp6aD538Kkzwspm8gEjNs9iEAqHwvfAvRkPF0yL/MUYhAJK
         C/LoipDeMwTzfyqwHZgd1r68sN58Ci025lUYPJ7bTAMdF5gd9Cwg/YbhwgcBi9tLZd0z
         pTdmyxdaGzxhg26ZmRD4GXlxSfZlJ8/IuBbx74XkN1wQKSSeXi+8jxOj0CpXEizVkNmY
         sULmjgq4ySUx0O06rKTuoynraXuX/BK1DuRUEscAD4VTyM4Ja9K8G7tWIk0mWJhIDld1
         CljGMkFlEEMLJoTLToJvRlcpKukBPjm8u05FX3qHz2AafiX7niJDQwuVYrtDoiH/phKq
         6CaQ==
X-Gm-Message-State: AOAM531Mv7OuTeGr6IYjs9TDMWPdVyJ26lT98Hs7izamdWLA2Z7hJi+9
        51dhz6FmcQFq6P+Q+1l7VXE7pf1GVvXtdp426F68
X-Google-Smtp-Source: ABdhPJwEnqc7V1NRJVUfKvCRxDcLWxHKwC04LW/AslJ8t3tHT+VIhkM1GtvHSi9RzbnnsIGUXVyYSmBJ5klezGQfiL8=
X-Received: by 2002:aa7:ce97:: with SMTP id y23mr16089395edv.128.1599360369151;
 Sat, 05 Sep 2020 19:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200826145247.10029-1-casey@schaufler-ca.com> <20200826145247.10029-15-casey@schaufler-ca.com>
In-Reply-To: <20200826145247.10029-15-casey@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 5 Sep 2020 22:45:57 -0400
Message-ID: <CAHC9VhQmEgNgsXmk8MeMsfkvZ82GuHBguoBvG5WR9mcoztBDOA@mail.gmail.com>
Subject: Re: [PATCH v20 14/23] LSM: Ensure the correct LSM context releaser
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 11:16 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Add a new lsmcontext data structure to hold all the information
> about a "security context", including the string, its size and
> which LSM allocated the string. The allocation information is
> necessary because LSMs have different policies regarding the
> lifecycle of these strings. SELinux allocates and destroys
> them on each use, whereas Smack provides a pointer to an entry
> in a list that never goes away.
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: John Johansen <john.johansen@canonical.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: linux-integrity@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  drivers/android/binder.c                | 10 ++++---
>  fs/ceph/xattr.c                         |  6 ++++-
>  fs/nfs/nfs4proc.c                       |  8 ++++--
>  fs/nfsd/nfs4xdr.c                       |  7 +++--
>  include/linux/security.h                | 35 +++++++++++++++++++++++--
>  include/net/scm.h                       |  5 +++-
>  kernel/audit.c                          | 14 +++++++---
>  kernel/auditsc.c                        | 12 ++++++---
>  net/ipv4/ip_sockglue.c                  |  4 ++-
>  net/netfilter/nf_conntrack_netlink.c    |  4 ++-
>  net/netfilter/nf_conntrack_standalone.c |  4 ++-
>  net/netfilter/nfnetlink_queue.c         | 13 ++++++---
>  net/netlabel/netlabel_unlabeled.c       | 19 +++++++++++---
>  net/netlabel/netlabel_user.c            |  4 ++-
>  security/security.c                     | 11 ++++----
>  15 files changed, 121 insertions(+), 35 deletions(-)

One small comment below, but otherwise ...

Acked-by: Paul Moore <paul@paul-moore.com>

> +/**
> + * lsmcontext_init - initialize an lsmcontext structure.
> + * @cp: Pointer to the context to initialize
> + * @context: Initial context, or NULL
> + * @size: Size of context, or 0
> + * @slot: Which LSM provided the context
> + *
> + * Fill in the lsmcontext from the provided information.
> + * This is a scaffolding function that will be removed when
> + * lsmcontext integration is complete.
> + */
> +static inline void lsmcontext_init(struct lsmcontext *cp, char *context,
> +                                  u32 size, int slot)
> +{
> +       cp->slot = slot;
> +       cp->context = context;
> +       cp->len = size;
> +}

Here is another case where some of the intermediate code, and perhaps
some of the final code, can probably be simplified if
lsmcontext_init() returns the lsmcontext pointer.

-- 
paul moore
www.paul-moore.com
