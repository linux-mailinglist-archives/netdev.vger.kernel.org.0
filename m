Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E71588036
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbiHBQ0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237458AbiHBQ0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:26:33 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88224357E6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 09:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659457588; x=1690993588;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ku52B6somYBDUC4YngEab5TCrpoza4ehZejhbqVpntg=;
  b=EAooWgpkSQ7R8lxV3WxAAIlHN6rT7BOXtHX14Ynz1VGclhgU78UB/QO3
   X26rOf7iIUTpm6mel33HTqWS9yK4YSHmyO8mc5wbkr4qw8M30Sz+av2+H
   T3efuY8/T8gaPFG5at1/3sUcYW+TyMKaiBUwiEriBhYTdJrZ38XcBPOPS
   Dsx1p8vrEkhpTP0yiQxYOFNWtwOhvc+vpTvQYWq6RQZYyiRwOmQIaUC7i
   vnb6rdJhiMuoaPDRuoeoojRLSUshvs4jabzD9I2rg79NMzyoijvnXpUkq
   f0m2EQp9NJMac7EeJmscK7pp1pOY+ngSgUs/wXphqbRAt6KU04QVzJjc9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="375758127"
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="375758127"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 09:26:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="630775505"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 09:26:24 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oIuiu-000GCm-0v;
        Tue, 02 Aug 2022 16:26:24 +0000
Date:   Wed, 3 Aug 2022 00:26:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Message-ID: <202208030026.UbhC51Ku-lkp@intel.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801080053.21849-1-maximmi@nvidia.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Maxim-Mikityanskiy/net-tls-Use-RCU-API-to-access-tls_ctx-netdev/20220801-160258
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 63757225a93353bc2ce4499af5501eabdbbf23f9
config: mips-randconfig-s043-20220801 (https://download.01.org/0day-ci/archive/20220803/202208030026.UbhC51Ku-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/9971662af97683a6f0ea3d752495bba5ef6229dc
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Maxim-Mikityanskiy/net-tls-Use-RCU-API-to-access-tls_ctx-netdev/20220801-160258
        git checkout 9971662af97683a6f0ea3d752495bba5ef6229dc
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=mips SHELL=/bin/bash drivers/net/bonding/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
   drivers/net/bonding/bond_main.c:2831:26: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/bonding/bond_main.c:2837:20: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/bonding/bond_main.c:2910:40: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] vlan_proto @@     got int @@
   drivers/net/bonding/bond_main.c:2910:40: sparse:     expected restricted __be16 [usertype] vlan_proto
   drivers/net/bonding/bond_main.c:2910:40: sparse:     got int
>> drivers/net/bonding/bond_main.c:5336:13: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct net_device *slave_dev @@     got struct net_device [noderef] __rcu *netdev @@
   drivers/net/bonding/bond_main.c:5336:13: sparse:     expected struct net_device *slave_dev
   drivers/net/bonding/bond_main.c:5336:13: sparse:     got struct net_device [noderef] __rcu *netdev
   drivers/net/bonding/bond_main.c:5337:75: sparse: sparse: incorrect type in argument 3 (different address spaces) @@     expected struct net_device *slave_dev @@     got struct net_device [noderef] __rcu *netdev @@
   drivers/net/bonding/bond_main.c:5337:75: sparse:     expected struct net_device *slave_dev
   drivers/net/bonding/bond_main.c:5337:75: sparse:     got struct net_device [noderef] __rcu *netdev

vim +5336 drivers/net/bonding/bond_main.c

007feb87fb1593 Tariq Toukan 2021-01-17  5331  
89df6a8104706f Tariq Toukan 2021-01-17  5332  #if IS_ENABLED(CONFIG_TLS_DEVICE)
89df6a8104706f Tariq Toukan 2021-01-17  5333  static netdev_tx_t bond_tls_device_xmit(struct bonding *bond, struct sk_buff *skb,
89df6a8104706f Tariq Toukan 2021-01-17  5334  					struct net_device *dev)
89df6a8104706f Tariq Toukan 2021-01-17  5335  {
89df6a8104706f Tariq Toukan 2021-01-17 @5336  	if (likely(bond_get_slave_by_dev(bond, tls_get_ctx(skb->sk)->netdev)))
89df6a8104706f Tariq Toukan 2021-01-17  5337  		return bond_dev_queue_xmit(bond, skb, tls_get_ctx(skb->sk)->netdev);
89df6a8104706f Tariq Toukan 2021-01-17  5338  	return bond_tx_drop(dev, skb);
89df6a8104706f Tariq Toukan 2021-01-17  5339  }
89df6a8104706f Tariq Toukan 2021-01-17  5340  #endif
89df6a8104706f Tariq Toukan 2021-01-17  5341  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
