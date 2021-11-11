Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273F144D944
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhKKPkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhKKPkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 10:40:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6AEF61354;
        Thu, 11 Nov 2021 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636645070;
        bh=2eA9iUlEuADj3BKv79QTkwIPPIXVJkqtUIRgA05qQ7Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jZa1Xdqy1yVWyMXxWQRZ7xUvjIAOObR/ZgrKMq2DOlWIA8LPA5jg9QSZrYkkkHkWt
         8vLFeGCH9PFULYPEj3XAcSoWCkwChpPuvogZAJoMzvjD2curjx38it0NY0tYvu+Usj
         Cs0T4NFdlNC2P5zn4Nq9xA7/AfVw99RUH0YHk85/b/nvvtkFp44QbEhDhTM/xdhCD4
         JVx9sJH6sxLPCC75QHzFYSivEVGbalqKvyWtiiw6Mey1l9gzswnv59am7Iz64dB/jE
         eLr6y1o6V/67eI3KduhD3THbtyAqtj+o09jMuDowVjvtzKdlRqhDYkt5A41h5kZo8d
         ki6n6nRQNeO/A==
Date:   Thu, 11 Nov 2021 07:37:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] amt: use cancel_delayed_work() instead of
 flush_delayed_work() in amt_fini()
Message-ID: <20211111073748.136d2e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211108145340.17208-1-ap420073@gmail.com>
References: <20211108145340.17208-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Nov 2021 14:53:40 +0000 Taehee Yoo wrote:
> When the amt module is being removed, it calls flush_delayed_work() to exit
> source_gc_wq. But it wouldn't be exited properly because the
> amt_source_gc_work(), which is the callback function of source_gc_wq
> internally calls mod_delayed_work() again.
> So, amt_source_gc_work() would be called after the amt module is removed.
> Therefore kernel panic would occur.
> In order to avoid it, cancel_delayed_work() should be used instead of
> flush_delayed_work().

Somehow I convinced myself this is correct but now I'm not sure, again.

> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index c384b2694f9e..47a04c330885 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -3286,7 +3286,7 @@ static void __exit amt_fini(void)
>  {
>  	rtnl_link_unregister(&amt_link_ops);
>  	unregister_netdevice_notifier(&amt_notifier_block);
> -	flush_delayed_work(&source_gc_wq);
> +	cancel_delayed_work(&source_gc_wq);

This doesn't guarantee that the work is not running _right_ now and
will re-arm itself on the next clock cycle, so to speak.

 CPU 0                      CPU 1
 -----                      -----

 worker gets the work
 clears pending
 work starts running
                            cancel_work
                            grabs pending
                            clears pending
 mod_delayed_work()

You need cancel_delayed_work_sync(), right?

>  	__amt_source_gc_work();
>  	destroy_workqueue(amt_wq);
>  }

