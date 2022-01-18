Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943F3492E11
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 20:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348561AbiARTAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 14:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348554AbiARTAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 14:00:35 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B54C06173E;
        Tue, 18 Jan 2022 11:00:34 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id b14so56182383lff.3;
        Tue, 18 Jan 2022 11:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WPi7cOaqxmlfXtjEvnXzyxsFr/ba0vn/8SuRU7fcy3A=;
        b=GOqwB2MQdS93IXWsAsm01khNW3l7Y73tlxa/Ntt9TWOntGRt3iUwtEga6A2mP+6/Iy
         f0r0fbJB4LIRz8bOLN/JZcHCMv3WZEZmoBVGHJa+jb/1Ug8j2XQbl1mW1sGxsHqbYE54
         2S5y+XfkUftsCYCRMhl/MF2tVQoDAzbqQ+idRwvCpYaQ0A9Oo6zcG2CnQeXkM+EziMnI
         LMVTo+2Wgb3zH/iOkQhNW7wLkMd/KdpvU3eFizJgpROV6MA4/6tiP06iLh/Yu168SLE+
         Bk2oUvwfgK3HuPjJkJZ7sEv+9IG+q9wDMOLhHxudisPQpyyWQfBO/3Ph96+dqY88lG4H
         LgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WPi7cOaqxmlfXtjEvnXzyxsFr/ba0vn/8SuRU7fcy3A=;
        b=mVy8hGdbtT0AJmqhQ/7i1SCW2Ly4kbzjXQxD2uFsHAt/uXJmIgjaMOyWMUC5NUCdFm
         euSp6qze9/hg3C7vyBrlSKDFIQaBDrqjIn9i86uwKox41GMCSXMmhx9y+z9u12IDAqDt
         i1/A5AYJuc74k7fwm+DZ//QS24XjBFYpLJlN2vG27084ElVGhHzrhS0DqIi2HAgo08ga
         0Zj8LLCV9PIxjaraO1aD6Pyvn1/lvL8IzGRUQLB/ClJtF0MMpL33oYGdTcQ8U2BoDOkg
         IjH50nL4q0WY1YXV6nEjYnEGUDVd99YAeNSlFtGZkZQprizeT1JHjnLqsEs9BcLOExe4
         lKQw==
X-Gm-Message-State: AOAM530kGeujRy17+HLF0Wx9w2byIgQSG0SQR04bnpasiEHeq69to9Lu
        EqoYUlnxt5ac8yVNefgd+sc=
X-Google-Smtp-Source: ABdhPJxfN95MAGUJJ/wBvhI7JuoatDaSy685fRbr5BjD7GfTpTnpe15beyQ9UJdsHC3QbClLuyTr0Q==
X-Received: by 2002:a2e:9bd5:: with SMTP id w21mr15589147ljj.417.1642532432107;
        Tue, 18 Jan 2022 11:00:32 -0800 (PST)
Received: from [192.168.1.11] ([94.103.227.208])
        by smtp.gmail.com with ESMTPSA id d36sm1773796lfv.230.2022.01.18.11.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 11:00:31 -0800 (PST)
Message-ID: <5431144f-62d4-23f8-c60b-c11c52863c66@gmail.com>
Date:   Tue, 18 Jan 2022 22:00:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFT] net: asix: add proper error handling of usb read
 errors
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, oneukum@suse.com, robert.foss@collabora.com,
        freddy@asix.com.tw, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
References: <20220105131952.15693-1-paskripkin@gmail.com>
 <d2a4ad77-3ade-9319-f99c-82201c4268e5@gmail.com> <YeZbzM6TDCIEvCUc@kroah.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <YeZbzM6TDCIEvCUc@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On 1/18/22 09:18, Greg KH wrote:
> On Mon, Jan 17, 2022 at 10:31:21PM +0300, Pavel Skripkin wrote:
>> On 1/5/22 16:19, Pavel Skripkin wrote:
>> > Syzbot once again hit uninit value in asix driver. The problem still the
>> > same -- asix_read_cmd() reads less bytes, than was requested by caller.
>> > 
>> > Since all read requests are performed via asix_read_cmd() let's catch
>> > usb related error there and add __must_check notation to be sure all
>> > callers actually check return value.
>> > 
>> > So, this patch adds sanity check inside asix_read_cmd(), that simply
>> > checks if bytes read are not less, than was requested and adds missing
>> > error handling of asix_read_cmd() all across the driver code.
>> > 
>> > Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
>> > Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
>> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> > ---
>> 
>> gentle ping :)
> 
> It's the middle of a merge window, and you ask for testing before it can
> be applied?
> 

I indeed lost track of days, sorry for bothering during merge window, my 
bad.

FYI, this patch was tested by Oleksij [1], that why I decided to ping, 
but as I said I lost track of days a bit

[1] https://lore.kernel.org/all/20220105141535.GI303@pengutronix.de/


With regards,
Pavel Skripkin
