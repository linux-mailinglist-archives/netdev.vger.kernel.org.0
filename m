Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EC63EA7FE
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhHLPv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238365AbhHLPvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:51:33 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C076C061756;
        Thu, 12 Aug 2021 08:51:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z9so8893918wrh.10;
        Thu, 12 Aug 2021 08:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Ox8EA3msfn26kOfs3nfK6Ep7YttC7NK9mJ+afKsxEI=;
        b=YUkvhqc+QAdePDaPdTt5Xjix4FY9Jwr63o0QwfgpzV/9lxY3A6Bzc6nuZ6tPeV+v3u
         OnjDVGVxM/w/6yskm+0Hn3Lyt8V6CPVcn1AiuVgwLLh3dCnDwAprTdwaFnIIVoFIXuuL
         mVoTcYnD4NTTNckm/Fzu/JJwELPRNV3wzxAOBtF8Q79ejWkfPhbKfbgtRoIGPLapOeXP
         g6Ayk+eQR0uTWEoQaq1mMb8EU5SwMRFPFfvF+pYOndn79fsqIh8kEHl3ltpyy86G+VbU
         j06cjJbGocqrZI28bKvAH1oV3xrrvU7ec8QvhjFs3Vko7Twm5625aM4r+lFqw3sl6Lhn
         IiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Ox8EA3msfn26kOfs3nfK6Ep7YttC7NK9mJ+afKsxEI=;
        b=Shg5XT+88fBr0ZsyAECe0y+1MXnpvVEdh/OSaTTmZYQGnh0j4xQzzTlBhytBoaoeRJ
         UsYG3OPGR5QknHd3vzVPsMAmuWiyIWz9UXSwYhjloDeMwCtrC2ca2kLrse78/KCtlPI/
         4VHU1jwhkHYyGpoQ12ucmipBxn7cH1oAgxiZgN1l86/iFA10GpVpZndXXeiZI7uQFmeI
         wh543gKSPAmONAI36ggn5qtjjsMtczcdPNNAk5M7cXM57KDwL64uwVpHHCgTaNZyEosm
         ePtyWdGpgthBZwLs+3aw4KKq2J7UT03hrhw6R1VTc4pSPZWMKuNwenFbi/Y0H/lkW4xZ
         Dv4Q==
X-Gm-Message-State: AOAM5322mzKZfi+dkucSxEp312KMXcqMcKZg9YpiRp6QcPG/Ls9RWmSO
        8MVVEFFqRwQvNGnJ5reilRU=
X-Google-Smtp-Source: ABdhPJzU5U5q4HQPY2Oh41ABzfk7GiiE8EOLu5Cy8IDSivIXWs+NS58kEtMKu+EAGKATFuxDupyQ8A==
X-Received: by 2002:a5d:42c2:: with SMTP id t2mr4772060wrr.49.1628783466985;
        Thu, 12 Aug 2021 08:51:06 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.40.60])
        by smtp.gmail.com with ESMTPSA id y14sm3397044wrs.29.2021.08.12.08.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 08:51:06 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] udp: UDP socket send queue repair
To:     Bui Quang Minh <minhquangbui99@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        avagin@gmail.com, alexander@mihalicyn.com,
        lesedorucalin01@gmail.com
References: <20210811154557.6935-1-minhquangbui99@gmail.com>
 <721a2e32-c930-ad6b-5055-631b502ed11b@gmail.com>
 <7f3ecbaf-7759-88ae-53d3-2cc5b1623aff@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <489f0200-b030-97de-cf3a-2d715b07dfa4@gmail.com>
Date:   Thu, 12 Aug 2021 17:51:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7f3ecbaf-7759-88ae-53d3-2cc5b1623aff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/21 3:46 PM, Bui Quang Minh wrote:
> 
> 
> On 8/11/2021 11:14 PM, Eric Dumazet wrote:
>>
>>
>> On 8/11/21 5:45 PM, Bui Quang Minh wrote:
>>> In this patch, I implement UDP_REPAIR sockoption and a new path in
>>> udp_recvmsg for dumping the corked packet in UDP socket's send queue.
>>>
>>> A userspace program can use recvmsg syscall to get the packet's data and
>>> the msg_name information of the packet. Currently, other related
>>> information in inet_cork that are set in cmsg are not dumped.
>>>
>>> While working on this, I was aware of Lese Doru Calin's patch and got some
>>> ideas from it.
>>
>>
>> What is the use case for this feature, adding a test in UDP fast path ?
> 
> This feature is used to help CRIU to dump CORKed UDP packet in send queue. I'm sorry for being not aware of the performance perspective here.

UDP is not reliable.

I find a bit strange we add so many lines of code
for a feature trying very hard to to drop _one_ packet.

I think a much better changelog would be welcomed.

> 
>> IMO, TCP_REPAIR hijacking standard system calls was a design error,
>> we should have added new system calls.
> 
> You are right that adding new system calls is a better approach. What do you think about adding a new option in getsockopt approach?
> 
> Thanks,
> Quang Minh.
