Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DFC35453D
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242429AbhDEQeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242379AbhDEQe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:34:29 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27AAC061756;
        Mon,  5 Apr 2021 09:34:23 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id k25so12147135oic.4;
        Mon, 05 Apr 2021 09:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/D8xKPfaEk5h0IUuj0ZaKonPQzq7GWKMhfUBYdKGhFY=;
        b=alKMcIHbxfce8Bp2XsRlXcRRzuQyRU5D+8Gb96q/hUTSa2PsIVfEUjC5a6rsBvKXUS
         9hr/XEx8oa59FuICO8FIR5vPE627pbhML2PoobZ6Nf6Gxd7f6vTEQZK5HWa4mCfkXkXX
         kxqMSkkR42M+StrKw0HXnwF/gVgAXS+BX1Y70dLbvnO7tewRo/aRhqSeGyZA/KLqXFJe
         HhVXk5aQx31CmUWzcmf2B0gBTyilTvG6Wp8HWvcrpbiiocNLZvHEGCT2d2XOyVCNtnAq
         vli1MY7NSazM7bBwrWAUPf5STDvRRHQRyq1ggrqf3dk5qXiAtmxxBvY0MvND8KOKmVhT
         3Rog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/D8xKPfaEk5h0IUuj0ZaKonPQzq7GWKMhfUBYdKGhFY=;
        b=JCyO8yWF45Z4+9zCEZHCB2PCkg5uIJ0+OrV5li7iZHysrnfeNH1WxVGk4h9P8ltAZu
         fwlxRfvrUHW4reRljInPNK9zplEgEOpZxpMtYjFKk0quP7nLDkXjxBYaEtZl7I39IsTL
         54Ll66KfLMw/ESLnZO6ATVS2xJd55frAtiWU6GP5T+IhhqL9RcxHyrVt4cwPiSdyLdnh
         guNxxSpT7jIqTrNkjgApsG2C+03VEQCKd3IsBO7ub6bpZPscJqHmMe51B8GeB4G/fh1M
         rUDXHNs9GGwrjFYyZS4w2s69Lp7vcpQj27v63Qrl5O5fHL9Qz3t4gmnmhWafEYR0E5p2
         SxJQ==
X-Gm-Message-State: AOAM532wKBfocJy6VUmGLYna7m4HUqPiwhhvkWuPWY9wI22MbGl9QFM3
        usuoOMClt5BqD4bjXed9UYfpCscuW3E=
X-Google-Smtp-Source: ABdhPJz775aKrzmAMTvdvoCEk0uvv3EkH6Z4Qr3r0mdYyHuPsAKP+Aw2EmI/KM4wW466cbKB7sO6Og==
X-Received: by 2002:aca:ea06:: with SMTP id i6mr6816oih.82.1617640462797;
        Mon, 05 Apr 2021 09:34:22 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id n13sm3993405otk.61.2021.04.05.09.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 09:34:22 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH] rtlwifi: Simplify locking of a skb list accesses
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <99cf8894fd52202cb7ce2ec6e3200eef400bc071.1617609346.git.christophe.jaillet@wanadoo.fr>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <347e6042-2964-7037-b57f-5dd84aa4bf14@lwfinger.net>
Date:   Mon, 5 Apr 2021 11:34:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <99cf8894fd52202cb7ce2ec6e3200eef400bc071.1617609346.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/21 2:57 AM, Christophe JAILLET wrote:
> The 'c2hcmd_lock' spinlock is only used to protect some __skb_queue_tail()
> and __skb_dequeue() calls.
> Use the lock provided in the skb itself and call skb_queue_tail() and
> skb_dequeue(). These functions already include the correct locking.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c | 15 ++-------------
>   drivers/net/wireless/realtek/rtlwifi/wifi.h |  1 -
>   2 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index 6e8bd99e8911..2a7ee90a3f54 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -551,7 +551,6 @@ int rtl_init_core(struct ieee80211_hw *hw)
>   	spin_lock_init(&rtlpriv->locks.rf_lock);
>   	spin_lock_init(&rtlpriv->locks.waitq_lock);
>   	spin_lock_init(&rtlpriv->locks.entry_list_lock);
> -	spin_lock_init(&rtlpriv->locks.c2hcmd_lock);
>   	spin_lock_init(&rtlpriv->locks.scan_list_lock);
>   	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
>   	spin_lock_init(&rtlpriv->locks.fw_ps_lock);
> @@ -2269,7 +2268,6 @@ static bool rtl_c2h_fast_cmd(struct ieee80211_hw *hw, struct sk_buff *skb)
>   void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, struct sk_buff *skb)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	unsigned long flags;
>   
>   	if (rtl_c2h_fast_cmd(hw, skb)) {
>   		rtl_c2h_content_parsing(hw, skb);
> @@ -2278,11 +2276,7 @@ void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, struct sk_buff *skb)
>   	}
>   
>   	/* enqueue */
> -	spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
> -
> -	__skb_queue_tail(&rtlpriv->c2hcmd_queue, skb);
> -
> -	spin_unlock_irqrestore(&rtlpriv->locks.c2hcmd_lock, flags);
> +	skb_queue_tail(&rtlpriv->c2hcmd_queue, skb);
>   
>   	/* wake up wq */
>   	queue_delayed_work(rtlpriv->works.rtl_wq, &rtlpriv->works.c2hcmd_wq, 0);
> @@ -2340,16 +2334,11 @@ void rtl_c2hcmd_launcher(struct ieee80211_hw *hw, int exec)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct sk_buff *skb;
> -	unsigned long flags;
>   	int i;
>   
>   	for (i = 0; i < 200; i++) {
>   		/* dequeue a task */
> -		spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
> -
> -		skb = __skb_dequeue(&rtlpriv->c2hcmd_queue);
> -
> -		spin_unlock_irqrestore(&rtlpriv->locks.c2hcmd_lock, flags);
> +		skb = skb_dequeue(&rtlpriv->c2hcmd_queue);
>   
>   		/* do it */
>   		if (!skb)
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 9119144bb5a3..877ed6a1589f 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -2450,7 +2450,6 @@ struct rtl_locks {
>   	spinlock_t waitq_lock;
>   	spinlock_t entry_list_lock;
>   	spinlock_t usb_lock;
> -	spinlock_t c2hcmd_lock;
>   	spinlock_t scan_list_lock; /* lock for the scan list */
>   
>   	/*FW clock change */
> 

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry
