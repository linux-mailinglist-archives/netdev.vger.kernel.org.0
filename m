Return-Path: <netdev+bounces-11733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B097340FC
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 14:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 935AF2817F3
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23058F70;
	Sat, 17 Jun 2023 12:28:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9324C8F6C
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 12:28:36 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678189F
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687004915; x=1718540915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gcx54GOJYpiKaGHNkkKV1rdnDRChX8bu3SKuBMyMvrI=;
  b=H9WzEJmSIR76O/hpSybq4SvJSwKmL28tUmuAiksmwls+khpHn7VmUWFY
   HaOAhEuhjKRUGyto4XWD5cqdXQLUFb7MBhbzdnAoWcsgl7vH2simgAux6
   l8Ma46TGKQvBc8Up/h1L9uPm6/FjBr2rTU2AasGCzB/JjGl3NIsK3RGFf
   pzwUGdRa1hAp3Z1aL+ZYqLogFInmI0cII/dAmY9A42mMqgOe2tvL4W20t
   +WwdVjVF55nrZWk8MVng+iaRqMBfn8dxOmBa7boLlIuO4LRrqKS2o2VnW
   /TJqW/mTkbMEIOjRhuhvKTiUv972aOIO2z6x9ryEsFlHHJwVGMKht7I8D
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="425328380"
X-IronPort-AV: E=Sophos;i="6.00,250,1681196400"; 
   d="scan'208";a="425328380"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2023 05:28:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="857692486"
X-IronPort-AV: E=Sophos;i="6.00,250,1681196400"; 
   d="scan'208";a="857692486"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jun 2023 05:28:33 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qAV2e-0002kK-21;
	Sat, 17 Jun 2023 12:28:32 +0000
Date: Sat, 17 Jun 2023 20:27:31 +0800
From: kernel test robot <lkp@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	edumazet@google.com, pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dqs: add NIC stall detector based on BQL
Message-ID: <202306172057.jx7YhLiu-lkp@intel.com>
References: <20230616213236.2379935-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616213236.2379935-1-kuba@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/net-dqs-add-NIC-stall-detector-based-on-BQL/20230617-053320
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230616213236.2379935-1-kuba%40kernel.org
patch subject: [PATCH net-next] net: dqs: add NIC stall detector based on BQL
config: i386-randconfig-s052-20230614 (https://download.01.org/0day-ci/archive/20230617/202306172057.jx7YhLiu-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230617/202306172057.jx7YhLiu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306172057.jx7YhLiu-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/dynamic_queue_limits.c:18:6: sparse: sparse: symbol 'dql_check_stall' was not declared. Should it be static?

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

