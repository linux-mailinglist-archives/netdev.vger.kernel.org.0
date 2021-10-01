Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D887F41F7EF
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhJAXBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhJAXBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 19:01:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22B661AD0;
        Fri,  1 Oct 2021 22:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633129178;
        bh=J+KyLIxmGsnqZziRl7hoYvR6nRmbRnva5Gd0Pc5n3+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jBB37UrfaAAxZ98cKA+YUaFSWOe4pBAa9wOqHvK1GeIAhNoRdDoDweCJur8Cktl5B
         D+wVqFjCqyJisolJH/9fxiSNNcUI5Qxt39odYqB2dN6h2fPHnuUVBqp2R1YJncreuv
         XuTAIJM1dTsWR6furDJe0bPHUIr7OAwy7r/Goc01Z6AkJeBeTUWutgbWqcLEZw4DdF
         VMrH/KDkf7dgiWx1R2CitS8xdIoFIOLBPjQEWfjTGPUBYFdiu9Y4k9vVRwI+rVHZ8b
         AUlG1SiW98ZNRPFECYW44ac0NkNEQ/LZs7uBkuZm0lbjU7yyr7syT+3fw+qRvVIXUa
         m42cmYntTn6nQ==
Date:   Fri, 1 Oct 2021 15:59:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        Po Liu <po.liu@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on
 vsc9959
Message-ID: <20211001155936.48eec95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001224633.u7ylsyy4mpl5kmmo@skbuf>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
        <20211001151115.5f583f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211001224633.u7ylsyy4mpl5kmmo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021 22:46:34 +0000 Vladimir Oltean wrote:
> On Fri, Oct 01, 2021 at 03:11:15PM -0700, Jakub Kicinski wrote:
> > On Thu, 30 Sep 2021 15:59:40 +0800 Xiaoliang Yang wrote:  
> > > VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
> > > This patch series add PSFP support on tc flower offload of ocelot
> > > driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add gate
> > > and police set to support PSFP in VSC9959 driver.  
> >
> > Vladimir, any comments?  
> 
> Sorry, I was intending to try out the patches and get an overall feel
> from there, but I had an incredibly busy week and simply didn't have time.
> If it's okay to wait a bit more I will do that tomorrow.

Take your time, I'll mark it as Deferred for now.

> In general I feel that the most glaring issue Xiaoliang has still
> avoided to address is the one discussed here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210831034536.17497-6-xiaoliang.yang_1@nxp.com/#24416737
> where basically some tc filters depend on some bridge fdb entries, and
> there's no way to prevent the bridge from deleting the fdb entries which
> would in turn break the tc filters, but also no way of removing the tc
> filters when the bridge fdb entries disappear.
> The hardware design is poor, no two ways around that, but arguably it's
> a tricky issue to handle in software too, the bridge simply doesn't give
> switchdev drivers a chance to veto an fdb removal, and I've no idea what
> changing that would even mean. So I can understand why Xiaoliang is
> avoiding it.
> That's why I wanted to run the patches too, first I feel that we should
> provide a selftest for the feature, and that is absent from this patch
> series, and second I would like to see how broken can the driver state
> end up being if we just leave tc filters around which are just inactive
> in the absence of a bridge, or a bridge fdb entry. I simply don't know
> that right now.
> It's almost as if we would be better off stealing some hardware FDB
> entries from the bridge and reserving them for the tc filter, and not
> depending on the bridge driver at all.

Maybe I shouldn't comment based on the snippets of understanding but
"steal some FDB entries" would be my first reaction. Xiaoliang said:

	The PSFP gate and police action are set on ingress port, and
	"tc-filter" has no parameter to set the forward port for the
	filtered stream.

which seems to undersell TC.
