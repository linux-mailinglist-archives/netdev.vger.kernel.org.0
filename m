Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217EB3B2FD6
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 15:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFXNO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:14:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:48020 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFXNO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 09:14:58 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lwP9p-0001f9-UU; Thu, 24 Jun 2021 15:12:37 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lwP9p-000UvC-Lm; Thu, 24 Jun 2021 15:12:37 +0200
Subject: Re: [PATCH bpf-next v4 05/19] xdp: add proper __rcu annotations to
 redirect map entries
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210623110727.221922-1-toke@redhat.com>
 <20210623110727.221922-6-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f26af869-5ea2-878a-a263-ae6f099043e9@iogearbox.net>
Date:   Thu, 24 Jun 2021 15:12:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210623110727.221922-6-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26211/Thu Jun 24 13:04:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/21 1:07 PM, Toke Høiland-Jørgensen wrote:
> XDP_REDIRECT works by a three-step process: the bpf_redirect() and
> bpf_redirect_map() helpers will lookup the target of the redirect and store
> it (along with some other metadata) in a per-CPU struct bpf_redirect_info.
> Next, when the program returns the XDP_REDIRECT return code, the driver
> will call xdp_do_redirect() which will use the information thus stored to
> actually enqueue the frame into a bulk queue structure (that differs
> slightly by map type, but shares the same principle). Finally, before
> exiting its NAPI poll loop, the driver will call xdp_do_flush(), which will
> flush all the different bulk queues, thus completing the redirect.
[...]
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
[...]
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index c5ad7df029ed..b01e266dad9e 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -762,12 +762,10 @@ DECLARE_BPF_DISPATCHER(xdp)
>   
>   static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
>   					    struct xdp_buff *xdp)
> -{
> -	/* Caller needs to hold rcu_read_lock() (!), otherwise program
> -	 * can be released while still running, or map elements could be
> -	 * freed early while still having concurrent users. XDP fastpath
> -	 * already takes rcu_read_lock() when fetching the program, so
> -	 * it's not necessary here anymore.
> +
> +	/* Driver XDP hooks are invoked within a single NAPI poll cycle and thus
> +	 * under local_bh_disable(), which provides the needed RCU protection
> +	 * for accessing map entries.
>   	 */
>   	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
>   }

I just went over the series to manually fix up merge conflicts in the driver
patches since they didn't apply cleanly against bpf-next.

But as it turned out that extra work was needless, since you didn't even compile
test the series before submission, sigh.

Please fix (and only submit compile- & runtime-tested code in future).

Thanks,
Daniel
