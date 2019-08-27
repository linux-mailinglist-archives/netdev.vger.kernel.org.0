Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273159E6A2
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfH0LSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:18:36 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:37556 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbfH0LSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 07:18:36 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i2ZUf-0002W1-Ic; Tue, 27 Aug 2019 13:18:33 +0200
Date:   Tue, 27 Aug 2019 13:18:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, shmulik@metanetworks.com
Subject: Re: [REGRESSION] netfilter: conntrack: Unable to change conntrack
 accounting of a net namespace via 'nf_conntrack_acct' sysfs
Message-ID: <20190827111833.GZ20113@breakpoint.cc>
References: <20190827135754.7d460ef8@pixies>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827135754.7d460ef8@pixies>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shmulik Ladkani <shmulik.ladkani@gmail.com> wrote:
> -static int nf_conntrack_acct_init_sysctl(struct net *net)
> -{
> -	struct ctl_table *table;
> -
> -	table = kmemdup(acct_sysctl_table, sizeof(acct_sysctl_table),
> -			GFP_KERNEL);
> -	if (!table)
> -		goto out;
> -
> -	table[0].data = &net->ct.sysctl_acct;
> -
> 
> (where 'nf_conntrack_acct_init_sysctl()' was originally called by
> 'nf_conntrack_acct_pernet_init()').
> 
> However POST d912dec12428, the per-net netfilter sysctl table simply
> inherits from global 'nf_ct_sysctl_table[]', which has 
> 
> +		.data		= &init_net.ct.sysctl_acct,
> 
> effectivly making any 'net.netfilter.nf_conntrack_acct' sysctl change
> affect the 'init_net' and not relevant net namespace.
>
> Also, looks like "nf_conntrack_helper", "nf_conntrack_events",
> "nf_conntrack_timestamp" where also harmed in a similar way, see:
> 
>   d912dec12428 ("netfilter: conntrack: merge acct and helper sysctl table with main one")
>   cb2833ed0044 ("netfilter: conntrack: merge ecache and timestamp sysctl tables with main one")

Thanks for reporting this bug, I will submit a patch soon.
