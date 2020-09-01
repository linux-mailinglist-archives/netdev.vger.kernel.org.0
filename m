Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B785258879
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 08:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgIAGsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 02:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgIAGsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 02:48:17 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E6EC0612AC;
        Mon, 31 Aug 2020 23:48:16 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id b79so23782wmb.4;
        Mon, 31 Aug 2020 23:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P0AD1Y/Lrkza56GStpxrrisnFk/Rh5ZF4KO+s+OS1N0=;
        b=dQMYLRr+HeQrqvZ37hOut1a1wWXhuuNN4Ee2sj3VBzJtz6tiT5TVc0+RPU4ZPnuRBz
         NzXPFyQZydzGs4vb8iHNqgZnK8ZlhVHCJpvgm3Dhp37Bs+w189HnBzkVv6YqZgaDHW8C
         8PCUS8+UvaLbaWaYmg3cSOy6DTZPEeQL6n2Rz7csM62eAFiJLLyC344mqPzpobk9E0DL
         M+GfZxFVbP1GqvT4IO4cylBzGLc4zVC81vU+VuMqDrDBcPOwPJ7km/2OHS+hLBy4mS9F
         1id+OR8txcMmUnR4HrGS1UKPjguIi8rsHrYLDVCXRz0W4sPD7JbGq9L4054O0TnlAGMA
         NFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P0AD1Y/Lrkza56GStpxrrisnFk/Rh5ZF4KO+s+OS1N0=;
        b=R58OLQDTy5uQvqLUJDvvFOZ+btZTA2/X/zulyN4gubF7mXZXqtHyIkPhFR4niq9aNn
         NnqCi5qbgKLBikzeQQcjgehoNWz/XauWCo4KqVHbAzKoIT4rUz1kyS/S7u1rNnzermO4
         dqejrw4dBo1+t0NAUcRiucFZGdoBX1g/emXK8P3wINVNn8dfpIZWIiI0SK5b+4ks7vVA
         zkmt6FdSWajXrgpo9VZWv0Fc6okg4xmTwji1SQJMzsFuDUQwOxn7NjbI2GaQzmSARO4n
         Gb6ovQCcUJwy5p/CuYSyeict7ikEjW9sq53CjRx1+KA9E6KUk5NeUK/xZ56thjsBIekw
         cDPA==
X-Gm-Message-State: AOAM533m02fYYP/wD+s7kh43pnspcVzAT6TPuu/teHX728OGCgfr+R18
        G20EQ1R/AsPDNuAnelfWcPI=
X-Google-Smtp-Source: ABdhPJwozowH/FyzcH63GrxI3KvkT6Rv2AAo5rdl7GWlFRDB5Ggqe7IVvrtT/tBQAuJ2+0gB7cTQPg==
X-Received: by 2002:a1c:234b:: with SMTP id j72mr248342wmj.153.1598942894686;
        Mon, 31 Aug 2020 23:48:14 -0700 (PDT)
Received: from [192.168.8.147] ([37.166.79.47])
        by smtp.gmail.com with ESMTPSA id q12sm593092wrs.48.2020.08.31.23.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 23:48:14 -0700 (PDT)
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2d93706f-3ba6-128b-738a-b063216eba6d@gmail.com>
Date:   Tue, 1 Sep 2020 08:48:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/20 5:55 PM, Yunsheng Lin wrote:
> Currently there is concurrent reset and enqueue operation for the
> same lockless qdisc when there is no lock to synchronize the
> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
> out-of-bounds access for priv->ring[] in hns3 driver if user has
> requested a smaller queue num when __dev_xmit_skb() still enqueue a
> skb with a larger queue_mapping after the corresponding qdisc is
> reset, and call hns3_nic_net_xmit() with that skb later.
> 
> Avoid the above concurrent op by calling synchronize_rcu_tasks()
> after assigning new qdisc to dev_queue->qdisc and before calling
> qdisc_deactivate() to make sure skb with larger queue_mapping
> enqueued to old qdisc will always be reset when qdisc_deactivate()
> is called.
> 

We request Fixes: tag for fixes in networking land.

> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  net/sched/sch_generic.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 265a61d..6e42237 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1160,8 +1160,13 @@ static void dev_deactivate_queue(struct net_device *dev,
>  
>  	qdisc = rtnl_dereference(dev_queue->qdisc);
>  	if (qdisc) {
> -		qdisc_deactivate(qdisc);
>  		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
> +
> +		/* Make sure lockless qdisc enqueuing is done with the
> +		 * old qdisc in __dev_xmit_skb().
> +		 */
> +		synchronize_rcu_tasks();

This seems quite wrong, there is not a single use of synchronize_rcu_tasks() in net/,
we probably do not want this.

I bet that synchronize_net() is appropriate, if not please explain/comment why we want this instead.

Adding one synchronize_net() per TX queue is a killer for devices with 128 or 256 TX queues.

I would rather find a way of not calling qdisc_reset() from qdisc_deactivate().

This lockless pfifo_fast is a mess really.


