Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FAD49F0E3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345270AbiA1CTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345221AbiA1CTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:19:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFFCC061714;
        Thu, 27 Jan 2022 18:19:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA9961DB4;
        Fri, 28 Jan 2022 02:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81646C340E4;
        Fri, 28 Jan 2022 02:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643336371;
        bh=Aoj2Iv8DFQ9AdcHDqZfrHVewWKFn6QA7nOKH4pJfZME=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RTUdW5JFpLi6UJhFMkB9gjKt2wVV6Vk8Y1ktbFE/z3VnCGbrl4NY0pEnmqYS7I6cb
         YZCEeVcE8D9XYhzjBDWzDTpMAnLxFr/OVRo1OmcPQe6ImYtjo1kT0/0hDJey67sMOh
         MhVFZ090m8aMt4oiDdEAiIOuzh5KhFkG22KUDwblMhyZLSh8kh/eexC+GPCZKn6qAa
         8OJKqR56qeWGnuW+M50LhuDwDcl7ILX9Qm0zgmo4gH3efcu+NL/KKiNHCuPN24nuOZ
         Ovn9yrOVq1CYL8l9qYI3U1YtLZ2rRFqNGDnTReYREYSvuteHh/mi03XEeYb37i9TmO
         kCuCyq89nl32g==
Date:   Thu, 27 Jan 2022 18:19:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jann Horn <jannh@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>
Subject: Re: [BUG] net_device UAF: linkwatch_fire_event() calls dev_hold()
 after netdev_wait_allrefs() is done
Message-ID: <20220127181930.355c8c82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com>
References: <CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interesting..

I don't know what link_reset does, but since it turns the carrier on it
seems like something that should be flushed/canceled when the device
goes down. unregister brings the device down under rtnl_lock.

On Fri, 28 Jan 2022 02:51:24 +0100 Jann Horn wrote:
> Is the bug that usbnet_disconnect() should be stopping &dev->kevent
> before calling unregister_netdev()?

I'd say not this one, I think the generally agreed on semantics are that
the netdev is under users control between register and unregister, we
should not cripple it before unregister.

> Or is the bug that ax88179_link_reset() doesn't take some kind of lock
> and re-check that the netdev is still alive?

That'd not be an uncommon way to fix this.. taking rtnl_lock, not even 
a driver lock in similar.

> Or should netif_carrier_on() be doing that?
> Or is it the responsibility of the linkwatch code to check whether the
> netdev is already going away?

Possibly, although we don't do much in the way of defensive programming
in networking.
