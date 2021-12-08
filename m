Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D1746D5F3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbhLHOqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:46:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:16609 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhLHOqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:46:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="301223952"
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="301223952"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 06:42:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="612108832"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2021 06:42:46 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1muy9d-0000gf-OI; Wed, 08 Dec 2021 14:42:45 +0000
Date:   Wed, 8 Dec 2021 22:41:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joseph CHANG <josright123@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Add DM9051 driver
Message-ID: <202112082228.stoSxUom-lkp@intel.com>
References: <20211202204656.4411-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202204656.4411-3-josright123@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ce83278f313ce65a9bbd780a3e07fa3f62d82525]

url:    https://github.com/0day-ci/linux/commits/Joseph-CHANG/ADD-DM9051-NET-DEVICE/20211208-193833
base:   ce83278f313ce65a9bbd780a3e07fa3f62d82525
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20211208/202112082228.stoSxUom-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9ee7a9a16698431c764b4b21a0839e87f3692078
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Joseph-CHANG/ADD-DM9051-NET-DEVICE/20211208-193833
        git checkout 9ee7a9a16698431c764b4b21a0839e87f3692078
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/ethernet/davicom/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/davicom/dm9051.c: In function 'dm9051_read_mac_to_dev':
   drivers/net/ethernet/davicom/dm9051.c:255:35: error: assignment of read-only location '*(ndev->dev_addr + (sizetype)i)'
     255 |                 ndev->dev_addr[i] = ior(db, DM9051_PAR + i);
         |                                   ^
   drivers/net/ethernet/davicom/dm9051.c:260:43: error: assignment of read-only location '*(ndev->dev_addr + (sizetype)i)'
     260 |                         ndev->dev_addr[i] = ior(db, DM9051_PAR + i);
         |                                           ^
   drivers/net/ethernet/davicom/dm9051.c: In function 'dm_set_mac_lock':
>> drivers/net/ethernet/davicom/dm9051.c:341:57: warning: passing argument 3 of 'dm_write_eeprom_func' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     341 |                         dm_write_eeprom_func(db, i / 2, &ndev->dev_addr[i]);
         |                                                         ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/davicom/dm9051.c:156:73: note: expected 'u8 *' {aka 'unsigned char *'} but argument is of type 'const unsigned char *'
     156 | static void dm_write_eeprom_func(struct board_info *db, int offset, u8 *data)
         |                                                                     ~~~~^~~~


vim +341 drivers/net/ethernet/davicom/dm9051.c

   318	
   319	/* set mac permanently
   320	 */
   321	static void dm_set_mac_lock(struct board_info *db)
   322	{
   323		struct net_device *ndev = db->ndev;
   324	
   325		if (db->enter_setmac) {
   326			int i, oft;
   327	
   328			db->enter_setmac = 0;
   329			netdev_info(ndev, "set_mac_address %02x %02x %02x  %02x %02x %02x\n",
   330				    ndev->dev_addr[0], ndev->dev_addr[1], ndev->dev_addr[2],
   331				    ndev->dev_addr[3], ndev->dev_addr[4], ndev->dev_addr[5]);
   332	
   333			/* write to net device and chip */
   334			ADDR_LOCK_HEAD_ESSENTIAL(db); //mutex_lock
   335			for (i = 0, oft = DM9051_PAR; i < ETH_ALEN; i++, oft++)
   336				iow(db, oft, ndev->dev_addr[i]);
   337			ADDR_LOCK_TAIL_ESSENTIAL(db); //mutex_unlock
   338	
   339			/* write to EEPROM */
   340			for (i = 0; i < ETH_ALEN; i += 2)
 > 341				dm_write_eeprom_func(db, i / 2, &ndev->dev_addr[i]);
   342		}
   343	}
   344	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
