Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1C8244C9B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgHNQ0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgHNQ0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 12:26:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41DAA20774;
        Fri, 14 Aug 2020 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597422374;
        bh=/SHBgGxBS8/a5WR2ThEGzx65pkiQmIhwMPE6VBiLKJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D93YTt0bYfTwxfBxPPsxAWXvLb6DYWCun4SEwhzot527rmJ3rCAsDRLYZgOZ0h8Zt
         3lHZ8oXoowW77f7Sgmeyq0cKnmj1gq4VPjcm1hrXSGRZu7w4IIflTdWReD7cDuHmN8
         zhQkisnsHxKqqRytYIf+2OysW86MHlODAulhS3uc=
Date:   Fri, 14 Aug 2020 12:26:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        "w@1wt.eu" <w@1wt.eu>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ohering@suse.com" <ohering@suse.com>
Subject: Re: [PATCH][for v4.4 only] udp: drop corrupt packets earlier to
 avoid data corruption
Message-ID: <20200814162613.GP2975990@sasha-vm>
References: <20200728015505.37830-1-decui@microsoft.com>
 <KL1P15301MB0279A6C3BB3ACADE410F8144BF490@KL1P15301MB0279.APCP153.PROD.OUTLOOK.COM>
 <20200813000650.GL2975990@sasha-vm>
 <CANn89iJmJdCdhn3pJYs4sh4YJsStqOQgGnvTyNKf=iPrN8Av5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANn89iJmJdCdhn3pJYs4sh4YJsStqOQgGnvTyNKf=iPrN8Av5g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 05:09:37PM -0700, Eric Dumazet wrote:
>On Wed, Aug 12, 2020 at 5:06 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Fri, Aug 07, 2020 at 06:03:00PM +0000, Dexuan Cui wrote:
>> >> From: Dexuan Cui <decui@microsoft.com>
>> >> Sent: Monday, July 27, 2020 6:55 PM
>> >> To: gregkh@linuxfoundation.org; edumazet@google.com;
>> >> stable@vger.kernel.org
>> >> Cc: w@1wt.eu; Dexuan Cui <decui@microsoft.com>; Joseph Salisbury
>> >> <Joseph.Salisbury@microsoft.com>; Michael Kelley <mikelley@microsoft.com>;
>> >> viro@zeniv.linux.org.uk; netdev@vger.kernel.org; davem@davemloft.net;
>> >> ohering@suse.com
>> >> Subject: [PATCH][for v4.4 only] udp: drop corrupt packets earlier to avoid data
>> >> corruption
>> >>
>> >> The v4.4 stable kernel lacks this bugfix:
>> >> commit 327868212381 ("make skb_copy_datagram_msg() et.al. preserve
>> >> ->msg_iter on error").
>> >> As a result, the v4.4 kernel can deliver corrupt data to the application
>> >> when a corrupt UDP packet is closely followed by a valid UDP packet: the
>> >> same invocation of the recvmsg() syscall can deliver the corrupt packet's
>> >> UDP payload to the application with the UDP payload length and the
>> >> "from IP/Port" of the valid packet.
>> >>
>> >> Details:
>> >>
>> >> For a UDP packet longer than 76 bytes (see the v5.8-rc6 kernel's
>> >> include/linux/skbuff.h:3951), Linux delays the UDP checksum verification
>> >> until the application invokes the syscall recvmsg().
>> >>
>> >> In the recvmsg() syscall handler, while Linux is copying the UDP payload
>> >> to the application's memory, it calculates the UDP checksum. If the
>> >> calculated checksum doesn't match the received checksum, Linux drops the
>> >> corrupt UDP packet, and then starts to process the next packet (if any),
>> >> and if the next packet is valid (i.e. the checksum is correct), Linux
>> >> will copy the valid UDP packet's payload to the application's receiver
>> >> buffer.
>> >>
>> >> The bug is: before Linux starts to copy the valid UDP packet, the data
>> >> structure used to track how many more bytes should be copied to the
>> >> application memory is not reset to what it was when the application just
>> >> entered the kernel by the syscall! Consequently, only a small portion or
>> >> none of the valid packet's payload is copied to the application's
>> >> receive buffer, and later when the application exits from the kernel,
>> >> actually most of the application's receive buffer contains the payload
>> >> of the corrupt packet while recvmsg() returns the length of the UDP
>> >> payload of the valid packet.
>> >>
>> >> For the mainline kernel, the bug was fixed in commit 327868212381,
>> >> but unluckily the bugfix is only backported to v4.9+. It turns out
>> >> backporting 327868212381 to v4.4 means that some supporting patches
>> >> must be backported first, so the overall changes seem too big, so the
>> >> alternative is performs the csum validation earlier and drops the
>> >> corrupt packets earlier.
>> >>
>> >> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> >> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>> >> ---
>> >>  net/ipv4/udp.c | 3 +--
>> >>  net/ipv6/udp.c | 6 ++----
>> >>  2 files changed, 3 insertions(+), 6 deletions(-)
>> >>
>> >> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>> >> index bb30699..49ab587 100644
>> >> --- a/net/ipv4/udp.c
>> >> +++ b/net/ipv4/udp.c
>> >> @@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct
>> >> sk_buff *skb)
>> >>              }
>> >>      }
>> >>
>> >> -    if (rcu_access_pointer(sk->sk_filter) &&
>> >> -        udp_lib_checksum_complete(skb))
>> >> +    if (udp_lib_checksum_complete(skb))
>> >>              goto csum_error;
>> >>
>> >>      if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
>> >> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> >> index 73f1112..2d6703d 100644
>> >> --- a/net/ipv6/udp.c
>> >> +++ b/net/ipv6/udp.c
>> >> @@ -686,10 +686,8 @@ int udpv6_queue_rcv_skb(struct sock *sk, struct
>> >> sk_buff *skb)
>> >>              }
>> >>      }
>> >>
>> >> -    if (rcu_access_pointer(sk->sk_filter)) {
>> >> -            if (udp_lib_checksum_complete(skb))
>> >> -                    goto csum_error;
>> >> -    }
>> >> +    if (udp_lib_checksum_complete(skb))
>> >> +            goto csum_error;
>> >>
>> >>      if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
>> >>              UDP6_INC_STATS_BH(sock_net(sk),
>> >> --
>> >> 1.8.3.1
>> >
>> >+Sasha
>> >
>> >This patch is targeted to the linux-4.4.y branch of the stable tree.
>>
>> Eric, will you ack this (or have a missed a previous ack)?
>
>Sure, although I have already a Signed-off-by: tag on this one, since
>I wrote this simpler fix for stable.
>
>If needed :
>Acked-by: Eric Dumazet <edumazet@google.com>

Ah, I see. Queued up, thanks!

-- 
Thanks,
Sasha
