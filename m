Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59EFB166B3F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 01:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgBUAC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 19:02:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729234AbgBUAC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 19:02:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0323C121793D8;
        Thu, 20 Feb 2020 16:02:55 -0800 (PST)
Date:   Thu, 20 Feb 2020 16:02:55 -0800 (PST)
Message-Id: <20200220.160255.1955114765293599857.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, christophe.leroy@c-s.fr, rgb@redhat.com,
        erhard_f@mailbox.org
Subject: Re: [PATCH net] net: netlink: cap max groups which will be
 considered in netlink_bind()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220144213.860206-1-nikolay@cumulusnetworks.com>
References: <20200220144213.860206-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 16:02:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Thu, 20 Feb 2020 16:42:13 +0200

> Since nl_groups is a u32 we can't bind more groups via ->bind
> (netlink_bind) call, but netlink has supported more groups via
> setsockopt() for a long time and thus nlk->ngroups could be over 32.
> Recently I added support for per-vlan notifications and increased the
> groups to 33 for NETLINK_ROUTE which exposed an old bug in the
> netlink_bind() code causing out-of-bounds access on archs where unsigned
> long is 32 bits via test_bit() on a local variable. Fix this by capping the
> maximum groups in netlink_bind() to BITS_PER_TYPE(u32), effectively
> capping them at 32 which is the minimum of allocated groups and the
> maximum groups which can be bound via netlink_bind().
> 
> CC: Christophe Leroy <christophe.leroy@c-s.fr>
> CC: Richard Guy Briggs <rgb@redhat.com>
> Fixes: 4f520900522f ("netlink: have netlink per-protocol bind function return an error code.")
> Reported-by: Erhard F. <erhard_f@mailbox.org>
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied.

> Dave it is not necessary to queue this fix for stable releases since
> NETLINK_ROUTE is the first to reach more groups after I added the vlan
> notification changes and I don't think we'll ever backport new groups. :)
> Up to you of course.
> 
> In fact looking at netlink_kernel_create nlk->groups can't be less than 32
> so we can add a NETLINK_MIN_GROUPS == NETLINK_MAX_LEGACY_BIND_GRPS == 32
> in net-next to replace the raw value.

Ok, thanks for letting me know. Let's skip the -stable backport.
