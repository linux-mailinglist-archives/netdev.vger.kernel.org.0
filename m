Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561BC42C61
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfFLQdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:33:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:47860 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbfFLQdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:33:19 -0400
Received: from [88.198.220.132] (helo=sslproxy03.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb6BV-0000cm-W5; Wed, 12 Jun 2019 18:33:14 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb6BV-0000Tf-Ow; Wed, 12 Jun 2019 18:33:13 +0200
Subject: Re: [PATCH net-next] net: sched: ingress: set 'unlocked' flag for
 Qdisc ops
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, alexei.starovoitov@gmail.com
References: <20190612071435.7367-1-vladbu@mellanox.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <52082ab2-7db8-b047-f42f-a5c69ba9c303@iogearbox.net>
Date:   Wed, 12 Jun 2019 18:33:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190612071435.7367-1-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25478/Wed Jun 12 10:14:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2019 09:14 AM, Vlad Buslov wrote:
> To remove rtnl lock dependency in tc filter update API when using ingress
> Qdisc, set QDISC_CLASS_OPS_DOIT_UNLOCKED flag in ingress Qdisc_class_ops.
> 
> Ingress Qdisc ops don't require any modifications to be used without rtnl
> lock on tc filter update path. Ingress implementation never changes its
> q->block and only releases it when Qdisc is being destroyed. This means it
> is enough for RTM_{NEWTFILTER|DELTFILTER|GETTFILTER} message handlers to
> hold ingress Qdisc reference while using it without relying on rtnl lock
> protection. Unlocked Qdisc ops support is already implemented in filter
> update path by unlocked cls API patch set.
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> ---
>  net/sched/sch_ingress.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> index 0f65f617756b..d5382554e281 100644
> --- a/net/sched/sch_ingress.c
> +++ b/net/sched/sch_ingress.c
> @@ -114,6 +114,7 @@ static int ingress_dump(struct Qdisc *sch, struct sk_buff *skb)
>  }
>  
>  static const struct Qdisc_class_ops ingress_class_ops = {
> +	.flags		=	QDISC_CLASS_OPS_DOIT_UNLOCKED,
>  	.leaf		=	ingress_leaf,
>  	.find		=	ingress_find,
>  	.walk		=	ingress_walk,
> 

Vlad, why is clsact_class_ops not updated here? Please elaborate!
