Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB93A6C5C79
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 03:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCWCHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 22:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCWCHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 22:07:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5F1C158;
        Wed, 22 Mar 2023 19:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679537229; x=1711073229;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YcF6oXbkraAUc5DQwXJNDo/0gXTDsPYlop4iuj4uF1E=;
  b=dOdhi50g5Kdp7MIK8jZJoGfHT97jo+LA+qJHgqDA5QnN47sa4h3q9KZi
   6fkECYS5dOsXbSnL6tFAlTeqs5d7BKpEMVz2EpVZ5YuswIAbXRBK/L8kU
   lUGFThl4nDvzE9Hv29VGDJRP56/pWi5AfF1MYBfFE8L4uqYpK+Uxp6oH1
   62+N2uP6zVBJNRdkbNqHdGRVVrdWemxgJ8snal/9PeAN3KP7uEjOsJPIE
   yT2r+tbGkiXJNJ8GwZbLOFSeOHrOhER6VcEQQTthFJLHx8DZdghVtGzEI
   oQdXrhlfuErs+Qd3cYdl1xRTpk332BrguIlVwtbTiqtYk0a4/sJHqNXgj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="341739542"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="341739542"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 19:07:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="684527365"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="684527365"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 22 Mar 2023 19:07:05 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pfAM4-000DqN-1B;
        Thu, 23 Mar 2023 02:07:04 +0000
Date:   Thu, 23 Mar 2023 10:06:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] virtio_net: introduce receive_small_xdp()
Message-ID: <202303230953.y0P1e1Fc-lkp@intel.com>
References: <20230322030308.16046-9-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322030308.16046-9-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xuan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Xuan-Zhuo/virtio_net-mergeable-xdp-put-old-page-immediately/20230322-110445
patch link:    https://lore.kernel.org/r/20230322030308.16046-9-xuanzhuo%40linux.alibaba.com
patch subject: [PATCH net-next 8/8] virtio_net: introduce receive_small_xdp()
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20230323/202303230953.y0P1e1Fc-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6445923dc4c91e57f98b8356d0bd706e95dafaa1
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xuan-Zhuo/virtio_net-mergeable-xdp-put-old-page-immediately/20230322-110445
        git checkout 6445923dc4c91e57f98b8356d0bd706e95dafaa1
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303230953.y0P1e1Fc-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/virtio_net.c:969:6: warning: variable 'buflen' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:78:22: note: expanded from macro 'unlikely'
   # define unlikely(x)    __builtin_expect(!!(x), 0)
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:990:22: note: uninitialized use occurs here
           xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
                               ^~~~~~
   drivers/net/virtio_net.c:969:2: note: remove the 'if' if its condition is always true
           if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:958:21: note: initialize the variable 'buflen' to silence this warning
           unsigned int buflen;
                              ^
                               = 0
   drivers/net/virtio_net.c:1428:6: warning: variable 'page' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (unlikely(len > truesize - room)) {
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:78:22: note: expanded from macro 'unlikely'
   # define unlikely(x)    __builtin_expect(!!(x), 0)
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1519:11: note: uninitialized use occurs here
           put_page(page);
                    ^~~~
   drivers/net/virtio_net.c:1428:2: note: remove the 'if' if its condition is always false
           if (unlikely(len > truesize - room)) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1421:19: note: initialize the variable 'page' to silence this warning
           struct page *page;
                            ^
                             = NULL
   drivers/net/virtio_net.c:1428:6: warning: variable 'num_buf' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (unlikely(len > truesize - room)) {
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:78:22: note: expanded from macro 'unlikely'
   # define unlikely(x)    __builtin_expect(!!(x), 0)
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1520:25: note: uninitialized use occurs here
           mergeable_buf_free(rq, num_buf, dev, stats);
                                  ^~~~~~~
   drivers/net/virtio_net.c:1428:2: note: remove the 'if' if its condition is always false
           if (unlikely(len > truesize - room)) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1422:13: note: initialize the variable 'num_buf' to silence this warning
           int num_buf;
                      ^
                       = 0
   3 warnings generated.


vim +969 drivers/net/virtio_net.c

4941d472bf95b4 Jason Wang             2017-07-19   941  
6445923dc4c91e Xuan Zhuo              2023-03-22   942  static struct sk_buff *receive_small_xdp(struct net_device *dev,
bb91accf27335c Jason Wang             2016-12-23   943  					 struct virtnet_info *vi,
bb91accf27335c Jason Wang             2016-12-23   944  					 struct receive_queue *rq,
6445923dc4c91e Xuan Zhuo              2023-03-22   945  					 struct bpf_prog *xdp_prog,
6445923dc4c91e Xuan Zhuo              2023-03-22   946  					 void *buf,
6445923dc4c91e Xuan Zhuo              2023-03-22   947  					 void *ctx,
186b3c998c50fc Jason Wang             2017-09-19   948  					 unsigned int len,
7d9d60fd4ab696 Toshiaki Makita        2018-07-23   949  					 unsigned int *xdp_xmit,
d46eeeaf99bcfa Jason Wang             2018-07-31   950  					 struct virtnet_rq_stats *stats)
f121159d72091f Michael S. Tsirkin     2013-11-28   951  {
4941d472bf95b4 Jason Wang             2017-07-19   952  	unsigned int xdp_headroom = (unsigned long)ctx;
f6b10209b90d48 Jason Wang             2017-02-21   953  	unsigned int header_offset = VIRTNET_RX_PAD + xdp_headroom;
f6b10209b90d48 Jason Wang             2017-02-21   954  	unsigned int headroom = vi->hdr_len + header_offset;
6445923dc4c91e Xuan Zhuo              2023-03-22   955  	struct virtio_net_hdr_mrg_rxbuf *hdr = buf + header_offset;
4941d472bf95b4 Jason Wang             2017-07-19   956  	struct page *page = virt_to_head_page(buf);
4941d472bf95b4 Jason Wang             2017-07-19   957  	struct page *xdp_page;
6445923dc4c91e Xuan Zhuo              2023-03-22   958  	unsigned int buflen;
0354e4d19cd5de John Fastabend         2017-02-02   959  	struct xdp_buff xdp;
6445923dc4c91e Xuan Zhuo              2023-03-22   960  	struct sk_buff *skb;
6445923dc4c91e Xuan Zhuo              2023-03-22   961  	unsigned int delta = 0;
6445923dc4c91e Xuan Zhuo              2023-03-22   962  	unsigned int metasize = 0;
f6b10209b90d48 Jason Wang             2017-02-21   963  	void *orig_data;
bb91accf27335c Jason Wang             2016-12-23   964  	u32 act;
bb91accf27335c Jason Wang             2016-12-23   965  
95dbe9e7b3720e Jesper Dangaard Brouer 2018-02-20   966  	if (unlikely(hdr->hdr.gso_type))
bb91accf27335c Jason Wang             2016-12-23   967  		goto err_xdp;
0354e4d19cd5de John Fastabend         2017-02-02   968  
4941d472bf95b4 Jason Wang             2017-07-19  @969  	if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
4941d472bf95b4 Jason Wang             2017-07-19   970  		int offset = buf - page_address(page) + header_offset;
4941d472bf95b4 Jason Wang             2017-07-19   971  		unsigned int tlen = len + vi->hdr_len;
981f14d42a7f16 Heng Qi                2023-01-31   972  		int num_buf = 1;
4941d472bf95b4 Jason Wang             2017-07-19   973  
4941d472bf95b4 Jason Wang             2017-07-19   974  		xdp_headroom = virtnet_get_headroom(vi);
4941d472bf95b4 Jason Wang             2017-07-19   975  		header_offset = VIRTNET_RX_PAD + xdp_headroom;
4941d472bf95b4 Jason Wang             2017-07-19   976  		headroom = vi->hdr_len + header_offset;
4941d472bf95b4 Jason Wang             2017-07-19   977  		buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
4941d472bf95b4 Jason Wang             2017-07-19   978  			SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
4941d472bf95b4 Jason Wang             2017-07-19   979  		xdp_page = xdp_linearize_page(rq, &num_buf, page,
4941d472bf95b4 Jason Wang             2017-07-19   980  					      offset, header_offset,
4941d472bf95b4 Jason Wang             2017-07-19   981  					      &tlen);
4941d472bf95b4 Jason Wang             2017-07-19   982  		if (!xdp_page)
4941d472bf95b4 Jason Wang             2017-07-19   983  			goto err_xdp;
4941d472bf95b4 Jason Wang             2017-07-19   984  
4941d472bf95b4 Jason Wang             2017-07-19   985  		buf = page_address(xdp_page);
4941d472bf95b4 Jason Wang             2017-07-19   986  		put_page(page);
4941d472bf95b4 Jason Wang             2017-07-19   987  		page = xdp_page;
4941d472bf95b4 Jason Wang             2017-07-19   988  	}
4941d472bf95b4 Jason Wang             2017-07-19   989  
43b5169d8355cc Lorenzo Bianconi       2020-12-22   990  	xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
be9df4aff65f18 Lorenzo Bianconi       2020-12-22   991  	xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
be9df4aff65f18 Lorenzo Bianconi       2020-12-22   992  			 xdp_headroom, len, true);
f6b10209b90d48 Jason Wang             2017-02-21   993  	orig_data = xdp.data;
4249e276b1ab30 Xuan Zhuo              2023-03-22   994  
4249e276b1ab30 Xuan Zhuo              2023-03-22   995  	act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
0354e4d19cd5de John Fastabend         2017-02-02   996  
bb91accf27335c Jason Wang             2016-12-23   997  	switch (act) {
4249e276b1ab30 Xuan Zhuo              2023-03-22   998  	case VIRTNET_XDP_RES_PASS:
2de2f7f40ef923 John Fastabend         2017-02-02   999  		/* Recalculate length in case bpf program changed it */
f6b10209b90d48 Jason Wang             2017-02-21  1000  		delta = orig_data - xdp.data;
6870de435b90c0 Nikita V. Shirokov     2018-04-17  1001  		len = xdp.data_end - xdp.data;
503d539a6e417b Yuya Kusakabe          2020-02-25  1002  		metasize = xdp.data - xdp.data_meta;
bb91accf27335c Jason Wang             2016-12-23  1003  		break;
4249e276b1ab30 Xuan Zhuo              2023-03-22  1004  
4249e276b1ab30 Xuan Zhuo              2023-03-22  1005  	case VIRTNET_XDP_RES_CONSUMED:
bb91accf27335c Jason Wang             2016-12-23  1006  		goto xdp_xmit;
4249e276b1ab30 Xuan Zhuo              2023-03-22  1007  
4249e276b1ab30 Xuan Zhuo              2023-03-22  1008  	case VIRTNET_XDP_RES_DROP:
bb91accf27335c Jason Wang             2016-12-23  1009  		goto err_xdp;
bb91accf27335c Jason Wang             2016-12-23  1010  	}
bb91accf27335c Jason Wang             2016-12-23  1011  
f6b10209b90d48 Jason Wang             2017-02-21  1012  	skb = build_skb(buf, buflen);
053c9e18c6f9cf Wenliang Wang          2021-12-16  1013  	if (!skb)
f6b10209b90d48 Jason Wang             2017-02-21  1014  		goto err;
6445923dc4c91e Xuan Zhuo              2023-03-22  1015  
f6b10209b90d48 Jason Wang             2017-02-21  1016  	skb_reserve(skb, headroom - delta);
6870de435b90c0 Nikita V. Shirokov     2018-04-17  1017  	skb_put(skb, len);
503d539a6e417b Yuya Kusakabe          2020-02-25  1018  	if (metasize)
503d539a6e417b Yuya Kusakabe          2020-02-25  1019  		skb_metadata_set(skb, metasize);
503d539a6e417b Yuya Kusakabe          2020-02-25  1020  
f121159d72091f Michael S. Tsirkin     2013-11-28  1021  	return skb;
bb91accf27335c Jason Wang             2016-12-23  1022  
bb91accf27335c Jason Wang             2016-12-23  1023  err_xdp:
d46eeeaf99bcfa Jason Wang             2018-07-31  1024  	stats->xdp_drops++;
053c9e18c6f9cf Wenliang Wang          2021-12-16  1025  err:
d46eeeaf99bcfa Jason Wang             2018-07-31  1026  	stats->drops++;
4941d472bf95b4 Jason Wang             2017-07-19  1027  	put_page(page);
bb91accf27335c Jason Wang             2016-12-23  1028  xdp_xmit:
bb91accf27335c Jason Wang             2016-12-23  1029  	return NULL;
f121159d72091f Michael S. Tsirkin     2013-11-28  1030  }
f121159d72091f Michael S. Tsirkin     2013-11-28  1031  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
