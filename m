Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162041D0164
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgELV7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbgELV7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 17:59:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2180206B7;
        Tue, 12 May 2020 21:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589320760;
        bh=umeyPfzMnWUsI5DYYCbU0pSKl5SS197xscOjTElhVOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Orwq489TX5Fd2s66luzYbKVVgduIHMk5HY1Z5C2/g255CTs0S+aNNxq/hJsS/Y41o
         W8r0qfRHsg71g6f6Rxqm6CQwuwh6IBrjpO2gNOLIXo4fj0upk24RpESOk6UItCHhiL
         YVKL1XGaqCNX3GK3lmfbBhf5Q01Dnb+hT43e1oCQ=
Date:   Tue, 12 May 2020 14:59:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Amol Grover <frextrite@gmail.com>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        sfr@canb.auug.org.au, "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net 2/2 RESEND] ipmr: Add lockdep expression to
 ipmr_for_each_table macro
Message-ID: <20200512145917.729db7bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200512171710.GA3200@workstation-portable>
References: <20200509072243.3141-1-frextrite@gmail.com>
        <20200509072243.3141-2-frextrite@gmail.com>
        <20200509141938.028fa959@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200512051705.GB9585@madhuparna-HP-Notebook>
        <20200512171710.GA3200@workstation-portable>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 22:47:10 +0530 Amol Grover wrote:
> > > This is a strange condition, IMHO. How can we be fine with either
> > > lock.. This is supposed to be the writer side lock, one can't have 
> > > two writer side locks..
> > > 
> > > I think what is happening is this:
> > > 
> > > ipmr_net_init() -> ipmr_rules_init() -> ipmr_new_table()
> > > 
> > > ipmr_new_table() returns an existing table if there is one, but
> > > obviously none can exist at init.  So a better fix would be:
> > > 
> > > #define ipmr_for_each_table(mrt, net)					\
> > > 	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
> > > 				lockdep_rtnl_is_held() ||		\
> > > 				list_empty(&net->ipv4.mr_tables))
> > >  
> 
> Jakub, I agree, this condition looks better (and correct) than the one I
> proposed. I'll do the changes as necessary. Also, do you want me to add
> the full trace to the git commit body as well? I omitted it on purpose
> to not make it messy.

In this case we can leave it at the depth of IPMR code + the caller, so:

[    1.534758]  ? ipmr_get_table+0x3c/0x70
[    1.535430]  ? ipmr_new_table+0x1c/0x60
[    1.536173]  ? ipmr_net_init+0x7b/0x170
[    1.536923]  ? register_pernet_subsys+0xd/0x30

This makes it clear that the problem happens at net namespace init.

Thanks!
