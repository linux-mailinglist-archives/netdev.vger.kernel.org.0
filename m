Return-Path: <netdev+bounces-1075-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 035B36FC16D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8B0F281155
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0404B17ACC;
	Tue,  9 May 2023 08:12:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC67171C7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:12:49 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9EA19F
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683619966; x=1715155966;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pVDhvyfWVhVuWZyd6JaHvPDqNIm5zlel1usrxNyley4=;
  b=kRTOENv81bC5uGAAOk8yeOXd/r/cXOws9XpVySaIuVXxmNMykewdwzfj
   aZqbz0w5Cy7ukpDdcKdBWAPJzr58X0YadRyXZeCm6wulx7QC2aL/+6WWg
   FLZNQK5aAkgWiMldaLVSBctU0d8M7uzGhpDRXD9/os5TWFXyfEIJyrWE6
   vzP2fNTLu2V/gYmkBgu/y7QMLXH1DlI0nNUp7AKpY3KnSsn5JCIMDDrnj
   acGz23qVm13aIp49vMLrO7NS+W3FHdijLTUqu5eB5ITwdnmDKVpnIu5ZX
   Wb1/B3bkf1ZHRjlHGJJ0FJMpnno8cMiwhqbc8CVoI7XrRHGpUoolLnP84
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="334283282"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="334283282"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 01:12:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="1028724915"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="1028724915"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 09 May 2023 01:12:43 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pwISg-0001xg-2v;
	Tue, 09 May 2023 08:12:42 +0000
Date: Tue, 9 May 2023 16:12:18 +0800
From: kernel test robot <lkp@intel.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH v2 net] net: Fix sk->sk_stamp race in sock_recv_cmsgs().
Message-ID: <202305091519.TLuWISjA-lkp@intel.com>
References: <20230508165815.45602-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508165815.45602-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Kuniyuki,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/net-Fix-sk-sk_stamp-race-in-sock_recv_cmsgs/20230509-005901
base:   net/main
patch link:    https://lore.kernel.org/r/20230508165815.45602-1-kuniyu%40amazon.com
patch subject: [PATCH v2 net] net: Fix sk->sk_stamp race in sock_recv_cmsgs().
config: arm64-randconfig-s032-20230507 (https://download.01.org/0day-ci/archive/20230509/202305091519.TLuWISjA-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/7755d082501de4c89033aed3be404114fcba1c44
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kuniyuki-Iwashima/net-Fix-sk-sk_stamp-race-in-sock_recv_cmsgs/20230509-005901
        git checkout 7755d082501de4c89033aed3be404114fcba1c44
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/firmware/tegra/ net/mctp/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305091519.TLuWISjA-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/mctp/af_mctp.c: note: in included file (through arch/arm64/include/asm/atomic.h, include/linux/atomic.h, include/asm-generic/bitops/atomic.h, ...):
>> arch/arm64/include/asm/cmpxchg.h:174:1: sparse: sparse: cast truncates bits from constant value (ffffffffc4653600 becomes 0)
   arch/arm64/include/asm/cmpxchg.h:174:1: sparse: sparse: cast truncates bits from constant value (ffffffffc4653600 becomes 3600)

vim +174 arch/arm64/include/asm/cmpxchg.h

10b663aef1c247 Catalin Marinas 2012-03-05  170  
305d454aaa292b Will Deacon     2015-10-08  171  __CMPXCHG_GEN()
305d454aaa292b Will Deacon     2015-10-08  172  __CMPXCHG_GEN(_acq)
305d454aaa292b Will Deacon     2015-10-08  173  __CMPXCHG_GEN(_rel)
305d454aaa292b Will Deacon     2015-10-08 @174  __CMPXCHG_GEN(_mb)
10b663aef1c247 Catalin Marinas 2012-03-05  175  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

