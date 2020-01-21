Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADF3144719
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 23:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAUWT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 17:19:56 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34436 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbgAUWTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 17:19:55 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so2292446pgf.1;
        Tue, 21 Jan 2020 14:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=87q9xhoPKVsZRpT7sXkkO2m2/qUarjs1kR3PGeTcCa8=;
        b=V6+0gFQxv4KVdfOevLuORPsMA0IRumBkHZGOYQyPErMao8SthHHq7cBPYxHBMZjQGI
         TNZuiJNT4SeYK8K0hdMIqq7jJSaF40Tp7OuUfxFOqlBI+iSSJX63CpbOZS0BcUeIGeoA
         iVRvlfpR6KCTMSGOZyFpbivijF8HsnSHpmRCRG2298dfJEJmdXkeWIZl4Mz6IMyuebYc
         5KqCSCfsCnmhYTj4RyLanptRRVWnLmbu/hd3dMZYbxEFVWfms6NurkIlCs2oanVYqAHO
         Viop3Ydl33vbMniGsD8HecJnNHKeAxPqa1Nmu3bZGcKMAQRrsEP/LsWkBH6TrqNOqSjv
         G0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=87q9xhoPKVsZRpT7sXkkO2m2/qUarjs1kR3PGeTcCa8=;
        b=hgHab1ttOOuH3FRnCuCAJ1glqxLk4HVJbU827Yy2+GEwzU+qyhX+wNNk25yRxnHbtk
         cYcHWXNuG8ICDHXRet/rhAEnd5kauhkzJj8b9TDxJaBafpEezRgYjd/tWOGCCc75tWGz
         CsffxYnFmia1dfBiFPxKGPl+9Ea1zfNwfaVzaV02A+aHHNV07S60iheOSVUMZq1brKmg
         /FfFnRsi+v4NSqgdgQzEPd0XelKRj1V48bcUu0UxbiK7QrqwSittxuLMAIR8eD8y1RRv
         vNt7sP9HmPFkc9c8w+OPvmEAUVWlTecShiDlYGgYICb2KdU5aHYqfApx3xrFi+nYIY6+
         hMnA==
X-Gm-Message-State: APjAAAU4nxyPF86fhkO/YFJnq0hPuUhnAKpKkn4MdiVd9+8o1QhfIw5q
        zbZ/6XwfzT7eo7tOur6lZgJHQRmU
X-Google-Smtp-Source: APXvYqzX+G5EAYzlbOeRoettvDYSWW16bHWnmdXsnq9AUn5obiFNsulAcXmnW6RhQSNdd6qnIwIbQQ==
X-Received: by 2002:a62:5447:: with SMTP id i68mr6697130pfb.44.1579645194049;
        Tue, 21 Jan 2020 14:19:54 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id a1sm43969982pfo.68.2020.01.21.14.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 14:19:53 -0800 (PST)
Subject: Re: [PATCH net v2 01/12] net/sonic: Add mutual exclusion for
 accessing shared state
To:     Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1579641728.git.fthain@telegraphics.com.au>
 <d7c6081de558e2fe5693a35bb735724411134cb5.1579641728.git.fthain@telegraphics.com.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0113c00f-3f77-8324-95a8-31dd6f64fa6a@gmail.com>
Date:   Tue, 21 Jan 2020 14:19:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d7c6081de558e2fe5693a35bb735724411134cb5.1579641728.git.fthain@telegraphics.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/21/20 1:22 PM, Finn Thain wrote:
> The netif_stop_queue() call in sonic_send_packet() races with the
> netif_wake_queue() call in sonic_interrupt(). This causes issues
> like "NETDEV WATCHDOG: eth0 (macsonic): transmit queue 0 timed out".
> Fix this by disabling interrupts when accessing tx_skb[] and next_tx.
> Update a comment to clarify the synchronization properties.
> 
> Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

> @@ -284,9 +287,16 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
>  	struct net_device *dev = dev_id;
>  	struct sonic_local *lp = netdev_priv(dev);
>  	int status;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&lp->lock, flags);


This is a hard irq handler, no need to block hard irqs.

spin_lock() here is enough.

> +
> +	status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
> +	if (!status) {
> +		spin_unlock_irqrestore(&lp->lock, flags);
>  
> -	if (!(status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT))
>  		return IRQ_NONE;
> +	}
>  
>  	do {
>  		if (status & SONIC_INT_PKTRX) {
> @@ -300,11 +310,12 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
>  			int td_status;
>  			int freed_some = 0;
>  
> -			/* At this point, cur_tx is the index of a TD that is one of:
> -			 *   unallocated/freed                          (status set   & tx_skb[entry] clear)
> -			 *   allocated and sent                         (status set   & tx_skb[entry] set  )
> -			 *   allocated and not yet sent                 (status clear & tx_skb[entry] set  )
> -			 *   still being allocated by sonic_send_packet (status clear & tx_skb[entry] clear)
> +			/* The state of a Transmit Descriptor may be inferred
> +			 * from { tx_skb[entry], td_status } as follows.
> +			 * { clear, clear } => the TD has never been used
> +			 * { set,   clear } => the TD was handed to SONIC
> +			 * { set,   set   } => the TD was handed back
> +			 * { clear, set   } => the TD is available for re-use
>  			 */
>  
>  			netif_dbg(lp, intr, dev, "%s: tx done\n", __func__);
> @@ -406,7 +417,12 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
>  		/* load CAM done */
>  		if (status & SONIC_INT_LCD)
>  			SONIC_WRITE(SONIC_ISR, SONIC_INT_LCD); /* clear the interrupt */
> -	} while((status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT));
> +
> +		status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
> +	} while (status);
> +
> +	spin_unlock_irqrestore(&lp->lock, flags);
> +
>  	return IRQ_HANDLED;



