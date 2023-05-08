Return-Path: <netdev+bounces-852-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9FB16FB053
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 659B6280EFB
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13D4360;
	Mon,  8 May 2023 12:41:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D91361;
	Mon,  8 May 2023 12:41:19 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7C438F0F;
	Mon,  8 May 2023 05:41:04 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QFLSw0tyHzsRLP;
	Mon,  8 May 2023 20:39:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 20:41:02 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <netdev@vger.kernel.org>
CC: <linux-rdma@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<xen-devel@lists.xenproject.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <alexanderduyck@fb.com>,
	<jbrouer@redhat.com>, <ilias.apalodimas@linaro.org>
Subject: [PATCH RFC 0/2] introduce skb_frag_fill_page_desc()
Date: Mon, 8 May 2023 20:39:20 +0800
Message-ID: <20230508123922.39284-1-linyunsheng@huawei.com>
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
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

It may also convert stack to use the folio easier.


Yunsheng Lin (2):
  net: introduce and use skb_frag_fill_page_desc()
  net: remove __skb_frag_set_page()

 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  6 +--
 drivers/net/ethernet/broadcom/bnx2.c          |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +--
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  5 +--
 drivers/net/ethernet/emulex/benet/be_main.c   | 30 +++++++-------
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
 20 files changed, 62 insertions(+), 106 deletions(-)

-- 
2.33.0


