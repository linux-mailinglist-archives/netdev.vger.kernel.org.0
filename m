Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B612708C1
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 00:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIRWK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 18:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRWK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 18:10:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56C7C0613CE;
        Fri, 18 Sep 2020 15:10:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3C9715A1189E;
        Fri, 18 Sep 2020 14:54:09 -0700 (PDT)
Date:   Fri, 18 Sep 2020 15:10:55 -0700 (PDT)
Message-Id: <20200918.151055.62730126907662149.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     geert+renesas@glider.be, hkallweit1@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, kuba@kernel.org,
        gaku.inami.xh@renesas.com, yoshihiro.shimoda.uh@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7bfebfdc0d7345c4612124ff00e20eebb0ff6cd9.camel@kernel.org>
References: <20200901150237.15302-1-geert+renesas@glider.be>
        <7bfebfdc0d7345c4612124ff00e20eebb0ff6cd9.camel@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:54:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Fri, 18 Sep 2020 10:58:49 -0700

> On Tue, 2020-09-01 at 17:02 +0200, Geert Uytterhoeven wrote:
>> @@ -158,7 +158,7 @@ static void linkwatch_do_dev(struct net_device
>> *dev)
>>  	clear_bit(__LINK_STATE_LINKWATCH_PENDING, &dev->state);
>>  
>>  	rfc2863_policy(dev);
>> -	if (dev->flags & IFF_UP && netif_device_present(dev)) {
>> +	if (dev->flags & IFF_UP) {
> 
> So with your issue the devices is both IFF_UP and !present ? how so ?
> I think you should look into that.
> 
> I am ok with removing the "dev present" check from here just because we
> shouldn't  be expecting IFF_UP && !present .. such thing must be a bug
> somewhere else.

Indeed, this is why I just asked in another email why a link change event
is firing for a device which hasn't fully resumed and marked itself as
"present" yet.

More and more I think this is a driver or PHY layer bug.
