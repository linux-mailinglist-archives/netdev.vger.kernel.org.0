Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D1BC7DE
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440880AbfIXMbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 08:31:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34468 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395274AbfIXMbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 08:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pc6TTZ5cVNiYrtnu/TOBn6xj1asel6LNNNrlQf6OXy0=; b=jU9Af4UMsKcdOy/XrNka9wvtsp
        MujgFqUmo6D/SILxZ5r7sQbiiILsiXn8gKmHXJFOQj2ojAgZenLPtezcVbzviCgDC6X6geO7kEo5g
        ryLFGv9UNeUP2b++CoQAaTCZFiTwDV6ab3GnTxfdf61BLnz7nt/eEtmDimDJ+XoOz/Js=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iCjyY-0004E6-J7; Tue, 24 Sep 2019 14:31:26 +0200
Date:   Tue, 24 Sep 2019 14:31:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference in
 phy_support_asym_pause
Message-ID: <20190924123126.GE14477@lunn.ch>
References: <573ffa6a-f29a-84d9-5895-b3d6cc389619@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <573ffa6a-f29a-84d9-5895-b3d6cc389619@ysoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 01:27:24PM +0200, Michal Vokáč wrote:
> Hi,
> 
> just tried booting latest next-20190920 on our imx6dl-yapp4-hydra platform
> with QCA8334 switch and got this:
> 
> [    7.424620] [<806840e0>] (phy_support_asym_pause) from [<80686724>] (qca8k_port_enable+0x40/0x48)
> [    7.436911] [<806866e4>] (qca8k_port_enable) from [<80a74134>] (dsa_port_enable+0x3c/0x6c)
> [    7.448629]  r7:00000000 r6:e88a02cc r5:e812d090 r4:e812d090
> [    7.457708] [<80a740f8>] (dsa_port_enable) from [<80a730bc>] (dsa_register_switch+0x798/0xacc)
> [    7.469833]  r5:e812d0cc r4:e812d090

Hi Michal

Please could you add a printk to verify it is the CPU port, and that
in qca8k_port_enable() phy is a NULL pointer.

I think the fix is going to look something like:

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 16f15c93a102..86c80a873e30 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -939,7 +939,8 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
        qca8k_port_set_status(priv, port, 1);
        priv->port_sts[port].enabled = 1;
 
-       phy_support_asym_pause(phy);
+       if (phy)
+               phy_support_asym_pause(phy);
 
        return 0;
 }

But i want to take a closer look at what priv->port_sts[port].enabled
= 1; does. Also, if there are any other port_enable() functions which
always assume a valid phy device.

       Andrew
