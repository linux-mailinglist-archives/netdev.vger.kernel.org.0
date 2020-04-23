Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65831B5CAD
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgDWNgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:36:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:45870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgDWNgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 09:36:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 24A15AC44;
        Thu, 23 Apr 2020 13:36:52 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E38C6602EE; Thu, 23 Apr 2020 15:36:49 +0200 (CEST)
Date:   Thu, 23 Apr 2020 15:36:49 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Yi Zhao <yi.zhao@windriver.com>, linville@tuxdriver.com
Subject: Re: ethtool -s always return 0 even for errors
Message-ID: <20200423133649.GF6778@lion.mk-sys.cz>
References: <20200423094547.2066-1-yi.zhao@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423094547.2066-1-yi.zhao@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 05:45:47PM +0800, Yi Zhao wrote:
> The ethtool -s returns 0 when it fails with an error (stderr):
> 
> $ ethtool -s eth0 duplex full
> Cannot advertise duplex full
> $ echo $?
> 0
> $ ethtool -s eth0 speed 10
> Cannot advertise speed 10
> $ echo $?
> 0

These two are not really errors, just warnings. According to comments in
the code, the idea was that requesting speed and/or duplex with
autonegotiation enabled (either already enabled or requested to be
enabled) and no explicit request for advertised modes (no "advertise"
keyword), ethtool should enable exactly the modes (out of those
supported by the device) which match requested speed and/or duplex
value(s). The messages you see above are warnings that this logic is not
implemented and all parameters are just passed to kernel and probably
ignored (depends on the driver).

Actually, with kernel 5.6 (with CONFIG_ETHTOOL_NETLINK=y) and ethtool
built from git (or 5.6 once released), these commands work as expected:

lion:/home/mike/work/git/ethtool # ./ethtool eth0
Settings for eth0:
...
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
...
        Auto-negotiation: on
...
lion:/home/mike/work/git/ethtool # ./ethtool -s eth0 speed 100
lion:/home/mike/work/git/ethtool # ./ethtool eth0
Settings for eth0:
...
        Advertised link modes:  100baseT/Half 100baseT/Full
...
lion:/home/mike/work/git/ethtool # ./ethtool -s eth0 duplex full
lion:/home/mike/work/git/ethtool # ./ethtool eth0
Settings for eth0:
...
        Advertised link modes:  10baseT/Full
                                100baseT/Full
                                1000baseT/Full
...
lion:/home/mike/work/git/ethtool # ./ethtool -s eth0 speed 100 duplex full
lion:/home/mike/work/git/ethtool # ./ethtool eth0
Settings for eth0:
...
        Advertised link modes:  100baseT/Full
...

> $ ethtool -s eth1 duplex full
> Cannot get current device settings: No such device
>   not setting duplex
> $ echo $?
> 0

The problem here is that for historical reasons, "ethtool -s" may issue
up to three separate ioctl requests (or up to four netlink requests with
new kernel and ethtool), depending on which parameters you request on
command line. Each of them can either succeed or fail and you can even
see multiple error messages:

lion:/home/mike/work/git/ethtool # ethtool -s foo phyad 3 wol um msglvl 7
Cannot get current device settings: No such device
  not setting phy_address
Cannot get current wake-on-lan settings: No such device
  not setting wol
Cannot get msglvl: No such device

Currently, do_sset() always returns 0. While it certainly feels wrong to
return 0 if all requests fail (including your case where there was only
one request and it failed), it is much less obvious what should we
return if some of the requests succeed and some fail.

Michal
