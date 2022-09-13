Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAA95B6B90
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiIMK01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiIMK0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:26:06 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EEF5A2D9;
        Tue, 13 Sep 2022 03:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663064762; x=1694600762;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ARgoLmEbhTA7goAGgTKJDoKZwOFyACEiJhXaXvPcn+4=;
  b=KdXS8FaZ+vo6T/5hCWIksLuwBH8PDMqbETvyIhOM6CCP+H7Of99znozS
   vlLiGDBKZlqAWH6jFYxZieVyHEjSc1P5Td/hID1sNN739bDGCZ87r7DBj
   jutysx4uZAoolU1+XVAM1WIJRx2bmrD7XLgLKCpIntE0qyydkScX6cQTW
   mgXJT1OJbYtkETtFs1JMxknEgSF7eFaECK5BILLaZWWs5rZCvOdDGnRH1
   Pv9yA7wZyb0F73DnUNXjFM9BLvj/qHOKOSjzpN+xpeW4qAi+7ljndW/O6
   GxN+L3yy/Us19t9mgFb2UYw5oHVJnKZiuOtjpJ2q2xeobuvdzXCe2RsPH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="359827124"
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="359827124"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 03:26:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="649609317"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2022 03:26:00 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oY379-0003U3-1K;
        Tue, 13 Sep 2022 10:25:59 +0000
Date:   Tue, 13 Sep 2022 18:25:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jianglei Nie <niejianglei2021@163.com>, irusskikh@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: Re: [PATCH] net: atlantic: fix potential memory leak in
 aq_ndev_close()
Message-ID: <202209131828.hYRSPYF2-lkp@intel.com>
References: <20220913063941.83611-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913063941.83611-1-niejianglei2021@163.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jianglei,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master linus/master v6.0-rc5 next-20220912]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jianglei-Nie/net-atlantic-fix-potential-memory-leak-in-aq_ndev_close/20220913-144300
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 169ccf0e40825d9e465863e4707d8e8546d3c3cb
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220913/202209131828.hYRSPYF2-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/e1ce8c41446db3a7dd59206ff9c8a75baf7be067
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jianglei-Nie/net-atlantic-fix-potential-memory-leak-in-aq_ndev_close/20220913-144300
        git checkout e1ce8c41446db3a7dd59206ff9c8a75baf7be067
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/aquantia/atlantic/aq_main.c: In function 'aq_ndev_close':
>> drivers/net/ethernet/aquantia/atlantic/aq_main.c:99:1: warning: label 'err_exit' defined but not used [-Wunused-label]
      99 | err_exit:
         | ^~~~~~~~


vim +/err_exit +99 drivers/net/ethernet/aquantia/atlantic/aq_main.c

97bde5c4f909a5 David VomLehn  2017-01-23   90  
97bde5c4f909a5 David VomLehn  2017-01-23   91  static int aq_ndev_close(struct net_device *ndev)
97bde5c4f909a5 David VomLehn  2017-01-23   92  {
97bde5c4f909a5 David VomLehn  2017-01-23   93  	struct aq_nic_s *aq_nic = netdev_priv(ndev);
7b0c342f1f6754 Nikita Danilov 2019-11-07   94  	int err = 0;
97bde5c4f909a5 David VomLehn  2017-01-23   95  
97bde5c4f909a5 David VomLehn  2017-01-23   96  	err = aq_nic_stop(aq_nic);
837c637869bef2 Nikita Danilov 2019-11-07   97  	aq_nic_deinit(aq_nic, true);
97bde5c4f909a5 David VomLehn  2017-01-23   98  
97bde5c4f909a5 David VomLehn  2017-01-23  @99  err_exit:
97bde5c4f909a5 David VomLehn  2017-01-23  100  	return err;
97bde5c4f909a5 David VomLehn  2017-01-23  101  }
97bde5c4f909a5 David VomLehn  2017-01-23  102  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
