Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB3C574ACD
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237706AbiGNKiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237555AbiGNKiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:38:08 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4AC4BD31;
        Thu, 14 Jul 2022 03:38:07 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id ez10so2590217ejc.13;
        Thu, 14 Jul 2022 03:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Da9JEC7sUGHY+kW86al+MlF51R6SUQjf24M49G8OwHc=;
        b=sSt79Ao4EA+Sxqycj92HB5U/EtwADsyJ5pv73fws0WSE4R0I1EofkXUc9DIj/s7Zg6
         lSpUYIKzv1Hn5Z6dtghYseCMkm861+Zhu8rXaH0/tEiVPzOQNkJsfrFYesZutyO8TqIe
         RouSnuigy3LmKeWY5EPl3YWq1J9ZuZuIAdgS1ZCZuW4sPEalAoK4uWpZJzx33z21nUMd
         XYGJRz71rg6FfMDs1cOhYQCiArBUfqkjsNt41mTfNT4/99tFqeWcYTihGZkJtTKk/ElG
         rXNKfupwBtz2+iWkkEbEDn5Hz/awKzg7wpW3+iCqVWIKth8BWwv/5MvtXCQzEm0rU0/3
         a8jQ==
X-Gm-Message-State: AJIora963kLSK0I78RdNMz3Z6dlrxGBjmT9zesvnzqX8hkvVKrG2ke3b
        nNgOjuCL7vjQKkJqIjotqlU=
X-Google-Smtp-Source: AGRyM1tylAikhT0jp8xuKYehbTcWTlzDur0ynRLeAdWpAL3ujadz/4Hz4YTv5mkPVzYlKcYDne9mDA==
X-Received: by 2002:a17:907:2815:b0:72b:70f6:4ced with SMTP id eb21-20020a170907281500b0072b70f64cedmr7883051ejc.353.1657795085810;
        Thu, 14 Jul 2022 03:38:05 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id ey6-20020a0564022a0600b00431962fe5d4sm805026edb.77.2022.07.14.03.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 03:38:04 -0700 (PDT)
Message-ID: <78cd3375-e95e-51b2-bf89-bad645e16ea4@kernel.org>
Date:   Thu, 14 Jul 2022 12:38:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] can: slcan: do not sleep with a spin lock held
Content-Language: en-US
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org
Cc:     lkp@lists.01.org, Jeroen Hofstee <jhofstee@victronenergy.com>,
        lkp@intel.com, kernel test robot <oliver.sang@intel.com>,
        Richard Palethorpe <rpalethorpe@suse.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        ltp@lists.linux.it, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20220713154458.253076-1-dario.binacchi@amarulasolutions.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220713154458.253076-1-dario.binacchi@amarulasolutions.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13. 07. 22, 17:44, Dario Binacchi wrote:
> We can't call close_candev() with a spin lock held, so release the lock
> before calling it.
> 
> Fixes: c4e54b063f42f ("can: slcan: use CAN network device driver API")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/linux-kernel/Ysrf1Yc5DaRGN1WE@xsang-OptiPlex-9020/
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> 
> ---
> 
> Changes in v2:
> - Release the lock just before calling the close_candev().
> 
>   drivers/net/can/slcan/slcan-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
> index 54d29a410ad5..5214421dedf3 100644
> --- a/drivers/net/can/slcan/slcan-core.c
> +++ b/drivers/net/can/slcan/slcan-core.c
> @@ -689,6 +689,7 @@ static int slc_close(struct net_device *dev)
>   		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
>   	}
>   	netif_stop_queue(dev);
> +	spin_unlock_bh(&sl->lock);
>   	close_candev(dev);
>   	sl->can.state = CAN_STATE_STOPPED;
>   	if (sl->can.bittiming.bitrate == CAN_BITRATE_UNKNOWN)
> @@ -696,7 +697,6 @@ static int slc_close(struct net_device *dev)
>   
>   	sl->rcount   = 0;
>   	sl->xleft    = 0;

So all these sets need not be under the spinlock?

If so, you should explain why in the commit message.

> -	spin_unlock_bh(&sl->lock);
>   
>   	return 0;
>   }

thanks,
-- 
js
suse labs
