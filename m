Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B7F567F38
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiGFHCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiGFHCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:02:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D324D1F2C2;
        Wed,  6 Jul 2022 00:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/1B8eXbzsym5vD7WEQKQVJKQdxQ5KaDuSszuUOxu30E=; b=JgY9CaH1XkdAyfaKVa3yL6lLfO
        mnczioUxVHk8S1zjflPUMY/wMV3QKFfGH932P1TfDHvdnzQhwU0TRhaxIUak8DEdZxNbywyw3A1zJ
        0/COwpX7kwcB4Xfl5AOfCDfM8aI04sIYA0YpChI8HHpypd7Kfgsz+++mqdIK+rF2Ewrlq+JoArbFO
        yDk+vyJcsverWoWn7oQRIF59fM6/wbhSIfe8p20psQwrxD4RPCMwZ0JA8Tz0yPC5f6qBLIo7BWLSl
        ZVr55GCwpcULf02yMZPrsQNColwrTmnb9HnXf9zMQ+RW0WhWG20Uaw1QwY+nSYGZtPAVuoQCN0wyy
        CA+mmU9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z2l-006uK0-Ir; Wed, 06 Jul 2022 07:01:51 +0000
Date:   Wed, 6 Jul 2022 00:01:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
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
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Message-ID: <YsUzX2IeNb/u9VmN@infradead.org>
References: <20220703130924.57240-1-dlan@gentoo.org>
 <YsKAZUJRo5cjtZ3n@infradead.org>
 <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
 <712c8fac-6784-2acd-66ca-d1fd393aef23@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <712c8fac-6784-2acd-66ca-d1fd393aef23@fb.com>
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

On Tue, Jul 05, 2022 at 11:41:30PM -0700, Yonghong Song wrote:
> 
> 
> On 7/5/22 10:00 PM, Andrii Nakryiko wrote:
> > On Sun, Jul 3, 2022 at 10:53 PM Christoph Hellwig <hch@infradead.org> wrote:
> > > 
> > > On Sun, Jul 03, 2022 at 09:09:24PM +0800, Yixun Lan wrote:
> > > > Enable this option to fix a bcc error in RISC-V platform
> > > > 
> > > > And, the error shows as follows:
> > > 
> > > These should not be enabled on new platforms.  Use the proper helpers
> > > to probe kernel vs user pointers instead.
> > 
> > riscv existed as of [0], so I'd argue it is a proper bug fix, as
> > corresponding select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should
> > have been added back then.
> > 
> > But I also agree that BCC tools should be updated to use proper
> > bpf_probe_read_{kernel,user}[_str()] helpers, please contribute such
> > fixes to BCC tools and BCC itself as well. Cc'ed Alan as his ksnoop in
> > libbpf-tools seems to be using bpf_probe_read() as well and needs to
> > be fixed.
> 
> Yixun, the bcc change looks like below:

No, this is broken.  bcc needs to stop using bpf_probe_read entirely
for user addresses and unconditionally use bpf_probe_read_user first
and only fall back to bpf_probe_read if not supported.
