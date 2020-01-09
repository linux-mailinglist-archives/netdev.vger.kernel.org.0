Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA80D135F78
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388216AbgAIRjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:39:52 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:32957 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbgAIRjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 12:39:52 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1ipbmh-0002Ei-Da; Thu, 09 Jan 2020 18:39:51 +0100
Subject: Re: [BUG] pfifo_fast may cause out-of-order CAN frame transmission
To:     Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Sascha Hauer <kernel@pengutronix.de>
References: <661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de>
 <7717e4470f6881bbc92645c72ad7f6ec71360796.camel@redhat.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <779d3346-0344-9064-15d5-4d565647a556@pengutronix.de>
Date:   Thu, 9 Jan 2020 18:39:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7717e4470f6881bbc92645c72ad7f6ec71360796.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Paolo,

On 1/9/20 1:51 PM, Paolo Abeni wrote:
> On Wed, 2020-01-08 at 15:55 +0100, Ahmad Fatoum wrote:
>> I've run into an issue of CAN frames being sent out-of-order on an i.MX6 Dual
>> with Linux v5.5-rc5. Bisecting has lead me down to this commit:
> 
> Thank you for the report.

Thanks for the prompt patch. :-)

> The code is only build-tested, could you please try it in your setup?

Issue still persists, albeit appears to have become much less frequent. Took 2 million
frames till first two were swapped. What I usually saw was a swap every few thousand
frames at least and quite often more frequent than that. Might just be noise though.

Thanks
Ahmad

> 
> Thanks,
> 
> Paolo
> ---
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index fceddf89592a..df460fe0773a 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -158,7 +158,6 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  	if (qdisc->flags & TCQ_F_NOLOCK) {
>  		if (!spin_trylock(&qdisc->seqlock))
>  			return false;
> -		WRITE_ONCE(qdisc->empty, false);
>  	} else if (qdisc_is_running(qdisc)) {
>  		return false;
>  	}
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0ad39c87b7fd..3c46575a5af5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3625,6 +3625,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  			qdisc_run_end(q);
>  		} else {
>  			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +			if (rc != NET_XMIT_DROP && READ_ONCE(q->empty))
> +				WRITE_ONCE(q->empty, false);
>  			qdisc_run(q);
>  		}
>  
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
