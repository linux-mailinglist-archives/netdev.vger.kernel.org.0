Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C7C28B546
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 14:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgJLM4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 08:56:30 -0400
Received: from correo.us.es ([193.147.175.20]:50754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730260AbgJLM4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 08:56:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F386D28C1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 14:56:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01AB5DA704
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 14:56:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EB2E0DA78C; Mon, 12 Oct 2020 14:56:16 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F32B2DA72F;
        Mon, 12 Oct 2020 14:56:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 14:56:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C984842EE38F;
        Mon, 12 Oct 2020 14:56:14 +0200 (CEST)
Date:   Mon, 12 Oct 2020 14:56:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: Drop fragmented ndisc packets assembled
 in netfilter
Message-ID: <20201012125614.GA27601@salvia>
References: <20201012125347.13011-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201012125347.13011-1-geokohma@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please, Cc: netfilter-devel@vger.kernel.org for your netfilter
patches, so patchwork can catch it there too next time.

On Mon, Oct 12, 2020 at 02:53:47PM +0200, Georg Kohmann wrote:
> Fragmented ndisc packets assembled in netfilter not dropped as specified
> in RFC 6980, section 5. This behaviour breaks TAHI IPv6 Core Conformance
> Tests v6LC.2.1.22/23, V6LC.2.2.26/27 and V6LC.2.3.18.
> 
> Setting IPSKB_FRAGMENTED flag during reassembly.
> 
> References: commit b800c3b966bc ("ipv6: drop fragmented ndisc packets by
> default (RFC 6980)")
> Signed-off-by: Georg Kohmann <geokohma@cisco.com>
> ---
>  net/ipv6/netfilter/nf_conntrack_reasm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index fed9666..054d287 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -355,6 +355,7 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
>  	ipv6_hdr(skb)->payload_len = htons(payload_len);
>  	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
>  	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
> +	IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
>  
>  	/* Yes, and fold redundant checksum back. 8) */
>  	if (skb->ip_summed == CHECKSUM_COMPLETE)
> -- 
> 2.10.2
> 
