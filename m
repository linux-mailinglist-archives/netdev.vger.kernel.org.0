Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AB012E803
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 16:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgABPVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 10:21:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgABPVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 10:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IdYA3gvWlF+j5uZXez7KuYc1OVhRo4qko1KG34K9Acw=; b=KMqWoFyek+invBAycpz5c8nKt+
        RJyDFaB7TQ3rR838gMTmqtWLs7oKZOPPrvOc/yKmHCLgtDB20L+EmV41bpjr6H6SC/dT/dDS6u7zh
        WqhaKSoneqGg781l9GR+CNr4Oi4ovWXU2LquDFWq6d6KpaH/iwwUUzUsbwEuutf4igGI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1in2IB-0007nb-M2; Thu, 02 Jan 2020 16:21:43 +0100
Date:   Thu, 2 Jan 2020 16:21:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai Heng Feng <kai.heng.feng@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
Subject: Re: SFP+ support for 8168fp/8117
Message-ID: <20200102152143.GB1397@lunn.ch>
References: <2D8F5FFE-3EC3-480B-9D15-23CACE5556DF@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2D8F5FFE-3EC3-480B-9D15-23CACE5556DF@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 02:59:42PM +0800, Kai Heng Feng wrote:
> Hi Heiner,
> 
> There's an 8168fp/8117 chip has SFP+ port instead of RJ45, the phy device ID matches "Generic FE-GE Realtek PHY" nevertheless.
> The problems is that, since it uses SFP+, both BMCR and BMSR read are always zero, so Realtek phylib never knows if the link is up.
> 
> However, the old method to read through MMIO correctly shows the link is up:
> static unsigned int rtl8169_xmii_link_ok(struct rtl8169_private *tp)
> {
>        return RTL_R8(tp, PHYstatus) & LinkStatus;
> }
> 
> Few ideas here:
> - Add a link state callback for phylib like phylink's phylink_fixed_state_cb(). However there's no guarantee that other parts of this chip works.
> - Add SFP+ support for this chip. However the phy device matches to "Generic FE-GE Realtek PHY" which may complicate things.
> 
> Any advice will be welcome.

Hi Kai

Is the i2c bus accessible? Is there any documentation or example code?

In order to correctly support SFP+ cages, we need access to the i2c
bus to determine what sort of module has been inserted. It would also
be good to have access to LOS, transmitter disable, etc, from the SFP
cage.

   Andrew
