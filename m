Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D203413098
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 11:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhIUJNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 05:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhIUJNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 05:13:38 -0400
X-Greylist: delayed 554 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Sep 2021 02:12:10 PDT
Received: from outbound.soverin.net (outbound.soverin.net [IPv6:2a01:4f8:fff0:2d:8::215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785D5C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 02:12:10 -0700 (PDT)
Received: from smtp.freedom.nl (unknown [10.10.3.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by outbound.soverin.net (Postfix) with ESMTPS id 25381604C4;
        Tue, 21 Sep 2021 09:02:54 +0000 (UTC)
Received: from smtp.freedom.nl (smtp.freedom.nl [116.202.127.71]) by soverin.net
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=blackstar.nl;
        s=soverin; t=1632214972;
        bh=rzSNdBWpJJWbpETdmcQ6nTlPVvPcVEzsKoXLVzNqt9g=;
        h=To:From:Subject:Cc:Date:From;
        b=gXFE3r258eC69pAZTpTj0vjshzvdkfYc2YASyRu3OQ+KZkNdVs58sOI28VrSZm/RI
         7Fvzh5JrOhh4fgxiJYXDpJnBJKsebJL7Fg5qxLzW7fGjpB7kVblGrgkXZ+HvrA67Lp
         ZDnE/dm3d5fNqd1QeJkzKHgJoC+5NoTasBm1KXWMUgRF+9SdZYdp164I4+evSTFA9a
         SWCNZl59+iv8AJQETq3plRE7Zlxwphbh2ULKpBkMpusQJR+mF2mc5jVsJ3+evecwas
         yD39dgPRDhPevh+kC4ZjDD0ld7Gzoh0JF0Surs3bQXJ7bcXUFvzmvIbi6Iiov9O8i6
         FWfoqWXFCrFdg==
Received: from [IPv6:2a10:3781:1f:1:2cc5:504d:ee92:38f6] (unknown [IPv6:2a10:3781:1f:1:2cc5:504d:ee92:38f6])
        by mail.blackstar.nl (Postfix) with ESMTPSA id 12BD969153;
        Tue, 21 Sep 2021 11:02:44 +0200 (CEST)
To:     netdev@vger.kernel.org
From:   Bas Vermeulen <bvermeul@blackstar.nl>
Subject: mv88e6xxx: 88ae6321 not learning bridge mac address
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com
Message-ID: <e58f4594-b73b-6681-cb2e-fa1ce56f22e1@blackstar.nl>
Date:   Tue, 21 Sep 2021 11:02:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
X-Clacks-Overhead: GNU Terry Pratchett
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am working on a custom i.MX8 board using a Marvell 88ae6321 switch. 
We're not using the latest kernel unfortunately, but 5.4.70 with patches 
from NXP and ourselves.

The switch is connected as follows:

CPU - fec ethernet -> 88ae6321 on port 5, with external PHYs on port 1, 
2 and 6, and using the internal PHY on port 3 and 4.

We set up a bridge with swp1, swp2, swp3, swp4, and swp6. Traffic from 
the various ports all learn correctly, with the exception of the bridge 
itself (and probably the CPU port?).

If I ping the bridge address from one of the clients, the switch floods 
the ping request to all ports.
If I ping a client from the bridge address, the ping request goes to 
that client, the reply goes to all connected ports. This also happens if 
I use iperf3 to test the bandwidth, and will limit the bandwidth 
available when sending from the client to the lowest link on the switch.

Anyone have an idea how to fix this? It's possible I've misconfigured 
something, but I'm not sure what it could be. If there is a way to teach 
the 88ae6321 that a mac address is available on the CPU port, that would 
fix it, for instance. I tried adding the switch mac address with bridge 
fdb add, but that didn't work.

Regards,

Bas Vermeulen


