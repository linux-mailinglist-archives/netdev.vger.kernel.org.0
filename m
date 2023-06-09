Return-Path: <netdev+bounces-9482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D127295F3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A88E281732
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6ECB1428D;
	Fri,  9 Jun 2023 09:54:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF73F125A9;
	Fri,  9 Jun 2023 09:54:14 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D4A4222;
	Fri,  9 Jun 2023 02:54:11 -0700 (PDT)
Received: from kwepemm600001.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qcwt85HNDzLqP3;
	Fri,  9 Jun 2023 17:35:28 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 17:38:30 +0800
From: zhangmingyi <zhangmingyi5@huawei.com>
To: <andrii.nakryiko@gmail.com>
CC: <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
	<daniel@iogearbox.net>, <davem@davemloft.net>, <edumazet@google.com>,
	<hsinweih@uci.edu>, <jakub@cloudflare.com>, <john.fastabend@gmail.com>,
	<kongweibin2@huawei.com>, <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
	<liuxin350@huawei.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<sdf@google.com>, <syzbot+49f6cef45247ff249498@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>, <wuchangye@huawei.com>,
	<xiesongyang@huawei.com>, <yanan@huawei.com>, <zhangmingyi5@huawei.com>
Subject: Re: [PATCH] libbpf:fix use empty function pointers in ringbuf_poll
Date: Fri, 9 Jun 2023 17:36:25 +0800
Message-ID: <20230609093625.727490-1-zhangmingyi5@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <CAEf4Bzb2_THiWkqNRnbN5LsOif6+9=GY7LrtEbQf6o24cihhMQ@mail.gmail.com>
References: <CAEf4Bzb2_THiWkqNRnbN5LsOif6+9=GY7LrtEbQf6o24cihhMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 1:39 AM Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
 
> On Thu, Jun 8, 2023 at 9:27 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Thu, Jun 8, 2023 at 6:00 AM zhangmingyi <zhangmingyi5@huawei.com> wrote:
> > >
> > > On 06/06,Stanislav Fomichev wrote:
> > >
> > > > On 06/05, Xin Liu wrote:
> > > > > From: zhangmingyi <zhangmingyi5@huawei.com>
> > > >
> > > > > The sample_cb of the ring_buffer__new interface can transfer NULL. However,
> > > > > the system does not check whether sample_cb is NULL during
> > > > > ring_buffer__poll, null pointer is used.
> > >
> > > > What is the point of calling ring_buffer__new with sample_cb == NULL?
> > >
> > > Yes, as you said, passing sample_cb in ring_buffer__new to NULL doesn't
> > > make sense, and few people use it that way, but that doesn't prevent this
> > > from being a allowed and supported scenario. And when ring_buffer__poll is
> > > called, it leads to a segmentation fault (core dump), which I think needs
> > > to be fixed to ensure the security quality of libbpf.
> >
> > I dunno. I'd argue that passing a NULL to ring_buffer__new is an API
> > misuse. Maybe ring_buffer__new should return -EINVAL instead when
> > passed NULL sample_cb? Although, we don't usually have those checks
> > for the majority of the arguments in libbpf...
> 
> Right. I'd say we should add a proper doc comment specifying all
> arguments and which ones are optional or not. And make it explicit
> that callback is not optional. If we start checking every possible
> pointer for NULL, libbpf will be littered with NULL checks, I'm not
> sure that's good.

I agree, we should add a proper doc comment specifying all
arguments and which ones are optional or not.
However, why does the external interface API in libbpf not verify input 
parameters or add verification where risky operations may exist? 
What's more, i think sample_cb=NULL is not strictly a mistake or 
prohibited use, and is meaningless.

