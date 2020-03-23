Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C33218F084
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 09:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgCWIA3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Mar 2020 04:00:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43161 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgCWIA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 04:00:28 -0400
Received: by mail-lj1-f193.google.com with SMTP id g27so4611510ljn.10;
        Mon, 23 Mar 2020 01:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nn3jGhr8uNWeITwAtUjp7FuShYd1eeyyePwVyNZWbwQ=;
        b=KdyhA4LxbptrlfkY5fB6ViEDVaVfexWZnz01pi3THkzPXjPW5Cghfav7lJhH02d8zj
         HMDODST5Zj6gNL87ZlJivpxzHHn1SCnx7G2iv1zggZeHgXL7L4ypgzfU0Lt4jxUuxnbl
         5TankKqQtyHL3QrEIrYWYvwg1UfO6OQuuo3eYxhqBWOifsciMPrtRFuXVSIeVC8NquLx
         J1w9jilWO+O0fXqw9wdR2PKRVeuH72ljendUI53LMi5fU40x3GXfqRW9z98vxQC7r3bo
         HaBTDMQFyrr9vOVj3+yG+Gfnl/ImR8oydjtfD+wwjpHmuFJxRPYDuly2txuD54W3MR5/
         oxFg==
X-Gm-Message-State: ANhLgQ3S0aMEmitY/3xVJpehW3d64oMzq+Up6Ui0pEZhw6jgrbEp65Xb
        zBAyvwkDlsZ+XhjEKzoSfgA=
X-Google-Smtp-Source: ADFU+vu1Ai42/ka/sxlnk2Rib/+aMfnQsCfzDAsftUKEzVNNv/FrpkwB+zryC+afi57yS4g05T6XnQ==
X-Received: by 2002:a2e:9852:: with SMTP id e18mr12883378ljj.249.1584950425030;
        Mon, 23 Mar 2020 01:00:25 -0700 (PDT)
Received: from vostro.wlan (dty2hzyyyyyyyyyyyyx9y-3.rev.dnainternet.fi. [2001:14ba:802c:6a00::4fa])
        by smtp.gmail.com with ESMTPSA id 15sm7799287lfr.17.2020.03.23.01.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 01:00:24 -0700 (PDT)
Date:   Mon, 23 Mar 2020 10:00:21 +0200
From:   Timo Teras <timo.teras@iki.fi>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Message-ID: <20200323100021.05d68204@vostro.wlan>
In-Reply-To: <20200323073239.59000-1-yuehaibing@huawei.com>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
        <20200323073239.59000-1-yuehaibing@huawei.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-alpine-linux-musl)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 15:32:39 +0800
YueHaibing <yuehaibing@huawei.com> wrote:

> After xfrm_add_policy add a policy, its ref is 2, then
> 
>                              xfrm_policy_timer
>                                read_lock
>                                xp->walk.dead is 0
>                                ....
>                                mod_timer()
> xfrm_policy_kill
>   policy->walk.dead = 1
>   ....
>   del_timer(&policy->timer)
>     xfrm_pol_put //ref is 1
>   xfrm_pol_put  //ref is 0
>     xfrm_policy_destroy
>       call_rcu
>                                  xfrm_pol_hold //ref is 1
>                                read_unlock
>                                xfrm_pol_put //ref is 0
>                                  xfrm_policy_destroy
>                                   call_rcu
> 
> xfrm_policy_destroy is called twice, which may leads to
> double free.
> 
> Call Trace:
> RIP: 0010:refcount_warn_saturate+0x161/0x210
> ...
>  xfrm_policy_timer+0x522/0x600
>  call_timer_fn+0x1b3/0x5e0
>  ? __xfrm_decode_session+0x2990/0x2990
>  ? msleep+0xb0/0xb0
>  ? _raw_spin_unlock_irq+0x24/0x40
>  ? __xfrm_decode_session+0x2990/0x2990
>  ? __xfrm_decode_session+0x2990/0x2990
>  run_timer_softirq+0x5c5/0x10e0
> 
> Fix this by use write_lock_bh in xfrm_policy_kill.
> 
> Fixes: ea2dea9dacc2 ("xfrm: remove policy lock when accessing policy->walk.dead")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Timo Teräs <timo.teras@iki.fi>

> ---
> v3: Only lock 'policy->walk.dead'
> v2: Fix typo 'write_lock_bh'--> 'write_unlock_bh' while unlocking
> ---
>  net/xfrm/xfrm_policy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index dbda08ec566e..8a4af86a285e 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -434,7 +434,9 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
>  
>  static void xfrm_policy_kill(struct xfrm_policy *policy)
>  {
> +	write_lock_bh(&policy->lock);
>  	policy->walk.dead = 1;
> +	write_unlock_bh(&policy->lock);
>  
>  	atomic_inc(&policy->genid);
>  
> -- 
> 2.17.1
> 
> 
