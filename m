Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124F710343B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 07:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKTGPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 01:15:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:33771 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfKTGPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 01:15:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 22:15:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,220,1571727600"; 
   d="scan'208";a="357337027"
Received: from jesusale-mobl4.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.32.22])
  by orsmga004.jf.intel.com with ESMTP; 19 Nov 2019 22:15:43 -0800
Subject: Re: [PATCH] xsk: fix xsk_poll()'s return type
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
References: <20191120001042.30830-1-luc.vanoostenryck@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <103f550e-4a78-e540-4a57-bdecc2f066cf@intel.com>
Date:   Wed, 20 Nov 2019 07:15:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191120001042.30830-1-luc.vanoostenryck@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-11-20 01:10, Luc Van Oostenryck wrote:
> xsk_poll() is defined as returning 'unsigned int' but the
> .poll method is declared as returning '__poll_t', a bitwise type.
> 
> Fix this by using the proper return type and using the EPOLL
> constants instead of the POLL ones, as required for __poll_t.
>

Thanks for the cleanup!

Acked-by: Björn Töpel <bjorn.topel@intel.com>

Daniel/Alexei: This should go through bpf-next.


Björn



> CC: Björn Töpel <bjorn.topel@intel.com>
> CC: Magnus Karlsson <magnus.karlsson@intel.com>
> CC: Jonathan Lemon <jonathan.lemon@gmail.com>
> CC: netdev@vger.kernel.org
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>   net/xdp/xsk.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 9044073fbf22..7b59f36eec0d 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -418,10 +418,10 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>   	return __xsk_sendmsg(sk);
>   }
>   
> -static unsigned int xsk_poll(struct file *file, struct socket *sock,
> +static __poll_t xsk_poll(struct file *file, struct socket *sock,
>   			     struct poll_table_struct *wait)
>   {
> -	unsigned int mask = datagram_poll(file, sock, wait);
> +	__poll_t mask = datagram_poll(file, sock, wait);
>   	struct sock *sk = sock->sk;
>   	struct xdp_sock *xs = xdp_sk(sk);
>   	struct net_device *dev;
> @@ -443,9 +443,9 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
>   	}
>   
>   	if (xs->rx && !xskq_empty_desc(xs->rx))
> -		mask |= POLLIN | POLLRDNORM;
> +		mask |= EPOLLIN | EPOLLRDNORM;
>   	if (xs->tx && !xskq_full_desc(xs->tx))
> -		mask |= POLLOUT | POLLWRNORM;
> +		mask |= EPOLLOUT | EPOLLWRNORM;
>   
>   	return mask;
>   }
> 
