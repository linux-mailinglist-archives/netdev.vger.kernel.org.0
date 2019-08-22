Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D131F99E76
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733009AbfHVSMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:12:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:34506 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730918AbfHVSMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 14:12:00 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 11:12:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="262945701"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 22 Aug 2019 11:11:58 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1i0rZ0-0003ve-Ao; Fri, 23 Aug 2019 02:11:58 +0800
Date:   Fri, 23 Aug 2019 02:11:46 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yi-Hung Wei <yihung.wei@gmail.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, pshelar@ovn.org,
        Yi-Hung Wei <yihung.wei@gmail.com>
Subject: Re: [PATCH net] openvswitch: Fix conntrack cache with timeout
Message-ID: <201908230208.0aRY5GdN%lkp@intel.com>
References: <1566432854-35880-1-git-send-email-yihung.wei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566432854-35880-1-git-send-email-yihung.wei@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yi-Hung,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Yi-Hung-Wei/openvswitch-Fix-conntrack-cache-with-timeout/20190822-212539
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   include/linux/sched.h:609:43: sparse: sparse: bad integer constant expression
   include/linux/sched.h:609:73: sparse: sparse: invalid named zero-width bitfield `value'
   include/linux/sched.h:610:43: sparse: sparse: bad integer constant expression
   include/linux/sched.h:610:67: sparse: sparse: invalid named zero-width bitfield `bucket_id'
>> net/openvswitch/conntrack.c:706:41: sparse: sparse: incompatible types in comparison expression (different address spaces):
>> net/openvswitch/conntrack.c:706:41: sparse:    struct nf_ct_timeout *
>> net/openvswitch/conntrack.c:706:41: sparse:    struct nf_ct_timeout [noderef] <asn:4> *

vim +706 net/openvswitch/conntrack.c

   670	
   671	/* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
   672	static bool skb_nfct_cached(struct net *net,
   673				    const struct sw_flow_key *key,
   674				    const struct ovs_conntrack_info *info,
   675				    struct sk_buff *skb)
   676	{
   677		enum ip_conntrack_info ctinfo;
   678		struct nf_conn *ct;
   679		bool ct_executed = true;
   680	
   681		ct = nf_ct_get(skb, &ctinfo);
   682		if (!ct)
   683			ct = ovs_ct_executed(net, key, info, skb, &ct_executed);
   684	
   685		if (ct)
   686			nf_ct_get(skb, &ctinfo);
   687		else
   688			return false;
   689	
   690		if (!net_eq(net, read_pnet(&ct->ct_net)))
   691			return false;
   692		if (!nf_ct_zone_equal_any(info->ct, nf_ct_zone(ct)))
   693			return false;
   694		if (info->helper) {
   695			struct nf_conn_help *help;
   696	
   697			help = nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
   698			if (help && rcu_access_pointer(help->helper) != info->helper)
   699				return false;
   700		}
   701		if (info->nf_ct_timeout) {
   702			struct nf_conn_timeout *timeout_ext;
   703	
   704			timeout_ext = nf_ct_timeout_find(ct);
   705			if (!timeout_ext ||
 > 706			    info->nf_ct_timeout != timeout_ext->timeout)
   707				return false;
   708		}
   709		/* Force conntrack entry direction to the current packet? */
   710		if (info->force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
   711			/* Delete the conntrack entry if confirmed, else just release
   712			 * the reference.
   713			 */
   714			if (nf_ct_is_confirmed(ct))
   715				nf_ct_delete(ct, 0, 0);
   716	
   717			nf_conntrack_put(&ct->ct_general);
   718			nf_ct_set(skb, NULL, 0);
   719			return false;
   720		}
   721	
   722		return ct_executed;
   723	}
   724	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
