Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D508B4BB377
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 08:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiBRHok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 02:44:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiBRHok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 02:44:40 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBE2369F4;
        Thu, 17 Feb 2022 23:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645170264; x=1676706264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=osuNt80955OU32o0J/qG3+OwLv2mluxGXSTdoAxLuyg=;
  b=iIp4L3FwoET+R83VnREbCSU994EeM5uroK/zpMDDhTLItrCV8vghjlUn
   rIog4CeD1Irl2w9Rg5beS0rNrb9YLuDMlcf77YZD9J7RM19K798T9RYUn
   dOYekMvlzqMfm3A5w+2ayzaCTGH9Iq9j4ST20X4R5kr1Ibp0tss1i5nFf
   CbnvXRNntVldQbbDKgeUIgdQGfag2CXTNR+LUMY67mfxSL3/DQkIzXlUq
   lLW4sjSHxQT0dpMbW1cL1ZVulMD/XTOcd3vwjMEXoh8pchGOecZ+s7ScC
   RPCTNkjz4KU8E6Tz81gygYr9Y163aNw1qckXHin3YbvcFIITX5v/ho/v6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250830003"
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="250830003"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 23:44:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="635601194"
Received: from lkp-server01.sh.intel.com (HELO 6f05bf9e3301) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 17 Feb 2022 23:44:17 -0800
Received: from kbuild by 6f05bf9e3301 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nKxw8-00015I-KY; Fri, 18 Feb 2022 07:44:16 +0000
Date:   Fri, 18 Feb 2022 15:43:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Message-ID: <202202181535.l3nA3dto-lkp@intel.com>
References: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Christophe-Leroy/net-Use-csum_replace_-and-csum_sub-helpers-instead-of-opencoding/20220217-234555
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git c8b441d2fbd0e005541c7363fd5346971b6febcb
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220218/202202181535.l3nA3dto-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/cec9ed7cf59fe6dafcec0a30811024d22fad8cbd
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Christophe-Leroy/net-Use-csum_replace_-and-csum_sub-helpers-instead-of-opencoding/20220217-234555
        git checkout cec9ed7cf59fe6dafcec0a30811024d22fad8cbd
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   net/netfilter/nft_payload.c: note: in included file (through include/net/sctp/sctp.h, include/net/sctp/checksum.h):
   include/net/sctp/structs.h:335:41: sparse: sparse: array of flexible structures
>> net/netfilter/nft_payload.c:560:28: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] from @@     got restricted __wsum [usertype] fsum @@
   net/netfilter/nft_payload.c:560:28: sparse:     expected restricted __be32 [usertype] from
   net/netfilter/nft_payload.c:560:28: sparse:     got restricted __wsum [usertype] fsum
>> net/netfilter/nft_payload.c:560:34: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] to @@     got restricted __wsum [usertype] tsum @@
   net/netfilter/nft_payload.c:560:34: sparse:     expected restricted __be32 [usertype] to
   net/netfilter/nft_payload.c:560:34: sparse:     got restricted __wsum [usertype] tsum
>> net/netfilter/nft_payload.c:560:28: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] from @@     got restricted __wsum [usertype] fsum @@
   net/netfilter/nft_payload.c:560:28: sparse:     expected restricted __be32 [usertype] from
   net/netfilter/nft_payload.c:560:28: sparse:     got restricted __wsum [usertype] fsum
>> net/netfilter/nft_payload.c:560:34: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] to @@     got restricted __wsum [usertype] tsum @@
   net/netfilter/nft_payload.c:560:34: sparse:     expected restricted __be32 [usertype] to
   net/netfilter/nft_payload.c:560:34: sparse:     got restricted __wsum [usertype] tsum

vim +560 net/netfilter/nft_payload.c

   557	
   558	static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
   559	{
 > 560		csum_replace4(sum, fsum, tsum);
   561		if (*sum == 0)
   562			*sum = CSUM_MANGLED_0;
   563	}
   564	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
