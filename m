Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0E137FC1F
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 19:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhEMRJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 13:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhEMRJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 13:09:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BC9C06175F;
        Thu, 13 May 2021 10:08:27 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lhEow-00029d-BN; Thu, 13 May 2021 19:08:22 +0200
Date:   Thu, 13 May 2021 19:08:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Dexuan Cui <decui@microsoft.com>,
        "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN
Message-ID: <20210513170822.GA3673@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
References: <MW2PR2101MB0892FC0F67BD25661CDCE149BF529@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB0892864684CFDB096E0DBF02BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB08925E481FFFF8AB7A3ACDAFBF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB089257F49E8FAA00CDA63A61BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <20210513094047.GA24842@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513094047.GA24842@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 13, 2021 at 11:40:47AM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 13, 2021 at 06:19:38AM +0000, Dexuan Cui wrote:
> > > From: Dexuan Cui
> > > Sent: Wednesday, May 12, 2021 11:02 PM
> > 
> > BTW, I found a similar report in 2019:
> > 
> > "
> > https://serverfault.com/questions/101022/error-applying-iptables-rules-using-iptables-restore
> > I stumbled upon this issue on Ubuntu 18.04. The netfilter-persistent
> > service failed randomly on boot while working ok when launched manually.
> > Turned out it was conflicting with sshguard service due to systemd trying
> > to load everything in parallel. What helped is to setting
> > ENABLE_FIREWALL=0 in /etc/default/sshguard and then adding sshguard chain
> > and rule manually to /etc/iptables/rules.v4 and /etc/iptables/rules.v6.
> > "
> > 
> > The above report provided a workaround.
> 
> There's -w and -W to serialize ruleset updates. You could follow a
> similar approach from userspace if you don't use iptables userspace
> binary.

My guess is the xtables lock is not effective here, so waiting for it
probably won't help.

Dexuan, concurrent access is avoided in user space using a file-based
lock. So if multiple iptables(-restore) processes run in different
mount-namespaces, they might miss the other's /run/xtables.lock. Another
option would be if libiptc is used instead of calling iptables, but
that's more a shot in the dark - I don't know if libiptc doesn't support
obtaining the xtables lock.

> > I think we need a real fix.
> 
> iptables-nft already fixes this.

nftables (and therefore iptables-nft) implement transactional logic in
kernel, user space automatically retries if a transaction's commit
fails.

Cheers, Phil
