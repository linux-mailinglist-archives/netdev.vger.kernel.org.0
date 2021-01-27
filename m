Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CE2306423
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 20:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344443AbhA0Tc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 14:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344393AbhA0TcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 14:32:22 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42D2C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:31:41 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id v15so492167ljk.13
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZJB6pzhcxR6RIOhk+W4vBLAOQOY6A+IbRkTJX3GrSIA=;
        b=Nex7m0nPT6ikFYD0UDxgXryCJyYTx+pRUl8n/I+/+QgVAzM5sX/Iufo8IZe70BES4A
         PxumGwRUK+eKwrok3peAydYv34EWMMQMd6k8vlFvyDIPohc+dGl9OdT0wXxeuKjCUlu3
         DoAjRpEayelexJA+o2u5g1eysr8elGHigTn34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZJB6pzhcxR6RIOhk+W4vBLAOQOY6A+IbRkTJX3GrSIA=;
        b=UzVGDW44lWjUonnGsS/gvUgfRZjLANXzI+/+GFCYsEIY0Mt330M3rJQd8K6fo8zPbX
         cImeTgepUGXx+wXw6149puknPjTYASszft0yDp4Qif6q9Srx2ANQsXVweF0U20O1pT6i
         iDC3Y3yBl7Vuu0DoKO7gQFwl25N5KbWuyoL/qLUYm9vA5/PWb1zqIqrLsMiMElhM3+yh
         +mix8jgo0WPzsOT7ghC2F2nl+SH9FsgDRaGu1dkF/KtykwTmsTI5MDDQxLvsBpujJjAv
         Y2slo+rswAcAEN0W4VjTtXk8XYDKJ4jqLWsVuFpMvnzsEg7QFh/Xe7gtL5oDrLAKU6RT
         ejNg==
X-Gm-Message-State: AOAM532sZGSE9Dsqtgeaf1EEvcuHAqjky7ZwyDUwFA+ykvR9vgT7HA1M
        W5t+L/tngjA82K9Htvu64x3wsIRIMIosBA==
X-Google-Smtp-Source: ABdhPJx0H2uxokVqNIICbbCztipr5OZaDzPAyW1JbvxtSIhFEFLYFodDe4akmPWWcxxkKqiBAptpUg==
X-Received: by 2002:a2e:7a05:: with SMTP id v5mr6226181ljc.402.1611775899997;
        Wed, 27 Jan 2021 11:31:39 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id i2sm736186lfl.152.2021.01.27.11.31.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 11:31:38 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id h7so4298518lfc.6
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:31:38 -0800 (PST)
X-Received: by 2002:ac2:420a:: with SMTP id y10mr5554909lfh.377.1611775897778;
 Wed, 27 Jan 2021 11:31:37 -0800 (PST)
MIME-Version: 1.0
References: <000000000000672eda05b9e291ff@google.com>
In-Reply-To: <000000000000672eda05b9e291ff@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 27 Jan 2021 11:31:21 -0800
X-Gmail-Original-Message-ID: <CAHk-=whCX0Ab=Z2N-zuKVv7BdBZAUGgP0jQqCg+OJjHmtaOkTA@mail.gmail.com>
Message-ID: <CAHk-=whCX0Ab=Z2N-zuKVv7BdBZAUGgP0jQqCg+OJjHmtaOkTA@mail.gmail.com>
Subject: Re: KASAN: invalid-free in p9_client_create (2)
To:     syzbot <syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        David Miller <davem@davemloft.net>, ericvh@gmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lucho@ionkov.net, Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        v9fs-developer@lists.sourceforge.net, wanghai38@huawei.com,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Participants list changed - syzbot thought this was networking and
p9, but it really looks entirely like a slub internal bug. I left the
innocent people on the list just to let them know they are innocent ]

On Wed, Jan 27, 2021 at 6:27 AM syzbot
<syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com> wrote:
>
> The issue was bisected to:
>
> commit dde3c6b72a16c2db826f54b2d49bdea26c3534a2
> Author: Wang Hai <wanghai38@huawei.com>
> Date:   Wed Jun 3 22:56:21 2020 +0000
>
>     mm/slub: fix a memory leak in sysfs_slab_add()
>
> BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3142 [inline]
> BUG: KASAN: double-free or invalid-free in kmem_cache_free+0x82/0x350 mm/slub.c:3158

The p9 part of this bug report seems to be a red herring.

The problem looks like it's simply the kmem_cache failure case, ie:

 - mm/slab_common.c: create_cache(): if the __kmem_cache_create()
fails, it does:

        out_free_cache:
                kmem_cache_free(kmem_cache, s);

 - but __kmem_cache_create() - at least for slub() - will have done

        sysfs_slab_add(s) .. fails ..
            -> kobject_del(&s->kobj); .. which frees s ...

so the networking and p9 are fine, and the only reason p9 shows up in
the trace is that apparently it causes that failure in
kobject_init_and_add() for whatever reason, and that then exposes the
problem.

So the added kobject_put() really looks buggy in this situation, and
the memory leak that that commit dde3c6b72a16 ("mm/slub: fix a memory
leak in sysfs_slab_add()") fixes is now a double free.

And no, I don't think you can just remove the kmem_cache_free() in
create_cache(), because _other_ error cases of __kmem_cache_create()
do not free this.

Wang Hai - comments? I'm inclined to revert that commit for now unless
somebody can come up with a proper fix..

              Linus
