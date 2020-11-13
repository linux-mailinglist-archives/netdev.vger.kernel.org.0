Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608742B1455
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgKMChW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:37:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:6073 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgKMChW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 21:37:22 -0500
IronPort-SDR: 5k8iJIjIP7zc7blM1UFLRETOXSDeXMe+8Z5jXY6ynHDQ7bT6p+H8B7TaGqOhVYkM5jI26AmHFk
 qPu80i4mCXpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="167835180"
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="gz'50?scan'50,208,50";a="167835180"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 18:37:12 -0800
IronPort-SDR: YIVNVwWzBBdhGmp1o2wffuSJKyVdmFMqBjx2ofcxL/hLW0SD6Y58gedYJjKe5hRgHOCUFrbzRS
 RlwqIIDQPCiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="gz'50?scan'50,208,50";a="366581803"
Received: from lkp-server02.sh.intel.com (HELO 6c110fa9b5d1) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Nov 2020 18:37:09 -0800
Received: from kbuild by 6c110fa9b5d1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kdOxZ-00008g-62; Fri, 13 Nov 2020 02:37:09 +0000
Date:   Fri, 13 Nov 2020 10:36:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
Subject: Re: [net-next 1/8] tcp: Copy straggler unaligned data for TCP Rx.
 zerocopy.
Message-ID: <202011131006.fYay8JNw-lkp@intel.com>
References: <20201112190205.633640-2-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20201112190205.633640-2-arjunroy.kdev@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arjun,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Arjun-Roy/Perf-optimizations-for-TCP-Recv-Zerocopy/20201113-030506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git e545f86573937142b8a90bd65d476b9f001088cf
config: nds32-defconfig (attached as .config)
compiler: nds32le-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/5c20c7c34817692f87427a655374172f6666d8ed
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Arjun-Roy/Perf-optimizations-for-TCP-Recv-Zerocopy/20201113-030506
        git checkout 5c20c7c34817692f87427a655374172f6666d8ed
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=nds32 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/ipv4/tcp.c: In function 'tcp_copy_straggler_data':
>> net/ipv4/tcp.c:1754:34: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    1754 |  err = import_single_range(READ, (void __user *)zc->copybuf_address,
         |                                  ^

vim +1754 net/ipv4/tcp.c

  1745	
  1746	static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
  1747					   struct sk_buff *skb, u32 copylen,
  1748					   u32 *offset, u32 *seq)
  1749	{
  1750		struct msghdr msg = {};
  1751		struct iovec iov;
  1752		int err;
  1753	
> 1754		err = import_single_range(READ, (void __user *)zc->copybuf_address,
  1755					  copylen, &iov, &msg.msg_iter);
  1756		if (err)
  1757			return err;
  1758		err = skb_copy_datagram_msg(skb, *offset, &msg, copylen);
  1759		if (err)
  1760			return err;
  1761		zc->recv_skip_hint -= copylen;
  1762		*offset += copylen;
  1763		*seq += copylen;
  1764		return (__s32)copylen;
  1765	}
  1766	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--HcAYCG3uE/tztfnV
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--HcAYCG3uE/tztfnV--
