Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD2233E7D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 06:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgGaExH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 00:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgGaExG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 00:53:06 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50CE12074B;
        Fri, 31 Jul 2020 04:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596171186;
        bh=MnEbR4t/xoxAN93gD+qE5jCDyQ4vcBjhtQp8diZ/N88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ugZ+u62GbxspOh76EELUql3biENANGq3nTvcDrY1aGLphdm1mxDObpR/WAHU3Upvn
         I6lfZeT+cGvAyIdNSrO/BfjIlqiTUE6aaA+CVw0L9tF5MEzpHH9faVIlaS8keDBqB8
         hn6iSlGtBHbLSPJg0Yb5zkpCpXC//r+57UaXAD0s=
Date:   Fri, 31 Jul 2020 07:53:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731045301.GI75549@unreal>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730192026.110246-1-yepeilin.cs@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
> rds_notify_queue_get() is potentially copying uninitialized kernel stack
> memory to userspace since the compiler may leave a 4-byte hole at the end
> of `cmsg`.
>
> In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
> unfortunately does not always initialize that 4-byte hole. Fix it by using
> memset() instead.

Of course, this is the difference between "{ 0 }" and "{}" initializations.

>
> Cc: stable@vger.kernel.org
> Fixes: f037590fff30 ("rds: fix a leak of kernel memory")
> Fixes: bdbe6fbc6a2f ("RDS: recv.c")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> Note: the "real" copy_to_user() happens in put_cmsg(), where
> `cmlen - sizeof(*cm)` equals to `sizeof(cmsg)`.
>
> Reference: https://lwn.net/Articles/417989/
>
> $ pahole -C "rds_rdma_notify" net/rds/recv.o
> struct rds_rdma_notify {
> 	__u64                      user_token;           /*     0     8 */
> 	__s32                      status;               /*     8     4 */
>
> 	/* size: 16, cachelines: 1, members: 2 */
> 	/* padding: 4 */
> 	/* last cacheline: 16 bytes */
> };
>
>  net/rds/recv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index c8404971d5ab..aba4afe4dfed 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -450,12 +450,13 @@ static int rds_still_queued(struct rds_sock *rs, struct rds_incoming *inc,
>  int rds_notify_queue_get(struct rds_sock *rs, struct msghdr *msghdr)
>  {
>  	struct rds_notifier *notifier;
> -	struct rds_rdma_notify cmsg = { 0 }; /* fill holes with zero */
> +	struct rds_rdma_notify cmsg;
>  	unsigned int count = 0, max_messages = ~0U;
>  	unsigned long flags;
>  	LIST_HEAD(copy);
>  	int err = 0;
>
> +	memset(&cmsg, 0, sizeof(cmsg));	/* fill holes with zero */

It works, but the right solution is to drop 0 from cmsg initialization
and write "struct rds_rdma_notify cmsg = {};" without any memset.

Thanks
