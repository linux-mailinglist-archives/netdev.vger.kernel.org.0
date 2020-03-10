Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292A617FAAA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbgCJNHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 09:07:15 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:23931 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730920AbgCJNHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 09:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583845632;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=6R1RKm2q+lEZhuVelK1a77+oRAAsa1Xp6grAc/+xsXE=;
        b=URt7zzUnEnTvofORtuRgOgsWVLD++cxyB1eUte9R8PgJvMMdtcvxgwHUCFCa9LImKO
        51t5J47ocVi6hlmyIrNuQthH+E2HtNSyJCIp7tzvLs2W3GwEjiW0uga6aUMkWfzdEWaW
        z99GXggdOYGskCGrR92Gr5TYR2wdKJZfT+H1VQifAJy30uq+Fu/GmWhfB68Ipu4DSjOP
        kqUxb5ljm/um1iOBa35XmzcaHv5sEO0Ny6KbT86vsWax36ja1+6OGPMt28hmpDzmGCOK
        u6zayrTUprrHAVuH4WkGFyzAWAGUGZcQqJilbqpDLcEm43kfqMWd650XMsPZRqWwyuxs
        qhaw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVch5lEq7"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id e0a4ffw2AD78XAp
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Mar 2020 14:07:08 +0100 (CET)
Subject: Re: [PATCH] net: slcan, slip -- no need for goto when if () will do
To:     Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        yangerkun@huawei.com, davem@davemloft.net, mkl@pengutronix.de,
        wg@grandegger.com
References: <20200309223323.GA1634@duo.ucw.cz>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <0d9a5f11-1dc9-03ad-cecb-af38ad421c95@hartkopp.net>
Date:   Tue, 10 Mar 2020 14:07:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309223323.GA1634@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/03/2020 23.33, Pavel Machek wrote:
> 
> No need to play with gotos to jump over single statement.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 2f5c287eac95..686d853fc249 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -348,11 +348,8 @@ static void slcan_write_wakeup(struct tty_struct *tty)
>   
>   	rcu_read_lock();
>   	sl = rcu_dereference(tty->disc_data);
> -	if (!sl)
> -		goto out;
> -
> -	schedule_work(&sl->tx_work);
> -out:
> +	if (sl)
> +		schedule_work(&sl->tx_work);
>   	rcu_read_unlock();
>   }

Haha. Yes, that looks indeed much better ...

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

>   
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index babb01888b78..f81fb0b13a94 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -456,11 +456,8 @@ static void slip_write_wakeup(struct tty_struct *tty)
>   
>   	rcu_read_lock();
>   	sl = rcu_dereference(tty->disc_data);
> -	if (!sl)
> -		goto out;
> -
> -	schedule_work(&sl->tx_work);
> -out:
> +	if (sl)
> +		schedule_work(&sl->tx_work);
>   	rcu_read_unlock();
>   }
>   
> 
