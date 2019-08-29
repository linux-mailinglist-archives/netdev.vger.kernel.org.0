Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B90A12C7
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 09:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfH2HpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 03:45:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:47884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726739AbfH2HpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 03:45:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECC97AF80;
        Thu, 29 Aug 2019 07:45:16 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 39FEBE0CFC; Thu, 29 Aug 2019 09:45:16 +0200 (CEST)
Date:   Thu, 29 Aug 2019 09:45:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        David Miller <davem@davemloft.net>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
Subject: Re: [PATCH 1/2] rtnetlink: gate MAC address with an LSM hook
Message-ID: <20190829074516.GM29594@unicorn.suse.cz>
References: <20190821134547.96929-1-jeffv@google.com>
 <20190822.161913.326746900077543343.davem@davemloft.net>
 <CABXk95BF=RfqFSHU_---DRHDoKyFON5kS_vYJbc4ns2OS=_t0w@mail.gmail.com>
 <CAHC9VhRmmEp_nFtOFy_YRa9NwZA4qPnjw7D3JQvqED-tO4Ha1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRmmEp_nFtOFy_YRa9NwZA4qPnjw7D3JQvqED-tO4Ha1g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 04:47:04PM -0400, Paul Moore wrote:
> 
> I'm also not a big fan of inserting the hook in rtnl_fill_ifinfo(); as
> presented it is way too specific for a LSM hook for me to be happy.
> However, I do agree that giving the LSMs some control over netlink
> messages makes sense.  As others have pointed out, it's all a matter
> of where to place the hook.
> 
> If we only care about netlink messages which leverage nlattrs I
> suppose one option that I haven't seen mentioned would be to place a
> hook in nla_put().  While it is a bit of an odd place for a hook, it
> would allow the LSM easy access to the skb and attribute type to make
> decisions, and all of the callers should already be checking the
> return code (although we would need to verify this).  One notable
> drawback (not the only one) is that the hook is going to get hit
> multiple times for each message.

For most messages, "multiple times" would mean tens, for many even
hundreds of calls. For each, you would have to check corresponding
socket (and possibly also genetlink header) to see which netlink based
protocol it is and often even parse existing part of the message to get
the context (because the same numeric attribute type can mean something
completely different if it appears in a nested attribute).

Also, nla_put() (or rather __nla_put()) is not used for all attributes,
one may also use nla_reserve() and then compose the attribute date in
place.

Michal Kubecek
