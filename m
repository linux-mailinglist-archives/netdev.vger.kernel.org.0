Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F9545B401
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 06:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhKXFkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 00:40:01 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:33670 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbhKXFkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 00:40:01 -0500
Received: by mail-wm1-f48.google.com with SMTP id r9-20020a7bc089000000b00332f4abf43fso3290869wmh.0
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 21:36:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5WFKu4Bo1/BdapI3OQCFlgCOVVsSlRyF6xhtvPVl3qk=;
        b=MRJOpIB9oCrpTNcdqxrJsHDcd2iynohch8f0DS8m1dHi76+jrhi3iwfexu5paQgCLx
         O0UkHTX7SqKOU9JvFWR5MkR2CPxNeGzGBlMc4CUnYucEUcyu3hobcHToTpbeaKBiqXGs
         MqBi7rvUwYR4k/Eh7baKbICRQ4qxLdIhapDDdUkfTUsT/Cxp/Z9vTfvSOHeTWI1k+wpX
         EWvb2anG1jxtBWwp+9UdR0ELsoztHQ+yVa7iBOTRT27Pbre9UBw0/qg5YxbvhEood6lv
         24edyh14Z2YHP36ELXV2TvDP9cPldUFLBaBRUck/8Euf5LtBxZK6SleQdaoWXj6Rwwdk
         VH5w==
X-Gm-Message-State: AOAM531jpoE1SbL3nT2DunUSQg8ueO+tTh25MS5kGQeIm0Xe/Z2FIoTq
        5Nt5aAbB4z5H2mERwWSyrMo=
X-Google-Smtp-Source: ABdhPJyAlkdOMGKEssxs7XHdPf5WO+9K4OdRhsJUvUfnFzzB45D/hYFxtbil2J3y7jLM6Zg7DA8vHw==
X-Received: by 2002:a05:600c:1e06:: with SMTP id ay6mr12133246wmb.64.1637732211495;
        Tue, 23 Nov 2021 21:36:51 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id m1sm3298450wme.39.2021.11.23.21.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 21:36:51 -0800 (PST)
Message-ID: <b3307219-db82-d519-63df-dc246e11b037@kernel.org>
Date:   Wed, 24 Nov 2021 06:36:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 1/3] mctp: serial: cancel tx work on ldisc close
Content-Language: en-US
To:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211123125042.2564114-1-jk@codeconstruct.com.au>
 <20211123125042.2564114-2-jk@codeconstruct.com.au>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20211123125042.2564114-2-jk@codeconstruct.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23. 11. 21, 13:50, Jeremy Kerr wrote:
> We want to ensure that the tx work has finished before returning from
> the ldisc close op, so do a synchronous cancel.
> 
> Reported-by: Jiri Slaby <jirislaby@kernel.org>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
> ---
>   drivers/net/mctp/mctp-serial.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
> index 9ac0e187f36e..c958d773a82a 100644
> --- a/drivers/net/mctp/mctp-serial.c
> +++ b/drivers/net/mctp/mctp-serial.c
> @@ -478,6 +478,7 @@ static void mctp_serial_close(struct tty_struct *tty)
>   	struct mctp_serial *dev = tty->disc_data;
>   	int idx = dev->idx;
>   
> +	cancel_work_sync(&dev->tx_work);

But the work still can be queued after the cancel (and before the 
unregister), right?

>   	unregister_netdev(dev->netdev);
>   	ida_free(&mctp_serial_ida, idx);
>   }
> 

thanks,
-- 
js
suse labs
