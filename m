Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED18D402307
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 07:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbhIGFPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 01:15:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:48523 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhIGFPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 01:15:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="220157023"
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="gz'50?scan'50,208,50";a="220157023"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 22:14:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="gz'50?scan'50,208,50";a="546546517"
Received: from lkp-server01.sh.intel.com (HELO 730d49888f40) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 06 Sep 2021 22:14:40 -0700
Received: from kbuild by 730d49888f40 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mNTRP-00005W-Uq; Tue, 07 Sep 2021 05:14:39 +0000
Date:   Tue, 7 Sep 2021 13:14:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Message-ID: <202109071335.nzVG1KjE-lkp@intel.com>
References: <20210907021415.962-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20210907021415.962-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Cole,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Cole-Dishington/net-netfilter-Fix-port-selection-of-FTP-for-NF_NAT_RANGE_PROTO_SPECIFIED/20210907-101823
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git b539c44df067ac116ec1b58b956efda51b6a7fc1
config: arm-randconfig-r003-20210906 (attached as .config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 9c476172b93367d2cb88d7d3f4b1b5b456fa6020)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/3d790f5d7c3d6069948749b4697090adfcc48e51
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Cole-Dishington/net-netfilter-Fix-port-selection-of-FTP-for-NF_NAT_RANGE_PROTO_SPECIFIED/20210907-101823
        git checkout 3d790f5d7c3d6069948749b4697090adfcc48e51
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_nat_core.c:373:6: warning: no previous prototype for function 'nf_nat_l4proto_unique_tuple' [-Wmissing-prototypes]
   void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
        ^
   net/netfilter/nf_nat_core.c:373:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
   ^
   static 
   1 warning generated.


vim +/nf_nat_l4proto_unique_tuple +373 net/netfilter/nf_nat_core.c

   367	
   368	/* Alter the per-proto part of the tuple (depending on maniptype), to
   369	 * give a unique tuple in the given range if possible.
   370	 *
   371	 * Per-protocol part of tuple is initialized to the incoming packet.
   372	 */
 > 373	void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
   374					 const struct nf_nat_range2 *range,
   375					 enum nf_nat_manip_type maniptype,
   376					 const struct nf_conn *ct)
   377	{
   378		unsigned int range_size, min, max, i, attempts;
   379		__be16 *keyptr;
   380		u16 off;
   381		static const unsigned int max_attempts = 128;
   382	
   383		switch (tuple->dst.protonum) {
   384		case IPPROTO_ICMP:
   385		case IPPROTO_ICMPV6:
   386			/* id is same for either direction... */
   387			keyptr = &tuple->src.u.icmp.id;
   388			if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
   389				min = 0;
   390				range_size = 65536;
   391			} else {
   392				min = ntohs(range->min_proto.icmp.id);
   393				range_size = ntohs(range->max_proto.icmp.id) -
   394					     ntohs(range->min_proto.icmp.id) + 1;
   395			}
   396			goto find_free_id;
   397	#if IS_ENABLED(CONFIG_NF_CT_PROTO_GRE)
   398		case IPPROTO_GRE:
   399			/* If there is no master conntrack we are not PPTP,
   400			   do not change tuples */
   401			if (!ct->master)
   402				return;
   403	
   404			if (maniptype == NF_NAT_MANIP_SRC)
   405				keyptr = &tuple->src.u.gre.key;
   406			else
   407				keyptr = &tuple->dst.u.gre.key;
   408	
   409			if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
   410				min = 1;
   411				range_size = 65535;
   412			} else {
   413				min = ntohs(range->min_proto.gre.key);
   414				range_size = ntohs(range->max_proto.gre.key) - min + 1;
   415			}
   416			goto find_free_id;
   417	#endif
   418		case IPPROTO_UDP:
   419		case IPPROTO_UDPLITE:
   420		case IPPROTO_TCP:
   421		case IPPROTO_SCTP:
   422		case IPPROTO_DCCP:
   423			if (maniptype == NF_NAT_MANIP_SRC)
   424				keyptr = &tuple->src.u.all;
   425			else
   426				keyptr = &tuple->dst.u.all;
   427	
   428			break;
   429		default:
   430			return;
   431		}
   432	
   433		/* If no range specified... */
   434		if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
   435			/* If it's dst rewrite, can't change port */
   436			if (maniptype == NF_NAT_MANIP_DST)
   437				return;
   438	
   439			if (ntohs(*keyptr) < 1024) {
   440				/* Loose convention: >> 512 is credential passing */
   441				if (ntohs(*keyptr) < 512) {
   442					min = 1;
   443					range_size = 511 - min + 1;
   444				} else {
   445					min = 600;
   446					range_size = 1023 - min + 1;
   447				}
   448			} else {
   449				min = 1024;
   450				range_size = 65535 - 1024 + 1;
   451			}
   452		} else {
   453			min = ntohs(range->min_proto.all);
   454			max = ntohs(range->max_proto.all);
   455			if (unlikely(max < min))
   456				swap(max, min);
   457			range_size = max - min + 1;
   458		}
   459	
   460	find_free_id:
   461		if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
   462			off = (ntohs(*keyptr) - ntohs(range->base_proto.all));
   463		else
   464			off = prandom_u32();
   465	
   466		attempts = range_size;
   467		if (attempts > max_attempts)
   468			attempts = max_attempts;
   469	
   470		/* We are in softirq; doing a search of the entire range risks
   471		 * soft lockup when all tuples are already used.
   472		 *
   473		 * If we can't find any free port from first offset, pick a new
   474		 * one and try again, with ever smaller search window.
   475		 */
   476	another_round:
   477		for (i = 0; i < attempts; i++, off++) {
   478			*keyptr = htons(min + off % range_size);
   479			if (!nf_nat_used_tuple(tuple, ct))
   480				return;
   481		}
   482	
   483		if (attempts >= range_size || attempts < 16)
   484			return;
   485		attempts /= 2;
   486		off = prandom_u32();
   487		goto another_round;
   488	}
   489	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--RnlQjJ0d97Da+TV1
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--RnlQjJ0d97Da+TV1--
