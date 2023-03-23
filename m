Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98C16C6CE7
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjCWQFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjCWQFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:05:39 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4212798B
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:05:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u10so1039981plz.7
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679587537;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rv/skISr3z3SdmS0Ib30xBiuStpEP9xwh7ontts5CkE=;
        b=fzWxtG1NxR6d3AK29ytDv3ySyOV27osq3RyCxqPfXitWutzni32H9qZNvkFCI/6ThS
         0xKe51STKNBuvT2FL2ntRYWBMSXak7GvdSHYl52waMXSIPQpgzR/rLKDl79OI1fNQI50
         VcPlE3Y9f/NO3G8k8WgqWmXiKeanyk3605GbB5Z2c40BvpMVXoAvbzke3Xd8SAF+XclC
         Lar9J55PhrXnzZ4z1M8CTF42TEdoxVF/jctB9a6wd3I8xpJcIQZHkIEDmNy2CZVh3ZHl
         OpPTVk3e/i3+hE6X5FU6cjRxQ2zbAJSdYgR+XyW9QNCwSxUBJlOM5I2CKcVai8Dwj9FM
         bRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679587537;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rv/skISr3z3SdmS0Ib30xBiuStpEP9xwh7ontts5CkE=;
        b=aROhfrtksZSomSEfkRFkvIhpe3obC41ol5Yhnp/gAUjYc7jDVFqrKfe67LIl6iB+Ri
         pawxG84GAwHFHJHA/ZoWcpdedz6GNo+M89yqdzLSQDgtqNxCnE8y0iLiv4jJIxCRRaTH
         5vwSr/JdpOxxPLCleAQlm5sMm40g1+JSewvoUPKcZfm8fNLAxwRyvY/Tz3kBOzsr/oVL
         3NreRa5zTfUc5nJvtJtZRrkxxu/9nVINLvPOvMKctwysY2XusCp649gvl0lEYXMDodhM
         QGn9nj/UNIo9HK3h4siBBHob/7LxSNFHX23hNuJzu6vKJ4AOC+en/j0ek8Qls1pg7uRp
         M1eQ==
X-Gm-Message-State: AAQBX9c11ke26hxa/ZQesTwI/dY7f6BDXaw30t40XwLHIkxYwqaCouPr
        PCNIUD4TMgOeiM9F1pMe0Aiqt4NhHO8=
X-Google-Smtp-Source: AKy350YDy08JqePW48nsjCVl4tKAdEQzD6kd8fQ/3/0mFz1qYh0nL5Kwn+C4jRfKAeSPW8EPwr45bw==
X-Received: by 2002:a17:902:f552:b0:1a1:7899:f009 with SMTP id h18-20020a170902f55200b001a17899f009mr6149166plf.17.1679587537259;
        Thu, 23 Mar 2023 09:05:37 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.116.32])
        by smtp.googlemail.com with ESMTPSA id c2-20020a170902aa4200b001a1bbe7020esm10204295plr.231.2023.03.23.09.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 09:05:36 -0700 (PDT)
Message-ID: <5060c11df10c66f56b5ca7ec2ec92333252b084b.camel@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com
Date:   Thu, 23 Mar 2023 09:05:35 -0700
In-Reply-To: <20230322233028.269410-1-kuba@kernel.org>
References: <20230322233028.269410-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-22 at 16:30 -0700, Jakub Kicinski wrote:
> A lot of drivers follow the same scheme to stop / start queues
> without introducing locks between xmit and NAPI tx completions.
> I'm guessing they all copy'n'paste each other's code.
>=20
> Smaller drivers shy away from the scheme and introduce a lock
> which may cause deadlocks in netpoll.
>=20
> Provide macros which encapsulate the necessary logic.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> rfc: https://lore.kernel.org/all/20230311050130.115138-1-kuba@kernel.org/
>  - perdicate -> predicate
>  - on race use start instead of wake and make a note of that
>    in the doc / comment at the start
> ---
>  include/net/netdev_queues.h | 171 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 171 insertions(+)
>  create mode 100644 include/net/netdev_queues.h
>=20
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> new file mode 100644
> index 000000000000..64e059647274
> --- /dev/null
> +++ b/include/net/netdev_queues.h
> @@ -0,0 +1,171 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_NET_QUEUES_H
> +#define _LINUX_NET_QUEUES_H
> +
> +#include <linux/netdevice.h>
> +
> +/* Lockless queue stopping / waking helpers.
> + *
> + * These macros are designed to safely implement stopping and waking
> + * netdev queues without full lock protection. We assume that there can
> + * be no concurrent stop attempts and no concurrent wake attempts.
> + * The try-stop should happen from the xmit handler*, while wake up
> + * should be triggered from NAPI poll context. The two may run
> + * concurrently (single producer, single consumer).
> + *
> + * All descriptor ring indexes (and other relevant shared state) must
> + * be updated before invoking the macros.
> + *
> + * * the try-stop side does not reschedule Tx (netif_tx_start_queue()
> + *   instead of netif_tx_wake_queue()) so uses outside of the xmit
> + *   handler may lead to bugs
> + */
> +
> +#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)		\
> +	({								\
> +		int _res;						\
> +									\
> +		netif_tx_stop_queue(txq);				\
> +									\
> +		smp_mb();						\
> +									\
> +		/* We need to check again in a case another		\
> +		 * CPU has just made room available.			\
> +		 */							\
> +		if (likely(get_desc < start_thrs)) {			\
> +			_res =3D 0;					\
> +		} else {						\
> +			netif_tx_start_queue(txq);			\
> +			_res =3D -1;					\
> +		}							\
> +		_res;							\
> +	})								\
> +

The issue I see here is that with this being a macro it abstracts away
the relationship between get_desc and the memory barrier. At a minimum
I think we should be treating get_desc as a function instead of just
passing it and its arguments as a single value. Maybe something more
like how read_poll_timeout passes the "op" and then uses it as a
function with args passed seperately. What we want to avoid is passing
a precomuted value to this function as get_desc.

In addition I think I would prefer to see _res initialized to the
likely value so that we can drop this to one case instead of having to
have two. Same thing for the macros below.

> +/**
> + * netif_tx_queue_maybe_stop() - locklessly stop a Tx queue, if needed
> + * @txq:	struct netdev_queue to stop/start
> + * @get_desc:	get current number of free descriptors (see requirements b=
elow!)
> + * @stop_thrs:	minimal number of available descriptors for queue to be l=
eft
> + *		enabled
> + * @start_thrs:	minimal number of descriptors to re-enable the queue, ca=
n be
> + *		equal to @stop_thrs or higher to avoid frequent waking
> + *
> + * All arguments may be evaluated multiple times, beware of side effects=
.
> + * @get_desc must be a formula or a function call, it must always
> + * return up-to-date information when evaluated!
> + * Expected to be used from ndo_start_xmit, see the comment on top of th=
e file.
> + *
> + * Returns:
> + *	 0 if the queue was stopped
> + *	 1 if the queue was left enabled
> + *	-1 if the queue was re-enabled (raced with waking)
> + */

We may want to change the values here. The most likely case is "left
enabled" with that being the case we probably want to make that the 0
case. I would then probably make 1 the re-enabled case and -1 the
stopped case.

With that the decision tree becomes more straightforward as we would do
something like:
	if (result) {
		if (result < 0)
			Increment stopped stat
			return
		else
			Increment restarted stat
	}

In addition for readability we may want consider adding an enum simliar
to the netdev_tx enum as then we have the return types locked and
usable should we want to specifically pick out one.


> +#define netif_tx_queue_maybe_stop(txq, get_desc, stop_thrs, start_thrs)	=
\
> +	({								\
> +		int _res;						\
> +									\
> +		if (likely(get_desc > stop_thrs))			\
> +			_res =3D 1;					\
> +		else							\
> +			_res =3D netif_tx_queue_try_stop(txq, get_desc,	\
> +						       start_thrs);	\
> +		_res;							\
> +	})								\
> +
> +#define __netif_tx_queue_try_wake(txq, get_desc, start_thrs, down_cond) =
\
> +	({								\
> +		int _res;						\
> +									\
> +		/* Make sure that anybody stopping the queue after	\
> +		 * this sees the new next_to_clean.			\
> +		 */							\
> +		smp_mb();						\
> +		if (netif_tx_queue_stopped(txq) && !(down_cond)) {	\
> +			netif_tx_wake_queue(txq);			\
> +			_res =3D 0;					\
> +		} else {						\
> +			_res =3D 1;					\
> +		}							\
> +		_res;							\
> +	})
> +
> +#define netif_tx_queue_try_wake(txq, get_desc, start_thrs)		\
> +	__netif_tx_queue_try_wake(txq, get_desc, start_thrs, false)
> +
> +/**
> + * __netif_tx_queue_maybe_wake() - locklessly wake a Tx queue, if needed
> + * @txq:	struct netdev_queue to stop/start
> + * @get_desc:	get current number of free descriptors (see requirements b=
elow!)
> + * @start_thrs:	minimal number of descriptors to re-enable the queue
> + * @down_cond:	down condition, predicate indicating that the queue shoul=
d
> + *		not be woken up even if descriptors are available
> + *
> + * All arguments may be evaluated multiple times.
> + * @get_desc must be a formula or a function call, it must always
> + * return up-to-date information when evaluated!
> + *
> + * Returns:
> + *	 0 if the queue was woken up
> + *	 1 if the queue was already enabled (or disabled but @down_cond is tr=
ue)
> + *	-1 if the queue was left stopped
> + */

I would go with the same here. The most common case should probably be
0 which would be "already enabled" with 1 being woken up and -1 being
stopped. In addition keeping the two consistent with each other would
allow for easier understanding of the two.

> +#define __netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, down_cond=
) \
> +	({								\
> +		int _res;						\
> +									\
> +		if (likely(get_desc < start_thrs))			\
> +			_res =3D -1;					\
> +		else							\
> +			_res =3D __netif_tx_queue_try_wake(txq, get_desc,	\
> +							 start_thrs,	\
> +							 down_cond);	\
> +		_res;							\
> +	})
> +

The likely here is probably not correct. In most cases the queue will
likely have enough descriptors to enable waking since Tx cleanup can
usually run pretty fast compared to the transmit path itself since it
can run without needing to take locks.

> +#define netif_tx_queue_maybe_wake(txq, get_desc, start_thrs)		\
> +	__netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, false)
> +
> +/* subqueue variants follow */
> +
> +#define netif_subqueue_try_stop(dev, idx, get_desc, start_thrs)		\
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq =3D netdev_get_tx_queue(dev, idx);			\
> +		netif_tx_queue_try_stop(txq, get_desc, start_thrs);	\
> +	})
> +
> +#define netif_subqueue_maybe_stop(dev, idx, get_desc, stop_thrs, start_t=
hrs) \
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq =3D netdev_get_tx_queue(dev, idx);			\
> +		netif_tx_queue_maybe_stop(txq, get_desc,		\
> +					  stop_thrs, start_thrs);	\
> +	})
> +
> +#define __netif_subqueue_try_wake(dev, idx, get_desc, start_thrs, down_c=
ond) \
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq =3D netdev_get_tx_queue(dev, idx);			\
> +		__netif_tx_queue_try_wake(txq, get_desc,		\
> +					  start_thrs, down_cond);	\
> +	})
> +
> +#define netif_subqueue_try_wake(dev, idx, get_desc, start_thrs)		\
> +	__netif_subqueue_try_wake(dev, idx, get_desc, start_thrs, false)
> +
> +#define __netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs, down=
_cond) \
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq =3D netdev_get_tx_queue(dev, idx);			\
> +		__netif_tx_queue_maybe_wake(txq, get_desc,		\
> +					    start_thrs, down_cond);	\
> +	})
> +
> +#define netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs)	\
> +	__netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs, false)
> +
> +#endif

