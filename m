Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3AE465DF7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 06:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355557AbhLBFoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 00:44:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:35206 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355337AbhLBFob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 00:44:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="260622526"
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="260622526"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 21:41:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="459513515"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 01 Dec 2021 21:41:06 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mseqA-000Fux-17; Thu, 02 Dec 2021 05:41:06 +0000
Date:   Thu, 2 Dec 2021 13:40:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 08/19] drop_monitor: add net device refcount
 tracker
Message-ID: <202112021345.IlporM5t-lkp@intel.com>
References: <20211202032139.3156411-9-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202032139.3156411-9-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8057cbb8335cf6d419866737504473833e1d128a
config: nds32-allyesconfig (https://download.01.org/0day-ci/archive/20211202/202112021345.IlporM5t-lkp@intel.com/config)
compiler: nds32le-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/6b336d0b301ebb1097132101a9e3bd01f71c40d4
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
        git checkout 6b336d0b301ebb1097132101a9e3bd01f71c40d4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nds32 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/core/drop_monitor.c: In function 'net_dm_hw_metadata_free':
>> net/core/drop_monitor.c:869:47: warning: passing argument 2 of 'dev_put_track' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     869 |         dev_put_track(hw_metadata->input_dev, &hw_metadata->dev_tracker);
         |                                               ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/core/drop_monitor.c:10:
   include/linux/netdevice.h:3863:53: note: expected 'struct ref_tracker **' but argument is of type 'struct ref_tracker * const*'
    3863 |                                  netdevice_tracker *tracker)
         |                                  ~~~~~~~~~~~~~~~~~~~^~~~~~~


vim +869 net/core/drop_monitor.c

   865	
   866	static void
   867	net_dm_hw_metadata_free(const struct devlink_trap_metadata *hw_metadata)
   868	{
 > 869		dev_put_track(hw_metadata->input_dev, &hw_metadata->dev_tracker);
   870		kfree(hw_metadata->fa_cookie);
   871		kfree(hw_metadata->trap_name);
   872		kfree(hw_metadata->trap_group_name);
   873		kfree(hw_metadata);
   874	}
   875	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
