Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7371CCE7F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 00:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgEJWOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 18:14:39 -0400
Received: from correo.us.es ([193.147.175.20]:38842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729028AbgEJWOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 18:14:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6BEAC117734
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 00:14:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E374115412
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 00:14:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53BAC21FE3; Mon, 11 May 2020 00:14:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A4E3A6A0;
        Mon, 11 May 2020 00:14:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 May 2020 00:14:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3DA0842EF4E0;
        Mon, 11 May 2020 00:14:35 +0200 (CEST)
Date:   Mon, 11 May 2020 00:14:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: flowtable: Add pending bit for offload
 work
Message-ID: <20200510221434.GA11226@salvia>
References: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, May 06, 2020 at 02:24:39PM +0300, Paul Blakey wrote:
> Gc step can queue offloaded flow del work or stats work.
> Those work items can race each other and a flow could be freed
> before the stats work is executed and querying it.
> To avoid that, add a pending bit that if a work exists for a flow
> don't queue another work for it.
> This will also avoid adding multiple stats works in case stats work
> didn't complete but gc step started again.

This is happening since the mutex has been removed, right?

Another question below.

> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> ---
>  include/net/netfilter/nf_flow_table.h | 1 +
>  net/netfilter/nf_flow_table_offload.c | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 6bf6965..c54a7f7 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -127,6 +127,7 @@ enum nf_flow_flags {
>  	NF_FLOW_HW_DYING,
>  	NF_FLOW_HW_DEAD,
>  	NF_FLOW_HW_REFRESH,
> +	NF_FLOW_HW_PENDING,
>  };
>  
>  enum flow_offload_type {
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index b9d5ecc..731d738 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -817,6 +817,7 @@ static void flow_offload_work_handler(struct work_struct *work)
>  			WARN_ON_ONCE(1);
>  	}
>  
> +	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
>  	kfree(offload);
>  }
>  
> @@ -831,9 +832,14 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
>  {
>  	struct flow_offload_work *offload;
>  
> +	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
> +		return NULL;

In case of stats, it's fine to lose work.

But how does this work for the deletion case? Does this falls back to
the timeout deletion?

Thanks.
