Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40ECD4B2094
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348179AbiBKIuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:50:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBKIt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:49:58 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6687E8A;
        Fri, 11 Feb 2022 00:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644569397; x=1676105397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=852yCQeyi6TTe+G3DozY7ao5wBPlsQfmMMcR8YALnuw=;
  b=JLT4c39Wv9SeFkvfPtKVeByq+Oh0c2jqPumnWvPG3HO6C6s0fcceB/F1
   xJ+s6PTDnaxrcFetz4b0fduZO3msH0jNgS+weM7SNWxqSQsGEvkhmYCSP
   Be4Fds4terCg7YWSzC1jSBHUg7k4F8JBBcOg5IkX0ahBajbLGSaUvzuvq
   EtGJZOZZKoYRZtqs5NZkqM8aeg29MciSQ3Rd5QGliHMya7SUflC1xrV+X
   O0lvM41z4SSgyP6fMrVAm7eUeJu4mN4p64nOzReupBK4yT6OeV77MQYlL
   KPh2Wn3QqFM2U9PxpxKZD9wAc1BXMwZuRUEb30mjLAxKimyJY2wvc51T9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="312974539"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="312974539"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 00:49:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="630166731"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 00:49:52 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nIRbq-003NFF-R8;
        Fri, 11 Feb 2022 10:48:54 +0200
Date:   Fri, 11 Feb 2022 10:48:54 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 05/49] qed: rework qed_rdma_bmap_free()
Message-ID: <YgYi9p7oeR1NAKzv@smile.fi.intel.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
 <20220210224933.379149-6-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210224933.379149-6-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 02:48:49PM -0800, Yury Norov wrote:
> qed_rdma_bmap_free() is mostly an opencoded version of printk("%*pb").
> Using %*pb format simplifies the code, and helps to avoid inefficient
> usage of bitmap_weight().
> 
> While here, reorganize logic to avoid calculating bmap weight if check
> is false.

I like this kind of patches,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
> 
> This is RFC because it changes lines printing format to bitmap %*pb. If
> it hurts userspace, it's better to drop the patch.

How? The only way is some strange script that parses dmesg, but dmesg almost
never was an ABI, moreover, with printk() indexing feature (recently
introduced) the one who parses such messages can actually find the (new)
format as well.

>  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 45 +++++++---------------
>  1 file changed, 14 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> index 23b668de4640..f4c04af9d4dd 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> @@ -319,44 +319,27 @@ static int qed_rdma_alloc(struct qed_hwfn *p_hwfn)
>  void qed_rdma_bmap_free(struct qed_hwfn *p_hwfn,
>  			struct qed_bmap *bmap, bool check)
>  {
> -	int weight = bitmap_weight(bmap->bitmap, bmap->max_count);
> -	int last_line = bmap->max_count / (64 * 8);
> -	int last_item = last_line * 8 +
> -	    DIV_ROUND_UP(bmap->max_count % (64 * 8), 64);
> -	u64 *pmap = (u64 *)bmap->bitmap;
> -	int line, item, offset;
> -	u8 str_last_line[200] = { 0 };
> -
> -	if (!weight || !check)
> +	unsigned int bit, weight, nbits;
> +	unsigned long *b;
> +
> +	if (!check)
> +		goto end;
> +
> +	weight = bitmap_weight(bmap->bitmap, bmap->max_count);
> +	if (!weight)
>  		goto end;
>  
>  	DP_NOTICE(p_hwfn,
>  		  "%s bitmap not free - size=%d, weight=%d, 512 bits per line\n",
>  		  bmap->name, bmap->max_count, weight);
>  
> -	/* print aligned non-zero lines, if any */
> -	for (item = 0, line = 0; line < last_line; line++, item += 8)
> -		if (bitmap_weight((unsigned long *)&pmap[item], 64 * 8))
> +	for (bit = 0; bit < bmap->max_count; bit += 512) {
> +		b =  bmap->bitmap + BITS_TO_LONGS(bit);
> +		nbits = min(bmap->max_count - bit, 512);
> +
> +		if (!bitmap_empty(b, nbits))
>  			DP_NOTICE(p_hwfn,
> -				  "line 0x%04x: 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx\n",
> -				  line,
> -				  pmap[item],
> -				  pmap[item + 1],
> -				  pmap[item + 2],
> -				  pmap[item + 3],
> -				  pmap[item + 4],
> -				  pmap[item + 5],
> -				  pmap[item + 6], pmap[item + 7]);
> -
> -	/* print last unaligned non-zero line, if any */
> -	if ((bmap->max_count % (64 * 8)) &&
> -	    (bitmap_weight((unsigned long *)&pmap[item],
> -			   bmap->max_count - item * 64))) {
> -		offset = sprintf(str_last_line, "line 0x%04x: ", line);
> -		for (; item < last_item; item++)
> -			offset += sprintf(str_last_line + offset,
> -					  "0x%016llx ", pmap[item]);
> -		DP_NOTICE(p_hwfn, "%s\n", str_last_line);
> +				  "line 0x%04x: %*pb\n", bit / 512, nbits, b);
>  	}
>  
>  end:
> -- 
> 2.32.0
> 

-- 
With Best Regards,
Andy Shevchenko


