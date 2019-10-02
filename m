Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD45C9347
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfJBVIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:08:44 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46893 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729316AbfJBVIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:08:44 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so296336pgm.13
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X+8bmAmrtR87H1ULnWamgFG18JfBhpSz7zIQC0CYtms=;
        b=juf5QcFUJe3DodAihJ+OHH2fHL9nYyOU7oUCMHg8bfYm4GraiUTYhA/1SsRzgFLuWM
         57cSesFYJVNWZ+pVsrqUe7PeUQZ4nCpvKwcxrnUTb6EAM2Vjw1f7GOcZb8J90eZdPzgo
         s3NVuRkUVe4m5uP/VYA5s/wiLoqBXLaLcGo2CLy0/sU1/48LNPDMx6qR0GJzqFICCIgm
         4/Mv+WIUxnviZUF4pMsK9gHL0FdqSGcseTLzuE1WD5goZTycGnxzHqXLHDgF1mFRj9Eu
         yIrHCT5G2V4qpwdAKnIyAdGs3l6At/nzy4T6jCzHPwadFVgJxrK74kdg3fXVp06DNUwG
         HvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X+8bmAmrtR87H1ULnWamgFG18JfBhpSz7zIQC0CYtms=;
        b=TuP3RezwEEYuZ5np4EG8Aru4jJop3lq8eWHRRTrKtCetJLAwaYq4WHm1ZMJJ6wf4TM
         2SENpCoWj9sJAqAfq8he/y9G80NCm/bMQpv5AurPwIeddJt1fVZgb8oHtR/s9ptsxXOd
         jA/wCB+XcRBr6CZFJQSM4qYulb7V3WQdyHwxAEYZuC0AeJqt17RoQvTSKnaYaNzM6Y8K
         YMKcQMuMgc5/wwZyPdwNDMoYurK00VAPnJK9AV9h1uS99NQ3BddVTK4qMobnmnL1qUje
         itEg5r59l5yIQ5zJyFfeshrPOEvT9SJS03Cr/2qSKHltuiCicmAoYDeLJABOboroKzUE
         +5gQ==
X-Gm-Message-State: APjAAAVvSco+x9NFU9O9xNPgOs+PzgFoaZBxZ1santo0XJamGw1yOnQm
        ZYVMxg5ZuWRdXmtRlW/fZHmIVcfG
X-Google-Smtp-Source: APXvYqwgLyDP5io6soe8WYOo9QACMJdpYfcCku4CTKVdDTd1hrRJetOwserQi70CRIO+bfQQfXHl/g==
X-Received: by 2002:a63:170e:: with SMTP id x14mr5833349pgl.4.1570050523646;
        Wed, 02 Oct 2019 14:08:43 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id x125sm375409pfb.93.2019.10.02.14.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 14:08:42 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com,
        David Ahern <dsahern@gmail.com>
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
Message-ID: <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
Date:   Wed, 2 Oct 2019 14:08:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/19 11:18 AM, Eric Dumazet wrote:
> 
> 
> On 9/30/19 8:28 PM, David Ahern wrote:
>> From: David Ahern <dsahern@gmail.com>
>>
>> Rajendra reported a kernel panic when a link was taken down:
>>
>> [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
>> [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
>>
>> <snip>
>>
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> Thanks !
> 

Apparently this patch causes problems. I yet have to make an analysis.
