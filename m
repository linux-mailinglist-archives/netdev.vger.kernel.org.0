Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC34F4F7CB5
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244231AbiDGK3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244230AbiDGK3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:29:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD4685950;
        Thu,  7 Apr 2022 03:27:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ncPLt-0003a3-PO; Thu, 07 Apr 2022 12:26:57 +0200
Date:   Thu, 7 Apr 2022 12:26:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jaco Kroon <jaco@uls.co.za>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Message-ID: <20220407102657.GB16047@breakpoint.cc>
References: <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
 <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
 <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com>
 <CADVnQykexgJ+NEUojiKrt=HTomF0nL8CncF401+mEFkvuge7Rg@mail.gmail.com>
 <20220406135807.GA16047@breakpoint.cc>
 <726cf53c-f6aa-38a9-71c4-52fb2457f818@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <726cf53c-f6aa-38a9-71c4-52fb2457f818@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> I'd merge the two conditions so that it'd cover both original condition 
> branches:
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 8ec55cd72572..87375ce2f995 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -556,33 +556,26 @@ static bool tcp_in_window(struct nf_conn *ct,
>  			}
>  
>  		}
> -	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
> -		     && dir == IP_CT_DIR_ORIGINAL)
> -		   || (state->state == TCP_CONNTRACK_SYN_RECV
> -		     && dir == IP_CT_DIR_REPLY))
> -		   && after(end, sender->td_end)) {
> +	} else if (tcph->syn &&
> +		   ((after(end, sender->td_end) &&
> +		     (state->state == TCP_CONNTRACK_SYN_SENT ||
> +		      state->state == TCP_CONNTRACK_SYN_RECV)) ||
> +		    (dir == IP_CT_DIR_REPLY &&
> +		     state->state == TCP_CONNTRACK_SYN_SENT))) {

Thats what I did as well, I merged the two branches but I made the
2nd clause stricter to also consider the after() test; it would no
longer re-init for syn-acks when sequence did not advance.

Then, dir == IP_CT_DIR_REPLY && state == SYN_SENT is already covered
by earlier test and can be elided.

I'm fine with your version though, will you submit a patch?
