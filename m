Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D167D2F24E6
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391693AbhALAZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390836AbhAKWzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 17:55:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 666B722C7E;
        Mon, 11 Jan 2021 22:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610405692;
        bh=nKAh5cvaRwnCxtiMJvjNsnoKNha835ZMi43ut6R+Sls=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VsM8MW1kmBpFkWzjz9U8mj1xqLGdO4/80nKbfj7LOC9H3scMwVMcbxakI2smHimwN
         FjYZu2anS8rohNC7GoziLVrEiIzZGTZ5MRVHyoPqrD79r0G9Z0ns298Sqf/xoJnsoK
         5NHiBfgBfdWZHKIz6bmGtCvQvFIQ6hkJMbDxv/0H+0lyhDYMqkgbxSiKe8OXfwnGAm
         D6Mm6XYzGA5MvWjLnhLbvpSHRDszdoo5O9UwaFFPqio9otlheB6BZuRrWMDii16T8+
         U2K5Xh9M8tJo/Pnm7BaJAeQk4uZhy1R7N6NWYi0+QqcM2ZeO6TcEeJ/ZF7WDmIv8to
         nNZhw0sm+ObYQ==
Message-ID: <b517b9a54761a0ee650d6d64712844606cf8a631.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 11/15] net: catch errors from dev_get_stats
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Mon, 11 Jan 2021 14:54:50 -0800
In-Reply-To: <20210109172624.2028156-12-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-12-olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> dev_get_stats can now return error codes. Convert all remaining call
> sites to look at that error code and stop processing.
> 
> The effects of simulating a kernel error (returning -ENOMEM) upon
> existing programs or kernel interfaces:
> 
> - ifconfig and "cat /proc/net/dev" print up until the interface that
>   failed, and there they return:
> cat: read error: Cannot allocate memory
> 
> - ifstat and "ip -s -s link show":
> RTNETLINK answers: Cannot allocate memory
> Dump terminated
> 
> Some call sites are coming from a context that returns void (ethtool
> stats, workqueue context). So since we can't report to the upper
> layer,
> do the next best thing: print an error to the console.
> 

another concern, one buggy netdev driver in a system will cause
unnecessary global failures when reading stats via netlink/procfs for
all the netdev in a netns, when other drivers will be happy to report.

can't we just show a message in that driver's stats line about the
occurred err ? and show the normal stats line of all others ?

> This patch wraps up the conversion of existing dev_get_stats callers,
> so
> we can add the __must_check attribute now to ensure that future
> callers
> keep doing this too.
> 
> 

