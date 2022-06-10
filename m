Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98121545CF9
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbiFJHO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346543AbiFJHO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:14:26 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504FF2DA9F;
        Fri, 10 Jun 2022 00:14:25 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzYqW-000848-PU; Fri, 10 Jun 2022 09:14:16 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzYqW-000UfC-Et; Fri, 10 Jun 2022 09:14:16 +0200
Subject: Re: [PATCH] net: sched: fix potential null pointer deref
To:     Jianhao Xu <jianhao_xu@smail.nju.edu.cn>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220610021445.2441579-1-jianhao_xu@smail.nju.edu.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3f460707-e267-e749-07fc-c44604cd5713@iogearbox.net>
Date:   Fri, 10 Jun 2022 09:14:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220610021445.2441579-1-jianhao_xu@smail.nju.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26567/Thu Jun  9 10:06:06 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jianhao,

On 6/10/22 4:14 AM, Jianhao Xu wrote:
> mq_queue_get() may return NULL, a check is needed to avoid using
> the NULL pointer.
> 
> Signed-off-by: Jianhao Xu <jianhao_xu@smail.nju.edu.cn>

Do you have a reproducer where this is triggered?

> ---
>   net/sched/sch_mq.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
> index 83d2e54bf303..9aca4ca82947 100644
> --- a/net/sched/sch_mq.c
> +++ b/net/sched/sch_mq.c
> @@ -201,6 +201,8 @@ static int mq_graft(struct Qdisc *sch, unsigned long cl, struct Qdisc *new,
>   static struct Qdisc *mq_leaf(struct Qdisc *sch, unsigned long cl)
>   {
>   	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
> +	if (!dev_queue)
> +		return NULL;
>   
>   	return dev_queue->qdisc_sleeping;
>   }
> @@ -218,6 +220,8 @@ static int mq_dump_class(struct Qdisc *sch, unsigned long cl,
>   			 struct sk_buff *skb, struct tcmsg *tcm)
>   {
>   	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
> +	if (!dev_queue)
> +		return -1;
>   
>   	tcm->tcm_parent = TC_H_ROOT;
>   	tcm->tcm_handle |= TC_H_MIN(cl);
> @@ -229,6 +233,8 @@ static int mq_dump_class_stats(struct Qdisc *sch, unsigned long cl,
>   			       struct gnet_dump *d)
>   {
>   	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
> +	if (!dev_queue)
> +		return -1;
>   
>   	sch = dev_queue->qdisc_sleeping;
>   	if (gnet_stats_copy_basic(d, sch->cpu_bstats, &sch->bstats, true) < 0 ||
> 

