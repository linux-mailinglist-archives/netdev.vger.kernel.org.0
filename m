Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591415A33E2
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiH0CqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiH0CqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:46:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7187AE7266;
        Fri, 26 Aug 2022 19:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7BDFB83387;
        Sat, 27 Aug 2022 02:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209FEC433C1;
        Sat, 27 Aug 2022 02:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568377;
        bh=lrKD4wXLL55A4dSy805qVttWuDV5BsmjYOQPLQfvxWg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eqe0d+IpjnNf+H9Siy0BxztNh0PTxdDBHTRTfL4knU6p6MeVAL4Co4KVZJ2kxH9Qg
         mz2qJbVGqAB/CVq9KaG3eQQAlXHXR7l/0jQUmGnz19uZGcLThHPuCo4t9mgF9Wat0U
         xk0vuH49ZgRbjN5TAWwbQ0yrT6O18HCseACj3otpaB2gwADuThIK+TBzfWIz6WL1+f
         p/HN/lZEW8mD3XztN/idObS9f+oHiDUG4veaszU6DL+USE6REBxfL2sJM/1avnVNcG
         l49xrnLOBVDWnktORy7JJF3QZvwj7hzkQtIb2kp5XIlcs4fJ8FJuxXIgsNLnNVFL2W
         QO/01mMrSjDqQ==
Date:   Fri, 26 Aug 2022 19:46:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH -next] net: sched: sch_skbprio: add support for qlen
 statistics of each priority in sch_skbprio
Message-ID: <20220826194616.37abfe9e@kernel.org>
In-Reply-To: <20220825102745.70728-1-shaozhengchao@huawei.com>
References: <20220825102745.70728-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 18:27:45 +0800 Zhengchao Shao wrote:
> diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
> index 7a5e4c454715..fe2bb7bf9d2a 100644
> --- a/net/sched/sch_skbprio.c
> +++ b/net/sched/sch_skbprio.c
> @@ -83,6 +83,7 @@ static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  		__skb_queue_tail(qdisc, skb);

The skb queue called "qdisc" here (confusingly) already maintains 
a length (also called qlen). Can we just access that variable instead
of maintaining the same value manually?

>  		qdisc_qstats_backlog_inc(sch, skb);
>  		q->qstats[prio].backlog += qdisc_pkt_len(skb);
> +		q->qstats[prio].qlen++;

