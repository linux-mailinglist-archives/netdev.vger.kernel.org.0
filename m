Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CF5380A0A
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 15:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhENNBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 09:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhENNBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 09:01:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C44C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 06:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KDmoL/PICwH0qpSvIByP4TbOr9/b6+oGluUGWMZZRYk=; b=xyTVk0YPxXQEse69+Y5OMqxVe
        c7EaOUGmOmVyL4b5S0sOQq3BbcbK14YKKfvTc4DmFLrN9dhhKXe4CUiyKezeNYfZ0mckIYm8gx6qo
        FYDpW9DUwfyw0+VvZMaRJgEBVLpDuE1XEtCo3jnj2QlDxrZlruiLv69JqLoFivXUyLSGwvaCQRxXa
        6DI9x1N12bAhE7Lf6w+T5rSPaEzQxMxNKewM/WIcREKG3ogaHaHLX6c4mGsfKzbMny1tt9Gbl47hr
        bqigh0sjHVOv6TsWqqkBKFWHLKxT3pqJGE8to4zq8icQg2X2ERU4Duje3qufKuVpA9ZwZoI9fu54P
        NkSoILCUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43970)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhXQR-0008Av-HI; Fri, 14 May 2021 14:00:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhXQQ-00041P-DA; Fri, 14 May 2021 14:00:18 +0100
Date:   Fri, 14 May 2021 14:00:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: mvpp2: incorrect max mtu?
Message-ID: <20210514130018.GC12395@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

While testing out the 10G speeds on my Macchiatobin platforms, the first
thing I notice is that they only manage about 1Gbps at a MTU of 1500.
As expected, this increases when the MTU is increased - a MTU of 9000
works, and gives a useful performance boost.

Then comes the obvious question - what is the maximum MTU.

#define MVPP2_BM_JUMBO_FRAME_SIZE       10432   /* frame size 9856 */

So, one may assume that 9856 is the maximum. However:

# ip li set dev eth0 mtu 9888
# ip li set dev eth0 mtu 9889
Error: mtu greater than device maximum.

So, the maximum that userspace can set appears to be 9888. If this is
set, then, while running iperf3, we get:

mvpp2 f2000000.ethernet eth0: bad rx status 9202e510 (resource error), size=9888

So clearly this is too large, and we should not be allowing userspace
to set this large a MTU.

At this point, it seems to be impossible to regain the previous speed of
the interface by lowering the MTU. Here is a MTU of 9000:

[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.37 MBytes  11.5 Mbits/sec   40   17.5 KBytes       
[  5]   1.00-2.00   sec  1.25 MBytes  10.5 Mbits/sec   39   8.74 KBytes       
[  5]   2.00-3.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes       
[  5]   3.00-4.00   sec  1.13 MBytes  9.45 Mbits/sec   39   8.74 KBytes       
[  5]   4.00-5.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes       
[  5]   5.00-6.00   sec  1.28 MBytes  10.7 Mbits/sec   39   8.74 KBytes       
[  5]   6.00-7.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes       
[  5]   7.00-8.00   sec  1.25 MBytes  10.5 Mbits/sec   39   8.74 KBytes       
[  5]   8.00-9.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes       
[  5]   9.00-10.00  sec  1.13 MBytes  9.45 Mbits/sec   39   8.74 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  11.9 MBytes  9.99 Mbits/sec  379             sender
[  5]   0.00-10.00  sec  11.7 MBytes  9.80 Mbits/sec                  receiver

Whereas before the test, it was:

[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   729 MBytes  6.11 Gbits/sec
[  5]   1.00-2.00   sec   719 MBytes  6.03 Gbits/sec
[  5]   2.00-3.00   sec   773 MBytes  6.49 Gbits/sec
[  5]   3.00-4.00   sec   769 MBytes  6.45 Gbits/sec
[  5]   4.00-5.00   sec   779 MBytes  6.54 Gbits/sec
[  5]   5.00-6.00   sec   784 MBytes  6.58 Gbits/sec
[  5]   6.00-7.00   sec   777 MBytes  6.52 Gbits/sec
[  5]   7.00-8.00   sec   774 MBytes  6.50 Gbits/sec
[  5]   8.00-9.00   sec   769 MBytes  6.45 Gbits/sec
[  5]   9.00-10.00  sec   774 MBytes  6.49 Gbits/sec
[  5]  10.00-10.00  sec  3.07 MBytes  5.37 Gbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  7.47 GBytes  6.41 Gbits/sec                  receiver

(this is on the server end of iperf3, the others are the client end,
but the results were pretty very similar to that.)

So, clearly something bad has happened to the buffer management as a
result of raising the MTU so high.

As the end which has suffered this issue is the mcbin VM host, I'm not
currently in a position I can reboot it without cause major disruption
to my network. However, thoughts on this (and... can others reproduce
it) would be useful.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
