Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B4E4E1EE0
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 02:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344072AbiCUBtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 21:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343763AbiCUBtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 21:49:01 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D214717E368;
        Sun, 20 Mar 2022 18:47:37 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id c11so9277578pgu.11;
        Sun, 20 Mar 2022 18:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SOfMbm5RJKvVdhj3M5lguM9j4PPbRfpyMx1l0V2G0sM=;
        b=YD/sFWwZJgwFHupdzTKj19DesWJPVhibD5xUNFAr41Iqcb6q/n0EE5JL2i88wqugvJ
         4P7CEEMqcrkZn+e2GwMvW939nl+0L9xEqXL6v66kx4bnHGgsGuxfKBFA6ry8pUpLBjYN
         8Q3qT/gTYFKbTpr5ULNEEk6WYj1/ki32mjXXf7zXMQBRjcmGvSES4dXo52rP8lyw0S2h
         LbPbzP51hsLEGsEuA2T147IXbc7vPpnuZIxEue6vbPa4VYqlapiC02AOyEU12FvZal3U
         eR5PjYfw7wdGi4rQ/EZrWq0/KkiBeyfYD6tCJ7RC67oPXtLAf60dkH0rFM6UCK71gql1
         HDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SOfMbm5RJKvVdhj3M5lguM9j4PPbRfpyMx1l0V2G0sM=;
        b=UCqYm7nQXJrUQxWGrkSRZNQovqspnb0KB3N6sA3JRAI/4KRLru9xNKUGTz+pLrjdev
         JKzLnQCAUNvxhctqGyZeY0Gfk/jABRhmZpdtVp/gvzfnF4ioIx1sE1oLL/i0W/vGtmyT
         bbRGlQI5Z3rbQHXHdGbHgvy7Sm4Er8dX9eOT0rSRwavSs/3XTLHO35pwhk2sazh52muE
         WNGKN9RcpeD10k400uLztwdwZy2161XrNREXJrmTfgvcgr5/mbi+IbLTKke5MQcstKx+
         z1yO0btSGDrFV9yBTt1y0HRChrEHX4Aij1Ekai/H/kCiW4lEaNK1QtxSIuJS6+kryoBY
         +AGw==
X-Gm-Message-State: AOAM53033oKnmSLw0dC5GslGfI2tCKSxy6UvJoGEwZEmRxrgeXFScLTZ
        qGKhorkpuUPbRqiTwBxRWSw=
X-Google-Smtp-Source: ABdhPJy9vF2yPyOMLUrz5Shpq535MiBZLAqZb32nSc0lGiBI8aK2dWSqx66kmayAta6/+ktf1Ye3MQ==
X-Received: by 2002:a05:6a00:889:b0:4e0:dcc3:5e06 with SMTP id q9-20020a056a00088900b004e0dcc35e06mr21497904pfj.29.1647827257386;
        Sun, 20 Mar 2022 18:47:37 -0700 (PDT)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id q12-20020a17090a178c00b001bd036e11fdsm18080673pja.42.2022.03.20.18.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 18:47:36 -0700 (PDT)
Message-ID: <0d2f9980-fb1d-4068-7868-effc77892a97@gmail.com>
Date:   Mon, 21 Mar 2022 09:47:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] can: mcba_usb: fix possible double dev_kfree_skb in
 mcba_usb_start_xmit
Content-Language: en-US
To:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, paskripkin@gmail.com,
        remigiusz.kollataj@mobica.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220311080208.45047-1-hbh25y@gmail.com>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220311080208.45047-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle ping.

On 2022/3/11 16:02, Hangyu Hua wrote:
> There is no need to call dev_kfree_skb when usb_submit_urb fails beacause
> can_put_echo_skb deletes original skb and can_free_echo_skb deletes the cloned
> skb.
> 
> Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>   drivers/net/can/usb/mcba_usb.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> index 77bddff86252..7c198eb5bc9c 100644
> --- a/drivers/net/can/usb/mcba_usb.c
> +++ b/drivers/net/can/usb/mcba_usb.c
> @@ -364,7 +364,6 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
>   xmit_failed:
>   	can_free_echo_skb(priv->netdev, ctx->ndx, NULL);
>   	mcba_usb_free_ctx(ctx);
> -	dev_kfree_skb(skb);
>   	stats->tx_dropped++;
>   
>   	return NETDEV_TX_OK;
