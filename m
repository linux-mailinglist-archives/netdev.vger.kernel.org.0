Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8833A46AC
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFKQnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:43:31 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47279 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhFKQn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:43:26 -0400
X-Greylist: delayed 9071 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2021 12:43:25 EDT
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4G1mnW3mnLz1s3pb;
        Fri, 11 Jun 2021 18:41:19 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4G1mnV6lD7z1r0wv;
        Fri, 11 Jun 2021 18:41:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id DNOF1t6SXpEc; Fri, 11 Jun 2021 18:41:17 +0200 (CEST)
X-Auth-Info: UjAl/qSEJiAcUzh+KfzDTVzON+wrDx36PXw07BKvqDwzz+F6woY6oRGDBmF8tT9C
Received: from igel.home (ppp-46-244-189-84.dynamic.mnet-online.de [46.244.189.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 11 Jun 2021 18:41:17 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
        id C31282C3655; Fri, 11 Jun 2021 18:41:16 +0200 (CEST)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 7/9] riscv: bpf: Avoid breaking W^X
References: <20210330022144.150edc6e@xhacker>
        <20210330022521.2a904a8c@xhacker> <87o8ccqypw.fsf@igel.home>
        <20210612002334.6af72545@xhacker>
X-Yow:  I will SHAVE and buy JELL-O and bring my MARRIAGE MANUAL!!
Date:   Fri, 11 Jun 2021 18:41:16 +0200
In-Reply-To: <20210612002334.6af72545@xhacker> (Jisheng Zhang's message of
        "Sat, 12 Jun 2021 00:23:34 +0800")
Message-ID: <87bl8cqrpv.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jun 12 2021, Jisheng Zhang wrote:

> I reproduced an kernel panic with the defconfig on qemu, but I'm not sure whether
> this is the issue you saw, I will check.
>
>     0.161959] futex hash table entries: 512 (order: 3, 32768 bytes, linear)
> [    0.167028] pinctrl core: initialized pinctrl subsystem
> [    0.190727] Unable to handle kernel paging request at virtual address ffffffff81651bd8
> [    0.191361] Oops [#1]
> [    0.191509] Modules linked in:
> [    0.191814] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5-default+ #3
> [    0.192179] Hardware name: riscv-virtio,qemu (DT)
> [    0.192492] epc : __memset+0xc4/0xfc
> [    0.192712]  ra : skb_flow_dissector_init+0x22/0x86

Yes, that's the same.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
