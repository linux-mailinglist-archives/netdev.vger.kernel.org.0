Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5483C45AF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfJBBpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:45:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfJBBpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:45:43 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66BE114DE2322;
        Tue,  1 Oct 2019 18:45:42 -0700 (PDT)
Date:   Tue, 01 Oct 2019 21:45:41 -0400 (EDT)
Message-Id: <20191001.214541.933023401187237363.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        rajendra.dendukuri@broadcom.com, eric.dumazet@gmail.com,
        dsahern@gmail.com
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001032834.5330-1-dsahern@kernel.org>
References: <20191001032834.5330-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 18:45:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon, 30 Sep 2019 20:28:34 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Rajendra reported a kernel panic when a link was taken down:
 ...
> addrconf_dad_work is kicked to be scheduled when a device is brought
> up. There is a race between addrcond_dad_work getting scheduled and
> taking the rtnl lock and a process taking the link down (under rtnl).
> The latter removes the host route from the inet6_addr as part of
> addrconf_ifdown which is run for NETDEV_DOWN. The former attempts
> to use the host route in ipv6_ifa_notify. If the down event removes
> the host route due to the race to the rtnl, then the BUG listed above
> occurs.
> 
> This scenario does not occur when the ipv6 address is not kept
> (net.ipv6.conf.all.keep_addr_on_down = 0) as addrconf_ifdown sets the
> state of the ifp to DEAD. Handle when the addresses are kept by checking
> IF_READY which is reset by addrconf_ifdown.
> 
> The 'dead' flag for an inet6_addr is set only under rtnl, in
> addrconf_ifdown and it means the device is getting removed (or IPv6 is
> disabled). The interesting cases for changing the idev flag are
> addrconf_notify (NETDEV_UP and NETDEV_CHANGE) and addrconf_ifdown
> (reset the flag). The former does not have the idev lock - only rtnl;
> the latter has both. Based on that the existing dead + IF_READY check
> can be moved to right after the rtnl_lock in addrconf_dad_work.
> 
> Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
> Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable.
