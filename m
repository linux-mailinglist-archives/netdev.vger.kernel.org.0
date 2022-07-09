Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E51656C787
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 08:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGIGZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 02:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGIGZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 02:25:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BAF57E34;
        Fri,  8 Jul 2022 23:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5zqC6/B7/e8C07wEoM+B0njfXe1wcbKaBp+7TWzkiPo=; b=jvfBEMbtcA8GtVYtjjieBTSOsO
        X3qdQ5a0YIrbfGjpFX8SZhvtjue42BpWlSStPR+Nj/uk+5CvUEn1052Z5BRqFJJ3+eG/Q44DagP61
        rTwCZgOVcwWRLiDFmZP4pEIvmRBuV9gan516Nh0p+is5WWYNaM3SSBRMEY0SLlwZCotYUZt6OdpCx
        Bp1auOjQVJvqiiEOGnKp2kbB/asmCLC+UsDHQgijuZk6B7sao0Dex2dEfO5dUZGr1Xn+sd0sbZS3c
        92EqiWblob+HZftOx/WY5V05HJsBEJE9Mrpm3I45k5FURrfS2r+gWbsfyohRtgL0C95GJ+flc04WH
        GePRj6Bw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oA3tu-0078te-IK; Sat, 09 Jul 2022 06:25:10 +0000
Date:   Fri, 8 Jul 2022 23:25:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alan Maguire <alan.maguire@oracle.com>,
        Yixun Lan <dlan@gentoo.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Message-ID: <YskfRqDqmNhGcuVF@infradead.org>
References: <20220703130924.57240-1-dlan@gentoo.org>
 <YsKAZUJRo5cjtZ3n@infradead.org>
 <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
 <YsUy8jBpt11zoc5E@infradead.org>
 <CAEf4BzZrvOyYxmJpw=azZ59adeEqnHYqnUXKQProyUKBP5NaUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZrvOyYxmJpw=azZ59adeEqnHYqnUXKQProyUKBP5NaUA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 03:22:51PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 6, 2022 at 12:00 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Tue, Jul 05, 2022 at 10:00:42PM -0700, Andrii Nakryiko wrote:
> > > riscv existed as of [0], so I'd argue it is a proper bug fix, as
> > > corresponding select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should
> > > have been added back then.
> >
> > How much of an eBPF ecosystem was there on RISC-V at the point?
> 
> No idea, never used RISC-V and didn't pay much attention. But why does
> it matter?

It matters because we should not spread broken legacy interfaces.
