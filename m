Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E914059BA
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhIIOyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbhIIOyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:54:44 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06194C061574;
        Thu,  9 Sep 2021 07:53:34 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso2789527otv.12;
        Thu, 09 Sep 2021 07:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TM4uR7MYSBmGP5NBL1zBrMe7eUBmghAcfkl2JUGwpAI=;
        b=O10es/ON911runMDSkfuH0UU/Qc1B70lCG/VlA8X2egEqUF3DaobxWWLhSaxWcrkyd
         Hx9itcKE7CFlcaKNJrW7kzDw6vq90btHnnui3yX/llEUYOZxBYhix1YZOw8uExbQITfA
         rPfCeaM7T7j1yURY03JgBnAR+PSyzjQAjmlvhuFlNxnRYbYWKRywZzVAWX/jhLBI1uJD
         KR0bq67fm5NwM4X1BGkYFvMIalTZEY9RA6Q+ll1OlY1d+c0Wf0CE04N3PCiqpz9u26On
         Nc1ljwIGs9jn/z96fpr4t0a8Q9aMp81QrhNzthPMR2Ptrke1qHh2tgP6YAxdP3CRKah9
         WG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TM4uR7MYSBmGP5NBL1zBrMe7eUBmghAcfkl2JUGwpAI=;
        b=ftwb6lbitd0FGH9rd8seK69swAXkzNRcfVJMzobW7ZPq3i/yaGYm63hgnaTUokBU0R
         tGgcSWlB9y33Ws5uFrOVr1PWIoS2VB/RrSdwGNW+itQXNS3KhOV9epQYUB2eUyrQpnr+
         fGt1hCk0swAC09wuhOkIRs4lyoZX/Y5qooMjIhbTkkz0nE0IdGbhJ52FqI3jplrkHGxt
         FICjhuc93EyWDF06CfFC3JA1xPdozJp1NBlbP7h6UGi0t26Obx0WiVcKfv6OsXaQzrQ6
         K5V1vPTmgJcNJ3C3gPtu4N80+KB31qXRs8ED9uLCAyk6+D2+j/QIcBulWU3IMqd9q3aZ
         jrNQ==
X-Gm-Message-State: AOAM530ASCSlUHOqv243k63v9QyZWvUjzKZK1hQO0VT46MjaEcSXeYez
        Ghk+i/kfrhWp+uOSclXkLNs+UP8Ygs0=
X-Google-Smtp-Source: ABdhPJwI837/3QsXonMBsK8Rc1vgjHn+HG+E2WgueUDEQgrBOixmYLFaLMsKnIJqpTiq3E6qBuP3ag==
X-Received: by 2002:a05:6830:13c4:: with SMTP id e4mr250251otq.58.1631199213050;
        Thu, 09 Sep 2021 07:53:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s17sm487211otr.51.2021.09.09.07.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 07:53:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     ajk@comnets.uni-bremen.de, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210909035743.1247042-1-linux@roeck-us.net>
 <20210909.123442.1648633411296774237.davem@davemloft.net>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] net: 6pack: Fix tx timeout and slot time
Message-ID: <751f5079-2da1-187e-573c-d7d2d6743bbf@roeck-us.net>
Date:   Thu, 9 Sep 2021 07:53:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210909.123442.1648633411296774237.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/21 4:34 AM, David Miller wrote:
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Wed,  8 Sep 2021 20:57:43 -0700
> 
>> tx timeout and slot time are currently specified in units of HZ.
>> On Alpha, HZ is defined as 1024. When building alpha:allmodconfig,
>> this results in the following error message.
>>
>> drivers/net/hamradio/6pack.c: In function 'sixpack_open':
>> drivers/net/hamradio/6pack.c:71:41: error:
>> 	unsigned conversion from 'int' to 'unsigned char'
>> 	changes value from '256' to '0'
>>
>> In the 6PACK protocol, tx timeout is specified in units of 10 ms
>> and transmitted over the wire. Defining a value dependent on HZ
>> doesn't really make sense. Assume that the intent was to set tx
>> timeout and slot time based on a HZ value of 100 and use constants
>> instead of values depending on HZ for SIXP_TXDELAY and SIXP_SLOTTIME.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> No idea if this is correct or even makes sense. Compile tested only.
> 
> These are timer offsets so they have to me HZ based.  Better to make the
> structure members unsigned long, I think.
> 

Hmm, ok. Both tx_delay and slottime are updated in sp_encaps(), though,
from data in the transmit buffer. The KISS protocol description states
that the values are in units of 10ms; that is where my assumption
came from.

Command        Function         Comments
    0           Data frame       The  rest  of the frame is data to
                                 be sent on the HDLC channel.

    1           TXDELAY          The next  byte  is  the  transmitter
                                 keyup  delay  in  10 ms units.
                 		The default start-up value is 50
                                 (i.e., 500 ms).

    2           P                The next byte  is  the  persistence
                                 parameter,  p, scaled to the range
                                 0 - 255 with the following
                                 formula:

                                          P = p * 256 - 1

                                 The  default  value  is  P  =  63
                                 (i.e.,  p  =  0.25).

    3           SlotTime         The next byte is the slot interval
                                 in 10 ms units.
                                 The default is 10 (i.e., 100ms).

But then slottime is indeed used with jiffies, which is odd.

tx_delay is used (before it is updated) in encode_sixpack()
and added to a character buffer. I thought that was the value sent
on the wire (which would again be supposed to be in 10ms units).
I don't see where else it is used, but I may be missing it.
That means though it can not easily be changed to anything
but unsigned char.

Anyway, I am inclined to just mark the protocol as dependent on
!ALPHA. Would you accept that ?

Thanks,
Guenter
