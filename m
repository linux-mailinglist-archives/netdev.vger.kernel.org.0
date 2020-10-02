Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8632F2816EB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbgJBPmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387777AbgJBPmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:42:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2464E2074B;
        Fri,  2 Oct 2020 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601653374;
        bh=zlkla6EnJXIi15Um2j+RZZTMQ9PmueD5XO+tx9Z3kYs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1bGTLkDYEzyFPNNvWbgDVnDHlaHleB8+VNlaQ3tcMWa+uHDzP9aLI3lcEJYe4WZHW
         /TiEx1IgG1He/WYLycjrnF2bpI27Q3Xhxs/Mqo7M4a+0I4VH4rP79MTIA4DHwTumFe
         inozgaWae2PgJQllKdpR8+GNVJGRwDACW8XyyUG8=
Date:   Fri, 2 Oct 2020 08:42:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4/5] genetlink: factor skb preparation out of
 ctrl_dumppolicy()
Message-ID: <20201002084252.5f18a244@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201002110205.ce65a163aebd.I0e59ae414404a92143c6ed8b0b0caf7e0e0d11a0@changeid>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
        <20201002110205.ce65a163aebd.I0e59ae414404a92143c6ed8b0b0caf7e0e0d11a0@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Oct 2020 11:09:43 +0200 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> We'll need this later for the per-op policy index dump.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

>  	while (netlink_policy_dump_loop(ctx->state)) {
> -		void *hdr;
> +		void *hdr = ctrl_dumppolicy_prep(skb, cb);
>  		struct nlattr *nest;
>  
> -		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
> -				  cb->nlh->nlmsg_seq, &genl_ctrl,
> -				  NLM_F_MULTI, CTRL_CMD_GETPOLICY);
>  		if (!hdr)
>  			goto nla_put_failure;

bike shedding, but I find it less pretty when functions which require
error checking are called as variable init (if it's not the only
variable declared).
