Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124F4138685
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732705AbgALMzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:55:49 -0500
Received: from mga14.intel.com ([192.55.52.115]:62680 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732667AbgALMzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 07:55:49 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2020 04:55:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,425,1571727600"; 
   d="scan'208";a="241846808"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 12 Jan 2020 04:55:46 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iqcmQ-00059I-5B; Sun, 12 Jan 2020 20:55:46 +0800
Date:   Sun, 12 Jan 2020 20:55:17 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     kbuild-all@lists.01.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2 03/11] net, sk_msg: Clear sk_user_data
 pointer on clone if tagged
Message-ID: <202001121818.1Uz3HxtE%lkp@intel.com>
References: <20200110105027.257877-4-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110105027.257877-4-jakub@cloudflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]
[also build test WARNING on bpf/master net/master net-next/master linus/master ipvs/master v5.5-rc5 next-20200110]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Jakub-Sitnicki/Extend-SOCKMAP-to-store-listening-sockets/20200111-045213
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   include/trace/events/sock.h:177:1: sparse: sparse: directive in macro's argument list
   include/trace/events/sock.h:184:1: sparse: sparse: directive in macro's argument list
>> net/core/sock.c:1871:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
>> net/core/sock.c:1871:25: sparse:    void [noderef] <asn:4> *
>> net/core/sock.c:1871:25: sparse:    void *

vim +1871 net/core/sock.c

  1785	
  1786	/**
  1787	 *	sk_clone_lock - clone a socket, and lock its clone
  1788	 *	@sk: the socket to clone
  1789	 *	@priority: for allocation (%GFP_KERNEL, %GFP_ATOMIC, etc)
  1790	 *
  1791	 *	Caller must unlock socket even in error path (bh_unlock_sock(newsk))
  1792	 */
  1793	struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
  1794	{
  1795		struct proto *prot = READ_ONCE(sk->sk_prot);
  1796		struct sock *newsk;
  1797		bool is_charged = true;
  1798	
  1799		newsk = sk_prot_alloc(prot, priority, sk->sk_family);
  1800		if (newsk != NULL) {
  1801			struct sk_filter *filter;
  1802	
  1803			sock_copy(newsk, sk);
  1804	
  1805			newsk->sk_prot_creator = prot;
  1806	
  1807			/* SANITY */
  1808			if (likely(newsk->sk_net_refcnt))
  1809				get_net(sock_net(newsk));
  1810			sk_node_init(&newsk->sk_node);
  1811			sock_lock_init(newsk);
  1812			bh_lock_sock(newsk);
  1813			newsk->sk_backlog.head	= newsk->sk_backlog.tail = NULL;
  1814			newsk->sk_backlog.len = 0;
  1815	
  1816			atomic_set(&newsk->sk_rmem_alloc, 0);
  1817			/*
  1818			 * sk_wmem_alloc set to one (see sk_free() and sock_wfree())
  1819			 */
  1820			refcount_set(&newsk->sk_wmem_alloc, 1);
  1821			atomic_set(&newsk->sk_omem_alloc, 0);
  1822			sk_init_common(newsk);
  1823	
  1824			newsk->sk_dst_cache	= NULL;
  1825			newsk->sk_dst_pending_confirm = 0;
  1826			newsk->sk_wmem_queued	= 0;
  1827			newsk->sk_forward_alloc = 0;
  1828			atomic_set(&newsk->sk_drops, 0);
  1829			newsk->sk_send_head	= NULL;
  1830			newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
  1831			atomic_set(&newsk->sk_zckey, 0);
  1832	
  1833			sock_reset_flag(newsk, SOCK_DONE);
  1834			mem_cgroup_sk_alloc(newsk);
  1835			cgroup_sk_alloc(&newsk->sk_cgrp_data);
  1836	
  1837			rcu_read_lock();
  1838			filter = rcu_dereference(sk->sk_filter);
  1839			if (filter != NULL)
  1840				/* though it's an empty new sock, the charging may fail
  1841				 * if sysctl_optmem_max was changed between creation of
  1842				 * original socket and cloning
  1843				 */
  1844				is_charged = sk_filter_charge(newsk, filter);
  1845			RCU_INIT_POINTER(newsk->sk_filter, filter);
  1846			rcu_read_unlock();
  1847	
  1848			if (unlikely(!is_charged || xfrm_sk_clone_policy(newsk, sk))) {
  1849				/* We need to make sure that we don't uncharge the new
  1850				 * socket if we couldn't charge it in the first place
  1851				 * as otherwise we uncharge the parent's filter.
  1852				 */
  1853				if (!is_charged)
  1854					RCU_INIT_POINTER(newsk->sk_filter, NULL);
  1855				sk_free_unlock_clone(newsk);
  1856				newsk = NULL;
  1857				goto out;
  1858			}
  1859			RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
  1860	
  1861			if (bpf_sk_storage_clone(sk, newsk)) {
  1862				sk_free_unlock_clone(newsk);
  1863				newsk = NULL;
  1864				goto out;
  1865			}
  1866	
  1867			/* Clear sk_user_data if parent had the pointer tagged
  1868			 * as not suitable for copying when cloning.
  1869			 */
  1870			if (sk_user_data_is_nocopy(newsk))
> 1871				RCU_INIT_POINTER(newsk->sk_user_data, NULL);
  1872	
  1873			newsk->sk_err	   = 0;
  1874			newsk->sk_err_soft = 0;
  1875			newsk->sk_priority = 0;
  1876			newsk->sk_incoming_cpu = raw_smp_processor_id();
  1877			if (likely(newsk->sk_net_refcnt))
  1878				sock_inuse_add(sock_net(newsk), 1);
  1879	
  1880			/*
  1881			 * Before updating sk_refcnt, we must commit prior changes to memory
  1882			 * (Documentation/RCU/rculist_nulls.txt for details)
  1883			 */
  1884			smp_wmb();
  1885			refcount_set(&newsk->sk_refcnt, 2);
  1886	
  1887			/*
  1888			 * Increment the counter in the same struct proto as the master
  1889			 * sock (sk_refcnt_debug_inc uses newsk->sk_prot->socks, that
  1890			 * is the same as sk->sk_prot->socks, as this field was copied
  1891			 * with memcpy).
  1892			 *
  1893			 * This _changes_ the previous behaviour, where
  1894			 * tcp_create_openreq_child always was incrementing the
  1895			 * equivalent to tcp_prot->socks (inet_sock_nr), so this have
  1896			 * to be taken into account in all callers. -acme
  1897			 */
  1898			sk_refcnt_debug_inc(newsk);
  1899			sk_set_socket(newsk, NULL);
  1900			RCU_INIT_POINTER(newsk->sk_wq, NULL);
  1901	
  1902			if (newsk->sk_prot->sockets_allocated)
  1903				sk_sockets_allocated_inc(newsk);
  1904	
  1905			if (sock_needs_netstamp(sk) &&
  1906			    newsk->sk_flags & SK_FLAGS_TIMESTAMP)
  1907				net_enable_timestamp();
  1908		}
  1909	out:
  1910		return newsk;
  1911	}
  1912	EXPORT_SYMBOL_GPL(sk_clone_lock);
  1913	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
