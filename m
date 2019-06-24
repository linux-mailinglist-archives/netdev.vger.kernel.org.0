Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5680051932
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfFXQ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:59:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:26543 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfFXQ7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 12:59:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 09:59:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="184186335"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jun 2019 09:59:18 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hfSJJ-0007dK-DJ; Tue, 25 Jun 2019 00:59:17 +0800
Date:   Tue, 25 Jun 2019 00:59:13 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net,
        nirranjan@chelsio.com, dt@chelsio.com, rajur@chelsio.com
Subject: Re: [PATCH v2 net-next 4/4] cxgb4: Add MPS refcounting for
 alloc/free mac filters
Message-ID: <201906250053.jc0h6Lqo%lkp@intel.com>
References: <20190624085037.2358-5-rajur@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624085037.2358-5-rajur@chelsio.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Raju,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Raju-Rangoju/cxgb4-Reference-count-MPS-TCAM-entries-within-a-PF/20190624-230630
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c:17:51: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected struct atomic_t [usertype] *v @@    got ct atomic_t [usertype] *v @@
>> drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c:17:51: sparse:    expected struct atomic_t [usertype] *v
>> drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c:17:51: sparse:    got struct refcount_struct *

vim +17 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c

     5	
     6	static int cxgb4_mps_ref_dec_by_mac(struct adapter *adap,
     7					    const u8 *addr, const u8 *mask)
     8	{
     9		u8 bitmask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
    10		struct mps_entries_ref *mps_entry, *tmp;
    11		int ret = -EINVAL;
    12	
    13		spin_lock_bh(&adap->mps_ref_lock);
    14		list_for_each_entry_safe(mps_entry, tmp, &adap->mps_ref, list) {
    15			if (ether_addr_equal(mps_entry->addr, addr) &&
    16			    ether_addr_equal(mps_entry->mask, mask ? mask : bitmask)) {
  > 17				if (!atomic_dec_and_test(&mps_entry->refcnt)) {
    18					spin_unlock_bh(&adap->mps_ref_lock);
    19					return -EBUSY;
    20				}
    21				list_del(&mps_entry->list);
    22				kfree(mps_entry);
    23				ret = 0;
    24				break;
    25			}
    26		}
    27		spin_unlock_bh(&adap->mps_ref_lock);
    28		return ret;
    29	}
    30	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
