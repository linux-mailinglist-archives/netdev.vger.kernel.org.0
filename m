Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291786BF86E
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 08:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCRHJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 03:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCRHJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 03:09:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA6D4C07;
        Sat, 18 Mar 2023 00:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679123388; x=1710659388;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZZe5l4cXg80AEW9cX2gNAzHIp4JAzqxmUcwHOz1YtFo=;
  b=nuuEai4SKxjHs87t3dGjuatQFWSEvOvEok7dwen1hLsjtLA8JDt+5jyL
   V0awckugwAl5cCjKmTjU5zx7n4eN2ZhIgzhJgNITwjnyqV4ePxQVBn7wn
   U6Ca3cu8oL+yJq7Z4DKpvV682rgKFfzL/Yjq9hj93TGyws3Bp85uTBm62
   nq3deivxcGZePIJgfstEQUUSPJ82cEm94VDdBVaY/TvNHqTYlHiUY716O
   Jy4gV4XAV2IF4aPqTdWKYAkv1CsU57FuCtA9rNsdEKIzUempdArnXj21V
   jvopH2xCSYcxK2DTisTk8BAkUoyRdot3/k4GbQ4CJhapEUbandY8f4PK2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="318069525"
X-IronPort-AV: E=Sophos;i="5.98,271,1673942400"; 
   d="scan'208";a="318069525"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2023 00:09:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="673812694"
X-IronPort-AV: E=Sophos;i="5.98,271,1673942400"; 
   d="scan'208";a="673812694"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 18 Mar 2023 00:09:42 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pdQh6-0009tK-1Y;
        Sat, 18 Mar 2023 07:09:36 +0000
Date:   Sat, 18 Mar 2023 15:08:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] net: usb: lan78xx: Limit packet length to skb->len
Message-ID: <202303181417.1MZBovse-lkp@intel.com>
References: <20230317173606.91426-1-szymon.heidrich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317173606.91426-1-szymon.heidrich@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Szymon,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]
[also build test WARNING on net/main linus/master v6.3-rc2 next-20230317]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Szymon-Heidrich/net-usb-lan78xx-Limit-packet-length-to-skb-len/20230318-013659
patch link:    https://lore.kernel.org/r/20230317173606.91426-1-szymon.heidrich%40gmail.com
patch subject: [PATCH v2] net: usb: lan78xx: Limit packet length to skb->len
config: s390-randconfig-r003-20230318 (https://download.01.org/0day-ci/archive/20230318/202303181417.1MZBovse-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/17c060ef752f4a1366ed7d8e62ba5f64f654eced
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Szymon-Heidrich/net-usb-lan78xx-Limit-packet-length-to-skb-len/20230318-013659
        git checkout 17c060ef752f4a1366ed7d8e62ba5f64f654eced
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/net/usb/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303181417.1MZBovse-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/net/usb/lan78xx.c:6:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/net/usb/lan78xx.c:6:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/net/usb/lan78xx.c:6:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/net/usb/lan78xx.c:3603:20: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
                           struct sk_buff *skb2;
                                           ^
   13 warnings generated.


vim +3603 drivers/net/usb/lan78xx.c

55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3552  
ec4c7e12396b1a John Efstathiades         2021-11-18  3553  static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
ec4c7e12396b1a John Efstathiades         2021-11-18  3554  		      int budget, int *work_done)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3555  {
0dd87266c1337d John Efstathiades         2021-11-18  3556  	if (skb->len < RX_SKB_MIN_LEN)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3557  		return 0;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3558  
ec4c7e12396b1a John Efstathiades         2021-11-18  3559  	/* Extract frames from the URB buffer and pass each one to
ec4c7e12396b1a John Efstathiades         2021-11-18  3560  	 * the stack in a new NAPI SKB.
ec4c7e12396b1a John Efstathiades         2021-11-18  3561  	 */
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3562  	while (skb->len > 0) {
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3563  		u32 rx_cmd_a, rx_cmd_b, align_count, size;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3564  		u16 rx_cmd_c;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3565  		unsigned char *packet;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3566  
bb448f8a60ea93 Chuhong Yuan              2019-07-19  3567  		rx_cmd_a = get_unaligned_le32(skb->data);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3568  		skb_pull(skb, sizeof(rx_cmd_a));
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3569  
bb448f8a60ea93 Chuhong Yuan              2019-07-19  3570  		rx_cmd_b = get_unaligned_le32(skb->data);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3571  		skb_pull(skb, sizeof(rx_cmd_b));
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3572  
bb448f8a60ea93 Chuhong Yuan              2019-07-19  3573  		rx_cmd_c = get_unaligned_le16(skb->data);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3574  		skb_pull(skb, sizeof(rx_cmd_c));
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3575  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3576  		packet = skb->data;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3577  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3578  		/* get the packet length */
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3579  		size = (rx_cmd_a & RX_CMD_A_LEN_MASK_);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3580  		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3581  
17c060ef752f4a Szymon Heidrich           2023-03-17  3582  		if (unlikely(size > skb->len)) {
17c060ef752f4a Szymon Heidrich           2023-03-17  3583  			netif_dbg(dev, rx_err, dev->net,
17c060ef752f4a Szymon Heidrich           2023-03-17  3584  				  "size err rx_cmd_a=0x%08x\n",
17c060ef752f4a Szymon Heidrich           2023-03-17  3585  				  rx_cmd_a);
17c060ef752f4a Szymon Heidrich           2023-03-17  3586  			return 0;
17c060ef752f4a Szymon Heidrich           2023-03-17  3587  		}
17c060ef752f4a Szymon Heidrich           2023-03-17  3588  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3589  		if (unlikely(rx_cmd_a & RX_CMD_A_RED_)) {
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3590  			netif_dbg(dev, rx_err, dev->net,
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3591  				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3592  		} else {
17c060ef752f4a Szymon Heidrich           2023-03-17  3593  			u32 frame_len;
17c060ef752f4a Szymon Heidrich           2023-03-17  3594  
17c060ef752f4a Szymon Heidrich           2023-03-17  3595  			if (unlikely(size < ETH_FCS_LEN)) {
17c060ef752f4a Szymon Heidrich           2023-03-17  3596  				netif_dbg(dev, rx_err, dev->net,
17c060ef752f4a Szymon Heidrich           2023-03-17  3597  					  "size err rx_cmd_a=0x%08x\n",
17c060ef752f4a Szymon Heidrich           2023-03-17  3598  					  rx_cmd_a);
17c060ef752f4a Szymon Heidrich           2023-03-17  3599  				return 0;
17c060ef752f4a Szymon Heidrich           2023-03-17  3600  			}
17c060ef752f4a Szymon Heidrich           2023-03-17  3601  
17c060ef752f4a Szymon Heidrich           2023-03-17  3602  			frame_len = size - ETH_FCS_LEN;
ec4c7e12396b1a John Efstathiades         2021-11-18 @3603  			struct sk_buff *skb2;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3604  
ec4c7e12396b1a John Efstathiades         2021-11-18  3605  			skb2 = napi_alloc_skb(&dev->napi, frame_len);
ec4c7e12396b1a John Efstathiades         2021-11-18  3606  			if (!skb2)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3607  				return 0;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3608  
ec4c7e12396b1a John Efstathiades         2021-11-18  3609  			memcpy(skb2->data, packet, frame_len);
ec4c7e12396b1a John Efstathiades         2021-11-18  3610  
ec4c7e12396b1a John Efstathiades         2021-11-18  3611  			skb_put(skb2, frame_len);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3612  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3613  			lan78xx_rx_csum_offload(dev, skb2, rx_cmd_a, rx_cmd_b);
ec21ecf0aad279 Dave Stevenson            2018-06-25  3614  			lan78xx_rx_vlan_offload(dev, skb2, rx_cmd_a, rx_cmd_b);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3615  
ec4c7e12396b1a John Efstathiades         2021-11-18  3616  			/* Processing of the URB buffer must complete once
ec4c7e12396b1a John Efstathiades         2021-11-18  3617  			 * it has started. If the NAPI work budget is exhausted
ec4c7e12396b1a John Efstathiades         2021-11-18  3618  			 * while frames remain they are added to the overflow
ec4c7e12396b1a John Efstathiades         2021-11-18  3619  			 * queue for delivery in the next NAPI polling cycle.
ec4c7e12396b1a John Efstathiades         2021-11-18  3620  			 */
ec4c7e12396b1a John Efstathiades         2021-11-18  3621  			if (*work_done < budget) {
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3622  				lan78xx_skb_return(dev, skb2);
ec4c7e12396b1a John Efstathiades         2021-11-18  3623  				++(*work_done);
ec4c7e12396b1a John Efstathiades         2021-11-18  3624  			} else {
ec4c7e12396b1a John Efstathiades         2021-11-18  3625  				skb_queue_tail(&dev->rxq_overflow, skb2);
ec4c7e12396b1a John Efstathiades         2021-11-18  3626  			}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3627  		}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3628  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3629  		skb_pull(skb, size);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3630  
ec4c7e12396b1a John Efstathiades         2021-11-18  3631  		/* skip padding bytes before the next frame starts */
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3632  		if (skb->len)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3633  			skb_pull(skb, align_count);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3634  	}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3635  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3636  	return 1;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3637  }
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3638  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
