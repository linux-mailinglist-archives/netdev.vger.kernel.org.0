Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450ED34A08F
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 05:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhCZEcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 00:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhCZEbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 00:31:50 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F22AC06174A;
        Thu, 25 Mar 2021 21:31:50 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id l15so4669574ybm.0;
        Thu, 25 Mar 2021 21:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=77bXvTG175JM/Chg4+Z7haekme4dDDgGkrHlXjwMUaU=;
        b=rXLd55v46YAtZKnc+qt2xGhvcTJFNUUZwn07PU+iPPXwylGf0N/NTW0MZFIi22N/fu
         JUrMIa9CEOi2rMvOFxTZ6X7pBX2psCZKSO8VF56sxjdq0MWscVHkQHSeVdIrqCO5caSX
         yYhnJkCmOWjJYhRGaqOAv/pypGxuLXcgj0/AQANVZiAr9Jl/GVDoBd8u18xKMW90fCiI
         X2HBZQ6IErBMia4y/LHSPvf2o4z4BxIyJibTeVlhsbks+ZPMMcAIhziFaVjtBRBkg1UP
         NA1dDyxEo7E31c/Z5ScpUDCOjOoE7Lpd9wQp0fwy/vADjCIf5tFznInQcwimL4sWiXa1
         0cCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=77bXvTG175JM/Chg4+Z7haekme4dDDgGkrHlXjwMUaU=;
        b=nJ4Xbx0sb8aC1IhWtbZpL+FR+b9ydGaiWqFVswwpLwgti0TBGK2kPnw6DQOzWaU2IF
         Fv8hwpcxPdbhr1IJLwD7U6Lc/LCLltXYI1fekCbh/atIR/7eCLyfmCl4iVmMCswiIqIh
         w1uPL6u6/9eNGfTMyPfA8Z+8SMXsXGkGepX8Pm8dzWBNQ/LSvLCbkoqLEuCs/L1Xr8EF
         ZWkR+dgBRmmYjb0yJmEuMO7WOEDLinuTBGgfWRs7+b9qfhll58UZSDUoGhd2IPDJOJrn
         is8UoVgxowC0Kf7/bMhrqTPNMmL8iJ5rkwPmkJjDPuG9H5cy6zu4YlGkLRf+KkUKPP4z
         GI1Q==
X-Gm-Message-State: AOAM531ysiPnFf/5o14RHoEsOP9KUrcLglVodSb/CRrR/yOIAcKPMXkG
        Xb5LMBc5S5kz9etCTS80A2w4VXq+/Licp4cQXKyj9DSNUrg=
X-Google-Smtp-Source: ABdhPJx0gpfc3Q4cIbZdzJSLjyFgFwqS2iU7/bNMbKTzi6+pdRxHy9XrVvg/k4h2K3kYHcskJPm3rmFBt+HU75QFIkk=
X-Received: by 2002:a25:ab03:: with SMTP id u3mr10683103ybi.347.1616733109956;
 Thu, 25 Mar 2021 21:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210325150115.138750-1-pctammela@mojatatu.com>
In-Reply-To: <20210325150115.138750-1-pctammela@mojatatu.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Mar 2021 21:31:39 -0700
Message-ID: <CAEf4Bzby2eo3-s86rgEjOESrQdemBjYsfLCv=WPh0UHTOZQ7Tw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix bail out from 'ringbuf_process_ring()'
 on error
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 8:02 AM Pedro Tammela <pctammela@gmail.com> wrote:
>
> The current code bails out with negative and positive returns.
> If the callback returns a positive return code, 'ring_buffer__consume()'
> and 'ring_buffer__poll()' will return a spurious number of records
> consumed, but mostly important will continue the processing loop.
>
> This patch makes positive returns from the callback a no-op.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  tools/lib/bpf/ringbuf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks. Applied to bpf tree and added:

Fixes: bf99c936f947 ("libbpf: Add BPF ring buffer support")


> diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
> index 8caaafe7e312..e7a8d847161f 100644
> --- a/tools/lib/bpf/ringbuf.c
> +++ b/tools/lib/bpf/ringbuf.c
> @@ -227,7 +227,7 @@ static int ringbuf_process_ring(struct ring* r)
>                         if ((len & BPF_RINGBUF_DISCARD_BIT) == 0) {
>                                 sample = (void *)len_ptr + BPF_RINGBUF_HDR_SZ;
>                                 err = r->sample_cb(r->ctx, sample, len);
> -                               if (err) {
> +                               if (err < 0) {
>                                         /* update consumer pos and bail out */
>                                         smp_store_release(r->consumer_pos,
>                                                           cons_pos);
> --
> 2.25.1
>
