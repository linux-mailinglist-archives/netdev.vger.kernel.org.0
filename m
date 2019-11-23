Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E350107C94
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 03:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfKWCxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 21:53:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:39446 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfKWCxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 21:53:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 18:53:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,232,1571727600"; 
   d="scan'208";a="210596681"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 22 Nov 2019 18:53:50 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iYLYU-000Gx0-1w; Sat, 23 Nov 2019 10:53:50 +0800
Date:   Sat, 23 Nov 2019 10:53:27 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [ipsec-next:testing 6/6] net/xfrm/espintcp.c:402:13: sparse: sparse:
 incompatible types in comparison expression (different address spaces):
Message-ID: <201911231026.qn0a6HJ2%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
head:   73994d31bda7074698e8d07b40152eeabccd5780
commit: 73994d31bda7074698e8d07b40152eeabccd5780 [6/6] xfrm: add espintcp (RFC 8229)
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-36-g9305d48-dirty
        git checkout 73994d31bda7074698e8d07b40152eeabccd5780
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/xfrm/espintcp.c:402:13: sparse: sparse: incompatible types in comparison expression (different address spaces):
>> net/xfrm/espintcp.c:402:13: sparse:    void [noderef] <asn:4> *
>> net/xfrm/espintcp.c:402:13: sparse:    void *

vim +402 net/xfrm/espintcp.c

   390	
   391	static int espintcp_init_sk(struct sock *sk)
   392	{
   393		struct inet_connection_sock *icsk = inet_csk(sk);
   394		struct strp_callbacks cb = {
   395			.rcv_msg = espintcp_rcv,
   396			.parse_msg = espintcp_parse,
   397		};
   398		struct espintcp_ctx *ctx;
   399		int err;
   400	
   401		/* sockmap is not compatible with espintcp */
 > 402		if (rcu_access_pointer(sk->sk_user_data))
   403			return -EBUSY;
   404	
   405		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
   406		if (!ctx)
   407			return -ENOMEM;
   408	
   409		err = strp_init(&ctx->strp, sk, &cb);
   410		if (err)
   411			goto free;
   412	
   413		__sk_dst_reset(sk);
   414	
   415		strp_check_rcv(&ctx->strp);
   416		skb_queue_head_init(&ctx->ike_queue);
   417		skb_queue_head_init(&ctx->out_queue);
   418		sk->sk_prot = &espintcp_prot;
   419		sk->sk_socket->ops = &espintcp_ops;
   420		ctx->saved_data_ready = sk->sk_data_ready;
   421		ctx->saved_write_space = sk->sk_write_space;
   422		sk->sk_data_ready = espintcp_data_ready;
   423		sk->sk_write_space = espintcp_write_space;
   424		sk->sk_destruct = espintcp_destruct;
   425		rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
   426		INIT_WORK(&ctx->work, espintcp_tx_work);
   427	
   428		/* avoid using task_frag */
   429		sk->sk_allocation = GFP_ATOMIC;
   430	
   431		return 0;
   432	
   433	free:
   434		kfree(ctx);
   435		return err;
   436	}
   437	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
