Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147E4127AD0
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLTMPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:15:01 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33291 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbfLTMPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:15:00 -0500
Received: by mail-il1-f194.google.com with SMTP id v15so7796291iln.0
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EVTrDTjdXLIfcCojPULwd3KxwFBMJh1j/xJeTBKbEWo=;
        b=iOV72Ioy6P1HMLqkYTcLcbaRBzQHhMhmXpRMZdnWVwHWtuLMgmccg4UbJZkTUXLAXF
         6NPEk8cAtFu8uD3jCEeIQYvb8d9kmn9ghp/9jGCaTIKG2ApyUiijAm9cwycvAQxYFlGz
         dnRu8B7nSyJN/SoSv7FAzDdtJAhMB3BEOFR0iSWEaeSYht9BuN569mxxIppOIB5HRjQE
         OFn1w8qhKpiFr0qcTRoPkEcpu7FJEjpwCAJIykM0Dl88GdBP2Tnfl/TX/GTRrgW/fkVF
         1LZ2Kh5rhBlgazP35blXeJXc4QKOPRSbIibZOspospirjdzE7cq0LXrD7b1aVGW2Yg5j
         Mx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVTrDTjdXLIfcCojPULwd3KxwFBMJh1j/xJeTBKbEWo=;
        b=V3GQ8SJZSyS+Ro2+K6QVBw2fL4IdBsp5ZB9tLEdFmhLOD3Fusk9VahRq1QbaujqfCs
         +I2FpYRk3GYTOjrs638mVvx2T2wrRbTZyrttl5ERUrnB7O13i3nq/JcWV+vZKkG0K4Fb
         XkzqYJA0Ijw5eb/E7pDDQDz/nBscdVc13tnbVJauLgObVWvJ0r7GvFEdpwtqMmI7SmdV
         GsprTLeI5KFNwVIicbu7t8mObGAwNjo5H/OcQhYEhbbluTMK9Rg/KFPWvDmxQMetfstm
         DEqju6y+FTKMXqwArHeFqnb3jX0YRMlNInqke4X1b6l0NNM6Pfg9gE+QxW32QxA7OCnJ
         aU2w==
X-Gm-Message-State: APjAAAUll5x4fbbq6+qeBkBAAlBCA2oY1F3ZiRNb7FXLeH4e4hb+8LrD
        n+5znFSW4/IaliILoI/b5Y0ueA==
X-Google-Smtp-Source: APXvYqxIoEOF9WKDmdtpayNU9pMieZN/dOfaU/RysK5fs8nkZsCYAP2SZrO3opIL/uH2WsjJ7VCeRQ==
X-Received: by 2002:a92:d34d:: with SMTP id a13mr1587556ilh.178.1576844100158;
        Fri, 20 Dec 2019 04:15:00 -0800 (PST)
Received: from [192.168.0.125] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id u10sm4514717ilq.1.2019.12.20.04.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 04:14:59 -0800 (PST)
Subject: Re: [PATCH net 0/2] net/sched: cls_u32: fix refcount leak
To:     David Miller <davem@davemloft.net>, dcaratti@redhat.com
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vladbu@mellanox.com, mrv@mojatatu.com
References: <cover.1576623250.git.dcaratti@redhat.com>
 <20191219.175331.2104515305508917057.davem@davemloft.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <21a8c84d-6a2e-bb84-e980-64437f2f1f16@mojatatu.com>
Date:   Fri, 20 Dec 2019 07:14:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191219.175331.2104515305508917057.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-19 8:53 p.m., David Miller wrote:
> From: Davide Caratti <dcaratti@redhat.com>
> Date: Wed, 18 Dec 2019 00:00:03 +0100
> 
>> a refcount leak in the error path of u32_change() has been recently
>> introduced. It can be observed with the following commands:
>   ...
>> they all legitimately return -EINVAL; however, they leave semi-configured
>> filters at eth0 tc ingress:
>   ...
>> With older kernels, filters were unconditionally considered empty (and
>> thus de-refcounted) on the error path of ->change().
>> After commit 8b64678e0af8 ("net: sched: refactor tp insert/delete for
>> concurrent execution"), filters were considered empty when the walk()
>> function didn't set 'walker.stop' to 1.
>> Finally, with commit 6676d5e416ee ("net: sched: set dedicated tcf_walker
>> flag when tp is empty"), tc filters are considered empty unless the walker
>> function is called with a non-NULL handle. This last change doesn't fit
>> cls_u32 design, because at least the "root hnode" is (almost) always
>> non-NULL, as it's allocated in u32_init().
>>
>> - patch 1/2 is a proposal to restore the original kernel behavior, where
>>    no filter was installed in the error path of u32_change().
>> - patch 2/2 adds tdc selftests that can be ued to verify the correct
>>    behavior of u32 in the error path of ->change().
> 
> Series applied, thanks.
> 

There is still an ongoing discussion on this patch set...

cheers,
jamal
