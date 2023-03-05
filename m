Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D9A6AAF48
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 12:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjCELW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 06:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCELW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 06:22:28 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A61EA5F5;
        Sun,  5 Mar 2023 03:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678015347; x=1709551347;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YspSz6HVobERfe6tNMqxvlJoMX2cvmnkOE7gTDTCvwc=;
  b=hWy9tgX/YFwWU79t0lL5ivVoWxHJR6yXsTGPhEntx5uGF24GVndYUQUW
   golAzVZKiPMHor92slTwEMZdDquFvss5RPMsyJPX+1aO5KfMngyvb70rm
   4rTuJPXUqZvnPCeHp8dNgAKO8N8pm0MgoONmqCsEopQRxa30oWO2KZP3N
   h/T1rAChrY9kC7px1KuMUp1pcI0gTer2FRQTB4T8mjB5isvrNyFHxDxTX
   OtfmoiwvPPRbtVRGK+lD1vly+2n3/konGwbBaEKns+B2JVXps2+lWXiui
   +CKrEYsXQZ++98eRX8zrfmBpaeiXfs5+m4+qIdhN7SrtOm+1bd8wYdugx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10639"; a="336883397"
X-IronPort-AV: E=Sophos;i="5.98,235,1673942400"; 
   d="scan'208";a="336883397"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2023 03:22:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10639"; a="764924029"
X-IronPort-AV: E=Sophos;i="5.98,235,1673942400"; 
   d="scan'208";a="764924029"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Mar 2023 03:22:24 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYmRb-0002im-2h;
        Sun, 05 Mar 2023 11:22:23 +0000
Date:   Sun, 5 Mar 2023 19:21:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH v2 6/8] vdpa_sim: use kthread worker
Message-ID: <202303051841.bPAIzJRy-lkp@intel.com>
References: <20230302113421.174582-7-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302113421.174582-7-sgarzare@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on linus/master next-20230303]
[cannot apply to v6.2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Stefano-Garzarella/vdpa-add-bind_mm-unbind_mm-callbacks/20230302-193850
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
patch link:    https://lore.kernel.org/r/20230302113421.174582-7-sgarzare%40redhat.com
patch subject: [PATCH v2 6/8] vdpa_sim: use kthread worker
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20230305/202303051841.bPAIzJRy-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5b2107457ac0e7b1bb0aa3635ebf13b02e82bb78
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stefano-Garzarella/vdpa-add-bind_mm-unbind_mm-callbacks/20230302-193850
        git checkout 5b2107457ac0e7b1bb0aa3635ebf13b02e82bb78
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/wireless/ath/ath10k/ drivers/vdpa/vdpa_sim/ fs/erofs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303051841.bPAIzJRy-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vdpa/vdpa_sim/vdpa_sim.c:166:6: warning: variable 'dev' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (IS_ERR(vdpasim->worker))
               ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/vdpa/vdpa_sim/vdpa_sim.c:213:13: note: uninitialized use occurs here
           put_device(dev);
                      ^~~
   drivers/vdpa/vdpa_sim/vdpa_sim.c:166:2: note: remove the 'if' if its condition is always false
           if (IS_ERR(vdpasim->worker))
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vdpa/vdpa_sim/vdpa_sim.c:132:20: note: initialize the variable 'dev' to silence this warning
           struct device *dev;
                             ^
                              = NULL
   1 warning generated.


vim +166 drivers/vdpa/vdpa_sim/vdpa_sim.c

   125	
   126	struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
   127				       const struct vdpa_dev_set_config *config)
   128	{
   129		const struct vdpa_config_ops *ops;
   130		struct vdpa_device *vdpa;
   131		struct vdpasim *vdpasim;
   132		struct device *dev;
   133		int i, ret = -ENOMEM;
   134	
   135		if (!dev_attr->alloc_size)
   136			return ERR_PTR(-EINVAL);
   137	
   138		if (config->mask & BIT_ULL(VDPA_ATTR_DEV_FEATURES)) {
   139			if (config->device_features &
   140			    ~dev_attr->supported_features)
   141				return ERR_PTR(-EINVAL);
   142			dev_attr->supported_features =
   143				config->device_features;
   144		}
   145	
   146		if (batch_mapping)
   147			ops = &vdpasim_batch_config_ops;
   148		else
   149			ops = &vdpasim_config_ops;
   150	
   151		vdpa = __vdpa_alloc_device(NULL, ops,
   152					   dev_attr->ngroups, dev_attr->nas,
   153					   dev_attr->alloc_size,
   154					   dev_attr->name, false);
   155		if (IS_ERR(vdpa)) {
   156			ret = PTR_ERR(vdpa);
   157			goto err_alloc;
   158		}
   159	
   160		vdpasim = vdpa_to_sim(vdpa);
   161		vdpasim->dev_attr = *dev_attr;
   162	
   163		kthread_init_work(&vdpasim->work, vdpasim_work_fn);
   164		vdpasim->worker = kthread_create_worker(0, "vDPA sim worker: %s",
   165							dev_attr->name);
 > 166		if (IS_ERR(vdpasim->worker))
   167			goto err_iommu;
   168	
   169		spin_lock_init(&vdpasim->lock);
   170		spin_lock_init(&vdpasim->iommu_lock);
   171	
   172		dev = &vdpasim->vdpa.dev;
   173		dev->dma_mask = &dev->coherent_dma_mask;
   174		if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
   175			goto err_iommu;
   176		vdpasim->vdpa.mdev = dev_attr->mgmt_dev;
   177	
   178		vdpasim->config = kzalloc(dev_attr->config_size, GFP_KERNEL);
   179		if (!vdpasim->config)
   180			goto err_iommu;
   181	
   182		vdpasim->vqs = kcalloc(dev_attr->nvqs, sizeof(struct vdpasim_virtqueue),
   183				       GFP_KERNEL);
   184		if (!vdpasim->vqs)
   185			goto err_iommu;
   186	
   187		vdpasim->iommu = kmalloc_array(vdpasim->dev_attr.nas,
   188					       sizeof(*vdpasim->iommu), GFP_KERNEL);
   189		if (!vdpasim->iommu)
   190			goto err_iommu;
   191	
   192		vdpasim->iommu_pt = kmalloc_array(vdpasim->dev_attr.nas,
   193						  sizeof(*vdpasim->iommu_pt), GFP_KERNEL);
   194		if (!vdpasim->iommu_pt)
   195			goto err_iommu;
   196	
   197		for (i = 0; i < vdpasim->dev_attr.nas; i++)
   198			vhost_iotlb_init(&vdpasim->iommu[i], max_iotlb_entries, 0);
   199	
   200		vdpasim->buffer = kvmalloc(dev_attr->buffer_size, GFP_KERNEL);
   201		if (!vdpasim->buffer)
   202			goto err_iommu;
   203	
   204		for (i = 0; i < dev_attr->nvqs; i++)
   205			vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
   206					 &vdpasim->iommu_lock);
   207	
   208		vdpasim->vdpa.dma_dev = dev;
   209	
   210		return vdpasim;
   211	
   212	err_iommu:
   213		put_device(dev);
   214	err_alloc:
   215		return ERR_PTR(ret);
   216	}
   217	EXPORT_SYMBOL_GPL(vdpasim_create);
   218	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
