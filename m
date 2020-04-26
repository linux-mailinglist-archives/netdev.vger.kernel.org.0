Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA391B9466
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 00:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDZWHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 18:07:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37000 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgDZWHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 18:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BAv8SBLhkChwDv/VhOV6LMwLTBU0QCR5l8tZnM4FPJg=; b=SwhDCQAGolAooFyy2lXSFInvU6
        8yGKgjdIa50zhtXlRxr1er/jx0d4xosB4OX0OF9lk0bSpVoPLLuV/QKXR8ojSqCtGDk9zEnfz41bN
        4yWb+fi9SMWPXPg/cPj6kfpBg+PjDpoNxaLVuroTuDLxERbnTjJ4lMokS99HK4CPO0dA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSpQg-0055VZ-R2; Mon, 27 Apr 2020 00:07:14 +0200
Date:   Mon, 27 Apr 2020 00:07:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v1 2/9] net: phy: Add support for polling cable
 test
Message-ID: <20200426220714.GA1212378@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-3-andrew@lunn.ch>
 <7557316a-fc27-ac05-6f6d-b9bac81afd82@gmail.com>
 <20200425201014.GF1088354@lunn.ch>
 <52b62cec-cb65-03a4-f5c2-e36d0d0ff8d3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52b62cec-cb65-03a4-f5c2-e36d0d0ff8d3@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > At least with the Marvell PHY, there is no documented way to tell it
> > to abort a cable test. So knowing the user space has lost interest in
> > the results does not help us.
> 
> The same is true with Broadcom PHYs, but I think we should be guarding
> somehow against the PHY state machine being left in PHY_CABLETEST state
> with no other way to recover than do an ip link set down/up in order to
> recover it. We can try to tackle this as an improvement later on.

I did wonder about setting a big timeout in the core. If after 20
seconds it has not returned any results, we probably need to move to
the error state? But that only works for polling. For interrupt driven
PHYs we don't have any sort of timer, we would need to add more
infrastructure to the core.

If the PHY never completed the cable test, we are probably in the land
of driver bugs, and how do we recover from that?

    Andrew
