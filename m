Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82075370005
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 19:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhD3RyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 13:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3RyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 13:54:19 -0400
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 7AA2FC06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:53:31 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 79BB0560EB8;
        Fri, 30 Apr 2021 17:53:29 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1619803264; t=1619805209;
        bh=OW+cFuPkQjwBHFEfvCQWBzvwWdLaAx8nDXyqjYXFXdE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PIIeUUcCWiN+YWeQeo+XlouI3/PdjxScuJIrUZFL8OSC0gwVcobKud0xXzOeD/OJE
         7GtX74REWFzLkzBXuAPyez+yFEjYMdwIJqxDC4Jt2XLXgLNyILJ7QBNGT1ySu/feIH
         yoOysnxacWNMqK2+/QSlRsx8RJsJlM0qQCnI0Gd86gq5boJJuGWa2s0dOhCYm775Z+
         Gl7kHQhZb72E3xBUtCsEM8uDXG0pvkMVdfU8/PNAmeRJgHFQqFevslGMeyNxFhNg4A
         UAvGJb1+pobMJRm99P7wl/o/j7UijLaxP+8C68GQoqIjX1JmNo16/NXh7SEmQTst8k
         v9NHcGR9glSNg==
Message-ID: <df6fdff3-f307-c631-44e7-15fda817662f@bluematt.me>
Date:   Fri, 30 Apr 2021 13:53:29 -0400
MIME-Version: 1.0
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Keyu Man <kman001@ucr.edu>
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me>
 <20210428141319.GA7645@1wt.eu>
 <055d0512-216c-9661-9dd4-007c46049265@bluematt.me>
 <CANn89iKfGhNYJVpj4T2MLkomkwPsYWyOof+COVvNFsfVfb7CRQ@mail.gmail.com>
 <64829c98-e4eb-6725-0fee-dc3c6681506f@bluematt.me>
 <1baf048d-18e8-3e0c-feee-a01b381b0168@bluematt.me>
 <CANn89iKJDUQuXBueuZWdi17LgFW3yb4LUsH3hzY08+ytJ9QgeA@mail.gmail.com>
 <c8ad9235-5436-8418-69a9-6c525fd254a4@bluematt.me>
 <CANn89iKJmbr_otzWrC19q5A_gGVRjMKso46=vT6=B9vUC5kgqA@mail.gmail.com>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <CANn89iKJmbr_otzWrC19q5A_gGVRjMKso46=vT6=B9vUC5kgqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/21 13:49, Eric Dumazet wrote:
> On Fri, Apr 30, 2021 at 7:42 PM Matt Corallo
> <netdev-list@mattcorallo.com> wrote:
>> This was never about DDoS attacks - as noted several times this is about it being trivial to have all your fragments
>> blackholed for 30 seconds at a time just because you have some normal run-of-the-mill packet loss.
> 
> Again, it will be trivial to have a use case where valid fragments are dropped.
> 
> Random can be considered as the worst strategy in some cases.
> 
> Queue management can tail drop, head drop, random drop, there is no
> magical choice.

Glad we're on the same page :).

>>
>> I agree with you wholeheartedly that there isn't a solution to the DDoS attack issue, I'm not trying to address it. On
>> the other hand, in the face of no attacks or otherwise malicious behavior, I'd expect Linux to not exhibit the complete
>> blackholing of fragments that it does today.
> 
> Your expectations are unfortunately not something that linux can
> satisfy _automatically_,
> you have to tweak sysctls to tune _your_ workload.

Yep, totally agree, its an optimization question. We just have to decide on what the most reasonable use-case is that 
can be supported at low cost.

I'm still a little dubious that a constant picked some twenty years ago is still the best selection for an optimization 
question that is a function of real-world networks.

Buffer bloat exists, but so do networks that will happily drop 1Mbps of packets. The first has always been true, the 
second only more recently has become more and more common (both due to network speed and application behavior).

Thanks again for your time and consideration,
Matt
