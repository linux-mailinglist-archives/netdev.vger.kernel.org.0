Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260D0439013
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 09:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhJYHM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 03:12:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:22813 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229727AbhJYHMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 03:12:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10147"; a="228344438"
X-IronPort-AV: E=Sophos;i="5.87,179,1631602800"; 
   d="gz'50?scan'50,208,50";a="228344438"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 00:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,179,1631602800"; 
   d="gz'50?scan'50,208,50";a="446516453"
Received: from lkp-server02.sh.intel.com (HELO 74392981b700) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 25 Oct 2021 00:10:00 -0700
Received: from kbuild by 74392981b700 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1meu7L-0001Sa-OJ; Mon, 25 Oct 2021 07:09:59 +0000
Date:   Mon, 25 Oct 2021 15:09:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Feng Li <lifeng1519@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [mst-vhost:vhost 4/47] drivers/block/virtio_blk.c:175:17: error:
 implicit declaration of function 'sg_free_table_chained'
Message-ID: <202110251556.mUpsGaHx-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   2b109044b081148b58974f5696ffd4383c3e9abb
commit: b2c5221fd074fbb0e57d6707bed5b7386bf430ed [4/47] virtio-blk: avoid preallocating big SGL for data
config: riscv-nommu_virt_defconfig (attached as .config)
compiler: riscv64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=b2c5221fd074fbb0e57d6707bed5b7386bf430ed
        git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
        git fetch --no-tags mst-vhost vhost
        git checkout b2c5221fd074fbb0e57d6707bed5b7386bf430ed
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=riscv 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/block/virtio_blk.c: In function 'virtblk_unmap_data':
>> drivers/block/virtio_blk.c:175:17: error: implicit declaration of function 'sg_free_table_chained' [-Werror=implicit-function-declaration]
     175 |                 sg_free_table_chained(&vbr->sg_table,
         |                 ^~~~~~~~~~~~~~~~~~~~~
   drivers/block/virtio_blk.c: In function 'virtblk_map_data':
>> drivers/block/virtio_blk.c:188:15: error: implicit declaration of function 'sg_alloc_table_chained'; did you mean 'sg_alloc_table'? [-Werror=implicit-function-declaration]
     188 |         err = sg_alloc_table_chained(&vbr->sg_table,
         |               ^~~~~~~~~~~~~~~~~~~~~~
         |               sg_alloc_table
   cc1: some warnings being treated as errors


vim +/sg_free_table_chained +175 drivers/block/virtio_blk.c

   171	
   172	static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
   173	{
   174		if (blk_rq_nr_phys_segments(req))
 > 175			sg_free_table_chained(&vbr->sg_table,
   176					      VIRTIO_BLK_INLINE_SG_CNT);
   177	}
   178	
   179	static int virtblk_map_data(struct blk_mq_hw_ctx *hctx, struct request *req,
   180			struct virtblk_req *vbr)
   181	{
   182		int err;
   183	
   184		if (!blk_rq_nr_phys_segments(req))
   185			return 0;
   186	
   187		vbr->sg_table.sgl = vbr->sg;
 > 188		err = sg_alloc_table_chained(&vbr->sg_table,
   189					     blk_rq_nr_phys_segments(req),
   190					     vbr->sg_table.sgl,
   191					     VIRTIO_BLK_INLINE_SG_CNT);
   192		if (unlikely(err))
   193			return -ENOMEM;
   194	
   195		return blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
   196	}
   197	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--5mCyUwZo2JvN/JJP
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
rvEjcS4ODmDvhJmPVv4FNHZu6rtrAAA=

--5mCyUwZo2JvN/JJP--
