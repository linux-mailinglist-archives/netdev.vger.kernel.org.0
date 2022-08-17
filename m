Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19306596B37
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 10:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiHQIO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 04:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiHQIO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 04:14:26 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D013954670;
        Wed, 17 Aug 2022 01:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660724060; x=1692260060;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WSvGEjuAiVX5neKeHcOX4QCFy/+sM1+tD4NRxZl6qQA=;
  b=JTsEOZVYFxw/zel/cY+7au8ZYbfFgiyW8BpEE/RUR48aGqGmMmQX+Knf
   /bGxMncOt7zy3uwaU3iydMNwKrm/ut8+a8xWYqGMGKcLQED5hLYoPmJYp
   ThQ88WGRIM8pYszql+NOeiQ8bLC+uPt3FRArew9pTZ5bFHvedQcqdcxr5
   EnXcpgZsTCOEidXU0hFJCJ8FscwglTb9O1bUKO+uIOg6oT14xMYVShlM+
   7FTbRJFjYX8LsLyL1P9nN4xG9P9G0Wctqeu/qGhgIMc4sEJOAC43KKkb1
   9mctERyJEL5fega9tZUHlN1r2wBLse45bp05lv80QIIO8NQ+wvXUPbIe/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="293228766"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="293228766"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 01:14:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="583668044"
Received: from lkp-server02.sh.intel.com (HELO 81d7e1ade3ba) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 17 Aug 2022 01:14:14 -0700
Received: from kbuild by 81d7e1ade3ba with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oOEBq-0000is-0o;
        Wed, 17 Aug 2022 08:14:14 +0000
Date:   Wed, 17 Aug 2022 16:13:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>, yin31149@gmail.com
Cc:     kbuild-all@lists.01.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: Fix suspicious RCU usage in
 bpf_sk_reuseport_detach()
Message-ID: <202208171521.JiKYmnhP-lkp@intel.com>
References: <166065637961.4008018.10420960640773607710.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166065637961.4008018.10420960640773607710.stgit@warthog.procyon.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Howells/net-Fix-suspicious-RCU-usage-in-bpf_sk_reuseport_detach/20220816-212744
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git ae806c7805571a9813e41bf6763dd08d0706f4ed
config: x86_64-rhel-8.3-kvm (https://download.01.org/0day-ci/archive/20220817/202208171521.JiKYmnhP-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/fe74fdc1e7fe8aa84006265deb7b55f40bcc8736
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Howells/net-Fix-suspicious-RCU-usage-in-bpf_sk_reuseport_detach/20220816-212744
        git checkout fe74fdc1e7fe8aa84006265deb7b55f40bcc8736
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: kernel/bpf/reuseport_array.o: in function `bpf_sk_reuseport_detach':
>> kernel/bpf/reuseport_array.c:28: undefined reference to `lockdep_is_held'


vim +28 kernel/bpf/reuseport_array.c

    20	
    21	/* The caller must hold the reuseport_lock */
    22	void bpf_sk_reuseport_detach(struct sock *sk)
    23	{
    24		struct sock __rcu **socks;
    25	
    26		write_lock_bh(&sk->sk_callback_lock);
    27		socks = __rcu_dereference_sk_user_data_with_flags_check(
  > 28			sk, SK_USER_DATA_BPF, lockdep_is_held(&sk->sk_callback_lock));
    29		if (socks) {
    30			WRITE_ONCE(sk->sk_user_data, NULL);
    31			/*
    32			 * Do not move this NULL assignment outside of
    33			 * sk->sk_callback_lock because there is
    34			 * a race with reuseport_array_free()
    35			 * which does not hold the reuseport_lock.
    36			 */
    37			RCU_INIT_POINTER(*socks, NULL);
    38		}
    39		write_unlock_bh(&sk->sk_callback_lock);
    40	}
    41	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
