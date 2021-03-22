Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852D9345367
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhCVX4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:56:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55526 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCVXzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:55:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AA2424D24926B;
        Mon, 22 Mar 2021 16:55:29 -0700 (PDT)
Date:   Mon, 22 Mar 2021 16:55:26 -0700 (PDT)
Message-Id: <20210322.165526.2248035624466168840.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        groeck@google.com
Subject: Re: [PATCH net-next] net: set initial device refcount to 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210322182145.531377-1-eric.dumazet@gmail.com>
References: <20210322182145.531377-1-eric.dumazet@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 22 Mar 2021 16:55:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 22 Mar 2021 11:21:45 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> When adding CONFIG_PCPU_DEV_REFCNT, I forgot that the
> initial net device refcount was 0.
> 
> When CONFIG_PCPU_DEV_REFCNT is not set, this means
> the first dev_hold() triggers an illegal refcount
> operation (addition on 0)
> 
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 0 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0x128/0x1a4
> 
> Fix is to change initial (and final) refcount to be 1.
> 
> Also add a missing kerneldoc piece, as reported by
> Stephen Rothwell.
> 
> Fixes: 919067cc845f ("net: add CONFIG_PCPU_DEV_REFCNT")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Guenter Roeck <groeck@google.com>

This hunk:
> @@ -10682,6 +10682,9 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>  	dev->pcpu_refcnt = alloc_percpu(int);
>  	if (!dev->pcpu_refcnt)
>  		goto free_dev;
> +	dev_hold(dev);
> +#else
> +	refcount_set(&dev->dev_refcnt, 1);
>  #endif
>  
>  	if (dev_addr_init(dev))
 gets rejects in net-next.  Please respin.
 
