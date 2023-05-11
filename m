Return-Path: <netdev+bounces-1623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D45816FE916
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A1892815C1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C6862A;
	Thu, 11 May 2023 01:14:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795F4620;
	Thu, 11 May 2023 01:14:47 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FF5E70;
	Wed, 10 May 2023 18:14:45 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QGv4S3XMqzLpmy;
	Thu, 11 May 2023 09:11:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 09:14:42 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, <bpf@vger.kernel.org>
Subject: [PATCH net-next v2 0/2] introduce skb_frag_fill_page_desc()
Date: Thu, 11 May 2023 09:12:11 +0800
Message-ID: <20230511011213.59091-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Most users use __skb_frag_set_page()/skb_frag_off_set()/
skb_frag_size_set() to fill the page desc for a skb frag.
It does not make much sense to calling __skb_frag_set_page()
without calling skb_frag_off_set(), as the offset may depend
on whether the page is head page or tail page, so add
skb_frag_fill_page_desc() to fill the page desc for a skb
frag.

In the future, we can make sure the page in the frag is
head page of compound page or a base page, if not, we
may warn about that and convert the tail page to head
page and update the offset accordingly, if we see a warning
about that, we also fix the caller to fill the head page
in the frag. when the fixing is done, we may remove the
warning and converting.

In this way, we can remove the compound_head() or use
page_ref_*() like the below case:
https://elixir.bootlin.com/linux/latest/source/net/core/page_pool.c#L881
https://elixir.bootlin.com/linux/latest/source/include/linux/skbuff.h#L3383

It may also convert net stack to use the folio easier.

V1: repost with all the ack/review tags included.
RFC: remove a local variable as pointed out by Simon.


Yunsheng Lin (2):
  net: introduce and use skb_frag_fill_page_desc()
  net: remove __skb_frag_set_page()

 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  6 +--
 drivers/net/ethernet/broadcom/bnx2.c          |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 10 ++---
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  5 +--
 drivers/net/ethernet/emulex/benet/be_main.c   | 32 ++++++++-------
 drivers/net/ethernet/freescale/enetc/enetc.c  |  5 +--
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  5 +--
 drivers/net/ethernet/marvell/mvneta.c         |  5 +--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  4 +-
 drivers/net/ethernet/sun/cassini.c            |  8 +---
 drivers/net/virtio_net.c                      |  4 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 +-
 drivers/net/xen-netback/netback.c             |  4 +-
 include/linux/skbuff.h                        | 39 +++++--------------
 net/bpf/test_run.c                            |  3 +-
 net/core/gro.c                                |  4 +-
 net/core/pktgen.c                             | 13 ++++---
 net/core/skbuff.c                             |  7 ++--
 net/tls/tls_device.c                          | 10 ++---
 net/xfrm/xfrm_ipcomp.c                        |  5 +--
 20 files changed, 65 insertions(+), 109 deletions(-)

-- 
2.33.0


