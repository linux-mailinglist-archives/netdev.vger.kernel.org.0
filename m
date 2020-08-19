Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D7C24A691
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHSTKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSTKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 15:10:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E538207DA;
        Wed, 19 Aug 2020 19:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597864208;
        bh=i3ZIZ7dQwZRZWx3oMKEHw8yuIYL4brpvIXtewBIvz68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vGEeQxDC0b4J5qbLGoZrO03G7H3mWliX5nX5SU+o3gN8nr1Zd7LqPJOLuLcsCxtyO
         bHllH/nCboxiV0dnGTHXznIn07YdQXFwJSYDNX3JlbhqdInJTo+VRIXsWfmrSqacao
         MhxzBNCNtu0mpOY1pS3MyNOSH60qBy+bCQ/l5oWY=
Date:   Wed, 19 Aug 2020 12:10:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] netlink: fix state reallocation in policy export
Message-ID: <20200819121006.7f6615e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819122255.6b32aa54d205.I316de8a67c79a393ae1826a1b2dcc08f31b1856e@changeid>
References: <20200819122255.6b32aa54d205.I316de8a67c79a393ae1826a1b2dcc08f31b1856e@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 12:22:55 +0200 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Evidently, when I did this previously, we didn't have more than
> 10 policies and didn't run into the reallocation path, because
> it's missing a memset() for the unused policies. Fix that.
> 
> Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/netlink/policy.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netlink/policy.c b/net/netlink/policy.c
> index f6491853c797..3f3b421fd70c 100644
> --- a/net/netlink/policy.c
> +++ b/net/netlink/policy.c
> @@ -51,6 +51,9 @@ static int add_policy(struct nl_policy_dump **statep,
>  	if (!state)
>  		return -ENOMEM;
>  
> +	memset(&state->policies[state->n_alloc], 0,
> +	       sizeof(state->policies[0]) * (n_alloc - state->n_alloc));


[flex_]array_size() ? To avoid the inevitable follow up from a bot..
