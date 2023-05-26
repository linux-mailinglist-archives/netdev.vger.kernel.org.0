Return-Path: <netdev+bounces-5598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BFA2712394
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8C8F1C211A8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6E5111A9;
	Fri, 26 May 2023 09:28:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196C5AD48;
	Fri, 26 May 2023 09:28:27 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02819194;
	Fri, 26 May 2023 02:28:17 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QSKH33ftzzqTPD;
	Fri, 26 May 2023 17:23:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 17:28:15 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>, <bpf@vger.kernel.org>
Subject: [PATCH net-next 0/2] support non-frag page for page_pool_alloc_frag()
Date: Fri, 26 May 2023 17:26:13 +0800
Message-ID: <20230526092616.40355-1-linyunsheng@huawei.com>
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
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In [1], there is a use case to use frag support in page
pool to reduce memory usage, and it may request different
frag size depending on the head/tail room space for
xdp_frame/shinfo and mtu/packet size. When the requested
frag size is large enough that a single page can not be
split into more than one frag, using frag support only
have performance penalty because of the extra frag count
handling for frag support.

So this patchset provides a way for user to fail back to
non-frag page when a page is not able to hold two frags.

PP_FLAG_PAGE_FRAG may be removed after this patchset, and
the extra benefit is that driver does not need to handle
the case for arch with PAGE_POOL_DMA_USE_PP_FRAG_COUNT when
using page_pool_alloc_frag() API.

1. https://patchwork.kernel.org/project/netdevbpf/patch/d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org/

V1: Drop RFC tag and page_pool_frag patch

Yunsheng Lin (2):
  page_pool: unify frag page and non-frag page handling
  page_pool: support non-frag page for page_pool_alloc_frag()

 include/net/page_pool.h | 38 ++++++++++++++++++++++++++------
 net/core/page_pool.c    | 48 +++++++++++++++++++++++++----------------
 2 files changed, 61 insertions(+), 25 deletions(-)

-- 
2.33.0


