Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75BE61BF36
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 23:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfEMVqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 17:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbfEMVqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 17:46:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6BD5685363;
        Mon, 13 May 2019 21:46:53 +0000 (UTC)
Received: from bistromath.localdomain (unknown [10.40.205.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44CB35D71E;
        Mon, 13 May 2019 21:46:49 +0000 (UTC)
Date:   Mon, 13 May 2019 23:46:48 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, Dan Winship <danw@redhat.com>
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
Message-ID: <20190513214648.GA29270@bistromath.localdomain>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
 <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
 <20190513150812.GA18478@bistromath.localdomain>
 <771b21d6-3b1e-c118-2907-5b5782f7cb92@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <771b21d6-3b1e-c118-2907-5b5782f7cb92@6wind.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 13 May 2019 21:46:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-13, 17:13:36 +0200, Nicolas Dichtel wrote:
> Le 13/05/2019 à 17:08, Sabrina Dubroca a écrit :
> > 2019-05-13, 16:50:51 +0200, Nicolas Dichtel wrote:
> >> Le 13/05/2019 à 15:47, Sabrina Dubroca a écrit :
> >>> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
> >>> iflink == ifindex.
> >>>
> >>> In some cases, a device can be created in a different netns with the
> >>> same ifindex as its parent. That device will not dump its IFLA_LINK
> >>> attribute, which can confuse some userspace software that expects it.
> >>> For example, if the last ifindex created in init_net and foo are both
> >>> 8, these commands will trigger the issue:
> >>>
> >>>     ip link add parent type dummy                   # ifindex 9
> >>>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
> >>>
> >>> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
> >>> always put the IFLA_LINK attribute as well.
> >>>
> >>> Thanks to Dan Winship for analyzing the original OpenShift bug down to
> >>> the missing netlink attribute.
> >>>
> >>> Analyzed-by: Dan Winship <danw@redhat.com>
> >>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >> I would say:
> >> Fixes: 5e6700b3bf98 ("sit: add support of x-netns")
> >>
> >> Because before this patch, there was no device with an iflink that can be put in
> >> another netns.
> > 
> > That tells us how far back we might want to backport this fix, but not
> > which commit introduced the bug. I think Fixes should refer to the
> > introduction of the faulty code, not to what patch made it visible (if
> > we can find both).
> No sure to follow you. The problem you describe cannot happen before commit
> 5e6700b3bf98, so there cannot be a "faulty" patch before that commit.

What about macvlan devices?

From commit b863ceb7ddce ("[NET]: Add macvlan driver"):

static int macvlan_init(struct net_device *dev)
{
...
        dev->iflink             = lowerdev->ifindex;
...
}

vlan devices also had an iflink assigned since commit ddd7bf9fe4e5.

What am I missing?

-- 
Sabrina
