Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489BC14F813
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 15:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgBAOgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 09:36:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56031 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgBAOgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 09:36:18 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so11112308wmj.5;
        Sat, 01 Feb 2020 06:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=ToTlhUmffyf/A4SVkFIr/tfQPx5sGPUvI56+zcHPEUw=;
        b=cfiA1kjcC+BVeP9rXotWDpsyjbC+sJuhp+Xv8Oo5uG40Tl6RNehPE8FVbcESG+prbW
         3Iu7m5yc8g1I7Ree380egdQKtrBapc6W2p+x5aNoxylxYlNgD/zOW/q52hFB0iNQyxqj
         K1ARpQV+GgaKcaEBPUVqRfdAbDqOyGRHPbBxa8JkgCB23IsZo9NrIyONQTC/W14sIq+Q
         vhKbaHiMpV4QWCUpMn/Ht/45ieORhzT57+Myp+qzsoLKBT1hQmAmXkhexrgthm3hXjkC
         tdUG1QGmnRNfyPTFXkPeH+PhKBqYotgqaaQDeF/EeSct+eVQsjzDIAoUfG+grOMiAbAt
         WciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=ToTlhUmffyf/A4SVkFIr/tfQPx5sGPUvI56+zcHPEUw=;
        b=W1BepHMpFQ2DpM2W8RLiLpDpkrv4GNhyPCjY+1wHpEGYFbxKgrQakcxj6tH7VNqcTx
         P2Nq2pxx56hDIJf1TbRX674nmm07nK1jUb+8H+IDiLhf/1lVLJN4rPE0kW2p8gEBZLI6
         JKw5AilXlDbjAidzn9qowmscwwALF/tl2rjR06LimwcymZXce46CksGXMfpG+FPcW31O
         sKvNbLfs5UQFhpTPt3KGWfuXdDNCdETu3CTBlhQ0ZsXF8G7K7kZDSIVvSgomY0ojVKSL
         nBY9ADwOfIdCFN6m3wDaX3UnkIx8PNKRyI7Mcj1talBUYus/iVeD89lIRu97tpjtkNFi
         c0rA==
X-Gm-Message-State: APjAAAVLxdPz8YW02k/bpzn/e8SiM9epZjOPeQ8AsngOaZHi9p15sazG
        Etoyk+XLgXNich0GFGnBooNQxCOX0ns=
X-Google-Smtp-Source: APXvYqzTMnln0B3RAggD6XzXDTdJhlDANqZdbhISoGJwV1cDa/nFYPLckKwlwlTwpeAnUR8pPKu6/Q==
X-Received: by 2002:a1c:a947:: with SMTP id s68mr18954093wme.61.1580567775804;
        Sat, 01 Feb 2020 06:36:15 -0800 (PST)
Received: from localhost.localdomain ([88.128.88.116])
        by smtp.gmail.com with ESMTPSA id b16sm17677481wrj.23.2020.02.01.06.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 06:36:14 -0800 (PST)
From:   SeongJae Park <sj38.park@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     sj38.park@gmail.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, aams@amazon.com,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuah@kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        David Laight <David.Laight@aculab.com>,
        SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: [PATCH v2 1/2] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Sat,  1 Feb 2020 15:36:08 +0100
Message-Id: <20200201143608.6742-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CADVnQynpW0BZXK+hp94HF75sVnmCjTfpc9NbKU2Y+UQODnxwyQ@mail.gmail.com> (raw)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Feb 2020 08:51:48 -0500 Neal Cardwell <ncardwell@google.com> wrote:

> On Sat, Feb 1, 2020 at 2:19 AM <sj38.park@gmail.com> wrote:
> >
> > From: SeongJae Park <sjpark@amazon.de>
> >
> > When closing a connection, the two acks that required to change closing
> > socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
> > reverse order.  This is possible in RSS disabled environments such as a
> > connection inside a host.
> >
> > For example, expected state transitions and required packets for the
> > disconnection will be similar to below flow.
> >
> >          00 (Process A)                         (Process B)
> >          01 ESTABLISHED                         ESTABLISHED
> >          02 close()
> >          03 FIN_WAIT_1
> >          04             ---FIN-->
> >          05                                     CLOSE_WAIT
> >          06             <--ACK---
> >          07 FIN_WAIT_2
> >          08             <--FIN/ACK---
> >          09 TIME_WAIT
> >          10             ---ACK-->
> >          11                                     LAST_ACK
> >          12 CLOSED                              CLOSED
> >
> > In some cases such as LINGER option applied socket, the FIN and FIN/ACK
> > will be substituted to RST and RST/ACK, but there is no difference in
> > the main logic.
> >
> > The acks in lines 6 and 8 are the acks.  If the line 8 packet is
> > processed before the line 6 packet, it will be just ignored as it is not
> > a expected packet, and the later process of the line 6 packet will
> > change the status of Process A to FIN_WAIT_2, but as it has already
> > handled line 8 packet, it will not go to TIME_WAIT and thus will not
> > send the line 10 packet to Process B.  Thus, Process B will left in
> > CLOSE_WAIT status, as below.
> >
> >          00 (Process A)                         (Process B)
> >          01 ESTABLISHED                         ESTABLISHED
> >          02 close()
> >          03 FIN_WAIT_1
> >          04             ---FIN-->
> >          05                                     CLOSE_WAIT
> >          06                             (<--ACK---)
> >          07                             (<--FIN/ACK---)
> >          08                             (fired in right order)
> >          09             <--FIN/ACK---
> >          10             <--ACK---
> >          11             (processed in reverse order)
> >          12 FIN_WAIT_2
> >
> > Later, if the Process B sends SYN to Process A for reconnection using
> > the same port, Process A will responds with an ACK for the last flow,
> > which has no increased sequence number.  Thus, Process A will send RST,
> > wait for TIMEOUT_INIT (one second in default), and then try
> > reconnection.  If reconnections are frequent, the one second latency
> > spikes can be a big problem.  Below is a tcpdump results of the problem:
> >
> >     14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
> >     14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512
> >     14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq 2541101298
> >     /* ONE SECOND DELAY */
> >     15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
> >
> > This commit mitigates the problem by reducing the delay for the next SYN
> > if the suspicous ACK is received while in SYN_SENT state.
> >
> > Following commit will add a selftest, which can be also helpful for
> > understanding of this issue.
> >
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >  net/ipv4/tcp_input.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 2a976f57f7e7..980bd04b9d95 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5893,8 +5893,14 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
> >                  *        the segment and return)"
> >                  */
> >                 if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
> > -                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
> > +                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
> > +                       /* Previous FIN/ACK or RST/ACK might be ignored. */
> > +                       if (icsk->icsk_retransmits == 0)
> > +                               inet_csk_reset_xmit_timer(sk,
> > +                                               ICSK_TIME_RETRANS, TCP_ATO_MIN,
> > +                                               TCP_RTO_MAX);
> >                         goto reset_and_undo;
> > +               }
> >
> >                 if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
> >                     !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
> > --
> 
> Scheduling a timer for TCP_ATO_MIN, typically 40ms, sounds like it
> might be a bit on the slow side. How about TCP_TIMEOUT_MIN, which is
> typically 2ms on a HZ=1000 kernel?
> 
> I think this would be closer to what Eric mentioned: "sending the SYN
> a few ms after the RST seems way better than waiting 1 second as if we
> received no packet at all."

Agreed, it seems much better!  Because this is just a small change in a tiny
patchset containing only two patches, I will send the updated version of only
this patch in reply to this mail, as soon as I finish tests.


Thanks,
SeongJae Park
> 
> neal
