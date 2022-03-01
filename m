Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2734C9346
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbiCAS3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 13:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbiCAS31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 13:29:27 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1082A714;
        Tue,  1 Mar 2022 10:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4qQmMjIAiTQvnNnaC1WHCchcXF9E9dDy4G6npTea56M=; b=0NJSVp1GVv2yfmwiqsdwZ5jiXj
        RrtALBzQC6KEMXVBXGQozfl49Ir1/XaN60DX6Qh1+8DnpoSnKsBRdbr2yhsnk0dloMgw/viPciUI2
        +wdAAUwjwKKQA7aowWnivpD7Y49RzNtoT+oM/H/ClT/rgcVYrASHNoK7X6lEcms8+IQcbSIDxJ9fA
        YM0cnyFiaFxkF+MIsXpnjF2hIRfReWQTXUpZtFVwVhA9+LQhlnsel1S74Hyw8rCeVot2xGLlPYTuI
        FO2bY3CNIdvaI0H/8MBNP1fM1b3HOxTNh2VhbRuf2jqKB/m4alTTlCpMGY61KePrTEMinzrNxjRbK
        WfCOGLEQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nP7EY-000C19-Vb; Tue, 01 Mar 2022 18:28:26 +0000
Date:   Tue, 1 Mar 2022 10:28:26 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Shakeel Butt <shakeelb@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        NeilBrown <neilb@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices
Message-ID: <Yh5lyr8dJXmEoFG6@bombadil.infradead.org>
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
 <YhzeCkXEvga7+o/A@bombadil.infradead.org>
 <20220301180917.tkibx7zpcz2faoxy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301180917.tkibx7zpcz2faoxy@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 10:09:17AM -0800, Shakeel Butt wrote:
> On Mon, Feb 28, 2022 at 06:36:58AM -0800, Luis Chamberlain wrote:
> > On Mon, Feb 28, 2022 at 10:17:16AM +0300, Vasily Averin wrote:
> > > Following one-liner running inside memcg-limited container consumes
> > > huge number of host memory and can trigger global OOM.
> > >
> > > for i in `seq 1 xxx` ; do ip l a v$i type veth peer name vp$i ; done
> > >
> > > Patch accounts most part of these allocations and can protect host.
> > > ---[cut]---
> > > It is not polished, and perhaps should be splitted.
> > > obviously it affects other kind of netdevices too.
> > > Unfortunately I'm not sure that I will have enough time to handle it
> > properly
> > > and decided to publish current patch version as is.
> > > OpenVz workaround it by using per-container limit for number of
> > > available netdevices, but upstream does not have any kind of
> > > per-container configuration.
> > > ------
> 
> > Should this just be a new ucount limit on kernel/ucount.c and have veth
> > use something like inc_ucount(current_user_ns(), current_euid(),
> > UCOUNT_VETH)?
> 
> > This might be abusing ucounts though, not sure, Eric?
> 
> 
> For admins of systems running multiple workloads, there is no easy way
> to set such limits for each workload.

That's why defaults would exist. Today's ulimits IMHO are insane and
some are arbitrarily large.

> Some may genuinely need more veth
> than others.

So why not make it a high sensible but not enough to OOM a typical system?

But again, I'd like to hear whether or not a ulimit for veth is a mi-use
of ulimits or if its the right place. If it's not then perhaps the
driver can just have its own atomic max definition.

> From admin's perspective it is preferred to have minimal
> knobs to set and if these objects are charged to memcg then the memcg
> limits would limit them. There was similar situation for inotify
> instances where fs sysctl inotify/max_user_instances already limits the
> inotify instances but we memcg charged them to not worry about setting
> such limits. See ac7b79fd190b ("inotify, memcg: account inotify
> instances to kmemcg").

Yes but we want sensible defaults out of the box. What those should be
IMHO might be work which needs to be figured out well.

IMHO today's ulimits are a bit over the top today. This is off slightly
off topic but for instance play with:

git clone https://github.com/ColinIanKing/stress-ng
cd stress-ng
make -j 8
echo 0 > /proc/sys/vm/oom_dump_tasks                                            
i=1; while true; do echo "RUNNING TEST $i"; ./stress-ng --unshare 8192 --unshare-ops 10000;  sleep 1; let i=$i+1; done

If you see:

[  217.798124] cgroup: fork rejected by pids controller in
/user.slice/user-1000.slice/session-1.scope
                                                                                
Edit /usr/lib/systemd/system/user-.slice.d/10-defaults.conf to be:

[Slice]                                                                         
TasksMax=MAX_TASKS|infinity

Even though we have max_threads set to 61343, things ulimits have a
different limit set, and what this means is the above can end up easily
creating over 1048576 (17 times max_threads) threads all eagerly doing
nothing to just exit, essentially allowing a sort of fork bomb on exit.
Your system may or not fall to its knees.

  Luis
