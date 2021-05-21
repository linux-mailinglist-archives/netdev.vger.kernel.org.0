Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DB238CEBD
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhEUUTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhEUUTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 16:19:47 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0036C0613ED
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 13:18:23 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p24so30979011ejb.1
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 13:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRq3a79BTOfjNk8E8ggTZT/+wBIRKwD0NpYc594HzrI=;
        b=UH99zw+vtI7dopQApmvoMsy3tQTx8crrO5RdqATQKJeGjj9X9HW4DJr6L/KgJhmb52
         EbOrdP18PpptzmqaEHEVLWqQhtg2ig/nDIcYozVDVoiohObZZKY2YB9gIDMb0e7q4k2h
         IyQ2rdNQeDvuIuqW3YsOBLk0SDrGifHMGI8nFYhawD6A9zoZrDJzuKUgo9StDPYvvOHn
         Wc3hBFqw6dMMK+mCL3rTZ8a91vq1n7VyeMMm3rb1q0C+d+WDIMRK4GgKT2KiSDlUh0oG
         yuLQrav2371H6hx0/zqlPYxLPg3J12q4NvDSVYEZDNY2gSA8spZfahSOykEClF02T37Y
         5fZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRq3a79BTOfjNk8E8ggTZT/+wBIRKwD0NpYc594HzrI=;
        b=dSEzoxgjomBem2U8n3K9Sy9zLNVYTuvw028jrkI+2GeSjmjBvTlpiRSQ1iDZIBs5fa
         YIoWBbsImTVGff246/CqwskESp4H6WTdqyUnKOD3ovTVZ59TtQyMOlvD/VbIyj8eTiKO
         Jub2OW9hJTsrt//Ix8bUdknnSiM8bx7tNoOPilhftcPePWiTax4te/2zMlLUmAZnsdmp
         WVqS3PtZ8oyLWKY5ju3adPmqpGsuBcjZm0M9L3iF+L4Utw8qO4cAgPJ6PG0h6N9aG/Yz
         B6+cHSPuv608UK8gGvuciF8hVZamO1/roXzkGYqGte4oQv3Pcx6+TOBdoqKtwLFk+20J
         kxMQ==
X-Gm-Message-State: AOAM530xPzf074C3UWqs3/K73ogOXixjZRgUShUJ3Ex/0iu7Pl2lwJFX
        QyVMkmvSzx5MZLKj8wMT0EY6zwkNroxf+Is58d6P
X-Google-Smtp-Source: ABdhPJxLHNN51avk7YeEqYnny9tixz6B4/nVEaokiaEMktyaFuLHwTU/FmzSQ8cmk+6m7bv1Outbe1fzb6k8sZfbRLA=
X-Received: by 2002:a17:906:8389:: with SMTP id p9mr12291163ejx.106.1621628302546;
 Fri, 21 May 2021 13:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210513200807.15910-1-casey@schaufler-ca.com> <20210513200807.15910-8-casey@schaufler-ca.com>
In-Reply-To: <20210513200807.15910-8-casey@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 May 2021 16:18:11 -0400
Message-ID: <CAHC9VhR_eDyfUUH=0PyJ06R739yFJLgxGsi5i9My3PXaPEskNA@mail.gmail.com>
Subject: Re: [PATCH v26 07/25] LSM: Use lsmblob in security_secctx_to_secid
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 4:16 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Change the security_secctx_to_secid interface to use a lsmblob
> structure in place of the single u32 secid in support of
> module stacking. Change its callers to do the same.
>
> The security module hook is unchanged, still passing back a secid.
> The infrastructure passes the correct entry from the lsmblob.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> Cc: netfilter-devel@vger.kernel.org
> To: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/linux/security.h          | 26 ++++++++++++++++++--
>  kernel/cred.c                     |  4 +---
>  net/netfilter/nft_meta.c          | 10 ++++----
>  net/netfilter/xt_SECMARK.c        |  7 +++++-
>  net/netlabel/netlabel_unlabeled.c | 23 +++++++++++-------
>  security/security.c               | 40 ++++++++++++++++++++++++++-----
>  6 files changed, 85 insertions(+), 25 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>


--
paul moore
www.paul-moore.com
