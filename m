Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D742C149A4C
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 12:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgAZLBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 06:01:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56104 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgAZLBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 06:01:03 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D2E5151F95F9;
        Sun, 26 Jan 2020 03:01:01 -0800 (PST)
Date:   Sun, 26 Jan 2020 12:00:59 +0100 (CET)
Message-Id: <20200126.120059.1968749784775179465.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, sgoutham@marvell.com,
        gakula@marvell.com
Subject: Re: [PATCH v5 04/17] octeontx2-pf: Initialize and config queues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579887955-22172-5-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579887955-22172-5-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Jan 2020 03:01:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Fri, 24 Jan 2020 23:15:42 +0530

> @@ -184,6 +192,72 @@ static inline void otx2_mbox_unlock(struct mbox *mbox)
>  	mutex_unlock(&mbox->lock);
>  }
>  
> +/* With the absence of API for 128-bit IO memory access for arm64,
> + * implement required operations at place.
> + */
> +#if defined(CONFIG_ARM64)
> +static inline void otx2_write128(u64 lo, u64 hi, void __iomem *addr)
> +{
> +	__asm__ volatile("stp %x[x0], %x[x1], [%x[p1],#0]!"
> +			 ::[x0]"r"(lo), [x1]"r"(hi), [p1]"r"(addr));
> +}
> +
> +static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
> +{
> +	u64 result;
> +
> +	__asm__ volatile(".cpu   generic+lse\n"
> +			 "ldadd %x[i], %x[r], [%[b]]"
> +			 : [r]"=r"(result), "+m"(*ptr)
> +			 : [i]"r"(incr), [b]"r"(ptr)
> +			 : "memory");
> +	return result;
> +}
> +
> +#else
> +#define otx2_write128(lo, hi, addr)
> +#define otx2_atomic64_add(incr, ptr)		({ *ptr = incr; })
> +#endif

So what exactly is going on here?  Are these true 128-bit writes
and atomic operations?  Why is it named atomic64 then?  Why can't
the normal atomic64 kernel interfaces be used?

Finally why is the #else case doing an assignment to *ptr rather
than an increment like "*ptr += incr;"?
