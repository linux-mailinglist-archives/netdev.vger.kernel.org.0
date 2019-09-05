Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2CA8A9FC6
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbfIEKgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:36:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44530 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387871AbfIEKgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:36:17 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6CF371538812D;
        Thu,  5 Sep 2019 03:36:16 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:36:15 +0200 (CEST)
Message-Id: <20190905.123615.989515327771345755.davem@davemloft.net>
To:     sharpd@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        sworley@cumulusnetworks.com
Subject: Re: [PATCH v3 net] net: Properly update v4 routes with v6 nexthop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190904141158.17021-1-sharpd@cumulusnetworks.com>
References: <20190904141158.17021-1-sharpd@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:36:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Donald Sharp <sharpd@cumulusnetworks.com>
Date: Wed,  4 Sep 2019 10:11:58 -0400

> When creating a v4 route that uses a v6 nexthop from a nexthop group.
> Allow the kernel to properly send the nexthop as v6 via the RTA_VIA
> attribute.
> 
> Broken behavior:
> 
> $ ip nexthop add via fe80::9 dev eth0
> $ ip nexthop show
> id 1 via fe80::9 dev eth0 scope link
> $ ip route add 4.5.6.7/32 nhid 1
> $ ip route show
> default via 10.0.2.2 dev eth0
> 4.5.6.7 nhid 1 via 254.128.0.0 dev eth0
> 10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
> $
> 
> Fixed behavior:
> 
> $ ip nexthop add via fe80::9 dev eth0
> $ ip nexthop show
> id 1 via fe80::9 dev eth0 scope link
> $ ip route add 4.5.6.7/32 nhid 1
> $ ip route show
> default via 10.0.2.2 dev eth0
> 4.5.6.7 nhid 1 via inet6 fe80::9 dev eth0
> 10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
> $
> 
> v2, v3: Addresses code review comments from David Ahern
> 
> Fixes: dcb1ecb50edf (“ipv4: Prepare for fib6_nh from a nexthop object”)
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>

Applied, thank you.
