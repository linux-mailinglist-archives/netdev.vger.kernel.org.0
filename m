Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C58659688A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 07:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiHQFUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 01:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiHQFUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 01:20:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154ED7B1DA;
        Tue, 16 Aug 2022 22:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660713614; x=1692249614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5bt+yEaFkDJZ0T4WXPCC3lkGJnzqfu9H6YHaGlGTsZU=;
  b=bOP//bJCRzJWiwt4W+aO3x9Z3wLM9IQZjVpk5TQDLczPetpfxZmPW3Ex
   hw9kiMBUpVwPtfsBiArLsxbJb9SWeVaCmmmrN9fwswL/Q+ddvS2IICJjO
   z/eU7ySPppM862LQrl4qCKw9r9OVYbLsZztBmmjoaE+vsun8Ups3Skx3u
   /FbJpEQPkP0nIVMB37wMX37F1Tpi93V0vIVMymkD8xitSvZx0Paz9q4wQ
   swyNz02XZIz/qjiLCpEsAFBHfg+rddsSHM665LqvurnDwOmO8Hv7qXb8I
   erpK8z5J+YpCcy+22sIvwVnFIUJBaet1RyBepN3S0BLLLh4p0jLaYVFjv
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="354147473"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="354147473"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 22:20:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="749573739"
Received: from lkp-server02.sh.intel.com (HELO 81d7e1ade3ba) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 16 Aug 2022 22:20:11 -0700
Received: from kbuild by 81d7e1ade3ba with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oOBTP-0000bi-0i;
        Wed, 17 Aug 2022 05:20:11 +0000
Date:   Wed, 17 Aug 2022 13:19:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>, yin31149@gmail.com
Cc:     kbuild-all@lists.01.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: Fix suspicious RCU usage in
 bpf_sk_reuseport_detach()
Message-ID: <202208171301.3cD4S3Ui-lkp@intel.com>
References: <166065637961.4008018.10420960640773607710.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166065637961.4008018.10420960640773607710.stgit@warthog.procyon.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
config: nios2-buildonly-randconfig-r001-20220815 (https://download.01.org/0day-ci/archive/20220817/202208171301.3cD4S3Ui-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fe74fdc1e7fe8aa84006265deb7b55f40bcc8736
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Howells/net-Fix-suspicious-RCU-usage-in-bpf_sk_reuseport_detach/20220816-212744
        git checkout fe74fdc1e7fe8aa84006265deb7b55f40bcc8736
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   nios2-linux-ld: kernel/bpf/reuseport_array.o: in function `bpf_sk_reuseport_detach':
>> reuseport_array.c:(.text+0x368): undefined reference to `lockdep_is_held'
   reuseport_array.c:(.text+0x368): relocation truncated to fit: R_NIOS2_CALL26 against `lockdep_is_held'
   `adc3xxx_i2c_remove' referenced in section `.data' of sound/soc/codecs/tlv320adc3xxx.o: defined in discarded section `.exit.text' of sound/soc/codecs/tlv320adc3xxx.o

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
