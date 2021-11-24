Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CAA45CF78
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 22:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245727AbhKXVyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 16:54:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:32688 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245638AbhKXVyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 16:54:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235325513"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235325513"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 13:51:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="457178197"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 24 Nov 2021 13:51:03 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mq0AQ-0005MW-6h; Wed, 24 Nov 2021 21:51:02 +0000
Date:   Thu, 25 Nov 2021 05:50:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 5/8] leds: trigger: netdev: add hardware control
 support
Message-ID: <202111250506.dija25Sg-lkp@intel.com>
References: <20211112153557.26941-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112153557.26941-6-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ansuel,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on linus/master v5.16-rc2 next-20211124]
[cannot apply to pavel-leds/for-next robh/for-next net-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ansuel-Smith/Adds-support-for-PHY-LEDs-with-offload-triggers/20211112-233807
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 5833291ab6de9c3e2374336b51c814e515e8f3a5
config: h8300-randconfig-s031-20211115 (https://download.01.org/0day-ci/archive/20211125/202111250506.dija25Sg-lkp@intel.com/config)
compiler: h8300-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/d5fdf1b98c9c9e1e89f59a3db1d863683be8e401
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ansuel-Smith/Adds-support-for-PHY-LEDs-with-offload-triggers/20211112-233807
        git checkout d5fdf1b98c9c9e1e89f59a3db1d863683be8e401
        # save the config file to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=h8300 SHELL=/bin/bash drivers/leds/trigger/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/leds/trigger/ledtrig-netdev.c:55:61: sparse: sparse: Using plain integer as NULL pointer
   drivers/leds/trigger/ledtrig-netdev.c:55:64: sparse: sparse: Using plain integer as NULL pointer

vim +55 drivers/leds/trigger/ledtrig-netdev.c

    44	
    45	static void set_baseline_state(struct led_netdev_data *trigger_data)
    46	{
    47		int current_brightness, can_offload;
    48		struct led_classdev *led_cdev = trigger_data->led_cdev;
    49	
    50		if (LED_HARDWARE_CONTROLLED & led_cdev->flags) {
    51			/* Check if blink mode can he set in hardware mode.
    52			 * The LED driver will chose a interval based on the trigger_data
    53			 * and its implementation.
    54			 */
  > 55			can_offload = led_cdev->blink_set(led_cdev, 0, 0);
    56	
    57			/* If blink_set doesn't return error we can run in hardware mode
    58			 * So actually activate it.
    59			 */
    60			if (!can_offload) {
    61				led_cdev->hw_control_start(led_cdev);
    62				return;
    63			}
    64		}
    65	
    66		/* If LED supports only hardware mode and we reach this point,
    67		 * then skip any software handling.
    68		 */
    69		if (!(LED_SOFTWARE_CONTROLLED & led_cdev->flags))
    70			return;
    71	
    72		current_brightness = led_cdev->brightness;
    73		if (current_brightness)
    74			led_cdev->blink_brightness = current_brightness;
    75		if (!led_cdev->blink_brightness)
    76			led_cdev->blink_brightness = led_cdev->max_brightness;
    77	
    78		if (!trigger_data->carrier_link_up) {
    79			led_set_brightness(led_cdev, LED_OFF);
    80		} else {
    81			if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
    82				led_set_brightness(led_cdev,
    83						   led_cdev->blink_brightness);
    84			else
    85				led_set_brightness(led_cdev, LED_OFF);
    86	
    87			/* If we are looking for RX/TX start periodically
    88			 * checking stats
    89			 */
    90			if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ||
    91			    test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
    92				schedule_delayed_work(&trigger_data->work, 0);
    93		}
    94	}
    95	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
