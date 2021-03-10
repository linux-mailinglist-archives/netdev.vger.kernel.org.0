Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22684333280
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhCJAhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:37:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48560 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhCJAhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 19:37:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJmqN-00A5qf-Qs; Wed, 10 Mar 2021 01:36:55 +0100
Date:   Wed, 10 Mar 2021 01:36:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC net] net: dsa: Centralize validation of VLAN configuration
Message-ID: <YEgUp0E9uCtBjP5I@lunn.ch>
References: <20210309184244.1970173-1-tobias@waldekranz.com>
 <699042d3-e124-7584-6486-02a6fb45423e@gmail.com>
 <87h7lkow44.fsf@waldekranz.com>
 <20210309220119.t24sdc7cqqfxhpfb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309220119.t24sdc7cqqfxhpfb@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > .100  br0  .100
> >    \  / \  /
> >    lan0 lan1
> > 
> > $ ip link add dev br0 type bridge vlan_filtering 1
> > $ ip link add dev lan0.100 link lan0 type vlan id 100
> > $ ip link add dev lan1.100 link lan1 type vlan id 100
> > $ ip link set dev lan0 master br0
> > $ ip link set dev lan1 master br0 # This should fail

> > 
> > .100  br0
> >    \  / \
> >    lan0 lan1
> > 
> > $ ip link add dev br0 type bridge vlan_filtering 1
> > $ ip link add dev lan0.100 link lan0 type vlan id 100
> > $ ip link set dev lan0 master br0
> > $ ip link set dev lan1 master br0
> > $ bridge vlan add dev lan1 vid 100 # This should fail
> 
> diff --git a/tools/testing/selftests/drivers/net/dsa/vlan_validation.sh b/tools/testing/selftests/drivers/net/dsa/vlan_validation.sh

Hi Vladimir

Cool to see self tests.

> new file mode 100755
> index 000000000000..445ce17cb925
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/dsa/vlan_validation.sh
> @@ -0,0 +1,316 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +NUM_NETIFS=2
> +lib_dir=$(dirname $0)/../../../net/forwarding
> +source $lib_dir/lib.sh
> +
> +eth0=${NETIFS[p1]}
> +eth1=${NETIFS[p2]}

Could these be called lan0 and lan1, so they match the diagrams?  I
find eth0 confusing, since that is often the master interface, not a
slave interface.

      Andrew
