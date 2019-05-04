Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA3613781
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfEDElV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:41:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfEDElV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:41:21 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F63C14D8E200;
        Fri,  3 May 2019 21:41:15 -0700 (PDT)
Date:   Sat, 04 May 2019 00:41:11 -0400 (EDT)
Message-Id: <20190504.004111.284554825798498883.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, alan.maguire@oracle.com,
        jwestfall@surrealistic.net, dsahern@gmail.com
Subject: Re: [PATCH net] neighbor: Call __ipv4_neigh_lookup_noref in
 neigh_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502011842.1645-1-dsahern@kernel.org>
References: <20190502011842.1645-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:41:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed,  1 May 2019 18:18:42 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Commit cd9ff4de0107 changed the key for IFF_POINTOPOINT devices to
> INADDR_ANY but neigh_xmit which is used for MPLS encapsulations was not
> updated to use the altered key. The result is that every packet Tx does
> a lookup on the gateway address which does not find an entry, a new one
> is created only to find the existing one in the table right before the
> insert since arp_constructor was updated to reset the primary key. This
> is seen in the allocs and destroys counters:
>     ip -s -4 ntable show | head -10 | grep alloc
> 
> which increase for each packet showing the unnecessary overhread.
> 
> Fix by having neigh_xmit use __ipv4_neigh_lookup_noref for NEIGH_ARP_TABLE.
> 
> Fixes: cd9ff4de0107 ("ipv4: Make neigh lookup keys for loopback/point-to-point devices be INADDR_ANY")
> Reported-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable.
