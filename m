Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19009134B4E
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 20:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgAHTNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 14:13:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46557 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgAHTNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 14:13:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so4542339wrl.13
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 11:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/YqP82UI2EgKOEnVNSo22iAEZ3XqBq42tOxJtrxCfsI=;
        b=JCVLTgCnCYbxSUlRSbDM+x+B/HBmhYkvHzn+X24d5I1fCe1H/fIzAm+sDqeJyouhVR
         h7AafFyZXFIQvXW9uW+EYUWuPxeYC0LmLitjHdZAthxSBxkhaqeU0GlN28Wv+Gj7f88w
         KNwtONCqDPmYNCzck5JkzuGV1FgoEnJOnGda0NyiXG54BXDbbkd1mF1JwFoOsfCV7/41
         j1covLsUvnJGM9/oA1ROX/b68+8Tr4dwPRdeUbSQUQco1yZeJvLYlFRWcm18pRsoeloS
         kN5N6foXDzazmObrHGasXBV2wQAo3KD/LTLtThmMQuSJ8mW3jPSBVXZ1Xhw1rLheo4XN
         /51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/YqP82UI2EgKOEnVNSo22iAEZ3XqBq42tOxJtrxCfsI=;
        b=PPnM4E0lzKNOsZNpsWDBzP1WlGu+hM3YLQvDGSCcdj0Nn+Bf2/IKeoojm0tmUnmBAO
         +jjO41VqpGrGhZaDlEDevdCAPHRbeg3HkC5lZ8SgqYaI20HI1G8WmpUX1ZkCmAN16Bfh
         RaO2qayAm5zMRtwOyISCU/afULoY4fBEuulYDfeN+yayjiFZA0x84b6UmHu2YPCglCVD
         iTl1CZPgEFnYCKExOzgu/CjfboWWxU9QgAPSlXYXQ3cqSJswAU4gv39taVcZ7JcDnGuY
         mQP0jJlqUfrmyQhdFnEe/bU6htSQhFqDCLgFahwtV3tvWgRztB+vJsnT5KSjJ0WciTon
         PAdg==
X-Gm-Message-State: APjAAAUt4rTuT6TOxVli/EA/Wjl3RY1RWvuVGHqnTkWVfW1guSaz9PUg
        70D/RXAlzOB8Tz7nIrifI0y9QU0zKFVmZg==
X-Google-Smtp-Source: APXvYqy/KYgHIJL9KmZ7xh4+R/QKJu2P1RDW5Hg2lUKUC76lj6Zu3fVxBDoscr22988zTLccEheURg==
X-Received: by 2002:a5d:410e:: with SMTP id l14mr6135829wrp.238.1578510819999;
        Wed, 08 Jan 2020 11:13:39 -0800 (PST)
Received: from xps13.intranet.net (82-64-122-65.subs.proxad.net. [82.64.122.65])
        by smtp.googlemail.com with ESMTPSA id u8sm93761wmm.15.2020.01.08.11.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 11:13:39 -0800 (PST)
Subject: Re: [PATCH net] net: usb: lan78xx: fix possible skb leak
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
References: <20200107185701.137063-1-edumazet@google.com>
From:   RENARD Pierre-Francois <pfrenard@gmail.com>
Message-ID: <393ec56d-5d37-ac75-13af-25ade6aabac8@gmail.com>
Date:   Wed, 8 Jan 2020 20:13:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107185701.137063-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I tried with last rawhide kernel 5.5.0-0.rc5.git0.1.local.fc32.aarch64
I compiled it this night. (I check it includes the patch for lan78xx.c )

Both tests (scp and nfs ) are failing the same way as before.

Fox



On 1/7/20 7:57 PM, Eric Dumazet wrote:
> If skb_linearize() fails, we need to free the skb.
>
> TSO makes skb bigger, and this bug might be the reason
> Raspberry Pi 3B+ users had to disable TSO.
>
> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> Cc: Stefan Wahren <stefan.wahren@i2se.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> ---
>   drivers/net/usb/lan78xx.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index f940dc6485e56a7e8f905082ce920f5dd83232b0..fb4781080d6dec2af22f41c5e064350ea74130b3 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -2724,11 +2724,6 @@ static int lan78xx_stop(struct net_device *net)
>   	return 0;
>   }
>   
> -static int lan78xx_linearize(struct sk_buff *skb)
> -{
> -	return skb_linearize(skb);
> -}
> -
>   static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
>   				       struct sk_buff *skb, gfp_t flags)
>   {
> @@ -2740,8 +2735,10 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
>   		return NULL;
>   	}
>   
> -	if (lan78xx_linearize(skb) < 0)
> +	if (skb_linearize(skb)) {
> +		dev_kfree_skb_any(skb);
>   		return NULL;
> +	}
>   
>   	tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
>   


