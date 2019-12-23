Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3991294CA
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 12:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfLWLHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 06:07:00 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:33921 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbfLWLHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 06:07:00 -0500
Received: by mail-pj1-f66.google.com with SMTP id s94so5694565pjc.1
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 03:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mFKvqtQ9vSPm5T315tkOXf8KD7fD/8AVHb7q+1r7gfY=;
        b=pVgC4P7FEEyT+JBvMyEZQHV2zV6kVPMHYiC2LiK/xtQF/XsjR0avCcwDPQEPazYJwS
         bnTczswulHp2+XbhwTw1NABpuepJxPhBuvPCQatkrhA1EtptLdxhGuKnIsaDeEg+Szc4
         +2dOfsmxqgnbFYZuh7AFQgm9s0kHdv/ZKYGstEGFnjxtdKwcmcP2S4ywiPfCOzhumKn9
         LTNdD+EnrOHYyNf/00Qa7qad3Bcrj77m0z6H0+TdqEgPPhg+ZkLYQscOfwnERnqvpsGy
         E0WGEB8TFXeYnSzqstutUaDXy/jPYQUYYvdLUrggzVruqNPf/PAK3u22WLaY/Sb1yyuw
         GeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mFKvqtQ9vSPm5T315tkOXf8KD7fD/8AVHb7q+1r7gfY=;
        b=s/sXJopBdkxlcqLGCm+kmoreZBXlzEQuPGh5mxGw9fF+eIGfVuaNbWGtXT1ErKoLRY
         XErz1vpRbGnKe6me3EnJ6r7HrMYTwUj0GpyO3wi3Y0ALXBGBfFp0NnS3HMmg9q/bDo7H
         sEOrWVMNVj2OlbhcpIyqL2gZSzygU5nBzKah8R6BgD5c3CJyBiKftDKIR5bYhwg2m3Gi
         ce4BabYkWkENujqSZxw8Hc1WvYW83DdqB06ZiTbhw/hx5TsfHEqQpO9bGkTR+BZ5brUK
         tLakX86SNRFnE8MUnNwmjkIHjJlxRGpV2v8v3jhMthm0aGYO2bH2PVL6JgNXu0sb6mw6
         xQag==
X-Gm-Message-State: APjAAAVrrk/JYuCJ49Ghqr+DGQ5h+oL7FnFYYbVEa3ltVrJNmjbdYzOC
        SPGaDTnSxbCOVBlRiUhu20w=
X-Google-Smtp-Source: APXvYqyZzmMEyF8usYU0hkMnDW0u6Cm6lH1+L2QNrCUkQCrC1udZtoXP7KrRaFvDssYUJSYj8jCS5g==
X-Received: by 2002:a17:90a:2808:: with SMTP id e8mr33465518pjd.63.1577099219041;
        Mon, 23 Dec 2019 03:06:59 -0800 (PST)
Received: from [192.168.1.236] (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id k3sm22301785pgc.3.2019.12.23.03.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 03:06:58 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon> <87fthh6ehg.fsf@toke.dk>
 <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com>
 <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com> <874kxw4o4r.fsf@toke.dk>
 <5eb791bf-1876-0b4b-f721-cb3c607f846c@gmail.com>
 <75228f98-338e-453c-3ace-b6d36b26c51c@redhat.com>
 <3654a205-b3fd-b531-80ac-42823e089b39@gmail.com>
 <3e7bbc36-256f-757b-d4e0-aeaae7009d6c@gmail.com>
 <58e0f61d-cb17-f517-d76d-8a665af31618@gmail.com>
 <4d1847f1-73c2-7cf2-11e4-ce66c268b386@redhat.com>
 <09118670-b0c7-897c-961d-022ad4dfb093@gmail.com>
 <2ca3d486-a5ee-5c78-e957-74f8932f1f62@redhat.com>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <fc739287-62d1-e90c-c935-685b8db7970f@gmail.com>
Date:   Mon, 23 Dec 2019 20:06:53 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2ca3d486-a5ee-5c78-e957-74f8932f1f62@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/2019 5:34 PM, Jason Wang wrote:
> 
> On 2019/12/23 下午4:09, Prashant Bhole wrote:
>>
>>
>> On 12/23/19 3:05 PM, Jason Wang wrote:
>>>
>>> On 2019/12/21 上午6:17, Prashant Bhole wrote:
>>>>
>>>>
>>>> On 12/21/2019 1:11 AM, David Ahern wrote:
>>>>> On 12/19/19 9:46 PM, Prashant Bhole wrote:
>>>>>>
>>>>>> "It can improve container networking where veth pair links the 
>>>>>> host and
>>>>>> the container. Host can set ACL by setting tx path XDP to the veth
>>>>>> iface."
>>>>>
>>>>> Just to be clear, this is the use case of interest to me, not the
>>>>> offloading. I want programs managed by and viewable by the host OS and
>>>>> not necessarily viewable by the guest OS or container programs.
>>>>>
>>>>
>>>> Yes the plan is to implement this while having a provision to implement
>>>> offload feature on top of it.
>>>
>>>
>>> I wonder maybe it's easier to focus on the TX path first then 
>>> consider building offloading support on top.
>> Currently working on TX path. I will try make sure that we will be able
>> to implement offloading on top of it later.
>>
>> Thanks.
> 
> 
> Right, then I think it's better to drop patch 13 and bring it back in 
> the offloading series.
> 

Yes that patch actually makes sense in offloading series.



