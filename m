Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD25C65FD7
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 21:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfGKTEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 15:04:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46238 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbfGKTEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 15:04:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id i8so3361136pgm.13
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 12:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=2O1dm9K6cIdVi874eo27CBgXviHY88BWqwd4kcEJgfA=;
        b=nTCWvmvdWiLqiAWFCfniq2l8HKH7IE8r1kOcfyTqQqDWyWlJ8MNFz/fhRvbvbQsWu0
         +mwgQCT5Ot90rCUeS96a+8eVVGmO7mX57Yt51jY9VD4VIfbl6FXvkqcsXfYQbvzonD/j
         LqzydhGbh14MuTTeKoV6EJL7CA++aPC9qyzEoa+zknUrcbyZXxlp1F/fR7sx3M4eECDF
         Rt0r40cVbMclizKMEY3E6hqtl0Vodjq9lPfIWAR1WYUhznNxOuj95C7fUAQJ1n3Di4qx
         AZHQD55mF8Vn3ehwJQ1IkCNBL/uuMsyAS7d9Tj1begQFVK3fD71xixE2U2MUwzCU7Y8u
         HCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=2O1dm9K6cIdVi874eo27CBgXviHY88BWqwd4kcEJgfA=;
        b=sWTCkZ0nMfETzD4SiOeyGG6zuFKeNH8pJqM78xEoKCEzAX7xLNW/VxDpcLcrJiG3Ct
         OAUMW2hRklRAwLqQBokwSiGoYMZ+FRKiK+yt5NwEuQEY5nPKseblPqGnqK+Rl69AHptJ
         wshcMwT7kuBCBIWoKA/gZJ08Xs/Y3syf2x3D7HPQdlKjh0rrpTGN+Q1vFBKKMJKVUkQd
         muZzmJ/eIHINzjAmD8awKcMi8sYvz9demm4UHKuLPulORVAfsJABBJ9rr5J2243IQCgS
         sjKwF9kmMGBQ/oJxAFWPSvyE0uoIPvbYfBdyyH/thNqx19UdA1qTxm4yude8OTZ1Xxj3
         Q4pQ==
X-Gm-Message-State: APjAAAVmbC7Cn9arL8lIhIv9DscIqIXxmPMICRHabndSDp+TM/2Y0eyg
        LcQ9u9MUceWq/snPoD1fV2M=
X-Google-Smtp-Source: APXvYqxotWwHNAxE5uCsH9KPocVRBli2liiTV5cXNWNDYL26NqUsvm85Xe1oIjvLCLNwpqG1+Cdv1g==
X-Received: by 2002:a63:374a:: with SMTP id g10mr5943347pgn.31.1562871889875;
        Thu, 11 Jul 2019 12:04:49 -0700 (PDT)
Received: from [172.20.53.108] ([2620:10d:c090:200::1b4d])
        by smtp.gmail.com with ESMTPSA id k70sm11303088pje.14.2019.07.11.12.04.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 12:04:49 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Eric Dumazet" <eric.dumazet@gmail.com>
Cc:     "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        "Christoph Paasch" <christoph.paasch@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jonathan Looney" <jtl@netflix.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Bruce Curtis" <brucec@netflix.com>,
        "Dustin Marquess" <dmarquess@apple.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Date:   Thu, 11 Jul 2019 12:04:48 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <4B9799E0-A736-4944-9BF3-FBACCFBDCCC5@gmail.com>
In-Reply-To: <d4b1ab65-c308-382a-2a0e-9042750335e0@gmail.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
 <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
 <adec774ed16540c6b627c2f607f3e216@ll.mit.edu>
 <d4b1ab65-c308-382a-2a0e-9042750335e0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11 Jul 2019, at 11:28, Eric Dumazet wrote:

> On 7/11/19 7:14 PM, Prout, Andrew - LLSC - MITLL wrote:
>>
>> In my opinion, if a small SO_SNDBUF below a certain value is no 
>> longer supported, then SOCK_MIN_SNDBUF should be adjusted to reflect 
>> this. The RCVBUF/SNDBUF sizes are supposed to be hints, no error is 
>> returned if they are not honored. The kernel should continue to 
>> function regardless of what userspace requests for their values.
>>
>
> It is supported to set whatever SO_SNDBUF value and get terrible 
> performance.
>
> It always has been.
>
> The only difference is that we no longer allow an attacker to fool TCP 
> stack
> and consume up to 2 GB per socket while SO_SNDBUF was set to 128 KB.
>
> The side effect is that in some cases, the workload can appear to have 
> the signature of the attack.
>
> The solution is to increase your SO_SNDBUF, or even better let TCP 
> stack autotune it.
> nobody forced you to set very small values for it.

I discovered we have some production services that set SO_SNDBUF to
very small values (~4k), as they are essentially doing interactive
communications, not bulk transfers.  But there's a difference between
"terrible performance" and "TCP stops working".
-- 
Jonathan
