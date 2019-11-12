Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5362F9184
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfKLOHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:07:24 -0500
Received: from mga03.intel.com ([134.134.136.65]:57094 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbfKLOHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 09:07:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 06:07:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,296,1569308400"; 
   d="scan'208";a="229401761"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 12 Nov 2019 06:07:21 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iUWpF-0008eg-8s; Tue, 12 Nov 2019 22:07:21 +0800
Date:   Tue, 12 Nov 2019 22:06:24 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 1285/1291]
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:760:32: sparse: sparse:
 restricted __le16 degrades to integer
Message-ID: <201911122209.isu09tNx%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   ca22d6977b9b4ab0fd2e7909b57e32ba5b95046f
commit: a24cae7012b59bfe1aed01fe3fc13d81b7b97b08 [1285/1291] net: stmmac: Fix sparse warning
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-29-g781bc5d-dirty
        git checkout a24cae7012b59bfe1aed01fe3fc13d81b7b97b08
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:760:32: sparse: sparse: restricted __le16 degrades to integer
--
>> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c:594:32: sparse: sparse: restricted __le16 degrades to integer

vim +760 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c

4ce84f4da7c472 Jose Abreu 2019-05-24  734  
c1be0022df0dae Jose Abreu 2019-09-10  735  static void dwmac4_update_vlan_hash(struct mac_device_info *hw, u32 hash,
a24cae7012b59b Jose Abreu 2019-11-11  736  				    __le16 perfect_match, bool is_double)
c1be0022df0dae Jose Abreu 2019-09-10  737  {
c1be0022df0dae Jose Abreu 2019-09-10  738  	void __iomem *ioaddr = hw->pcsr;
c1be0022df0dae Jose Abreu 2019-09-10  739  
c1be0022df0dae Jose Abreu 2019-09-10  740  	writel(hash, ioaddr + GMAC_VLAN_HASH_TABLE);
c1be0022df0dae Jose Abreu 2019-09-10  741  
c1be0022df0dae Jose Abreu 2019-09-10  742  	if (hash) {
c1be0022df0dae Jose Abreu 2019-09-10  743  		u32 value = GMAC_VLAN_VTHM | GMAC_VLAN_ETV;
c1be0022df0dae Jose Abreu 2019-09-10  744  		if (is_double) {
c1be0022df0dae Jose Abreu 2019-09-10  745  			value |= GMAC_VLAN_EDVLP;
c1be0022df0dae Jose Abreu 2019-09-10  746  			value |= GMAC_VLAN_ESVL;
c1be0022df0dae Jose Abreu 2019-09-10  747  			value |= GMAC_VLAN_DOVLTC;
c1be0022df0dae Jose Abreu 2019-09-10  748  		}
c1be0022df0dae Jose Abreu 2019-09-10  749  
c1be0022df0dae Jose Abreu 2019-09-10  750  		writel(value, ioaddr + GMAC_VLAN_TAG);
c7ab0b8088d7f0 Jose Abreu 2019-10-06  751  	} else if (perfect_match) {
c7ab0b8088d7f0 Jose Abreu 2019-10-06  752  		u32 value = GMAC_VLAN_ETV;
c7ab0b8088d7f0 Jose Abreu 2019-10-06  753  
c7ab0b8088d7f0 Jose Abreu 2019-10-06  754  		if (is_double) {
c7ab0b8088d7f0 Jose Abreu 2019-10-06  755  			value |= GMAC_VLAN_EDVLP;
c7ab0b8088d7f0 Jose Abreu 2019-10-06  756  			value |= GMAC_VLAN_ESVL;
c7ab0b8088d7f0 Jose Abreu 2019-10-06  757  			value |= GMAC_VLAN_DOVLTC;
c7ab0b8088d7f0 Jose Abreu 2019-10-06  758  		}
c7ab0b8088d7f0 Jose Abreu 2019-10-06  759  
c7ab0b8088d7f0 Jose Abreu 2019-10-06 @760  		writel(value | perfect_match, ioaddr + GMAC_VLAN_TAG);
c1be0022df0dae Jose Abreu 2019-09-10  761  	} else {
c1be0022df0dae Jose Abreu 2019-09-10  762  		u32 value = readl(ioaddr + GMAC_VLAN_TAG);
c1be0022df0dae Jose Abreu 2019-09-10  763  
c1be0022df0dae Jose Abreu 2019-09-10  764  		value &= ~(GMAC_VLAN_VTHM | GMAC_VLAN_ETV);
c1be0022df0dae Jose Abreu 2019-09-10  765  		value &= ~(GMAC_VLAN_EDVLP | GMAC_VLAN_ESVL);
c1be0022df0dae Jose Abreu 2019-09-10  766  		value &= ~GMAC_VLAN_DOVLTC;
c1be0022df0dae Jose Abreu 2019-09-10  767  		value &= ~GMAC_VLAN_VID;
c1be0022df0dae Jose Abreu 2019-09-10  768  
c1be0022df0dae Jose Abreu 2019-09-10  769  		writel(value, ioaddr + GMAC_VLAN_TAG);
c1be0022df0dae Jose Abreu 2019-09-10  770  	}
c1be0022df0dae Jose Abreu 2019-09-10  771  }
c1be0022df0dae Jose Abreu 2019-09-10  772  

:::::: The code at line 760 was first introduced by commit
:::::: c7ab0b8088d7f023f543013963f23aecc7e47efb net: stmmac: Fallback to VLAN Perfect filtering if HASH is not available

:::::: TO: Jose Abreu <joabreu@synopsys.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
