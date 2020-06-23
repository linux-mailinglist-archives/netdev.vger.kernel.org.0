Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64B7205A01
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733182AbgFWR40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733095AbgFWR4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:56:25 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB386C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 10:56:25 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l9so5488061ilq.12
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 10:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nRWHlVlHkqzcCUDBSwEh9bYa8CSv1evht5Bg/jRe1W8=;
        b=VRxTSHnttrPxaaN/NwFhu6w3yFNZOPLixH9Z/ZUapBWB9VYQFYr2OGgUVgC6VRc6XZ
         zY9ax7vofipVZ0funD2rGfp6/XXqQ5UwcGmtBnkGFnF11NleYEyDNe9f2uXe0vVwQj0V
         MO159Dxy+0DVG1N4id/T9ixw/uz2wxTzJVcpTINpWDDvNO3Csb3jqn3TgY+kUaS0+2pl
         F0lIGa6HSAQm+0eARx5ixeLASCjiB+OPjUPJncKKP+Wxqrdkn0OvSfw9jq+4VTWYQunV
         5qg2lFdWldAyF+I6XHWCYWcY3JTO8jTuUZG1T6OqHjCexfbLGt53kUZruJL3E5q6zSTi
         MHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nRWHlVlHkqzcCUDBSwEh9bYa8CSv1evht5Bg/jRe1W8=;
        b=JvnceqvMABUWd/esWGn2oQAmEpaSj6ZUc+UyPFXJf/YC20F3yngE6P6LGxdB207mg6
         PVaq55MT0YlvyoFhPcVQAROhbTKFlfzV4W859T7lIb6v/Fjc8TbWDzXsMjjm+C6fN6nZ
         36BXl/3FjZbReu6BBA7IOFN54GtgtsWw9VVbQbGNjpoLSDfk+UAbK7Wf0BCO9l8QrcfU
         h/ld2EP8biX143IVkMwvkRFILFBQjTmZ0GaWzmqk7G22DPr+eYWelG8yOOoN87mBRJAd
         WE1+n3dYlw1XMb2EBGfh2gYQ47aLNiE8WRyE2tuR5/3MZG1eWZY2xhxRQDLPtKwglbQf
         hMPA==
X-Gm-Message-State: AOAM532gRbsnm7WRx53Hr7HSbj0SSZNSYltjMW3wklaNu/TPU7Y5XEWf
        OslVayOXVraFQWTOX8syYG39nNxdUcwmaerL7jE=
X-Google-Smtp-Source: ABdhPJy3WpQjyqWltQkDs0SytFYtZVGXSPxEJ7BO+hb2K9rijLCWEX6w1bwtB41wM9K+KCgV8q7Wk18H39qaHmiXzJs=
X-Received: by 2002:a92:bb0b:: with SMTP id w11mr16392823ili.238.1592934985120;
 Tue, 23 Jun 2020 10:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200622203910.GE301338@carbon.dhcp.thefacebook.com> <bbcf2abd-53d8-966c-32a0-feccfdd0d7fe@windriver.com>
In-Reply-To: <bbcf2abd-53d8-966c-32a0-feccfdd0d7fe@windriver.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 23 Jun 2020 10:56:13 -0700
Message-ID: <CAM_iQpWf9s_FA6GDjpandwhmnjDbd48xSiNmA8JSP1Tt1Ap9Xw@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     "Zhang,Qiang" <qiang.zhang@windriver.com>
Cc:     Roman Gushchin <guro@fb.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Li Zefan <lizefan@huawei.com>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 1:45 AM Zhang,Qiang <qiang.zhang@windriver.com> wrote:
>
> There are some message in kernelv5.4, I don't know if it will help.
>
> demsg:
>
> cgroup: cgroup: disabling cgroup2 socket matching due to net_prio or
> net_cls activation
...
> -----------[ cut here ]-----------
> percpu ref (cgroup_bpf_release_fn) <= 0 (-12) after switching to atomic
> WARNING: CPU: 1 PID: 0 at lib/percpu-refcount.c:161
> percpu_ref_switch_to_atomic_rcu+0x12a/0x140

Yes, this proves we have the refcnt bug which my patch tries to fix.
The negative refcnt is exactly a consequence of the bug, as without
my patch we just put the refcnt without holding it first.

If you can reproduce it, please test my patch:
https://patchwork.ozlabs.org/project/netdev/patch/20200616180352.18602-1-xiyou.wangcong@gmail.com/

But, so far I still don't have a good explanation to the NULL
pointer deref. I think that one is an older bug, and we need to check
for NULL even after we fix the refcnt bug, but I do not know how it is
just exposed recently with Zefan's patch. I am still trying to find an
explanation.

Thanks!
