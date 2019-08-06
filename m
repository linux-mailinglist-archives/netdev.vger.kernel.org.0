Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 818928385F
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732158AbfHFSDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:03:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfHFSDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 14:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gFTMaprVsWCgr9Uw9bzdPgJHb9ARiC94eqZBiW4eSVc=; b=3hJwWYcV1ev3cSjzWQU0BfllIo
        c0F1FYsz9lNNEW84aPfPLdbDLkPq/t8q9EV7adJ5fRB1arSCpe3ygFS0Pa43H3Q0wWm+tXIG+DM8f
        pYaWeqKRb+aJCdmpS8UGIoSvzO7rQlqH4iftV6+sS2mYgzyOh2wv/L8YE4R0ztLbLqpU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hv3oI-0006f8-Md; Tue, 06 Aug 2019 20:03:46 +0200
Date:   Tue, 6 Aug 2019 20:03:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Message-ID: <20190806180346.GD17072@lunn.ch>
References: <20190806164036.GA2332@nanopsycho.orion>
 <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 11:38:32AM -0600, David Ahern wrote:
> On 8/6/19 10:40 AM, Jiri Pirko wrote:
> > Hi all.
> > 
> > I just discussed this with DavidA and I would like to bring this to
> > broader audience. David wants to limit kernel resources in network
> > namespaces, for example fibs, fib rules, etc.
> > 
> > He claims that devlink api is rich enough to program this limitations
> > as it already does for mlxsw hw resources for example. If we have this
> > api for hardware, why don't to reuse it for the kernel and it's
> > resources too?
> 
> The analogy is that a kernel is 'programmed' just like hardware, it has
> resources just like hardware (e.g., memory) and those resources are
> limited as well. So the resources consumed by fib entries, rules,
> nexthops, etc should be controllable.

I expect one question that will come up is why not control
groups. That is often used by the rest of the kernel for resource
control.

But cgroups are mostly about limiting resources for a collection of
processes. I don't think that is true for networking resources. The
resources we are talking about are orthogonal to processes. Or are
there any resources which should be linked to processes? eBPF
resources?

> > So the proposal is to have some new device, say "kernelnet", that would
> > implicitly create per-namespace devlink instance.

Maybe kernelns, to make it clear we are talking about namespace
resources.

Going back to cgroups concept. They are generally hierarchical. Do we
need any sort of hierarchy here? Are there some resources we want to
set a global limit on, and then a per namespace limit on top of that?
We would then need two names, and kernelnet sounds more like the
global level?

       Andrew
