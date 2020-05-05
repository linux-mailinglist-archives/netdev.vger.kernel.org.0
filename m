Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B931C6127
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgEETiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:38:20 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6652 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgEETiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:38:19 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb1c09d0000>; Tue, 05 May 2020 12:38:05 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 05 May 2020 12:38:18 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 05 May 2020 12:38:18 -0700
Received: from [10.2.56.198] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 May
 2020 19:38:17 +0000
Subject: Re: [RFC] mm/gup.c: Updated return value of
 {get|pin}_user_pages_fast()
To:     Souptick Joarder <jrdr.linux@gmail.com>, <tony.luck@intel.com>,
        <fenghua.yu@intel.com>, <rspringer@google.com>,
        <toddpoynor@google.com>, <benchan@chromium.org>,
        <gregkh@linuxfoundation.org>, <jens.wiklander@linaro.org>,
        <akpm@linux-foundation.org>, <santosh.shilimkar@oracle.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jack@suse.cz>,
        <ira.weiny@intel.com>, <jglisse@redhat.com>
CC:     <inux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <tee-dev@lists.linaro.org>,
        <linux-mm@kvack.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>
References: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com>
Date:   Tue, 5 May 2020 12:38:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588707485; bh=PpKef4ceL5ARXGdqxSB6n13i/3UcgZwPiEix1It/ZkE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=f3UHEPPjBYIt8QMuA58LlhrYtukbZaR7vNiQYZd87MF9YUWZjW5zSihZn7XPS5agY
         APGOb4bhF7t9e0pWynEpNPQU0a6WqpxPVVhirYxBv3wb+A0ywitv43JhHF5cNerat+
         QEIFjRlIDDzZrxW0jgcvrewufvjPE6p8ve78/2ns1XISBdeIvuMz9MSvcjKLykVh9t
         Mr8bBVM0ibcpw2RbEY3wP1hCNs68WR7d8PjZykAzXIjaeGe4w2bgmpxec0Jc/wLptM
         4+mIJP+25o5v0se4Wcf8+T4xYVdXcfe9XcZg4Ou71c4HhKmWfN6lItTBpZIqEO1YmI
         8FeOhlFhyYhQQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-05 12:14, Souptick Joarder wrote:
> Currently {get|pin}_user_pages_fast() have 3 return value 0, -errno
> and no of pinned pages. The only case where these two functions will
> return 0, is for nr_pages <= 0, which doesn't find a valid use case.
> But if at all any, then a -ERRNO will be returned instead of 0, which
> means {get|pin}_user_pages_fast() will have 2 return values -errno &
> no of pinned pages.
> 
> Update all the callers which deals with return value 0 accordingly.

Hmmm, seems a little shaky. In order to do this safely, I'd recommend
first changing gup_fast/pup_fast so so that they return -EINVAL if
the caller specified nr_pages==0, and of course auditing all callers,
to ensure that this won't cause problems.

The gup.c documentation would also need updating in a couple of comment
blocks, above get_user_pages_remote(), and __get_user_pages(), because
those talk about a zero return value.

This might be practical without slowing down the existing code, because
there is already a check in place, so just tweaking it like this (untested)
won't change performance at all:

diff --git a/mm/gup.c b/mm/gup.c
index 11fda538c9d9..708eed79ae29 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2787,7 +2787,7 @@ static int internal_get_user_pages_fast(unsigned long start, 
int nr_pages,
         end = start + len;

         if (end <= start)
-               return 0;
+               return -EINVAL;
         if (unlikely(!access_ok((void __user *)start, len)))
                 return -EFAULT;

...although I might be missing some other things that need a similar change,
so you should look carefully for yourself.


Once that change (and anything I missed) is in place, then you could go
ahead and stop handling ret==0 cases at the call sites.


thanks,
-- 
John Hubbard
NVIDIA

> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>   arch/ia64/kernel/err_inject.c              | 2 +-
>   drivers/platform/goldfish/goldfish_pipe.c  | 2 +-
>   drivers/staging/gasket/gasket_page_table.c | 4 ++--
>   drivers/tee/tee_shm.c                      | 2 +-
>   mm/gup.c                                   | 6 +++---
>   net/rds/rdma.c                             | 2 +-
>   6 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/ia64/kernel/err_inject.c b/arch/ia64/kernel/err_inject.c
> index 8b5b8e6b..fd72218 100644
> --- a/arch/ia64/kernel/err_inject.c
> +++ b/arch/ia64/kernel/err_inject.c
> @@ -143,7 +143,7 @@ static DEVICE_ATTR(name, 0644, show_##name, store_##name)
>   	int ret;
>   
>   	ret = get_user_pages_fast(virt_addr, 1, FOLL_WRITE, NULL);
> -	if (ret<=0) {
> +	if (ret < 0) {
>   #ifdef ERR_INJ_DEBUG
>   		printk("Virtual address %lx is not existing.\n",virt_addr);
>   #endif
> diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
> index 1ab207e..831449d 100644
> --- a/drivers/platform/goldfish/goldfish_pipe.c
> +++ b/drivers/platform/goldfish/goldfish_pipe.c
> @@ -277,7 +277,7 @@ static int goldfish_pin_pages(unsigned long first_page,
>   	ret = pin_user_pages_fast(first_page, requested_pages,
>   				  !is_write ? FOLL_WRITE : 0,
>   				  pages);
> -	if (ret <= 0)
> +	if (ret < 0)
>   		return -EFAULT;
>   	if (ret < requested_pages)
>   		*iter_last_page_size = PAGE_SIZE;
> diff --git a/drivers/staging/gasket/gasket_page_table.c b/drivers/staging/gasket/gasket_page_table.c
> index f6d7157..1d08e1d 100644
> --- a/drivers/staging/gasket/gasket_page_table.c
> +++ b/drivers/staging/gasket/gasket_page_table.c
> @@ -489,11 +489,11 @@ static int gasket_perform_mapping(struct gasket_page_table *pg_tbl,
>   			ret = get_user_pages_fast(page_addr - offset, 1,
>   						  FOLL_WRITE, &page);
>   
> -			if (ret <= 0) {
> +			if (ret < 0) {
>   				dev_err(pg_tbl->device,
>   					"get user pages failed for addr=0x%lx, offset=0x%lx [ret=%d]\n",
>   					page_addr, offset, ret);
> -				return ret ? ret : -ENOMEM;
> +				return ret;
>   			}
>   			++pg_tbl->num_active_pages;
>   
> diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
> index bd679b7..2706a1f 100644
> --- a/drivers/tee/tee_shm.c
> +++ b/drivers/tee/tee_shm.c
> @@ -230,7 +230,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
>   	if (rc > 0)
>   		shm->num_pages = rc;
>   	if (rc != num_pages) {
> -		if (rc >= 0)
> +		if (rc > 0)
>   			rc = -ENOMEM;
>   		ret = ERR_PTR(rc);
>   		goto err;
> diff --git a/mm/gup.c b/mm/gup.c
> index 50681f0..8d293ed 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2760,7 +2760,7 @@ static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
>   	end = start + len;
>   
>   	if (end <= start)
> -		return 0;
> +		return -EINVAL;
>   	if (unlikely(!access_ok((void __user *)start, len)))
>   		return -EFAULT;
>   
> @@ -2805,8 +2805,8 @@ static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
>    * calling get_user_pages().
>    *
>    * Returns number of pages pinned. This may be fewer than the number requested.
> - * If nr_pages is 0 or negative, returns 0. If no pages were pinned, returns
> - * -errno.
> + * If nr_pages is 0 or negative, returns -errno. If no pages were pinned,
> + * returns -errno.
>    */
>   int get_user_pages_fast(unsigned long start, int nr_pages,
>   			unsigned int gup_flags, struct page **pages)
> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> index a7ae118..44b96e6 100644
> --- a/net/rds/rdma.c
> +++ b/net/rds/rdma.c
> @@ -161,7 +161,7 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
>   		gup_flags |= FOLL_WRITE;
>   
>   	ret = pin_user_pages_fast(user_addr, nr_pages, gup_flags, pages);
> -	if (ret >= 0 && ret < nr_pages) {
> +	if (ret > 0 && ret < nr_pages) {
>   		unpin_user_pages(pages, ret);
>   		ret = -EFAULT;
>   	}
> 

