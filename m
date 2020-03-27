Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28700195318
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgC0ImQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:42:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:38588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgC0ImP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 04:42:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69F31B0AE;
        Fri, 27 Mar 2020 08:42:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 96B90E00A5; Fri, 27 Mar 2020 09:42:12 +0100 (CET)
Date:   Fri, 27 Mar 2020 09:42:12 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 11/12] ethtool: add timestamping related string
 sets
Message-ID: <20200327084212.GG31519@unicorn.suse.cz>
References: <105373960c4afeeea7b51459b9763b0452d6e660.1585267388.git.mkubecek@suse.cz>
 <202003271437.5LMEAGMc%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003271437.5LMEAGMc%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 02:55:36PM +0800, kbuild test robot wrote:
> Hi Michal,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> [also build test WARNING on next-20200326]
> [cannot apply to net/master linus/master v5.6-rc7]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Michal-Kubecek/ethtool-netlink-interface-part-4/20200327-122420
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5bb7357f45315138f623d08a615d23dd6ac26cf3
> config: nds32-defconfig (attached as .config)
> compiler: nds32le-linux-gcc (GCC) 9.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=9.2.0 make.cross ARCH=nds32 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    net/core/dev_ioctl.c: In function 'net_hwtstamp_validate':
> >> net/core/dev_ioctl.c:186:2: warning: enumeration value '__HWTSTAMP_TX_CNT' not handled in switch [-Wswitch]
>      186 |  switch (tx_type) {
>          |  ^~~~~~
> >> net/core/dev_ioctl.c:195:2: warning: enumeration value '__HWTSTAMP_FILTER_CNT' not handled in switch [-Wswitch]
>      195 |  switch (rx_filter) {
>          |  ^~~~~~

(kbuild bot omitted netdev list)

Something like below (probably with a better comment text) should get
rid of this warning.

Michal


diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index dbaebbe573f0..547b587c1950 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -190,6 +190,9 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	case HWTSTAMP_TX_ONESTEP_P2P:
 		tx_type_valid = 1;
 		break;
+	case __HWTSTAMP_TX_CNT:
+		/* not a real value */
+		break;
 	}
 
 	switch (rx_filter) {
@@ -211,6 +214,9 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	case HWTSTAMP_FILTER_NTP_ALL:
 		rx_filter_valid = 1;
 		break;
+	case __HWTSTAMP_FILTER_CNT:
+		/* not a real value */
+		break;
 	}
 
 	if (!tx_type_valid || !rx_filter_valid)
