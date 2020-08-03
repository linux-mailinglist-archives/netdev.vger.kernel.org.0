Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5491123A313
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHCLDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:03:30 -0400
Received: from correo.us.es ([193.147.175.20]:46678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgHCLD3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:03:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9377C9662D
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:03:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75837DA789
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:03:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 153D2E1506; Mon,  3 Aug 2020 13:03:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C280DA4D7;
        Mon,  3 Aug 2020 13:03:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 03 Aug 2020 13:03:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.249.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D82434265A32;
        Mon,  3 Aug 2020 13:03:20 +0200 (CEST)
Date:   Mon, 3 Aug 2020 13:03:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH net v2 1/2] netfilter: conntrack: Move
 nf_ct_offload_timeout to header file
Message-ID: <20200803103916.GB2903@salvia>
References: <20200803073305.702079-1-roid@mellanox.com>
 <20200803073305.702079-2-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803073305.702079-2-roid@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 10:33:04AM +0300, Roi Dayan wrote:
> To be used by callers from other modules.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> ---
>  include/net/netfilter/nf_conntrack.h | 12 ++++++++++++
>  net/netfilter/nf_conntrack_core.c    | 12 ------------
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 90690e37a56f..8481819ff632 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -279,6 +279,18 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
>  	       !nf_ct_is_dying(ct);
>  }
>  
> +#define	DAY	(86400 * HZ)
> +
> +/* Set an arbitrary timeout large enough not to ever expire, this save
> + * us a check for the IPS_OFFLOAD_BIT from the packet path via
> + * nf_ct_is_expired().
> + */
> +static inline void nf_ct_offload_timeout(struct nf_conn *ct)
> +{
> +	if (nf_ct_expires(ct) < DAY / 2)
> +		ct->timeout = nfct_time_stamp + DAY;
> +}
> +
>  struct kernel_param;
>  

For the record: I have renamed DAY to NF_CT_DAY to avoid a possible
symbol name clash. No need to resend, I applied this small change
before applying.
