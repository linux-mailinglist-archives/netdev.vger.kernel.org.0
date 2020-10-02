Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C902816A8
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbgJBPbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388074AbgJBPbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:31:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59233206A2;
        Fri,  2 Oct 2020 15:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601652705;
        bh=knsczBAZ3BmAcI4zPdt3xpMdnm+C+/lwCbD1eJ+35hU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BHS48EUlDw0YUOt4gCxoUe5ooTRdy22hgxjP7VQQJnXqoe3MCQuPRElPnTuGP4uhD
         BE6oIRh18JN9mCwTu4duamCXrzOgnno09vZs+8mKJGB2Y/wkDhAwOKh5hLTJSKjCRL
         /Mkj1wsQRa9S5q/0zMhwMAA0+jKgf7//3WpuAG/A=
Date:   Fri, 2 Oct 2020 08:31:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/5] netlink: simplify netlink_policy_dump_start()
 prototype
Message-ID: <20201002083144.39af89e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201002110205.35dfe0fb3299.If2afc69c480c29c3dfc7c373c9a8b45678939746@changeid>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
        <20201002110205.35dfe0fb3299.If2afc69c480c29c3dfc7c373c9a8b45678939746@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Oct 2020 11:09:40 +0200 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since moving the call to this to a dump start() handler we no
> longer need this to deal with being called after having been
> called already. Since that is the preferred way of doing things
> anyway, remove the code necessary for that and simply return
> the pointer (or an ERR_PTR()).
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

> -	return netlink_policy_dump_start(op.policy, op.maxattr, &ctx->state);
> +	ctx->state = netlink_policy_dump_start(op.policy, op.maxattr);
> +	if (IS_ERR(ctx->state))
> +		return PTR_ERR(ctx->state);
> +	return 0;

PTR_ERR_OR_ZERO()?
