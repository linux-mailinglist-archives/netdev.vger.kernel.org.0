Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9746F2FA7EE
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436649AbhARRv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:51:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46410 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407331AbhARRv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:51:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1Yft-001JgP-OU; Mon, 18 Jan 2021 18:50:45 +0100
Date:   Mon, 18 Jan 2021 18:50:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning
 for DSA and CPU ports)
Message-ID: <YAXKdWL9CdplNrtm@lunn.ch>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk>
 <87h7nhlksr.fsf@waldekranz.com>
 <af05538b-7b64-e115-6960-0df8e503dde3@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af05538b-7b64-e115-6960-0df8e503dde3@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I suppose the real solution is having userspace do some "bridge mdb add"
> yoga, but since no code currently uses
> MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT, I don't think there's any
> way to actually achieve this. And I have no idea how to represent the
> requirement that "frames with this multicast DA are only to be directed
> at the CPU" in a hardware-agnostic way.

The switchdev interface for this exists, because there can be
multicast listeners on the bridge. When they join a group, they ask
the switch to put in a HOST MDB, which should cause the traffic for
the group to be sent to the host. What you don't have is the
exclusivity. If there is an IGMP report for the DA received on another
port, IGMP snooping will add an MDB entry to forward traffic out that
port.

	Andrew
