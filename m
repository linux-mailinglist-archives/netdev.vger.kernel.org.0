Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB7ADE251
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfJUCp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:45:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33276 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfJUCp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:45:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 202B1602D8; Mon, 21 Oct 2019 02:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571625928;
        bh=8uTFIfGtSSIYJ3ZuI4g2I7OoCL2DWgnMQeMXn8uL7is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kv/qvyCAtBvp/ipgqbMEksvY5RzVNqE6QO9Ky89t6iGTH3Boc4EUS7+xti/g7L8KT
         FsJu6nhLG9VmzgYcAYaNYVJP/HA1YKj/3qmB1VxZyeOowMU05UWYxZsoFg1jK6mlqy
         An0jO9obc2Rv0G0FySqxMab1XPrFnm7HDeOM4YEA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id E7A096030D;
        Mon, 21 Oct 2019 02:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571625926;
        bh=8uTFIfGtSSIYJ3ZuI4g2I7OoCL2DWgnMQeMXn8uL7is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hvUp2kZ/qSp1AkvFKKl0HgUqhiwR0R1HN9gLCvymgXVYAaeB7khVmN7bp8O2f4nc7
         deyfTLkEcio1FL0w0aQnG7QuuTNxcgqejRCLqw83QqMswFihAfHLDnx0igsGLLrklO
         X9H5S68bRbkSUdzIQo6ONW/hRmyjMx64j/v6JUqo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 20 Oct 2019 20:45:25 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
In-Reply-To: <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
 <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
Message-ID: <2279a8988c3f37771dda5593b350d014@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> FIN-WAIT1 just means the local application has called close() or
> shutdown() to shut down the sending direction of the socket, and the
> local TCP stack has sent a FIN, and is waiting to receive a FIN and an
> ACK from the other side (in either order, or simultaneously). The
> ASCII art state transition diagram on page 22 of RFC 793 (e.g.
> https://tools.ietf.org/html/rfc793#section-3.2 ) is one source for
> this, though the W. Richard Stevens books have a much more readable
> diagram.
> 
> There may still be unacked and SACKed data in the retransmit queue at
> this point.
> 

Thanks for the clarification.

> Thanks, that is a useful data point. Do you know what particular value
>  tp->sacked_out has? Would you be able to capture/log the value of
> tp->packets_out, tp->lost_out, and tp->retrans_out as well?
> 

tp->sacket_out varies per crash instance - 55, 180 etc.
However the other values are always the same - tp->packets_out is 0,
tp->lost_out is 1 and tp->retrans_out is 1.

> Yes, one guess would be that somehow the skbs in the retransmit queue
> have been freed, but tp->sacked_out is still non-zero and
> tp->highest_sack is still a dangling pointer into one of those freed
> skbs. The tcp_write_queue_purge() function is one function that fees
> the skbs in the retransmit queue and leaves tp->sacked_out as non-zero
> and  tp->highest_sack as a dangling pointer to a freed skb, AFAICT, so
> that's why I'm wondering about that function. I can't think of a
> specific sequence of events that would involve tcp_write_queue_purge()
> and then a socket that's still in FIN-WAIT1. Maybe I'm not being
> creative enough, or maybe that guess is on the wrong track. Would you
> be able to set a new bit in the tcp_sock in tcp_write_queue_purge()
> and log it in your instrumentation point, to see if
> tcp_write_queue_purge()  was called for these connections that cause
> this crash?

Sure, I can try this out.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
