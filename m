Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34DC381282
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhENVEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhENVDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 17:03:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37EC660FDB;
        Fri, 14 May 2021 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621026115;
        bh=f5TkJBZqW4w49ldqu70ipX22W/ljS7yxqSr2Y/aj5Xk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pKVG+e2jbcTNwNUWOMCbcn7SRzGWrZMOWTmpgwud/miMkfLUi3maXZGHQAxJAbbeu
         YlB5Q7xeY0+mE+Rr1lmUCGY2tkqB+RkonvgeAZX/0icMCmmDh0iB0PMbHKrKSM35ds
         XrprQ5I19k9lTYuQrIiTX/9oZLGhBK8dmh2nManxxv9Xpn9TQwoFmzsfi1SZPjn7s5
         4KgqOMZMqit/WIUs6ivytIH2kitZ0v+CkNZPvxu4QBGhPIOQ+XphlSTHcLFxq2Xn6c
         wqPM1cmuSEDZrKE1AMZCqWLi3v5FCtXxSCU/0DTHO1HqFlDBZA+qv1moB/WyP0dBeK
         +PeHfK0wdqMXg==
Date:   Fri, 14 May 2021 14:01:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev
 queue mapping
Message-ID: <20210514140154.475e7f3b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87y2ch121x.fsf@vcostago-mobl2.amr.corp.intel.com>
References: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
        <20210514083226.6d3912c4@kicinski-fedora-PC1C0HJN>
        <87y2ch121x.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 13:40:58 -0700 Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > You haven't CCed anyone who worked on this Qdisc in the last 2 years :/
> > CCing them now. Comments, anyone?  
> 
> I guess I should suggest myself as maintainer, to reduce chances of this
> happening again.

Yes, please.

> > This looks like a very drastic change. Are you expecting the qdisc will
> > always be bypassed?  
> 
> Only when running in full offload mode it will be bypassed.
> 
> And it's kind of by design, in offload mode, the idea was: configure the
> netdev traffic class to queue mapping, send the schedule to the hardware
> and stay out of the way.
> 
> But as per Yannick's report, it seems that taprio doesn't stay enough
> out of the yay.
> 
> > After a 1 minute looks it seems like taprio is using device queues in
> > strict priority fashion. Maybe a different model is needed, but a qdisc
> > with:
> >
> > enqueue()
> > {
> > 	WARN_ONCE(1)
> > }
> >
> > really doesn't look right to me.  
> 
> This patch takes the "stay out of the way" to the extreme, I kind of
> like it/I am not opposed to it, if I had this idea a couple of years
> ago, perhaps I would have used this same approach.

Sorry for my ignorance, but for TXTIME is the hardware capable of
reordering or the user is supposed to know how to send packets?

My biggest problem with this patch is that unless the application is
very careful that WARN_ON_ONCE(1) will trigger. E.g. if softirq is
servicing the queue when the application sends - the qdisc will not 
be bypassed, right?

> I am now thinking if this idea locks us out of anything.
> 
> Anyway, a nicer alternative would exist if we had a way to tell the core
> "this qdisc should be bypassed" (i.e. don't call enqueue()/dequeue())
> after init() runs.

I don't think calling enqueue() and dequeue() is a problem. The problem
is that RT process does unrelated work.

> > Quoting the rest of the patch below for the benefit of those on CC.
