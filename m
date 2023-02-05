Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C27A68ADC4
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 02:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBEBLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 20:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBEBLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 20:11:08 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516BE252AB
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 17:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675559467; x=1707095467;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LFlO3W+6GgETwNF/iBpulf0HF5czISSB4puko0mMG8w=;
  b=a+dpyvt+cLydNY0Hb7YMCMHWaQ5JgFVGFIGlQInN0dJGHEnFNdZuUKWh
   ZKq+0fEkDwjBjoFVDL7N1FYLcNr0AguC1jTjKnpu2wvsXQ9hHNx/Gam7r
   0+YTNDCv/aA8iFybKUhkKe7x+WpOyjna1QnsVJJFongG1flDkjrJVwRd1
   xajEBZ+2/yeeUVel/jISf786NoushoXqwL4CxFVf3akFuRu+Tv1R3TnD+
   FnDLH85Wv1vwhheGH+8vL64wS6+sjcr6GcuYLAburlQz/+sp0HaWd7jQ2
   cTazoV2Nzvxtb2s1rVOIvvNiug24qHrlBdSgH3fGUQ6QUVXrYAOCbJDpJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="331141815"
X-IronPort-AV: E=Sophos;i="5.97,274,1669104000"; 
   d="scan'208";a="331141815"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 17:11:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="790081781"
X-IronPort-AV: E=Sophos;i="5.97,274,1669104000"; 
   d="scan'208";a="790081781"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 04 Feb 2023 17:11:03 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pOTYc-0001cm-0h;
        Sun, 05 Feb 2023 01:11:02 +0000
Date:   Sun, 5 Feb 2023 09:10:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net-next 1/5] net: create nf_conntrack_ovs for ovs and tc
 use
Message-ID: <202302050823.JwxMWCH9-lkp@intel.com>
References: <6eca3cf10a8c06f733fac943bcb997c06ec5daa3.1675548023.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6eca3cf10a8c06f733fac943bcb997c06ec5daa3.1675548023.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Xin-Long/net-create-nf_conntrack_ovs-for-ovs-and-tc-use/20230205-060514
patch link:    https://lore.kernel.org/r/6eca3cf10a8c06f733fac943bcb997c06ec5daa3.1675548023.git.lucien.xin%40gmail.com
patch subject: [PATCH net-next 1/5] net: create nf_conntrack_ovs for ovs and tc use
config: s390-defconfig (https://download.01.org/0day-ci/archive/20230205/202302050823.JwxMWCH9-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e2bb7f965a86f833a4ae6ec28444ba328fdfc358
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xin-Long/net-create-nf_conntrack_ovs-for-ovs-and-tc-use/20230205-060514
        git checkout e2bb7f965a86f833a4ae6ec28444ba328fdfc358
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "nf_ct_helper" [net/openvswitch/openvswitch.ko] undefined!
>> ERROR: modpost: "nf_ct_add_helper" [net/openvswitch/openvswitch.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
