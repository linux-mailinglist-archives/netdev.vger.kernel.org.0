Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91E01ED85C
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 00:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgFCWFH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jun 2020 18:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgFCWFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 18:05:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F635C08C5C0;
        Wed,  3 Jun 2020 15:05:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jgbVO-00018H-Jl; Thu, 04 Jun 2020 00:05:02 +0200
Date:   Thu, 4 Jun 2020 00:05:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Wilder <dwilder@us.ibm.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        wilder@us.ibm.com, mkubecek@suse.com
Subject: Re: [(RFC) PATCH ] NULL pointer dereference on rmmod iptable_mangle.
Message-ID: <20200603220502.GD28263@breakpoint.cc>
References: <20200603212516.22414-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200603212516.22414-1-dwilder@us.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Wilder <dwilder@us.ibm.com> wrote:
> This crash happened on a ppc64le system running ltp network tests when ltp script ran "rmmod iptable_mangle".
> 
> [213425.602369] BUG: Kernel NULL pointer dereference at 0x00000010
> [213425.602388] Faulting instruction address: 0xc008000000550bdc
[..]

> In the crash we find in iptable_mangle_hook() that state->net->ipv4.iptable_mangle=NULL causing a NULL pointer dereference. net->ipv4.iptable_mangle is set to NULL in iptable_mangle_net_exit() and called when ip_mangle modules is unloaded. A rmmod task was found in the crash dump.  A 2nd crash showed the same problem when running "rmmod iptable_filter" (net->ipv4.iptable_filter=NULL).
> 
> Once a hook is registered packets will picked up a pointer from: net->ipv4.iptable_$table. The patch adds a call to synchronize_net() in ipt_unregister_table() to insure no packets are in flight that have picked up the pointer before completing the un-register.
> 
> This change has has prevented the problem in our testing.  However, we have concerns with this change as it would mean that on netns cleanup, we would need one synchronize_net() call for every table in use. Also, on module unload, there would be one synchronize_net() for every existing netns.

Yes, I agree with the analysis.

> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  net/ipv4/netfilter/ip_tables.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index c2670ea..97c4121 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -1800,8 +1800,10 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
>  void ipt_unregister_table(struct net *net, struct xt_table *table,
>  			  const struct nf_hook_ops *ops)
>  {
> -	if (ops)
> +	if (ops) {
>  		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
> +		synchronize_net();
> +	}

I'd wager ebtables, arptables and ip6tables have the same bug.

The extra synchronize_net() isn't ideal.  We could probably do it this
way and then improve in a second patch.

One way to fix this without a new synchronize_net() is to switch all
iptable_foo.c to use ".pre_exit" hook as well.

pre_exit would unregister the underlying hook and .exit would to the
table freeing.

Since the netns core already does an unconditional synchronize_rcu after
the pre_exit hooks this would avoid the problem as well.
