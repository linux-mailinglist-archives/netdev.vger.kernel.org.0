Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF2A486CDD
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244742AbiAFVxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:53:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:36242 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239651AbiAFVxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 16:53:51 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B2EEE64287;
        Thu,  6 Jan 2022 22:51:02 +0100 (CET)
Date:   Thu, 6 Jan 2022 22:53:45 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     zhang kai <zhangkaiheb@126.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: seqadj: check seq offset before update
Message-ID: <Yddk6YFEJ/FOWYT3@salvia>
References: <20211224023713.9260-1-zhangkaiheb@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211224023713.9260-1-zhangkaiheb@126.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 24, 2021 at 10:37:13AM +0800, zhang kai wrote:
> if seq/ack offset is zero, don't update

Please, provide more details: explain the scenario that triggers and
seq/ack offset adjustment of zero, describe the scenario that triggers
the bug, etc.

> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/netfilter/nf_conntrack_seqadj.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
> index 3066449f8bd8..d35e272a2e36 100644
> --- a/net/netfilter/nf_conntrack_seqadj.c
> +++ b/net/netfilter/nf_conntrack_seqadj.c
> @@ -186,11 +186,13 @@ int nf_ct_seq_adjust(struct sk_buff *skb,
>  	else
>  		seqoff = this_way->offset_before;
>  
> -	newseq = htonl(ntohl(tcph->seq) + seqoff);
> -	inet_proto_csum_replace4(&tcph->check, skb, tcph->seq, newseq, false);
> -	pr_debug("Adjusting sequence number from %u->%u\n",
> -		 ntohl(tcph->seq), ntohl(newseq));
> -	tcph->seq = newseq;
> +	if (seqoff) {
> +		newseq = htonl(ntohl(tcph->seq) + seqoff);
> +		inet_proto_csum_replace4(&tcph->check, skb, tcph->seq, newseq, false);
> +		pr_debug("Adjusting sequence number from %u->%u\n",
> +			 ntohl(tcph->seq), ntohl(newseq));
> +		tcph->seq = newseq;
> +	}
>  
>  	if (!tcph->ack)
>  		goto out;
> @@ -201,6 +203,9 @@ int nf_ct_seq_adjust(struct sk_buff *skb,
>  	else
>  		ackoff = other_way->offset_before;
>  
> +	if (!ackoff)
> +		goto out;
> +
>  	newack = htonl(ntohl(tcph->ack_seq) - ackoff);
>  	inet_proto_csum_replace4(&tcph->check, skb, tcph->ack_seq, newack,
>  				 false);
> -- 
> 2.17.1
> 
