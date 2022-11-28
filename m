Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5977C63B11D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiK1SVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbiK1SUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:20:42 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F642F011
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:07:28 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id e18so6580167qvs.1
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qOn1PUQxMJCGp3yaVSqPelmstrqLulCIcemPhpNVzdU=;
        b=4tQKhAmlgqJFeuomcyGn+GyBJTF3TXNZND3NJQrXoNmD8007Bxyc2BZx8oFt4hfIHz
         DcHStdfL2bgNWjZTK0ib7Ohf9zqFJ+82s5fozbOWW3QWW289UEPRstHix3b0fcK1+fOF
         ud9ZTqyADxWT2iqEUic/48O1fS33VMxPFrU3i1iO79Mwue4ofOjSA5Yhg7qSYgKtqIYq
         c0XG+rJLlfayL++XpOTdm2AUjwy3zr8n5NSnhkwYqQPKPXDvpOjCuAvDzEVYTP13jtUi
         c80FdjP5USS2wz5z/YixX3LluJBQGexKDWu0K9Qraubay+EYw+V5uZ1Iy3idEWE+bCZM
         Fl8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOn1PUQxMJCGp3yaVSqPelmstrqLulCIcemPhpNVzdU=;
        b=FnxbAvdzaOqAKD3EYKNQQRhFXp1dtgiihwzH7g5UBCUq2JuT5RWvo8soVFqCIEyvgG
         A7+0v4Nm4QufYPMJBi2riMC7ZvbHQVpFSqM+5W4yrC08CxM57emwIec91ZeIcWY7RMdR
         pEN/2CqdEeTYBha5kVH2EhYf4CXNrufQq3SjqwUSMkVx/lVOCVaBh5nOkidgJIWwNfOn
         dJeqqvqcTpO35jWuczgEAKbm7i63riv6UA9Utp8lS7k2a1db+zqEFuzuvKregPaQ7O8I
         A326fcjyObUZkMHALqrKifEV/i5beDlZknLQVnQ1wu2fPN1hEsbCmAcg11nnf8tpceLY
         i3uQ==
X-Gm-Message-State: ANoB5plZa0SWGf9OcHlPYL3FuRpeJRbJQALw0Jm6ZBMI9uK1d0ZD9Plr
        kLnAEo1fvle4I7ODA9IihokBlw==
X-Google-Smtp-Source: AA0mqf6DaYR4aiOKw2PMYmb+XewvGkHvB6VF27wWN2x2o6DHCI1w5vwLSnOS5O+2XZOdfSZK+r2GVg==
X-Received: by 2002:a0c:ff28:0:b0:4b8:6953:aed6 with SMTP id x8-20020a0cff28000000b004b86953aed6mr34287361qvt.47.1669658847054;
        Mon, 28 Nov 2022 10:07:27 -0800 (PST)
Received: from localhost (2603-7000-0c01-2716-9175-2920-760a-79fa.res6.spectrum.com. [2603:7000:c01:2716:9175:2920:760a:79fa])
        by smtp.gmail.com with ESMTPSA id u19-20020a37ab13000000b006e99290e83fsm8607554qke.107.2022.11.28.10.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 10:07:26 -0800 (PST)
Date:   Mon, 28 Nov 2022 13:07:25 -0500
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Message-ID: <Y4T43Tc54vlKjTN0@cmpxchg.org>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org>
 <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 05:28:24PM -0800, Ivan Babrou wrote:
> On Tue, Nov 22, 2022 at 2:11 PM Ivan Babrou <ivan@cloudflare.com> wrote:
> >
> > On Tue, Nov 22, 2022 at 12:05 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > >
> > > On Mon, Nov 21, 2022 at 04:53:43PM -0800, Ivan Babrou wrote:
> > > > Hello,
> > > >
> > > > We have observed a negative TCP throughput behavior from the following commit:
> > > >
> > > > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> > > >
> > > > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> > > >
> > > > The crux of the issue is that in some cases with swap present the
> > > > workload can be unfairly throttled in terms of TCP throughput.
> > >
> > > Thanks for the detailed analysis, Ivan.
> > >
> > > Originally, we pushed back on sockets only when regular page reclaim
> > > had completely failed and we were about to OOM. This patch was an
> > > attempt to be smarter about it and equalize pressure more smoothly
> > > between socket memory, file cache, anonymous pages.
> > >
> > > After a recent discussion with Shakeel, I'm no longer quite sure the
> > > kernel is the right place to attempt this sort of balancing. It kind
> > > of depends on the workload which type of memory is more imporant. And
> > > your report shows that vmpressure is a flawed mechanism to implement
> > > this, anyway.
> > >
> > > So I'm thinking we should delete the vmpressure thing, and go back to
> > > socket throttling only if an OOM is imminent. This is in line with
> > > what we do at the system level: sockets get throttled only after
> > > reclaim fails and we hit hard limits. It's then up to the users and
> > > sysadmin to allocate a reasonable amount of buffers given the overall
> > > memory budget.
> > >
> > > Cgroup accounting, limiting and OOM enforcement is still there for the
> > > socket buffers, so misbehaving groups will be contained either way.
> > >
> > > What do you think? Something like the below patch?
> >
> > The idea sounds very reasonable to me. I can't really speak for the
> > patch contents with any sort of authority, but it looks ok to my
> > non-expert eyes.
> >
> > There were some conflicts when cherry-picking this into v5.15. I think
> > the only real one was for the "!sc->proactive" condition not being
> > present there. For the rest I just accepted the incoming change.
> >
> > I'm going to be away from my work computer until December 5th, but
> > I'll try to expedite my backported patch to a production machine today
> > to confirm that it makes the difference. If I can get some approvals
> > on my internal PRs, I should be able to provide the results by EOD
> > tomorrow.
> 
> I tried the patch and something isn't right here.

Thanks for giving it a sping.

> With the patch applied I'm capped at ~120MB/s, which is a symptom of a
> clamped window.
> 
> I can't find any sockets with memcg->socket_pressure = 1, but at the
> same time I only see the following rcv_ssthresh assigned to sockets:

Hm, I don't see how socket accounting would alter the network behavior
other than through socket_pressure=1.

How do you look for that flag? If you haven't yet done something
comparable, can you try with tracing to rule out sampling errors?

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 066166aebbef..134b623bee6a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7211,6 +7211,7 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 		goto success;
 	}
 	memcg->socket_pressure = 1;
+	trace_printk("skmem charge failed nr_pages=%u gfp=%pGg\n", nr_pages, &gfp_mask);
 	if (gfp_mask & __GFP_NOFAIL) {
 		try_charge(memcg, gfp_mask, nr_pages);
 		goto success;
