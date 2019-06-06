Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F056374A3
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfFFM6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:58:21 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50984 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbfFFM6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 08:58:21 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hYryE-00016f-MH; Thu, 06 Jun 2019 14:58:18 +0200
Date:   Thu, 6 Jun 2019 14:58:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, jhs@mojatatu.com, fw@strlen.de,
        oss-drivers@netronome.com
Subject: Re: [RFC net-next v2 1/1] net: sched: protect against loops in TC
 filter hooks
Message-ID: <20190606125818.bvo5im2wqj365tai@breakpoint.cc>
References: <1559825374-32117-1-git-send-email-john.hurley@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559825374-32117-1-git-send-email-john.hurley@netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Hurley <john.hurley@netronome.com> wrote:
> TC hooks allow the application of filters and actions to packets at both
> ingress and egress of the network stack. It is possible, with poor
> configuration, that this can produce loops whereby an ingress hook calls
> a mirred egress action that has an egress hook that redirects back to
> the first ingress etc. The TC core classifier protects against loops when
> doing reclassifies but there is no protection against a packet looping
> between multiple hooks. This can lead to stack overflow panics among other
> things.
> 
> Previous versions of the kernel (<4.2) had a TTL count in the tc_verd skb
> member that protected against loops. This was removed and the tc_verd
> variable replaced by bit fields.
> 
> Extend the TC fields in the skb with an additional 2 bits to store the TC
> hop count. This should use existing allocated memory in the skb.
> 
> Add the checking and setting of the new hop count to the act_mirred file
> given that it is the source of the loops. This means that the code
> additions are not in the main datapath.
> 
> v1->v2
> - change from per cpu counter to per skb tracking (Jamal)
> - move check/update from fast path to act_mirred (Daniel)
> 
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> ---
>  include/linux/skbuff.h | 2 ++
>  net/sched/act_mirred.c | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 2ee5e63..f0dbc5b 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -645,6 +645,7 @@ typedef unsigned char *sk_buff_data_t;
>   *	@tc_at_ingress: used within tc_classify to distinguish in/egress
>   *	@tc_redirected: packet was redirected by a tc action
>   *	@tc_from_ingress: if tc_redirected, tc_at_ingress at time of redirect
> + *	@tc_hop_count: hop counter to prevent packet loops
>   *	@peeked: this packet has been seen already, so stats have been
>   *		done for it, don't do them again
>   *	@nf_trace: netfilter packet trace flag
> @@ -827,6 +828,7 @@ struct sk_buff {
>  	__u8			tc_at_ingress:1;
>  	__u8			tc_redirected:1;
>  	__u8			tc_from_ingress:1;
> +	__u8			tc_hop_count:2;

I dislike this, why can't we just use a pcpu counter?

The only problem is with recursion/nesting; whenever we
hit something that queues the skb for later we're safe.

We can't catch loops in real (physical) setups either,
e.g. bridge looping back on itself.
