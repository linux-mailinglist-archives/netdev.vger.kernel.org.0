Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA5D68F7F4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 20:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbjBHTX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 14:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjBHTXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 14:23:24 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642817EEC;
        Wed,  8 Feb 2023 11:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675884201; x=1707420201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x8JvwmPfV501F78zkonRHlQok1YynedVrVweId2Hv6s=;
  b=BKxoFK/Pxg2d1RqOtpNBfPYqcuGS2L2s5xEQXbEIH21a9OHVAsokGJju
   S559p0E1tE5Zrmhkn7HlQP+2WbJVIJgk+TfkPzVTdqUxQEJqRVKb8Fihu
   jUiaZ/weWcCF4Pmi0jMRuqvFWPla5+DgHtw/Ndj56kb5TX/kOoEEuWJoK
   EPHClb5JXk6T0bsCBor3edldnUYsQdZvTQ9GWSEWPY+agNjz7cLAnuh0g
   r5k3EnJi53gqIlI2BM4XociuPeYg7tBkHaeM68f+pthIm0blgKmC4s83X
   k2jXTvFRAOV8YzO9po0dhoTkm5Zb0Xei3WuD7p1Qh4O+srGBP0vSsL7AW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="332024288"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="332024288"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 11:23:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="644982911"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="644982911"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 11:23:12 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pPq2B-0004bg-0q;
        Wed, 08 Feb 2023 19:23:11 +0000
Date:   Thu, 9 Feb 2023 03:22:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>,
        yury.norov@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev, Jonathan.Cameron@huawei.com,
        andriy.shevchenko@linux.intel.com, baohua@kernel.org,
        bristot@redhat.com, bsegall@google.com, davem@davemloft.net,
        dietmar.eggemann@arm.com, gal@nvidia.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        jgg@nvidia.com, juri.lelli@redhat.com, kuba@kernel.org,
        leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@redhat.com,
        netdev@vger.kernel.org, peter@n8pjl.ca, peterz@infradead.org,
        rostedt@goodmis.org, saeedm@nvidia.com, tariqt@nvidia.com,
        tony.luck@intel.com
Subject: Re: [PATCH 1/1] ice: Change assigning method of the CPU affinity
 masks
Message-ID: <202302090331.7L2Y93PP-lkp@intel.com>
References: <20230208153905.109912-1-pawel.chmielewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208153905.109912-1-pawel.chmielewski@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pawel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on tnguy-next-queue/dev-queue]
[also build test ERROR on linus/master v6.2-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pawel-Chmielewski/ice-Change-assigning-method-of-the-CPU-affinity-masks/20230208-234144
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
patch link:    https://lore.kernel.org/r/20230208153905.109912-1-pawel.chmielewski%40intel.com
patch subject: [PATCH 1/1] ice: Change assigning method of the CPU affinity masks
config: arm-randconfig-r046-20230209 (https://download.01.org/0day-ci/archive/20230209/202302090331.7L2Y93PP-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/33971c3245ae75900dbc4cc9aa2b76ff9cdb534c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Pawel-Chmielewski/ice-Change-assigning-method-of-the-CPU-affinity-masks/20230208-234144
        git checkout 33971c3245ae75900dbc4cc9aa2b76ff9cdb534c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/intel/ice/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/20230208153905.109912-1-pawel.chmielewski@intel.com

All errors (new ones prefixed by >>):

   drivers/net/ethernet/intel/ice/ice_base.c: In function 'ice_vsi_alloc_q_vectors':
>> drivers/net/ethernet/intel/ice/ice_base.c:662:28: error: 'struct device' has no member named 'numa_node'
     662 |         int numa_node = dev->numa_node;
         |                            ^~
>> drivers/net/ethernet/intel/ice/ice_base.c:678:9: error: implicit declaration of function 'for_each_numa_hop_mask'; did you mean 'for_each_node_mask'? [-Werror=implicit-function-declaration]
     678 |         for_each_numa_hop_mask(aff_mask, numa_node) {
         |         ^~~~~~~~~~~~~~~~~~~~~~
         |         for_each_node_mask
>> drivers/net/ethernet/intel/ice/ice_base.c:678:52: error: expected ';' before '{' token
     678 |         for_each_numa_hop_mask(aff_mask, numa_node) {
         |                                                    ^~
         |                                                    ;
   drivers/net/ethernet/intel/ice/ice_base.c:663:20: warning: unused variable 'cpu' [-Wunused-variable]
     663 |         u16 v_idx, cpu = 0;
         |                    ^~~
   drivers/net/ethernet/intel/ice/ice_base.c:660:31: warning: unused variable 'last_aff_mask' [-Wunused-variable]
     660 |         cpumask_t *aff_mask, *last_aff_mask = cpu_none_mask;
         |                               ^~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +662 drivers/net/ethernet/intel/ice/ice_base.c

   650	
   651	/**
   652	 * ice_vsi_alloc_q_vectors - Allocate memory for interrupt vectors
   653	 * @vsi: the VSI being configured
   654	 *
   655	 * We allocate one q_vector per queue interrupt. If allocation fails we
   656	 * return -ENOMEM.
   657	 */
   658	int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
   659	{
   660		cpumask_t *aff_mask, *last_aff_mask = cpu_none_mask;
   661		struct device *dev = ice_pf_to_dev(vsi->back);
 > 662		int numa_node = dev->numa_node;
   663		u16 v_idx, cpu = 0;
   664		int err;
   665	
   666		if (vsi->q_vectors[0]) {
   667			dev_dbg(dev, "VSI %d has existing q_vectors\n", vsi->vsi_num);
   668			return -EEXIST;
   669		}
   670	
   671		for (v_idx = 0; v_idx < vsi->num_q_vectors; v_idx++) {
   672			err = ice_vsi_alloc_q_vector(vsi, v_idx);
   673			if (err)
   674				goto err_out;
   675		}
   676	
   677		v_idx = 0;
 > 678		for_each_numa_hop_mask(aff_mask, numa_node) {
   679			for_each_cpu_andnot(cpu, aff_mask, last_aff_mask)
   680				if (v_idx < vsi->num_q_vectors) {
   681					if (cpu_online(cpu))
   682						cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
   683					v_idx++;
   684				}
   685			last_aff_mask = aff_mask;
   686		}
   687	
   688		return 0;
   689	
   690	err_out:
   691		while (v_idx--)
   692			ice_free_q_vector(vsi, v_idx);
   693	
   694		dev_err(dev, "Failed to allocate %d q_vector for VSI %d, ret=%d\n",
   695			vsi->num_q_vectors, vsi->vsi_num, err);
   696		vsi->num_q_vectors = 0;
   697		return err;
   698	}
   699	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
