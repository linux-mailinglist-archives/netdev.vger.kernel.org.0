Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E4546DFA6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbhLIAtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:49:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58010 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbhLIAtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:49:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FB4AB82345
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 00:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF276C00446;
        Thu,  9 Dec 2021 00:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639010745;
        bh=QwcNNciADfY3jwW4GUUePLCGGK9OnOkiRPYlipNXJuE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jwRwrJHMxPh13iu1jy+bMMBjVARcllMowE4O5rgnkll9/xiGftG+56uCkDa2QSUF1
         LkINZtLOkuUiUWKDyuzvgci6G1z8QOmET9uogkUszjWrjtzjYYz9vYq3RWVJVxmjCb
         5sIQwoYMDHEQpMjl7WLcuOhEC3I9KULjfnW8qx77FrQUzYTGiITwEU9HwW8w9v1Rb0
         04AdpUw19c1qNFiNFtGSIaNHSrnD3EZzbwwbBOAJbhs7r24UpoXvnQxP5E405gVODF
         DtFZSLWNaQcagiy9+50az83hgYMu+bUblGX7en+hMmcblZSY0N3ILASGuAvUc8km/i
         YHvf3N83TmD6g==
Date:   Wed, 8 Dec 2021 16:45:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org, nikolay@nvidia.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211208164544.64792d51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7ae281fa-3d05-542f-941c-ba86bd35c31e@gmail.com>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
        <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
        <20211208214711.zr4ljxqpb5u7z3op@kgollan-pc>
        <05fe0ea9-56ba-9248-fa05-b359d6166c9f@gmail.com>
        <20211208160405.18c7d30f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7ae281fa-3d05-542f-941c-ba86bd35c31e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 17:18:48 -0700 David Ahern wrote:
> On 12/8/21 5:04 PM, Jakub Kicinski wrote:
> >> I think marking the dev's and then using a delete loop is going to be
> >> the better approach - avoid the sort and duplicate problem. I use that
> >> approach for nexthop deletes:
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/nexthop.c#n1849
> >>
> >> Find a hole in net_device struct in an area used only for control path
> >> and add 'bool grp_delete' (or a 1-bit hole). Mark the devices on pass
> >> and delete them on another.  
> > 
> > If we want to keep state in the netdev itself we can probably piggy
> > back on dev->unreg_list. It should be initialized to empty and not
> > touched unless device goes thru unregister.
> 
> isn't that used when the delink function calls unregister_netdevice_queue?

Sure but all the validation is before we start calling delink, so
doesn't matter?

list to_kill, queued;

for_each_attr(nest) {
	...

	dev = get_by_index(nla_get_s32(..));
	if (!dev)
		goto cleanup;
	if (!list_empty(&dev->unreg_list))
		goto cleanup;
	...

	list_add(&to_kill, &dev->unreg_list);
}

for_each_entry_safe(to_kill) {
	list_del_init(&dev->unreg_list);
	->dellink(dev, queued);
}

unreg_many(queued);

return

cleanup:
	for_each_entry_safe(to_kill) {
		list_del_init(&dev->unreg_list);
	}

No?
