Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF8468192
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 01:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383930AbhLDAvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 19:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383922AbhLDAvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 19:51:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0828BC061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 16:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2871B829C0
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 00:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48885C341C0;
        Sat,  4 Dec 2021 00:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638578865;
        bh=uOiMib5qNVizw93qq34cahEVzbzEkJTWW1/JcDbKZpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T/Xu2kRk0CRHHhngwGptVrr4RErEgnS0FIMyyofukNb8ZhZGFP8KrVgnjwKQ0M00H
         4+lnH8iGuoJKmEhA1ynIVli6YG7z2iOHY4M2d+azDUMzckf2ORdT47h2QWLJFMfqUn
         sfg3ir7CxZprz9zRuh12SnQtp7HPy4W87c8F2GInIoF3xty9UBYvCyBZ02juonqiPQ
         FBYwzRimejdbuAzfE2UkPR1YBCX2OqY+pUUsvdQG9HVb0Tvi+YZ1ET2/fxc/MgdB+H
         6lWc4kbdsE9yPEI3KUdnd3gFZP2wYYRjDTU9F1P2wxFZOwmdB5qnY+Qk8XIp6HGqfe
         oHL1jpCsEJI7w==
Date:   Fri, 3 Dec 2021 16:47:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v2 net-next 00/23] net: add preliminary netdev refcount
 tracking
Message-ID: <20211203164743.23de4a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Dec 2021 18:46:17 -0800 Eric Dumazet wrote:
> Two first patches add a generic infrastructure, that will be used
> to get tracking of refcount increments/decrements.
> 
> The general idea is to be able to precisely pair each decrement with
> a corresponding prior increment. Both share a cookie, basically
> a pointer to private data storing stack traces.
> 
> The third place adds dev_hold_track() and dev_put_track() helpers
> (CONFIG_NET_DEV_REFCNT_TRACKER)
> 
> Then a series of 20 patches converts some dev_hold()/dev_put()
> pairs to new hepers : dev_hold_track() and dev_put_track().
> 
> Hopefully this will be used by developpers and syzbot to
> root cause bugs that cause netdevice dismantles freezes.
> 
> With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
> some class of bugs, but too late (when too many dev_put()
> were happening).

Hi Eric, there's a handful of kdoc warnings added here:

include/linux/netdevice.h:2278: warning: Function parameter or member 'refcnt_tracker' not described in 'net_device'
include/net/devlink.h:679: warning: Function parameter or member 'dev_tracker' not described in 'devlink_trap_metadata'
include/linux/netdevice.h:2283: warning: Function parameter or member 'refcnt_tracker' not described in 'net_device'
include/linux/mroute_base.h:40: warning: Function parameter or member 'dev_tracker' not described in 'vif_device'

Would you mind following up? likely not worth re-spinning just for that.
