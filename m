Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813EB310AC2
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 12:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhBEL6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 06:58:10 -0500
Received: from mail.thelounge.net ([91.118.73.15]:41173 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbhBELzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 06:55:42 -0500
X-Greylist: delayed 1280 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2021 06:55:41 EST
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4DXCwR40RGzXRV;
        Fri,  5 Feb 2021 12:33:27 +0100 (CET)
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
References: <20210205001727.2125-1-pablo@netfilter.org>
 <20210205001727.2125-2-pablo@netfilter.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update
 deleted entry
Message-ID: <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net>
Date:   Fri, 5 Feb 2021 12:33:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205001727.2125-2-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


thank you for adressing that issue - maybe GRO can be enabled and wasn't 
involved at all

"Reap only entries which won't be updated" sounds for me like the could 
be some optimization: i mean when you first update and then check what 
can be reaped the recently updated entry would not match to begin with

Am 05.02.21 um 01:17 schrieb Pablo Neira Ayuso:
> From: Jozsef Kadlecsik <kadlec@mail.kfki.hu>
> 
> When both --reap and --update flag are specified, there's a code
> path at which the entry to be updated is reaped beforehand,
> which then leads to kernel crash. Reap only entries which won't be
> updated.
> 
> Fixes kernel bugzilla #207773.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=207773
> Reported-by: Reindl Harald <h.reindl@thelounge.net>
> Fixes: 0079c5aee348 ("netfilter: xt_recent: add an entry reaper")
> Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   net/netfilter/xt_recent.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> index 606411869698..0446307516cd 100644
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -152,7 +152,8 @@ static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
>   /*
>    * Drop entries with timestamps older then 'time'.
>    */
> -static void recent_entry_reap(struct recent_table *t, unsigned long time)
> +static void recent_entry_reap(struct recent_table *t, unsigned long time,
> +			      struct recent_entry *working, bool update)
>   {
>   	struct recent_entry *e;
>   
> @@ -161,6 +162,12 @@ static void recent_entry_reap(struct recent_table *t, unsigned long time)
>   	 */
>   	e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
>   
> +	/*
> +	 * Do not reap the entry which are going to be updated.
> +	 */
> +	if (e == working && update)
> +		return;
> +
>   	/*
>   	 * The last time stamp is the most recent.
>   	 */
> @@ -303,7 +310,8 @@ recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
>   
>   		/* info->seconds must be non-zero */
>   		if (info->check_set & XT_RECENT_REAP)
> -			recent_entry_reap(t, time);
> +			recent_entry_reap(t, time, e,
> +				info->check_set & XT_RECENT_UPDATE && ret);
>   	}
>   
>   	if (info->check_set & XT_RECENT_SET ||
