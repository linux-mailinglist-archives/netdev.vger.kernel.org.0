Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B7517D888
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCIEOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:14:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgCIEO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:14:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 43456158B5610;
        Sun,  8 Mar 2020 21:14:29 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:14:28 -0700 (PDT)
Message-Id: <20200308.211428.244940116218476313.davem@davemloft.net>
To:     jwiesner@suse.com
Cc:     netdev@vger.kernel.org, maheshb@google.com,
        Andreas.Taschner@suse.com, mkubecek@suse.cz
Subject: Re: [PATCH v2 net] ipvlan: do not add hardware address of master
 to its unicast filter list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200307123157.GA28858@incl>
References: <20200307123157.GA28858@incl>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:14:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Wiesner <jwiesner@suse.com>
Date: Sat, 7 Mar 2020 13:31:57 +0100

> There is a problem when ipvlan slaves are created on a master device that
> is a vmxnet3 device (ipvlan in VMware guests). The vmxnet3 driver does not
> support unicast address filtering. When an ipvlan device is brought up in
> ipvlan_open(), the ipvlan driver calls dev_uc_add() to add the hardware
> address of the vmxnet3 master device to the unicast address list of the
> master device, phy_dev->uc. This inevitably leads to the vmxnet3 master
> device being forced into promiscuous mode by __dev_set_rx_mode().
> 
> Promiscuous mode is switched on the master despite the fact that there is
> still only one hardware address that the master device should use for
> filtering in order for the ipvlan device to be able to receive packets.
> The comment above struct net_device describes the uc_promisc member as a
> "counter, that indicates, that promiscuous mode has been enabled due to
> the need to listen to additional unicast addresses in a device that does
> not implement ndo_set_rx_mode()". Moreover, the design of ipvlan
> guarantees that only the hardware address of a master device,
> phy_dev->dev_addr, will be used to transmit and receive all packets from
> its ipvlan slaves. Thus, the unicast address list of the master device
> should not be modified by ipvlan_open() and ipvlan_stop() in order to make
> ipvlan a workable option on masters that do not support unicast address
> filtering.
> 
> Fixes: 2ad7bf3638411 ("ipvlan: Initial check-in of the IPVLAN driver")
> Reported-by: Per Sundstrom <per.sundstrom@redqube.se>
> Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Mahesh Bandewar <maheshb@google.com>

Applied and queued up for -stable, thank you.
