Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A920A21B5C1
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgGJNCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:02:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:37448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgGJNCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 09:02:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6609AD45;
        Fri, 10 Jul 2020 13:02:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4A97260567; Fri, 10 Jul 2020 15:02:51 +0200 (CEST)
Date:   Fri, 10 Jul 2020 15:02:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jerko Begic <JerkoB@supermicro.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ethtool - LLDP Not staying Persistent
Message-ID: <20200710130251.gn6vprhwom7dgtnb@lion.mk-sys.cz>
References: <ed1870073f754199b622ef26208c9eea@EX2013-MBX1.supermicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed1870073f754199b622ef26208c9eea@EX2013-MBX1.supermicro.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:20:15PM +0000, Jerko Begic wrote:
> Hello,
> 
> Not sure if this is the best way to reach out to ethtool team in
> regards to the issues but I came across this
> site<https://mirrors.edge.kernel.org/pub/software/network/ethtool/>
> and wanted to check if you are aware of LLDP not staying persistent
> when turned off using ethtool? Originally, we have filed a case with
> Intel, but they have pointed us to reach out to ethtool team.
> 
> We have customers that keep contacting us about the LLDP not staying
> persistent when using our Networking cards (as an example AOC-MTG-i4S:
> https://www.supermicro.com/en/products/accessories/addon/AOC-MTG-i4S.php).
> We did some testing on our side with the card above and this
> MB<https://www.supermicro.com/en/products/motherboard/X11DPT-B> :
> 
> First we check that disable-fw-lldp is set to off by default
> ethtool --show-priv-flags <port#>
> 
> Then go ahead and disable LLDP on the FW with command:
> ethtool --set-priv-flags <port#> disable-fw-lldp on
> 
> Reboot the system and check:
> ethtool --show-priv-flags <port#>
> 
> LLDP is OFF (same as default) but we need it to be persistent after
> the reboot and to be ON
> 
> Please let me know if anyone can help with this case... We have tried
> on multiple ethtool versions and the results are the same :(

This is not something that could be addressed in ethtool alone, not even
by general ethtool code in kernel. Private flags, their meaning and
implementation are determined by network device and its drivers.

Private flags are a black box from ethtool point of view: driver reports
the list of available flags for a device and implements querying and
viewing them; ethtool only serves as an interface between user and the
driver but the implementation and properties, including the persistency.

In general, most settings are not persistent; if you want them to
persist through reboots, the usual way to achieve that is to have some
init script (or service) that will set them on each boot. Some
distributions allow setting such parameters in their config files, e.g.
in openSUSE or SLE it's ETHTOOL_OPTIONS in /etc/sysconfig/network/ifcfg-*

Hope this helps
Michal


