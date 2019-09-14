Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A7CB2A4C
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 09:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfINHSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 03:18:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:7604 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfINHSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 03:18:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Sep 2019 00:17:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="179918477"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 14 Sep 2019 00:17:55 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1i92Jf-0008iL-Cs; Sat, 14 Sep 2019 15:17:55 +0800
Date:   Sat, 14 Sep 2019 15:16:56 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/7] net/dsa: configure autoneg for CPU port
Message-ID: <201909141553.6VZtDpQw%lkp@intel.com>
References: <20190910154238.9155-2-bob.beckett@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910154238.9155-2-bob.beckett@collabora.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[cannot apply to v5.3-rc8 next-20190904]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Robert-Beckett/net-dsa-mv88e6xxx-features-to-handle-network-storms/20190911-142233
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   include/linux/sched.h:609:43: sparse: sparse: bad integer constant expression
   include/linux/sched.h:609:73: sparse: sparse: invalid named zero-width bitfield `value'
   include/linux/sched.h:610:43: sparse: sparse: bad integer constant expression
   include/linux/sched.h:610:67: sparse: sparse: invalid named zero-width bitfield `bucket_id'
>> net/dsa/port.c:541:55: sparse: sparse: incompatible types for operation (|)
>> net/dsa/port.c:541:55: sparse:    left side has type unsigned long *
>> net/dsa/port.c:541:55: sparse:    right side has type unsigned long

vim +541 net/dsa/port.c

   525	
   526	static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
   527	{
   528		struct dsa_switch *ds = dp->ds;
   529		struct phy_device *phydev;
   530		int port = dp->index;
   531		int err = 0;
   532	
   533		phydev = dsa_port_get_phy_device(dp);
   534		if (!phydev)
   535			return 0;
   536	
   537		if (IS_ERR(phydev))
   538			return PTR_ERR(phydev);
   539	
   540		if (enable) {
 > 541			phydev->supported = PHY_GBIT_FEATURES | SUPPORTED_MII |
   542					    SUPPORTED_AUI | SUPPORTED_FIBRE |
   543					    SUPPORTED_BNC | SUPPORTED_Pause |
   544					    SUPPORTED_Asym_Pause;
   545			phydev->advertising = phydev->supported;
   546	
   547			err = genphy_config_init(phydev);
   548			if (err < 0)
   549				goto err_put_dev;
   550	
   551			err = genphy_config_aneg(phydev);
   552			if (err < 0)
   553				goto err_put_dev;
   554	
   555			err = genphy_resume(phydev);
   556			if (err < 0)
   557				goto err_put_dev;
   558	
   559			err = genphy_read_status(phydev);
   560			if (err < 0)
   561				goto err_put_dev;
   562		} else {
   563			err = genphy_suspend(phydev);
   564			if (err < 0)
   565				goto err_put_dev;
   566		}
   567	
   568		if (ds->ops->adjust_link)
   569			ds->ops->adjust_link(ds, port, phydev);
   570	
   571		dev_dbg(ds->dev, "enabled port's phy: %s", phydev_name(phydev));
   572	
   573	err_put_dev:
   574		put_device(&phydev->mdio.dev);
   575		return err;
   576	}
   577	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
