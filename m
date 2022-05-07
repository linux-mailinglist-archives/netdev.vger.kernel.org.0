Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB6951E6D3
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 14:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391359AbiEGMOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 08:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345199AbiEGMOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 08:14:32 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4D81E3CA
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 05:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651925444; x=1683461444;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=MZwuz7MgNHtxiZR6kSY6czplVusXK/7unaN970ecXvk=;
  b=ZQXuGpPbsvokicrIAxqFZQyQwFkShO8x/BBpob6tG2CVCHoB5dipN7Uo
   wUhjn1YC/0kP2PMSoTiK/f42B7x5XP+ofFIoCd3glBwxML2/YZTpVsGTl
   bn36RkYa68zyS21mBTHKJe+CBRtw0bywaOcZsF6kbQtmHPIVmE0wFRxlK
   /qTkwlhK4FzRgCkzRcnWJS8rIRDu9CQN8IkjMhibnbio9Rj7mkSKuftGK
   3Uh/GUgSVhEDtDJ3/HoHKzT8mhKju9A8GG0wTOKEe1PLsd8q+zxDVtRmK
   r4NpDkh5F5NOX+aHdfsJTykykZqjpx16QmC78LB9DMNNBYuJVyiN/SxFX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="268327238"
X-IronPort-AV: E=Sophos;i="5.91,207,1647327600"; 
   d="scan'208";a="268327238"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2022 05:10:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,207,1647327600"; 
   d="scan'208";a="736165769"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2022 05:10:41 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nnJGi-000EY8-VZ;
        Sat, 07 May 2022 12:10:40 +0000
Date:   Sat, 7 May 2022 20:10:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] net: dsa: realtek: rtl8366rb: Serialize indirect PHY
 register access
Message-ID: <202205071955.IM81bph1-lkp@intel.com>
References: <20220507073945.2462186-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220507073945.2462186-1-linus.walleij@linaro.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.18-rc5 next-20220506]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Linus-Walleij/net-dsa-realtek-rtl8366rb-Serialize-indirect-PHY-register-access/20220507-154616
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 4b97bac0756a81cda5afd45417a99b5bccdcff67
config: riscv-randconfig-c006-20220506 (https://download.01.org/0day-ci/archive/20220507/202205071955.IM81bph1-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project af4cf1c6b8ed0d8102fc5e69acdc2fcbbcdaa9a7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/5858edf68f246841b19173d0a30ebc5651f7b0c2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Linus-Walleij/net-dsa-realtek-rtl8366rb-Serialize-indirect-PHY-register-access/20220507-154616
        git checkout 5858edf68f246841b19173d0a30ebc5651f7b0c2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/dsa/realtek/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/net/dsa/realtek/rtl8366rb.c:16:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from drivers/net/dsa/realtek/rtl8366rb.c:16:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from drivers/net/dsa/realtek/rtl8366rb.c:16:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:1024:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
                                                     ~~~~~~~~~~ ^
>> drivers/net/dsa/realtek/rtl8366rb.c:1666:6: warning: variable 'val' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (ret) {
               ^~~
   drivers/net/dsa/realtek/rtl8366rb.c:1684:9: note: uninitialized use occurs here
           return val;
                  ^~~
   drivers/net/dsa/realtek/rtl8366rb.c:1666:2: note: remove the 'if' if its condition is always false
           if (ret) {
           ^~~~~~~~~~
   drivers/net/dsa/realtek/rtl8366rb.c:1660:6: warning: variable 'val' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (ret)
               ^~~
   drivers/net/dsa/realtek/rtl8366rb.c:1684:9: note: uninitialized use occurs here
           return val;
                  ^~~
   drivers/net/dsa/realtek/rtl8366rb.c:1660:2: note: remove the 'if' if its condition is always false
           if (ret)
           ^~~~~~~~
   drivers/net/dsa/realtek/rtl8366rb.c:1649:9: note: initialize the variable 'val' to silence this warning
           u32 val;
                  ^
                   = 0
   9 warnings generated.


vim +1666 drivers/net/dsa/realtek/rtl8366rb.c

d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1646  
f5f119077b1cd6 drivers/net/dsa/realtek/rtl8366rb.c Luiz Angelo Daros de Luca 2022-01-28  1647  static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int regnum)
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1648  {
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1649  	u32 val;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1650  	u32 reg;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1651  	int ret;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1652  
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1653  	if (phy > RTL8366RB_PHY_NO_MAX)
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1654  		return -EINVAL;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1655  
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1656  	mutex_lock(&priv->map_lock);
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1657  
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1658  	ret = regmap_write(priv->map_nolock, RTL8366RB_PHY_ACCESS_CTRL_REG,
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1659  			   RTL8366RB_PHY_CTRL_READ);
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1660  	if (ret)
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1661  		goto out;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1662  
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1663  	reg = 0x8000 | (1 << (phy + RTL8366RB_PHY_NO_OFFSET)) | regnum;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1664  
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1665  	ret = regmap_write(priv->map_nolock, reg, 0);
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14 @1666  	if (ret) {
f5f119077b1cd6 drivers/net/dsa/realtek/rtl8366rb.c Luiz Angelo Daros de Luca 2022-01-28  1667  		dev_err(priv->dev,
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1668  			"failed to write PHY%d reg %04x @ %04x, ret %d\n",
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1669  			phy, regnum, reg, ret);
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1670  		goto out;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1671  	}
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1672  
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1673  	ret = regmap_read(priv->map_nolock, RTL8366RB_PHY_ACCESS_DATA_REG,
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1674  			  &val);
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1675  	if (ret)
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1676  		goto out;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1677  
f5f119077b1cd6 drivers/net/dsa/realtek/rtl8366rb.c Luiz Angelo Daros de Luca 2022-01-28  1678  	dev_dbg(priv->dev, "read PHY%d register 0x%04x @ %08x, val <- %04x\n",
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1679  		phy, regnum, reg, val);
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1680  
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1681  out:
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1682  	mutex_unlock(&priv->map_lock);
5858edf68f2468 drivers/net/dsa/realtek/rtl8366rb.c Alvin Šipraga             2022-05-07  1683  
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1684  	return val;
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1685  }
d8652956cf37c5 drivers/net/dsa/rtl8366rb.c         Linus Walleij             2018-07-14  1686  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
