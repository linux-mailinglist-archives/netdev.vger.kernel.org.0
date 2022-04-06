Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68894F65D6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbiDFQjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237942AbiDFQjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:39:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E67A3024D9;
        Wed,  6 Apr 2022 06:58:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nc6Ah-0005QG-9l; Wed, 06 Apr 2022 15:58:07 +0200
Date:   Wed, 6 Apr 2022 15:58:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>, Jaco Kroon <jaco@uls.co.za>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kadlec@netfilter.org
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Message-ID: <20220406135807.GA16047@breakpoint.cc>
References: <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
 <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
 <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com>
 <CADVnQykexgJ+NEUojiKrt=HTomF0nL8CncF401+mEFkvuge7Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVnQykexgJ+NEUojiKrt=HTomF0nL8CncF401+mEFkvuge7Rg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neal Cardwell <ncardwell@google.com> wrote:

[ trimmed CCs, add Jozsef and nf-devel ]

Neal, Eric, thanks for debugging this problem.

> On Sat, Apr 2, 2022 at 12:32 PM Eric Dumazet <edumazet@google.com> wrote:
> > On Sat, Apr 2, 2022 at 9:29 AM Neal Cardwell <ncardwell@google.com> wrote:
> > > FWIW those log entries indicate netfilter on the mail client machine
> > > dropping consecutive outbound skbs with 2*MSS of payload. So that
> > > explains the large consecutive losses of client data packets to the
> > > e-mail server. That seems to confirm my earlier hunch that those drops
> > > of consecutive client data packets "do not look like normal congestive
> > > packet loss".
> >
> > This also explains why we have all these tiny 2-MSS packets in the pcap.
> > Under normal conditions, autocorking should kick in, allowing TCP to
> > build bigger TSO packets.
> 
> I have not looked at the conntrack code before today, but AFAICT this
> is the buggy section of  nf_conntrack_proto_tcp.c:
> 
>         } else if (((state->state == TCP_CONNTRACK_SYN_SENT
>                      && dir == IP_CT_DIR_ORIGINAL)
>                    || (state->state == TCP_CONNTRACK_SYN_RECV
>                      && dir == IP_CT_DIR_REPLY))
>                    && after(end, sender->td_end)) {
>                 /*
>                  * RFC 793: "if a TCP is reinitialized ... then it need
>                  * not wait at all; it must only be sure to use sequence
>                  * numbers larger than those recently used."
>                  */
>                 sender->td_end =
>                 sender->td_maxend = end;
>                 sender->td_maxwin = (win == 0 ? 1 : win);
> 
>                 tcp_options(skb, dataoff, tcph, sender);
> 
> Note that the tcp_options() function implicitly assumes it is being
> called on a SYN, because it sets state->td_scale to 0 and only sets
> state->td_scale to something non-zero if it sees a wscale option. So
> if we ever call that on an skb that's not a SYN, we will forget that
> the connection is using the wscale option.
>
> But at this point in the code it is calling tcp_options() without
> first checking that this is a SYN.

Yes, thats the bug, tcp_options() must not be called if syn bit is not
set.

> For this TFO scenario like the one in the trace, where the server
> sends its first data packet after the SYNACK packet and before the
> client's first ACK, presumably the conntrack state machine is
> (correctly) SYN_RECV, and then (incorrectly) executes this code,

Right.  Jozsef, for context, sequence is in trace is:

S > C Flags [S], seq 3451342529, win 62580, options [mss 8940,sackOK,TS val 331187616 ecr 0,nop,wscale 7,tfo [|tcp]>
C > S Flags [S.], seq 2699962254, ack 3451342530, win 65535, options [mss 1440,sackOK,TS val 1206542770 ecr 331187616,nop,wscale 8], length 0
C > S Flags [P.], seq 1:89, ack 1, win 256, options [nop,nop,TS val 1206542772 ecr 331187616], length 88: SMTP [|smtp]

Normally, 3rd packet would be S > C, but this one is C > S.

So, packet #3 hits the 'reinit' branch which zaps wscale option.

> Someone more familiar with conntrack may have a good idea about how to
> best fix this?

Jozsef, does this look sane to you?
It fixes the TFO capture and still passes the test case i made for
82b72cb94666b3dbd7152bb9f441b068af7a921b
("netfilter: conntrack: re-init state for retransmitted syn-ack").

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8ec55cd72572..90ad1c0f23b1 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -556,33 +556,24 @@ static bool tcp_in_window(struct nf_conn *ct,
 			}
 
 		}
-	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
-		     && dir == IP_CT_DIR_ORIGINAL)
-		   || (state->state == TCP_CONNTRACK_SYN_RECV
-		     && dir == IP_CT_DIR_REPLY))
-		   && after(end, sender->td_end)) {
+	} else if (tcph->syn &&
+		   after(end, sender->td_end) &&
+		   (state->state == TCP_CONNTRACK_SYN_SENT ||
+		    state->state == TCP_CONNTRACK_SYN_RECV)) {
 		/*
 		 * RFC 793: "if a TCP is reinitialized ... then it need
 		 * not wait at all; it must only be sure to use sequence
 		 * numbers larger than those recently used."
-		 */
-		sender->td_end =
-		sender->td_maxend = end;
-		sender->td_maxwin = (win == 0 ? 1 : win);
-
-		tcp_options(skb, dataoff, tcph, sender);
-	} else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
-		   state->state == TCP_CONNTRACK_SYN_SENT) {
-		/* Retransmitted syn-ack, or syn (simultaneous open).
 		 *
+		 * also check for retransmitted syn-ack, or syn (simultaneous open).
 		 * Re-init state for this direction, just like for the first
 		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
+		 *
+		 * Check for invalid syn-ack in original direction was already done.
 		 */
 		tcp_init_sender(sender, receiver,
 				skb, dataoff, tcph,
 				end, win);
-		if (!tcph->ack)
-			return true;
 	}
 
 	if (!(tcph->ack)) {
