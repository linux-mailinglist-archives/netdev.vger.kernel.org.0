Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394211E4E8E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbgE0TuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbgE0TuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 15:50:21 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507552078C;
        Wed, 27 May 2020 19:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590609019;
        bh=V4k/bpx0s+ErqefODRw/Gzx3D6BwsghX+U0JTgK+Bj8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1vD5NQ6443157y2vRvX6+UowtGBzInf8c81gZcTyTYoBxH7wOYfzOFPM/pTe6eCAM
         a88u0PHiJW/6koXyjg7+GcYOgvnB860xrvw3VPUUTjYojdxlgIqZ8bLw+7yZVEI2te
         1GchugCf2lM089nSfwkPZ+Ug21fuF8qgkALqxNh8=
Date:   Wed, 27 May 2020 12:50:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/14] mlxsw: Various trap changes - part 2
Message-ID: <20200527125017.1c960f70@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527073857.GA1511819@splinter>
References: <20200525230556.1455927-1-idosch@idosch.org>
        <20200526151437.6fc3fb67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20200526231905.GA1507270@splinter>
        <20200526164323.565c8309@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20200527073857.GA1511819@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 10:38:57 +0300 Ido Schimmel wrote:
> There is no special sauce required to get a DHCP daemon working nor BFD.
> It is supposed to Just Work. Same for IGMP / MLD snooping, STP etc. This
> is enabled by the ASIC trapping the required packets to the CPU.
> 
> However, having a 3.2/6.4/12.8 Tbps ASIC (it keeps growing all the time)
> send traffic to the CPU can very easily result in denial of service. You
> need to have hardware policers and classification to different traffic
> classes ensuring the system remains functional regardless of the havoc
> happening in the offloaded data path.

I don't see how that's only applicable to a switch ASIC, though.
Ingress classification, and rate limiting applies to any network 
system.

> This control plane policy has been hard coded in mlxsw for a few years
> now (based on sane defaults), but it obviously does not fit everyone's
> needs. Different users have different use cases and different CPUs
> connected to the ASIC. Some have Celeron / Atom while others have more
> high-end Xeon CPUs, which are obviously capable of handling more packets
> per second. You also have zero visibility into how many packets were
> dropped by these hardware policers.

There are embedded Atom systems out there with multi-gig interfaces,
they obviously can't ingest peak traffic, doesn't matter whether they
are connected to a switch ASIC or a NIC.

> By exposing these traps we allow users to tune these policers and get
> visibility into how many packets they dropped. In the future also
> changing their traffic class, so that (for example), packets hitting
> local routes are scheduled towards the CPU before packets dropped due to
> ingress VLAN filter.
> 
> If you don't have any special needs you are probably OK with the
> defaults, in which case you don't need to do anything (no special
> sauce).

As much as traps which forward traffic to the CPU fit the switch
programming model, we'd rather see a solution that offloads constructs
which are also applicable to the software world.

Sniffing dropped frames to troubleshoot is one thing, but IMHO traps
which default to "trap" are a bad smell.
