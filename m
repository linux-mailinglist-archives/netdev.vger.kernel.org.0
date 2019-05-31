Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BC331496
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfEaSXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:23:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:36556 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbfEaSXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 14:23:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 11:23:46 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 31 May 2019 11:23:44 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hWmBr-000I4A-R3; Sat, 01 Jun 2019 02:23:43 +0800
Date:   Sat, 1 Jun 2019 02:23:22 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V4 net-next 2/6] net: Introduce a new MII time stamping
 interface.
Message-ID: <201906010245.pVc1Wt27%lkp@intel.com>
References: <cc892ec1dfe16c3e5feb26e756cb20405a386948.1559109077.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc892ec1dfe16c3e5feb26e756cb20405a386948.1559109077.git.richardcochran@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Richard-Cochran/Peer-to-Peer-One-Step-time-stamping/20190531-213601
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/macvlan.c:1059:49: sparse: sparse: no member 'ts_info' in struct phy_driver
   drivers/net/macvlan.c:1060:36: sparse: sparse: no member 'ts_info' in struct phy_driver
>> drivers/net/macvlan.c:1059:49: sparse: sparse: unknown expression (8 46)

vim +1059 drivers/net/macvlan.c

9edb8bb6 Stephen Hemminger 2008-10-29  1051  
254c0a2b Hangbin Liu       2019-03-20  1052  static int macvlan_ethtool_get_ts_info(struct net_device *dev,
254c0a2b Hangbin Liu       2019-03-20  1053  				       struct ethtool_ts_info *info)
254c0a2b Hangbin Liu       2019-03-20  1054  {
254c0a2b Hangbin Liu       2019-03-20  1055  	struct net_device *real_dev = macvlan_dev_real_dev(dev);
254c0a2b Hangbin Liu       2019-03-20  1056  	const struct ethtool_ops *ops = real_dev->ethtool_ops;
254c0a2b Hangbin Liu       2019-03-20  1057  	struct phy_device *phydev = real_dev->phydev;
254c0a2b Hangbin Liu       2019-03-20  1058  
254c0a2b Hangbin Liu       2019-03-20 @1059  	if (phydev && phydev->drv && phydev->drv->ts_info) {
254c0a2b Hangbin Liu       2019-03-20  1060  		 return phydev->drv->ts_info(phydev, info);
254c0a2b Hangbin Liu       2019-03-20  1061  	} else if (ops->get_ts_info) {
254c0a2b Hangbin Liu       2019-03-20  1062  		return ops->get_ts_info(real_dev, info);
254c0a2b Hangbin Liu       2019-03-20  1063  	} else {
254c0a2b Hangbin Liu       2019-03-20  1064  		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
254c0a2b Hangbin Liu       2019-03-20  1065  			SOF_TIMESTAMPING_SOFTWARE;
254c0a2b Hangbin Liu       2019-03-20  1066  		info->phc_index = -1;
254c0a2b Hangbin Liu       2019-03-20  1067  	}
254c0a2b Hangbin Liu       2019-03-20  1068  
254c0a2b Hangbin Liu       2019-03-20  1069  	return 0;
254c0a2b Hangbin Liu       2019-03-20  1070  }
254c0a2b Hangbin Liu       2019-03-20  1071  

:::::: The code at line 1059 was first introduced by commit
:::::: 254c0a2bfedb9e1baf38bd82ca86494d4bc1e0cb macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to real device

:::::: TO: Hangbin Liu <liuhangbin@gmail.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
