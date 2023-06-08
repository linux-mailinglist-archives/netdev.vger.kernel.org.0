Return-Path: <netdev+bounces-9221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B957280C5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:00:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DE5E281700
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57DC112B6A;
	Thu,  8 Jun 2023 13:00:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410B8E560;
	Thu,  8 Jun 2023 13:00:32 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674EE26B2;
	Thu,  8 Jun 2023 06:00:28 -0700 (PDT)
Received: from kwepemm600001.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QcPR46RqBz25h63;
	Thu,  8 Jun 2023 20:58:40 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 21:00:23 +0800
From: zhangmingyi <zhangmingyi5@huawei.com>
To: <sdf@google.com>
CC: <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
	<daniel@iogearbox.net>, <davem@davemloft.net>, <edumazet@google.com>,
	<hsinweih@uci.edu>, <jakub@cloudflare.com>, <john.fastabend@gmail.com>,
	<kongweibin2@huawei.com>, <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
	<liuxin350@huawei.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<syzbot+49f6cef45247ff249498@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>, <wuchangye@huawei.com>,
	<xiesongyang@huawei.com>, <yanan@huawei.com>, <zhangmingyi5@huawei.com>
Subject: Re: [PATCH] libbpf:fix use empty function pointers in ringbuf_poll
Date: Thu, 8 Jun 2023 20:58:20 +0800
Message-ID: <20230608125820.726340-1-zhangmingyi5@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <ZH4a1l1pfG8ewo3v@google.com>
References: <ZH4a1l1pfG8ewo3v@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/06,Stanislav Fomichev wrote:

> On 06/05, Xin Liu wrote:
> > From: zhangmingyi <zhangmingyi5@huawei.com>
> 
> > The sample_cb of the ring_buffer__new interface can transfer NULL. However,
> > the system does not check whether sample_cb is NULL during 
> > ring_buffer__poll, null pointer is used.

> What is the point of calling ring_buffer__new with sample_cb == NULL?

Yes, as you said, passing sample_cb in ring_buffer__new to NULL doesn't 
make sense, and few people use it that way, but that doesn't prevent this 
from being a allowed and supported scenario. And when ring_buffer__poll is 
called, it leads to a segmentation fault (core dump), which I think needs 
to be fixed to ensure the security quality of libbpf.

