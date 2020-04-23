Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9641B5524
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgDWHFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:05:55 -0400
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:3276
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726027AbgDWHFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:05:55 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2020 03:05:53 EDT
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id CC965206A4;
        Thu, 23 Apr 2020 07:00:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Apr 2020 09:00:42 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        kjlu@umn.edu, Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH 1/2] net/x25: Fix x25_neigh refcnt leak when x25_connect()
 fails
Organization: TDT AG
In-Reply-To: <1587618822-13544-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1587618822-13544-1-git-send-email-xiyuyang19@fudan.edu.cn>
Message-ID: <fccc5247bb916ccbd9a4c2ef8c6e76e4@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-23 07:13, Xiyu Yang wrote:
> x25_connect() invokes x25_get_neigh(), which returns a reference of the
> specified x25_neigh object to "x25->neighbour" with increased refcnt.
> 
> When x25_connect() returns, local variable "x25" and "x25->neighbour"
> become invalid, so the refcount should be decreased to keep refcount
> balanced.
> 
> The reference counting issue happens in one exception handling path of
> x25_connect(). When sock state is not TCP_ESTABLISHED and its flags
> include O_NONBLOCK, the function forgets to decrease the refcnt
> increased by x25_get_neigh(), causing a refcnt leak.
> 
> Fix this issue by jumping to "out_put_neigh" label when x25_connect()
> fails.

I don't agree with that.
Please have a look at commit e21dba7a4df4 ("net/x25: fix nonblocking 
connect).

But I also think you are right and there seems to be a refcnt leak,
which should be fixed by a call to x25_neigh_put() in the
x25_disconnect() function.

- Martin


> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  net/x25/af_x25.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index d5b09bbff375..e6571c56209b 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c
> @@ -816,7 +816,7 @@ static int x25_connect(struct socket *sock, struct
> sockaddr *uaddr,
>  	/* Now the loop */
>  	rc = -EINPROGRESS;
>  	if (sk->sk_state != TCP_ESTABLISHED && (flags & O_NONBLOCK))
> -		goto out;
> +		goto out_put_neigh;
> 
>  	rc = x25_wait_for_connection_establishment(sk);
>  	if (rc)

