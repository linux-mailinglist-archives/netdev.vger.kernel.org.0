Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBF71AE49A
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgDQSRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730256AbgDQSRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 14:17:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA94C061A0C;
        Fri, 17 Apr 2020 11:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vy45WYyAvnWC++4r2BeTmRg1PjZyiSd0b2OnG2cNJU4=; b=sWz2kV2wssYwweQnlTwBuJKzyR
        7VUKhrbWXqHxSQj/1A0zpmh1Kqo3QLCka1o4544prwiy6c/4iHqUMzyGylYnt+McLHPs8lFc0/KpL
        hyIbBsAFXl6M0QCeXVxGYe5bPGGM8dg+ksbZyoZ+ydLz33z62TIdQqic2u3XvtzhXEJtO1cTsorjz
        sQPe/tkkyZEsFP757b455kygIg+AjxJSRfa+NbGYtL4e455Hu9kPaKsR4R9u5WmpmRav7TadG5cTF
        R1FweRHYUnu2ref+DlWyLZMyRGCveeIPeoUwv6K/TXltQHb6w67+NoaQ+dysV3SPmKrH2sx96sJgt
        tZbzUuXQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPVYE-0007Jp-SN; Fri, 17 Apr 2020 18:17:18 +0000
Date:   Fri, 17 Apr 2020 11:17:18 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 6/6] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200417181718.GN5820@bombadil.infradead.org>
References: <20200417064146.1086644-1-hch@lst.de>
 <20200417064146.1086644-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417064146.1086644-7-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 08:41:46AM +0200, Christoph Hellwig wrote:
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index b6f5d459b087..d5c9a9bf4e90 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -539,13 +539,13 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
>  	return err;
>  }
>  
> -static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
> +static ssize_t proc_sys_call_handler(struct file *filp, void __user *ubuf,
>  		size_t count, loff_t *ppos, int write)
>  {
>  	struct inode *inode = file_inode(filp);
>  	struct ctl_table_header *head = grab_header(inode);
>  	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
> -	void *new_buf = NULL;
> +	void *kbuf;
>  	ssize_t error;
>  
>  	if (IS_ERR(head))
> @@ -564,27 +564,36 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
>  	if (!table->proc_handler)
>  		goto out;
>  
> -	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, buf, &count,
> -					   ppos, &new_buf);
> +	if (write) {
> +		kbuf = memdup_user_nul(ubuf, count);
> +		if (IS_ERR(kbuf)) {
> +			error = PTR_ERR(kbuf);
> +			goto out;
> +		}
> +	} else {
> +		error = -ENOMEM;
> +		kbuf = kzalloc(count, GFP_KERNEL);
> +		if (!kbuf)
> +			goto out;
> +	}
> +
> +	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, &kbuf, &count,
> +					   ppos);
>  	if (error)
> -		goto out;
> +		goto out_free_buf;
>  
>  	/* careful: calling conventions are nasty here */

I think this comment can go now ;-)

> -	if (new_buf) {
> -		mm_segment_t old_fs;
> -
> -		old_fs = get_fs();
> -		set_fs(KERNEL_DS);
> -		error = table->proc_handler(table, write, (void __user *)new_buf,
> -					    &count, ppos);
> -		set_fs(old_fs);
> -		kfree(new_buf);
> -	} else {
> -		error = table->proc_handler(table, write, buf, &count, ppos);
> -	}
> +	error = table->proc_handler(table, write, kbuf, &count, ppos);
> +	if (error)
> +		goto out_free_buf;
> +
> +	error = -EFAULT;
> +	if (copy_to_user(ubuf, kbuf, count))
> +		goto out_free_buf;

Can we skip this if !write?  Indeed, don't we have to in case the user has
passed a pointer to a read-only memory page?

