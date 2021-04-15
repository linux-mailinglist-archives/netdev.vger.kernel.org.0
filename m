Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE9B3602A0
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 08:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhDOGq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 02:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhDOGq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 02:46:56 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD7DC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:46:34 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id q123-20020a1c43810000b029012c7d852459so3473200wma.0
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s+SIKKHGE0TG0a9nm+rEkhtw8QtFbNRjMHOdbd3dfP4=;
        b=hqt+15/4ufoQLfxKFE2qTy1J2nHuTMqxScBG8LKKBGDAMI5rPP9+PA/Atdwo+kst+z
         aUsV+cWvq43Iue+M0MOMeST5isBY+Nq9/yRZjhkUXi3z1K9Mt+vFwAsb9PW0zaj0lOwK
         EbSDQwgZGonV40xRIvO5zecdJnI4dxMFjhEGUeik/tRdKP4Z1Syeamxp6xA3zdgJrq9r
         AkTVmO4qpzGaSYlEqCswasWdp+9DzXugs3PLzo/T7K6CgwnmjaL91v/TPRVTjtQ3YJAu
         4NL9y5+GL0xLeTbnjCFETcY2lnxoeuR1iRe71FzEWoiQIdyhIGmwJ17Ez7S+tE5ZY9xl
         eyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s+SIKKHGE0TG0a9nm+rEkhtw8QtFbNRjMHOdbd3dfP4=;
        b=q9AX3iQHf+2caHybiH6yX9uMdy44+c13DHJGWhxCiYy2RMbqi+I+8TFkq+lLnigx++
         aKDJ9hEz/tIVIPRW43O9p1FnCf5K7pfHzx+4gccXQEEEKn345qOEoeX/HpAc2eRhLcjR
         NjPtF/1S3NBXiD1MrhPYyl5as2Pe3Rnbb3V972adUUEUspmcK88aAxejVOAnsoulNURR
         7yiHV+4Iwtxf4zXMqyuA7lE3eaWZtmTtp8xhthJtSYhmqciA7lge0G/jv7ms8gBwo4qn
         +pLRwgoM1j+SzSN0G0fDnRY/6RMFMUInBtkpJXeFVXuJpu9ZevY+NG/WYzgXvWfDiEuU
         3sHw==
X-Gm-Message-State: AOAM533zeBGw9HXUnmXJZE6K65N6XKQyuk7drWbTy+kgf2/f5rBwml3b
        W8lHh7/5w/zAKAMQjtUb3wvb6kIKneg=
X-Google-Smtp-Source: ABdhPJzUgnAKTs+fnAZSKOrenp+oez7HQvVBog/9mEagwFSpaFJvizro6Ad2xIN8xjI5UCbJcHws4Q==
X-Received: by 2002:a7b:c1cf:: with SMTP id a15mr1526714wmj.168.1618469192727;
        Wed, 14 Apr 2021 23:46:32 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.86.66])
        by smtp.gmail.com with ESMTPSA id x25sm1327798wmj.34.2021.04.14.23.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 23:46:32 -0700 (PDT)
Subject: Re: [PATCH net v2] net: core: make napi_disable more robust
To:     Jakub Kicinski <kuba@kernel.org>, Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20210414080845.11426-1-lijunp213@gmail.com>
 <20210414162109.77eecf47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5f5ea71d-c9e9-fe85-2f29-475c67174549@gmail.com>
Date:   Thu, 15 Apr 2021 08:46:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210414162109.77eecf47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/21 1:21 AM, Jakub Kicinski wrote:
> On Wed, 14 Apr 2021 03:08:45 -0500 Lijun Pan wrote:
>> There are chances that napi_disable can be called twice by NIC driver.
>> This could generate deadlock. For example,
>> the first napi_disable will spin until NAPI_STATE_SCHED is cleared
>> by napi_complete_done, then set it again.
>> When napi_disable is called the second time, it will loop infinitely
>> because no dev->poll will be running to clear NAPI_STATE_SCHED.
>>
>> Though it is driver writer's responsibility to make sure it being
>> called only once, making napi_disable more robust does not hurt, not
>> to say it can prevent a buggy driver from crashing a system.
>> So, we check the napi state bit to make sure that if napi is already
>> disabled, we exit the call early enough to avoid spinning infinitely.
> 
> You've already been told by Eric & Dave to fix the driver instead.
> 
> Your check is _not_ correct - SCHED && NPSVC && !MISSED && !BUSY_POLL 
> can well arise without disabling the NAPI.
> 
> But regardless, a driver bug should be relatively easy to identify with
> task getting stuck in napi_disable(). We don't provide "protection" 
> for taking spin locks or ref counts twice either. Unless you can show 
> a strong use case please stop posting new versions of this patch.
> 

+222

I notice this v2 does not even mention which driver has the issue.

I suspect an out-of-tree driver.

