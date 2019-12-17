Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448E4121F52
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLQAPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:15:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQAPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:15:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D154B1556D69B;
        Mon, 16 Dec 2019 16:15:13 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:15:13 -0800 (PST)
Message-Id: <20191216.161513.1612649885729019096.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        roopa@cumulusnetworks.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next v2 00/10] Simplify IPv4 route offload API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191214155315.613186-1-idosch@idosch.org>
References: <20191214155315.613186-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:15:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sat, 14 Dec 2019 17:53:05 +0200

> Motivation
> ==========
> 
> The aim of this patch set is to simplify the IPv4 route offload API by
> making the stack a bit smarter about the notifications it is generating.
> This allows driver authors to focus on programming the underlying device
> instead of having to duplicate the IPv4 route insertion logic in their
> driver, which is error-prone.
> 
> This is the first patch set out of a series of four. Subsequent patch
> sets will simplify the IPv6 API, add offload/trap indication to routes
> and add tests for all the code paths (including error paths). Available
> here [1].
> 
> Details
> =======
> 
> Today, whenever an IPv4 route is added or deleted a notification is sent
> in the FIB notification chain and it is up to offload drivers to decide
> if the route should be programmed to the hardware or not. This is not an
> easy task as in hardware routes are keyed by {prefix, prefix length,
> table id}, whereas the kernel can store multiple such routes that only
> differ in metric / TOS / nexthop info.
> 
> This series makes sure that only routes that are actually used in the
> data path are notified to offload drivers. This greatly simplifies the
> work these drivers need to do, as they are now only concerned with
> programming the hardware and do not need to replicate the IPv4 route
> insertion logic and store multiple identical routes.
> 
> The route that is notified is the first FIB alias in the FIB node with
> the given {prefix, prefix length, table ID}. In case the route is
> deleted and there is another route with the same key, a replace
> notification is emitted. Otherwise, a delete notification is emitted.
> 
> The above means that in the case of multiple routes with the same key,
> but different TOS, only the route with the highest TOS is notified.
> While the kernel can route a packet based on its TOS, this is not
> supported by any hardware devices I am familiar with. Moreover, this is
> not supported by IPv6 nor by BIRD/FRR from what I could see. Offload
> drivers should therefore use the presence of a non-zero TOS as an
> indication to trap packets matching the route and let the kernel route
> them instead. mlxsw has been doing it for the past two years.
 ...

Series applied, thanks!
