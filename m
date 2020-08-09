Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41AF23FEB8
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 16:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgHIOSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 10:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgHIOSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 10:18:24 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1106C061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 07:18:23 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k20so5984753wmi.5
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 07:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+jxuVdJADwlzmEG3BZhwMflsT916JYhc90rVwcscydM=;
        b=YZo5dkyCASj7MrbEEFR6gdYMHDpOHJpSNTKKo16slbQ7s8IV7ISoPyCXBdrEjuIcyW
         yCimg/oY136/hlNUBNpLYFBvioSGEPf24AP6I+6fm95CW0NKvGs93E1UVTiTp3lerqbS
         Ms4BELld8F3MkCm68GEt7EbVxKiOsJxmSO5W4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+jxuVdJADwlzmEG3BZhwMflsT916JYhc90rVwcscydM=;
        b=kRjN7go5wyRgfr34cb59syMYQ8evbe0bsXdJOtasL9ZgABItOlYdZh7d+LHTeXpLNu
         9he/jnsUXHsr9Bph/0uE2tZlaZIJr2qyhXJno/OBlS/KNmrW7oP0wNvNyTaCHEn1o01y
         +nnxC6+Ke/vMTFE56m5WssJ4KDi7TW6avMbln+lIbVykIKEZ2zH4kn9xrfOYnHaC7dk0
         h0Qv/guKOJmaPMGqZGU/5zsBq2fm3pqzkPBFwkWIQp0YWPLD5l9hyuTJeN/z4VD1CqLh
         fGfzwMox4kWbqzNKew8hSPRuRFd3bGwalv1cEs4muJxYSQ44irGqDBMV6lY+S6sxLmlc
         a5WA==
X-Gm-Message-State: AOAM533EDLZ9y/w1g9AIdkQCx3ZgejUzb6gOhsGLFzfLCF9LiSAMqJBn
        hZkj0eGzJvSPXAz3m7DXGhhmDA==
X-Google-Smtp-Source: ABdhPJxyj2kyyXgZODY/XZ4g7Bp3IXMvQiwgPOEBDDbAhz8Kn0hgCHAuBXlj61OzgUk3jSiIArMxQA==
X-Received: by 2002:a7b:c195:: with SMTP id y21mr21173602wmi.20.1596982702211;
        Sun, 09 Aug 2020 07:18:22 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e16sm17327071wrx.30.2020.08.09.07.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 07:18:21 -0700 (PDT)
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Hillf Danton <hdanton@sina.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>,
        Markus Elfring <Markus.Elfring@web.de>
References: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
 <20200805163425.6c13ef11@hermes.lan>
 <191e0da8-178f-5f91-3d37-9b7cefb61352@prevas.dk>
 <2a6edf25-b12b-c500-ad33-c0ec9e60cde9@cumulusnetworks.com>
 <20200806203922.3d687bf2@hermes.lan>
 <29a82363-411c-6f2b-9f55-97482504e453@prevas.dk>
 <20200809134924.12056-1-hdanton@sina.com>
 <b2cabeeb-f36d-189b-2ce2-1f9605af0063@cumulusnetworks.com>
Message-ID: <b7ff3781-a944-ae04-91d1-14a7cb8187b2@cumulusnetworks.com>
Date:   Sun, 9 Aug 2020 17:18:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b2cabeeb-f36d-189b-2ce2-1f9605af0063@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2020 17:12, Nikolay Aleksandrov wrote:
> On 09/08/2020 16:49, Hillf Danton wrote:
>>
>> On Fri, 7 Aug 2020 08:03:32 -0700 Stephen Hemminger wrote:
>>> On Fri, 7 Aug 2020 10:03:59 +0200
>>> Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
>>>
>>>> On 07/08/2020 05.39, Stephen Hemminger wrote:
>>>>> On Thu, 6 Aug 2020 12:46:43 +0300
>>>>> Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
>>>>>   
>>>>>> On 06/08/2020 12:17, Rasmus Villemoes wrote:  
>>>>>>> On 06/08/2020 01.34, Stephen Hemminger wrote:    
>>>>>>>> On Wed, 5 Aug 2020 16:25:23 +0200  
>>>>
>>>>>>
>>>>>> Hi Rasmus,
>>>>>> I haven't tested anything but git history (and some grepping) points to deadlocks when
>>>>>> sysfs entries are being changed under rtnl.
>>>>>> For example check: af38f2989572704a846a5577b5ab3b1e2885cbfb and 336ca57c3b4e2b58ea3273e6d978ab3dfa387b4c
>>>>>> This is a common usage pattern throughout net/, the bridge is not the only case and there are more
>>>>>> commits which talk about deadlocks.
>>>>>> Again I haven't verified anything but it seems on device delete (w/ rtnl held) -> sysfs delete
>>>>>> would wait for current readers, but current readers might be stuck waiting on rtnl and we can deadlock.
>>>>>>  
>>>>>
>>>>> I was referring to AB BA lock inversion problems.  
>>>>
>>>> Ah, so lock inversion, not priority inversion.
>>
>> Hi folks,
>>
>> Is it likely that kworker helps work around that deadlock, by
>> acquiring the rtnl lock in the case that the current fails to
>> trylock it?
>>
>> Hillf
> 
> You know it's a user writing to a file expecting config change, right?
> There are numerous problems with deferring it (e.g. error handling).
> 
> Thanks,
>  Nik

OK, admittedly spoke too soon about the error handling. :) 
But I still think it suffers the same problem if the sysfs files are going to be destroyed
under rtnl while you're writing in one. Their users are "drained", so it will again wait forever.
Because neither rtnl will be released, nor the writer will finish.
And it may become even more interesting if we're trying to remove the bridge module at that time.



