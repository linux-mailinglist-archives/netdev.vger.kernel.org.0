Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890A911C87E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 09:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfLLIut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 03:50:49 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36228 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfLLIut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 03:50:49 -0500
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 39905440159;
        Thu, 12 Dec 2019 10:50:46 +0200 (IST)
Date:   Thu, 12 Dec 2019 10:50:45 +0200
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
References: <87tv67tcom.fsf@tarshish>
 <20191211131111.GK16369@lunn.ch>
 <87fthqu6y6.fsf@tarshish>
 <20191211174938.GB30053@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211174938.GB30053@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Dec 11, 2019 at 06:49:38PM +0100, Andrew Lunn wrote:
> > Bisect points at 7fb5a711545d ("net: dsa: mv88e6xxx: drop adjust_link to
> > enabled phylink"). Reverting this commit on top of v5.3.15 fixes the
> > issue (and brings the warning back). As I understand, this basically
> > reverts the driver migration to phylink. What might be the issue with
> > phylink?
> 
> That suggests the MAC is wrongly running at 1G, and the PHY at 100M,
> which is why it does not work.

I reproduced the same issue with 1Gb link as well:

[   63.510782] mv88e6085 f412a200.mdio-mii:04 lan1: Link is Up - 1Gbps/Full - flow control rx/tx
[   63.519357] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready

> You probably want to add #define DEBUG to the top of phylink.c, and
> scatter some debug prints in mv88e6xxx_mac_config(). My guess would
> be, either mv88e6xxx_mac_config() is existing before configuring the
> MAC, or mv88e6xxx_port_setup_mac() has wrongly decided nothing has
> changed and so has not configured the MAC.

As you guessed, mv88e6xxx_mac_config() exits early because 
mv88e6xxx_phy_is_internal() returns true for port number 2, and 'mode' is 
MLO_AN_PHY. What is the right MAC/PHY setup flow in this case?

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
