Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6938B3B4762
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 18:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFYQ2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:28:39 -0400
Received: from novek.ru ([213.148.174.62]:33002 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhFYQ2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 12:28:38 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 4E5B95006F4;
        Fri, 25 Jun 2021 19:24:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 4E5B95006F4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624638258; bh=TTdfN3XYxrgv+fWtlaeKlYfmYOSe3GRZrTomK+ueHHI=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=APdl0BJKwsIDnfLQrO5QDTBVhaEo4COPBIKL+kCLURy8CetIDdQaLJG8Zn550HQl4
         /WgjuHE7iFh77bfZXOgWKN+BbfADOQuEBp9rCEX1GIzB6d1NCskuT0/dIGSMYO/G2f
         DhwMWRObFHi78rjnBe7enURu2Q665DF7uezf30QA=
Subject: Re: Fw: [Bug 213581] New: Change in ip_dst_mtu_maybe_forward() breaks
 WebRTC connections
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210625083632.5a321cef@hermes.local>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <11df926b-ed72-e558-8d49-46e1804eaefd@novek.ru>
Date:   Fri, 25 Jun 2021 17:26:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625083632.5a321cef@hermes.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.06.2021 16:36, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Fri, 25 Jun 2021 11:54:19 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 213581] New: Change in ip_dst_mtu_maybe_forward() breaks WebRTC connections
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=213581
> 
>              Bug ID: 213581
>             Summary: Change in ip_dst_mtu_maybe_forward() breaks WebRTC
>                      connections
>             Product: Networking
>             Version: 2.5
>      Kernel Version: 5.13.0-rc7
>            Hardware: All
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: normal
>            Priority: P1
>           Component: IPV4
>            Assignee: stephen@networkplumber.org
>            Reporter: godlike64@gmail.com
>          Regression: No
> 
> Recent Linux kernel versions (>=5.9 if my calculations are correct), when used
> as a gateway on a LAN (or a similar setup) will break WebRTC protocols such as
> Google Meet, Discord, etc. (have not done extensive testing but would gather
> that most similar protocols are affected). In the case of Meet, no video for
> any participant is ever shown (other than my own), and nobody can see my video,
> although audio does work. In the case of Discord, no audio/video for other
> participants is ever shown. Note that every meeting is initiated or joined from
> inside the LAN, not on the gateway itself.
> 
> Using plain iptables, firewalld+iptables or firewalld+nftables makes no
> difference (it was the first thing I tried). I discovered this a few months ago
> when updating the kernel, and found that reverting to the previous kernel made
> this work again. I didn't look further into it until now, when I can no longer
> stay on that old of a kernel :).
> 
> Using git-bisect I was able to identify the offending commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=02a1b175b0e92d9e0fa5df3957ade8d733ceb6a0
> 
> This patch was backported to linux-stable shortly after 5.4.72 released. It
> appears to still be there in vanilla upstream. I can confirm that reverting
> this patch in 5.4.109 fixes the issue and webrtc works again.
> 
> I have also reverted this patch in 5.13.0-rc7 and WebRTC works with the patch
> reverted. Without reverting the patch, it's broken.
> 
> No other protocol/connection seems to be affected.
> 
> Reproducible: Always
> 
> Steps to Reproduce:
> 1. Install any kernel >5.4.9 on a gateway device.
> 2. Try to use a conferencing application that uses WebRTC (Meet, Discord, etc).
> Either start or join a meeting from a device that sits in the LAN.
> Actual Results:
> Audio and/or video does not work when a meeting is initiated/joined from within
> the LAN
> 
> Expected Results:
> Both audio and video should work when inside the meeting.
> 
> My C is quite limited, but it appears that this function, from wherever it gets
> called, returns a different value after the mentioned commit. It used to
> return:
> 
> return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
> 
> Now it returns:
> 
> mtu = dst_metric_raw(dst, RTAX_MTU);
> if (mtu)
>      return mtu;
> 

I'm trying to deal with this function right now, so I can try to reproduce this 
bug too. Actually, the change should only affect configuration with route with 
mtu specified explicitly. What is the routing configuration for this case? Does 
it use any kind of tunnels to connect networks?

