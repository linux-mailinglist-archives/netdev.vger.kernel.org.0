Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DE22BA058
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 03:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgKTCZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 21:25:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbgKTCZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 21:25:44 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfw7I-008333-JR; Fri, 20 Nov 2020 03:25:40 +0100
Date:   Fri, 20 Nov 2020 03:25:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Greg Ungerer <gerg@kernel.org>,
        Alex Dewar <alex.dewar90@gmail.com>,
        Chuanhong Guo <gch981213@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: support setting ageing
 time
Message-ID: <20201120022540.GD1804098@lunn.ch>
References: <20201119064020.19522-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119064020.19522-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 02:40:20PM +0800, DENG Qingfang wrote:
> MT7530 has a global address age control register, so use it to set
> ageing time.
> 
> The applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 41 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/mt7530.h | 13 +++++++++++++
>  2 files changed, 54 insertions(+)
> 
> RFC:
> 1. What is the expected behaviour if the timer is too big or too small?
>    - return -ERANGE or -EINVAL;

ERANGE is good. 

>      or
>    - if it is too big, apply the maximum value; if it is too small,
>      disable learning;
> 
> 2. Is there a better algorithm to find the closest pair?

The bridge code will default to 300 seconds. And after a topology
change, it sets it to 2 * the forwarding delay, which defaults to 15
seconds. So maybe you can look for these two values, and use
pre-computed values?

You still need to handle other values, the user can configure these.

	     Andrew
