Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71959C648
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 23:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfHYVcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 17:32:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56318 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfHYVcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 17:32:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71E2714E7BECD;
        Sun, 25 Aug 2019 14:32:50 -0700 (PDT)
Date:   Sun, 25 Aug 2019 14:32:46 -0700 (PDT)
Message-Id: <20190825.143246.1565839919556239720.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, sharpd@cumulusnetworks.com,
        dsahern@gmail.com
Subject: Re: [PATCH net] nexthop: Fix nexthop_num_path for blackhole
 nexthops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190825144730.28814-1-dsahern@kernel.org>
References: <20190825144730.28814-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 14:32:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Sun, 25 Aug 2019 07:47:30 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Donald reported this sequence:
>   ip next add id 1 blackhole
>   ip next add id 2 blackhole
>   ip ro add 1.1.1.1/32 nhid 1
>   ip ro add 1.1.1.2/32 nhid 2
> 
> would cause a crash. Backtrace is:
 ...
> fib_dump_info incorrectly has nhs = 0 for blackhole nexthops, so it
> believes the nexthop object is a multipath group (nhs != 1) and ends
> up down the nexthop_mpath_fill_node() path which is wrong for a
> blackhole.
> 
> The blackhole check in nexthop_num_path is leftover from early days
> of the blackhole implementation which did not initialize the device.
> In the end the design was simpler (fewer special case checks) to set
> the device to loopback in nh_info, so the check in nexthop_num_path
> should have been removed.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Reported-by: Donald Sharp <sharpd@cumulusnetworks.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks David.
