Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66A4231483
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgG1VT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:19:56 -0400
Received: from 7.mo179.mail-out.ovh.net ([46.105.61.94]:42644 "EHLO
        7.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgG1VT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 17:19:56 -0400
X-Greylist: delayed 12599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2020 17:19:55 EDT
Received: from player756.ha.ovh.net (unknown [10.108.42.239])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 04BDA1734F3
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 19:42:46 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player756.ha.ovh.net (Postfix) with ESMTPSA id 1FCAC13EFFD15;
        Tue, 28 Jul 2020 17:42:35 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-97G002e93d7dbd-e9bf-43f9-bbae-e865b5c28c99,96196EA346850768E7E70500A314E772A5EF2CEB) smtp.auth=groug@kaod.org
Date:   Tue, 28 Jul 2020 19:42:35 +0200
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
Message-ID: <20200728194235.52660c08@bahia.lan>
In-Reply-To: <20200728124129.130856-1-aik@ozlabs.ru>
References: <20200728124129.130856-1-aik@ozlabs.ru>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 7175923058598975989
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedriedvgdduudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepheekhfdtheegheehjeeludefkefhvdelfedvieehhfekhfdufffhueeuvdfftdfhnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejheeirdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexey,

Working on 9p now ?!? ;-)

Cc'ing Dominique Martinet who appears to be the person who takes care of 9p
these days.

On Tue, 28 Jul 2020 22:41:29 +1000
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> The "fd" transport layer uses 2 file descriptors passed externally
> and calls kernel_write()/kernel_read() on these. If files were opened
> without FMODE_WRITE/FMODE_READ, WARN_ON_ONCE() will fire.
> 
> This adds file mode checking in p9_fd_open; this returns -EBADF to
> preserve the original behavior.
> 

So this would cause open() to fail with EBADF, which might look a bit
weird to userspace since it didn't pass an fd... Is this to have a
different error than -EIO that is returned when either rfd or wfd
doesn't point to an open file descriptor ? If yes, why do we care ?

> Found by syzkaller.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  net/9p/trans_fd.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index 13cd683a658a..62cdfbd01f0a 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -797,6 +797,7 @@ static int parse_opts(char *params, struct p9_fd_opts *opts)
>  
>  static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
>  {
> +	bool perm;
>  	struct p9_trans_fd *ts = kzalloc(sizeof(struct p9_trans_fd),
>  					   GFP_KERNEL);
>  	if (!ts)
> @@ -804,12 +805,16 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
>  
>  	ts->rd = fget(rfd);
>  	ts->wr = fget(wfd);
> -	if (!ts->rd || !ts->wr) {
> +	perm = ts->rd && (ts->rd->f_mode & FMODE_READ) &&
> +	       ts->wr && (ts->wr->f_mode & FMODE_WRITE);
> +	if (!ts->rd || !ts->wr || !perm) {
>  		if (ts->rd)
>  			fput(ts->rd);
>  		if (ts->wr)
>  			fput(ts->wr);
>  		kfree(ts);
> +		if (!perm)
> +			return -EBADF;
>  		return -EIO;
>  	}
>  

