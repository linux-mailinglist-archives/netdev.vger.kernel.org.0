Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6E2761C9
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgIWUPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgIWUPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:15:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3691C0613CE;
        Wed, 23 Sep 2020 13:15:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 209A111E3E4CA;
        Wed, 23 Sep 2020 12:58:43 -0700 (PDT)
Date:   Wed, 23 Sep 2020 13:15:29 -0700 (PDT)
Message-Id: <20200923.131529.637266321442993059.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     saeed@kernel.org, geert+renesas@glider.be, f.fainelli@gmail.com,
        andrew@lunn.ch, kuba@kernel.org, gaku.inami.xh@renesas.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <14f41724-ce45-c2c0-a49c-1e379dba0cb5@gmail.com>
References: <3d9176a6-c93e-481c-5877-786f5e6aaef8@gmail.com>
        <28da797abe486e783547c60a25db44be0c030d86.camel@kernel.org>
        <14f41724-ce45-c2c0-a49c-1e379dba0cb5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 12:58:43 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 23 Sep 2020 21:58:59 +0200

> On 23.09.2020 20:35, Saeed Mahameed wrote:
>> Why would a driver detach the device on ndo_stop() ?
>> seems like this is the bug you need to be chasing ..
>> which driver is doing this ? 
>> 
> Some drivers set the device to PCI D3hot at the end of ndo_stop()
> to save power (using e.g. Runtime PM). Marking the device as detached
> makes clear to to the net core that the device isn't accessible any
> longer.

That being the case, the problem is that IFF_UP+!present is not a
valid netdev state.

Is it simply the issue that, upon resume, IFF_UP is marked true before
the device is brought out from D3hot state and thus marked as present
again?
