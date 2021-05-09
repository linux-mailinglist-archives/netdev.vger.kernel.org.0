Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D36377951
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 01:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhEIXjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 19:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhEIXjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 19:39:10 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D84C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 16:38:06 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id j75so14201666oih.10
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 16:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X77rQ7sOViH0m0ZSKWPOn96Noq1PBpj8SBg6N8fEpDo=;
        b=oZMaX5LtmLGKC7Gpy6ZQxlhj8Gq4j8noEANQ23KCB5MyZsMmmTCSrQMpfV2WorDhz+
         aD2Z3KvujH0iIaoKprRSqrDCGPX88z+JJQRHreLYoboLnseKuvp8AGIvO05K6MTZU0Qx
         Vphwzp6KkVeT5MQr1/PzY5mliy26H5M3jKoKdYwU9tHI58bEdunitckCNalzIn/Bs5K0
         h5iXgmgU4x78HNiATHRAmhZFzDlsthwuzE2nXKB7F7Ybjpt1A3vxb0FXwl9i5Egq7hm6
         dOKVWcPBZ1M/FM5N348gt29M9p57MPlzggU2hJPY/9ALHiYfGfwuCQngAQsVujWoeB/u
         xtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X77rQ7sOViH0m0ZSKWPOn96Noq1PBpj8SBg6N8fEpDo=;
        b=IDntqk2rL7BV/J4LmWS60TesN7fa49OZ+GVF3oUZc/F1UwHLXr7f9Bzk/6YYApy2V/
         XtdbVMAF5STI0KVdyO67ZmSm6fWDtuM7apXdo02W+alR/5+QoHhxtEtfvwy4RmBqC+7I
         GYiowzjIVDvrQ43e2qosLmb92CjFJ3JfL3dGtxcJaxOjCGtG/axxIR+tHHWzFM/K3xuq
         m4/c61Zzb1Idt7vzC0MBCRMrpxgwSw5s+tCudCzGv7AWRHieuXN1io8MuQ3tqvV7wUzb
         XmdiSQyzt6+4zsRhOxBCKDKpWBoWxZsK2yjXjYea8vrczCadfiA8MhBQk06zWxbWfSdq
         ixAA==
X-Gm-Message-State: AOAM530mMRhHC20m6AxbAo8dTgpnEMs2HP8nctG7BNEREcq/FBZbMndA
        VtsYu9ZbEjrNj0C2++OdxTwrRD9wLTM=
X-Google-Smtp-Source: ABdhPJzJ3UiwnKVWNcVv9uN+3KSwtJWQSOpZprUB6ZF5N89up7Z0Xv3omu8U8Sdd1ACX9Ne6bFqxgQ==
X-Received: by 2002:aca:c1c6:: with SMTP id r189mr7904038oif.171.1620603485913;
        Sun, 09 May 2021 16:38:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id g6sm1944693ooe.1.2021.05.09.16.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 16:38:05 -0700 (PDT)
Subject: Re: [PATCH iproute2] mptcp: avoid uninitialised errno usage
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org
References: <20210503103631.30694-1-fw@strlen.de>
 <b8d9cc70-7667-d2b3-50b6-0ef0ce041735@gmail.com>
 <20210509222549.GE4038@breakpoint.cc>
 <3fc254ad-4766-a599-3500-ca16bd7d52c6@gmail.com>
 <20210509225513.GF4038@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d9071d27-ed4d-f789-af90-8477dec82d6b@gmail.com>
Date:   Sun, 9 May 2021 17:38:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210509225513.GF4038@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/21 4:55 PM, Florian Westphal wrote:
> David Ahern <dsahern@gmail.com> wrote:
>>>  	if (rtnl_talk(grth, &req.n, &answer) < 0) {
>>>  		fprintf(stderr, "Error talking to the kernel\n");
>>> +		if (errno == 0)
>>> +			errno = EOPNOTSUPP;
>>
>> you don't list the above string in the output in the commit log. Staring
>> at rtnl_talk and recvmsg and its failure paths, it seems unlikely that
>> path is causing the problem.
> 
> Its not in my particular case, but if it would caller would still get random errno.
> 
> The sketch I sent merely provides a relible errno whenever ret is less
> than 0.  Right now it may or may not have been set.
> 

Then let's find and fix those locations.

Unless I missed a code path, rtnl_talk and friends (e.g.,
__rtnl_talk_iov) all set errno before any < 0 return.
