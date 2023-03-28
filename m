Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802CD6CB9E7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjC1Ixx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjC1Ixw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:53:52 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC1119A1;
        Tue, 28 Mar 2023 01:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=gEp59zkhMVdLtlPGh3Tui4d23aP7zg4mU9TC68P/rYc=; b=aLJDpi51t9Y15Oj8jDKUSX5Uht
        xpU8koFgXqg0nohgVLRmDZzKVBSYtE5V9xUT7DQHm6IOfGP9bzGvpMQaawzTaEmQ2n7EXccZMP3oC
        dqOQZQ4BPNGkvpcZmILwKME8lyNGPtp4d2egUt7pT9I7bmoQZFJIYvDMbDEhDhF7SxZ7yx8uMOE96
        tnnDNrzhWR0m6xsvDhfyXZkgPDYq0kneBBQ9Tx3n7CgytqExzepFSUdJM4oMOfKBy6qx0NuN6dcOY
        wg4qu60O8cau96vtNrQkdUV9/ReI542cm55xg0TSpcINFdZWDXhV7dMBZZXWT0X60fCrNDmY+sSIy
        t43UYVwQ==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1ph55R-000Gpt-2G; Tue, 28 Mar 2023 10:53:49 +0200
Received: from [219.59.88.22] (helo=localhost.localdomain)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ph55Q-00023f-1B; Tue, 28 Mar 2023 10:53:48 +0200
Subject: Re: [PATCH bpf] bpf: tcp: Use sock_gen_put instead of sock_put in
 bpf_iter_tcp
To:     Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        netdev@vger.kernel.org, kernel-team@meta.com
References: <20230328004232.2134233-1-martin.lau@linux.dev>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a7c68367-496f-a1a0-5d98-6b0ef50d08c2@iogearbox.net>
Date:   Tue, 28 Mar 2023 10:53:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230328004232.2134233-1-martin.lau@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26857/Tue Mar 28 09:23:39 2023)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/23 2:42 AM, Martin KaFai Lau wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> While reviewing the udp-iter batching patches, notice the bpf_iter_tcp
> calling sock_put() is incorrect. It should call sock_gen_put instead
> because bpf_iter_tcp is iterating the ehash table which has the
> req sk and tw sk. This patch replaces all sock_put with sock_gen_put
> in the bpf_iter_tcp codepath.
> 
> Fixes: 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock")
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>

Looks like patchbot is on vacation :( The below looks good to me, so I
applied it to bpf, thanks!

>   net/ipv4/tcp_ipv4.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index ea370afa70ed..b9d55277cb85 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2780,7 +2780,7 @@ static int tcp_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
>   static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
>   {
>   	while (iter->cur_sk < iter->end_sk)
> -		sock_put(iter->batch[iter->cur_sk++]);
> +		sock_gen_put(iter->batch[iter->cur_sk++]);
>   }
>   
>   static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
> @@ -2941,7 +2941,7 @@ static void *bpf_iter_tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>   		 * st->bucket.  See tcp_seek_last_pos().
>   		 */
>   		st->offset++;
> -		sock_put(iter->batch[iter->cur_sk++]);
> +		sock_gen_put(iter->batch[iter->cur_sk++]);
>   	}
>   
>   	if (iter->cur_sk < iter->end_sk)
> 

