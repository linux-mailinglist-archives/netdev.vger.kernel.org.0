Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B61C2458
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfI3Pds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 11:33:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54672 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbfI3Pds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 11:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z/diQhntlKZFD7bTXfg2ZYwSY19TwI9YoMypJr/2T/0=; b=5ru4q1CP2nlWHWs6sW3clr/nd8
        ehjNCz3HW1pbcD3f7V0J4SHrColcmseMIDFdCD8sLxHcDf3jx5ZwidKj8BuwcfeDppEn9+tKO1tiT
        scW61F8BMgbvMVtB5YXKUXXkmGSh3IcDsZ4NoSUEzDqZtuQj0l0fb7IMYTIpSegHUdAQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iExgF-0004PK-2a; Mon, 30 Sep 2019 17:33:43 +0200
Date:   Mon, 30 Sep 2019 17:33:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        pabeni@redhat.com, edumazet@google.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 2/3] net: introduce per-netns netdevice notifiers
Message-ID: <20190930153343.GE14745@lunn.ch>
References: <20190930081511.26915-1-jiri@resnulli.us>
 <20190930081511.26915-3-jiri@resnulli.us>
 <20190930133824.GA14745@lunn.ch>
 <20190930142349.GE2211@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930142349.GE2211@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 04:23:49PM +0200, Jiri Pirko wrote:
> Mon, Sep 30, 2019 at 03:38:24PM CEST, andrew@lunn.ch wrote:
> >>  static int call_netdevice_notifiers_info(unsigned long val,
> >>  					 struct netdev_notifier_info *info)
> >>  {
> >> +	struct net *net = dev_net(info->dev);
> >> +	int ret;
> >> +
> >>  	ASSERT_RTNL();
> >> +
> >> +	/* Run per-netns notifier block chain first, then run the global one.
> >> +	 * Hopefully, one day, the global one is going to be removed after
> >> +	 * all notifier block registrators get converted to be per-netns.
> >> +	 */
> >
> >Hi Jiri
> >
> >Is that really going to happen? register_netdevice_notifier() is used
> >in 130 files. Do you plan to spend the time to make it happen?
> 
> That's why I prepended the sentency with "Hopefully, one day"...
> 
> 
> >
> >> +	ret = raw_notifier_call_chain(&net->netdev_chain, val, info);
> >> +	if (ret & NOTIFY_STOP_MASK)
> >> +		return ret;
> >>  	return raw_notifier_call_chain(&netdev_chain, val, info);
> >>  }
> >
> >Humm. I wonder about NOTIFY_STOP_MASK here. These are two separate
> >chains. Should one chain be able to stop the other chain? Are there
> 
> Well if the failing item would be in the second chain, at the beginning
> of it, it would be stopped too. Does not matter where the stop happens,
> the point is that the whole processing stops. That is why I added the
> check here.
> 
> 
> >other examples where NOTIFY_STOP_MASK crosses a chain boundary?
> 
> Not aware of it, no. Could you please describe what is wrong?

You are expanding the meaning of NOTIFY_STOP_MASK. It now can stop
some other chain. If this was one chain with a filter, i would not be
asking. But this is two different chains, and one chain can stop
another? At minimum, i think this needs to be reviewed by the core
kernel people.

But i'm also wondering if you are solving the problem at the wrong
level. Are there other notifier chains which would benefit from
respecting name space boundaries? Would a better solution be to extend
struct notifier_block with some sort of filter?

Do you have some performance numbers? Where are you getting your
performance gains from? By the fact you are doing NOTIFY_STOP_MASK
earlier, so preventing a long chain being walked? I notice
notifer_block has a priority field. Did you try using that to put your
notified earlier on the chain?

	 Andrew
