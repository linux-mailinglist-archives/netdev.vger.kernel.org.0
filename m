Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A7C18F07F
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 08:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgCWH4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 03:56:54 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39960 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbgCWH4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 03:56:54 -0400
Received: by mail-lj1-f195.google.com with SMTP id 19so13393245ljj.7;
        Mon, 23 Mar 2020 00:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RxozTuwl/55ffhZ3F6euP3e/uvA+foyXaasqGP7bLks=;
        b=ua9pUQr58uwOlj6bUpsZjTfOj8sUfMPvzYRyXoOE3grAK1UJRxGmoElzuNf4gwo3r7
         KleHWcM7f9DwMvH3EnZJsRbvZXYDRkQ2nhielpcXdUdLs7dqwzJkXcs4lTZJ4wdGa9oJ
         jvrkAZUDOq4SbsxTNqxVftXRWwHyi5qKnCFtI9NV3CXweVGEUcgwFPJfWpadKsNevIZO
         NHohR1V+6H+i1x9afidKKNd06xGDYzqmoUI/eC7gQwYYK54VwT6v19LEGDRDadWr+Nal
         5iOaToYJ5u6pjMWeiwiVn9oXVmqSgGbQcHtDIpHgYNZD8lwyg0qcKUdcIDxPYHZvHVIj
         wcjw==
X-Gm-Message-State: ANhLgQ0sf2mxdoGmyvxigYgjL6kg4EGgcpNerpXA0ONRDJF1sGkxwHQc
        qS16T5hHf94tyfOxZMY6nbw=
X-Google-Smtp-Source: ADFU+vtod+jh8V/kDT8EsN3R9hoSknSBGekIOO1dtsQEEKSU+RJaK7NHTKerdyEzAWAwpinBCBKVAw==
X-Received: by 2002:a2e:b804:: with SMTP id u4mr3537196ljo.159.1584950211373;
        Mon, 23 Mar 2020 00:56:51 -0700 (PDT)
Received: from vostro.wlan (dty2hzyyyyyyyyyyyyx9y-3.rev.dnainternet.fi. [2001:14ba:802c:6a00::4fa])
        by smtp.gmail.com with ESMTPSA id f16sm8024546ljj.34.2020.03.23.00.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 00:56:51 -0700 (PDT)
Date:   Mon, 23 Mar 2020 09:56:47 +0200
From:   Timo Teras <timo.teras@iki.fi>
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Message-ID: <20200323095647.5e93ffd2@vostro.wlan>
In-Reply-To: <832e03ea-2511-eb7f-49d1-3cda6c9e6d18@huawei.com>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
        <20200323014155.56376-1-yuehaibing@huawei.com>
        <20200323085311.35aefe10@vostro.wlan>
        <832e03ea-2511-eb7f-49d1-3cda6c9e6d18@huawei.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-alpine-linux-musl)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 15:21:45 +0800
Yuehaibing <yuehaibing@huawei.com> wrote:

> On 2020/3/23 14:53, Timo Teras wrote:
> > Hi
> > 
> > On Mon, 23 Mar 2020 09:41:55 +0800
> > YueHaibing <yuehaibing@huawei.com> wrote:
> >   
> >> After xfrm_add_policy add a policy, its ref is 2, then
> >>
> >>                              xfrm_policy_timer
> >>                                read_lock
> >>                                xp->walk.dead is 0
> >>                                ....
> >>                                mod_timer()
> >> xfrm_policy_kill
> >>   policy->walk.dead = 1
> >>   ....
> >>   del_timer(&policy->timer)
> >>     xfrm_pol_put //ref is 1
> >>   xfrm_pol_put  //ref is 0
> >>     xfrm_policy_destroy
> >>       call_rcu
> >>                                  xfrm_pol_hold //ref is 1
> >>                                read_unlock
> >>                                xfrm_pol_put //ref is 0
> >>                                  xfrm_policy_destroy
> >>                                   call_rcu
> >>
> >> xfrm_policy_destroy is called twice, which may leads to
> >> double free.  
> > 
> > I believe the timer changes were added later in commit e7d8f6cb2f
> > which added holding a reference when timer is running. I think it
> > fails to properly account for concurrently running timer in
> > xfrm_policy_kill().  
> 
> commit e7d8f6cb2f hold a reference when &pq->hold_timer is armed,
> in my case, it's policy->timer, and hold_timer is not armed.

Ah, misread. Should have waited until first cup of coffee of the
morning..

I must have not understood del_timer() return value fully back then.

I first thought a more robust fix would be to take an extra reference
in the beginning of the timer function (and instead of using mod_timer()
return to see if a new reference is needed, it could be used in the
prologue to "keep" the reference). This would guarantee always proper
reference count inside the timer function.

But I suppose because of the above xfrm_policy_kill() is the only place
supposed to delete the timer, and that's why it had the locking in the
first place. And the above "fix" might still end up having timer armed
after kill_policy called del_timer() which is wrong.

So perhaps it's more straightforward to just have the lock as it was
originally around policy->walk.dead only. Perhaps adding a comment that
it's synchronizing with the timer function.

Since xfrm_policy_timer() ends with policy unref already now, the above
reference keeping tricking might be good to do even for the current
code as separate patch to avoid atomic ops if possible.

Thanks,
Timo
