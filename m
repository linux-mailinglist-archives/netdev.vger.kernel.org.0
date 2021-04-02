Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02DC352FB3
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhDBT0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 15:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhDBT0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 15:26:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3018600D3;
        Fri,  2 Apr 2021 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617391561;
        bh=Ur/RPoLJAFNQ/xo2Az7wZnPpTvyn9qFxiOG6Tvgto4g=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=lrH9MHjapHs5Z13vdaZwdG2XD8TgjL8lBjyuLrGWX8mgyfBHW1ok+EJqooW/fN6M+
         lvaV4XoalHG2L8tELTgrfSERJfwR6YSD+mNiI0XqWWig2I3GLvb1aEhTqrx5wgwt24
         QBb6m6+tOXz0RT2a3NINiEa9AgtnD/FYsYlvLbYx6Pwq4X5rXxz3/Vwnr2oVzXUPIi
         zAvxLWe9kaeJVsyrDAE2NdjPfIxOeeExM9aaCSFYpDvgtejq+31/aNrtpYZ24ExIgD
         yuwvo73gDOCvptd18e3AESfzz2eSgY3zpW7BhI+5Xc3qPp+1+sT6oXPxWsJPna5DQT
         20XxkPm2Cd6vA==
Date:   Fri, 2 Apr 2021 21:25:56 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
In-Reply-To: <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
Message-ID: <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com> <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com> <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com> <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com> <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com> <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com> <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com> <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com> <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020, John Fastabend wrote:

> > > At this point I fear we could consider reverting the NOLOCK stuff.
> > > I personally would hate doing so, but it looks like NOLOCK benefits are
> > > outweighed by its issues.
> > 
> > I agree, NOLOCK brings more pains than gains. There are many race
> > conditions hidden in generic qdisc layer, another one is enqueue vs.
> > reset which is being discussed in another thread.
> 
> Sure. Seems they crept in over time. I had some plans to write a
> lockless HTB implementation. But with fq+EDT with BPF it seems that
> it is no longer needed, we have a more generic/better solution.  So
> I dropped it. Also most folks should really be using fq, fq_codel,
> etc. by default anyways. Using pfifo_fast alone is not ideal IMO.

Half a year later, we still have the NOLOCK implementation 
present, and pfifo_fast still does set the TCQ_F_NOLOCK flag on itself. 

And we've just been bitten by this very same race which appears to be 
still unfixed, with single packet being stuck in pfifo_fast qdisc 
basically indefinitely due to this very race that this whole thread began 
with back in 2019.

Unless there are

	(a) any nice ideas how to solve this in an elegant way without 
	    (re-)introducing extra spinlock (Cong's fix) or

	(b) any objections to revert as per the argumentation above

I'll be happy to send a revert of the whole NOLOCK implementation next 
week.

Thanks,

-- 
Jiri Kosina
SUSE Labs

