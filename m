Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ABF43FF78
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhJ2PbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:31:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:56324 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJ2PbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:31:02 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mgTnm-000DRl-Hy; Fri, 29 Oct 2021 17:28:18 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mgTnm-00091V-8q; Fri, 29 Oct 2021 17:28:18 +0200
Subject: Re: [PATCH bpf-next v3 1/4] libfs: move shmem_exchange to
 simple_rename_exchange
To:     Lorenz Bauer <lmb@cloudflare.com>, viro@zeniv.linux.org.uk,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     mszeredi@redhat.com, gregkh@linuxfoundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211028094724.59043-1-lmb@cloudflare.com>
 <20211028094724.59043-2-lmb@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0c957c87-cfd1-fceb-ce18-54274eee9fc2@iogearbox.net>
Date:   Fri, 29 Oct 2021 17:28:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211028094724.59043-2-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26337/Fri Oct 29 10:19:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/21 11:47 AM, Lorenz Bauer wrote:
> Move shmem_exchange and make it available to other callers.
> 
> Suggested-by: <mszeredi@redhat.com>

nit: Should say proper name, but we can fix it up while applying.

Miklos, does the below look good to you? Would be good to have an ACK from fs
folks before applying, please take a look if you have a chance. Thanks!

> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>   fs/libfs.c         | 24 ++++++++++++++++++++++++
>   include/linux/fs.h |  2 ++
>   mm/shmem.c         | 24 +-----------------------
>   3 files changed, 27 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 51b4de3b3447..1cf144dc9ed2 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -448,6 +448,30 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
>   }
>   EXPORT_SYMBOL(simple_rmdir);
>   
> +int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
> +			   struct inode *new_dir, struct dentry *new_dentry)
> +{
> +	bool old_is_dir = d_is_dir(old_dentry);
> +	bool new_is_dir = d_is_dir(new_dentry);
> +
> +	if (old_dir != new_dir && old_is_dir != new_is_dir) {
> +		if (old_is_dir) {
> +			drop_nlink(old_dir);
> +			inc_nlink(new_dir);
> +		} else {
> +			drop_nlink(new_dir);
> +			inc_nlink(old_dir);
> +		}
> +	}
> +	old_dir->i_ctime = old_dir->i_mtime =
> +	new_dir->i_ctime = new_dir->i_mtime =
> +	d_inode(old_dentry)->i_ctime =
> +	d_inode(new_dentry)->i_ctime = current_time(old_dir);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(simple_rename_exchange);
> +
>   int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
>   		  struct dentry *old_dentry, struct inode *new_dir,
>   		  struct dentry *new_dentry, unsigned int flags)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e7a633353fd2..333b8af405ce 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3383,6 +3383,8 @@ extern int simple_open(struct inode *inode, struct file *file);
>   extern int simple_link(struct dentry *, struct inode *, struct dentry *);
>   extern int simple_unlink(struct inode *, struct dentry *);
>   extern int simple_rmdir(struct inode *, struct dentry *);
> +extern int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
> +				  struct inode *new_dir, struct dentry *new_dentry);
>   extern int simple_rename(struct user_namespace *, struct inode *,
>   			 struct dentry *, struct inode *, struct dentry *,
>   			 unsigned int);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b5860f4a2738..a18dde3d3092 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2945,28 +2945,6 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
>   	return shmem_unlink(dir, dentry);
>   }
>   
> -static int shmem_exchange(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
> -{
> -	bool old_is_dir = d_is_dir(old_dentry);
> -	bool new_is_dir = d_is_dir(new_dentry);
> -
> -	if (old_dir != new_dir && old_is_dir != new_is_dir) {
> -		if (old_is_dir) {
> -			drop_nlink(old_dir);
> -			inc_nlink(new_dir);
> -		} else {
> -			drop_nlink(new_dir);
> -			inc_nlink(old_dir);
> -		}
> -	}
> -	old_dir->i_ctime = old_dir->i_mtime =
> -	new_dir->i_ctime = new_dir->i_mtime =
> -	d_inode(old_dentry)->i_ctime =
> -	d_inode(new_dentry)->i_ctime = current_time(old_dir);
> -
> -	return 0;
> -}
> -
>   static int shmem_whiteout(struct user_namespace *mnt_userns,
>   			  struct inode *old_dir, struct dentry *old_dentry)
>   {
> @@ -3012,7 +2990,7 @@ static int shmem_rename2(struct user_namespace *mnt_userns,
>   		return -EINVAL;
>   
>   	if (flags & RENAME_EXCHANGE)
> -		return shmem_exchange(old_dir, old_dentry, new_dir, new_dentry);
> +		return simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
>   
>   	if (!simple_empty(new_dentry))
>   		return -ENOTEMPTY;
> 

