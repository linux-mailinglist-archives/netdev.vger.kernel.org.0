Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7124856D397
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 05:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGKD6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 23:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKD6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 23:58:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C24ACFE;
        Sun, 10 Jul 2022 20:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UI65JIxER2tdKqXX5LgQnx9rno5hEDFoEXbwkKGLcHY=; b=hpKH2kp8JCl9vOIpuuK4KJbi8C
        wH87kj29tzhnOJPZstNcwSDnYNphWdbRNeC6q6aK9wQUCoKk7eZ7Yic+AtFlppVyVQv151sSmIkRf
        dylieWAGpxwAOgkxfaLtE8CCRNxzSvYQFV/tmuxN1gxR/cZ6vWssEG1CbyZOduDxn0K80ITf/YRzv
        Qx4H7oJe07brUh5RHBPfPLdtjtAc8WT7BmX40bA+Au+E87Xibp6h+drk8L2Rgr7rvQCtWZ7w3iH1R
        urCexhWHnOKg7HHIaniJwieV6VeQ+Adjy+JX1HWPZdCuISjr3ZyLNJ1w3iOC0jVqAO2u6O5VUe0ZW
        rheRZhCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAkYr-00Flmi-Tu; Mon, 11 Jul 2022 03:58:17 +0000
Date:   Sun, 10 Jul 2022 20:58:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yixun Lan <dlan@gentoo.org>
Cc:     Christoph Hellwig <hch@infradead.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
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
Message-ID: <Ysuf2ZiZ5RSFnQOD@infradead.org>
References: <20220703130924.57240-1-dlan@gentoo.org>
 <YsKAZUJRo5cjtZ3n@infradead.org>
 <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
 <712c8fac-6784-2acd-66ca-d1fd393aef23@fb.com>
 <YsUzX2IeNb/u9VmN@infradead.org>
 <YsjTVvyqdVGy1uYZ@ofant>
 <YskfMTdnd+IyzCQ0@infradead.org>
 <YslAxaryvm/MfGbq@ofant>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YslAxaryvm/MfGbq@ofant>
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

On Sat, Jul 09, 2022 at 04:48:05PM +0800, Yixun Lan wrote:
> never mind, I think the logic is quite clear, we can do something in bcc:
> 
> 1) adopt new _{kernel,user} interface whenever possible, this will
> work fine for all arch with new kernel versions
> 
> 2) for old kernel versions which lack the _{kernel,user} support,
> fall back to old bpf_probe_read(), but take care of the Archs which
> have overlaping address space - like s390, and just error out for it

Yes, that is the right thing to do.
