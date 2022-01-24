Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5DD4981D7
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 15:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbiAXOPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 09:15:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:15264 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbiAXOPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 09:15:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643033755; x=1674569755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4IAiM5d1HQI9ZjI4owgrJCVfKSuWC7O2avNp+nqMEr4=;
  b=N8lLHuz55zA4lOENFq4ugHHEoBIORROeE8z0wfIbptseSyeKkPNquV34
   6wO/iyuRYRr5JcZyBCV4thdkMwn/oTo0QuE/wtmAlepl6d/jgFpKg1PdL
   fgBZxaa2rGSknTHIMjnMYsg4wlW2dzI3QP1+8uODdKx1GR/gsScMbA8K1
   yQSP/MJSKxs8iAA4wLu0btnivZLm0Ml8JlgRHvl30FNsrcFZB5GdhYt3f
   L+uitTF4BovCWMi/nfQkYRvNBovhvtWphqdHRQYBPBXXbllewDbEJ110M
   qHqcF2ryKwglCmgqRpPlO/WOJTRuBj6HYSiAc4TQpXwqXHe/qbrzHZLOb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="233413539"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="233413539"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 06:10:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="532087889"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jan 2022 06:10:43 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nC03P-000IQx-1o; Mon, 24 Jan 2022 14:10:43 +0000
Date:   Mon, 24 Jan 2022 22:09:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 1/3] net-zerocopy: split zerocopy receive to several parts
Message-ID: <202201242135.NjNu33RA-lkp@intel.com>
References: <20220124094320.900713-2-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124094320.900713-2-haoxu@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hao,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc1 next-20220124]
[cannot apply to horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Hao-Xu/io_uring-zerocopy-receive/20220124-174546
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0
config: sh-randconfig-r012-20220124 (https://download.01.org/0day-ci/archive/20220124/202201242135.NjNu33RA-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/8ed32d9a0fe79a5a05e30772afda62dc96232764
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Hao-Xu/io_uring-zerocopy-receive/20220124-174546
        git checkout 8ed32d9a0fe79a5a05e30772afda62dc96232764
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=sh SHELL=/bin/bash fs/ net/ipv4/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> net/ipv4/tcp.c:3939:5: warning: no previous prototype for 'zc_receive_check' [-Wmissing-prototypes]
    3939 | int zc_receive_check(struct tcp_zerocopy_receive *zc, int *lenp,
         |     ^~~~~~~~~~~~~~~~
   net/ipv4/tcp.c: In function 'zc_receive_check':
>> net/ipv4/tcp.c:3963:31: error: 'TCP_VALID_ZC_MSG_FLAGS' undeclared (first use in this function)
    3963 |         if (zc->msg_flags & ~(TCP_VALID_ZC_MSG_FLAGS))
         |                               ^~~~~~~~~~~~~~~~~~~~~~
   net/ipv4/tcp.c:3963:31: note: each undeclared identifier is reported only once for each function it appears in
   net/ipv4/tcp.c: At top level:
>> net/ipv4/tcp.c:3970:5: warning: no previous prototype for 'zc_receive_update' [-Wmissing-prototypes]
    3970 | int zc_receive_update(struct sock *sk, struct tcp_zerocopy_receive *zc, int len,
         |     ^~~~~~~~~~~~~~~~~
   net/ipv4/tcp.c: In function 'zc_receive_update':
>> net/ipv4/tcp.c:3995:17: error: implicit declaration of function 'tcp_zc_finalize_rx_tstamp' [-Werror=implicit-function-declaration]
    3995 |                 tcp_zc_finalize_rx_tstamp(sk, zc, tss);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/TCP_VALID_ZC_MSG_FLAGS +3963 net/ipv4/tcp.c

  3938	
> 3939	int zc_receive_check(struct tcp_zerocopy_receive *zc, int *lenp,
  3940			     char __user *optval, int __user *optlen)
  3941	{
  3942		int len = *lenp, err;
  3943	
  3944		if (get_user(len, optlen))
  3945			return -EFAULT;
  3946		if (len < 0 ||
  3947		    len < offsetofend(struct tcp_zerocopy_receive, length))
  3948			return -EINVAL;
  3949		if (unlikely(len > sizeof(*zc))) {
  3950			err = check_zeroed_user(optval + sizeof(*zc),
  3951						len - sizeof(*zc));
  3952			if (err < 1)
  3953				return err == 0 ? -EINVAL : err;
  3954			len = sizeof(*zc);
  3955			if (put_user(len, optlen))
  3956				return -EFAULT;
  3957		}
  3958		if (copy_from_user(zc, optval, len))
  3959			return -EFAULT;
  3960	
  3961		if (zc->reserved)
  3962			return -EINVAL;
> 3963		if (zc->msg_flags & ~(TCP_VALID_ZC_MSG_FLAGS))
  3964			return -EINVAL;
  3965	
  3966		*lenp = len;
  3967		return 0;
  3968	}
  3969	
> 3970	int zc_receive_update(struct sock *sk, struct tcp_zerocopy_receive *zc, int len,
  3971			      char __user *optval, struct scm_timestamping_internal *tss,
  3972			      int err)
  3973	{
  3974		sk_defer_free_flush(sk);
  3975		if (len >= offsetofend(struct tcp_zerocopy_receive, msg_flags))
  3976			goto zerocopy_rcv_cmsg;
  3977		switch (len) {
  3978		case offsetofend(struct tcp_zerocopy_receive, msg_flags):
  3979			goto zerocopy_rcv_cmsg;
  3980		case offsetofend(struct tcp_zerocopy_receive, msg_controllen):
  3981		case offsetofend(struct tcp_zerocopy_receive, msg_control):
  3982		case offsetofend(struct tcp_zerocopy_receive, flags):
  3983		case offsetofend(struct tcp_zerocopy_receive, copybuf_len):
  3984		case offsetofend(struct tcp_zerocopy_receive, copybuf_address):
  3985		case offsetofend(struct tcp_zerocopy_receive, err):
  3986			goto zerocopy_rcv_sk_err;
  3987		case offsetofend(struct tcp_zerocopy_receive, inq):
  3988			goto zerocopy_rcv_inq;
  3989		case offsetofend(struct tcp_zerocopy_receive, length):
  3990		default:
  3991			goto zerocopy_rcv_out;
  3992		}
  3993	zerocopy_rcv_cmsg:
  3994		if (zc->msg_flags & TCP_CMSG_TS)
> 3995			tcp_zc_finalize_rx_tstamp(sk, zc, tss);
  3996		else
  3997			zc->msg_flags = 0;
  3998	zerocopy_rcv_sk_err:
  3999		if (!err)
  4000			zc->err = sock_error(sk);
  4001	zerocopy_rcv_inq:
  4002		zc->inq = tcp_inq_hint(sk);
  4003	zerocopy_rcv_out:
  4004		if (!err && copy_to_user(optval, zc, len))
  4005			err = -EFAULT;
  4006		return err;
  4007	}
  4008	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
