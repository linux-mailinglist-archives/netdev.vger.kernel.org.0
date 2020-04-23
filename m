Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9181B54C3
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgDWGg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:36:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57016 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgDWGg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 02:36:58 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6D733A5B66683E8B1864;
        Thu, 23 Apr 2020 14:36:56 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.154) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Thu, 23 Apr 2020
 14:36:52 +0800
Subject: Re: [PATCH 1/2] net/x25: Fix x25_neigh refcnt leak when x25_connect()
 fails
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1587618822-13544-1-git-send-email-xiyuyang19@fudan.edu.cn>
CC:     <yuanxzhang@fudan.edu.cn>, <kjlu@umn.edu>,
        Xin Tan <tanxin.ctf@gmail.com>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <8636fc9a-001a-9d48-087b-7f243527cd99@huawei.com>
Date:   Thu, 23 Apr 2020 14:36:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <1587618822-13544-1-git-send-email-xiyuyang19@fudan.edu.cn>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/23 13:13, Xiyu Yang wrote:
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
> @@ -816,7 +816,7 @@ static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
>  	/* Now the loop */
>  	rc = -EINPROGRESS;
>  	if (sk->sk_state != TCP_ESTABLISHED && (flags & O_NONBLOCK))
> -		goto out;
> +		goto out_put_neigh;

This seems not right, see

commit e21dba7a4df4 ("net/x25: fix nonblocking connect")

>  
>  	rc = x25_wait_for_connection_establishment(sk);
>  	if (rc)
> 

