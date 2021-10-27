Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06B243D76E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 01:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhJ0XXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 19:23:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:41594 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhJ0XXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 19:23:46 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfsEM-000GsC-7q; Thu, 28 Oct 2021 01:21:14 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfsEL-00060m-VZ; Thu, 28 Oct 2021 01:21:13 +0200
Subject: Re: [PATCH bpf-next v2 1/3] libfs: support RENAME_EXCHANGE in
 simple_rename()
To:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, mszeredi@redhat.com,
        gregkh@linuxfoundation.org
References: <20211021151528.116818-1-lmb@cloudflare.com>
 <20211021151528.116818-2-lmb@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b215bb8c-3ffd-2b43-44a3-5b25243db5be@iogearbox.net>
Date:   Thu, 28 Oct 2021 01:21:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211021151528.116818-2-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26335/Wed Oct 27 10:28:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Adding Miklos & Greg to Cc for review given e0e0be8a8355 ("libfs: support RENAME_NOREPLACE in
   simple_rename()"). If you have a chance, would be great if you could take a look, thanks! ]

On 10/21/21 5:15 PM, Lorenz Bauer wrote:
> Allow atomic exchange via RENAME_EXCHANGE when using simple_rename.
> This affects binderfs, ramfs, hubetlbfs and bpffs. There isn't much
> to do except update the various *time fields.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>   fs/libfs.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 51b4de3b3447..93c03d593749 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -455,9 +455,12 @@ int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
>   	struct inode *inode = d_inode(old_dentry);
>   	int they_are_dirs = d_is_dir(old_dentry);
>   
> -	if (flags & ~RENAME_NOREPLACE)
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>   		return -EINVAL;
>   
> +	if (flags & RENAME_EXCHANGE)
> +		goto done;
> +
>   	if (!simple_empty(new_dentry))
>   		return -ENOTEMPTY;
>   
> @@ -472,6 +475,7 @@ int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
>   		inc_nlink(new_dir);
>   	}
>   
> +done:
>   	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
>   		new_dir->i_mtime = inode->i_ctime = current_time(old_dir);
>   
> 

