Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492E645A68F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhKWPgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 10:36:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:47983 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231209AbhKWPgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 10:36:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="234989855"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="234989855"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 07:33:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="553339142"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2021 07:33:42 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mpXnh-00021O-Hw; Tue, 23 Nov 2021 15:33:41 +0000
Date:   Tue, 23 Nov 2021 23:33:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>
Subject: Re: [net-next PATCH 2/2] net: dsa: qca8k: add LAG support
Message-ID: <202111232352.6wBDdqCJ-lkp@intel.com>
References: <20211123025911.20987-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123025911.20987-3-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ansuel,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Ansuel-Smith/Add-mirror-and-LAG-support-to-qca8k/20211123-110018
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3b0e04140bc30f9f5c254a68013a901e5390b0a8
config: i386-randconfig-a012-20211123 (https://download.01.org/0day-ci/archive/20211123/202111232352.6wBDdqCJ-lkp@intel.com/config.gz)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 49e3838145dff1ec91c2e67a2cb562775c8d2a08)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/8fe5def54ec185d13c952a5f4da988ee7757ad78
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ansuel-Smith/Add-mirror-and-LAG-support-to-qca8k/20211123-110018
        git checkout 8fe5def54ec185d13c952a5f4da988ee7757ad78
        # save the config file to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=i386 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/dsa/qca8k.c:2231:44: warning: overlapping comparisons always evaluate to true [-Wtautological-overlap-compare]
           if (info->hash_type != NETDEV_LAG_HASH_L2 ||
               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~
>> drivers/net/dsa/qca8k.c:2252:3: warning: variable 'hash' is uninitialized when used here [-Wuninitialized]
                   hash |= QCA8K_TRUNK_HASH_SIP_EN;
                   ^~~~
   drivers/net/dsa/qca8k.c:2246:10: note: initialize the variable 'hash' to silence this warning
           u32 hash;
                   ^
                    = 0
   2 warnings generated.


vim +2231 drivers/net/dsa/qca8k.c

  2208	
  2209	static bool
  2210	qca8k_lag_can_offload(struct dsa_switch *ds,
  2211			      struct net_device *lag,
  2212			      struct netdev_lag_upper_info *info)
  2213	{
  2214		struct dsa_port *dp;
  2215		int id, members = 0;
  2216	
  2217		id = dsa_lag_id(ds->dst, lag);
  2218		if (id < 0 || id >= ds->num_lag_ids)
  2219			return false;
  2220	
  2221		dsa_lag_foreach_port(dp, ds->dst, lag)
  2222			/* Includes the port joining the LAG */
  2223			members++;
  2224	
  2225		if (members > QCA8K_NUM_PORTS_FOR_LAG)
  2226			return false;
  2227	
  2228		if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
  2229			return false;
  2230	
> 2231		if (info->hash_type != NETDEV_LAG_HASH_L2 ||
  2232		    info->hash_type != NETDEV_LAG_HASH_L23)
  2233			return false;
  2234	
  2235		return true;
  2236	}
  2237	
  2238	static int
  2239	qca8k_lag_setup_hash(struct dsa_switch *ds,
  2240			     struct net_device *lag,
  2241			     struct netdev_lag_upper_info *info)
  2242	{
  2243		struct qca8k_priv *priv = ds->priv;
  2244		bool unique_lag = true;
  2245		int i, id;
  2246		u32 hash;
  2247	
  2248		id = dsa_lag_id(ds->dst, lag);
  2249	
  2250		switch (info->hash_type) {
  2251		case NETDEV_LAG_HASH_L23:
> 2252			hash |= QCA8K_TRUNK_HASH_SIP_EN;
  2253			hash |= QCA8K_TRUNK_HASH_DIP_EN;
  2254			fallthrough;
  2255		case NETDEV_LAG_HASH_L2:
  2256			hash |= QCA8K_TRUNK_HASH_SA_EN;
  2257			hash |= QCA8K_TRUNK_HASH_DA_EN;
  2258			break;
  2259		default: /* We should NEVER reach this */
  2260			return -EOPNOTSUPP;
  2261		}
  2262	
  2263		/* Check if we are the unique configured LAG */
  2264		dsa_lags_foreach_id(i, ds->dst)
  2265			if (i != id && dsa_lag_dev(ds->dst, i)) {
  2266				unique_lag = false;
  2267				break;
  2268			}
  2269	
  2270		/* Hash Mode is global. Make sure the same Hash Mode
  2271		 * is set to all the 4 possible lag.
  2272		 * If we are the unique LAG we can set whatever hash
  2273		 * mode we want.
  2274		 * To change hash mode it's needed to remove all LAG
  2275		 * and change the mode with the latest.
  2276		 */
  2277		if (unique_lag) {
  2278			priv->lag_hash_mode = hash;
  2279		} else if (priv->lag_hash_mode != hash) {
  2280			netdev_err(lag, "Error: Mismateched Hash Mode across different lag is not supported\n");
  2281			return -EOPNOTSUPP;
  2282		}
  2283	
  2284		return regmap_update_bits(priv->regmap, QCA8K_TRUNK_HASH_EN_CTRL,
  2285					  QCA8K_TRUNK_HASH_MASK, hash);
  2286	}
  2287	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
