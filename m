Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0A246DE6E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhLHWgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:12611 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237677AbhLHWgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="324226854"
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="324226854"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 14:33:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="612271399"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2021 14:32:59 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mv5Ug-00018e-Ke; Wed, 08 Dec 2021 22:32:58 +0000
Date:   Thu, 9 Dec 2021 06:32:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [net-next v2 2/2] net: sched: support hash/classid selecting tx
 queue
Message-ID: <202112090601.FrUCO7HV-lkp@intel.com>
References: <20211208143408.7047-3-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208143408.7047-3-xiangxia.m.yue@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/xiangxia-m-yue-gmail-com/net-sched-allow-user-to-select-txqueue/20211208-223656
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 1fe5b01262844be03de98afdd56d1d393df04d7e
config: i386-randconfig-a015-20211207 (https://download.01.org/0day-ci/archive/20211209/202112090601.FrUCO7HV-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 097a1cb1d5ebb3a0ec4bcaed8ba3ff6a8e33c00a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/522fbcfdde012bc46d29aa216bdfa73f512adcbd
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review xiangxia-m-yue-gmail-com/net-sched-allow-user-to-select-txqueue/20211208-223656
        git checkout 522fbcfdde012bc46d29aa216bdfa73f512adcbd
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/sched/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/sched/act_skbedit.c:39:11: warning: variable 'hash' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           else if (params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH)
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/sched/act_skbedit.c:42:34: note: uninitialized use occurs here
           queue_mapping = queue_mapping + hash % mapping_mod;
                                           ^~~~
   net/sched/act_skbedit.c:39:7: note: remove the 'if' if its condition is always true
           else if (params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH)
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/sched/act_skbedit.c:32:10: note: initialize the variable 'hash' to silence this warning
           u32 hash;
                   ^
                    = 0
   1 warning generated.


vim +39 net/sched/act_skbedit.c

    26	
    27	static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
    28				    struct sk_buff *skb)
    29	{
    30		u16 queue_mapping = params->queue_mapping;
    31		u16 mapping_mod = params->mapping_mod;
    32		u32 hash;
    33	
    34		if (!(params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH_MASK))
    35			return netdev_cap_txqueue(skb->dev, queue_mapping);
    36	
    37		if (params->flags & SKBEDIT_F_QUEUE_MAPPING_CLASSID)
    38			hash = jhash_1word(task_get_classid(skb), 0);
  > 39		else if (params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH)
    40			hash = skb_get_hash(skb);
    41	
    42		queue_mapping = queue_mapping + hash % mapping_mod;
    43		return netdev_cap_txqueue(skb->dev, queue_mapping);
    44	}
    45	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
