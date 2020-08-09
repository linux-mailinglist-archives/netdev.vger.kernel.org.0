Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE82323FEAE
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 16:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHIOMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 10:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgHIOMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 10:12:46 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133ECC061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 07:12:46 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 184so5991391wmb.0
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 07:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eS6dZ7NPSkGDL8o+0PmIe9wFz3Wec8gCnb4dSo+t9XQ=;
        b=RS3lDZ4x231a42Qga19kz2OdHAro+nn7xnqdJeNFfpa6GsnlgIWFweBAlClKAOhoVF
         H+qTlfDYz2MfrmEWxp24Z3BtwborxOv9XGDdh+dpkaBxJlI7rUstAydlbcSeRApLcJPV
         9MES/b4E0NF4LjkT6hamNr33aeucA1TqLKMLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eS6dZ7NPSkGDL8o+0PmIe9wFz3Wec8gCnb4dSo+t9XQ=;
        b=DRNkx0QJGsFQFSpuO/R9V+s8/CNL8Gi8QgDW+Yf5TmaE6/BmhsgUtl2kLpIC92d9QR
         D/Ybn1ftI/0/FCxstMUxwsRYj0FrWGwXm2Y4exemioyJg8jwglIKDN45jdRtXfobQ6wj
         yVLNX4eXaDL0WDQnZ2E2WdGJMwFGuhLb35C8AZgThmt2oSEw0A2zNFsoLWCUlZZG3muN
         WcsUyujPhgQtG9mNUJmJfrbhATNrKZtsv5Cpoq4LHrQR+L/wktclGDq3GziVbbvxM4mj
         1uOznrfDTPHvJ2ko99+LyN2SZygErI5/qbz017raQnJmac8znDooM3vtowJvHw/+8zCj
         +U6w==
X-Gm-Message-State: AOAM533xpf8woss17VhsnRjiwDRHCJwDpBOUvJETfWcbwO/LQoGk8Svn
        HGH7dKui+JcD4lKl4XedKuBZz5g7+6o=
X-Google-Smtp-Source: ABdhPJyaX0mcRE22y5YBmVI7Xez++FIkbl7Qtd+yKAsJ0V7+VKAWPcuN5D9FpReakIgujxoCha0N6g==
X-Received: by 2002:a1c:a78a:: with SMTP id q132mr20944807wme.27.1596982364350;
        Sun, 09 Aug 2020 07:12:44 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o7sm17360374wrv.50.2020.08.09.07.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 07:12:43 -0700 (PDT)
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
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
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b2cabeeb-f36d-189b-2ce2-1f9605af0063@cumulusnetworks.com>
Date:   Sun, 9 Aug 2020 17:12:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200809134924.12056-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2020 16:49, Hillf Danton wrote:
> 
> On Fri, 7 Aug 2020 08:03:32 -0700 Stephen Hemminger wrote:
>> On Fri, 7 Aug 2020 10:03:59 +0200
>> Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
>>
>>> On 07/08/2020 05.39, Stephen Hemminger wrote:
>>>> On Thu, 6 Aug 2020 12:46:43 +0300
>>>> Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
>>>>   
>>>>> On 06/08/2020 12:17, Rasmus Villemoes wrote:  
>>>>>> On 06/08/2020 01.34, Stephen Hemminger wrote:    
>>>>>>> On Wed, 5 Aug 2020 16:25:23 +0200  
>>>
>>>>>
>>>>> Hi Rasmus,
>>>>> I haven't tested anything but git history (and some grepping) points to deadlocks when
>>>>> sysfs entries are being changed under rtnl.
>>>>> For example check: af38f2989572704a846a5577b5ab3b1e2885cbfb and 336ca57c3b4e2b58ea3273e6d978ab3dfa387b4c
>>>>> This is a common usage pattern throughout net/, the bridge is not the only case and there are more
>>>>> commits which talk about deadlocks.
>>>>> Again I haven't verified anything but it seems on device delete (w/ rtnl held) -> sysfs delete
>>>>> would wait for current readers, but current readers might be stuck waiting on rtnl and we can deadlock.
>>>>>  
>>>>
>>>> I was referring to AB BA lock inversion problems.  
>>>
>>> Ah, so lock inversion, not priority inversion.
> 
> Hi folks,
> 
> Is it likely that kworker helps work around that deadlock, by
> acquiring the rtnl lock in the case that the current fails to
> trylock it?
> 
> Hillf

You know it's a user writing to a file expecting config change, right?
There are numerous problems with deferring it (e.g. error handling).

Thanks,
 Nik



