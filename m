Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33061D2481
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgENBNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgENBNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:13:24 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FB2205ED;
        Thu, 14 May 2020 01:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589418804;
        bh=E3TK4XJbiog9RqVvd1coo4BBYDYxNPOeooso1RPW9+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b38mEvyZRSzT8rHakz4cXiV/smUzpawoP/W25qu1jycv3OKF/Tee8zvKw12mAkxX2
         sMGDcbWVx9Rf4NXP29meINeTtJKaxPsH/WnZQ5G2Y/aMSZwnJKOW6PoAPJkE+Y4yEJ
         mgEjAnRg8ItCq5lHHZoRmJZSU0MdT1D0NFPbudbQ=
Date:   Thu, 14 May 2020 10:13:18 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/18] maccess: unify the probe kernel arch hooks
Message-Id: <20200514101318.1c14647e41b7038b99b91fcd@kernel.org>
In-Reply-To: <20200513160038.2482415-11-hch@lst.de>
References: <20200513160038.2482415-1-hch@lst.de>
        <20200513160038.2482415-11-hch@lst.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Wed, 13 May 2020 18:00:30 +0200
Christoph Hellwig <hch@lst.de> wrote:

> @@ -36,14 +50,20 @@ long __weak probe_kernel_read(void *dst, const void *src, size_t size)
>   * probe_kernel_read() suitable for use within regions where the caller
>   * already holds mmap_sem, or other locks which nest inside mmap_sem.
>   */
> -long __weak probe_kernel_read_strict(void *dst, const void *src, size_t size)
> -    __attribute__((alias("__probe_kernel_read")));
> +long probe_kernel_read_strict(void *dst, const void *src, size_t size)
> +{
> +	return __probe_kernel_read(dst, src, size, true);
> +}
>  
> -long __probe_kernel_read(void *dst, const void *src, size_t size)
> +static long __probe_kernel_read(void *dst, const void *src, size_t size,
> +		bool strict)
>  {
>  	long ret;
>  	mm_segment_t old_fs = get_fs();
>  
> +	if (!probe_kernel_read_allowed(dst, src, size, strict))
> +		return -EFAULT;

Could you make this return -ERANGE instead of -EFAULT so that
the caller can notice that the address might be user space?

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
