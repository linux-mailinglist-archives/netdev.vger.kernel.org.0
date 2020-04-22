Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C21B4B74
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgDVRTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVRTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:19:03 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800F7C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:19:03 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id i16so2682139ils.12
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KSVtlt7NXmNutc81+vekvqEq8LsuRuCJqqM7wfSQgEE=;
        b=ntd9B12ASH/sO5sr8RrvwzKIFNahJEGY4mzyDasBdLJJnNOU9ZHS8sOQAyf10DW0rZ
         q5a8TYa5F2VjOJ+tS/6Eu8kqOS8//qL3gvryoAnDq1n+DPZIMGjI2kk/QMUFCDlgui5S
         gg04ZYhCmQgXLbufeaHErIKOQyRrZq41NDYsJ8/ltnD38+kW6KWQsh9Mt1mPSQfs2QTA
         rUV/3Ni+jK5+TQEw0zQ+HtMPnE9ZyGqt/E2Ypg85E6RDATPUq/TGXu7QRToZqOhpQBO1
         OiGIRwFINn18kNdnjZFGpGw8Le7GlmK9apluGXyvPECWEHUPNSLBRr+YdYP79rApxoM3
         4Gdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KSVtlt7NXmNutc81+vekvqEq8LsuRuCJqqM7wfSQgEE=;
        b=A7BWIIp+qDZVvfgm9TaSMzDwZ/QIY9xx1kW2aR4RRHQs5WDUPWG06D1EGOypOnXQxR
         LDr6RenXMPlHqpEI1kHM4M+zgQ5zYzmsjy6/71hr/mUyVwxmtoBzMaTrU4NVP012Du7a
         Csh72J29OwLEreaREqWSXOOJEr74egLdk2UaIa78f3MfDiQjVr3KMOZw+4bVHiXRCqEe
         PWH8/ebfwHUFJeOrBgAMHZt7/5ok3WGShR+lgzavcP1bizlEwSe4jAoXkIr9A0ZwksKb
         H/jtK7XIC6iOxxUbvdSyILbSQmNcAorv0BXlrY9RY7t3f9/Vq5RL18STqxCDFOlsNwJl
         UfhQ==
X-Gm-Message-State: AGi0PuYP879AeDoFFLQKHGsYXBNCyqEuzPfTlAa0wi5fTQo9PDWldaWV
        QBFCwJy/cLQ58ecJjYuNvNC3Og==
X-Google-Smtp-Source: APiQypLIYORs1eoKA2Y/wMyNYsdsdQF0Q4hEXkpkiYEi7bo/Ibf3EabzEurBWuTotlzEPPWvuRAq6w==
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr27929531ilm.38.1587575942903;
        Wed, 22 Apr 2020 10:19:02 -0700 (PDT)
Received: from [192.168.0.105] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id e22sm1851801iot.24.2020.04.22.10.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:19:02 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2 1/2] bpf: Fix segfault when custom pinning is
 used
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <hadi@mojatatu.com>
References: <20200422102808.9197-1-jhs@emojatatu.com>
 <20200422102808.9197-2-jhs@emojatatu.com>
 <20200422093531.4d9364c9@hermes.lan>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <5a636d8d-e287-b553-b3fb-a62afbbde4ae@mojatatu.com>
Date:   Wed, 22 Apr 2020 13:19:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422093531.4d9364c9@hermes.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-22 12:35 p.m., Stephen Hemminger wrote:
> On Wed, 22 Apr 2020 06:28:07 -0400
> Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> 
>> From: Jamal Hadi Salim <hadi@mojatatu.com>
>>
> 
> This is not a sufficient commit message. You need to describe what the
> problem is and why this fixes it.
> 
> 
>> Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")
>>
>> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> ---
>>   lib/bpf.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/bpf.c b/lib/bpf.c
>> index 10cf9bf4..656cad02 100644
>> --- a/lib/bpf.c
>> +++ b/lib/bpf.c
>> @@ -1509,15 +1509,15 @@ out:
>>   static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>>   				const char *todo)
>>   {
>> -	char *tmp = NULL;
>> +	char tmp[PATH_MAX] = {};
> 
> Initializing the whole string to 0 is over kill here.

Why is it overkill? ;->
Note: I just replicated other parts of the same file which
initialize similar array to 0.

> 
>>   	char *rem = NULL;
>>   	char *sub;
>>   	int ret;
>>   
>> -	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
>> +	ret = snprintf(tmp, PATH_MAX, "%s/../", bpf_get_work_dir(ctx->type));
> 
> snprintf will never return -1.

Man page says it does. Practically it may not but we have code (in
iproute2) which assumes it will happen.

Pick your poison:
1) Ignore the return code
2) As suggested by Dominique, something along the lines of:
if (ret <= 0 || ret >= MAX_PATH)
    ...error here..

Which one do you prefer?

cheers,
jamal

