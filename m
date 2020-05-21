Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974B81DD9FE
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgEUWK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbgEUWKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 18:10:55 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E23C061A0E;
        Thu, 21 May 2020 15:10:54 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f13so8944784qkh.2;
        Thu, 21 May 2020 15:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=isMsZ2pUMyCVKxa9Y2mlyk5l3TCYNg/xt93/ki7P2xM=;
        b=rvtv2nZMjsCYj/CeRcxqSRzJYCvoWBWeEm/72+lnNyxa+Vdy9NkfFeD8cpeGY76yDk
         wfvMzNxbucIn7Hs+oWyf05qo9fHMcUsteanx5aU0XArHtMRRXJLuU721EUNgAES4ID8L
         4BK22OGZzPIFuxQJNAXNMRKzin+VQSx6P4f7rTt5QxVcnbVdnbKLOB4xWP/9BUtlDCzG
         wxQKxlWDremxmA6nHO7Dnyr4bSR0bzQXoj8MWM7oqmmacFdDmArrPOzkdO2ojiT2NeXZ
         3rF1QgvrXugmu2458C0loC8GmxZvMhABO4SKgIQSvB76sfSoth+Bvjqp6Btx4FaWlhSq
         MSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=isMsZ2pUMyCVKxa9Y2mlyk5l3TCYNg/xt93/ki7P2xM=;
        b=FBptfPGUWDhzI8w9NoAiGfqiiSfE6M7fJjPj/rxL+umLgLcWDDiyVs8/v9wGhNbVAJ
         R4GqelqZxq5SWSEFWhPsasveFwsHtmZ7BzBWuWIRRfUO6x0HdNfTp6HmgT4zCep/9YDo
         HYtqGgcYqXICe4/Fgili/0M3FhyoSwMzFG3kmTXraDOtp/BFLBWsv+XYqN7P0jBITp38
         1+6EsvEnhY9yJPYvpdXCbib0Q5knjbBE9gXX3QFWZJwx/m+yvy+f7jaem3GoImzYeLQq
         39P4Ysmk/XeYJJr2vOC163tKIf7Yphy4VvCm+Kcsu0OQtjJp/u1SlsHYkA6do39+5iwk
         gYXA==
X-Gm-Message-State: AOAM5324Oa27ravLh38tLiNdQMW1y5JxC8tVAi1JDLDw94HSp4AUxS49
        2f1GkdaVcSxMLParkw2Jfhu4fZ8AkcJQfVXyAc0=
X-Google-Smtp-Source: ABdhPJyXmTlK01x/mLueG4iMCV7LUGdCvFmE02/3ZxSTylcerxvuwFpzisGXHtk+V9iTqf6OpLYFCd1cU/qrM9V446Y=
X-Received: by 2002:ae9:e713:: with SMTP id m19mr12160235qka.39.1590099053692;
 Thu, 21 May 2020 15:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200521152301.2587579-1-hch@lst.de> <20200521152301.2587579-14-hch@lst.de>
In-Reply-To: <20200521152301.2587579-14-hch@lst.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 15:10:42 -0700
Message-ID: <CAEf4BzZCp3w9YB0Hg1yyfXFTTCv_Kvi2Xc5RXm7DU2kgm31EUg@mail.gmail.com>
Subject: Re: [PATCH 13/23] bpf: rework the compat kernel probe handling
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-mm@kvack.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 8:26 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Instead of using the dangerous probe_kernel_read and strncpy_from_unsafe
> helpers, rework the compat probes to check if an address is a kernel or
> userspace one, and then use the low-level kernel or user probe helper
> shared by the proper kernel and user probe helpers.  This slightly
> changes behavior as the compat probe on a user address doesn't check
> the lockdown flags, just as the pure user probes do.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good, thanks.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/trace/bpf_trace.c | 109 ++++++++++++++++++++++++---------------
>  1 file changed, 67 insertions(+), 42 deletions(-)
>

[...]
