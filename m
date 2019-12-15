Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB55A11FA44
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 19:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLOSCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 13:02:16 -0500
Received: from mga17.intel.com ([192.55.52.151]:50940 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbfLOSCQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 13:02:16 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Dec 2019 10:02:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,318,1571727600"; 
   d="gz'50?scan'50,208,50";a="209064295"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 15 Dec 2019 10:02:13 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1igYDc-0007g1-Qo; Mon, 16 Dec 2019 02:02:12 +0800
Date:   Mon, 16 Dec 2019 02:01:37 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [vhost:linux-next 12/12] drivers/vhost/vhost.c:1968:11: note: in
 expansion of macro 'min'
Message-ID: <201912160232.Nx7Wm6rX%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ecblupgiwutwm7nf"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ecblupgiwutwm7nf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
head:   b072ae74df177c3ad7704c5fbe66e3f10aad9d4e
commit: b072ae74df177c3ad7704c5fbe66e3f10aad9d4e [12/12] vhost: use vhost_desc instead of vhost_log
config: s390-debug_defconfig (attached as .config)
compiler: s390-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout b072ae74df177c3ad7704c5fbe66e3f10aad9d4e
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/list.h:9:0,
                    from include/linux/wait.h:7,
                    from include/linux/eventfd.h:13,
                    from drivers/vhost/vhost.c:13:
   drivers/vhost/vhost.c: In function 'vhost_log_write':
   include/linux/kernel.h:844:29: warning: comparison of distinct pointer types lacks a cast
      (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                                ^
   include/linux/kernel.h:858:4: note: in expansion of macro '__typecheck'
      (__typecheck(x, y) && __no_side_effects(x, y))
       ^~~~~~~~~~~
   include/linux/kernel.h:868:24: note: in expansion of macro '__safe_cmp'
     __builtin_choose_expr(__safe_cmp(x, y), \
                           ^~~~~~~~~~
   include/linux/kernel.h:877:19: note: in expansion of macro '__careful_cmp'
    #define min(x, y) __careful_cmp(x, y, <)
                      ^~~~~~~~~~~~~
>> drivers/vhost/vhost.c:1968:11: note: in expansion of macro 'min'
      u64 l = min(log[i].len, len);
              ^~~

vim +/min +1968 drivers/vhost/vhost.c

cc5e710759470b Jason Wang         2019-01-16  1948  
b072ae74df177c Michael S. Tsirkin 2019-12-11  1949  int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_desc *log,
cc5e710759470b Jason Wang         2019-01-16  1950  		    unsigned int log_num, u64 len, struct iovec *iov, int count)
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1951  {
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1952  	int i, r;
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1953  
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1954  	/* Make sure data written is seen before log. */
5659338c88963e Michael S. Tsirkin 2010-02-01  1955  	smp_wmb();
cc5e710759470b Jason Wang         2019-01-16  1956  
cc5e710759470b Jason Wang         2019-01-16  1957  	if (vq->iotlb) {
cc5e710759470b Jason Wang         2019-01-16  1958  		for (i = 0; i < count; i++) {
cc5e710759470b Jason Wang         2019-01-16  1959  			r = log_write_hva(vq, (uintptr_t)iov[i].iov_base,
cc5e710759470b Jason Wang         2019-01-16  1960  					  iov[i].iov_len);
cc5e710759470b Jason Wang         2019-01-16  1961  			if (r < 0)
cc5e710759470b Jason Wang         2019-01-16  1962  				return r;
cc5e710759470b Jason Wang         2019-01-16  1963  		}
cc5e710759470b Jason Wang         2019-01-16  1964  		return 0;
cc5e710759470b Jason Wang         2019-01-16  1965  	}
cc5e710759470b Jason Wang         2019-01-16  1966  
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1967  	for (i = 0; i < log_num; ++i) {
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14 @1968  		u64 l = min(log[i].len, len);
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1969  		r = log_write(vq->log_base, log[i].addr, l);
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1970  		if (r < 0)
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1971  			return r;
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1972  		len -= l;
5786aee8bf6d74 Michael S. Tsirkin 2010-09-22  1973  		if (!len) {
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1974  			if (vq->log_ctx)
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1975  				eventfd_signal(vq->log_ctx, 1);
5786aee8bf6d74 Michael S. Tsirkin 2010-09-22  1976  			return 0;
5786aee8bf6d74 Michael S. Tsirkin 2010-09-22  1977  		}
5786aee8bf6d74 Michael S. Tsirkin 2010-09-22  1978  	}
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1979  	/* Length written exceeds what we have stored. This is a bug. */
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1980  	BUG();
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1981  	return 0;
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1982  }
6ac1afbf6132df Asias He           2013-05-06  1983  EXPORT_SYMBOL_GPL(vhost_log_write);
3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1984  

:::::: The code at line 1968 was first introduced by commit
:::::: 3a4d5c94e959359ece6d6b55045c3f046677f55c vhost_net: a kernel-level virtio server

:::::: TO: Michael S. Tsirkin <mst@redhat.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--ecblupgiwutwm7nf
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
+rzLt0P9aLIrsY4s8nj6v+7uh8hZMgEA

--ecblupgiwutwm7nf--
