Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEC43EA5EC
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 15:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbhHLNqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 09:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbhHLNqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 09:46:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A492C061756;
        Thu, 12 Aug 2021 06:46:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so15254793pjb.3;
        Thu, 12 Aug 2021 06:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WB183lguWhFDS87ehCBje+Fiih0eLoDWXJwZXtQEnJM=;
        b=uxNPl+KgSeMlqAvP5yRaL+ww+r/qKjI+e/T18nAzB9BdKlmsaeGO4YU0LXLmSIVPDt
         9ANube2JoOKKjr/A0f14gNfi8CZND8GrwCDiHzE1nIIvhMjs9ZIXmyPG0DUYzlgwoKkP
         iS7zLVoY4UZ35o5rPxmH32dLT4JFMnF8isS+6t2D2k9JjjK65+mZjQgLvY0vCzUujcxU
         KXuZUY5mjZeE7Ec/jF1WFvQvTKA+hvji1CfTWE/5T2ldGD93DnRZtMhLMaen5iMKs0Jr
         Eb4wsKH4WP9pBBbERhElUz5co64a3iWP1TeMxiXDAjjcFTt8uiSfVSiMyYveMiw7BbhZ
         YFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WB183lguWhFDS87ehCBje+Fiih0eLoDWXJwZXtQEnJM=;
        b=ezJH7wmlkAo8wer1VuJ2l1hIhClIHgC4UhZChsp6xonEKRCPzddKhN2EelMPGNfhmk
         ePU9mp2yD8JHuxzumQnKh3tycrODy3BgU+dnndq3HoI7wb8Uh5WMB49NTwrMIyiHESJf
         Bofx3rhkaEULpKgMz9+9vSNXICgq1C/XK9x29t+LQGFguC9Xk/62F91tO5k9Avc/t4is
         q6Vs2tJsBtJH2XJkYul3R0oUDa4boNKuXRoLR/O0EjtncHUc3KZSYCD6rr5+f0qhOccP
         b94QDFQ6cpxabfqnRa8lzR5DoNv/YcUPN0XqrIQ+evzCO3tsFMNwrwvkN0V9wg8FPS/T
         HDDA==
X-Gm-Message-State: AOAM532Yg7Wi7S/PpEorPVTdR7+i7Zn1XngcdnOJHpWqtUgroMuzyzI7
        8mUOHsWMKdCbqoSQaRjxvVY=
X-Google-Smtp-Source: ABdhPJzoKVXyZ/PTFLUw2x1Er7mVePAz6u27KJTyu05oXW4WKzqoD0b1ImRigJ1gmfSsl+lX18NOqA==
X-Received: by 2002:a05:6a00:84e:b029:3ae:5c9:a48d with SMTP id q14-20020a056a00084eb02903ae05c9a48dmr4332754pfk.20.1628775988875;
        Thu, 12 Aug 2021 06:46:28 -0700 (PDT)
Received: from [192.168.0.109] ([123.20.118.31])
        by smtp.gmail.com with ESMTPSA id g10sm3589100pfh.120.2021.08.12.06.46.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 06:46:28 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] udp: UDP socket send queue repair
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        avagin@gmail.com, alexander@mihalicyn.com,
        lesedorucalin01@gmail.com
References: <20210811154557.6935-1-minhquangbui99@gmail.com>
 <721a2e32-c930-ad6b-5055-631b502ed11b@gmail.com>
From:   Bui Quang Minh <minhquangbui99@gmail.com>
Message-ID: <7f3ecbaf-7759-88ae-53d3-2cc5b1623aff@gmail.com>
Date:   Thu, 12 Aug 2021 20:46:23 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <721a2e32-c930-ad6b-5055-631b502ed11b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/2021 11:14 PM, Eric Dumazet wrote:
> 
> 
> On 8/11/21 5:45 PM, Bui Quang Minh wrote:
>> In this patch, I implement UDP_REPAIR sockoption and a new path in
>> udp_recvmsg for dumping the corked packet in UDP socket's send queue.
>>
>> A userspace program can use recvmsg syscall to get the packet's data and
>> the msg_name information of the packet. Currently, other related
>> information in inet_cork that are set in cmsg are not dumped.
>>
>> While working on this, I was aware of Lese Doru Calin's patch and got some
>> ideas from it.
> 
> 
> What is the use case for this feature, adding a test in UDP fast path ?

This feature is used to help CRIU to dump CORKed UDP packet in send queue. I'm 
sorry for being not aware of the performance perspective here.

> IMO, TCP_REPAIR hijacking standard system calls was a design error,
> we should have added new system calls.

You are right that adding new system calls is a better approach. What do you 
think about adding a new option in getsockopt approach?

Thanks,
Quang Minh.
