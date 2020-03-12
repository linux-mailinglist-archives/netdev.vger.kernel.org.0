Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3CA183D43
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCLXXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:23:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:41302 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgCLXXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:23:02 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCXAJ-0000L5-LW; Fri, 13 Mar 2020 00:22:59 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCXAJ-0000eZ-CO; Fri, 13 Mar 2020 00:22:59 +0100
Subject: Re: [PATCH bpf-next] bpf: abstract away entire bpf_link clean up
 procedure
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200312203914.1195762-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2d6ae192-fe22-0239-54c7-142ec21b7794@iogearbox.net>
Date:   Fri, 13 Mar 2020 00:22:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200312203914.1195762-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25749/Thu Mar 12 14:09:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20 9:39 PM, Andrii Nakryiko wrote:
> Instead of requiring users to do three steps for cleaning up bpf_link, its
> anon_inode file, and unused fd, abstract that away into bpf_link_cleanup()
> helper. bpf_link_defunct() is removed, as it shouldn't be needed as an
> individual operation anymore.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   include/linux/bpf.h  |  3 ++-
>   kernel/bpf/syscall.c | 18 +++++++++++-------
>   2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4fd91b7c95ea..358f3eb07c01 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1075,7 +1075,8 @@ struct bpf_link_ops {
>   
>   void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
>   		   struct bpf_prog *prog);
> -void bpf_link_defunct(struct bpf_link *link);
> +void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> +		      int link_fd);
>   void bpf_link_inc(struct bpf_link *link);
>   void bpf_link_put(struct bpf_link *link);
>   int bpf_link_new_fd(struct bpf_link *link);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b2f73ecacced..d2f49ae225b0 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2188,9 +2188,17 @@ void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
>   	link->prog = prog;
>   }
>   
> -void bpf_link_defunct(struct bpf_link *link)
> +/* Clean up bpf_link and corresponding anon_inode file and FD. After
> + * anon_inode is created, bpf_link can't be just kfree()'d due to deferred
> + * anon_inode's release() call. This helper manages marking bpf_link as
> + * defunct, releases anon_inode file and puts reserved FD.
> + */
> +void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> +		      int link_fd)

Looks good, but given it is only used here this should be static instead.

>   {
>   	link->prog = NULL;
> +	fput(link_file);
> +	put_unused_fd(link_fd);
>   }
>   
>   void bpf_link_inc(struct bpf_link *link)
> @@ -2383,9 +2391,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
>   
>   	err = bpf_trampoline_link_prog(prog);
>   	if (err) {
> -		bpf_link_defunct(&link->link);
> -		fput(link_file);
> -		put_unused_fd(link_fd);
> +		bpf_link_cleanup(&link->link, link_file, link_fd);
>   		goto out_put_prog;
>   	}
>   
> @@ -2498,9 +2504,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
>   
>   	err = bpf_probe_register(link->btp, prog);
>   	if (err) {
> -		bpf_link_defunct(&link->link);
> -		fput(link_file);
> -		put_unused_fd(link_fd);
> +		bpf_link_cleanup(&link->link, link_file, link_fd);
>   		goto out_put_btp;
>   	}
>   
> 

