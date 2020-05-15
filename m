Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1ABF1D5415
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgEOPSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbgEOPSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:18:18 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AC8C061A0C;
        Fri, 15 May 2020 08:18:17 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id j3so2637310ljg.8;
        Fri, 15 May 2020 08:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=REDpfW4exKlgzKSnLzpuC90VwMVqpl03JyhjEvUP2uk=;
        b=uWmEk+4ZghzYaNyscKmOqzIGQOffXaaHl8rZzweTUXoNAbZJG8hSPjWnjk0LJAaz/m
         lUE4fdT52VRg7GNy0chFybyftyoyGbP1luN2YFEWFOvew8erqXRUqGhOCdA8VJtAu0TU
         fg2AOGdIGV/hkpMBgSU1F6k+kb2teIDcvUEAp7ZokOPO4/wvBYcAktx+wmXN0fL9TW6v
         WepGUrDXsz8A2vsdOQPXea8T2L784Z8cFUkaXNUTUwiU9ZMLyWMYv/kWzsNQ2MO8l+ef
         NkZ5RElKU5RF78RGf/ytLZO7jcVLFAr8M1XPvwMaio/nkY/41A+J0+4iReNETKrPouKI
         uI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=REDpfW4exKlgzKSnLzpuC90VwMVqpl03JyhjEvUP2uk=;
        b=eNLq3T7SYgUWK8Zsrj8yJuMGToxyJHowPB73ULMB7ksLCL/R5dl/7AGThFZ5MgGmA0
         +ehvWYFc9wPWL5z1ZgZvp+AdIK5wxDWdPgyWloN1vR9bEnu5j/fY2JVPuvnR7wWqXyYe
         TrQAOhg91Zq2J1M2DvhvejLruWUDwqJ8YCU+Owi0RVFpx8TZQzidish+ZUGqlYts/6Nx
         IN/rwIDDNcDTHlcJfgJiO63Qj0fsYbAgGlrhAyFz1QL0cBBOWcY95cOU1g5f/JuVMLoX
         +lx1PYflCFxw0N0ZcSaDmPUYToFU29+Qh3MSCpyuwHUURTtpGPTs9m1eI0JfrgVvWk9T
         P0IQ==
X-Gm-Message-State: AOAM533B53/rzgf+5LN3J6rVxcW+iWk0bS8Dd1VMOTJybPXRXkB37h0C
        Qt5gwnXbjMn4y56r8VPUe0gTOaZlr8e4bcqMR1nMLA==
X-Google-Smtp-Source: ABdhPJzjz3NiYaV6v2Yb/B+hqlMdRLP8U+twJCaMQR8NIA+6VK5PmRtJ0RFGF5jhe6FyuYIordLmv4nE0jr0zXTWa+M=
X-Received: by 2002:a2e:9641:: with SMTP id z1mr2417197ljh.215.1589555896095;
 Fri, 15 May 2020 08:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200515101118.6508-1-daniel@iogearbox.net>
In-Reply-To: <20200515101118.6508-1-daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 15 May 2020 08:18:04 -0700
Message-ID: <CAADnVQJn__9kWGfrfApJhnd19KXdOX=UbybUKjtHGX7WfcbvWg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 0/3] Restrict bpf_probe_read{,str}() and
 bpf_trace_printk()'s %s
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 3:11 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Small set of fixes in order to restrict BPF helpers for tracing which are
> broken on archs with overlapping address ranges as per discussion in [0].
> I've targetted this for -bpf tree so they can be routed as fixes. Thanks!
>
> v1 -> v2:
>   - switch to reusable %pks, %pus format specifiers (Yonghong)
>   - fixate %s on kernel_ds probing for archs with overlapping addr space
>
>   [0] https://lore.kernel.org/bpf/CAHk-=wjJKo0GVixYLmqPn-Q22WFu0xHaBSjKEo7e7Yw72y5SPQ@mail.gmail.com/T/

Applied to bpf tree. Thanks
We'll send pr to Dave soon to hopefully get this and other fixes
into 5.7 before Sunday rc.
