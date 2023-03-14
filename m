Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDD26BA0BF
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCNU34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNU3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:29:55 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACD931E0C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678825793; x=1710361793;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lv5S4P9iG4cZbsNSXeO54sVYqku8L4DkS7WtApt3p7k=;
  b=HOwRTYLnTwTkbgrEBw6TXIWWVSBk8A33qLru59zJ6Ptgt5k2IocQcTrM
   KpSFKI5JhYteezcBpVDSf+sdk8JLmd8bAw+HmvG3VeMd4G8zCtr1QGyWw
   QeVvCT5MZO404ghbRhATc+JqPYoNdE9Zt8tqN+U0KpOuKqM21m3LFLEwx
   khto0fu2CsP/q3XkrgWn0mrd2+v34iGcoFE7D/qTYTy9tzBryQONkITqi
   aHIZ9CNC7DE5WP0HXEahL4JrTjr/uT9aYsx5ugkXAuAAbZR0RICQRRU7R
   1UvkDUzpuntz3bqoYzfVlSbarhjwm4FzK3O0tRFs2n8+eqOEedJTVGFeF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365211165"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="365211165"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 13:29:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925069220"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="925069220"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 14 Mar 2023 13:29:51 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcBHK-0007Am-1N;
        Tue, 14 Mar 2023 20:29:50 +0000
Date:   Wed, 15 Mar 2023 04:29:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     oe-kbuild-all@lists.linux.dev,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 5/5] sfc: add offloading of 'foreign' TC (decap)
 rules
Message-ID: <202303150436.cQ46tTwI-lkp@intel.com>
References: <a7aabdb45290f1cd50681eb9e1d610893fbce299.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7aabdb45290f1cd50681eb9e1d610893fbce299.1678815095.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20230314]
[cannot apply to net-next/master horms-ipvs/master linus/master v6.3-rc2 v6.3-rc1 v6.2 v6.3-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/edward-cree-amd-com/sfc-add-notion-of-match-on-enc-keys-to-MAE-machinery/20230315-013855
patch link:    https://lore.kernel.org/r/a7aabdb45290f1cd50681eb9e1d610893fbce299.1678815095.git.ecree.xilinx%40gmail.com
patch subject: [PATCH net-next 5/5] sfc: add offloading of 'foreign' TC (decap) rules
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20230315/202303150436.cQ46tTwI-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/51a99241aafeb3bd67a12aae5e9089c7aff2f3cd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review edward-cree-amd-com/sfc-add-notion-of-match-on-enc-keys-to-MAE-machinery/20230315-013855
        git checkout 51a99241aafeb3bd67a12aae5e9089c7aff2f3cd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303150436.cQ46tTwI-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/sfc/tc.c:21:21: warning: no previous prototype for 'efx_tc_indr_netdev_type' [-Wmissing-prototypes]
      21 | enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev)
         |                     ^~~~~~~~~~~~~~~~~~~~~~~


vim +/efx_tc_indr_netdev_type +21 drivers/net/ethernet/sfc/tc.c

    20	
  > 21	enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev)
    22	{
    23		if (netif_is_vxlan(net_dev))
    24			return EFX_ENCAP_TYPE_VXLAN;
    25		if (netif_is_geneve(net_dev))
    26			return EFX_ENCAP_TYPE_GENEVE;
    27	
    28		return EFX_ENCAP_TYPE_NONE;
    29	}
    30	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
