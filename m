Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AAC1EDB9F
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 05:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgFDD2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 23:28:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:55413 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDD2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 23:28:51 -0400
IronPort-SDR: QWSl6jwIUcMp4j7uw45TC8lDXLVoz2ATULRlKYwEIgWM7klw6W9Ayhbq8fEkKUeiSh5sV6sOxp
 AoUPwet4Nc1Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 20:28:50 -0700
IronPort-SDR: MH7Od14Rrt4PYD/v/UL97A1EhvZiI0nFAd/A7WiZELVw1O3FO4ZAEng/TIwFS1J6w9d9h59jh3
 QQOThTqlgFjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,470,1583222400"; 
   d="scan'208";a="471389436"
Received: from lkp-server01.sh.intel.com (HELO 8bb2cd163565) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jun 2020 20:28:48 -0700
Received: from kbuild by 8bb2cd163565 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jggYh-0000Le-NB; Thu, 04 Jun 2020 03:28:47 +0000
Date:   Thu, 4 Jun 2020 11:28:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, edumazet@google.com, borisp@mellanox.com,
        secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: Re: [PATCH net-next] crypto/chtls: Fix compile error when
 CONFIG_IPV6 is disabled
Message-ID: <202006041135.KHGZmEJm%lkp@intel.com>
References: <20200603103317.653-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603103317.653-1-vinay.yadav@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinay,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Vinay-Kumar-Yadav/crypto-chtls-Fix-compile-error-when-CONFIG_IPV6-is-disabled/20200603-184315
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 065fcfd49763ec71ae345bb5c5a74f961031e70e
compiler: gcc-9 (Debian 9.3.0-13) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


cppcheck warnings: (new ones prefixed by >>)

>> drivers/crypto/chelsio/chtls/chtls_cm.c:700:6: warning: Uninitialized variable: ret [uninitvar]
    if (ret > 0)
        ^
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1151:7: warning: Uninitialized variable: n [uninitvar]
    if (!n)
         ^

vim +700 drivers/crypto/chelsio/chtls/chtls_cm.c

cc35c88ae4db21 Atul Gupta        2018-03-31  633  
cc35c88ae4db21 Atul Gupta        2018-03-31  634  int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
cc35c88ae4db21 Atul Gupta        2018-03-31  635  {
cc35c88ae4db21 Atul Gupta        2018-03-31  636  	struct net_device *ndev;
cc35c88ae4db21 Atul Gupta        2018-03-31  637  	struct listen_ctx *ctx;
cc35c88ae4db21 Atul Gupta        2018-03-31  638  	struct adapter *adap;
cc35c88ae4db21 Atul Gupta        2018-03-31  639  	struct port_info *pi;
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  640  	bool clip_valid;
cc35c88ae4db21 Atul Gupta        2018-03-31  641  	int stid;
cc35c88ae4db21 Atul Gupta        2018-03-31  642  	int ret;
cc35c88ae4db21 Atul Gupta        2018-03-31  643  
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  644  	clip_valid = false;
cc35c88ae4db21 Atul Gupta        2018-03-31  645  	rcu_read_lock();
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  646  	ndev = chtls_find_netdev(cdev, sk);
cc35c88ae4db21 Atul Gupta        2018-03-31  647  	rcu_read_unlock();
cc35c88ae4db21 Atul Gupta        2018-03-31  648  	if (!ndev)
cc35c88ae4db21 Atul Gupta        2018-03-31  649  		return -EBADF;
cc35c88ae4db21 Atul Gupta        2018-03-31  650  
cc35c88ae4db21 Atul Gupta        2018-03-31  651  	pi = netdev_priv(ndev);
cc35c88ae4db21 Atul Gupta        2018-03-31  652  	adap = pi->adapter;
80f61f19e542ae Arjun Vynipadath  2019-03-04  653  	if (!(adap->flags & CXGB4_FULL_INIT_DONE))
cc35c88ae4db21 Atul Gupta        2018-03-31  654  		return -EBADF;
cc35c88ae4db21 Atul Gupta        2018-03-31  655  
cc35c88ae4db21 Atul Gupta        2018-03-31  656  	if (listen_hash_find(cdev, sk) >= 0)   /* already have it */
cc35c88ae4db21 Atul Gupta        2018-03-31  657  		return -EADDRINUSE;
cc35c88ae4db21 Atul Gupta        2018-03-31  658  
cc35c88ae4db21 Atul Gupta        2018-03-31  659  	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
cc35c88ae4db21 Atul Gupta        2018-03-31  660  	if (!ctx)
cc35c88ae4db21 Atul Gupta        2018-03-31  661  		return -ENOMEM;
cc35c88ae4db21 Atul Gupta        2018-03-31  662  
cc35c88ae4db21 Atul Gupta        2018-03-31  663  	__module_get(THIS_MODULE);
cc35c88ae4db21 Atul Gupta        2018-03-31  664  	ctx->lsk = sk;
cc35c88ae4db21 Atul Gupta        2018-03-31  665  	ctx->cdev = cdev;
cc35c88ae4db21 Atul Gupta        2018-03-31  666  	ctx->state = T4_LISTEN_START_PENDING;
cc35c88ae4db21 Atul Gupta        2018-03-31  667  	skb_queue_head_init(&ctx->synq);
cc35c88ae4db21 Atul Gupta        2018-03-31  668  
cc35c88ae4db21 Atul Gupta        2018-03-31  669  	stid = cxgb4_alloc_stid(cdev->tids, sk->sk_family, ctx);
cc35c88ae4db21 Atul Gupta        2018-03-31  670  	if (stid < 0)
cc35c88ae4db21 Atul Gupta        2018-03-31  671  		goto free_ctx;
cc35c88ae4db21 Atul Gupta        2018-03-31  672  
cc35c88ae4db21 Atul Gupta        2018-03-31  673  	sock_hold(sk);
cc35c88ae4db21 Atul Gupta        2018-03-31  674  	if (!listen_hash_add(cdev, sk, stid))
cc35c88ae4db21 Atul Gupta        2018-03-31  675  		goto free_stid;
cc35c88ae4db21 Atul Gupta        2018-03-31  676  
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  677  	if (sk->sk_family == PF_INET) {
cc35c88ae4db21 Atul Gupta        2018-03-31  678  		ret = cxgb4_create_server(ndev, stid,
cc35c88ae4db21 Atul Gupta        2018-03-31  679  					  inet_sk(sk)->inet_rcv_saddr,
cc35c88ae4db21 Atul Gupta        2018-03-31  680  					  inet_sk(sk)->inet_sport, 0,
cc35c88ae4db21 Atul Gupta        2018-03-31  681  					  cdev->lldi->rxq_ids[0]);
015ca7982064b6 Vinay Kumar Yadav 2020-06-03  682  #if IS_ENABLED(CONFIG_IPV6)
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  683  	} else {
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  684  		int addr_type;
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  685  
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  686  		addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  687  		if (addr_type != IPV6_ADDR_ANY) {
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  688  			ret = cxgb4_clip_get(ndev, (const u32 *)
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  689  					     &sk->sk_v6_rcv_saddr, 1);
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  690  			if (ret)
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  691  				goto del_hash;
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  692  			clip_valid = true;
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  693  		}
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  694  		ret = cxgb4_create_server6(ndev, stid,
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  695  					   &sk->sk_v6_rcv_saddr,
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  696  					   inet_sk(sk)->inet_sport,
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  697  					   cdev->lldi->rxq_ids[0]);
015ca7982064b6 Vinay Kumar Yadav 2020-06-03  698  #endif
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  699  	}
cc35c88ae4db21 Atul Gupta        2018-03-31 @700  	if (ret > 0)
cc35c88ae4db21 Atul Gupta        2018-03-31  701  		ret = net_xmit_errno(ret);
cc35c88ae4db21 Atul Gupta        2018-03-31  702  	if (ret)
cc35c88ae4db21 Atul Gupta        2018-03-31  703  		goto del_hash;
cc35c88ae4db21 Atul Gupta        2018-03-31  704  	return 0;
cc35c88ae4db21 Atul Gupta        2018-03-31  705  del_hash:
015ca7982064b6 Vinay Kumar Yadav 2020-06-03  706  #if IS_ENABLED(CONFIG_IPV6)
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  707  	if (clip_valid)
6abde0b2412243 Vinay Kumar Yadav 2020-06-02  708  		cxgb4_clip_release(ndev, (const u32 *)&sk->sk_v6_rcv_saddr, 1);
015ca7982064b6 Vinay Kumar Yadav 2020-06-03  709  #endif
cc35c88ae4db21 Atul Gupta        2018-03-31  710  	listen_hash_del(cdev, sk);
cc35c88ae4db21 Atul Gupta        2018-03-31  711  free_stid:
cc35c88ae4db21 Atul Gupta        2018-03-31  712  	cxgb4_free_stid(cdev->tids, stid, sk->sk_family);
cc35c88ae4db21 Atul Gupta        2018-03-31  713  	sock_put(sk);
cc35c88ae4db21 Atul Gupta        2018-03-31  714  free_ctx:
cc35c88ae4db21 Atul Gupta        2018-03-31  715  	kfree(ctx);
cc35c88ae4db21 Atul Gupta        2018-03-31  716  	module_put(THIS_MODULE);
cc35c88ae4db21 Atul Gupta        2018-03-31  717  	return -EBADF;
cc35c88ae4db21 Atul Gupta        2018-03-31  718  }
cc35c88ae4db21 Atul Gupta        2018-03-31  719  

:::::: The code at line 700 was first introduced by commit
:::::: cc35c88ae4db219611e204375d6a4248bc0e84d6 crypto : chtls - CPL handler definition

:::::: TO: Atul Gupta <atul.gupta@chelsio.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
