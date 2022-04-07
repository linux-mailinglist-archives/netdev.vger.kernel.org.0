Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937A94F7F75
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245437AbiDGMuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244128AbiDGMuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:50:39 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A03792D38;
        Thu,  7 Apr 2022 05:48:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id D2C4DCC00FF;
        Thu,  7 Apr 2022 14:48:35 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu,  7 Apr 2022 14:48:33 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 4AF82CC00FD;
        Thu,  7 Apr 2022 14:48:33 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 3F373340D76; Thu,  7 Apr 2022 14:48:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 3DB1C340D60;
        Thu,  7 Apr 2022 14:48:33 +0200 (CEST)
Date:   Thu, 7 Apr 2022 14:48:33 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
cc:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jaco Kroon <jaco@uls.co.za>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
In-Reply-To: <20220407102657.GB16047@breakpoint.cc>
Message-ID: <9c6d2d7-70b-bd12-ee14-7923664afb1@netfilter.org>
References: <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com> <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com> <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za> <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com> <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com> <CADVnQykexgJ+NEUojiKrt=HTomF0nL8CncF401+mEFkvuge7Rg@mail.gmail.com>
 <20220406135807.GA16047@breakpoint.cc> <726cf53c-f6aa-38a9-71c4-52fb2457f818@netfilter.org> <20220407102657.GB16047@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > I'd merge the two conditions so that it'd cover both original condition 
> > branches:
> > 
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > index 8ec55cd72572..87375ce2f995 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -556,33 +556,26 @@ static bool tcp_in_window(struct nf_conn *ct,
> >  			}
> >  
> >  		}
> > -	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
> > -		     && dir == IP_CT_DIR_ORIGINAL)
> > -		   || (state->state == TCP_CONNTRACK_SYN_RECV
> > -		     && dir == IP_CT_DIR_REPLY))
> > -		   && after(end, sender->td_end)) {
> > +	} else if (tcph->syn &&
> > +		   ((after(end, sender->td_end) &&
> > +		     (state->state == TCP_CONNTRACK_SYN_SENT ||
> > +		      state->state == TCP_CONNTRACK_SYN_RECV)) ||
> > +		    (dir == IP_CT_DIR_REPLY &&
> > +		     state->state == TCP_CONNTRACK_SYN_SENT))) {
> 
> Thats what I did as well, I merged the two branches but I made the
> 2nd clause stricter to also consider the after() test; it would no
> longer re-init for syn-acks when sequence did not advance.

That's perfectly fine.

But what about simultaneous syn? The TCP state is zeroed in the REPLY 
direction, so the after() test can easily be false and the state wouldn't 
be picked up. Therefore I extended the condition.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
