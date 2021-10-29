Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8086F44005D
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhJ2Qcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhJ2Qcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 12:32:46 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2F3C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 09:30:18 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p40so4890747pfh.8
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 09:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=txl43EV+zeEEnK6vy8BX7+Ofayf3hqNln0n/t2wWrQ8=;
        b=Lazdh9IaLFnwynu9VEiMhenyvDDXHXtYm8UdKs//K1iWqeMjpSCw7emg2AyhWVWFel
         AIDo5KazjWR53PLw/FUzXELYudqkHzjCLUHMFrLYaG/KH3jSkmg1IHFHEsvAj0Qgzjr6
         vTg/rcBYrLU9zVnJdi4cCwP8V52h8IW1MtMknqZpwC1DBzBkU3Mef1AiF6ej4cq57sVJ
         9VX6po7j52Y58ie8bY5rRuuIx8KxAQicQcojZ0yUZgAvZqVfUfT8iA23+6Ms6eGPy+Eu
         3Vitz2Q1/r6ObTjVRNyncZp0rfn9PBenmqDaYXHNb+Rsxx2Bwz4mpj9jxVWrZRslnlJn
         N6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=txl43EV+zeEEnK6vy8BX7+Ofayf3hqNln0n/t2wWrQ8=;
        b=HY+38S7r90URzZFkCTupaeutYs39zo8UZu7FZvGiJr4N35gCW8ggFXaUMdtc0eHliJ
         B/aD1e5GFBya7MT9ybaDzDC8UyANXs79bOsAE3swCBknSrjUmWjo9EmWjxuxsg1avzPF
         c7N21HwEcA1h2cfHKb4FcEU+W1SsZd+vcDnKlaty7NDnv00jxi2tIpe7a0xDEDXODk55
         itxsw92G33QVNomw1D3z5h0B6U6qtHPhs1ZMi8z2W7Ayu1WhtpOhcn9ObLBnf9gE06Qg
         JQYXEi8nuSRxG2wItfm5YI1mnKmsf5/oW/NAdgoDmCx892sAuu0Ve8Gw2mu98NCkr3wc
         dLYg==
X-Gm-Message-State: AOAM532BQP2o1Sc5M/SX31029ZF6WJuTXK/8H1ckInGCxKUVrzOEDu+B
        TQCjWoSaue3NBrxtH7ZUoxQ=
X-Google-Smtp-Source: ABdhPJxftzWZqTpq9ZV3qYS1vwy90a9WCJ0Crl+7R9XTTPL4gQVt7jgpscwod9cTBhb0LYbxxLVs1g==
X-Received: by 2002:a05:6a00:a8b:b0:44d:ef7c:94b9 with SMTP id b11-20020a056a000a8b00b0044def7c94b9mr12047192pfl.36.1635525017536;
        Fri, 29 Oct 2021 09:30:17 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 142sm5973579pgh.22.2021.10.29.09.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 09:30:17 -0700 (PDT)
Subject: Re: [PATCH] tcp: Use BPF timeout setting for SYN ACK RTO
To:     Akhmat Karakotov <hmukos@yandex-team.ru>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexander Azimov <mitradir@yandex-team.ru>, zeil@yandex-team.ru,
        Lawrence Brakmo <brakmo@fb.com>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <b8700d59-d533-71ee-f8c3-b7f0906debc5@gmail.com>
 <6178131635190015@myt6-af0b0b987ed8.qloud-c.yandex.net>
 <87d9c47b-1797-3f9a-9707-48d2b398dba3@gmail.com>
 <2A707577-CBEA-42C9-A234-2C2AB7E7F7BB@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <863fdf13-b1f4-f429-d8ac-269f9ceaa747@gmail.com>
Date:   Fri, 29 Oct 2021 09:30:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2A707577-CBEA-42C9-A234-2C2AB7E7F7BB@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/21 9:19 AM, Akhmat Karakotov wrote:
> 
>> On Oct 25, 2021, at 23:48, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> Also, have you checked if TCP syn cookies would still work
>> if tcp_timeout_init() returns a small value like 5ms ?
>>
>> tcp_check_req()
>> ...
>> tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((tcp_timeout_init((struct sock *)req)/HZ)<<req->num_timeout);
>>
>> -> tmp_opt.ts_recent_stamp = ktime_get_seconds()
>>
>>
> 
> I may have overlooked this. As long as I remember TCP SYN cookies worked
> but I will recheck this place again. Also could you please tell in what way exactly
> does this relate to syn cookies? I may have misunderstood what the code does.
> 

This was badly written.

This should have been two different questions.
