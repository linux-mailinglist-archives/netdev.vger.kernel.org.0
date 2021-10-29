Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9DB43FE7E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 16:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhJ2Ofi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 10:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhJ2Ofh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 10:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 549AA60FC1;
        Fri, 29 Oct 2021 14:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635517988;
        bh=fgSuI5rKuSuOKIq2/2tJ97d9GRuTfwvZEzhk7D6Ml4g=;
        h=In-Reply-To:References:Cc:To:From:Subject:Date:From;
        b=ZvEXjVYPM2JqCOXSPQwkmWTYlJe8oGXP9cTdZmqC7IHaPpE9+X6nko8XQ/llhpRTt
         oTdaYM8XAAWJMnU/CNPGk6swXwU3Gk063R6qQewB5OM3DTDh2S+OJ/2DTHFGj4vqTk
         V5LaxmUSX9UUA0TX9uhPKv30k/j3QqD7jspDFxvBMNN4p8b9YtmIKHg1aedGUP9MM9
         aHPJzjj2gCZ1wQ4jCfka7C4bMy45vB0g2T2xnxsM99/FxidgzHk2q4OS4uGL3SqsLI
         uozbjzTo48+VF0bfOMmJlIhiazXU61ZRqr/ru0SRKCa4rJlvc1cv50Nw2gwLzV/bTS
         czAmkcw9spBTg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
Cc:     pabeni@redhat.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org, mhocko@suse.com
To:     davem@davemloft.net, kuba@kernel.org
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [RFC PATCH net-next 0/9] Userspace spinning on net-sysfs access
Message-ID: <163551798537.3523.2552384180016058127@kwain>
Date:   Fri, 29 Oct 2021 16:33:05 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the approach taken in this thread not going too well[1], what next?
I think we should discuss other possibilities and gather some ideas.
Below are some early thoughts, that might not be acceptable.

1) Making an rtnl_lock helper that returns when needed

The idea would be to replace rtnl_trylock/restart_syscall by this
helper, which would try to grab the rtnl lock and return when needed.
Something like the following:

  static rtnl_lock_ifalive(const struct net_device *dev)
  {
          while (!rtnl_trylock()) {
                  if (!dev_isalive(dev))
                          return -EINVAL;

                  /* Special case for queue files */
                  if (dev->drain_sysfs_queues)
                          return restart_syscall();

                  /* something not to have the CPU spinning */
          }
  }

One way not to have the CPU spinning is to sleep, let's say with
`usleep_range(500, 1000);` (range to be defined properly). The
disadvantage is on net device unregistration as we might need to wait
for all those loops to return first. (It's a trade-off though, we're not
restarting syscalls over and over in other situations). Or would there
be something better?

Possible improvements:
- Add an overall timeout and restart the syscall if we hit it, to have
  an upper bound.
- Make it interruptible, check for need_resched, etc.

Note that this approach could work for sysctl files as well; looping
over all devices in a netns to make the checks.

2) Interrupt rtnl_lock when in the unregistration paths

I'm wondering if using mutex_lock_interruptible in problematic areas
(sysfs, sysctl), keeping track of their tasks and interrupting them in
the unregistration paths would work and be acceptable. On paper this
looks like a solution with not much overhead and not too invasive to
implement. But is it acceptable? (Are there some side effects we really
don't want?).

Note that this would need some thinking to make it safe against sysfs
accesses between the tasks interruption and the sysfs files draining
(refcount? another lock?).

3) Other ideas?

Also, I'm not sure about the -rt implications of all the above.

Thanks,
Antoine

[1] https://lore.kernel.org/netdev/163549826664.3523.4140191764737040064@kw=
ain/
