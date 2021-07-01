Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EDF3B8D34
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 06:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhGAEiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 00:38:06 -0400
Received: from smtprelay0066.hostedemail.com ([216.40.44.66]:55928 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229577AbhGAEiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 00:38:05 -0400
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 5B578181EE40C;
        Thu,  1 Jul 2021 04:35:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id D603320D770;
        Thu,  1 Jul 2021 04:35:33 +0000 (UTC)
Message-ID: <fe4a647d5324e9d8d23564f6d685f3ca720db166.camel@perches.com>
Subject: Re: [RFC 13/19] staging: qlge: rewrite do while loop as for loop in
 qlge_sem_spinlock
From:   Joe Perches <joe@perches.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 30 Jun 2021 21:35:31 -0700
In-Reply-To: <20210630233338.2l34shhrm3bdd4gx@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
         <20210621134902.83587-14-coiby.xu@gmail.com> <20210622072036.GK1861@kadam>
         <20210624112245.zgvkcxyu7hzrzc23@Rk>
         <f7beb9aee00a1cdb8dd97a49a36abd60d58279f2.camel@perches.com>
         <20210630233338.2l34shhrm3bdd4gx@Rk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.37
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: D603320D770
X-Stat-Signature: 7rmdc1nrquttg9xgaoqxcsmo73w5qmoc
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19n/GBQXP7gIkMOXhN3RXKOLxsT9DwiqiU=
X-HE-Tag: 1625114133-240606
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-01 at 07:33 +0800, Coiby Xu wrote:
> On Wed, Jun 30, 2021 at 03:58:06AM -0700, Joe Perches wrote:
> > On Thu, 2021-06-24 at 19:22 +0800, Coiby Xu wrote:
> > > On Tue, Jun 22, 2021 at 10:20:36AM +0300, Dan Carpenter wrote:
> > > > On Mon, Jun 21, 2021 at 09:48:56PM +0800, Coiby Xu wrote:
> > > > > Since wait_count=30 > 0, the for loop is equivalent to do while
> > > > > loop. This commit also replaces 100 with UDELAY_DELAY.
> > []
> > > > > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > []
> > I also think using UDELAY_DELAY is silly and essentially misleading
> > as it's also used as an argument value for mdelay
> > 
> > $ git grep -w UDELAY_DELAY
> > drivers/staging/qlge/qlge.h:#define UDELAY_DELAY 100
> > drivers/staging/qlge/qlge_main.c:               udelay(UDELAY_DELAY);
> > drivers/staging/qlge/qlge_main.c:               udelay(UDELAY_DELAY);
> > drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY);
> > drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY);
> > drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY); /* 100ms */
> 
> Thanks for spotting this issue! How about "#define MDELAY_DELAY 100" for
> mdelay?

I think the define is pointless and it'd be more readable
to just use 100 in all the cases.

IMO: There really aren't enough cases to justify using defines.


