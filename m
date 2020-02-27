Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC159172E0B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 02:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgB1BOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 20:14:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:40788 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbgB1BOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 20:14:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 17:14:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="256950236"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 27 Feb 2020 17:14:28 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1j7UEV-0002S3-M0; Fri, 28 Feb 2020 09:14:27 +0800
Date:   Fri, 28 Feb 2020 06:19:39 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: datagram: drop 'destructor' argument
 from several helpers
Message-ID: <202002280625.J2ZRBDmx%lkp@intel.com>
References: <42639d3f3b1da6959ed42c683780c48a8fe08f4e.1582802470.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42639d3f3b1da6959ed42c683780c48a8fe08f4e.1582802470.git.pabeni@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master linus/master v5.6-rc3 next-20200227]
[cannot apply to ipvs/master sparc-next/master]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Paolo-Abeni/net-cleanup-datagram-receive-helpers/20200227-214333
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2b99e54b30ed56201dedd91e6049ed83aa9d2302
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-173-ge0787745-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/xfrm/espintcp.c:103:34: sparse: sparse: too many arguments for function __skb_recv_datagram

vim +103 net/xfrm/espintcp.c

e27cca96cd68fa Sabrina Dubroca 2019-11-25   91  
e27cca96cd68fa Sabrina Dubroca 2019-11-25   92  static int espintcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
e27cca96cd68fa Sabrina Dubroca 2019-11-25   93  			    int nonblock, int flags, int *addr_len)
e27cca96cd68fa Sabrina Dubroca 2019-11-25   94  {
e27cca96cd68fa Sabrina Dubroca 2019-11-25   95  	struct espintcp_ctx *ctx = espintcp_getctx(sk);
e27cca96cd68fa Sabrina Dubroca 2019-11-25   96  	struct sk_buff *skb;
e27cca96cd68fa Sabrina Dubroca 2019-11-25   97  	int err = 0;
e27cca96cd68fa Sabrina Dubroca 2019-11-25   98  	int copied;
e27cca96cd68fa Sabrina Dubroca 2019-11-25   99  	int off = 0;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  100  
e27cca96cd68fa Sabrina Dubroca 2019-11-25  101  	flags |= nonblock ? MSG_DONTWAIT : 0;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  102  
e27cca96cd68fa Sabrina Dubroca 2019-11-25 @103  	skb = __skb_recv_datagram(sk, &ctx->ike_queue, flags, NULL, &off, &err);
e27cca96cd68fa Sabrina Dubroca 2019-11-25  104  	if (!skb)
e27cca96cd68fa Sabrina Dubroca 2019-11-25  105  		return err;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  106  
e27cca96cd68fa Sabrina Dubroca 2019-11-25  107  	copied = len;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  108  	if (copied > skb->len)
e27cca96cd68fa Sabrina Dubroca 2019-11-25  109  		copied = skb->len;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  110  	else if (copied < skb->len)
e27cca96cd68fa Sabrina Dubroca 2019-11-25  111  		msg->msg_flags |= MSG_TRUNC;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  112  
e27cca96cd68fa Sabrina Dubroca 2019-11-25  113  	err = skb_copy_datagram_msg(skb, 0, msg, copied);
e27cca96cd68fa Sabrina Dubroca 2019-11-25  114  	if (unlikely(err)) {
e27cca96cd68fa Sabrina Dubroca 2019-11-25  115  		kfree_skb(skb);
e27cca96cd68fa Sabrina Dubroca 2019-11-25  116  		return err;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  117  	}
e27cca96cd68fa Sabrina Dubroca 2019-11-25  118  
e27cca96cd68fa Sabrina Dubroca 2019-11-25  119  	if (flags & MSG_TRUNC)
e27cca96cd68fa Sabrina Dubroca 2019-11-25  120  		copied = skb->len;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  121  	kfree_skb(skb);
e27cca96cd68fa Sabrina Dubroca 2019-11-25  122  	return copied;
e27cca96cd68fa Sabrina Dubroca 2019-11-25  123  }
e27cca96cd68fa Sabrina Dubroca 2019-11-25  124  

:::::: The code at line 103 was first introduced by commit
:::::: e27cca96cd68fa2c6814c90f9a1cfd36bb68c593 xfrm: add espintcp (RFC 8229)

:::::: TO: Sabrina Dubroca <sd@queasysnail.net>
:::::: CC: Steffen Klassert <steffen.klassert@secunet.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
