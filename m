Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347E84970B5
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 10:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiAWJUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 04:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiAWJUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 04:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BD3C06173B;
        Sun, 23 Jan 2022 01:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21ACE60921;
        Sun, 23 Jan 2022 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B53C340E2;
        Sun, 23 Jan 2022 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642929618;
        bh=Dj6LQFC0Rt8FZEOhmYI8OL38h0K/bUpUPb0UB+tnZ04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ddr8J3QFItYLfJ90lbG74ECaXAThq37UnIESGdmin4cpD9hObbT2Cgnl6QXBZu0wZ
         7X8ny859qZekzDnAR+PZFii/Dc2plkluME3Iojpn1I8lXW+DD/X4UEmXSuVM/c6ipW
         fg9cjBd5mHlYdPMm5TgLfx3+CBC9gXnmg/W5WQFmWOUvSWqmjsjHn2lb8UTOo6wC5G
         5sbrvSdT0tW9/pXelP1ff15Vucl4z/A05TNtsTnwuLykCh6X6uqbx5U03GaRo3Fco0
         Ym4jHSzh6PdZDqQMGifzu/ucMrwGXPHo45QnR3yJgCHcMGc2+ExHNR6i7anFhFBObl
         Lq8VP3PWdxmWQ==
Date:   Sun, 23 Jan 2022 17:12:40 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Mayuresh Chitale <mchitale@ventanamicro.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 11/12] riscv: extable: add a dedicated uaccess handler
Message-ID: <Ye0cCI8aAC8rL1IE@xhacker>
References: <20211118192130.48b8f04c@xhacker>
 <20211118192651.605d0c80@xhacker>
 <CAN37VV6vfee+T18UkbDLe1ts87+Zvg25oQR1+VJD3e6SJFPPiA@mail.gmail.com>
 <YeqkIKUsdHH0ORxf@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YeqkIKUsdHH0ORxf@xhacker>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 08:16:51PM +0800, Jisheng Zhang wrote:
> On Thu, Jan 20, 2022 at 11:45:34PM +0530, Mayuresh Chitale wrote:
> > Hello Jisheng,
> 
> Hi,
> 
> > 
> > Just wanted to inform you that this patch breaks the writev02 test
> > case in LTP and if it is reverted then the test passes. If we run the
> > test through strace then we see that the test hangs and following is
> > the last line printed by strace:
> > 
> > "writev(3, [{iov_base=0x7fff848a6000, iov_len=8192}, {iov_base=NULL,
> > iov_len=0}]"
> > 
> 
> Thanks for the bug report. I will try to fix it.

Hi Mayuresh,

I just sent out a fix for this bug. Per my test, the issue is fixed.
Could you please try?

Thanks
