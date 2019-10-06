Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802CECD95D
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 23:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfJFVvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 17:51:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:30873 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfJFVvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Oct 2019 17:51:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Oct 2019 14:51:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,265,1566889200"; 
   d="scan'208";a="217779937"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 06 Oct 2019 14:51:19 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iHEQx-000AgY-9V; Mon, 07 Oct 2019 05:51:19 +0800
Date:   Mon, 7 Oct 2019 05:50:44 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: stmmac: Fallback to VLAN Perfect
 filtering if HASH is not available
Message-ID: <201910070529.LpPdh7OD%lkp@intel.com>
References: <3504067666a0cee6ecf636cf30081b09a6b79710.1570360411.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3504067666a0cee6ecf636cf30081b09a6b79710.1570360411.git.Jose.Abreu@synopsys.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Jose-Abreu/net-stmmac-Improvements-for-next/20191007-013324
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:2> *ioaddr @@    got void [noderef] <asn:2> *ioaddr @@
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17: sparse:    expected void [noderef] <asn:2> *ioaddr
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17: sparse:    got struct mac_device_info *hw
>> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:4224:21: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [assigned] [usertype] vid @@    got  short [assigned] [usertype] vid @@
>> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:4224:21: sparse:    expected unsigned short [assigned] [usertype] vid
>> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:4224:21: sparse:    got restricted __le16 [usertype]

vim +4224 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c

  4206	
  4207	static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
  4208	{
  4209		u32 crc, hash = 0;
  4210		int count = 0;
  4211		u16 vid = 0;
  4212	
  4213		for_each_set_bit(vid, priv->active_vlans, VLAN_N_VID) {
  4214			__le16 vid_le = cpu_to_le16(vid);
  4215			crc = bitrev32(~stmmac_vid_crc32_le(vid_le)) >> 28;
  4216			hash |= (1 << crc);
  4217			count++;
  4218		}
  4219	
  4220		if (!priv->dma_cap.vlhash) {
  4221			if (count > 2) /* VID = 0 always passes filter */
  4222				return -EOPNOTSUPP;
  4223	
> 4224			vid = cpu_to_le16(vid);
  4225			hash = 0;
  4226		}
  4227	
  4228		return stmmac_update_vlan_hash(priv, priv->hw, hash, vid, is_double);
  4229	}
  4230	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
