Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6017D34EF0A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbhC3RKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhC3RJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 13:09:59 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62DDC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 10:09:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f10so12161575pgl.9
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 10:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dNAX4yUhihJ7q4P1YX3kbGZXIV8ENHRCVK9SMNN3SMI=;
        b=QgRYxEWdOWcLVpQRhxgtRzjwWyvPY4GmsNVM9CgAMZfxZJ8I7vKGtKDmQ+Qi8kf0aK
         2Jo96l5d/kCrdi5C2pjxzByCkQehIiAsQpv82/CvF619RVfiud/6fZjHlgfjyj8i/f9D
         dmmwzhe/0geSc0C0ELVJ7vWwfjfDJxjPA1c/tVCe9HOnHwbOONUN5/1PuVtyMbROJOc8
         q3fiC6ou7W0zy0r046Mf5ek1lVxM993vCcUF0Nf16UA8AoXJIjS2XVdYPYdAvXkn6Wds
         CKVZYIZPKw50xMezOtV9PHJdimlbqPlfehZalbLlf4zhsIjIzkCu9oCT4okuvf52TkZJ
         BcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dNAX4yUhihJ7q4P1YX3kbGZXIV8ENHRCVK9SMNN3SMI=;
        b=XYZ7S6P0gTUjEk9MEdQaJv206SFVl7t6ANqduub8vYYcVhcutcqGdrE+GjZvJzEfe2
         QY4k3lvPkplKR8/5k5VcckeKN+k7ARgcxne94zLL+hF/5/HIG8ZbJlokWMvPLKHdU3/W
         JI4Th2DzLY2ssMbhA5l4AKmJyw01kSqeYBngZUxNQGByUMDRPjNwzzbQVEv/cHDlshRC
         76ZaNx8CyIQk5wBQEKtM+smgQ0jzts4Jc9ua76mARxayEZybFpROqi3hYpABkBq7s0aQ
         sb8OqCZw8TUVutyf24OJjdft+XxUkTTZwsiQxarWOhzsFVClXs0IIMEmsi/QUzP1lMBR
         vLhA==
X-Gm-Message-State: AOAM533N75gUN53sdrSNGYiQjB74/6MklC4AfOHLwfljPO+3vNAl8tYl
        twZp7oqkD1pVJypPVw2NExZy
X-Google-Smtp-Source: ABdhPJwFLxuCmnN19HuK/cai+8x731ps3lz+fvkNHQEZE2zTK+6ohP1sw5Zsbf5s0nBS4dTSaGYuTw==
X-Received: by 2002:aa7:8187:0:b029:213:d43b:4782 with SMTP id g7-20020aa781870000b0290213d43b4782mr30345684pfi.26.1617124198280;
        Tue, 30 Mar 2021 10:09:58 -0700 (PDT)
Received: from work ([103.77.37.178])
        by smtp.gmail.com with ESMTPSA id x69sm20862539pfd.161.2021.03.30.10.09.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Mar 2021 10:09:57 -0700 (PDT)
Date:   Tue, 30 Mar 2021 22:39:54 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, bjorn.andersson@linaro.org,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: qrtr: Fix memory leak on qrtr_tx_wait failure
Message-ID: <20210330170954.GA27256@work>
References: <1617113468-19222-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617113468-19222-1-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 04:11:08PM +0200, Loic Poulain wrote:
> qrtr_tx_wait does not check for radix_tree_insert failure, causing
> the 'flow' object to be unreferenced after qrtr_tx_wait return. Fix
> that by releasing flow on radix_tree_insert failure.
> 
> Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
> Reported-by: syzbot+739016799a89c530b32a@syzkaller.appspotmail.com
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  net/qrtr/qrtr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index f4ab3ca6..a01b50c7 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -271,7 +271,10 @@ static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
>  		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
>  		if (flow) {
>  			init_waitqueue_head(&flow->resume_tx);
> -			radix_tree_insert(&node->qrtr_tx_flow, key, flow);
> +			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
> +				kfree(flow);
> +				flow = NULL;
> +			}
>  		}
>  	}
>  	mutex_unlock(&node->qrtr_tx_lock);
> -- 
> 2.7.4
> 
