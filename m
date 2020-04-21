Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C171B2FE8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgDUTQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:16:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49856 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgDUTQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:16:26 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQyNT-007mDc-HD; Tue, 21 Apr 2020 19:16:15 +0000
Date:   Tue, 21 Apr 2020 20:16:15 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 5/5] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200421191615.GE23230@ZenIV.linux.org.uk>
References: <20200421171539.288622-1-hch@lst.de>
 <20200421171539.288622-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421171539.288622-6-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 07:15:39PM +0200, Christoph Hellwig wrote:
> Instead of having all the sysctl handlers deal with user pointers, which
> is rather hairy in terms of the BPF interaction, copy the input to and
> from  userspace in common code.  This also means that the strings are
> always NUL-terminated by the common code, making the API a little bit
> safer.
> 
> As most handler just pass through the data to one of the common handlers
> a lot of the changes are mechnical.

> @@ -564,27 +564,38 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
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

Better allocate count + 1 bytes here, that way a lot of insanity in the
instances can be simply converted to snprintf().  Yes, I know it'll bring
the Church Of Avoiding The Abomination Of Sprintf out of the woodwork,
but...
