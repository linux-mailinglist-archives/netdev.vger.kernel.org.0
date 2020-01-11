Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8631383EC
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgAKXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:10:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731642AbgAKXKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:10:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8434D15A0B602;
        Sat, 11 Jan 2020 15:10:31 -0800 (PST)
Date:   Sat, 11 Jan 2020 15:10:30 -0800 (PST)
Message-Id: <20200111.151030.80812382992588994.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 00/15] net: macsec: initial support for
 hardware offloading
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200111.150807.963654509739345915.davem@davemloft.net>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
        <20200111.150807.963654509739345915.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 11 Jan 2020 15:10:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 11 Jan 2020 15:08:07 -0800 (PST)

> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Date: Fri, 10 Jan 2020 17:19:55 +0100
> 
>> td;dr: When applying this series, do not apply patches 12 to 14.
>> 
>> This series intends to add support for offloading MACsec transformations
>> to hardware enabled devices. The series adds the necessary
>> infrastructure for offloading MACsec configurations to hardware drivers,
>> in patches 1 to 6; then introduces MACsec offloading support in the
>> Microsemi MSCC PHY driver, in patches 7 to 11.
>> 
>> The remaining 4 patches, 12 to 14, are *not* part of the series but
>> provide the mandatory changes needed to support offloading MACsec
>> operations to a MAC driver. Those patches are provided for anyone
>> willing to add support for offloading MACsec operations to a MAC, and
>> should be part of the first series adding a MAC as a MACsec offloading
>> provider.
> 
> You say four 4 patches, but 12 to 14 is 3.  I think you meant 12 to 15
> because 15 depends upon stuff added in 12 :-)
> 
> I applied everything except patch #7, which had the unnecessary phy
> exports, and also elided 12 to 15.

Actually I had to revert.

You are including net/macsec.h from a UAPI header, and that does not
work once userlance tries to use things.  And this even makes the
kernel build fail:

[davem@localhost net-next]$ make -s -j14
In file included from <command-line>:32:
./usr/include/linux/if_macsec.h:17:10: fatal error: net/macsec.h: No such file or directory
 #include <net/macsec.h>
          ^~~~~~~~~~~~~~
compilation terminated.
make[2]: *** [usr/include/Makefile:104: usr/include/linux/if_macsec.hdrtest] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.build:503: usr/include] Error 2
make: *** [Makefile:1693: usr] Error 2

Please fix this and respin.  And honestly just leave 12-15 out of the v6
submission, thanks.
