Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B0743B082
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhJZKxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhJZKxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:53:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C989C061745;
        Tue, 26 Oct 2021 03:51:07 -0700 (PDT)
Date:   Tue, 26 Oct 2021 12:51:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1635245465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YR554zZNX+8KqrAZj/mvDyDMz4vqSs1+lugDdR5VM9o=;
        b=EqKd9SIGW+8KPrTEN9KdzL/ayXZncODZUFKi8XacggL2s/HIYgtCPjkZz2dfkaceEHKInl
        nJzhZZ8qLAa8WLeLTG2uUF7LfDxzSnBWI69Ltey1B4TwR5NU7ma6TADYZmYUIT9+h2LlbM
        HvmlymcQxB509oQQ8wvPq5wtCJ30ONxfyFWcLdyz1ZdwkkyZnDUA/C0ejARfxi77IkVUhy
        WKEXm/016JTbB7pjSJ0uCKevmWutL7RM/2ztYuar6eIalTapvkytH8wfW13Vdcax4GkCxI
        MsIgAgmGlA86159eRNsFqi05Gc4XKURSu4S2whv+Fw3f7ii61OVgkKiXmz2IHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1635245465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YR554zZNX+8KqrAZj/mvDyDMz4vqSs1+lugDdR5VM9o=;
        b=i5ZBkH/6gh1/sfXgbDyOdY4YFPeYExSuuQCDhYHpZ93zDdR5rOCv8SkT7yoibP3m+VG345
        FQQ/Y9aTa9tHxNCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Denis Kirjanov <dkirjanov@suse.de>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v3] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
Message-ID: <20211026105104.vhfxrwisqcbvsxiq@linutronix.de>
References: <20211026100711.nalhttf6mbe6sudx@linutronix.de>
 <3bf1e148-14fc-98f6-5319-78046a7b9565@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3bf1e148-14fc-98f6-5319-78046a7b9565@suse.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-26 13:42:24 [+0300], Denis Kirjanov wrote:
> > diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
> > index 72de08ef8335e..1073c76d05c45 100644
> > --- a/net/sched/sch_gred.c
> > +++ b/net/sched/sch_gred.c
> > @@ -311,42 +312,43 @@ static void gred_offload(struct Qdisc *sch, enum tc_gred_command command)
> >   {
> >   	struct gred_sched *table = qdisc_priv(sch);
> >   	struct net_device *dev = qdisc_dev(sch);
> > -	struct tc_gred_qopt_offload opt = {
> > -		.command	= command,
> > -		.handle		= sch->handle,
> > -		.parent		= sch->parent,
> > -	};
> > +	struct tc_gred_qopt_offload *opt = table->opt;
> >   	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
> >   		return;
> > +	memset(opt, 0, sizeof(*opt));
> 
> It's zeroed in kzalloc()

but it is not limited to a single invocation?

Sebastian
