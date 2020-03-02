Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6AE175AA4
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 13:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCBMhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 07:37:06 -0500
Received: from correo.us.es ([193.147.175.20]:40024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbgCBMhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 07:37:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 084051C43A5
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 13:36:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED0B4DA3C2
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 13:36:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DEE22DA3AB; Mon,  2 Mar 2020 13:36:51 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D78A8FC5E8;
        Mon,  2 Mar 2020 13:36:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Mar 2020 13:36:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9E2A44251480;
        Mon,  2 Mar 2020 13:36:49 +0100 (CET)
Date:   Mon, 2 Mar 2020 13:37:01 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Amol Grover <frextrite@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipt_CLUSTERIP: Pass lockdep expression to RCU
 lists
Message-ID: <20200302123701.qnjmnmyoxycaixs6@salvia>
References: <20200219101626.31943-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219101626.31943-1-frextrite@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 03:46:27PM +0530, Amol Grover wrote:
> cn->configs is traversed using list_for_each_entry_rcu
> outside an RCU read-side critical section but under the protection
> of cn->lock.
> 
> Hence, add corresponding lockdep expression to silence false-positive
> warnings, and harden RCU lists.
> 
> Signed-off-by: Amol Grover <frextrite@gmail.com>
> ---
>  net/ipv4/netfilter/ipt_CLUSTERIP.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> index 6bdb1ab8af61..df856ff835b7 100644
> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> @@ -139,7 +139,8 @@ __clusterip_config_find(struct net *net, __be32 clusterip)
>  	struct clusterip_config *c;
>  	struct clusterip_net *cn = clusterip_pernet(net);
>  
> -	list_for_each_entry_rcu(c, &cn->configs, list) {
> +	list_for_each_entry_rcu(c, &cn->configs, list,
> +				lockdep_is_held(&cn->lock)) {

bh is disabled before calling __clusterip_config_find(), then
rcu_read_lock_any_held() evaluates true.

Are you sure this really results in a WARN_ON splat?
