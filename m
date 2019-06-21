Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4D4EEE7
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfFUStF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:49:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:34424 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfFUStF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 14:49:05 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 11:49:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,401,1557212400"; 
   d="scan'208";a="165730818"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 21 Jun 2019 11:49:03 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1heOat-0007Cd-FP; Sat, 22 Jun 2019 02:49:03 +0800
Date:   Sat, 22 Jun 2019 02:48:23 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     kbuild-all@01.org, davem@davemloft.net, netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net] ipv6: fix neighbour resolution with raw socket
Message-ID: <201906220241.iq6BXV95%lkp@intel.com>
References: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Nicolas-Dichtel/ipv6-fix-neighbour-resolution-with-raw-socket/20190621-115455
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/vrf.c:363:17: sparse: sparse: incorrect type in assignment (different modifiers) @@    expected struct in6_addr *nexthop @@    got structstruct in6_addr *nexthop @@
>> drivers/net/vrf.c:363:17: sparse:    expected struct in6_addr *nexthop
>> drivers/net/vrf.c:363:17: sparse:    got struct in6_addr const *
   include/net/route.h:356:48: sparse: sparse: incorrect type in argument 2 (different base types) @@    expected unsigned int [usertype] key @@    got restrunsigned int [usertype] key @@
   include/net/route.h:356:48: sparse:    expected unsigned int [usertype] key
   include/net/route.h:356:48: sparse:    got restricted __be32 [usertype] daddr
   include/net/route.h:356:48: sparse: sparse: incorrect type in argument 2 (different base types) @@    expected unsigned int [usertype] key @@    got restrunsigned int [usertype] key @@
   include/net/route.h:356:48: sparse:    expected unsigned int [usertype] key
   include/net/route.h:356:48: sparse:    got restricted __be32 [usertype] daddr
--
>> net/bluetooth/6lowpan.c:188:25: sparse: sparse: incorrect type in assignment (different modifiers) @@    expected struct in6_addr *[assigned] nexthop @@    got t in6_addr *[assigned] nexthop @@
>> net/bluetooth/6lowpan.c:188:25: sparse:    expected struct in6_addr *[assigned] nexthop
>> net/bluetooth/6lowpan.c:188:25: sparse:    got struct in6_addr const *

vim +363 drivers/net/vrf.c

dcdd43c4 David Ahern      2017-03-20  345  
35402e31 David Ahern      2015-10-12  346  #if IS_ENABLED(CONFIG_IPV6)
35402e31 David Ahern      2015-10-12  347  /* modelled after ip6_finish_output2 */
35402e31 David Ahern      2015-10-12  348  static int vrf_finish_output6(struct net *net, struct sock *sk,
35402e31 David Ahern      2015-10-12  349  			      struct sk_buff *skb)
35402e31 David Ahern      2015-10-12  350  {
35402e31 David Ahern      2015-10-12  351  	struct dst_entry *dst = skb_dst(skb);
35402e31 David Ahern      2015-10-12  352  	struct net_device *dev = dst->dev;
35402e31 David Ahern      2015-10-12  353  	struct neighbour *neigh;
35402e31 David Ahern      2015-10-12  354  	struct in6_addr *nexthop;
35402e31 David Ahern      2015-10-12  355  	int ret;
35402e31 David Ahern      2015-10-12  356  
eb63ecc1 David Ahern      2016-12-14  357  	nf_reset(skb);
eb63ecc1 David Ahern      2016-12-14  358  
35402e31 David Ahern      2015-10-12  359  	skb->protocol = htons(ETH_P_IPV6);
35402e31 David Ahern      2015-10-12  360  	skb->dev = dev;
35402e31 David Ahern      2015-10-12  361  
35402e31 David Ahern      2015-10-12  362  	rcu_read_lock_bh();
35402e31 David Ahern      2015-10-12 @363  	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
35402e31 David Ahern      2015-10-12  364  	neigh = __ipv6_neigh_lookup_noref(dst->dev, nexthop);
35402e31 David Ahern      2015-10-12  365  	if (unlikely(!neigh))
35402e31 David Ahern      2015-10-12  366  		neigh = __neigh_create(&nd_tbl, nexthop, dst->dev, false);
35402e31 David Ahern      2015-10-12  367  	if (!IS_ERR(neigh)) {
4ff06203 Julian Anastasov 2017-02-06  368  		sock_confirm_neigh(skb, neigh);
0353f282 David Ahern      2019-04-05  369  		ret = neigh_output(neigh, skb, false);
35402e31 David Ahern      2015-10-12  370  		rcu_read_unlock_bh();
35402e31 David Ahern      2015-10-12  371  		return ret;
35402e31 David Ahern      2015-10-12  372  	}
35402e31 David Ahern      2015-10-12  373  	rcu_read_unlock_bh();
35402e31 David Ahern      2015-10-12  374  
35402e31 David Ahern      2015-10-12  375  	IP6_INC_STATS(dev_net(dst->dev),
35402e31 David Ahern      2015-10-12  376  		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
35402e31 David Ahern      2015-10-12  377  	kfree_skb(skb);
35402e31 David Ahern      2015-10-12  378  	return -EINVAL;
35402e31 David Ahern      2015-10-12  379  }
35402e31 David Ahern      2015-10-12  380  

:::::: The code at line 363 was first introduced by commit
:::::: 35402e31366349a32b505afdfe856aeeb8d939a0 net: Add IPv6 support to VRF device

:::::: TO: David Ahern <dsa@cumulusnetworks.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
