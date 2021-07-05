Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699A63BC43E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 01:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhGEX5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 19:57:00 -0400
Received: from smtp.sysclose.org ([69.164.214.230]:42282 "EHLO sysclose.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhGEX47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 19:56:59 -0400
Received: from localhost (unknown [191.7.188.189])
        by sysclose.org (Postfix) with ESMTPSA id 51DEF2613;
        Mon,  5 Jul 2021 23:54:26 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org 51DEF2613
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1625529266;
        bh=zVz1V2cB6GNMus71RcvbKD8sPWbQds76F/TrRNhZjK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LEqiiTDOoD0rrQkdDFkEenG4mgdoJsCUg2BGVS2hkTYsJrZBBw+taKaqD2HyVRsZt
         QlAPiFo5u+kIiDkEqjVfy/CN6Oc+cRvL+QOXoRC69vs+JJHaXTiOPdwAiYxP9srLaw
         Q0bb0L/TzomB1ZtW60BMk4bEQXr34+sBRPPDksS1oB66s5wv3Xa0Bn92LwCKbY0W0F
         fVSz4z5NWQ/IDl+Fj50mrCKO/CX1qA3C9BXDcVCVOuIxEolaPB07SvH7T1JP8Gc2W4
         VIwTNKXALye8AgMXCq7xHLa1UjRZY9ZxIgzIv8qvYbuaJ21XLcxQvRM7L0vHSmJ5mI
         D8v9L0jPsAs4A==
Date:   Mon, 5 Jul 2021 20:54:17 -0300
From:   Flavio Leitner <fbl@sysclose.org>
To:     Mark Gray <mark.d.gray@redhat.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com, pravin.ovn@gmail.com
Subject: Re: [PATCH net-next] openvswitch: Introduce per-cpu upcall dispatch
Message-ID: <YOObqVRRRHUNmA9o@p50>
References: <20210630095350.817785-1-mark.d.gray@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630095350.817785-1-mark.d.gray@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 05:53:49AM -0400, Mark Gray wrote:
> The Open vSwitch kernel module uses the upcall mechanism to send
> packets from kernel space to user space when it misses in the kernel
> space flow table. The upcall sends packets via a Netlink socket.
> Currently, a Netlink socket is created for every vport. In this way,
> there is a 1:1 mapping between a vport and a Netlink socket.
> When a packet is received by a vport, if it needs to be sent to
> user space, it is sent via the corresponding Netlink socket.
> 
> This mechanism, with various iterations of the corresponding user
> space code, has seen some limitations and issues:
> 
> * On systems with a large number of vports, there is a correspondingly
> large number of Netlink sockets which can limit scaling.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1526306)
> * Packet reordering on upcalls.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1844576)
> * A thundering herd issue.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1834444)
> 
> This patch introduces an alternative, feature-negotiated, upcall
> mode using a per-cpu dispatch rather than a per-vport dispatch.
> 
> In this mode, the Netlink socket to be used for the upcall is
> selected based on the CPU of the thread that is executing the upcall.
> In this way, it resolves the issues above as:
> 
> a) The number of Netlink sockets scales with the number of CPUs
> rather than the number of vports.
> b) Ordering per-flow is maintained as packets are distributed to
> CPUs based on mechanisms such as RSS and flows are distributed
> to a single user space thread.
> c) Packets from a flow can only wake up one user space thread.
> 
> The corresponding user space code can be found at:
> https://mail.openvswitch.org/pipermail/ovs-dev/2021-April/382618.html
> 
> Bugzilla: https://bugzilla.redhat.com/1844576
> Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
> ---

It looks good and works for me.
Acked-by: Flavio Leitner <fbl@sysclose.org>

Thanks Mark!
fbl
