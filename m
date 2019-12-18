Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB86112425C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLRJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 04:03:44 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:35616 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfLRJDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 04:03:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576659822;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=E5EK+nZyMM8i0OBv88VCVdNSE8sqZomIq7L1cCPL+eY=;
        b=ZQXUEIZUvPZ3PaUJnCv8nG+HzUxhFp4Ql5GX3RA5ZEh3w93VAtWVItjSfuTc5fQsmx
        S+4fJmkeLAK4Jiqdx807pxLR27dnMz+x6F6y2rIneUML32nuAVuZ6a1ptU2RWNmwIIzg
        L7XP0ScWGbmeE7NLyZ8gzRV2TLn1quaesTDNfbd8Iu5KSEzxtiLZ10CYYHVFvalzLM57
        LPqP0CaHzn5FHWfvrGZZeYpNH5ttTeIeKZ9lqlUY2ZLAFboQ2LigUPJK8QXABxgRJoCc
        cm+dDDDhaHldpeUzz4+axwc93M/33NhaeRpLVvQWhN04Wu+EgcIq6UFGon1CvmEbk1I9
        2JuQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3jXdVqE32oRVrGn+26OxA=="
X-RZG-CLASS-ID: mo00
Received: from [10.180.55.161]
        by smtp.strato.de (RZmta 46.0.7 AUTH)
        with ESMTPSA id j0a0eavBI93W39R
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 18 Dec 2019 10:03:32 +0100 (CET)
Subject: Re: [PATCH v1] can: j1939: transport: j1939_simple_recv(): ignore
 local J1939 messages send not by J1939 stack
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <20191218084355.24398-1-o.rempel@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <c2e25142-8104-872e-3e33-63307a2d34ab@hartkopp.net>
Date:   Wed, 18 Dec 2019 10:03:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218084355.24398-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 18/12/2019 09.43, Oleksij Rempel wrote:
> In current J1939 stack implementation, we process all locally send
> messages as own messages. Even if it was send by CAN_RAW socket.
> 
> To reproduce it use following commands:
> testj1939 -P -r can0:0x80 &
> cansend can0 18238040#0123
> 
> This step will trigger false positive not critical warning:
> j1939_simple_recv: Received already invalidated message
> 
> With this patch we add additional check to make sure, related skb is own
> echo message.

in net/can/raw.c we check whether the CAN has been sent from that socket 
(an by default suppress our own transmitted data):

https://elixir.bootlin.com/linux/v5.4.3/source/net/can/raw.c#L124

would checking against the 'sk' work for you too?

What happens if someone runs a J1939 implementation on a CAN_RAW socket 
in addition to the in-kernel implementation? Can they talk to each other?

Regards,
Oliver

> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>   net/can/j1939/socket.c    | 1 +
>   net/can/j1939/transport.c | 4 ++++
>   2 files changed, 5 insertions(+)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index f7587428febd..b9a17c2ee16f 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -398,6 +398,7 @@ static int j1939_sk_init(struct sock *sk)
>   	spin_lock_init(&jsk->sk_session_queue_lock);
>   	INIT_LIST_HEAD(&jsk->sk_session_queue);
>   	sk->sk_destruct = j1939_sk_sock_destruct;
> +	sk->sk_protocol = CAN_J1939;
>   
>   	return 0;
>   }
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index 9f99af5b0b11..b135c5e2a86e 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -2017,6 +2017,10 @@ void j1939_simple_recv(struct j1939_priv *priv, struct sk_buff *skb)
>   	if (!skb->sk)
>   		return;
>   
> +	if (skb->sk->sk_family != AF_CAN ||
> +	    skb->sk->sk_protocol != CAN_J1939)
> +		return;
> +
>   	j1939_session_list_lock(priv);
>   	session = j1939_session_get_simple(priv, skb);
>   	j1939_session_list_unlock(priv);
> 
