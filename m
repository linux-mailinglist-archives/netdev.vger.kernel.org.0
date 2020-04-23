Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF961B624B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgDWRqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730093AbgDWRqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:46:46 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA12CC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:46:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w4so7320179ioc.6
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vHt8PVnHHgfNCbD+V5T+3Vh2CunuDVqjk+hHcHmPAg4=;
        b=msk3HJfU9ILXyZH/MYpGto3oRCeyP2OinUcFvoBcoDrybLLqKm7Dx2b80X7bO/1O4m
         IMNDZvC9AqHKaK6U43UmImKNoutJDIsmgNwYczXjw2X5MdTjP1SLCRiovc/BViKqbhKz
         vr+wtnZwe0NlAiy25FtxHIOZ2IqGoi8JioY9b1F30TuIaJQCvyw5t+z6V5jt9Iq2KeMl
         iyQvPFDlzuM1ZqmeU6Aezz5d4sHWI61984rVOOuUkTW1UpwQLN0Rje/hT5ONVLsbZErx
         0FSAbd2hs4mKMUqpJDqEb8xFr2z19846p83jyZpCcYVQyHT4fHyVy34F3dsXn6kVh9Xz
         0LZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vHt8PVnHHgfNCbD+V5T+3Vh2CunuDVqjk+hHcHmPAg4=;
        b=JAxEHt7ImI0SVB+ai1qgdMOcVeNCvFu5HxjsWHtt6ToCUNrkkjlzFeI21a0unCY581
         rMGNmzGpQFMEptHaRHgVUSrilchOFuxRVKp5WPiRgZ5PxE6huxH2e6i80ioPrJbZIQbK
         l+RroOelsKOu8BWuwwfsIbRjPgtJbnKYaHPrUjQ8JPy6pDea05O+c/vEXPhc2vD6W8uE
         IjwIkrimdpr1Nm3yiWdkOK4n6ohXOaYeddIp3C2RIWOsnzen94fLHd74pXe+p8ZIbVrd
         1fqcMb5cnqpn23DM/20a/jPNQ8llVbwFf50Ahb7ODlm1CVBtKD9V+EsdLPnM2m1GPXkf
         ZbNw==
X-Gm-Message-State: AGi0PuZz5M8LpK0BJvFgBpQ/r1DEbkZjbJUz5JK3bKPPYQba9sYRZVKD
        Prj2UTUny6V8eCGY44pxkz2uXcMfa+AHNw==
X-Google-Smtp-Source: APiQypKHXZT+cmMm8lvPdl3mxY7kTPNo2MeWjQL4xP2nZ3Md5dru6TQxr5MFj46KsE/hpwpWS0m4EQ==
X-Received: by 2002:a02:c7c2:: with SMTP id s2mr4513255jao.130.1587664006031;
        Thu, 23 Apr 2020 10:46:46 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id r1sm1101607ilg.61.2020.04.23.10.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 10:46:45 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2 1/2] bpf: Fix segfault when custom pinning is
 used
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, Jamal Hadi Salim <hadi@mojatatu.com>
References: <20200422102808.9197-1-jhs@emojatatu.com>
 <20200422102808.9197-2-jhs@emojatatu.com>
 <20200422093531.4d9364c9@hermes.lan>
 <5a636d8d-e287-b553-b3fb-a62afbbde4ae@mojatatu.com>
 <20200423063020.GA31520@nautica>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b1b03d43-5f89-be71-4d74-b18a1d7d69d4@mojatatu.com>
Date:   Thu, 23 Apr 2020 13:46:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423063020.GA31520@nautica>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-23 2:30 a.m., Dominique Martinet wrote:
> Jamal Hadi Salim wrote on Wed, Apr 22, 2020:

[..]
>>> Initializing the whole string to 0 is over kill here.
>>
>> Why is it overkill? ;->
>> Note: I just replicated other parts of the same file which
>> initialize similar array to 0.
> 
> FWIW I kind of agree this is overkill, there's only one other occurence
> of a char * being explicitely zeroed, the rest isn't strings so probably
> have better reasons to.

But "overkill" is such a strong word;-> Is it affecting performance,
readability, or is the point that it was over-engineering exercise?
Do note: there's other code that does the same thing (even in
the same file!). And all i did was, in TheLinuxWay(tm),
just cutnpasted.
Same thing with checking for return code of snprintf.

Consistency is the problem - because there are different styles
in the same tree. Possibly had i sent the code using the suggested
approach someone would have probably pointed out i shouldve used
the approach i did;->
In any case, i think we are now heading in the direction
of the bike shed ;->

I will fix this and snprintf in the next update.

> 
> snprintf will safely zero-terminate it and nothing should ever access
> past the nul byte so it shouldn't be necessary.
> 

It would also depend on the knowledge of the coder on what could
go wrong.
You may still want to know what you think you wrote in there was
picked up (so checking max size)..
I dont know why the manpage says you'll get a negative return
but the safest thing against Murphy should be to check for all
possible boundary conditions.

Note: The original fix from Andrea was for a compiler warning on
snprintf.

I will send the next update..

cheers,
jamal
