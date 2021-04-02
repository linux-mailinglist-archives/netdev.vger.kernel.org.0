Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4686C352608
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 06:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhDBEQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 00:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhDBEQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 00:16:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC56C06178A
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 21:16:36 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v4so3654244wrp.13
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 21:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EF04ZQkeFciI3OPVClfJodus6PK+ab706FdkNzAwhhM=;
        b=YnksgUvTp/aj/gKETPzhozoW5W6T/U14dYMauYuYflKWD8oXsbKHIgk/5UM7FgMBXS
         +BTLAkLs2N7OW+GbQSMqXVZeVVqP3RuO39RaPprBCyTCKfTE3OZu1hT+q59bbwpxI4KV
         vp+HYS6aC3a4n48AgGFXM0pD0faBVwawGv6qZ0sYE6SWO/zhmt+G9RzM7VW40KhH5kog
         hFUAYZ/1uLJkT5oGyKtjgQqsWioshEX565M97SN0U0iYThjmna7XyXPBnH5rzPh9zWye
         0gQvDp+V8v4z+k/99thMEzz+vYpHcNrqBQt7c8a9fUot7/d5O5aqQRoHaFmdTxVxWZth
         a7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EF04ZQkeFciI3OPVClfJodus6PK+ab706FdkNzAwhhM=;
        b=JZo0n8Crq4DGqOptNXCgRDdU0vgejwrALgi9+iwhz4zfdzJ02SY/4M+ek6DbkKIoNv
         neR5ze7ffyPlWN8Fv+MHOlOzs7Fe6PTUJgh+LkzSbUQnxoqnS0TJOKCMHnWlf5qHZlYv
         nepyqfWQN1lLjowqfpTwD09ffySUylqgO0wI4Z41gqfn1hiSGxe+C5on0j+lEkWrgQdX
         Q0Zl2hHRCBROc+wFmomEPUub/9rL5/jfqR3lFRbS3F+wzVriBlrsGwcrApKfyilpEzH9
         QYs5r7DBRSQMdqOr8ieXurokrAXEkQhx1PmH3/0w3Qi5sDWMDH69idSZ2mLC13oFrhFE
         W59Q==
X-Gm-Message-State: AOAM532sq2JFNL5GuEGf5NtprmABUTa0HiyMmjf7ThVsIeXaEIZNVv4i
        yy5PKW66iWa7PNs3pfvDHHO7N60dRBtbp/Al7Tg1mg==
X-Google-Smtp-Source: ABdhPJySKIt34vbErD7KKU1Rn4WmavlZWVD2kvyhosy94dmoSbf5MPEsuKtsD881aut0OM0oi/P2hKLMqfIIe8Im7ZU=
X-Received: by 2002:adf:9544:: with SMTP id 62mr12966999wrs.128.1617336995047;
 Thu, 01 Apr 2021 21:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210401002442.2fe56b88@xhacker> <20210401002724.794b3bc4@xhacker>
In-Reply-To: <20210401002724.794b3bc4@xhacker>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 2 Apr 2021 09:46:24 +0530
Message-ID: <CAAhSdy1qcNBy-o8NAho-bhJY1FOF_DCiQ37XX+FEiBbYqokxhA@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] riscv: kprobes: Implement alloc_insn_page()
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:02 PM Jisheng Zhang
<jszhang3@mail.ustc.edu.cn> wrote:
>
> From: Jisheng Zhang <jszhang@kernel.org>
>
> Allocate PAGE_KERNEL_READ_EXEC(read only, executable) page for kprobes
> insn page. This is to prepare for STRICT_MODULE_RWX.
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kernel/probes/kprobes.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
> index 7e2c78e2ca6b..8c1f7a30aeed 100644
> --- a/arch/riscv/kernel/probes/kprobes.c
> +++ b/arch/riscv/kernel/probes/kprobes.c
> @@ -84,6 +84,14 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>         return 0;
>  }
>
> +void *alloc_insn_page(void)
> +{
> +       return  __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START, VMALLOC_END,
> +                                    GFP_KERNEL, PAGE_KERNEL_READ_EXEC,
> +                                    VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
> +                                    __builtin_return_address(0));
> +}
> +
>  /* install breakpoint in text */
>  void __kprobes arch_arm_kprobe(struct kprobe *p)
>  {
> --
> 2.31.0
>
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
