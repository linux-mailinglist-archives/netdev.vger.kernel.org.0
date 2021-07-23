Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D892D3D3A33
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 14:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhGWLrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 07:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234832AbhGWLra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 07:47:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445F860E8C;
        Fri, 23 Jul 2021 12:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627043284;
        bh=/hiAX5CAjW6tGqppGXooRjBKQ0fykryiFtk5xbyBL5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ClM4itRigdwhpcbeJosSM1hJJCQiYijXqEk3LxM+YdmuKWCUCH8IdiJ3lGbpzfxqk
         pKfgrap4urO1oNLjGhtL6LzgSoPdbAMSyC7MX78P4GauiCg7BAkp7g0FsrW3zmzHSu
         Qa81UgbMGcjw2Aec6h/anR3ek2259WbMVLoEl8Fj6PdPPQVQxZTSer39iDunDlczIh
         z5RcHqPDHG36E/W7yjtjNj0p7RDo+MM05X/GMNwaktWmWfb30fmsBlvHmjfMNK5Q2D
         zUWAc056lCBP08V5ucxzraP/HxeO6vzZLJ/dtbGWRefNf41WnzMMqHe4xEw7wWtS2H
         lRmfmeuW9OZ7A==
Date:   Fri, 23 Jul 2021 17:57:53 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        bjorn.andersson@sonymobile.com, courtney.cavin@sonymobile.com,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: qrtr: fix memory leak in qrtr_local_enqueue
Message-ID: <20210723122753.GA3739@thinkpad>
References: <20210722161625.6956-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722161625.6956-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 07:16:25PM +0300, Pavel Skripkin wrote:
> Syzbot reported memory leak in qrtr. The problem was in unputted
> struct sock. qrtr_local_enqueue() function calls qrtr_port_lookup()
> which takes sock reference if port was found. Then there is the following
> check:
> 
> if (!ipc || &ipc->sk == skb->sk) {
> 	...
> 	return -ENODEV;
> }
> 
> Since we should drop the reference before returning from this function and
> ipc can be non-NULL inside this if, we should add qrtr_port_put() inside
> this if.
> 
> Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
> Reported-and-tested-by: syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

It'd be good if this patch can be extended to fix one more corner case here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/qrtr/qrtr.c#n522

Thanks,
Mani

> ---
>  net/qrtr/qrtr.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index e6f4a6202f82..d5ce428d0b25 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -839,6 +839,8 @@ static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  
>  	ipc = qrtr_port_lookup(to->sq_port);
>  	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
> +		if (ipc)
> +			qrtr_port_put(ipc);
>  		kfree_skb(skb);
>  		return -ENODEV;
>  	}
> -- 
> 2.32.0
> 
