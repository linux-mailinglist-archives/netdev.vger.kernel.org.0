Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DED5D49D8
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfJKV1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:27:46 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:43128 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfJKV1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:27:45 -0400
Received: by mail-pf1-f169.google.com with SMTP id a2so6797722pfo.10
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SLWgiKqzeJ9v3pOKLdQ2spvEJqaMV0EiXXYqcwaqP/8=;
        b=uQy7d2WR68leb2R2vaaVa3OL9iCQqwBnT4VJ5uh1xJ24eXTJ5gJ/hQrNkQeOCXgF1G
         gpLWi+xh3NyDajwroS198bA2bWFXLzCmLL3J0DJVMtZRTBToQwAMH6OSDXZ/fCf+clH/
         qcGw5RKIVLYkbAg9SHcfkXlaVG4tXWtejykC6nN2MGKqROUF2D70oYWsTpLDM51OppTq
         kVCTCi3sXiRmmgjIAiutlto519gJRuT9don9z0sS9pyvD3GCiXbI240gRKFxo/6nmnAY
         DMkv684AfHDfXCz5lLUtqgQoqZ/uEt81qVawc6Xs6yFiL3MrHRFpAw9UbOdCQXmfgrxj
         udag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SLWgiKqzeJ9v3pOKLdQ2spvEJqaMV0EiXXYqcwaqP/8=;
        b=bfZNW7/Wh+9Qu9AvSFCvUB9MBLPIsSIvkILt6JjiHx8JP1f4bbpRtaKdwlZI6w34Vn
         zeG69KLSZDc47NEGvzOlyFKcG5sx2QaEtG7mhv3BE2FpTtjGVqMawjPPHBx1UdPkxz9O
         QpQA85QC1ogGD2qdY3rCbdeIhbMlkD+LZxBlSKiZ8pp2QOHmmARyierBebK7nbum+Efj
         +CWlJY/WnyBLGpuBQuTAMzQeharmvyjzkk0fG/7fBN+xI520L1k3WJ3vxKAX5fCJeW8J
         oHel0uUqSrwnucT3vgxDmOSfGrpgdelii27KxVeLy+WCmvX8l1SbXCrs56dSRrOhYzF+
         UBYA==
X-Gm-Message-State: APjAAAWOtGzemMCPajGdSIVklfEe/WRmFUW8Tuaqjl8QU8gcj1camkxo
        GPoD01xyuGpjmdgsXj5duZH1yKZs
X-Google-Smtp-Source: APXvYqw6rPRHb+g8Yr7HCCwEG9d6OkIevGK9vdQ3AYMMUp1Glq/6otimAFmAQy4xfFwx4dwKrjY/lw==
X-Received: by 2002:a63:1351:: with SMTP id 17mr18750493pgt.249.1570829263298;
        Fri, 11 Oct 2019 14:27:43 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d0e9:88fb:a643:fda7])
        by smtp.googlemail.com with ESMTPSA id f12sm8473622pgo.85.2019.10.11.14.27.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 14:27:42 -0700 (PDT)
Subject: Re: Race condition in route lookup
To:     Ido Schimmel <idosch@idosch.org>, Wei Wang <weiwan@google.com>,
        jesse@mbuki-mvuki.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
 <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter>
 <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <20191011181737.GA30138@splinter> <20191011182508.GA30970@splinter>
 <CAEA6p_CXZyUQf_DKhs7nQ5D0C7j1kM7bzgcyS2=D_k_U7Czu8w@mail.gmail.com>
 <20191011185250.GA31385@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52b3de47-d7f9-8ea9-10b1-0f7c11a2b31f@gmail.com>
Date:   Fri, 11 Oct 2019 15:27:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011185250.GA31385@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/19 12:52 PM, Ido Schimmel wrote:
> On Fri, Oct 11, 2019 at 11:47:12AM -0700, Wei Wang wrote:
>> On Fri, Oct 11, 2019 at 11:25 AM Ido Schimmel <idosch@idosch.org> wrote:
>>>
>>> On Fri, Oct 11, 2019 at 09:17:42PM +0300, Ido Schimmel wrote:
>>>> On Fri, Oct 11, 2019 at 10:54:13AM -0700, Wei Wang wrote:
>>>>> On Fri, Oct 11, 2019 at 8:42 AM Ido Schimmel <idosch@idosch.org> wrote:
>>>>>>
>>>>>> On Fri, Oct 11, 2019 at 09:36:51AM -0500, Jesse Hathaway wrote:
>>>>>>> On Thu, Oct 10, 2019 at 3:31 AM Ido Schimmel <idosch@idosch.org> wrote:
>>>>>>>> I think it's working as expected. Here is my theory:
>>>>>>>>
>>>>>>>> If CPU0 is executing both the route get request and forwarding packets
>>>>>>>> through the directly connected interface, then the following can happen:
>>>>>>>>
>>>>>>>> <CPU0, t0> - In process context, per-CPU dst entry cached in the nexthop
>>>>>>>> is found. Not yet dumped to user space
>>>>>>>>
>>>>>>>> <Any CPU, t1> - Routes are added / removed, therefore invalidating the
>>>>>>>> cache by bumping 'net->ipv4.rt_genid'

IPv4 needs a change similar to what was done for IPv6 - only invalidate
dst's for the branches / table affected and not all dst's across the
namespace.
