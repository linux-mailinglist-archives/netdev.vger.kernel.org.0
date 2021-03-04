Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9250D32DA0E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 20:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbhCDTHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 14:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237847AbhCDTHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 14:07:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38AF964F69;
        Thu,  4 Mar 2021 19:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614884787;
        bh=8zECwZ3PQe3CB4hmZBjMYu9XF22SCzcVNcf9eEkliiI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CuV/WylTMkHoyD3EfoLRz8Vovqd9a6MaYItwL0yilVDR5QbFdYNue+sJqB4Nnp0JD
         ia+THkZTFd8JbAoA/r9WgjqYOQpdPzVr52P5ZFCvOFfsoM1SdlMs3h+eBGYSHC+Xv3
         z2acOPR96+fwKulwspsciiRLtDg36Y7GaWr5Av19u9XnRKYAwAbsl72kUYv6uBE+6E
         AjN9rbnFmavTb/IwXsFSJui7qhfRVlqvFn/EYISWCWKVDmVVicAtHGkKtWsdGM1UZE
         PXxKgqbYjaZzQVk5AQHSIifq59XhLf0P+WFOveckbB2Hz29hygq+7sylkqqcBdvx1x
         qz+Y4deyZFBiA==
Date:   Thu, 4 Mar 2021 11:06:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen
 SYN
Message-ID: <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
References: <20210302060753.953931-1-kuba@kernel.org>
        <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
        <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
        <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
        <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Mar 2021 13:51:15 +0100 Eric Dumazet wrote:
> I think we are over thinking this really (especially if the fix needs
> a change in core networking or drivers)
> 
> We can reuse TSQ logic to have a chance to recover when the clone is
> eventually freed.
> This will be more generic, not only for the SYN+data of FastOpen.
> 
> Can you please test the following patch ?

#7 - Eric comes up with something much better :)


But so far doesn't seem to quite do it, I'm looking but maybe you'll
know right away (FWIW testing a v5.6 backport but I don't think TSQ
changed?):

On __tcp_retransmit_skb kretprobe:

==> Hit TFO case ret:-16 ca_state:0 skb:ffff888fdb4bac00!

First hit:
        __tcp_retransmit_skb+1
        tcp_rcv_state_process+2488
        tcp_v6_do_rcv+405
        tcp_v6_rcv+2984
        ip6_protocol_deliver_rcu+180
        ip6_input_finish+17

Successful hit:
        __tcp_retransmit_skb+1
        tcp_retransmit_skb+18
        tcp_retransmit_timer+716
        tcp_write_timer_handler+136
        tcp_write_timer+141
        call_timer_fn+43

 skb:ffff888fdb4bac00 --- delay:51642us bytes_acked:1
