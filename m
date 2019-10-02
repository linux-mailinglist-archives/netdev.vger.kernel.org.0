Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD00C8FFF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfJBRdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:33:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:46931 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727793AbfJBRdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 13:33:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 10:33:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="gz'50?scan'50,208,50";a="221479304"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 02 Oct 2019 10:33:32 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iFiVI-0008mT-1J; Thu, 03 Oct 2019 01:33:32 +0800
Date:   Thu, 3 Oct 2019 01:33:23 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     kbuild-all@01.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 4/9] xdp: Implement chain call logic to support
 multiple programs on one interface
Message-ID: <201910030106.jiEiPOvb%lkp@intel.com>
References: <157002302894.1302756.12004905609124608227.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jvcwoqd6f4txt6l6"
Content-Disposition: inline
In-Reply-To: <157002302894.1302756.12004905609124608227.stgit@alrua-x1>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jvcwoqd6f4txt6l6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi "Toke,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Toke-H-iland-J-rgensen/xdp-Support-multiple-programs-on-a-single-interface-through-chain-calls/20191003-005238
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Debian 7.4.0-13) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from include/net/sock.h:59:0,
                    from include/linux/tcp.h:19,
                    from include/linux/ipv6.h:87,
                    from include/net/ipv6.h:12,
                    from include/linux/sunrpc/clnt.h:28,
                    from include/linux/nfs_fs.h:32,
                    from init/do_mounts.c:23:
   include/linux/filter.h: In function 'bpf_prog_run_xdp':
>> include/linux/filter.h:725:10: error: implicit declaration of function 'bpf_xdp_chain_map_get_prog' [-Werror=implicit-function-declaration]
      prog = bpf_xdp_chain_map_get_prog(chain_map, prog->aux->id, ret);
             ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> include/linux/filter.h:725:8: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      prog = bpf_xdp_chain_map_get_prog(chain_map, prog->aux->id, ret);
           ^
   cc1: some warnings being treated as errors

vim +/bpf_xdp_chain_map_get_prog +725 include/linux/filter.h

   695	
   696	#define BPF_XDP_MAX_CHAIN_CALLS 32
   697	static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
   698						    struct xdp_buff *xdp)
   699	{
   700		/* Caller needs to hold rcu_read_lock() (!), otherwise program
   701		 * can be released while still running, or map elements could be
   702		 * freed early while still having concurrent users. XDP fastpath
   703		 * already takes rcu_read_lock() when fetching the program, so
   704		 * it's not necessary here anymore.
   705		 */
   706	
   707		int i = BPF_XDP_MAX_CHAIN_CALLS;
   708		struct bpf_map *chain_map;
   709		u32 ret;
   710	
   711		chain_map = rcu_dereference(xdp->rxq->dev->xdp_chain_map);
   712		if (!chain_map)
   713			return BPF_PROG_RUN(prog, xdp);
   714	
   715		do {
   716			if (!--i) {
   717				ret = XDP_ABORTED;
   718				goto out;
   719			}
   720	
   721			ret = BPF_PROG_RUN(prog, xdp);
   722			if (ret == XDP_ABORTED)
   723				goto out;
   724	
 > 725			prog = bpf_xdp_chain_map_get_prog(chain_map, prog->aux->id, ret);
   726		} while(prog);
   727	
   728	out:
   729		return ret;
   730	}
   731	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--jvcwoqd6f4txt6l6
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
jaAqd4aOUO302DrBgcIPvUQopQloAAA=

--jvcwoqd6f4txt6l6--
