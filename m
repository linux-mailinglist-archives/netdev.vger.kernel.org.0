Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD48929D89B
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbgJ1WfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:35:19 -0400
Received: from lists.nic.cz ([217.31.204.67]:48266 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388183AbgJ1WfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:35:16 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 5627D1409C8;
        Wed, 28 Oct 2020 23:35:14 +0100 (CET)
Date:   Wed, 28 Oct 2020 23:35:07 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201028233507.68188398@nic.cz>
In-Reply-To: <87k0vbv84z.fsf@waldekranz.com>
References: <20201027105117.23052-1-tobias@waldekranz.com>
        <20201027160530.11fc42db@nic.cz>
        <20201027152330.GF878328@lunn.ch>
        <87k0vbv84z.fsf@waldekranz.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 19:25:16 +0100
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> .-----. TO_CPU, FORWARD .-----. TO_CPU, FORWARD .-----.
> |     +-----------------+     +-----------------+     |
> | CPU |                 | sw0 |                 | sw1 |
> |     +-----------------+     +-----------------+     |
> '-----'    FORWARD      '-+-+-'    FORWARD      '-+-+-'
>                           | |                     | |
>                        swp1 swp2               swp3 swp4
> 
> So the links selected as the CPU ports will see a marginally higher load
> due to all TO_CPU being sent over it. But the hashing is not that great
> on this hardware anyway (DA/SA only) so some imbalance is unavoidable.

The hashing is horrible :( On Turris Omnia we have 5 user ports and 2
CPU ports, and I suspect that for most of our users there is at most
one peer MAC address on the other side of an user port. So if such a
user has 5 devices connected to each switch port, there are 5 pairs of
(DA,SA), so 2^5 = 32 different assignments of (DA,SA) pairs to CPU
ports.

With probability 2/32 = 6.25% traffic from all 5 user ports would go via
one port,
with probability 10/32 = 31.25% traffic from 4 user ports would go via
one port.

That is not good balancing :)

Marek
