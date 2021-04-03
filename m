Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501353533FE
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhDCMXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 08:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhDCMXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 08:23:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA78F6115A;
        Sat,  3 Apr 2021 12:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617452614;
        bh=j+qgLdFi7dSgQC2r74mI2QF8Cvo6wIoGFSrZBvP3pBQ=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=L2OBqespR4fZqSJPsdyVDJEBtsMPxWB7E86IoDqzp03YJ2nbQrhT6tuMe/fJBUwYO
         yfqYYlkYQMyOkjiNc19YgZL9MBDf39k+/oFAREiEDwQjl0HvDCMJXObrqKejYIWL9/
         Lwxdb6pfas05Lr+A2dEzAv+10jB1tRc0t1YKXM+vaJm1/IMLz7RoWgshSOoOBGZoHh
         2kr2cLugb/eYRwpYTqRECKXXMDzDdeOpN7SY2qcnji8onbA2C+bnOXsNhFOYpypqmD
         yUMSTrASlfaN5cn4RtUoLOZwwWHxvszTgN3snAPzasLOZHRjvo6uvpA2bvv3g2u8/a
         6RQdJAoeU2wvg==
Date:   Sat, 3 Apr 2021 14:23:29 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Hillf Danton <hdanton@sina.com>
cc:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Jike Song <albcamus@gmail.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
In-Reply-To: <20210403003537.2032-1-hdanton@sina.com>
Message-ID: <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com> <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com> <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com> <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com> <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com> <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com> <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com> <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com> <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch> <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm> <20210403003537.2032-1-hdanton@sina.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Apr 2021, Hillf Danton wrote:

> >>> Sure. Seems they crept in over time. I had some plans to write a
> >>> lockless HTB implementation. But with fq+EDT with BPF it seems that
> >>> it is no longer needed, we have a more generic/better solution.  So
> >>> I dropped it. Also most folks should really be using fq, fq_codel,
> >>> etc. by default anyways. Using pfifo_fast alone is not ideal IMO.
> >> 
> >> Half a year later, we still have the NOLOCK implementation
> >> present, and pfifo_fast still does set the TCQ_F_NOLOCK flag on itself.
> >> 
> >> And we've just been bitten by this very same race which appears to be
> >> still unfixed, with single packet being stuck in pfifo_fast qdisc
> >> basically indefinitely due to this very race that this whole thread began
> >> with back in 2019.
> >> 
> >> Unless there are
> >> 
> >> 	(a) any nice ideas how to solve this in an elegant way without
> >> 	    (re-)introducing extra spinlock (Cong's fix) or
> >> 
> >> 	(b) any objections to revert as per the argumentation above
> >> 
> >> I'll be happy to send a revert of the whole NOLOCK implementation next
> >> week.
> >> 
> >Jiri
> >
> 
> Feel free to revert it as the scorch wont end without a deluge.

I am still planning to have Yunsheng Lin's (CCing) fix [1] tested in the 
coming days. If it works, then we can consider proceeding with it, 
otherwise I am all for reverting the whole NOLOCK stuff.

[1] https://lore.kernel.org/linux-can/1616641991-14847-1-git-send-email-linyunsheng@huawei.com/T/#u

-- 
Jiri Kosina
SUSE Labs

