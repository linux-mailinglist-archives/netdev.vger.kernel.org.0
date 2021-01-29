Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7657530839B
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhA2CPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhA2CPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:15:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D83A64DF5;
        Fri, 29 Jan 2021 02:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886459;
        bh=yWDhkDgcH4a6xConyrZfFw1eIryxkZPci/0p0dsV5MY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TjIJcrJ5pLL4CgpAiea8HnXZ/DfivFFd7f7F+sQVTRGNd4WBZrGOfcvuw4Djrvx5U
         H65aVQucG11X5QYTJyY7WeoF0zRGYZEoeMco6NWSOsmJvxWXYcqLWlc5E3Viizk67u
         63dm4+tQzjm0nQqa8oiufMoNhgo3j45pfPeczKgplaz8R2bC/sjBCKGToiYXwnWbYB
         tYIxOPmkl+XzjkMJR1c5/QYnBmLX/YYcBtWF9KmQBM4rtxrG1JeQA3dPv2eBBi8rJT
         sPjP/z8NcRKeV1CMubX49NRuM/pEWRu2nEwLlTB9ilP8k720HmqgW/+5Yl8xgM4ntL
         0hu2mhIGY7zKA==
Date:   Thu, 28 Jan 2021 18:14:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v7 net-next 08/11] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210128181418.0c7f9927@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128200750.gnmgxm4ojudqbtli@skbuf>
References: <20210125220333.1004365-1-olteanv@gmail.com>
        <20210125220333.1004365-9-olteanv@gmail.com>
        <20210127173044.65de6aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210128200750.gnmgxm4ojudqbtli@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 22:07:50 +0200 Vladimir Oltean wrote:
> On Wed, Jan 27, 2021 at 05:30:44PM -0800, Jakub Kicinski wrote:
> > > +const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
> > > +{
> > > +	const struct dsa_device_ops *ops = NULL;
> > > +	struct dsa_tag_driver *dsa_tag_driver;
> > > +
> > > +	mutex_lock(&dsa_tag_drivers_lock);
> > > +	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
> > > +		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
> > > +
> > > +		if (!sysfs_streq(buf, tmp->name))
> > > +			continue;
> > > +
> > > +		ops = tmp;
> > > +		break;
> > > +	}
> > > +	mutex_unlock(&dsa_tag_drivers_lock);  
> >
> > What's protecting from the tag driver unloading at this very moment?  
> 
> The user's desire to not crash the kernel, and do something productive
> instead? Anyway, I've fixed this in my tree and I will repost soon.

:)

> > > +	info.tag_ops = old_tag_ops;
> > > +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DEL, &info);
> > > +	if (err)
> > > +		goto out_unlock;
> > > +
> > > +	info.tag_ops = tag_ops;
> > > +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_SET, &info);  
> >
> > Not sure I should bother you about this or not, but it looks like
> > Ocelot does allocations on SET, so there is a chance of not being
> > able to return to the previous config, leaving things broken.
> >
> > There's quite a few examples where we use REPLACE instead of set,
> > so that a careful driver can prep its resources before it kills
> > the previous config. Although that's not perfect either because
> > we'd rather have as much of that logic in the core as possible.
> >
> > What are your thoughts?  
> 
> On one hand, my immediate thoughts are:
> (a) out of the 2 ocelot taggers, only tag_8021q can fail, the NPI tagger
>     always returns 0. So either the .set_tag_protocol will always
>     succeed, or we'll always be able to restore the initial tag
>     protocol.
> (b) changing the tag protocol is done with network down, so if you can't
>     allocate some memory for some TCAM rules, you're probably in the
>     wrong business anyway once the ports go back up and you'll start
>     receiving network traffic.
> 
> But either way, I could create a single .replace_tag_protocol callback
> instead of the current .set_tag_protocol and .del_tag_protocol, and have
> the felix driver still call felix_set_tag_protocol privately from
> .setup(), and .felix_del_tag_protocol from .teardown(). That's a
> relatively non-invasive change which would make zero practical
> difference to my use case due to point (a) above.
> 
> However I will not pretend that having an "atomic" .replace_tag_protocol
> is going to ensure a consistent state of the tagger, because it won't.
> In the case where you have a DSA switch tree with 7 switches, and
> .replace_tag_protocol fails for the 5th, what do you do? You create a
> transactional model, with a prepare and commit phase, right? But I am
> doing some memory allocations from callbacks of external API
> (struct dsa_8021q_ops felix_tag_8021q_ops), so unless I have a crystal
> ball to guess what parameters will tag_8021q call me with (so I could
> preallocate), my options are:
> - propagate the prepare and commit phase to tag_8021q, which I'm not
>   going to.
> - do all of my setup in the prepare phase, the one that can return
>   errors, and privately restore my tagger e.g. from tag_8021q mode to
>   NPI mode if any allocation failed. Aka just do a facade thing with the
>   whole prepare/commit model.
> And having a prepare/commit model means that you do memory allocation in
> prepare so that you can use it during commit, which means that there
> must be some structure which holds the transactional storage of the
> driver. All is well except that the preparation phase of the 5th switch
> out of 7 may still fail, so you should also have an unprepare method
> that performs the resource deallocation for the first four. Normally the
> unprepare should not fail, but if I implement it the only I said I can
> (i.e. I do all my configuration in the prepare phase, and return in
> commit), then for all practical purposes, the unprepare phase will be a
> .replace_tag_protocol in the opposite direction. Aka an operation that
> can still fail.
> 
> If you have a better idea of how I can make dsa_tree_change_tag_proto
> guarantee that all switches in the tree end up with the same tagger,
> while not sabotaging the only driver implementing that API, do let me
> know.

I'm just trying to nudge you towards perfection. Working with servers
"at scale" I really appreciate the ability to reconfigure something on
very many machines without worrying that ~1% of them will be under
memory pressure and the failure will cause it to fall off the network.

But I take your point that it may be an overkill here.

A less ambitious plan would be to retry the SET when bringing up master
if the tree was left in a funky state?

Not knowing much about DSA internals I'll leave the decision to you and
other DSA maintainers.
