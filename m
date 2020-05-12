Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEF91CFAC5
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgELQce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 12:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgELQce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 12:32:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12432206CC;
        Tue, 12 May 2020 16:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589301153;
        bh=iai6OsTrstOImYGBblatIa+HRYGTeEYXR6O6Jhuge0Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gyfUMILZKf/6nFVyJhQlgWnDBIITwatliCL6ozMK0oYYDh9/NAxgxc1CXknpwXadj
         yyTgtV1zyYYhV6oo9ENRsJf+k/FGgpJvBVXQRyW1r8HEY4I+/AKreK2X+lh3ZWz0M1
         LJzi7cV8FRpSdqnDdByESWwxf/OWll2UtOoH1i2U=
Date:   Tue, 12 May 2020 09:32:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     sfr@canb.auug.org.au, Amol Grover <frextrite@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net 2/2 RESEND] ipmr: Add lockdep expression to
 ipmr_for_each_table macro
Message-ID: <20200512093231.7ce29f30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200512051705.GB9585@madhuparna-HP-Notebook>
References: <20200509072243.3141-1-frextrite@gmail.com>
        <20200509072243.3141-2-frextrite@gmail.com>
        <20200509141938.028fa959@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200512051705.GB9585@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 10:47:05 +0530 Madhuparna Bhowmik wrote:
> > >  #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
> > > -#define ipmr_for_each_table(mrt, net) \
> > > -	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
> > > -				lockdep_rtnl_is_held())
> > > +#define ipmr_for_each_table(mrt, net)					\
> > > +	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
> > > +				lockdep_rtnl_is_held() ||		\
> > > +				lockdep_is_held(&pernet_ops_rwsem))  
> > 
> > This is a strange condition, IMHO. How can we be fine with either
> > lock.. This is supposed to be the writer side lock, one can't have 
> > two writer side locks..
> > 
> > I think what is happening is this:
> > 
> > ipmr_net_init() -> ipmr_rules_init() -> ipmr_new_table()
> > 
> > ipmr_new_table() returns an existing table if there is one, but
> > obviously none can exist at init.  So a better fix would be:
> > 
> > #define ipmr_for_each_table(mrt, net)					\
> > 	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
> > 				lockdep_rtnl_is_held() ||		\
> > 				list_empty(&net->ipv4.mr_tables))
> >  
> (adding Stephen)
> 
> Hi Jakub,
> 
> Thank you for your suggestion about this patch.
> Here is a stack trace for ipmr.c:
> 
> [...]

Thanks!

> > Thoughts?  
> 
> Do you think a similar fix (the one you suggested) is also applicable
> in the ip6mr case.

Yes, looking at the code it seems ip6mr has the exact same flow for
netns init.
