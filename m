Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B2B57B3CF
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiGTJ3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238708AbiGTJ30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:29:26 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21215465D;
        Wed, 20 Jul 2022 02:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658309365; x=1689845365;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2DuSt0QvJZbYzemipvJzMJZJe6xxYK68zhMPGtzUfoc=;
  b=LLlw27yDP7LExfWEdpxdW/3gcObuHnPpm4WnXjqhN6IRYDcMjR3oDBa9
   dtrqditQMpx1I32sTp+cXMpBbWuoLikWlU+am1ndP37XPmemkP5y/yNH6
   o9mi3WahnsFxFBAYu0O7c7fod2xJtONJekXYOEU/qv0Y7Ahg+zsPGyQcF
   mF1/NoIF6ZAHRNwI/MY/2oBLu/cYP3gSXQNvu/exLVYrQ9kSk4wedNGUA
   xgFTzB8yo7MQSKobUwlEYTXJFnAYtmnh0RseICd3+B3z8Ajbtv7dBzWUA
   fXtvMg0Ogwf3wWYwfJJe3a8gM6Ush8OYEzgsWoxvFa5l6UwTl4MACzEcp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="287474436"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="287474436"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 02:29:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="548281972"
Received: from lkp-server01.sh.intel.com (HELO 7dfbdc7c7900) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2022 02:29:22 -0700
Received: from kbuild by 7dfbdc7c7900 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oE61B-0000LV-I6;
        Wed, 20 Jul 2022 09:29:21 +0000
Date:   Wed, 20 Jul 2022 17:28:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     kbuild-all@lists.01.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 07/11] net: phylink: Adjust link settings based on
 rate adaptation
Message-ID: <202207201727.9nqTCybA-lkp@intel.com>
References: <20220719235002.1944800-8-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719235002.1944800-8-sean.anderson@seco.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v5.19-rc7 next-20220719]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Anderson/net-phy-Add-support-for-rate-adaptation/20220720-075438
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 1f17708b47a99ca5bcad594a6f8d14cb016edfd2
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220720/202207201727.9nqTCybA-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/a17fd2b01914c1c5779a76167def6910a6dd1185
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-phy-Add-support-for-rate-adaptation/20220720-075438
        git checkout a17fd2b01914c1c5779a76167def6910a6dd1185
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "phy_rate_adaptation_to_str" [drivers/net/phy/phylink.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
