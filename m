Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B70F21D085
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgGMHiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:38:10 -0400
Received: from verein.lst.de ([213.95.11.211]:49118 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgGMHiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 03:38:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B741F68B02; Mon, 13 Jul 2020 09:38:06 +0200 (CEST)
Date:   Mon, 13 Jul 2020 09:38:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Doug Nazar <nazard@nazar.ca>, Christoph Hellwig <hch@lst.de>,
        ericvh@gmail.com, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/9p: validate fds in p9_fd_open
Message-ID: <20200713073806.GA14676@lst.de>
References: <20200710085722.435850-1-hch@lst.de> <5bee3e33-2400-2d85-080e-d10cd82b0d85@nazar.ca> <20200711104923.GA6584@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711104923.GA6584@nautica>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 12:49:23PM +0200, Dominique Martinet wrote:
> > >diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> > >index 13cd683a658ab6..1cd8ea0e493617 100644
> > >--- a/net/9p/trans_fd.c
> > >+++ b/net/9p/trans_fd.c
> > >@@ -803,20 +803,28 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
> > >  		return -ENOMEM;
> > >  	ts->rd = fget(rfd);
> > >+	if (!ts->rd)
> > >+		goto out_free_ts;
> > >+	if (!(ts->rd->f_mode & FMODE_READ))
> > >+		goto out_put_wr;
> > 
> > 		goto out_put_rd;
> > 
> > unless I'm mistaken.
> 
> Good catch, I've amended the commit so feel free to skip resending
> unless want to change something
> https://github.com/martinetd/linux/commit/28e987a0dc66744fb119e18150188fd8e3debd40

Thanks, this looks good to me.
