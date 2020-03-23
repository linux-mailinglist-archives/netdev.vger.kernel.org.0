Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297D718EFF2
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 07:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgCWGxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 02:53:18 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40684 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgCWGxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 02:53:18 -0400
Received: by mail-lj1-f196.google.com with SMTP id 19so13234286ljj.7;
        Sun, 22 Mar 2020 23:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WoCr+foN/8GXkw0Qp+PYNvYpbwWofyuyqb/3wF5oAQ0=;
        b=fSiqCnw2zf7Vld1iihjA7bFiyJXfTMXjjEU4RF1bFNrlP2PuAI/99WtEG3Tq9MEHpU
         E7XaUY18NOg+ce1MTp4eMf6Db6qMABa0vUbxwixu0Pp/698GsouKtQG5R7odxqUjI0ak
         Lb/hrAHnvLyhOV3IquC3/ff76S9bolL7qTr2h0DgIByJf6u+elNU5nC3Tf0f/iFuRMok
         PH6Ytzf/o1UadY6u9QiMpXl5orrwFS2pXKm4DiJZtbilBuf2bwH1cbxAPy+hHSqkML4u
         +QfdkNI80F2VsvNyZfLcxnNy/tyrazrpjGvgHimGvJrRI7FjyqQFK2vwBRDFvGWsL8/L
         Dt/g==
X-Gm-Message-State: ANhLgQ1G3V0YXn+358cXlH8HPHktW+m94kt4PAEMNLn7J+pJHuM234a0
        c/c7BWDz/knW7FZ8WBjvp+g=
X-Google-Smtp-Source: ADFU+vuMZue8vK66PxCV4QGppTqpco/74F7mHnAgQ3DaTqBb9cApDot3ZuKGv2VLiCHt6BdNejomVg==
X-Received: by 2002:a2e:a401:: with SMTP id p1mr12840290ljn.106.1584946395170;
        Sun, 22 Mar 2020 23:53:15 -0700 (PDT)
Received: from vostro.wlan (dty2hzyyyyyyyyyyyyx9y-3.rev.dnainternet.fi. [2001:14ba:802c:6a00::4fa])
        by smtp.gmail.com with ESMTPSA id o2sm3976447ljm.2.2020.03.22.23.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 23:53:14 -0700 (PDT)
Date:   Mon, 23 Mar 2020 08:53:11 +0200
From:   Timo Teras <timo.teras@iki.fi>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Message-ID: <20200323085311.35aefe10@vostro.wlan>
In-Reply-To: <20200323014155.56376-1-yuehaibing@huawei.com>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
        <20200323014155.56376-1-yuehaibing@huawei.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-alpine-linux-musl)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On Mon, 23 Mar 2020 09:41:55 +0800
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

I believe the timer changes were added later in commit e7d8f6cb2f which
added holding a reference when timer is running. I think it fails to
properly account for concurrently running timer in xfrm_policy_kill().

The time when commit ea2dea9dacc2 was done this was not the case.

I think it would be preferable if the concurrency issue could be solved
without additional locking.

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
> Fixes: ea2dea9dacc2 ("xfrm: remove policy lock when accessing
> policy->walk.dead") Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Should be instead:
Fixes: e7d8f6cb2f ("xfrm: Add refcount handling to queued policies")

> ---
> v2:  Fix typo 'write_lock_bh'--> 'write_unlock_bh' while unlocking
> ---
>  net/xfrm/xfrm_policy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index dbda08ec566e..ae0689174bbf 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -434,6 +434,7 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
>  
>  static void xfrm_policy_kill(struct xfrm_policy *policy)
>  {
> +	write_lock_bh(&policy->lock);
>  	policy->walk.dead = 1;
>  
>  	atomic_inc(&policy->genid);
> @@ -445,6 +446,7 @@ static void xfrm_policy_kill(struct xfrm_policy
> *policy) if (del_timer(&policy->timer))
>  		xfrm_pol_put(policy);
>  
> +	write_unlock_bh(&policy->lock);
>  	xfrm_pol_put(policy);
>  }
>  

