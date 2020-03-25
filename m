Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85894192E8B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgCYQp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbgCYQp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 12:45:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D66F2073E;
        Wed, 25 Mar 2020 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585154726;
        bh=7daJGqtkKBH0ISX7tNyfJmNro1hmvwQJ8kMdopLHVYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E3B2Scog1jkFyPx8lpIe/6BcbVQjRvzG1DF9DsJuKL07+/YLb9MR5afAdsaGUaYsX
         HTx+lDGcHbfdb+8sV5fLOzgn0P5bmK6FrS8WbMma34ApCE331eSC+tg6AI1KsUIrqh
         cC8jC21x7E2q+uPkJRE9SXODRDMyuzMBmhuU0IGg=
Date:   Wed, 25 Mar 2020 09:45:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 05/15] devlink: Allow setting of packet trap
 group parameters
Message-ID: <20200325094524.5c84a510@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200325103743.GC1332836@splinter>
References: <20200324193250.1322038-1-idosch@idosch.org>
        <20200324193250.1322038-6-idosch@idosch.org>
        <20200324205314.2d2ba2fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200325103743.GC1332836@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 12:37:43 +0200 Ido Schimmel wrote:
> > > +		if (policer_id && !policer_item) {
> > > +			NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");  
> > 
> > nit: is KBUILD_MODNAME still set if devlink can only be built-in now?  
> 
> It seems fine:
> 
> NL_SET_ERR_MSG_MOD:
> 
> # devlink trap policer set pci/0000:01:00.0 policer 1337
> Error: devlink: Device did not register this trap policer.
> devlink answers: No such file or directory
> 
> NL_SET_ERR_MSG:
> 
> # devlink trap policer set pci/0000:01:00.0 policer 1337
> Error: Device did not register this trap policer.
> devlink answers: No such file or directory

GTK!

> > > +			return -ENOENT;
> > > +		}
> > > +	}
> > > +	policer = policer_item ? policer_item->policer : NULL;
> > > +
> > > +	err = devlink->ops->trap_group_set(devlink, group_item->group, policer);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	group_item->policer_item = policer_item;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
> > >  					      struct genl_info *info)
> > >  {
> > > @@ -6060,6 +6099,10 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
> > >  	if (err)
> > >  		return err;
> > >  
> > > +	err = devlink_trap_group_set(devlink, group_item, info);
> > > +	if (err)
> > > +		return err;  
> > 
> > Should this unwind the action changes? Are the changes supposed to be
> > atomic? :S   
> 
> I used do_setlink() as reference and it seems that it does not unwind
> the changes. I can add extack message in case we did set action and
> devlink_trap_group_set() failed.

Okay.

> > Also could it potentially be a problem if trap is being enabled and
> > policer applied - if we enable first the CPU may get overloaded and it
> > may be hard to apply the policer? Making sure the ordering is right
> > requires some careful checking, so IDK if its worth it..  
> 
> I'm not sure it's really an issue, but I can flip the order just to be
> on the safe side.

No, no, flipping doesn't do anything. It will just move the problem
from enable to disable. You can leave as is if it's not expected to 
be an issue.

> >   
> > >  	return 0;
> > >  }
> > >    
> >   

