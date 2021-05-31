Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DC73953E6
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhEaCcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:32:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:63556 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhEaCcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 22:32:05 -0400
IronPort-SDR: 2ddfJmEbZLBfA2dF0gSFhgYkvK1pJVDC6hQrWos4fdQvFc4lQDr/uN2Bo0lb3sy3Dzm9JmcSti
 fGGQcQMdjvqQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="264471809"
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="264471809"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2021 19:30:26 -0700
IronPort-SDR: KoPf0wCxmg+RnIOC/i/4CwQN7sq0U7W3UOp5U64iSMqxB1Nw7hODoDJY6wJTfWftqD7S/gOa2c
 ecwKaAlULwag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="548601626"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 30 May 2021 19:30:26 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 3F6F1580921;
        Sun, 30 May 2021 19:30:22 -0700 (PDT)
Date:   Mon, 31 May 2021 10:30:19 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 0/8] Convert xpcs to phylink_pcs_ops
Message-ID: <20210531023019.GA5494@linux.intel.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
 <20210528021521.GA20022@linux.intel.com>
 <20210528091230.hzuzhotuna34amhj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528091230.hzuzhotuna34amhj@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 12:12:30PM +0300, Vladimir Oltean wrote:
> Hi VK,
> 
> On Fri, May 28, 2021 at 10:15:21AM +0800, Wong Vee Khee wrote:
> > I got the following kernel panic after applying [1], and followed by
> > this patch series.
> > 
> > [1] https://patchwork.kernel.org/project/netdevbpf/patch/20210527155959.3270478-1-olteanv@gmail.com/
> > 
> > [   10.742057] libphy: stmmac: probed
> > [   10.750396] mdio_bus stmmac-1:01: attached PHY driver [unbound] (mii_bus:phy_addr=stmmac-1:01, irq=POLL)
> > [   10.818222] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to validate link configuration for in-band status
> > [   10.830348] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to setup phy (-22)
> 
> Thanks a lot for testing. Sadly I can't figure out what is the mistake.
> Could you please add this debugging patch on top and let me know what it
> prints?
> 

Sorry for the late response. Here the debug log:

[   11.474302] mdio_bus stmmac-1:01: attached PHY driver [unbound] (mii_bus:phy_addr=stmmac-1:01, irq=POLL)
[   11.495564] mdio_bus stmmac-1:16: xpcs_create: xpcs_id 7996ced0 matched on entry 0
[   11.503154] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 13
[   11.510377] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 14
[   11.517590] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 6
[   11.524725] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 17
[   11.531946] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 18
[   11.539278] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 19
[   11.541316] ish-hid {33AECD58-B679-4E54-9BD9-A04D34F0C226}: [hid-ish]: enum_devices_done OK, num_hid_devices=6
[   11.546487] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 15
[   11.546489] mdio_bus stmmac-1:16: xpcs_create: xpcs->supported 0000000,00000000,000ee040
[   11.584687] hid-generic 001F:8087:0AC2.0001: device has no listeners, quitting
[   11.599461] mdio_bus stmmac-1:16: xpcs_validate: provided interface sgmii does not match supported interface 0 (usxgmii)
[   11.606538] hid-generic 001F:8087:0AC2.0002: device has no listeners, quitting
[   11.610306] mdio_bus stmmac-1:16: xpcs_validate: provided interface sgmii does not match any supported interface
[   11.610309] mdio_bus stmmac-1:16: xpcs_validate: provided interface sgmii does not match supported interface 0 (usxgmii)
[   11.626259] hid-generic 001F:8087:0AC2.0003: device has no listeners, quitting
[   11.627675] mdio_bus stmmac-1:16: xpcs_validate: provided interface sgmii does not match any supported interface
[   11.627677] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to validate link configuration for in-band status
[   11.641996] hid-generic 001F:8087:0AC2.0004: device has no listeners, quitting
[   11.645729] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to setup phy (-22)

Regards,
VK
