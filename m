Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E41C231A44
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 09:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgG2HWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 03:22:49 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:51702 "EHLO
        4.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgG2HWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 03:22:48 -0400
X-Greylist: delayed 3625 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2020 03:22:47 EDT
Received: from player731.ha.ovh.net (unknown [10.110.171.117])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id 9FF001E2B58
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 08:06:42 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player731.ha.ovh.net (Postfix) with ESMTPSA id A82B81493DA7D;
        Wed, 29 Jul 2020 06:06:31 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-103G0054b49c4c4-d057-4c56-8bb1-1a67c11c2913,A40F6FE0CFFE28C23AB4AFBB3D5D665E11D39731) smtp.auth=groug@kaod.org
Date:   Wed, 29 Jul 2020 08:06:30 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     v9fs-developer@lists.sourceforge.net,
        Latchesar Ionkov <lucho@ionkov.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [V9fs-developer] [PATCH kernel] 9p/trans_fd: Check file mode at
 opening
Message-ID: <20200729080630.2741f2e5@bahia.lan>
In-Reply-To: <ceaa4de6-e4df-e6b0-8085-7020240c57b4@ozlabs.ru>
References: <20200728124129.130856-1-aik@ozlabs.ru>
        <20200728194235.52660c08@bahia.lan>
        <ceaa4de6-e4df-e6b0-8085-7020240c57b4@ozlabs.ru>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1293096043977742837
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrieefgddutdefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepheekhfdtheegheehjeeludefkefhvdelfedvieehhfekhfdufffhueeuvdfftdfhnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejfedurdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 09:50:21 +1000
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> 
> 
> On 29/07/2020 03:42, Greg Kurz wrote:
> > Hi Alexey,
> > 
> > Working on 9p now ?!? ;-)
> 
> No, I am running syzkaller and seeing things :)
> 

:)

> 
> > Cc'ing Dominique Martinet who appears to be the person who takes care of 9p
> > these days.
> > 
> > On Tue, 28 Jul 2020 22:41:29 +1000
> > Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
> > 
> >> The "fd" transport layer uses 2 file descriptors passed externally
> >> and calls kernel_write()/kernel_read() on these. If files were opened
> >> without FMODE_WRITE/FMODE_READ, WARN_ON_ONCE() will fire.
> >>
> >> This adds file mode checking in p9_fd_open; this returns -EBADF to
> >> preserve the original behavior.
> >>
> > 
> > So this would cause open() to fail with EBADF, which might look a bit
> > weird to userspace since it didn't pass an fd... Is this to have a
> > different error than -EIO that is returned when either rfd or wfd
> > doesn't point to an open file descriptor ?
> 
> This is only to preserve the existing behavior.
> 
> > If yes, why do we care ?
> 
> 
> Without the patch, p9_fd_open() produces a kernel warning which is not
> great by itself and becomes crash with panic_on_warn.
> 

I don't question the patch, just the errno. Why not returning -EIO ?

> 
> 
> > 
> >> Found by syzkaller.
> >>
> >> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> ---
> >>  net/9p/trans_fd.c | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> >> index 13cd683a658a..62cdfbd01f0a 100644
> >> --- a/net/9p/trans_fd.c
> >> +++ b/net/9p/trans_fd.c
> >> @@ -797,6 +797,7 @@ static int parse_opts(char *params, struct p9_fd_opts *opts)
> >>  
> >>  static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
> >>  {
> >> +	bool perm;
> >>  	struct p9_trans_fd *ts = kzalloc(sizeof(struct p9_trans_fd),
> >>  					   GFP_KERNEL);
> >>  	if (!ts)
> >> @@ -804,12 +805,16 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
> >>  
> >>  	ts->rd = fget(rfd);
> >>  	ts->wr = fget(wfd);
> >> -	if (!ts->rd || !ts->wr) {
> >> +	perm = ts->rd && (ts->rd->f_mode & FMODE_READ) &&
> >> +	       ts->wr && (ts->wr->f_mode & FMODE_WRITE);
> >> +	if (!ts->rd || !ts->wr || !perm) {
> >>  		if (ts->rd)
> >>  			fput(ts->rd);
> >>  		if (ts->wr)
> >>  			fput(ts->wr);
> >>  		kfree(ts);
> >> +		if (!perm)
> >> +			return -EBADF;
> >>  		return -EIO;
> >>  	}
> >>  
> > 
> 

