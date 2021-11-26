Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD73745F732
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 00:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241831AbhKZX2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 18:28:41 -0500
Received: from mga17.intel.com ([192.55.52.151]:63666 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhKZX0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 18:26:38 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10180"; a="216433142"
X-IronPort-AV: E=Sophos;i="5.87,267,1631602800"; 
   d="scan'208";a="216433142"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 15:23:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,267,1631602800"; 
   d="scan'208";a="675670557"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 26 Nov 2021 15:23:20 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mqkYq-0008kz-14; Fri, 26 Nov 2021 23:23:20 +0000
Date:   Sat, 27 Nov 2021 07:22:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, jiri@nvidia.com
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] devlink: use min() to make code cleaner
Message-ID: <202111270712.SjCO9Kz9-lkp@intel.com>
References: <20211125071414.53147-1-lv.ruyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125071414.53147-1-lv.ruyi@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.16-rc2 next-20211126]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/cgel-zte-gmail-com/devlink-use-min-to-make-code-cleaner/20211125-151715
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 5f53fa508db098c9d372423a6dac31c8a5679cdf
config: x86_64-randconfig-s022-20211126 (https://download.01.org/0day-ci/archive/20211127/202111270712.SjCO9Kz9-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/836e00794d541adc38bfd77e1714579f2223a231
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/devlink-use-min-to-make-code-cleaner/20211125-151715
        git checkout 836e00794d541adc38bfd77e1714579f2223a231
        # save the config file to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/core/devlink.c:5762:29: sparse: sparse: incompatible types in comparison expression (different type sizes):
>> net/core/devlink.c:5762:29: sparse:    unsigned long long *
>> net/core/devlink.c:5762:29: sparse:    int *

vim +5762 net/core/devlink.c

  5737	
  5738	static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
  5739							struct devlink *devlink,
  5740							struct devlink_region *region,
  5741							struct nlattr **attrs,
  5742							u64 start_offset,
  5743							u64 end_offset,
  5744							u64 *new_offset)
  5745	{
  5746		struct devlink_snapshot *snapshot;
  5747		u64 curr_offset = start_offset;
  5748		u32 snapshot_id;
  5749		int err = 0;
  5750	
  5751		*new_offset = start_offset;
  5752	
  5753		snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
  5754		snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
  5755		if (!snapshot)
  5756			return -EINVAL;
  5757	
  5758		while (curr_offset < end_offset) {
  5759			u32 data_size;
  5760			u8 *data;
  5761	
> 5762			data_size = min(end_offset - curr_offset, DEVLINK_REGION_READ_CHUNK_SIZE);
  5763	
  5764			data = &snapshot->data[curr_offset];
  5765			err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
  5766								    data, data_size,
  5767								    curr_offset);
  5768			if (err)
  5769				break;
  5770	
  5771			curr_offset += data_size;
  5772		}
  5773		*new_offset = curr_offset;
  5774	
  5775		return err;
  5776	}
  5777	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
