Return-Path: <netdev+bounces-7922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D52A17221D8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89268281109
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81271134CB;
	Mon,  5 Jun 2023 09:17:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758D2804
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:17:04 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAB9FA;
	Mon,  5 Jun 2023 02:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685956615; x=1717492615;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cgrTKus95w+HymJbLJprRL1OTrYUDbn4V9Ftlx5lOjU=;
  b=HyIiFsMiD4vCVQUNItKh4fb1cgVIkU/WxdQOabpw0sWVbdTEP9PVRooF
   4UbEXVPvE2AYsgvHhgXvzLG677TbRO/IvpfoRSVwb1yiCH/3wimJ50Pj0
   pwq8bakVD7srpJJmxCZDOxFzlrYRWCpjmySweeWB48o7fPOMsgaUQ3zB+
   OR0IeG57TBy5XwuwSGcdcCFri5ePyb7itiV4CiWu8vaHpRakkK8qpwRaK
   HHtYSAPZlBrUdsZL8tte2yNLYAA+inw/qz68EPnvVHEPx1E2S6JEdMUft
   GrgLjSnyr2hHkFP0XQO7k0Micng25gYJbZqMBLRNmpcwo6PCAdkppsyOU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="335938664"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="335938664"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 02:15:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="778475633"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="778475633"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jun 2023 02:14:57 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q66Ii-00043z-0l;
	Mon, 05 Jun 2023 09:14:56 +0000
Date: Mon, 5 Jun 2023 17:14:07 +0800
From: kernel test robot <lkp@intel.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Steen Hegelund <steen.hegelund@microchip.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v5] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <202306051754.7zMgBFMX-lkp@intel.com>
References: <1685949196-16175-1-git-send-email-shradhagupta@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685949196-16175-1-git-send-email-shradhagupta@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Shradha,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on horms-ipvs/master v6.4-rc5 next-20230605]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shradha-Gupta/hv_netvsc-Allocate-rx-indirection-table-size-dynamically/20230605-151438
base:   linus/master
patch link:    https://lore.kernel.org/r/1685949196-16175-1-git-send-email-shradhagupta%40linux.microsoft.com
patch subject: [PATCH v5] hv_netvsc: Allocate rx indirection table size dynamically
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20230605/202306051754.7zMgBFMX-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/cd4dda15951edad50a4ffd51e084863ef2f50bd3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shradha-Gupta/hv_netvsc-Allocate-rx-indirection-table-size-dynamically/20230605-151438
        git checkout cd4dda15951edad50a4ffd51e084863ef2f50bd3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/hyperv/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306051754.7zMgBFMX-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/hyperv/rndis_filter.c: In function 'rndis_filter_device_remove':
   drivers/net/hyperv/rndis_filter.c:1612:54: error: 'net' undeclared (first use in this function)
    1612 |         struct net_device_context *ndc = netdev_priv(net);
         |                                                      ^~~
   drivers/net/hyperv/rndis_filter.c:1612:54: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/net/hyperv/rndis_filter.c:1613:28: warning: unused variable 'net' [-Wunused-variable]
    1613 |         struct net_device *net = hv_get_drvdata(dev);
         |                            ^~~


vim +/net +1613 drivers/net/hyperv/rndis_filter.c

  1607	
  1608	void rndis_filter_device_remove(struct hv_device *dev,
  1609					struct netvsc_device *net_dev)
  1610	{
  1611		struct rndis_device *rndis_dev = net_dev->extension;
  1612		struct net_device_context *ndc = netdev_priv(net);
> 1613		struct net_device *net = hv_get_drvdata(dev);
  1614	
  1615		/* Halt and release the rndis device */
  1616		rndis_filter_halt_device(net_dev, rndis_dev);
  1617	
  1618		netvsc_device_remove(dev);
  1619	
  1620		ndc->rx_table_sz = 0;
  1621		kfree(ndc->rx_table);
  1622		ndc->rx_table = NULL;
  1623	}
  1624	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

