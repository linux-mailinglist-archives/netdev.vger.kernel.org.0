Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4922A132F6
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 19:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfECROC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 13:14:02 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35114 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbfECROC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 13:14:02 -0400
Received: by mail-yw1-f65.google.com with SMTP id n188so4870266ywe.2
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 10:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6/g/tqSPu4NispOWvkbD5DPFB7kpfgeQVojJYWDhRdw=;
        b=lBIjld1/HwAAJYZ29cBZlmS3FRJgxDgfXA5sJLMmjEVwOzhTuyyav6mxxVRXR67mv7
         tc/lSvRo4dpclp4dLWzH6bWduMQGDj0WtrBlWktfNinzutRXwY4lJyD798u0UgtMEMJR
         QWjCCA41WbyZLd2wl61xpAgZa8ibQbTxNNp0wQluYOmBgJxDxrjOhNjp2S6cP5dRCWE3
         +LckjqpCV1dizZMae1fYkV7q3AObmcjrLfxCEjqjfOnN2WI4QUpYp/mB9f2rlXn5X0A1
         50wB+8scwE4nIXpDtEyDl6VnYYT0crvEleoXRdTr7tXB2fNMQ2gChfZdE5QhrQQil6Cv
         2e2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6/g/tqSPu4NispOWvkbD5DPFB7kpfgeQVojJYWDhRdw=;
        b=Uv8TSC1JMaGh1jxzIEgrdjZFlrskjijkMNG5H7wYYfrX5WUj7dChMo5vJRj1iRTR69
         ZgphaNAbScLHDUKrJ4/4Cl15rTifaYViP1RNQBDoaVQp9fDct8t1aXDlC9zr0KZE5Q/0
         3dlZ8WelmcVlbMykuQPgCLEL08J24vabzT5BrdaZqT3bp6V8caBYv6mFG82gyHiFQ61i
         X9QmFPvvFAFNyEtNknDIBQSNMsQw28OqLw+quKSk1Iyr/07s1uWLxep7NE/6Y2RfF3c4
         ehRCrXfY3q/bvDRe+fRE+oyzYMamZtAEo2L9az7O6sphM2JRw7vpFVNVLe4NkMzeEETi
         o9aA==
X-Gm-Message-State: APjAAAVLgxcaD6JrdCeUkIfFN+ibVDuifc6Nh0c0IgTnDrpRCh4T352y
        q1kcu5n2qTnMPX99beJLHp0=
X-Google-Smtp-Source: APXvYqzUYB1dG/B5stYk7Uy59xsokPEbUa690XAZxsi1toTecbVva7ASuptrRUvMb+a9c34PtR2wew==
X-Received: by 2002:a5b:289:: with SMTP id x9mr7740508ybl.313.1556903641624;
        Fri, 03 May 2019 10:14:01 -0700 (PDT)
Received: from [172.20.0.54] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id r11sm747134ywb.81.2019.05.03.10.14.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:14:00 -0700 (PDT)
Subject: Re: [PATCH net] ip6: fix skb leak in ip6frag_expire_frag_queue()
To:     Peter Oskolkov <posk@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Stfan Bader <stefan.bader@canonical.com>,
        Florian Westphal <fw@strlen.de>
References: <20190503114721.10502-1-edumazet@google.com>
 <CAPNVh5c-xeSaRkQgFtFUL1h3u0DpEozBXDP+xf-XEvXKbDgCYg@mail.gmail.com>
 <CANn89i+cRBCg=7Q4W45z9HuwJoCHspMNRKZJw9ztigjUDryY7w@mail.gmail.com>
 <CAPNVh5c88ZSAuhjdpf6_AULufZqjSkjWB7W8tguKzRTwYJbTWA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f6f20a1f-d86d-b735-e359-5ae7d2d8c546@gmail.com>
Date:   Fri, 3 May 2019 13:13:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAPNVh5c88ZSAuhjdpf6_AULufZqjSkjWB7W8tguKzRTwYJbTWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/19 11:58 AM, Peter Oskolkov wrote:
> On Fri, May 3, 2019 at 8:52 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Fri, May 3, 2019 at 11:33 AM Peter Oskolkov <posk@google.com> wrote:
>>>
>>> This skb_get was introduced by commit 05c0b86b9696802fd0ce5676a92a63f1b455bdf3
>>> "ipv6: frags: rewrite ip6_expire_frag_queue()", and the rbtree patch
>>> is not in 4.4, where the bug is reported at.
>>> Shouldn't the "Fixes" tag also reference the original patch?
>>
>> No, this bug really fixes a memory leak.
>>
>> Fact that it also fixes the XFRM issue is secondary, since all your
>> patches are being backported in stable
>> trees anyway for other reasons.
> 
> There are no plans to backport rbtree patches to 4.4 and earlier at
> the moment, afaik.
> 

No problem, I mentioned to Stefan what needs to be done.

(removing the head skb, removing the skb_get())

