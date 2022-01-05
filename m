Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487484856B8
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiAEQgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:36:14 -0500
Received: from carlson.workingcode.com ([50.78.21.49]:40810 "EHLO
        carlson.workingcode.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiAEQgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 11:36:13 -0500
Received: from [50.78.21.49] (carlson [50.78.21.49])
        (authenticated bits=0)
        by carlson.workingcode.com (8.17.0.3/8.17.0.3/SUSE Linux 0.8) with ESMTPSA id 205GZqk1030880
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 5 Jan 2022 11:35:52 -0500
DKIM-Filter: OpenDKIM Filter v2.11.0 carlson.workingcode.com 205GZqk1030880
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=workingcode.com;
        s=carlson; t=1641400557;
        bh=yK4p/+uRKKYsr3yTjJQtJfTHMIdsfz2oInv5aFubXlY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=targrst+mEl1f/HF4qUCCF8ArUpeizd1jdElEVe7u95ygJJYZhwwcf7neNn/VpM2F
         J0JxhtvFZV1lKC6Qu5Wxse2d8k6D5qbByrgASe9Jk24vfXEH8lPCFOCqdDC5K6YOjg
         rjOeuEozuU0A3r2RiBBcCSy++DlhhOxvK+fyEijc=
Message-ID: <f78e2051-714d-ff74-7e36-bea3b4edc682@workingcode.com>
Date:   Wed, 5 Jan 2022 11:35:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] ppp: ensure minimum packet size in ppp_write()
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
References: <20220105114842.2380951-1-eric.dumazet@gmail.com>
 <20220105131929.GA17823@pc-1.home>
 <dbde2a45-a7dd-0e8a-d04c-233f69631885@workingcode.com>
 <20220105162954.GB17823@pc-1.home>
From:   James Carlson <carlsonj@workingcode.com>
In-Reply-To: <20220105162954.GB17823@pc-1.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-DCC-x.dcc-servers-Metrics: carlson 104; Body=9 Fuz1=9 Fuz2=9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 11:29, Guillaume Nault wrote:
> On Wed, Jan 05, 2022 at 10:30:09AM -0500, James Carlson wrote:
>> On 1/5/22 08:19, Guillaume Nault wrote:
>>> On Wed, Jan 05, 2022 at 03:48:42AM -0800, Eric Dumazet wrote:
>>>> From: Eric Dumazet <edumazet@google.com>
>>>>
>>>> It seems pretty clear ppp layer assumed user space
>>>> would always be kind to provide enough data
>>>> in their write() to a ppp device.
>>>>
>>>> This patch makes sure user provides at least
>>>> 2 bytes.
>>>>
>>>> It adds PPP_PROTO_LEN macro that could replace
>>>> in net-next many occurrences of hard-coded 2 value.
>>>
>>> The PPP header can be compressed to only 1 byte, but since 2 bytes is
>>> assumed in several parts of the code, rejecting such packets in
>>> ppp_xmit() is probably the best we can do.
>>
>> The only ones that can be compressed are those less than 0x0100, which
>> are (intentionally) all network layer protocols.  We should be getting
>> only control protocol messages though the user-space interface, not
>> network layer, so I'd say it's not just the best we can do, but indeed
>> the right thing to do by design.
> 
> Well, I know of at least one implementation that used to transmit data
> by writing on ppp unit file descriptors. That was a hack to work around
> some other problems. Not a beautiful one, but it worked.
> 

So, if you do that sort of hack, then you're constrained to send
uncompressed protocol numbers regardless of what's negotiated. That
seems like a tiny concession. (And receivers are required to handle
uncompressed no matter what LCP negotiation says, per 1661 6.5.)

And I'd still maintain that the intended design is that control
protocols are handled by the user portion, while network layer protocols
are connected in the kernel.

-- 
James Carlson         42.703N 71.076W         <carlsonj@workingcode.com>
