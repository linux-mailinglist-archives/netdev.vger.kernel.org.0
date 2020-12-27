Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D972E30A3
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 10:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgL0JrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 04:47:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:54786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgL0JrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 04:47:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ED3A0AEB6;
        Sun, 27 Dec 2020 09:46:33 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 84B0C603AA; Sun, 27 Dec 2020 10:46:33 +0100 (CET)
Date:   Sun, 27 Dec 2020 10:46:33 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Bruce LIU <ccieliu@gmail.com>
Cc:     netdev@vger.kernel.org, shlei@cisco.com
Subject: Re: "ethtool" missing "master-slave" args in "do_sset"
 function.[TEXT/PLAIN]
Message-ID: <20201227094633.GA5267@lion.mk-sys.cz>
References: <d7196d65-c994-2e19-d41c-386a4957ac63@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7196d65-c994-2e19-d41c-386a4957ac63@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 27, 2020 at 12:34:09PM +0800, Bruce LIU wrote:
> Hi Michal Kubecek and Network dev team,
> 
> Good day! Hope you are doing well.
> This is Bruce from China, and please allow me to cc Rudy from Cisco Systems
> in China team.
> 
> We are facing a weird behavior about "master-slave configuration" function
> in ethtool.
> Please correct me if I am wrong....
> 
> As you know, start from ethtool 5.8,  "master/slave configuration support"
> added.
> https://lwn.net/Articles/828044/
> 
> ========================================================================
> Appeal:
> Confirm and discuss workaround
> 
> ========================================================================
> Issue description:
> As we test in lab, no "master-slave" option supported.
> 
> ========================================================================
> Issue reproduce:
> root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
> ethtool: bad command line argument(s)
> For more information run ethtool -h
> 
> ========================================================================
> Environment:
> debian-live-10.7.0-amd64-standard.iso
> Kernel 5.4.79

This is the problem. Kernel support for this feature was added in
5.8-rc1 so that your kernel does not have it and there is no chance it
could possibly work. Newer ethtool has support for this feature but
kernel must support it as well for it to actually work.

But I agree that the error message is misleading. We handle subcommands
supported only in netlink with proper error message when ioctl fallback
is used but we don't do the same for new parameters of existing
subcommands which are generally supported by ioctl code. That's why the
command line parser used by ioctl code does not recognize the new
parameter and handles it as a syntax error.

We'll need to handle new parameters in ioctl parser so that it produces
more meaningful error for parameters only supported via netlink. Long
term, the proper solution would probably be using one parser for both
netlink and ioctl but that was something I wanted to avoid for now to
reduce the risk of introducing subtle changes in behaviour of existing
code.

Michal
