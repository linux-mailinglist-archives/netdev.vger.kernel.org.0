Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137DC5FD6D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 21:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfGDTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 15:31:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52530 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfGDTbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 15:31:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1479D14384FF2;
        Thu,  4 Jul 2019 12:31:04 -0700 (PDT)
Date:   Thu, 04 Jul 2019 12:31:03 -0700 (PDT)
Message-Id: <20190704.123103.1316772203613609076.davem@davemloft.net>
To:     vincent@bernat.ch
Cc:     jiri@resnulli.us, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: add an option to specify a delay
 between peer notifications
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702174354.10154-1-vincent@bernat.ch>
References: <20190701092758.GA2250@nanopsycho>
        <20190702174354.10154-1-vincent@bernat.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jul 2019 12:31:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Bernat <vincent@bernat.ch>
Date: Tue,  2 Jul 2019 19:43:54 +0200

> Currently, gratuitous ARP/ND packets are sent every `miimon'
> milliseconds. This commit allows a user to specify a custom delay
> through a new option, `peer_notif_delay'.
> 
> Like for `updelay' and `downdelay', this delay should be a multiple of
> `miimon' to avoid managing an additional work queue. The configuration
> logic is copied from `updelay' and `downdelay'. However, the default
> value cannot be set using a module parameter: Netlink or sysfs should
> be used to configure this feature.
> 
> When setting `miimon' to 100 and `peer_notif_delay' to 500, we can
> observe the 500 ms delay is respected:
> 
>     20:30:19.354693 ARP, Request who-has 203.0.113.10 tell 203.0.113.10, length 28
>     20:30:19.874892 ARP, Request who-has 203.0.113.10 tell 203.0.113.10, length 28
>     20:30:20.394919 ARP, Request who-has 203.0.113.10 tell 203.0.113.10, length 28
>     20:30:20.914963 ARP, Request who-has 203.0.113.10 tell 203.0.113.10, length 28
> 
> In bond_mii_monitor(), I have tried to keep the lock logic readable.
> The change is due to the fact we cannot rely on a notification to
> lower the value of `bond->send_peer_notif' as `NETDEV_NOTIFY_PEERS' is
> only triggered once every N times, while we need to decrement the
> counter each time.
> 
> iproute2 also needs to be updated to be able to specify this new
> attribute through `ip link'.
> 
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>

Applied, thanks.
