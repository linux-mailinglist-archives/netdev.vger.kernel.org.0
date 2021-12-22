Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3458F47D962
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 23:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241825AbhLVWpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 17:45:08 -0500
Received: from mga12.intel.com ([192.55.52.136]:54452 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhLVWpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 17:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640213107; x=1671749107;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s+c+JTerOGh/4zsRfyWprt9/kpfHuhQZiUXD+ZUFe8k=;
  b=OcMW+zyOIPlRygNRO1hTQFfb4ZNYPky+ZX3WLiNuSGKPFxntE/0GrUXG
   +2LTxjb+StkAnmu4MXNUfh+eKpwuR+x5jTidzkTrxiUBRY5aADg9l8AY6
   u9O/G6hJaB4c62M+Ce5dk+SGxFGDi4sgzu5XzHj0TwpPWDit3FZcOG3n6
   BA1gf01KzE5P8Ja7ZjeHctSqcyVh7VbPyBQDjGCfFvXbtijwOScxfqZH8
   NFWcCwu7+cTQ2ZorlhJe3v+pXA60QnOfzRBTndamNqcdfMBGrTZ/8LMrU
   GCKOSRCw07Ks6Y7EY3JqEqv0+snb8sNZsjPVOaIKmfI/mL0tESCcadouc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="220729715"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="220729715"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 14:45:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="550025759"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 22 Dec 2021 14:45:04 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n0AM3-00011m-EE; Wed, 22 Dec 2021 22:45:03 +0000
Date:   Thu, 23 Dec 2021 06:44:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [net-next v6 1/2] net: sched: use queue_mapping to pick tx queue
Message-ID: <202112230652.grNJivfH-lkp@intel.com>
References: <20211222120809.2222-2-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222120809.2222-2-xiangxia.m.yue@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/xiangxia-m-yue-gmail-com/net-sched-allow-user-to-select-txqueue/20211222-201128
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f4f2970dfd87e5132c436e6125148914596a9863
config: i386-randconfig-m031-20211222 (https://download.01.org/0day-ci/archive/20211223/202112230652.grNJivfH-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

smatch warnings:
net/core/dev.c:4114 __dev_queue_xmit() warn: inconsistent indenting

vim +4114 net/core/dev.c

638b2a699fd3ec9 Jiri Pirko             2015-05-12  4036  
d29f749e252bcdb Dave Jones             2008-07-22  4037  /**
9d08dd3d320fab4 Jason Wang             2014-01-20  4038   *	__dev_queue_xmit - transmit a buffer
d29f749e252bcdb Dave Jones             2008-07-22  4039   *	@skb: buffer to transmit
eadec877ce9ca46 Alexander Duyck        2018-07-09  4040   *	@sb_dev: suboordinate device used for L2 forwarding offload
d29f749e252bcdb Dave Jones             2008-07-22  4041   *
d29f749e252bcdb Dave Jones             2008-07-22  4042   *	Queue a buffer for transmission to a network device. The caller must
d29f749e252bcdb Dave Jones             2008-07-22  4043   *	have set the device and priority and built the buffer before calling
d29f749e252bcdb Dave Jones             2008-07-22  4044   *	this function. The function can be called from an interrupt.
d29f749e252bcdb Dave Jones             2008-07-22  4045   *
d29f749e252bcdb Dave Jones             2008-07-22  4046   *	A negative errno code is returned on a failure. A success does not
d29f749e252bcdb Dave Jones             2008-07-22  4047   *	guarantee the frame will be transmitted as it may be dropped due
d29f749e252bcdb Dave Jones             2008-07-22  4048   *	to congestion or traffic shaping.
d29f749e252bcdb Dave Jones             2008-07-22  4049   *
d29f749e252bcdb Dave Jones             2008-07-22  4050   * -----------------------------------------------------------------------------------
d29f749e252bcdb Dave Jones             2008-07-22  4051   *      I notice this method can also return errors from the queue disciplines,
d29f749e252bcdb Dave Jones             2008-07-22  4052   *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
d29f749e252bcdb Dave Jones             2008-07-22  4053   *      be positive.
d29f749e252bcdb Dave Jones             2008-07-22  4054   *
d29f749e252bcdb Dave Jones             2008-07-22  4055   *      Regardless of the return value, the skb is consumed, so it is currently
d29f749e252bcdb Dave Jones             2008-07-22  4056   *      difficult to retry a send to this method.  (You can bump the ref count
d29f749e252bcdb Dave Jones             2008-07-22  4057   *      before sending to hold a reference for retry if you are careful.)
d29f749e252bcdb Dave Jones             2008-07-22  4058   *
d29f749e252bcdb Dave Jones             2008-07-22  4059   *      When calling this method, interrupts MUST be enabled.  This is because
d29f749e252bcdb Dave Jones             2008-07-22  4060   *      the BH enable code must have IRQs enabled so that it will not deadlock.
d29f749e252bcdb Dave Jones             2008-07-22  4061   *          --BLG
d29f749e252bcdb Dave Jones             2008-07-22  4062   */
eadec877ce9ca46 Alexander Duyck        2018-07-09  4063  static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
^1da177e4c3f415 Linus Torvalds         2005-04-16  4064  {
^1da177e4c3f415 Linus Torvalds         2005-04-16  4065  	struct net_device *dev = skb->dev;
dc2b48475a0a36f David S. Miller        2008-07-08  4066  	struct netdev_queue *txq;
^1da177e4c3f415 Linus Torvalds         2005-04-16  4067  	struct Qdisc *q;
^1da177e4c3f415 Linus Torvalds         2005-04-16  4068  	int rc = -ENOMEM;
f53c723902d1ac5 Steffen Klassert       2017-12-20  4069  	bool again = false;
^1da177e4c3f415 Linus Torvalds         2005-04-16  4070  
6d1ccff62780682 Eric Dumazet           2013-02-05  4071  	skb_reset_mac_header(skb);
6d1ccff62780682 Eric Dumazet           2013-02-05  4072  
e7fd2885385157d Willem de Bruijn       2014-08-04  4073  	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
e7ed11ee945438b Yousuk Seung           2021-01-20  4074  		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
e7fd2885385157d Willem de Bruijn       2014-08-04  4075  
^1da177e4c3f415 Linus Torvalds         2005-04-16  4076  	/* Disable soft irqs for various locks below. Also
^1da177e4c3f415 Linus Torvalds         2005-04-16  4077  	 * stops preemption for RCU.
^1da177e4c3f415 Linus Torvalds         2005-04-16  4078  	 */
d4828d85d188dc7 Herbert Xu             2006-06-22  4079  	rcu_read_lock_bh();
^1da177e4c3f415 Linus Torvalds         2005-04-16  4080  
5bc1421e34ecfe0 Neil Horman            2011-11-22  4081  	skb_update_prio(skb);
5bc1421e34ecfe0 Neil Horman            2011-11-22  4082  
1f211a1b929c804 Daniel Borkmann        2016-01-07  4083  	qdisc_pkt_len_init(skb);
1f211a1b929c804 Daniel Borkmann        2016-01-07  4084  #ifdef CONFIG_NET_CLS_ACT
8dc07fdbf2054f1 Willem de Bruijn       2017-01-07  4085  	skb->tc_at_ingress = 0;
42df6e1d221dddc Lukas Wunner           2021-10-08  4086  #endif
1f211a1b929c804 Daniel Borkmann        2016-01-07  4087  #ifdef CONFIG_NET_EGRESS
3435309167e51b1 Tonghao Zhang          2021-12-22  4088  	if (static_branch_unlikely(&txqueue_needed_key))
3435309167e51b1 Tonghao Zhang          2021-12-22  4089  		netdev_xmit_skip_txqueue(false);
3435309167e51b1 Tonghao Zhang          2021-12-22  4090  
aabf6772cc745f9 Davidlohr Bueso        2018-05-08  4091  	if (static_branch_unlikely(&egress_needed_key)) {
42df6e1d221dddc Lukas Wunner           2021-10-08  4092  		if (nf_hook_egress_active()) {
42df6e1d221dddc Lukas Wunner           2021-10-08  4093  			skb = nf_hook_egress(skb, &rc, dev);
42df6e1d221dddc Lukas Wunner           2021-10-08  4094  			if (!skb)
42df6e1d221dddc Lukas Wunner           2021-10-08  4095  				goto out;
42df6e1d221dddc Lukas Wunner           2021-10-08  4096  		}
42df6e1d221dddc Lukas Wunner           2021-10-08  4097  		nf_skip_egress(skb, true);
1f211a1b929c804 Daniel Borkmann        2016-01-07  4098  		skb = sch_handle_egress(skb, &rc, dev);
1f211a1b929c804 Daniel Borkmann        2016-01-07  4099  		if (!skb)
1f211a1b929c804 Daniel Borkmann        2016-01-07  4100  			goto out;
42df6e1d221dddc Lukas Wunner           2021-10-08  4101  		nf_skip_egress(skb, false);
1f211a1b929c804 Daniel Borkmann        2016-01-07  4102  	}
3435309167e51b1 Tonghao Zhang          2021-12-22  4103  
3435309167e51b1 Tonghao Zhang          2021-12-22  4104  	if (static_branch_unlikely(&txqueue_needed_key) &&
3435309167e51b1 Tonghao Zhang          2021-12-22  4105  	    netdev_xmit_txqueue_skipped())
3435309167e51b1 Tonghao Zhang          2021-12-22  4106  		txq = netdev_tx_queue_mapping(dev, skb);
3435309167e51b1 Tonghao Zhang          2021-12-22  4107  	else
1f211a1b929c804 Daniel Borkmann        2016-01-07  4108  #endif
3435309167e51b1 Tonghao Zhang          2021-12-22  4109  		txq = netdev_core_pick_tx(dev, skb, sb_dev);
3435309167e51b1 Tonghao Zhang          2021-12-22  4110  
0287587884b1504 Eric Dumazet           2014-10-05  4111  	/* If device/qdisc don't need skb->dst, release it right now while
0287587884b1504 Eric Dumazet           2014-10-05  4112  	 * its hot in this cpu cache.
0287587884b1504 Eric Dumazet           2014-10-05  4113  	 */
0287587884b1504 Eric Dumazet           2014-10-05 @4114  	if (dev->priv_flags & IFF_XMIT_DST_RELEASE)
0287587884b1504 Eric Dumazet           2014-10-05  4115  		skb_dst_drop(skb);
0287587884b1504 Eric Dumazet           2014-10-05  4116  	else
0287587884b1504 Eric Dumazet           2014-10-05  4117  		skb_dst_force(skb);
0287587884b1504 Eric Dumazet           2014-10-05  4118  
a898def29e4119b Paul E. McKenney       2010-02-22  4119  	q = rcu_dereference_bh(txq->qdisc);
37437bb2e1ae8af David S. Miller        2008-07-16  4120  
cf66ba58b5cb8b1 Koki Sanagi            2010-08-23  4121  	trace_net_dev_queue(skb);
^1da177e4c3f415 Linus Torvalds         2005-04-16  4122  	if (q->enqueue) {
bbd8a0d3a3b65d3 Krishna Kumar          2009-08-06  4123  		rc = __dev_xmit_skb(skb, q, dev, txq);
^1da177e4c3f415 Linus Torvalds         2005-04-16  4124  		goto out;
^1da177e4c3f415 Linus Torvalds         2005-04-16  4125  	}
^1da177e4c3f415 Linus Torvalds         2005-04-16  4126  
^1da177e4c3f415 Linus Torvalds         2005-04-16  4127  	/* The device has no queue. Common case for software devices:
eb13da1a103a808 tcharding              2017-02-09  4128  	 * loopback, all the sorts of tunnels...
^1da177e4c3f415 Linus Torvalds         2005-04-16  4129  
eb13da1a103a808 tcharding              2017-02-09  4130  	 * Really, it is unlikely that netif_tx_lock protection is necessary
eb13da1a103a808 tcharding              2017-02-09  4131  	 * here.  (f.e. loopback and IP tunnels are clean ignoring statistics
eb13da1a103a808 tcharding              2017-02-09  4132  	 * counters.)
eb13da1a103a808 tcharding              2017-02-09  4133  	 * However, it is possible, that they rely on protection
eb13da1a103a808 tcharding              2017-02-09  4134  	 * made by us here.
^1da177e4c3f415 Linus Torvalds         2005-04-16  4135  
eb13da1a103a808 tcharding              2017-02-09  4136  	 * Check this and shot the lock. It is not prone from deadlocks.
eb13da1a103a808 tcharding              2017-02-09  4137  	 *Either shot noqueue qdisc, it is even simpler 8)
^1da177e4c3f415 Linus Torvalds         2005-04-16  4138  	 */
^1da177e4c3f415 Linus Torvalds         2005-04-16  4139  	if (dev->flags & IFF_UP) {
^1da177e4c3f415 Linus Torvalds         2005-04-16  4140  		int cpu = smp_processor_id(); /* ok because BHs are off */
^1da177e4c3f415 Linus Torvalds         2005-04-16  4141  
7a10d8c810cfad3 Eric Dumazet           2021-11-30  4142  		/* Other cpus might concurrently change txq->xmit_lock_owner
7a10d8c810cfad3 Eric Dumazet           2021-11-30  4143  		 * to -1 or to their cpu id, but not to our id.
7a10d8c810cfad3 Eric Dumazet           2021-11-30  4144  		 */
7a10d8c810cfad3 Eric Dumazet           2021-11-30  4145  		if (READ_ONCE(txq->xmit_lock_owner) != cpu) {
97cdcf37b57e3f2 Florian Westphal       2019-04-01  4146  			if (dev_xmit_recursion())
745e20f1b626b1b Eric Dumazet           2010-09-29  4147  				goto recursion_alert;
745e20f1b626b1b Eric Dumazet           2010-09-29  4148  
f53c723902d1ac5 Steffen Klassert       2017-12-20  4149  			skb = validate_xmit_skb(skb, dev, &again);
1f59533f9ca5634 Jesper Dangaard Brouer 2014-09-03  4150  			if (!skb)
d21fd63ea385620 Eric Dumazet           2016-04-12  4151  				goto out;
1f59533f9ca5634 Jesper Dangaard Brouer 2014-09-03  4152  
3744741adab6d91 Willy Tarreau          2020-08-10  4153  			PRANDOM_ADD_NOISE(skb, dev, txq, jiffies);
c773e847ea8f681 David S. Miller        2008-07-08  4154  			HARD_TX_LOCK(dev, txq, cpu);
^1da177e4c3f415 Linus Torvalds         2005-04-16  4155  
7346649826382b7 Tom Herbert            2011-11-28  4156  			if (!netif_xmit_stopped(txq)) {
97cdcf37b57e3f2 Florian Westphal       2019-04-01  4157  				dev_xmit_recursion_inc();
ce93718fb7cdbc0 David S. Miller        2014-08-30  4158  				skb = dev_hard_start_xmit(skb, dev, txq, &rc);
97cdcf37b57e3f2 Florian Westphal       2019-04-01  4159  				dev_xmit_recursion_dec();
572a9d7b6fc7f20 Patrick McHardy        2009-11-10  4160  				if (dev_xmit_complete(rc)) {
c773e847ea8f681 David S. Miller        2008-07-08  4161  					HARD_TX_UNLOCK(dev, txq);
^1da177e4c3f415 Linus Torvalds         2005-04-16  4162  					goto out;
^1da177e4c3f415 Linus Torvalds         2005-04-16  4163  				}
^1da177e4c3f415 Linus Torvalds         2005-04-16  4164  			}
c773e847ea8f681 David S. Miller        2008-07-08  4165  			HARD_TX_UNLOCK(dev, txq);
e87cc4728f0e2fb Joe Perches            2012-05-13  4166  			net_crit_ratelimited("Virtual device %s asks to queue packet!\n",
7b6cd1ce72176e2 Joe Perches            2012-02-01  4167  					     dev->name);
^1da177e4c3f415 Linus Torvalds         2005-04-16  4168  		} else {
^1da177e4c3f415 Linus Torvalds         2005-04-16  4169  			/* Recursion is detected! It is possible,
745e20f1b626b1b Eric Dumazet           2010-09-29  4170  			 * unfortunately
745e20f1b626b1b Eric Dumazet           2010-09-29  4171  			 */
745e20f1b626b1b Eric Dumazet           2010-09-29  4172  recursion_alert:
e87cc4728f0e2fb Joe Perches            2012-05-13  4173  			net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
7b6cd1ce72176e2 Joe Perches            2012-02-01  4174  					     dev->name);
^1da177e4c3f415 Linus Torvalds         2005-04-16  4175  		}
^1da177e4c3f415 Linus Torvalds         2005-04-16  4176  	}
^1da177e4c3f415 Linus Torvalds         2005-04-16  4177  
^1da177e4c3f415 Linus Torvalds         2005-04-16  4178  	rc = -ENETDOWN;
d4828d85d188dc7 Herbert Xu             2006-06-22  4179  	rcu_read_unlock_bh();
^1da177e4c3f415 Linus Torvalds         2005-04-16  4180  
015f0688f57ca4d Eric Dumazet           2014-03-27  4181  	atomic_long_inc(&dev->tx_dropped);
1f59533f9ca5634 Jesper Dangaard Brouer 2014-09-03  4182  	kfree_skb_list(skb);
^1da177e4c3f415 Linus Torvalds         2005-04-16  4183  	return rc;
^1da177e4c3f415 Linus Torvalds         2005-04-16  4184  out:
d4828d85d188dc7 Herbert Xu             2006-06-22  4185  	rcu_read_unlock_bh();
^1da177e4c3f415 Linus Torvalds         2005-04-16  4186  	return rc;
^1da177e4c3f415 Linus Torvalds         2005-04-16  4187  }
f663dd9aaf9ed12 Jason Wang             2014-01-10  4188  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
