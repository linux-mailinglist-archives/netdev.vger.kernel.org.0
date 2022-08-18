Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13B8598065
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 10:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242352AbiHRIwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 04:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiHRIwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 04:52:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A16B0288
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 01:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660812760; x=1692348760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k8/zSAkp+cfoW3U6Qv53pN/pwfcCe/WePQzpTG+PzkE=;
  b=E0btYCNpM/FWEFDf7sD9DwJQz9ZSR0nmYOPkzjy7X3dSc5Uue/FbDQqw
   GyA0cI6S+fo1jYlK+nHn85s08u1Q8dPZ56DyZalJ/HAjJX96tPrlGOItB
   w/F93njgoYUZxRmYOcZlkL0VddEFJABQVmGsMDAttwUKLk1ZC9DVZJaPW
   PhmufQ9Ae46TueNFhyN7TCiKDnR3z0qVpJznR4WhgpI4z0QViW3MbxV8k
   SW4Q4eHQ07+sZEuCyiXEykvfkfJrVcsQPo8+hH+vWFduRjtTMCTyD+/lw
   dmmIbjBjDj1T6IUem3AVMBe5Yw1xWdNHnEn7YLQ3yK9NSS/eOgcP1UMgC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="273097905"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="273097905"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 01:52:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="675985895"
Received: from lkp-server01.sh.intel.com (HELO 6cc724e23301) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 01:52:38 -0700
Received: from kbuild by 6cc724e23301 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oObGX-0000Iv-1w;
        Thu, 18 Aug 2022 08:52:37 +0000
Date:   Thu, 18 Aug 2022 16:51:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH v2 net 13/17] net: Fix data-races around
 sysctl_fb_tunnels_only_for_init_net.
Message-ID: <202208181615.Lu9xjiEv-lkp@intel.com>
References: <20220818035227.81567-14-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818035227.81567-14-kuniyu@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuniyuki,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/net-sysctl-Fix-data-races-around-net-core-XXX/20220818-115941
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git fc4aaf9fb3c99bcb326d52f9d320ed5680bd1cee
config: riscv-randconfig-r032-20220818 (https://download.01.org/0day-ci/archive/20220818/202208181615.Lu9xjiEv-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project aed5e3bea138ce581d682158eb61c27b3cfdd6ec)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/6bc3dfb3dc4862f4e00ba93c45cd5c0251b85d5b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kuniyuki-Iwashima/net-sysctl-Fix-data-races-around-net-core-XXX/20220818-115941
        git checkout 6bc3dfb3dc4862f4e00ba93c45cd5c0251b85d5b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: sysctl_fb_tunnels_only_for_init_net
   >>> referenced by ip_tunnel.c
   >>>               ipv4/ip_tunnel.o:(ip_tunnel_init_net) in archive net/built-in.a
   >>> referenced by ip_tunnel.c
   >>>               ipv4/ip_tunnel.o:(ip_tunnel_init_net) in archive net/built-in.a

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
