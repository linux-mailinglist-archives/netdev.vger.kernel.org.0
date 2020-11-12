Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079322AFD02
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgKLBcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:54810 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgKLATe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 19:19:34 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kd0Ko-0007OD-G3; Thu, 12 Nov 2020 01:19:30 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kd0Ko-0004DD-Ak; Thu, 12 Nov 2020 01:19:30 +0100
Subject: Re: [bpf PATCH 1/5] bpf, sockmap: fix partial copy_page_to_iter so
 progress can still be made
To:     John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        jakub@cloudflare.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
 <160477787531.608263.10144789972668918015.stgit@john-XPS-13-9370>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1aa5f637-c044-3dc6-09d5-0b5dc0521f91@iogearbox.net>
Date:   Thu, 12 Nov 2020 01:19:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160477787531.608263.10144789972668918015.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25985/Wed Nov 11 14:18:01 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/20 8:37 PM, John Fastabend wrote:
> If copy_page_to_iter() fails or even partially completes, but with fewer
> bytes copied than expected we currently reset sg.start and return EFAULT.
> This proves problematic if we already copied data into the user buffer
> before we return an error. Because we leave the copied data in the user
> buffer and fail to unwind the scatterlist so kernel side believes data
> has been copied and user side believes data has _not_ been received.
> 
> Expected behavior should be to return number of bytes copied and then
> on the next read we need to return the error assuming its still there. This
> can happen if we have a copy length spanning multiple scatterlist elements
> and one or more complete before the error is hit.
> 
> The error is rare enough though that my normal testing with server side
> programs, such as nginx, httpd, envoy, etc., I have never seen this. The
> only reliable way to reproduce that I've found is to stream movies over
> my browser for a day or so and wait for it to hang. Not very scientific,
> but with a few extra WARN_ON()s in the code the bug was obvious.
> 
> When we review the errors from copy_page_to_iter() it seems we are hitting
> a page fault from copy_page_to_iter_iovec() where the code checks
> fault_in_pages_writeable(buf, copy) where buf is the user buffer. It
> also seems typical server applications don't hit this case.
> 
> The other way to try and reproduce this is run the sockmap selftest tool
> test_sockmap with data verification enabled, but it doesn't reproduce the
> fault. Perhaps we can trigger this case artificially somehow from the
> test tools. I haven't sorted out a way to do that yet though.
> 
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   net/ipv4/tcp_bpf.c |   15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 37f4cb2bba5c..3709d679436e 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -15,8 +15,8 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>   {
>   	struct iov_iter *iter = &msg->msg_iter;
>   	int peek = flags & MSG_PEEK;
> -	int i, ret, copied = 0;
>   	struct sk_msg *msg_rx;
> +	int i, copied = 0;
>   
>   	msg_rx = list_first_entry_or_null(&psock->ingress_msg,
>   					  struct sk_msg, list);
> @@ -37,10 +37,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>   			page = sg_page(sge);
>   			if (copied + copy > len)
>   				copy = len - copied;
> -			ret = copy_page_to_iter(page, sge->offset, copy, iter);
> -			if (ret != copy) {
> -				msg_rx->sg.start = i;
> -				return -EFAULT;
> +			copy = copy_page_to_iter(page, sge->offset, copy, iter);
> +			if (!copy) {
> +				return copied ? copied : -EFAULT;
>   			}

nit: no need for {}

>   
>   			copied += copy;
> @@ -56,6 +55,11 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>   						put_page(page);
>   				}
>   			} else {
> +				/* Lets not optimize peek case if copy_page_to_iter
> +				 * didn't copy the entire length lets just break.
> +				 */
> +				if (copy != sge->length)
> +					goto out;

nit: return copied;

Rest lgtm for this one.

>   				sk_msg_iter_var_next(i);
>   			}
>   
> @@ -82,6 +86,7 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>   						  struct sk_msg, list);
>   	}
>   
> +out:
>   	return copied;
>   }
>   EXPORT_SYMBOL_GPL(__tcp_bpf_recvmsg);
> 
> 

