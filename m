Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F80F12D4B6
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 22:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfL3Vx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 16:53:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:28162 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfL3Vx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 16:53:59 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Dec 2019 13:53:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,376,1571727600"; 
   d="scan'208";a="301360470"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 30 Dec 2019 13:53:56 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1im2z6-0007SD-Bm; Tue, 31 Dec 2019 05:53:56 +0800
Date:   Tue, 31 Dec 2019 05:53:31 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     kbuild-all@lists.01.org, Netdev <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <201912310520.gWWmntOp%lkp@intel.com>
References: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ttttabcd,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on net-next/master ipvs/master v5.5-rc4 next-20191220]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Ttttabcd/tcp-Fix-tcp_max_syn_backlog-limit-on-connection-requests/20191230-164004
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git bb3d0b8bf5be61ab1d6f472c43cbf34de17e796b
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/ipv4/tcp_input.c:6568:27: sparse: sparse: incompatible types in comparison expression (different signedness):
>> net/ipv4/tcp_input.c:6568:27: sparse:    int *
>> net/ipv4/tcp_input.c:6568:27: sparse:    unsigned int *
   net/ipv4/tcp_input.c:6673:17: sparse: sparse: context imbalance in 'tcp_conn_request' - unexpected unlock

vim +6568 net/ipv4/tcp_input.c

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
