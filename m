Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508E418198C
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgCKNWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:22:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:51974 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbgCKNWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:22:09 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC1JG-0003PB-SS; Wed, 11 Mar 2020 14:22:06 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC1JG-000Unh-Jc; Wed, 11 Mar 2020 14:22:06 +0100
Subject: Re: [PATCH bpf-next] bpf: add bpf_link_new_file that doesn't install
 FD
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200309231051.1270337-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7467529c-b712-5314-ebbe-13f73ac01bdb@iogearbox.net>
Date:   Wed, 11 Mar 2020 14:22:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200309231051.1270337-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25748/Wed Mar 11 12:08:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 12:10 AM, Andrii Nakryiko wrote:
> Add bpf_link_new_file() API for cases when we need to ensure anon_inode is
> successfully created before we proceed with expensive BPF program attachment
> procedure, which will require equally (if not more so) expensive and
> potentially failing compensation detachment procedure just because anon_inode
> creation failed. This API allows to simplify code by ensuring first that
> anon_inode is created and after BPF program is attached proceed with
> fd_install() that can't fail.
> 
> After anon_inode file is created, link can't be just kfree()'d anymore,
> because its destruction will be performed by deferred file_operations->release
> call. For this, bpf_link API required specifying two separate operations:
> release() and dealloc(), former performing detachment only, while the latter
> frees memory used by bpf_link itself. dealloc() needs to be specified, because
> struct bpf_link is frequently embedded into link type-specific container
> struct (e.g., struct bpf_raw_tp_link), so bpf_link itself doesn't know how to
> properly free the memory. In case when anon_inode file was successfully
> created, but subsequent BPF attachment failed, bpf_link needs to be marked as
> "defunct", so that file's release() callback will perform only memory
> deallocation, but no detachment.
> 
> Convert raw tracepoint and tracing attachment to new API and eliminate
> detachment from error handling path.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, but ...

[...]
> @@ -2337,20 +2374,24 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
>   	}
>   	bpf_link_init(&link->link, &bpf_tracing_link_lops, prog);
>   
> -	err = bpf_trampoline_link_prog(prog);
> -	if (err)
> -		goto out_free_link;
> +	link_file = bpf_link_new_file(&link->link, &link_fd);
> +	if (IS_ERR(link_file)) {
> +		kfree(link);
> +		err = PTR_ERR(link_file);
> +		goto out_put_prog;
> +	}
>   
> -	link_fd = bpf_link_new_fd(&link->link);
> -	if (link_fd < 0) {
> -		WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
> -		err = link_fd;
> -		goto out_free_link;
> +	err = bpf_trampoline_link_prog(prog);
> +	if (err) {
> +		bpf_link_defunct(&link->link);
> +		fput(link_file);
> +		put_unused_fd(link_fd);

Given the tear-down in error case requires 3 manual steps here, I think this begs
for a small helper.

> +		goto out_put_prog;
>   	}
> +
> +	fd_install(link_fd, link_file);
>   	return link_fd;
>   
[...]
> @@ -2431,28 +2481,32 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
>   		goto out_put_prog;
>   	}
>   
[...]
>   
> -	link_fd = bpf_link_new_fd(&raw_tp->link);
> -	if (link_fd < 0) {
> -		bpf_probe_unregister(raw_tp->btp, prog);
> -		err = link_fd;
> -		goto out_free_tp;
> +	err = bpf_probe_register(link->btp, prog);
> +	if (err) {
> +		bpf_link_defunct(&link->link);
> +		fput(link_file);
> +		put_unused_fd(link_fd);

Especially since you need it in multiple places; please follow-up.

> +		goto out_put_btp;
>   	}
> +
> +	fd_install(link_fd, link_file);
>   	return link_fd;
>   
> -out_free_tp:
> -	kfree(raw_tp);
>   out_put_btp:
>   	bpf_put_raw_tracepoint(btp);
>   out_put_prog:
> 

