Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F415C346E52
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhCXAqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:46:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43800 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230465AbhCXAod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:44:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOrd9-00CgG6-Tb; Wed, 24 Mar 2021 01:44:15 +0100
Date:   Wed, 24 Mar 2021 01:44:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <YFqLX+o2n2qRVW8M@lunn.ch>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <YFnh4dEap/lGX4ix@lunn.ch>
 <87a6qulybz.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6qulybz.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This was my initial approach. It gets quite messy though. Since taggers
> can be modules, there is no way of knowing if a supplied protocol name
> is garbage ("asdf"), or just part of a module in an initrd that is not
> loaded yet when you are probing the tree.

Hi Tobias

I don't think that is an issue. We currently lookup the tagger in
dsa_port_parse_cpu(). If it does not exist, we return
-EPROBE_DEFER. Either it eventually gets loaded, or the driver core
gives up. I don't see why the same cannot be done for a DT
property. If dsa_find_tagger_by_name() does not find the tagger return
-EPROBE_DEFER. Garbage will result in the switch never loading, and
the DT writer will go find their typo.

> Even when the tagger is available, there is no way to verify if the
> driver is compatible with it.

I would of though, calling the switch drivers change_tag_protocol() op
will that for you. If it comes back with -EINVAL, or -EOPNOTSUPP, you
know it is not compatible.

So i guess i would keep all the code you are adding here to allow
dynamic setting of the protocol. And add more code in
dsa_switch_parse_of() to parse the optional tagging protocol name,
error out -EPROBE_DEFER if it is not known yet, otherwise store it
away in something like dst->tag_ops_name. And then probably in
dsa_switch_setup(), if dst->tag_ops_name is not NULL, invoke the
dynamic change code to perform the actual change.

	Andrew
