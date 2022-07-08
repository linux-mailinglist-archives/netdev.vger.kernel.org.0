Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBF856B5EA
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 11:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbiGHJqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 05:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiGHJqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 05:46:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A0B7C18F;
        Fri,  8 Jul 2022 02:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657273606; x=1688809606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=58AK5+8PgyaQZBsNdP1u1fcyExfdKZdanD5BE5OQyfM=;
  b=g2+mzRR4hdTsB+i99GojniC5w0awwihpMC1KG0IhU+/CspeTzpFuxQZT
   9napFjrZFR2KyCHDDnEVnd1Mz0r+CKtZG3S/vmBK9eWgRpR+30Kbi0/Qr
   G0HaZD1bz26IKlm4IZg8Ysik9zUxFHYbAf7X6MlrJ1dfPln5XVZxp73B+
   XXigQZ2KxKp3kJnl7nlYUaksLBDDqQ+aLIIGJBTs3/AvYD1GcXcg0aZio
   kyM6tAQ0N2URgn9qqTMBfHLLibiJPXzHsHKsEqosWHoWmP1fqEmQpnaLa
   DcW/6kV9uFh1jWiKmQJzihUGN8HVmFKqCyXNdiETaps8fD0a7sgkCUUAC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="282995818"
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="282995818"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 02:46:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="840253054"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jul 2022 02:46:41 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9kZM-000NIC-Hr;
        Fri, 08 Jul 2022 09:46:40 +0000
Date:   Fri, 8 Jul 2022 17:46:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hans Schultz <netdev@kapio-technology.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 5/6] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <202207081751.PPV8GRpf-lkp@intel.com>
References: <20220707152930.1789437-6-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707152930.1789437-6-netdev@kapio-technology.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hans,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on shuah-kselftest/next linus/master v5.19-rc5]
[cannot apply to net-next/master next-20220707]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hans-Schultz/Extend-locked-port-feature-with-FDB-locked-flag-MAC-Auth-MAB/20220707-233246
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 07266d066301b97ad56a693f81b29b7ced429b27
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220708/202207081751.PPV8GRpf-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 562c3467a6738aa89203f72fc1d1343e5baadf3c)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/74f76ae0b0d4b12864a0cf5ff3c0685bc420aea3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hans-Schultz/Extend-locked-port-feature-with-FDB-locked-flag-MAC-Auth-MAB/20220707-233246
        git checkout 74f76ae0b0d4b12864a0cf5ff3c0685bc420aea3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/dsa/mv88e6xxx/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/dsa/mv88e6xxx/chip.c:1696:6: warning: variable 'err' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (mv88e6xxx_port_is_locked(chip, port))
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/dsa/mv88e6xxx/chip.c:1698:6: note: uninitialized use occurs here
           if (err)
               ^~~
   drivers/net/dsa/mv88e6xxx/chip.c:1696:2: note: remove the 'if' if its condition is always true
           if (mv88e6xxx_port_is_locked(chip, port))
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/dsa/mv88e6xxx/chip.c:1694:9: note: initialize the variable 'err' to silence this warning
           int err;
                  ^
                   = 0
   1 warning generated.


vim +1696 drivers/net/dsa/mv88e6xxx/chip.c

  1690	
  1691	static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
  1692	{
  1693		struct mv88e6xxx_chip *chip = ds->priv;
  1694		int err;
  1695	
> 1696		if (mv88e6xxx_port_is_locked(chip, port))
  1697			err = mv88e6xxx_atu_locked_entry_flush(ds, port);
  1698		if (err)
  1699			dev_err(chip->ds->dev, "p%d: failed to clear locked entries: %d\n",
  1700				port, err);
  1701	
  1702		mv88e6xxx_reg_lock(chip);
  1703		err = mv88e6xxx_port_fast_age_fid(chip, port, 0);
  1704		mv88e6xxx_reg_unlock(chip);
  1705	
  1706		if (err)
  1707			dev_err(chip->ds->dev, "p%d: failed to flush ATU: %d\n",
  1708				port, err);
  1709	}
  1710	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
