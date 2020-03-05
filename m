Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49E017A4EC
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCEMKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:10:17 -0500
Received: from correo.us.es ([193.147.175.20]:56060 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgCEMKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 07:10:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 61A0D18CE85
        for <netdev@vger.kernel.org>; Thu,  5 Mar 2020 13:09:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51145E1539
        for <netdev@vger.kernel.org>; Thu,  5 Mar 2020 13:09:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4463FDA3AF; Thu,  5 Mar 2020 13:09:59 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50EF6DA3A5;
        Thu,  5 Mar 2020 13:09:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Mar 2020 13:09:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3458F42EF4E3;
        Thu,  5 Mar 2020 13:09:57 +0100 (CET)
Date:   Thu, 5 Mar 2020 13:10:12 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org,
        syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: free flowtable hooks on hook
 register error
Message-ID: <20200305120931.poeox6r3rapcbujb@salvia>
References: <20200302205850.29365-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302205850.29365-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 09:58:50PM +0100, Florian Westphal wrote:
> If hook registration fails, the hooks allocated via nft_netdev_hook_alloc
> need to be freed.
> 
> We can't change the goto label to 'goto 5' -- while it does fix the memleak
> it does cause a warning splat from the netfilter core (the hooks were not
> registered).

It seems test/shell crashes after this, looking. It works after
reverting.

> Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
> Reported-by: syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_tables_api.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d1318bdf49ca..bb064aa4154b 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6300,8 +6300,13 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
>  		goto err4;
>  
>  	err = nft_register_flowtable_net_hooks(ctx.net, table, flowtable);
> -	if (err < 0)
> +	if (err < 0) {
> +		list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
> +			list_del_rcu(&hook->list);
> +			kfree_rcu(hook, rcu);
> +		}
>  		goto err4;
> +	}
>  
>  	err = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
>  	if (err < 0)
> -- 
> 2.24.1
> 
