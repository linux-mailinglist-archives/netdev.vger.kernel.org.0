Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E793934A477
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhCZJcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229773AbhCZJcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 05:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96A761A36;
        Fri, 26 Mar 2021 09:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616751120;
        bh=ubfXR8EL0Nl5t2d25uT9t1S9l5tjLbIQe0W8EAvq7No=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=isJSVcGvh/NE5+1o6I2m9d8Cb7Ui/S01Ynz/6l02kiouudbvkx0u8W5Noutb3ZGlV
         Vzw4HWKBjkOaBuEVK4BO4qKe2YdSwZ1b5Gnj5g6BBl3wNHCPMqC3w6RDKLWOv9OZcQ
         sz5DEsJVPkjbn3745PQIO+1nqNn0JaQrnCuVAd3g=
Date:   Fri, 26 Mar 2021 10:31:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: Re: [PATCH] net:qrtr: fix allocator flag of idr_alloc_u32() in
 qrtr_port_assign()
Message-ID: <YF2qDZkNpn8va28r@kroah.com>
References: <20210326033345.162531-1-ducheng2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326033345.162531-1-ducheng2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 11:33:45AM +0800, Du Cheng wrote:
> change the allocator flag of idr_alloc_u32 from GFP_ATOMIC to
> GFP_KERNEL, as GFP_ATOMIC caused BUG: "using smp_processor_id() in
> preemptible" as reported by syzkaller.
> 
> Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> Signed-off-by: Du Cheng <ducheng2@gmail.com>
> ---
> Hi David & Jakub,
> 
> Although this is a simple fix to make syzkaller happy, I feel that maybe a more
> proper fix is to convert qrtr_ports from using IDR to radix_tree (which is in
> fact xarray) ? 
> 
> I found some previous work done in 2019 by Matthew Wilcox:
> https://lore.kernel.org/netdev/20190820223259.22348-1-willy@infradead.org/t/#mcb60ad4c34e35a6183c7353c8a44ceedfcff297d
> but that was not merged as of now. My wild guess is that it was probably
> in conflicti with the conversion of radix_tree to xarray during 2020, and that
> might cause the direct use of xarray in qrtr.c unfavorable.
> 
> Shall I proceed with converting qrtr_pors to use radix_tree (or just xarray)?

Try it and see.  But how would that resolve this issue?  Those other
structures would also need to allocate memory at this point in time and
you need to tell it if it can sleep or not.

> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index edb6ac17ceca..ee42e1e1d4d4 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -722,17 +722,17 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
>  	mutex_lock(&qrtr_port_lock);
>  	if (!*port) {
>  		min_port = QRTR_MIN_EPH_SOCKET;
> -		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> +		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_KERNEL);

Are you sure that you can sleep in this code path?

thanks,

greg k-h
