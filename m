Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6A130950C
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 13:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhA3MB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 07:01:59 -0500
Received: from correo.us.es ([193.147.175.20]:50110 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhA3MB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 07:01:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3A6DDA7F1
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 13:01:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E30ECDA792
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 13:01:16 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D8A9BDA73F; Sat, 30 Jan 2021 13:01:16 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B979DA78C;
        Sat, 30 Jan 2021 13:01:14 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 30 Jan 2021 13:01:14 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7BDDC426CC84;
        Sat, 30 Jan 2021 13:01:14 +0100 (CET)
Date:   Sat, 30 Jan 2021 13:01:14 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
Message-ID: <20210130120114.GA7846@salvia>
References: <20210128074052.777999-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210128074052.777999-1-roid@nvidia.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roi,

On Thu, Jan 28, 2021 at 09:40:52AM +0200, Roi Dayan wrote:
> Currently, offloaded flows might be deleted when executing conntrack -L
> or cat /proc/net/nf_conntrack while rules being offloaded.
> Ct timeout is not maintained for offloaded flows as aging
> of offloaded flows are managed by the flow table offload infrastructure.
> 
> Don't do garbage collection for offloaded flows when dumping the
> entries.
> 
> Fixes: 90964016e5d3 ("netfilter: nf_conntrack: add IPS_OFFLOAD status bit")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
> ---
>  include/net/netfilter/nf_conntrack.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 439379ca9ffa..87c85109946a 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -276,7 +276,7 @@ static inline bool nf_ct_is_expired(const struct nf_conn *ct)
>  static inline bool nf_ct_should_gc(const struct nf_conn *ct)
>  {
>  	return nf_ct_is_expired(ct) && nf_ct_is_confirmed(ct) &&
> -	       !nf_ct_is_dying(ct);
> +	       !nf_ct_is_dying(ct) && !test_bit(IPS_OFFLOAD_BIT, &ct->status);

The gc_worker() calls nf_ct_offload_timeout() if the flow if
offloaded, so it extends the timeout to skip the garbage collection.

Could you update ctnetlink_dump_table() and ct_seq_show() to extend
the timeout if the flow is offloaded?

Thanks.
