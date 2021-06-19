Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106FB3ADAE6
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 18:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhFSQbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 12:31:09 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:33708 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbhFSQbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 12:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624119953;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=RT/Z+HTuBHVYZyc8sHkhkVJxAthV/PxHFaygLMLHaKE=;
    b=pHc5df34V7CZBMWNwLaQ2bRjKTlgS+Z7yagyXLQ7IGLPssw/0Motm6yYS0KMfYlNjr
    1yAmOMYCHvEsPBowKfoH76whD9log5vyBc2nKextmG15A3AUoPByK0hfjBVkWY+h8DXr
    wdnc+isLc9v7IKzYtMksk7vrwyCcP32K6Hh9iLH6SE52oPUUd7YpTwuM6TGNJ903ISil
    Bk7XPqqvDTnMtWG3y34fcLgHGWUBn86QVT0JQjbIaiSJKyfheaQQE9asdPks1fSK2g6C
    +7c0LEmRglKHQbDJMIZCslLRDBfT5maTBVHSjTTm7LOT0MrGBS//cmfmxpGla6L77toM
    T1tQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR9J8xozF0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
    by smtp.strato.de (RZmta 47.27.3 DYNA|AUTH)
    with ESMTPSA id N0b2dax5JGPr3mm
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 19 Jun 2021 18:25:53 +0200 (CEST)
Subject: Re: [PATCH] can: bcm: delay release of struct bcm_op after
 synchronize_rcu
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com,
        Norbert Slusarek <nslusarek@gmx.net>
References: <20210619161813.2098382-1-cascardo@canonical.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <685d97b7-3129-251f-9b44-03c636a44845@hartkopp.net>
Date:   Sat, 19 Jun 2021 18:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210619161813.2098382-1-cascardo@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19.06.21 18:18, Thadeu Lima de Souza Cascardo wrote:
> can_rx_register callbacks may be called concurrently to the call to
> can_rx_unregister. The callbacks and callback data, though, are protected by
> RCU and the struct sock reference count.
> 
> So the callback data is really attached to the life of sk, meaning that it
> should be released on sk_destruct. However, bcm_remove_op calls tasklet_kill,
> and RCU callbacks may be called under RCU softirq, so that cannot be used on
> kernels before the introduction of HRTIMER_MODE_SOFT.
> 
> However, bcm_rx_handler is called under RCU protection, so after calling
> can_rx_unregister, we may call synchronize_rcu in order to wait for any RCU
> read-side critical sections to finish. That is, bcm_rx_handler won't be called
> anymore for those ops. So, we only free them, after we do that synchronize_rcu.
> 
> Reported-by: syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com
> Reported-by: Norbert Slusarek <nslusarek@gmx.net>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks Norbert for reporting and Thadeu for working out the fix!

Best regards,
Oliver

> ---
>   net/can/bcm.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index f3e4d9528fa3..c67916020e63 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
> @@ -785,6 +785,7 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
>   						  bcm_rx_handler, op);
>   
>   			list_del(&op->list);
> +			synchronize_rcu();
>   			bcm_remove_op(op);
>   			return 1; /* done */
>   		}
> @@ -1533,6 +1534,11 @@ static int bcm_release(struct socket *sock)
>   					  REGMASK(op->can_id),
>   					  bcm_rx_handler, op);
>   
> +	}
> +
> +	synchronize_rcu();
> +
> +	list_for_each_entry_safe(op, next, &bo->rx_ops, list) {
>   		bcm_remove_op(op);
>   	}
>   
> 
