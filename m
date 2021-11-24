Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E2D45B451
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 07:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbhKXGjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 01:39:12 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:34352 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKXGjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 01:39:11 -0500
Received: by mail-wr1-f48.google.com with SMTP id j3so2235242wrp.1
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 22:36:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=jzv97KXGeHKud2cCD+IMjHAGwheYzN4/XLWvbpdaWoI=;
        b=2u0+xrhLSZZmN7ekRGL3ZxvMchNH+yrBix2vEmoL9msfN84P5YHKFlk2aIiHh/UeP7
         64F8+1ssrGDCMR/fDezRKzdMewSePUtH6i9bAT8GP9WzEtxvU8g1A2PW5T/QqvhirdqI
         ArnxZqYXx80hjh0WcXuus10yFfvfbL7a6qXg2jP9bNCO0MZoqGpX18htduBczXLK+UqR
         0LExtaiu7vPDg1VFmyolyBBK7Y07arUT4LYNFbkZfJCUIHEmPIfF40R7B/e//8bvos6d
         5KBRua+TzYJNtHJ2hj38xCZExlkF+M+RnuMpPxxsnGoo6RmFda+LSNeSGkSTxdx3ImrT
         WeSA==
X-Gm-Message-State: AOAM532fCLWPq9wjz1ifAkqwFjfRY5Co0LiImWpRUvCA7LRbFpFMD8sI
        hNp7FkbekAnJ9lJdboJiiAQ=
X-Google-Smtp-Source: ABdhPJxj1Am6viYsK6nkfE2BWlkXBbhmyJnuxdJutt8XHhDQQS7Y/FGIfyzxsy1AUsKKciVi/8ffiw==
X-Received: by 2002:a5d:5385:: with SMTP id d5mr15564128wrv.132.1637735761702;
        Tue, 23 Nov 2021 22:36:01 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id 8sm3216550wmg.24.2021.11.23.22.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 22:36:01 -0800 (PST)
Message-ID: <003d83a0-8958-c685-4f4f-4c6b7e2724e7@kernel.org>
Date:   Wed, 24 Nov 2021 07:35:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 1/3] mctp: serial: cancel tx work on ldisc close
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211123125042.2564114-1-jk@codeconstruct.com.au>
 <20211123125042.2564114-2-jk@codeconstruct.com.au>
 <b3307219-db82-d519-63df-dc246e11b037@kernel.org>
In-Reply-To: <b3307219-db82-d519-63df-dc246e11b037@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24. 11. 21, 6:36, Jiri Slaby wrote:
> On 23. 11. 21, 13:50, Jeremy Kerr wrote:
>> We want to ensure that the tx work has finished before returning from
>> the ldisc close op, so do a synchronous cancel.
>>
>> Reported-by: Jiri Slaby <jirislaby@kernel.org>
>> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
>> ---
>>   drivers/net/mctp/mctp-serial.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/mctp/mctp-serial.c 
>> b/drivers/net/mctp/mctp-serial.c
>> index 9ac0e187f36e..c958d773a82a 100644
>> --- a/drivers/net/mctp/mctp-serial.c
>> +++ b/drivers/net/mctp/mctp-serial.c
>> @@ -478,6 +478,7 @@ static void mctp_serial_close(struct tty_struct *tty)
>>       struct mctp_serial *dev = tty->disc_data;
>>       int idx = dev->idx;
>> +    cancel_work_sync(&dev->tx_work);
> 
> But the work still can be queued after the cancel (and before the 
> unregister), right?

Maybe do it in ->ndo_uninit()?

>>       unregister_netdev(dev->netdev);
>>       ida_free(&mctp_serial_ida, idx);
>>   }
>>
> 
> thanks,


-- 
js
suse labs
