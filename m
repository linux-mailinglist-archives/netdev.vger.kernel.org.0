Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CE8DF928
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 02:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfJVAEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 20:04:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbfJVAEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 20:04:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C0AB860909; Tue, 22 Oct 2019 00:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571702684;
        bh=4iTsFaI1TiNWCd6OdKQWrO+XwvtZM/sF7MhWLdOJ458=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z2cRUSuTBAwu7dZYmJ1y9epiG8PQ20e6Y89OnVRH+X9BO9gkVT0nhH2eExjYz5NHr
         7lN+BtwOy3cakSo0Zn+uJs/QI7o26L7A+yJ6KHW9QoFlR7aLVE5W+oEzYmAaR8jj/H
         UjxBQ19+ebd41rrvblGGcrcwaJfzhrncaK4BTBs4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id C478560112;
        Tue, 22 Oct 2019 00:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571702683;
        bh=4iTsFaI1TiNWCd6OdKQWrO+XwvtZM/sF7MhWLdOJ458=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qoq9VIFSE/xnnKckaXa+oKWU6knNpuApUeAmhi0ThhpD8WgQ2oP5JVo5nIDN7LJCt
         DvXEE5wmttiZ70R3FYmvE26FTPb9/ylQIAIvkfsq11n15yIxCzQ990vn1g+IsSihQn
         M1wyS5Ez/L0z6d6FsM7v81TQjY7AU7IWwv+j+hsE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Oct 2019 18:04:43 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
In-Reply-To: <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
 <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org>
 <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
Message-ID: <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Interesting! As tcp_input.c summarizes, "packets_out is
> SND.NXT-SND.UNA counted in packets". In the normal operation of a
> socket, tp->packets_out should not be 0 if any of those other fields
> are non-zero.
> 
> The tcp_write_queue_purge() function sets packets_out to 0:
> 
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/net/ipv4/tcp.c?h=v4.19#n2526
> 
> So the execution of tcp_write_queue_purge()  before this point is one
> way for the socket to end up in this weird state.
> 

In one of the instances, the values are tp->snd_nxt = 1016118098,
tp->snd_una = 1016047820

tp->mss_cache = 1378

I assume the number of outstanding segments should be
(tp->snd_nxt - tp->snd_una)/tp->mss_cache = 51

tp->packets_out = 0 and tp->sacked_out = 158 in this case.

>> > Yes, one guess would be that somehow the skbs in the retransmit queue
>> > have been freed, but tp->sacked_out is still non-zero and
>> > tp->highest_sack is still a dangling pointer into one of those freed
>> > skbs. The tcp_write_queue_purge() function is one function that fees
>> > the skbs in the retransmit queue and leaves tp->sacked_out as non-zero
>> > and  tp->highest_sack as a dangling pointer to a freed skb, AFAICT, so
>> > that's why I'm wondering about that function. I can't think of a
>> > specific sequence of events that would involve tcp_write_queue_purge()
>> > and then a socket that's still in FIN-WAIT1. Maybe I'm not being
>> > creative enough, or maybe that guess is on the wrong track. Would you
>> > be able to set a new bit in the tcp_sock in tcp_write_queue_purge()
>> > and log it in your instrumentation point, to see if
>> > tcp_write_queue_purge()  was called for these connections that cause
>> > this crash?

I've queued up a build which logs calls to tcp_write_queue_purge and
clears tp->highest_sack and tp->sacked_out. I will let you know how
it fares by end of week.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
