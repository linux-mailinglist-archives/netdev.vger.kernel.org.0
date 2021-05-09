Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21094377637
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 12:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEIKWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 06:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhEIKWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 06:22:45 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8625EC061573;
        Sun,  9 May 2021 03:21:41 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j10so19077545lfb.12;
        Sun, 09 May 2021 03:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HFXMGjQXsx8cPfls0P25GX5EYjEvlBhZLtRkWvOLBbU=;
        b=HbaKlPcKJjfvWmo1tXYJDJWDL8lz82Iop7XnYyeGFeB5M+B38w7ITgbxxsTZpa6nk5
         sQUqHglNMVis+t0w8+Phewmm0CJHCkq0Z3C9b03TM/B02H1oCJxeC8NiI7xW77TNQiAY
         t6bkjOiLxm2pal+tRjHtPx0e8ITSfIFaTRCbj0/MHFMuwtYuksPvLZUDLF++zMyU+4Fu
         qu9gmXjWZFZ72hSTUQISRv/DzcSa0Qs/wrr8+muIQM103x3vffdShqox/4xx2y53WOKF
         Qzye4ea1/MVG4+U0vsWrVcGpLwtt7RI6wFucyInbS+rQH/x27Mw0n8dAccqQ/7aAhc6k
         tTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HFXMGjQXsx8cPfls0P25GX5EYjEvlBhZLtRkWvOLBbU=;
        b=AI+Sl+yB1G+iQBS/dEdQlZCd2WE5egGdKkQ99+gIKtAWXJaHVkdBIlWty7TUXKXzH+
         fYdqDDaYPe+jAf3ca+EaAgeBgHvVUFvjW14pvhUSFzzLBsOALtJL+qNBPD3JEWAaajBS
         Vw6sIrgcIci6ntnooVcXhfSb00e1/xSdmOQtxviMyIAutzlUojuzDCBVZC0L962X891F
         kZNXzcU1Bk5c66pj+qnulgQCni697G0EjZZ+sXpn2p3e/mfKI5b1ZF5iZoIN4FD6mcix
         mR/zdVNs4xJzjhshNWqp/EmfUiUCb4EK2LbRJ/29rsZ9XiM5OLDBiJex979oA/l3HT1a
         nItg==
X-Gm-Message-State: AOAM5326TPGenu28ilwMVoIFCBpkgSWkzCDNJvOEvuepye1fN/kTAiZX
        Nrd+90tE1UjxDtI+kk8sWTgozS7+B/w=
X-Google-Smtp-Source: ABdhPJwGIvlsUYDyD+T0xVCapbtGIpnD5HUd4mY3Q7ARlT2nxJnxEDSeRLUtFNUT3S5mp0xEnb1wgg==
X-Received: by 2002:a19:808f:: with SMTP id b137mr13506155lfd.162.1620555699936;
        Sun, 09 May 2021 03:21:39 -0700 (PDT)
Received: from [192.168.1.100] ([178.176.79.150])
        by smtp.gmail.com with ESMTPSA id 8sm429399ljj.138.2021.05.09.03.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 03:21:38 -0700 (PDT)
Subject: Re: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
 <68291557-0af5-de1e-4f4f-b104bb65c6b3@gmail.com>
Organization: Brain-dead Software
Message-ID: <04c93015-5fe2-8471-3da5-ee85585d9e6c@gmail.com>
Date:   Sun, 9 May 2021 13:21:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <68291557-0af5-de1e-4f4f-b104bb65c6b3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.05.2021 23:47, Sergei Shtylyov wrote:

>     Posting a review of the already commited (over my head) patch. It would have
> been appropriate if the patch looked OK but it's not. :-/
> 
>> When a lot of frames were received in the short term, the driver
>> caused a stuck of receiving until a new frame was received. For example,
>> the following command from other device could cause this issue.
>>
>>      $ sudo ping -f -l 1000 -c 1000 <this driver's ipaddress>
> 
>     -l is essential here, right?
>     Have you tried testing sh_eth sriver like that, BTW?

    It's driver! :-)

>> The previous code always cleared the interrupt flag of RX but checks
>> the interrupt flags in ravb_poll(). So, ravb_poll() could not call
>> ravb_rx() in the next time until a new RX frame was received if
>> ravb_rx() returned true. To fix the issue, always calls ravb_rx()
>> regardless the interrupt flags condition.
> 
>     That bacially defeats the purpose of IIUC...
                                           ^ NAPI,

    I was sure I typed NAPI here, yet it got lost in the edits. :-)

>> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
[...]

MBR, Sergei
