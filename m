Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29373B8105
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 12:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhF3LAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 07:00:40 -0400
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:56216 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229882AbhF3LAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 07:00:38 -0400
Received: from omf06.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 03D2F18096A36;
        Wed, 30 Jun 2021 10:58:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 6F18E2448BB;
        Wed, 30 Jun 2021 10:58:07 +0000 (UTC)
Message-ID: <f7beb9aee00a1cdb8dd97a49a36abd60d58279f2.camel@perches.com>
Subject: Re: [RFC 13/19] staging: qlge: rewrite do while loop as for loop in
 qlge_sem_spinlock
From:   Joe Perches <joe@perches.com>
To:     Coiby Xu <coiby.xu@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 30 Jun 2021 03:58:06 -0700
In-Reply-To: <20210624112245.zgvkcxyu7hzrzc23@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
         <20210621134902.83587-14-coiby.xu@gmail.com> <20210622072036.GK1861@kadam>
         <20210624112245.zgvkcxyu7hzrzc23@Rk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.39
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 6F18E2448BB
X-Stat-Signature: byo61h9tdyfet1zjamufshpd8jh1i6zk
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19+Me1uZrs5Ho696/FTg+x3rB2212tX89w=
X-HE-Tag: 1625050687-621425
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 19:22 +0800, Coiby Xu wrote:
> On Tue, Jun 22, 2021 at 10:20:36AM +0300, Dan Carpenter wrote:
> > On Mon, Jun 21, 2021 at 09:48:56PM +0800, Coiby Xu wrote:
> > > Since wait_count=30 > 0, the for loop is equivalent to do while
> > > loop. This commit also replaces 100 with UDELAY_DELAY.
[]
> > > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
[]
> > > @@ -140,12 +140,13 @@ static int qlge_sem_trylock(struct qlge_adapter *qdev, u32 sem_mask)
> > >  int qlge_sem_spinlock(struct qlge_adapter *qdev, u32 sem_mask)
> > >  {
> > >  	unsigned int wait_count = 30;
> > > +	int count;
> > > 
> > > -	do {
> > > +	for (count = 0; count < wait_count; count++) {
> > >  		if (!qlge_sem_trylock(qdev, sem_mask))
> > >  			return 0;
> > > -		udelay(100);
> > > -	} while (--wait_count);
> > > +		udelay(UDELAY_DELAY);
> > 
> > This is an interesting way to silence the checkpatch udelay warning.  ;)
> 
> I didn't know this could silence the warning :)

It also seems odd to have unsigned int wait_count and int count.

Maybe just use 30 in the loop without using wait_count at all.

I also think using UDELAY_DELAY is silly and essentially misleading
as it's also used as an argument value for mdelay

$ git grep -w UDELAY_DELAY
drivers/staging/qlge/qlge.h:#define UDELAY_DELAY 100
drivers/staging/qlge/qlge_main.c:               udelay(UDELAY_DELAY);
drivers/staging/qlge/qlge_main.c:               udelay(UDELAY_DELAY);
drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY);
drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY);
drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY); /* 100ms */


