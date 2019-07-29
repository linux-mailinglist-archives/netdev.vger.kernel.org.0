Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E9E7844D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 07:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfG2FB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 01:01:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfG2FB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 01:01:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B4AEB6030E; Mon, 29 Jul 2019 05:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564376485;
        bh=mIl0s08L7PkWOZYSA0TvcEa/OieZYgjExvg6P8P+lCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZEUyHitlrJiUW4ROToV45adY2H51/pDubzbOjmU1k5S5r9nFjW9TULJv3pDo9KjjK
         wD0oDoarJTpUSfke7chy7NtybbBWN2fStcgWoJ4kQod9UHzsYXWIo5ni7dTYnAilb+
         MuUsBNw7XH1LCDQGZpjCWWZ0dY/rqaLukEehiSig=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id E1BD96030E;
        Mon, 29 Jul 2019 05:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564376484;
        bh=mIl0s08L7PkWOZYSA0TvcEa/OieZYgjExvg6P8P+lCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mo4++OukuoACyl7UMTY7E16qw8N1TkxYHCxpuvYRLuDJTZiuXeWW0QNXVLK7DFY1k
         id0oIh6tq5VwoceK1hYZ58fecBe23u0UmYwoy6pN/ZtvDZ2prapYm8WH8v5Txe9CM4
         2feOz+CX8sfShMqZcu0ZN8F5LTLmQMvxcJb/W7E0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Jul 2019 13:01:24 +0800
From:   xiaofeis@codeaurora.org
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, vkoul@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH v3] net: dsa: qca8k: enable port flow control
In-Reply-To: <20190728223114.GD23125@lunn.ch>
References: <1564275470-52666-1-git-send-email-xiaofeis@codeaurora.org>
 <20190728223114.GD23125@lunn.ch>
Message-ID: <fa444b03b42a2cb72037bc73a62f1976@codeaurora.org>
X-Sender: xiaofeis@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-29 06:31, Andrew Lunn wrote:
> On Sun, Jul 28, 2019 at 08:57:50AM +0800, xiaofeis wrote:
>> Set phy device advertising to enable MAC flow control.
> 
> Hi Xiaofei.
> 
> This is half of the needed change for MAC flow control.
> 
> phy_support_asym_pause(phy) is used by the MAC to tell the PHY layer
> that the MAC supports flow control. The PHY will then advertise
> this. When auto-negotiation is completed, the PHY layer will call
> qca8k_adjust_link() with the results. It could be that the peer does
> not support flow control, or only supports symmetric flow control.  So
> in that function, you need to program the MAC with the results of the
> auto-neg. This is currently missing. You need to look at phydev->pause
> and phydev->asym_pause to decide how to configure the MAC.
> 
>        Andrew
Hi Andrew

You are correct. With the change, the auto-negotiation result still 
depends on the peer.

But our qca8k HW can auto sync the pause status to MAC from phy with the 
auto-negotiated result.
So no need to set in qca8k_adjust_link, since there is one setting in 
qca8k_port_set_status: mask |= QCA8K_PORT_STATUS_LINK_AUTO;

This change's purpose is to keep enable advertise on our side.

Thanks
Xiaofeis
