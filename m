Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0C21539ED
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 22:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgBEVGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 16:06:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:45876 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgBEVGK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 16:06:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 13:06:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="343999270"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 05 Feb 2020 13:06:07 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1izRs7-000H4x-9y; Thu, 06 Feb 2020 05:06:07 +0800
Date:   Thu, 6 Feb 2020 05:05:10 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, opendmb@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH 2/6] net: bcmgenet: refactor phy mode configuration
Message-ID: <202002060443.937aTdBH%lkp@intel.com>
References: <20200201074625.8698-3-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201074625.8698-3-jeremy.linton@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeremy,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v5.5]
[also build test WARNING on next-20200205]
[cannot apply to net/master net-next/master linus/master ipvs/master]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Jeremy-Linton/Add-ACPI-bindings-to-the-genet/20200203-101928
base:    d5226fa6dbae0569ee43ecfc08bdcd6770fc4755

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

smatch warnings:
drivers/net/ethernet/broadcom/genet/bcmmii.c:485 bcmgenet_phy_interface_init() warn: unsigned 'priv->phy_interface' is never less than zero.

vim +485 drivers/net/ethernet/broadcom/genet/bcmmii.c

   479	
   480	static int bcmgenet_phy_interface_init(struct bcmgenet_priv *priv)
   481	{
   482		struct device *kdev = &priv->pdev->dev;
   483	
   484		priv->phy_interface = device_get_phy_mode(kdev);
 > 485		if (priv->phy_interface < 0) {
   486			dev_dbg(kdev, "invalid PHY mode property\n");
   487			priv->phy_interface = PHY_INTERFACE_MODE_RGMII;
   488		}
   489	
   490		/* We need to specifically look up whether this PHY interface is internal
   491		 * or not *before* we even try to probe the PHY driver over MDIO as we
   492		 * may have shut down the internal PHY for power saving purposes.
   493		 */
   494		if (priv->phy_interface == PHY_INTERFACE_MODE_INTERNAL)
   495			priv->internal_phy = true;
   496	
   497		return 0;
   498	}
   499	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
