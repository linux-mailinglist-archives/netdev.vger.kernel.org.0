Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6E7C3051
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfJAJhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:37:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60344 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfJAJhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:37:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iFEaa-0001OQ-Kz; Tue, 01 Oct 2019 11:37:00 +0200
Date:   Tue, 1 Oct 2019 11:37:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wh_bin@126.com
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter:get_next_corpse():No need to double check the
 *bucket
Message-ID: <20191001093700.GD14819@breakpoint.cc>
References: <20191001082441.7140-1-wh_bin@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001082441.7140-1-wh_bin@126.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wh_bin@126.com <wh_bin@126.com> wrote:
> From: Hongbin Wang <wh_bin@126.com>
> 
> The *bucket is in for loops,it has been checked.
> 
> Signed-off-by: Hongbin Wang <wh_bin@126.com>
> ---
>  net/netfilter/nf_conntrack_core.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 0c63120b2db2..8d48babe6561 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -2000,14 +2000,12 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
>  		lockp = &nf_conntrack_locks[*bucket % CONNTRACK_LOCKS];
>  		local_bh_disable();
>  		nf_conntrack_lock(lockp);
> -		if (*bucket < nf_conntrack_htable_size) {
> -			hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {
> -				if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
> -					continue;
> -				ct = nf_ct_tuplehash_to_ctrack(h);
> -				if (iter(ct, data))
> -					goto found;
> -			}
> +		hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {

I don't think this is correct.
unless we hold nf_conntrack_lock() nf_conntrack_hash[] could be
reallocated, no?
