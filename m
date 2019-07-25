Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1497D74707
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 08:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfGYGT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 02:19:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46229 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfGYGT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 02:19:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so49330826wru.13;
        Wed, 24 Jul 2019 23:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oairFP+0IPKj9z34QsgCMnG9avxEW40PIU4DCp8RWuw=;
        b=P2WDBWnFpseUEZC2tFSn/41K/3wV8NfZRDP8IOxM4ICMYSeIwFduUAq9oz3lb9ovhk
         h4SJhOBkiAyddhMSBxOGPxa0kp6WmrY170evuzYJ6F4yBXE2KG+Ze6ukW8XeXVpObS0j
         reYS7dNb/OlXKlmcehv+3BhapgXsvRmGBzRCp+VYrVC5/Kqvi2JHUg2w5RmDpTgK6oir
         eKtMw1griabhuXiNQFGkaeAgvxXDYfDZEyT+EXP0Ecaw11tZi34UUu42L81Sgq06YGtG
         8eeBm4mgn7c15fBWPUcRWdfwi4r3ojWlosS5XyB5xcpwmneZpj+dHFeR1JIIHiMZnAQr
         aBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oairFP+0IPKj9z34QsgCMnG9avxEW40PIU4DCp8RWuw=;
        b=Gzj+OWMIv6eQjkTBWQcqCi1s1X2xvvvDA/iQLR7MmsZYOJTM1QTc5b2z0D88KR+Tfc
         RvEs39cW9uNkZT45nX8dCRPnTYJBFj8pf7jlHgep3CI02ELKuf+ujfMhUcrJLVYdF2RO
         eang1BoIlVjDcGK0TZ+dROwGV2JOK2B+5qc5FCBOwU/CVew2AX3U/E6sUBaSQz5CDOmt
         GvM2NddF5IvINqD6rL32+yDIETw+y5IKblDZRs6Uw1dUI7vc1erE64jGSRKoLyUa3Wzf
         CBtlfCQBQlUW6UsJ+bqqFPbVhQ3v/R7f1fXRcTnHhH32ijkoO+rDtYTNKWd1e9HeG2Zb
         e3Lw==
X-Gm-Message-State: APjAAAXLYd/R9sihud6eZkaJmP2EgD0QBxSSjEzgwUw5wy+mz6eaL57Y
        YWkvGj8J7eGTU87vAVY6Fl09jhZ7
X-Google-Smtp-Source: APXvYqzUfCB9qKelAt7/YGzQ+wDGxjkeqzNGZaQxBMlUr15kSwxOCLHvY9XrWW8c1hbwMT4ANQlhbQ==
X-Received: by 2002:a5d:6583:: with SMTP id q3mr98127700wru.184.1564035594038;
        Wed, 24 Jul 2019 23:19:54 -0700 (PDT)
Received: from [192.168.8.147] (240.169.185.81.rev.sfr.net. [81.185.169.240])
        by smtp.gmail.com with ESMTPSA id r11sm60497627wre.14.2019.07.24.23.19.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 23:19:53 -0700 (PDT)
Subject: Re: [PATCH 4.4 stable net] net: tcp: Fix use-after-free in
 tcp_write_xmit
To:     maowenan <maowenan@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190724091715.137033-1-maowenan@huawei.com>
 <2e09f4d1-8a47-27e9-60f9-63d3b19a98ec@gmail.com>
 <13ffa2fe-d064-9786-bc52-e4281d26ed1d@huawei.com>
 <44f0ba0d-fd19-d44b-9c5c-686e2f8ef988@gmail.com>
 <9a8d6a5a-9a9d-9cb5-caa9-5c12ba04a43c@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <510109e3-101f-517c-22b4-921432f04fe5@gmail.com>
Date:   Thu, 25 Jul 2019 08:19:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9a8d6a5a-9a9d-9cb5-caa9-5c12ba04a43c@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/25/19 6:29 AM, maowenan wrote:
> 

>>>>> Syzkaller reproducer():
>>>>> r0 = socket$packet(0x11, 0x3, 0x300)
>>>>> r1 = socket$inet_tcp(0x2, 0x1, 0x0)
>>>>> bind$inet(r1, &(0x7f0000000300)={0x2, 0x4e21, @multicast1}, 0x10)
>>>>> connect$inet(r1, &(0x7f0000000140)={0x2, 0x1000004e21, @loopback}, 0x10)
>>>>> recvmmsg(r1, &(0x7f0000001e40)=[{{0x0, 0x0, &(0x7f0000000100)=[{&(0x7f00000005c0)=""/88, 0x58}], 0x1}}], 0x1, 0x40000000, 0x0)
>>>>> sendto$inet(r1, &(0x7f0000000000)="e2f7ad5b661c761edf", 0x9, 0x8080, 0x0, 0x0)
>>>>> r2 = fcntl$dupfd(r1, 0x0, r0)
>>>>> connect$unix(r2, &(0x7f00000001c0)=@file={0x0, './file0\x00'}, 0x6e)
>>>>>
>>
>> It does call tcp_disconnect(), by one of the connect() call.
> 
> yes, __inet_stream_connect will call tcp_disconnect when sa_family == AF_UNSPEC, in c repro if it
> passes sa_family with AF_INET it won't call disconnect, and then sk_send_head won't be NULL when tcp_connect.
> 


Look again at the Syzkaller reproducer()

It definitely uses tcp_disconnect()

Do not be fooled by connect$unix(), this is a connect() call really, with AF_UNSPEC
