Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C0E2CDDA3
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbgLCS2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgLCS2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 13:28:44 -0500
Date:   Thu, 3 Dec 2020 10:28:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607020083;
        bh=79pVmEiGY09uStaLdHgvpv8VoidOztdyQWlxY1kgCwA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=A06Bm35mVRT0NBoRGsjIZQoIWX4hX325fHqCGBaEwR25QoJ9Q2UtEamABN2nliHl4
         ump2zDNxgagmbC3XrzMg2+xW3zNMSX75zQKoh0Fv4bOKLa01gNNCKuhjzO2kBelZfa
         uTxqeLVYTmaLL2IVLjL0frhVg/q0RKSzC6V7yKcdLwf8eqTfrPDPEn2Xg1V6DHQdat
         lez353KoHeaKE4+6Kud9rQ4ugNwA7KGd8gQSHO0Rd+FKHCuByIeR3aUgxvyX05E3ep
         tnxZNBsK8ogPXwRGPIFDWL074hiivScxOP5RsJ7xx0R8SjCTXr4c7ioF6ra9t9Kgqu
         UxeWEJoOC4amQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph Huang <Joseph.Huang@garmin.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>
Subject: Re: [PATCH] bridge: Fix a deadlock when enabling multicast snooping
Message-ID: <20201203102802.62bc86ba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201214047.128948-1-Joseph.Huang@garmin.com>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 16:40:47 -0500 Joseph Huang wrote:
> When enabling multicast snooping, bridge module deadlocks on multicast_lock
> if 1) IPv6 is enabled, and 2) there is an existing querier on the same L2
> network.
> 
> The deadlock was caused by the following sequence: While holding the lock,
> br_multicast_open calls br_multicast_join_snoopers, which eventually causes
> IP stack to (attempt to) send out a Listener Report (in igmp6_join_group).
> Since the destination Ethernet address is a multicast address, br_dev_xmit
> feeds the packet back to the bridge via br_multicast_rcv, which in turn
> calls br_multicast_add_group, which then deadlocks on multicast_lock.
> 
> The fix is to move the call br_multicast_join_snoopers outside of the
> critical section. This works since br_multicast_join_snoopers only deals
> with IP and does not modify any multicast data structures of the bridge,
> so there's no need to hold the lock.
> 
> Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")
> 
> Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>

Nik, Linus - how does this one look?
