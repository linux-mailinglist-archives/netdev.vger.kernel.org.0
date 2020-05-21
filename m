Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F41DD34A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 18:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgEUQsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 12:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgEUQsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 12:48:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09F1C061A0E;
        Thu, 21 May 2020 09:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Z9SDQmK+aRv72gsSrNGRkJnHT0sGou9YYaeaGmP4Szw=; b=GoWZPMGDWaQrX1Az0wwnGx/5+W
        cBYWa07dN3dvBMADteOKfFxw/U9b2BBVksm/R7ukLb1M6sKZhYBy0DBdHa+JV3dHw7CsfMdCCTQi6
        c1KoXreEu2NfbBXG44aB6N9hc+mtUoNm1dm7c+Ri0DP1g1exHgwSRq5kcXRh52pUKGmBT9Etl6xez
        7uxyD6d0eewGXATwsTzRds25VNDXD8m8o3tEtgbWkFNKvAMq/QXaASkKehXCxXOzhH9PCi9WvXETc
        q/9r6OZUYLBBf6JgzhzD9SPrFhk0GZAqYbLgaeW0yvEoefX2WVEW9cFzvqewdBMFLG0jMT6W913kB
        XetKZaHw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jboME-000092-Ey; Thu, 21 May 2020 16:47:46 +0000
Date:   Thu, 21 May 2020 09:47:46 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     adobriyan@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        ebiederm@xmission.com, bernd.edlinger@hotmail.de,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] files: Use rcu lock to get the file structures for
 better performance
Message-ID: <20200521164746.GD28818@bombadil.infradead.org>
References: <20200521123835.70069-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521123835.70069-1-songmuchun@bytedance.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 08:38:35PM +0800, Muchun Song wrote:
> +++ b/fs/proc/fd.c
> @@ -34,19 +34,27 @@ static int seq_show(struct seq_file *m, void *v)
>  	if (files) {
>  		unsigned int fd = proc_fd(m->private);
>  
> -		spin_lock(&files->file_lock);
> +		rcu_read_lock();
> +again:
>  		file = fcheck_files(files, fd);
>  		if (file) {
> -			struct fdtable *fdt = files_fdtable(files);
> +			struct fdtable *fdt;
> +
> +			if (!get_file_rcu(file)) {
> +				/*
> +				 * we loop to catch the new file (or NULL
> +				 * pointer).
> +				 */
> +				goto again;
> +			}
>  
> +			fdt = files_fdtable(files);

This is unusual, and may not be safe.

fcheck_files() loads files->fdt.  Then it loads file from fdt->fd[].
Now you're loading files->fdt again here, and it could have been changed
by another thread expanding the fd table.

You have to write a changelog which convinces me you've thought about
this race and that it's safe.  Because I don't think you even realise
it's a possibility at this point.

> @@ -160,14 +168,23 @@ static int proc_fd_link(struct dentry *dentry, struct path *path)
>  		unsigned int fd = proc_fd(d_inode(dentry));
>  		struct file *fd_file;
>  
> -		spin_lock(&files->file_lock);
> +		rcu_read_lock();
> +again:
>  		fd_file = fcheck_files(files, fd);
>  		if (fd_file) {
> +			if (!get_file_rcu(fd_file)) {
> +				/*
> +				 * we loop to catch the new file
> +				 * (or NULL pointer).
> +				 */
> +				goto again;
> +			}
>  			*path = fd_file->f_path;
>  			path_get(&fd_file->f_path);
> +			fput(fd_file);
>  			ret = 0;
>  		}
> -		spin_unlock(&files->file_lock);
> +		rcu_read_unlock();

Why is it an improvement to increment/decrement the refcount on the
struct file here, rather than take/release the spinlock?

