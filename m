Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3B21811C6
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 08:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgCKHVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 03:21:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:40098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728242AbgCKHVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 03:21:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC2FDAF4E;
        Wed, 11 Mar 2020 07:21:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 855EFE0C0A; Wed, 11 Mar 2020 08:21:12 +0100 (CET)
Date:   Wed, 11 Mar 2020 08:21:12 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrej Ras <kermitthekoder@gmail.com>
Subject: Re: What does this code do
Message-ID: <20200311072112.GF8012@unicorn.suse.cz>
References: <CAHfguVw9unGL-_ETLzRSVCFqHH5_etafbj1MLaMB+FywLpZjTA@mail.gmail.com>
 <20200310221221.GD8012@unicorn.suse.cz>
 <CAHfguVy4=Gtm0cmToswashVSwmS+kOk57qg+H+jspaHrH8tJkg@mail.gmail.com>
 <20200311055343.GE8012@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311055343.GE8012@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 06:53:43AM +0100, Michal Kubecek wrote:
> On Tue, Mar 10, 2020 at 09:11:06PM -0700, Andrej Ras wrote:
> > On Tue, Mar 10, 2020 at 3:12 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >
> > > On Tue, Mar 10, 2020 at 02:42:11PM -0700, Andrej Ras wrote:
> > > > While browsing the Linux networking code I came across these two lines
> > > > in __ip_append_data() which I do not understand.
> > > >
> > > >                 /* Check if the remaining data fits into current packet. */
> > > >                 copy = mtu - skb->len;
> > > >                 if (copy < length)
> > > >                         copy = maxfraglen - skb->len;
> > > >                 if (copy <= 0) {
> > > >
> > > > Why not just use maxfraglen.
> > > >
> > > > Perhaps someone can explain why this is needed.
> > >
> > > This function appends more data to an skb which can already contain some
> > > payload. Therefore you need to take current length (from earlier) into
> > > account, not only newly appended data.
> > >
> > > This can be easily enforced e.g. with TCP_CORK or UDP_CORK socket option
> > > or MSG_MORE flag.
> > >
> > I understand that the code is appending data, what I do not understand
> > is why is it first calculating the remaining space by taking the
> > difference using the size of mtu and if the difference is <= 0 it
> > recalculates the difference using maxfraglen. Why not just use
> > maxfraglen -- All we need to know is how much more data can be added
> > to the skb.
> 
> Ah, I see. The first test checks if we can fit into an unfragmented
> packet so that we check against mtu.

Thinking about it again, it would be more precise to say "unfragmented
packet or last fragment" here as it also covers the case when we already
have some fragments and test if we can send the rest (including current
chunk) as last fragment whose length does not need to be a multiple of 8.

Michal Kubecek

>                                      If we don't fit, fragmentation will
> be needed so that maxfraglen is the limit (maxfraglen can be shorter
> than mtu due to the rounding down to a multiple of 8).


