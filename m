Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A0B25F0C4
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgIFVda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 17:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgIFVd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 17:33:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 941CC2078E;
        Sun,  6 Sep 2020 21:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599428007;
        bh=cJ708UL/ADiomAUjAbKxBhMf6n+GHXQJnHzoImsfcg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ePw+NbIWcoBts+yC81GpKZVCQ3kfkzNGSW2jFkiFOG5h1RLBSVzvxtYR6e/qqyN7X
         0TXYmsScyLa/9eNnEe2ESPBe0wdn+vbgcKFyw8G1gtM/+LLGfeQqkWvHlE1zV7avsD
         Z3LQmvZQ27m4va7r31agv4+StmqRxpuFpTx2d3cg=
Date:   Sun, 6 Sep 2020 14:33:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net
Subject: Re: [PATCH net-next v3 05/15] net: bridge: mcast: factor out port
 group del
Message-ID: <20200906143326.0a09348b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <89eb1120-5776-081e-52ce-1ef92f41ecbe@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
        <20200905082410.2230253-6-nikolay@cumulusnetworks.com>
        <20200906135604.4d47b7a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <89eb1120-5776-081e-52ce-1ef92f41ecbe@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 00:29:10 +0300 Nikolay Aleksandrov wrote:
> >> @@ -1641,16 +1647,7 @@ br_multicast_leave_group(struct net_bridge *br,
> >>   			if (p->flags & MDB_PG_FLAGS_PERMANENT)
> >>   				break;
> >>   
> >> -			rcu_assign_pointer(*pp, p->next);
> >> -			hlist_del_init(&p->mglist);
> >> -			del_timer(&p->timer);
> >> -			kfree_rcu(p, rcu);
> >> -			br_mdb_notify(br->dev, port, group, RTM_DELMDB,
> >> -				      p->flags | MDB_PG_FLAGS_FAST_LEAVE);  
> > 
> > And here we'll loose MDB_PG_FLAGS_FAST_LEAVE potentially?
> 
> Good catch, we will lose the fast leave indeed.
> This is a 1 line change to set the flag before notifying. Would you prefer
> me to send a v4 or a follow up for it?

I think it's cleaner if you send a v4. But not rush, I was planning to
apply this tomorrow morning PST, anyway.
