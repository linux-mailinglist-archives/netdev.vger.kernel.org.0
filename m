Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B456812CF05
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 11:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfL3Kzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 05:55:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:19798 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfL3Kzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 05:55:48 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Dec 2019 02:55:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,374,1571727600"; 
   d="gz'50?scan'50,208,50";a="208982563"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 30 Dec 2019 02:55:45 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ilsi8-0006Po-HQ; Mon, 30 Dec 2019 18:55:44 +0800
Date:   Mon, 30 Dec 2019 18:55:41 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     kbuild-all@lists.01.org, Netdev <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <201912301855.45LZiSwb%lkp@intel.com>
References: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="674qzkmkrcdyn3it"
Content-Disposition: inline
In-Reply-To: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--674qzkmkrcdyn3it
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ttttabcd,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on net-next/master ipvs/master v5.5-rc4 next-20191220]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Ttttabcd/tcp-Fix-tcp_max_syn_backlog-limit-on-connection-requests/20191230-164004
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git bb3d0b8bf5be61ab1d6f472c43cbf34de17e796b
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-7 (Debian 7.5.0-3) 7.5.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:19:0,
                    from ./arch/um/include/generated/asm/bug.h:1,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:9,
                    from net/ipv4/tcp_input.c:67:
   net/ipv4/tcp_input.c: In function 'tcp_conn_request':
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
>> net/ipv4/tcp_input.c:6568:20: note: in expansion of macro 'min'
     max_syn_backlog = min(net->ipv4.sysctl_max_syn_backlog,
                       ^~~

vim +/min +6568 net/ipv4/tcp_input.c

  6551	
  6552	int tcp_conn_request(struct request_sock_ops *rsk_ops,
  6553			     const struct tcp_request_sock_ops *af_ops,
  6554			     struct sock *sk, struct sk_buff *skb)
  6555	{
  6556		struct tcp_fastopen_cookie foc = { .len = -1 };
  6557		__u32 isn = TCP_SKB_CB(skb)->tcp_tw_isn;
  6558		struct tcp_options_received tmp_opt;
  6559		struct tcp_sock *tp = tcp_sk(sk);
  6560		struct net *net = sock_net(sk);
  6561		struct sock *fastopen_sk = NULL;
  6562		struct request_sock *req;
  6563		bool want_cookie = false;
  6564		struct dst_entry *dst;
  6565		int max_syn_backlog;
  6566		struct flowi fl;
  6567	
> 6568		max_syn_backlog = min(net->ipv4.sysctl_max_syn_backlog,

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--674qzkmkrcdyn3it
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
uhs+b8q8+T+hTkeOQIIAAA==

--674qzkmkrcdyn3it--
