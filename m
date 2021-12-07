Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5C546B3DF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhLGHck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:32:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37296 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbhLGHck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:32:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58E25B80DCB;
        Tue,  7 Dec 2021 07:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E674C341C3;
        Tue,  7 Dec 2021 07:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638862148;
        bh=5Dq/7jLxcO2UFh4QvOiytWk2dl7v7XkLRY05FxFYRqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YG6cDvRY/296PCdJ1xhJlyEaGHix7q7ygi4kq76xEErjx2iLH1gQRje/NH8btMrsl
         076PcMMIMt7N/Ku0WxlNaHfJUSJvgsT73sC/3TDkBy4q3g36+XSbGjtufJX3IQJYgN
         ZXpLhW77S1GCMQ+zWHHjpuh6DQ4EO58XqiXsdUoNFTIBsWOd2K8z8mRtGcOayz7GAF
         pl7j34I69Y4J1sxLx1AVeApxMwpz3JYdFrELoI3NOwu85zgpxw2KXHND2exLrp5ROM
         8nmNumt/j19kXx3UZkU9aeOU+OpdHG09OrAT47zF/0CigiN6V5pbt3Wc1/Ekku2cpS
         PB0VHMTt6UhzA==
Date:   Tue, 7 Dec 2021 09:29:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Allow parallel devlink execution
Message-ID: <Ya8NPxxn8/OAF4cR@unreal>
References: <cover.1638690564.git.leonro@nvidia.com>
 <20211206180027.3700d357@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180027.3700d357@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 06:00:27PM -0800, Jakub Kicinski wrote:
> On Sun,  5 Dec 2021 10:22:00 +0200 Leon Romanovsky wrote:
> > This is final piece of devlink locking puzzle, where I remove global
> > mutex lock (devlink_mutex), so we can run devlink commands in parallel.
> > 
> > The series starts with addition of port_list_lock, which is needed to
> > prevent locking dependency between netdevsim sysfs and devlink. It
> > follows by the patch that adds context aware locking primitives. Such
> > primitives allow us to make sure that devlink instance is locked and
> > stays locked even during reload operation. The last patches opens
> > devlink to parallel commands.
> 
> I'm not okay with assuming that all sub-objects are added when devlink
> is not registered.

But none of the patches in this series assume that.

In devlink_nested_lock() patch [1], I added new marker just to make sure
that we don't lock if this specific command is called in locked context.

+#define DEVLINK_NESTED_LOCK XA_MARK_2

[1] https://lore.kernel.org/all/2b64a2a81995b56fec0231751ff6075020058584.1638690564.git.leonro@nvidia.com/
