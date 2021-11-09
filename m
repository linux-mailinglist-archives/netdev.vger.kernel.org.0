Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B9844B00A
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238808AbhKIPJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:09:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236716AbhKIPJw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 10:09:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E8FB610A0;
        Tue,  9 Nov 2021 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636470426;
        bh=NbTi1s7PPh+6WlWPla4jC2pqy03eh5nPjE8IbKVq024=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F6FNwhYYZALUN5kw7Kbizx7aeOuEDj/i6JSmf/DWbZ+Tp0MnPhhW7iDQY1UTFP8Wf
         vV92T5LEbdEpvZmk3bjR50qbnmPyXClcD5dDxFEsnOoxF/mzqZlaikyF2g9L2QCAku
         eNudM629+IaPn99JF4svKjA495HKkTLqCW422DLYJg+37V9nwN14Vs7qNeMjRGd/rb
         Qy1tatHCNweCbImA61SUjBotN8ykN2hF36T8IydqpzpNZv1N7ukY/beLKRrPRNvlBp
         MKJUNMn7wlxHhErwxR8odEYcD+vAtwzyFusV2dBOi/lfBBjOkbOtky/KXewMS+C3wL
         33s/NZm1vp5qg==
Date:   Tue, 9 Nov 2021 07:07:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211109144358.GA1824154@nvidia.com>
References: <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
        <YYgJ1bnECwUWvNqD@shredder>
        <YYgSzEHppKY3oYTb@unreal>
        <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlfI4UgpEsMt5QI@unreal>
        <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlrZZTdJKhha0FF@unreal>
        <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYmBbJ5++iO4MOo7@unreal>
        <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211109144358.GA1824154@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Nov 2021 10:43:58 -0400 Jason Gunthorpe wrote:
> This becomes all entangled in the aux device stuff we did before.

So entangled in fact that neither of you is willing to elucidate 
the exact need ;)

> devlink reload is defined, for reasons unrelated to netns, to do a
> complete restart of the aux devices below the devlink. This happens
> necessarily during actual reconfiguration operations, for instance.
> 
> So we have a situation, which seems like bad design, where reload is
> also triggered by net namespace change that has nothing to do with
> reconfiguring.

Agreed, it is somewhat uncomfortable that the same callback achieves
two things. As clear as the need for reload-for-reset is (reconfig,
recovery etc.) I'm not as clear on reload for netns.

The main use case for reload for netns is placing a VF in a namespace,
for a container to use. Is that right? I've not seen use cases
requiring the PF to be moved, are there any?

devlink now lives in a networking namespace yet it spans such
namespaces (thru global notifiers). I think we need to define what it
means for devlink to live in a namespace. Is it just about the
configuration / notification channel? Or do we expect proper isolation?

Jiri?

> In this case the per-net-ns becomes a BKL that gets
> held across way too much stuff as it recuses down the reload path,
> through aux devices, into the driver core and beyond.
> 
> When I looked at trying to fix this from the RDMA side I could not
> find any remedy that didn't involve some kind of change in netdev
> land. The drivers must be able to register/unregister notifiers in
> their struct device_driver probe/remove functions.
> 
> I once sketched out fixing this by removing the need to hold the
> per_net_rwsem just for list iteration, which in turn avoids holding it
> over the devlink reload paths. It seemed like a reasonable step toward
> finer grained locking.

Seems to me the locking is just a symptom.
