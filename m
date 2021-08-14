Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2653EBF0E
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbhHNAk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:40:56 -0400
Received: from pecan-mail.exetel.com.au ([220.233.0.8]:36173 "EHLO
        pecan.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbhHNAk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 20:40:56 -0400
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2021 20:40:54 EDT
Received: from [203.24.121.254] (helo=mx1.kd.net.au)
        by pecan.exetel.com.au with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <hal@kd.net.au>)
        id 1mEhTC-0005H1-PP; Sat, 14 Aug 2021 10:24:15 +1000
Received: from localhost (auricle.kd [local]);
        by auricle.kd (OpenSMTPD) with ESMTPA id 7ca98a13;
        Sat, 14 Aug 2021 10:23:56 +1000 (AEST)
Date:   Sat, 14 Aug 2021 10:23:56 +1000
From:   Kevin Dawson <hal@kd.net.au>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, ajk@comnets.uni-bremen.de,
        davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: 6pack: fix slab-out-of-bounds in decode_data
Message-ID: <20210814002345.GA19994@auricle.kd>
References: <20210813112855.11170-1-paskripkin@gmail.com>
 <20210813145834.GC1931@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813145834.GC1931@kadam>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 05:58:34PM +0300, Dan Carpenter wrote:
> On Fri, Aug 13, 2021 at 02:28:55PM +0300, Pavel Skripkin wrote:
> > Syzbot reported slab-out-of bounds write in decode_data().
> > The problem was in missing validation checks.
> > 
> > Syzbot's reproducer generated malicious input, which caused
> > decode_data() to be called a lot in sixpack_decode(). Since
> > rx_count_cooked is only 400 bytes and noone reported before,
> > that 400 bytes is not enough, let's just check if input is malicious
> > and complain about buffer overrun.
> > 
> > ...
> > 
> > diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
> > index fcf3af76b6d7..f4ffc2a80ab7 100644
> > --- a/drivers/net/hamradio/6pack.c
> > +++ b/drivers/net/hamradio/6pack.c
> > @@ -827,6 +827,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
> >  		return;
> >  	}
> >  
> > +	if (sp->rx_count_cooked + 3 >= sizeof(sp->cooked_buf)) {
> 
> It should be + 2 instead of + 3.
> 
> We write three bytes.  idx, idx + 1, idx + 2.  Otherwise, good fix!

I would suggest that the statement be:

	if (sp->rx_count_cooked + 3 > sizeof(sp->cooked_buf)) {

or even, because it's a buffer overrun test:

	if (sp->rx_count_cooked > sizeof(sp->cooked_buf) - 3) {

This is because if there are three bytes being written, that is the number that should be obvious in the test.

I haven't looked at the surrounding code and there may be some other consideration why the "+ 2 >=" rather than "+ 3 >" (and from the description of "idx, idx + 1, idx + 2", I suspect it's visual consistency), so if that is important, feel free to adjust as required.

Thanks,
Kevin
