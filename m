Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227274F6BC0
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiDFUyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiDFUxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:53:50 -0400
X-Greylist: delayed 368 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Apr 2022 12:11:05 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD6FB6D1D;
        Wed,  6 Apr 2022 12:11:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 1A8B3CC0114;
        Wed,  6 Apr 2022 21:04:53 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed,  6 Apr 2022 21:04:50 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 65801CC0100;
        Wed,  6 Apr 2022 21:04:50 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 5937D340D76; Wed,  6 Apr 2022 21:04:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 57204340D60;
        Wed,  6 Apr 2022 21:04:50 +0200 (CEST)
Date:   Wed, 6 Apr 2022 21:04:50 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
cc:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jaco Kroon <jaco@uls.co.za>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
In-Reply-To: <20220406135807.GA16047@breakpoint.cc>
Message-ID: <726cf53c-f6aa-38a9-71c4-52fb2457f818@netfilter.org>
References: <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com> <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com> <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com> <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com> <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za> <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
 <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com> <CADVnQykexgJ+NEUojiKrt=HTomF0nL8CncF401+mEFkvuge7Rg@mail.gmail.com> <20220406135807.GA16047@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, 6 Apr 2022, Florian Westphal wrote:

> Neal Cardwell <ncardwell@google.com> wrote:
> 
> [ trimmed CCs, add Jozsef and nf-devel ]
> 
> Neal, Eric, thanks for debugging this problem.
> 
> > On Sat, Apr 2, 2022 at 12:32 PM Eric Dumazet <edumazet@google.com> wrote:
> > > On Sat, Apr 2, 2022 at 9:29 AM Neal Cardwell <ncardwell@google.com> wrote:
> > > > FWIW those log entries indicate netfilter on the mail client machine
> > > > dropping consecutive outbound skbs with 2*MSS of payload. So that
> > > > explains the large consecutive losses of client data packets to the
> > > > e-mail server. That seems to confirm my earlier hunch that those drops
> > > > of consecutive client data packets "do not look like normal congestive
> > > > packet loss".
> > >
> > > This also explains why we have all these tiny 2-MSS packets in the pcap.
> > > Under normal conditions, autocorking should kick in, allowing TCP to
> > > build bigger TSO packets.
> > 
> > I have not looked at the conntrack code before today, but AFAICT this
> > is the buggy section of  nf_conntrack_proto_tcp.c:
> > 
> >         } else if (((state->state == TCP_CONNTRACK_SYN_SENT
> >                      && dir == IP_CT_DIR_ORIGINAL)
> >                    || (state->state == TCP_CONNTRACK_SYN_RECV
> >                      && dir == IP_CT_DIR_REPLY))
> >                    && after(end, sender->td_end)) {
> >                 /*
> >                  * RFC 793: "if a TCP is reinitialized ... then it need
> >                  * not wait at all; it must only be sure to use sequence
> >                  * numbers larger than those recently used."
> >                  */
> >                 sender->td_end =
> >                 sender->td_maxend = end;
> >                 sender->td_maxwin = (win == 0 ? 1 : win);
> > 
> >                 tcp_options(skb, dataoff, tcph, sender);
> > 
> > Note that the tcp_options() function implicitly assumes it is being
> > called on a SYN, because it sets state->td_scale to 0 and only sets
> > state->td_scale to something non-zero if it sees a wscale option. So
> > if we ever call that on an skb that's not a SYN, we will forget that
> > the connection is using the wscale option.
> >
> > But at this point in the code it is calling tcp_options() without
> > first checking that this is a SYN.
> 
> Yes, thats the bug, tcp_options() must not be called if syn bit is not
> set.
> 
> > For this TFO scenario like the one in the trace, where the server
> > sends its first data packet after the SYNACK packet and before the
> > client's first ACK, presumably the conntrack state machine is
> > (correctly) SYN_RECV, and then (incorrectly) executes this code,
> 
> Right.  Jozsef, for context, sequence is in trace is:
> 
> S > C Flags [S], seq 3451342529, win 62580, options [mss 8940,sackOK,TS val 331187616 ecr 0,nop,wscale 7,tfo [|tcp]>
> C > S Flags [S.], seq 2699962254, ack 3451342530, win 65535, options [mss 1440,sackOK,TS val 1206542770 ecr 331187616,nop,wscale 8], length 0
> C > S Flags [P.], seq 1:89, ack 1, win 256, options [nop,nop,TS val 1206542772 ecr 331187616], length 88: SMTP [|smtp]
> 
> Normally, 3rd packet would be S > C, but this one is C > S.
> 
> So, packet #3 hits the 'reinit' branch which zaps wscale option.
> 
> > Someone more familiar with conntrack may have a good idea about how to
> > best fix this?
> 
> Jozsef, does this look sane to you?
> It fixes the TFO capture and still passes the test case i made for
> 82b72cb94666b3dbd7152bb9f441b068af7a921b
> ("netfilter: conntrack: re-init state for retransmitted syn-ack").

As far as I see it'd break simultaneous open because after(end, 
sender->td_end) is called in the new condition:

> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 8ec55cd72572..90ad1c0f23b1 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -556,33 +556,24 @@ static bool tcp_in_window(struct nf_conn *ct,
>  			}
>  
>  		}
> -	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
> -		     && dir == IP_CT_DIR_ORIGINAL)
> -		   || (state->state == TCP_CONNTRACK_SYN_RECV
> -		     && dir == IP_CT_DIR_REPLY))
> -		   && after(end, sender->td_end)) {
> +	} else if (tcph->syn &&
> +		   after(end, sender->td_end) &&
> +		   (state->state == TCP_CONNTRACK_SYN_SENT ||
> +		    state->state == TCP_CONNTRACK_SYN_RECV)) {
>  		/*
>  		 * RFC 793: "if a TCP is reinitialized ... then it need
>  		 * not wait at all; it must only be sure to use sequence
>  		 * numbers larger than those recently used."
> -		 */
> -		sender->td_end =
> -		sender->td_maxend = end;
> -		sender->td_maxwin = (win == 0 ? 1 : win);
> -
> -		tcp_options(skb, dataoff, tcph, sender);
> -	} else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
> -		   state->state == TCP_CONNTRACK_SYN_SENT) {
> -		/* Retransmitted syn-ack, or syn (simultaneous open).
>  		 *
> +		 * also check for retransmitted syn-ack, or syn (simultaneous open).
>  		 * Re-init state for this direction, just like for the first
>  		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
> +		 *
> +		 * Check for invalid syn-ack in original direction was already done.
>  		 */
>  		tcp_init_sender(sender, receiver,
>  				skb, dataoff, tcph,
>  				end, win);
> -		if (!tcph->ack)
> -			return true;
>  	}
>  
>  	if (!(tcph->ack)) {
> 

I'd merge the two conditions so that it'd cover both original condition 
branches:

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8ec55cd72572..87375ce2f995 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -556,33 +556,26 @@ static bool tcp_in_window(struct nf_conn *ct,
 			}
 
 		}
-	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
-		     && dir == IP_CT_DIR_ORIGINAL)
-		   || (state->state == TCP_CONNTRACK_SYN_RECV
-		     && dir == IP_CT_DIR_REPLY))
-		   && after(end, sender->td_end)) {
+	} else if (tcph->syn &&
+		   ((after(end, sender->td_end) &&
+		     (state->state == TCP_CONNTRACK_SYN_SENT ||
+		      state->state == TCP_CONNTRACK_SYN_RECV)) ||
+		    (dir == IP_CT_DIR_REPLY &&
+		     state->state == TCP_CONNTRACK_SYN_SENT))) {
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

What do you think?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
