Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC8BD55B9
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 12:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfJMK6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 06:58:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:6431 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbfJMK6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 06:58:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Oct 2019 03:58:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,291,1566889200"; 
   d="scan'208";a="206934591"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 13 Oct 2019 03:58:50 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iJbaM-000DQb-22; Sun, 13 Oct 2019 18:58:50 +0800
Date:   Sun, 13 Oct 2019 18:58:44 +0800
From:   kbuild test robot <lkp@intel.com>
To:     xiangxia.m.yue@gmail.com
Cc:     kbuild-all@lists.01.org, gvrose8192@gmail.com, pshelar@ovn.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: Re: [PATCH net-next v3 02/10] net: openvswitch: convert mask list in
 mask array
Message-ID: <201910131851.36Sn9nnj%lkp@intel.com>
References: <1570802447-8019-3-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570802447-8019-3-git-send-email-xiangxia.m.yue@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/xiangxia-m-yue-gmail-com/optimize-openvswitch-flow-looking-up/20191013-161404
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-43-g0ccb3b4-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/openvswitch/flow_table.c:307:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct callback_head *head @@    got struct callback_hestruct callback_head *head @@
>> net/openvswitch/flow_table.c:307:9: sparse:    expected struct callback_head *head
>> net/openvswitch/flow_table.c:307:9: sparse:    got struct callback_head [noderef] <asn:4> *

vim +307 net/openvswitch/flow_table.c

   297	
   298	/* No need for locking this function is called from RCU callback or
   299	 * error path.
   300	 */
   301	void ovs_flow_tbl_destroy(struct flow_table *table)
   302	{
   303		struct table_instance *ti = rcu_dereference_raw(table->ti);
   304		struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
   305	
   306		free_percpu(table->mask_cache);
 > 307		kfree_rcu(table->mask_array, rcu);
   308		table_instance_destroy(ti, ufid_ti, false);
   309	}
   310	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
