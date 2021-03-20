Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4104342A45
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 04:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTDsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 23:48:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:41612 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhCTDr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 23:47:59 -0400
IronPort-SDR: Af6bSwsTk4Xbz65FIdnODV2Ya3MAbqdpyfhvHGxUq/7zZ8+6Cu4hVj3Kea0AOVADDSqZesSBnd
 NmY64xtEkSQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="169940323"
X-IronPort-AV: E=Sophos;i="5.81,263,1610438400"; 
   d="scan'208";a="169940323"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 20:47:58 -0700
IronPort-SDR: Td8dh0iTmDpxTDtM8kXIomaMtbtW0x8N7mDeNB3WLbplLbYLk/wHZ7+gmJRddNIlhHez2RJ9vY
 rNPF10XsnVOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,263,1610438400"; 
   d="scan'208";a="512695394"
Received: from lkp-server02.sh.intel.com (HELO 1c294c63cb86) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 19 Mar 2021 20:47:56 -0700
Received: from kbuild by 1c294c63cb86 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lNSah-0002J6-I0; Sat, 20 Mar 2021 03:47:55 +0000
Date:   Sat, 20 Mar 2021 11:47:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org
Subject: Re: [PATCH v7 bpf-next 09/14] bpd: add multi-buffer support to xdp
 copy helpers
Message-ID: <202103201112.Qq22IgkP-lkp@intel.com>
References: <d7e913be6855a2aeaaff16de39960b38afd06da7.1616179034.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7e913be6855a2aeaaff16de39960b38afd06da7.1616179034.git.lorenzo@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Lorenzo-Bianconi/mvneta-introduce-XDP-multi-buffer-support/20210320-055103
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
compiler: nios2-linux-gcc (GCC) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


cppcheck warnings: (new ones prefixed by >>)
        ^
   net/core/filter.c:10085:6: note: Variable 'ret' is reassigned a value before the old one has been used.
    ret = -EACCES;
        ^
   net/core/filter.c:10090:6: note: Variable 'ret' is reassigned a value before the old one has been used.
    ret = fprog->len;
        ^
>> net/core/filter.c:4593:30: warning: Uninitialized variable: copy_len [uninitvar]
     memcpy(dst_buff, src_buff, copy_len);
                                ^

vim +4593 net/core/filter.c

  4551	
  4552	static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
  4553					  unsigned long off, unsigned long len)
  4554	{
  4555		struct xdp_buff *xdp = (struct xdp_buff *)ctx;
  4556		struct xdp_shared_info *xdp_sinfo;
  4557		unsigned long base_len;
  4558		const void *src_buff;
  4559	
  4560		if (likely(!xdp->mb)) {
  4561			src_buff = xdp->data;
  4562			memcpy(dst_buff, src_buff + off, len);
  4563	
  4564			return 0;
  4565		}
  4566	
  4567		base_len = xdp->data_end - xdp->data;
  4568		xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
  4569		do {
  4570			unsigned long copy_len;
  4571	
  4572			if (off < base_len) {
  4573				src_buff = xdp->data + off;
  4574				copy_len = min(len, base_len - off);
  4575			} else {
  4576				unsigned long frag_off_total = base_len;
  4577				int i;
  4578	
  4579				for (i = 0; i < xdp_sinfo->nr_frags; i++) {
  4580					skb_frag_t *frag = &xdp_sinfo->frags[i];
  4581					unsigned long frag_len = xdp_get_frag_size(frag);
  4582					unsigned long frag_off = off - frag_off_total;
  4583	
  4584					if (frag_off < frag_len) {
  4585						src_buff = xdp_get_frag_address(frag) +
  4586							   frag_off;
  4587						copy_len = min(len, frag_len - frag_off);
  4588						break;
  4589					}
  4590					frag_off_total += frag_len;
  4591				}
  4592			}
> 4593			memcpy(dst_buff, src_buff, copy_len);
  4594			off += copy_len;
  4595			len -= copy_len;
  4596			dst_buff += copy_len;
  4597		} while (len);
  4598	
  4599		return 0;
  4600	}
  4601	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
