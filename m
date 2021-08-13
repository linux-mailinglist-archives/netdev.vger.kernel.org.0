Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96DD3EB463
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 13:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbhHMLJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 07:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhHMLJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 07:09:01 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637AEC061756;
        Fri, 13 Aug 2021 04:08:34 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id a20so11502970plm.0;
        Fri, 13 Aug 2021 04:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+MEtveFkdOd+h/+N1vdHSRea+1UGQzxyyqVSqe8XsTI=;
        b=TnR5VAgs+WjVCuR/ln4UwTjYImgIev0hseQb/dL/xkKv+3HhdB19WXo8XqAB80miYf
         a93Nk2wFJWgirNymllqYDCKzND1IHsES1zVrJmdPjYI1nxalJjd3AMDZ1dqZ1ewOe8zg
         dlRDYhNL7TEsf19rlYGyao6p+tni487AVru69OhhU6Qgls/zYWpM2lrkUR05rSuDs2mk
         gIvr/kHic2M5FhmBS9R2s1FNjgBNx27wIHyXY1G6iTVmOTg1Ke5Rq+RJE0M6br9XjejN
         Piy9NXtpo9ZytPx2rfxcN6wn+QHIOhWQ/tLnF4F9/gWjri74qCrxhzH9F83+Rb54yZnB
         xGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MEtveFkdOd+h/+N1vdHSRea+1UGQzxyyqVSqe8XsTI=;
        b=SmBYEkUwNE27xl8HN3tzO53McekVi+qmEzloEhwpTPQRuq7f3uxmuOii1KsEVSu4IT
         2UUrqf2FZp4Da636R4bNkNDTDqlkbCv7JI7Ach+c3TEbERZRl3QVgdZPFEgswxcuIhZP
         b4eRIaVOvbvZxKot8Q/kBvpaom98173ko47T3VnTlHk18eCHARDVvUMO7bR9RyvOFGZZ
         ALoJ/M3DtAdkuwqaaKZV0IhAYGvqh9Rk4E8/5JepkbszVSddNiK/OGoz6LxmHG1Mm1S5
         9KfiEF2sIE7d7WmI0s1GATfrGmzRldX+/gQCKrt7DOgqEWR+lN8dow7+1AkBWzKFjpE/
         W7tQ==
X-Gm-Message-State: AOAM530Y/ebHgIT9jFutRJGpTINMIZBYm1CEVGMzciVUKms92IQmMWGN
        dl6GfEO8qk2mgpV41RXot/s=
X-Google-Smtp-Source: ABdhPJwDu1mMWjdXxr4u1Iw6jOPGjz0PDjJS6gkHk0nxjEQ/DP+CKE8YP+jW0mpe5JVOSWYzZd6X7w==
X-Received: by 2002:a17:90b:1c8c:: with SMTP id oo12mr2137167pjb.170.1628852913856;
        Fri, 13 Aug 2021 04:08:33 -0700 (PDT)
Received: from [192.168.0.109] ([123.20.118.31])
        by smtp.gmail.com with ESMTPSA id y13sm1618552pjn.34.2021.08.13.04.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 04:08:33 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] udp: UDP socket send queue repair
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        avagin@gmail.com, alexander@mihalicyn.com,
        lesedorucalin01@gmail.com
References: <20210811154557.6935-1-minhquangbui99@gmail.com>
 <721a2e32-c930-ad6b-5055-631b502ed11b@gmail.com>
 <7f3ecbaf-7759-88ae-53d3-2cc5b1623aff@gmail.com>
 <489f0200-b030-97de-cf3a-2d715b07dfa4@gmail.com>
From:   Bui Quang Minh <minhquangbui99@gmail.com>
Message-ID: <3f861c1d-bd33-f074-8ef3-eede9bff73c1@gmail.com>
Date:   Fri, 13 Aug 2021 18:08:28 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <489f0200-b030-97de-cf3a-2d715b07dfa4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2021 10:51 PM, Eric Dumazet wrote:
> 
> 
> On 8/12/21 3:46 PM, Bui Quang Minh wrote:
>>
>>
>> On 8/11/2021 11:14 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 8/11/21 5:45 PM, Bui Quang Minh wrote:
>>>> In this patch, I implement UDP_REPAIR sockoption and a new path in
>>>> udp_recvmsg for dumping the corked packet in UDP socket's send queue.
>>>>
>>>> A userspace program can use recvmsg syscall to get the packet's data and
>>>> the msg_name information of the packet. Currently, other related
>>>> information in inet_cork that are set in cmsg are not dumped.
>>>>
>>>> While working on this, I was aware of Lese Doru Calin's patch and got some
>>>> ideas from it.
>>>
>>>
>>> What is the use case for this feature, adding a test in UDP fast path ?
>>
>> This feature is used to help CRIU to dump CORKed UDP packet in send queue. I'm sorry for being not aware of the performance perspective here.
> 
> UDP is not reliable.
> 
> I find a bit strange we add so many lines of code
> for a feature trying very hard to to drop _one_ packet.
> 
> I think a much better changelog would be welcomed.

The reason we want to dump the packet in send queue is to make to state of the 
application consistent. The scenario is that when an application sends UDP 
packets via UDP_CORK socket or with MSG_MORE, CRIU comes and checkpoints the 
application. If we drop the data in send queue, when application restores, it 
sends some more data then turns off the cork and actually sends a packet. The 
receiving side may get that packet but it's unusual that the first part of that 
packet is missing because we drop it. So we try to solve this problem with some 
help from the Linux kernel.

Thanks,
Quang Minh.
