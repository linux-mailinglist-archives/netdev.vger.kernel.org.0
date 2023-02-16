Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB94D698E9C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjBPIXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBPIXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:23:40 -0500
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016353C25;
        Thu, 16 Feb 2023 00:23:38 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VbnsmYu_1676535815;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VbnsmYu_1676535815)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 16:23:36 +0800
Message-ID: <1676535726.8031962-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v3] xsk: support use vaddr as ring
Date:   Thu, 16 Feb 2023 16:22:06 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230214015112.12094-1-xuanzhuo@linux.alibaba.com>
 <3cfe3c9b-1c8c-363c-6dcb-343cabc2f369@intel.com>
 <1676425701.9314106-1-xuanzhuo@linux.alibaba.com>
 <d42b574b-d546-1557-a61b-b183df84a991@intel.com>
In-Reply-To: <d42b574b-d546-1557-a61b-b183df84a991@intel.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Feb 2023 17:50:54 +0100, Alexander Lobakin <aleksander.lobakin@intel.com> wrote:
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date: Wed, 15 Feb 2023 09:48:21 +0800
>
> > On Tue, 14 Feb 2023 15:45:12 +0100, Alexander Lobakin <alexandr.lobakin@intel.com> wrote:
> >> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >> Date: Tue, 14 Feb 2023 09:51:12 +0800
> >>
> >>> When we try to start AF_XDP on some machines with long running time, due
> >>> to the machine's memory fragmentation problem, there is no sufficient
> >>> contiguous physical memory that will cause the start failure.
> >>
> >> [...]
> >>
> >>> @@ -1319,13 +1317,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
> >>>
> >>>  	/* Matches the smp_wmb() in xsk_init_queue */
> >>>  	smp_rmb();
> >>> -	qpg = virt_to_head_page(q->ring);
> >>> -	if (size > page_size(qpg))
> >>> +	if (size > PAGE_ALIGN(q->ring_size))
> >>
> >> You can set q->ring_size as PAGE_ALIGN(size) already at the allocation
> >> to simplify this. I don't see any other places where you use it.
> >
> > That's it, but I think it is not particularly appropriate to change the
> > the semantics of ring_size just for simplify this code. This may make
> > people feel strange.
>
> You can name it 'vmalloc_size' then. By "ring_size" I first of all
> assume the number of elements, not the allocation size.


Maybe "ring_vmalloc_size"

>
> Also, wait, shouldn't you do this PAGE_ALIGN() *before* you actually
> vmalloc() it? Can't here be out-of-bounds with the current approach?


vmalloc_user() will do PAGE_ALIGN().

Thanks.


>
> >
> > I agree with you other opinions.
> >
> > Thanks.
>
> Thanks,
> Olek
