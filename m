Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBC13D3166
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 03:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhGWBLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 21:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhGWBLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 21:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FFAF60E9A;
        Fri, 23 Jul 2021 01:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627005126;
        bh=Rwbw1sOVz9TTJkfGdYwua+FtUGhD34/Z+trs/39qEes=;
        h=Date:From:To:Cc:Subject:From;
        b=UF9vYuDE0TH2fyE/y9rLrqDFSr0aDOI+3XNCHBwOO7fYka+j1+oBRGtklGiHSy1BO
         estVtn4JluyDqRrK6qHPfhB3jEAWWNXSD+zxPOZN6wTVksl6a6uIfyepWCwwDxfaeB
         C49qONKgQ0RUFbFIGGcvEBtMJybr66Uc/tV+pXp9NF8d254qOsIIvf4LDwyU8roAWX
         IWkHVc2nxqNy9VWgiIXrdi8O/DgNygWMZVFIDWR05SCY4Q+X/9lP+514NLkejbDGXq
         zH9YCjNbkxJMTNd2uuUE3Rv3bWJ4ZGal+rCgZMUEFO10ETKfSwLBByXnGG5eUFuIjQ
         XONaAGHivnazQ==
Date:   Fri, 23 Jul 2021 03:52:02 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: mvpp2 switch from gmac to xlg requires ifdown/ifup
Message-ID: <20210723035202.09a299d6@thinkpad>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell (and possibly others),

I discovered that with mvpp2 when switching from gmac (sgmii or
2500base-x mode) to xlg (10gbase-r mode) due to phylink requesting this
change, the link won't come up unless I do
  ifconfig ethX down
  ifconfig ethX up

Can be reproduced on MacchiatoBIN:
1. connect the two 10g RJ-45 ports (88X3310 PHY) with one cable
2. bring the interfaces up
3. the PHYs should link in 10gbase-t, links on MACs will go up in
   10gbase-r
4. use ethtool on one of the interfaces to advertise modes only up to
   2500base-t
5. the PHYs will unlink and then link at 2.5gbase-t, links on MACs will
   go up in 2500base-x
6. use ethtool on the same interface as in step 4 to advertise all
   supported modes

7. the PHYs will unlink and then link at 10gbase-t, BUT MACs won't link
   !!!
8. execute
     ifconfig ethX down ; ifconfig ethX up
   on both interfaces. After this, the MACs will successfully link in
   10gbase-r with the PHYs

It seems that the mvpp2 driver code needs to make additional stuff when
chaning mode from gmac to xlg. I haven't yet been able to find out
what, though.

BTW I discovered this because I am working on adding support for
5gbase-r mode to mvpp2, so that the PHY can support 5gbase-t on copper
side.
The ifdown/ifup cycle is required when switching from gmac to xlg, i.e.:
	sgmii		to	5gbase-r
	sgmii		to	10gbase-r
	2500base-x	to	5gbase-r
	2500base-x	to	10gbase-r
but also when switching from xlg to different xlg:
	5gbase-r	to	10gbase-r
	10gbase-r	to	5gbase-r

Did someone notice this bug? I see that Russell made some changes in
the phylink pcs API that touched mvpp2 (the .mac_config method got
split into .mac_prepare, .mac_config and .mac_finish, and also some
other changes). I haven't tried yet if the switch from gmac to xlg
worked at some time in the past. But if it did, maybe these changes
could be the cause?

Marek
