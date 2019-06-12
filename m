Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E241946
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 02:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392179AbfFLAI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 20:08:56 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34123 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392154AbfFLAIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 20:08:51 -0400
Received: by mail-lf1-f66.google.com with SMTP id y198so10647457lfa.1
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 17:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7bjlWA9RPjCrQknFfrxGmOZfe86lgEMXjZF4z0CIJc=;
        b=RWoo/BcyNh2oah4VXyI3kIfesyZEuxPtxc5DJD8ctRuMv6Qi6p8vz4Gx+1+B40AY4N
         9yFbeKUVmaSzdACCjyPiayJ713BXZR2wZL68Q2X6uBXdh/5iVjegCGmzBSYsl0uPLt5H
         zqW5Fzj1Z3xmwcCm2FT38hm5jvIYqoUDt/zeCZsET0ZDgWVY1lDwnSkL9f771ggVhQVS
         FUgf7CtH9AsJtcrBNIVpxDl+mQwlgoO+CFyzu/q6FUWJMq6Hg6ranPaLiqO3DHb1mcpW
         wCotrsWdfrMqcDteye8vRP6TXRfNT4g6bBhoyxpdZjMAvwgDuQPxbvyzrtKetr81xto9
         bMEQ==
X-Gm-Message-State: APjAAAWWmY3w8qz4lxi8tf7L9P+whJSuNkF2+Oaiz0lEiX3c0t0QJ+9x
        IR1ps5JCstaWe8Xe9ki5SQBJvxUyYM3rmUrPKP22dHf+DDs=
X-Google-Smtp-Source: APXvYqxFzgjcCWfgMQCGnFILHZZZFt+K2PbIk6ee1UmnlWOWCRs6XovMn177R/Z1IbC6Jj1CsbPXegUVXlXEWHtGkDc=
X-Received: by 2002:a19:ed07:: with SMTP id y7mr41426226lfy.56.1560298129355;
 Tue, 11 Jun 2019 17:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190608125019.417-1-mcroce@redhat.com> <20190609.195742.739339469351067643.davem@davemloft.net>
 <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org>
In-Reply-To: <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 12 Jun 2019 02:08:13 +0200
Message-ID: <CAGnkfhyS15NPEO2ygkjazECULtUDkJgPk8wCYFhA9zL2+w27pg@mail.gmail.com>
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 1:07 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 6/9/19 7:57 PM, David Miller wrote:
> > From: Matteo Croce <mcroce@redhat.com>
> > Date: Sat,  8 Jun 2019 14:50:19 +0200
> >
> >> MPLS routing code relies on sysctl to work, so let it select PROC_SYSCTL.
> >>
> >> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> >> Suggested-by: David Ahern <dsahern@gmail.com>
> >> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> >
> > Applied, thanks.
> >
>
> This patch causes build errors when
> # CONFIG_PROC_FS is not set
> because PROC_SYSCTL depends on PROC_FS.  The build errors are not
> in fs/proc/ but in other places in the kernel that never expect to see
> PROC_FS not set but PROC_SYSCTL=y.
>

Hi,

Maybe I'm missing something, if PROC_SYSCTL depends on PROC_FS, how is
possible to have PROC_FS not set but PROC_SYSCTL=y?
I tried it by manually editing .config. but make oldconfig warns:

WARNING: unmet direct dependencies detected for PROC_SYSCTL
  Depends on [n]: PROC_FS [=n]
  Selected by [m]:
  - MPLS_ROUTING [=m] && NET [=y] && MPLS [=y] && (NET_IP_TUNNEL [=n]
|| NET_IP_TUNNEL [=n]=n)
*
* Restart config...
*
*
* Configure standard kernel features (expert users)
*
Configure standard kernel features (expert users) (EXPERT) [Y/?] y
  Multiple users, groups and capabilities support (MULTIUSER) [Y/n/?] y
  sgetmask/ssetmask syscalls support (SGETMASK_SYSCALL) [N/y/?] n
  Sysfs syscall support (SYSFS_SYSCALL) [N/y/?] n
  Sysctl syscall support (SYSCTL_SYSCALL) [N/y/?] (NEW)

Regards,
-- 
Matteo Croce
per aspera ad upstream
