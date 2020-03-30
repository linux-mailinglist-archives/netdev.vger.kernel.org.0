Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1833619796F
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 12:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgC3KlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 06:41:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:41527 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgC3KlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 06:41:09 -0400
IronPort-SDR: xq45GVvmksVY+9x+Y4XZE8bbiFdVivZ7rqHcQP/E2GZJWq997R7nmi1dT6YJth/8EsP5MRFupF
 J/tOq7nWqwfA==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 03:41:07 -0700
IronPort-SDR: q1tfzt6snSAiwnljFIA1ZJ9nrRJgA+bAj8ome5+kNeXKqy1rSlqJoxNiaX6JTzloLgj5oeR0d5
 XrNM7moMiE4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,324,1580803200"; 
   d="gz'50?scan'50,208,50";a="237313227"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 30 Mar 2020 03:41:05 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jIrqq-00033m-NB; Mon, 30 Mar 2020 18:41:04 +0800
Date:   Mon, 30 Mar 2020 18:40:39 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        netdev@vger.kernel.org, khlebnikov@yandex-team.ru
Subject: Re: [PATCH net] inet_diag: add cgroup id attribute
Message-ID: <202003301846.ThHgDMrZ%lkp@intel.com>
References: <20200330081101.GA16030@yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20200330081101.GA16030@yandex-team.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dmitry,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on linus/master v5.6]
[cannot apply to net-next/master sparc-next/master next-20200327]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Dmitry-Yakunin/inet_diag-add-cgroup-id-attribute/20200330-175504
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git a0ba26f37ea04e025a793ef5e5ac809221728ecb
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-7 (Debian 7.4.0-6) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   net/ipv4/inet_diag.c: In function 'inet_diag_msg_attrs_fill':
>> net/ipv4/inet_diag.c:166:20: error: implicit declaration of function 'sock_cgroup_ptr'; did you mean 'task_cgroup_path'? [-Werror=implicit-function-declaration]
             cgroup_id(sock_cgroup_ptr(&sk->sk_cgrp_data)),
                       ^~~~~~~~~~~~~~~
                       task_cgroup_path
>> net/ipv4/inet_diag.c:166:20: warning: passing argument 1 of 'cgroup_id' makes pointer from integer without a cast [-Wint-conversion]
   In file included from include/net/netprio_cgroup.h:11:0,
                    from include/linux/netdevice.h:42,
                    from include/net/inet_sock.h:19,
                    from include/net/icmp.h:19,
                    from net/ipv4/inet_diag.c:18:
   include/linux/cgroup.h:308:19: note: expected 'struct cgroup *' but argument is of type 'int'
    static inline u64 cgroup_id(struct cgroup *cgrp)
                      ^~~~~~~~~
   cc1: some warnings being treated as errors

vim +166 net/ipv4/inet_diag.c

   142	
   143		if (net_admin && nla_put_u32(skb, INET_DIAG_MARK, sk->sk_mark))
   144			goto errout;
   145	
   146		if (ext & (1 << (INET_DIAG_CLASS_ID - 1)) ||
   147		    ext & (1 << (INET_DIAG_TCLASS - 1))) {
   148			u32 classid = 0;
   149	
   150	#ifdef CONFIG_SOCK_CGROUP_DATA
   151			classid = sock_cgroup_classid(&sk->sk_cgrp_data);
   152	#endif
   153			/* Fallback to socket priority if class id isn't set.
   154			 * Classful qdiscs use it as direct reference to class.
   155			 * For cgroup2 classid is always zero.
   156			 */
   157			if (!classid)
   158				classid = sk->sk_priority;
   159	
   160			if (nla_put_u32(skb, INET_DIAG_CLASS_ID, classid))
   161				goto errout;
   162		}
   163	
   164	#ifdef CONFIG_CGROUPS
   165		if (nla_put_u64_64bit(skb, INET_DIAG_CGROUP_ID,
 > 166				      cgroup_id(sock_cgroup_ptr(&sk->sk_cgrp_data)),
   167				      INET_DIAG_PAD))
   168			goto errout;
   169	#endif
   170	
   171		r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
   172		r->idiag_inode = sock_i_ino(sk);
   173	
   174		return 0;
   175	errout:
   176		return 1;
   177	}
   178	EXPORT_SYMBOL_GPL(inet_diag_msg_attrs_fill);
   179	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--YiEDa0DAkWCtVeE4
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
+btp8+b/AN/IqwcWgwAA

--YiEDa0DAkWCtVeE4--
