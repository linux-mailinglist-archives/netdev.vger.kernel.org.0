Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECAE2BD38
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 04:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfE1C2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 22:28:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:49754 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfE1C2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 22:28:00 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 19:27:59 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 May 2019 19:27:57 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hVRqG-000GUz-9u; Tue, 28 May 2019 10:27:56 +0800
Date:   Tue, 28 May 2019 10:27:12 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     kbuild-all@01.org, linux@armlinux.org.uk, f.fainelli@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH 03/11] net: phy: Check against net_device being NULL
Message-ID: <201905281030.nUFia0e7%lkp@intel.com>
References: <1558992127-26008-4-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558992127-26008-4-git-send-email-ioana.ciornei@nxp.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on v5.2-rc2 next-20190524]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ioana-Ciornei/Decoupling-PHYLINK-from-struct-net_device/20190528-061507
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/phy/phy_device.c:952:31: sparse: sparse: incorrect type in return expression (different base types) @@    expected int @@    got voiint @@
>> drivers/net/phy/phy_device.c:952:31: sparse:    expected int
>> drivers/net/phy/phy_device.c:952:31: sparse:    got void *

vim +952 drivers/net/phy/phy_device.c

   937	
   938	/**
   939	 * phy_connect_direct - connect an ethernet device to a specific phy_device
   940	 * @dev: the network device to connect
   941	 * @phydev: the pointer to the phy device
   942	 * @handler: callback function for state change notifications
   943	 * @interface: PHY device's interface
   944	 */
   945	int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
   946			       void (*handler)(struct net_device *),
   947			       phy_interface_t interface)
   948	{
   949		int rc;
   950	
   951		if (!dev)
 > 952			return ERR_PTR(-EINVAL);
   953	
   954		rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
   955		if (rc)
   956			return rc;
   957	
   958		phy_prepare_link(phydev, handler);
   959		if (phy_interrupt_is_valid(phydev))
   960			phy_request_interrupt(phydev);
   961	
   962		return 0;
   963	}
   964	EXPORT_SYMBOL(phy_connect_direct);
   965	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
