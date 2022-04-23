Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95DE50C956
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiDWKfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 06:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbiDWKfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 06:35:16 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05761167E3;
        Sat, 23 Apr 2022 03:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650709939; x=1682245939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=99EiatxEAzm7mLpblkfbmxHzYEHnM6shM4C4UTNQKG4=;
  b=NHy0IDNchryk1SJA9SO8XDITMfgqgsxuFgbOvrLE1iEn0yaMK7At/ZJt
   STnhAjO+Ri/hjVblyAboZP2ZM/yQIOHPYtU/QzD86gYulj4T9UJPxpmaJ
   IiguQqKLE3U1V7E+Xb/TVngpTnZtp6XwUEuK6qov1inQ+KlbKyWpgUW2z
   wqH075QS/1sciDLkBMsRn9b8IwZklC/CmS9wiLaia2yZTw++VopmAqTjs
   XC7Dne9N2Zpc0NhcZqwDSI+6qfkgturJpnU6Vgo9FvTnOMyBDVuiEUGZe
   xl+3YdHyP5k0uwcZER0STOzjB9Y+tfQb6Wf9/vxaI+gvzYhvDbS7tNk8K
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="290008027"
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="290008027"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 03:32:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="627338427"
Received: from lkp-server01.sh.intel.com (HELO dd58949a6e39) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 23 Apr 2022 03:32:16 -0700
Received: from kbuild by dd58949a6e39 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1niD3o-0000AT-7v;
        Sat, 23 Apr 2022 10:32:16 +0000
Date:   Sat, 23 Apr 2022 18:31:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vasily Averin <vvs@openvz.org>, Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: set proper memcg for net_init hooks allocations
Message-ID: <202204231806.8O86U791-lkp@intel.com>
References: <6f38e02b-9af3-4dcf-9000-1118a04b13c7@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f38e02b-9af3-4dcf-9000-1118a04b13c7@openvz.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vasily,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.18-rc3 next-20220422]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Vasily-Averin/net-set-proper-memcg-for-net_init-hooks-allocations/20220423-160759
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git c00c5e1d157bec0ef0b0b59aa5482eb8dc7e8e49
config: riscv-randconfig-r042-20220422 (https://download.01.org/0day-ci/archive/20220423/202204231806.8O86U791-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5bd87350a5ae429baf8f373cb226a57b62f87280)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/3b379e5391e36e13b9f36305aa6d233fb03d4e58
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vasily-Averin/net-set-proper-memcg-for-net_init-hooks-allocations/20220423-160759
        git checkout 3b379e5391e36e13b9f36305aa6d233fb03d4e58
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/gpu/drm/exynos/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/gpu/drm/exynos/exynos_drm_dma.c:15:
   In file included from drivers/gpu/drm/exynos/exynos_drm_drv.h:16:
   In file included from include/drm/drm_crtc.h:28:
   In file included from include/linux/i2c.h:19:
   In file included from include/linux/regulator/consumer.h:35:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   include/linux/memcontrol.h:1773:21: error: call to undeclared function 'css_tryget'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           } while (memcg && !css_tryget(&memcg->css));
                              ^
   include/linux/memcontrol.h:1773:38: error: incomplete definition of type 'struct mem_cgroup'
           } while (memcg && !css_tryget(&memcg->css));
                                          ~~~~~^
   include/linux/mm_types.h:31:8: note: forward declaration of 'struct mem_cgroup'
   struct mem_cgroup;
          ^
>> drivers/gpu/drm/exynos/exynos_drm_dma.c:55:35: warning: implicit conversion from 'unsigned long long' to 'unsigned int' changes value from 18446744073709551615 to 4294967295 [-Wconstant-conversion]
           dma_set_max_seg_size(subdrv_dev, DMA_BIT_MASK(32));
           ~~~~~~~~~~~~~~~~~~~~             ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:76:40: note: expanded from macro 'DMA_BIT_MASK'
   #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                                          ^~~~~
   1 warning and 2 errors generated.


vim +55 drivers/gpu/drm/exynos/exynos_drm_dma.c

67fbf3a3ef8443 Andrzej Hajda    2018-10-12  33  
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  34  /*
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  35   * drm_iommu_attach_device- attach device to iommu mapping
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  36   *
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  37   * @drm_dev: DRM device
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  38   * @subdrv_dev: device to be attach
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  39   *
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  40   * This function should be called by sub drivers to attach it to iommu
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  41   * mapping.
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  42   */
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  43  static int drm_iommu_attach_device(struct drm_device *drm_dev,
07dc3678bacc2a Marek Szyprowski 2020-03-09  44  				struct device *subdrv_dev, void **dma_priv)
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  45  {
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  46  	struct exynos_drm_private *priv = drm_dev->dev_private;
b9c633882de460 Marek Szyprowski 2020-06-01  47  	int ret = 0;
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  48  
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  49  	if (get_dma_ops(priv->dma_dev) != get_dma_ops(subdrv_dev)) {
6f83d20838c099 Inki Dae         2019-04-15  50  		DRM_DEV_ERROR(subdrv_dev, "Device %s lacks support for IOMMU\n",
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  51  			  dev_name(subdrv_dev));
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  52  		return -EINVAL;
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  53  	}
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  54  
ddfd4ab6bb0883 Marek Szyprowski 2020-07-07 @55  	dma_set_max_seg_size(subdrv_dev, DMA_BIT_MASK(32));
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  56  	if (IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)) {
07dc3678bacc2a Marek Szyprowski 2020-03-09  57  		/*
07dc3678bacc2a Marek Szyprowski 2020-03-09  58  		 * Keep the original DMA mapping of the sub-device and
07dc3678bacc2a Marek Szyprowski 2020-03-09  59  		 * restore it on Exynos DRM detach, otherwise the DMA
07dc3678bacc2a Marek Szyprowski 2020-03-09  60  		 * framework considers it as IOMMU-less during the next
07dc3678bacc2a Marek Szyprowski 2020-03-09  61  		 * probe (in case of deferred probe or modular build)
07dc3678bacc2a Marek Szyprowski 2020-03-09  62  		 */
07dc3678bacc2a Marek Szyprowski 2020-03-09  63  		*dma_priv = to_dma_iommu_mapping(subdrv_dev);
07dc3678bacc2a Marek Szyprowski 2020-03-09  64  		if (*dma_priv)
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  65  			arm_iommu_detach_device(subdrv_dev);
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  66  
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  67  		ret = arm_iommu_attach_device(subdrv_dev, priv->mapping);
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  68  	} else if (IS_ENABLED(CONFIG_IOMMU_DMA)) {
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  69  		ret = iommu_attach_device(priv->mapping, subdrv_dev);
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  70  	}
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  71  
b9c633882de460 Marek Szyprowski 2020-06-01  72  	return ret;
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  73  }
67fbf3a3ef8443 Andrzej Hajda    2018-10-12  74  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
