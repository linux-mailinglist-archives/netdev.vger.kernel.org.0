Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07FC68ADFD
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 03:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjBEBwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 20:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBEBwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 20:52:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4654819F36
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 17:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675561929; x=1707097929;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I5jEDVEv4E/ZUk3vxpTGpGFpHD2IGhqHXHaQI/TeKqo=;
  b=WY0H2VVlpyJq0RUR88O8/FNc6Rb3JsEfUkBfRODJgErGhwglGXZSdXsv
   t6bgwnDlRcbIewQAs23UFfqXOwFAg3Q/myMWGknfMeH80gtEOAWXESBEx
   465uIOdPXG4Jh5j7CPfMYWD6xoxpVUZDYztqRYaRGK61/JIZED89HaUO7
   G3k9L1txI5XCM+wxOhn6znQIRirEFv5qy35lhy7aWK39frjlK61N9fjW9
   EYMNx4cDhJSDOVOzGops9HEYW0kkBhGRCMmo1YdN5vJ4cEGoH7AxorKbR
   B+TEXUbA1YFP9Dre+CjCyc4kfyk1fbrW49Yp9RxKy0Vmm+Td320P1l+6E
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="330303280"
X-IronPort-AV: E=Sophos;i="5.97,274,1669104000"; 
   d="scan'208";a="330303280"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 17:52:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="666132622"
X-IronPort-AV: E=Sophos;i="5.97,274,1669104000"; 
   d="scan'208";a="666132622"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 04 Feb 2023 17:52:04 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pOUCJ-0001eS-1V;
        Sun, 05 Feb 2023 01:52:03 +0000
Date:   Sun, 5 Feb 2023 09:51:50 +0800
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
Subject: Re: [PATCH net-next 2/5] net: extract nf_ct_skb_network_trim
 function to nf_conntrack_ovs
Message-ID: <202302050931.ExDjYqcf-lkp@intel.com>
References: <c47c8808a2e46776ed38218ed6c8ddd59ced59d6.1675548023.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c47c8808a2e46776ed38218ed6c8ddd59ced59d6.1675548023.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Xin-Long/net-create-nf_conntrack_ovs-for-ovs-and-tc-use/20230205-060514
patch link:    https://lore.kernel.org/r/c47c8808a2e46776ed38218ed6c8ddd59ced59d6.1675548023.git.lucien.xin%40gmail.com
patch subject: [PATCH net-next 2/5] net: extract nf_ct_skb_network_trim function to nf_conntrack_ovs
config: s390-defconfig (https://download.01.org/0day-ci/archive/20230205/202302050931.ExDjYqcf-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e5c757094190576b1a59afee53d39b90bfbdd5f0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xin-Long/net-create-nf_conntrack_ovs-for-ovs-and-tc-use/20230205-060514
        git checkout e5c757094190576b1a59afee53d39b90bfbdd5f0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "nf_ct_helper" [net/openvswitch/openvswitch.ko] undefined!
ERROR: modpost: "nf_ct_add_helper" [net/openvswitch/openvswitch.ko] undefined!
>> ERROR: modpost: "nf_ct_skb_network_trim" [net/openvswitch/openvswitch.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
