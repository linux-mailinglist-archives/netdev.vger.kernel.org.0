Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1429C8B5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbfHZFhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:37:02 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41977 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfHZFhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:37:02 -0400
Received: by mail-qk1-f193.google.com with SMTP id g17so13139296qkk.8;
        Sun, 25 Aug 2019 22:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HXFMCXkCtgEG+phWKWnvagB67xULZR7CQP4q4jOM2lg=;
        b=aq403RUvXVjuLSvz2zD1kizG72TAxSRezq5Y+xhceIuN/bwQk2tUiBUw7ZiZWcgCxU
         BTkqE1g8czsGJ7Wjxfg8f/mpfEyMYduJV4w/0xZxdK8w2Ec66W63UX5yTsE/jPvIkISf
         j1nuqGSkXoa9q9ytX+0ZN1Ty3eSD6tGwvwK1GwyBg7oOar+B/PYf2mHOwWXvSdJ04Y3x
         GvBvkDGVDgqFH3Ma4Kt55dnD1qdIpCW0RPSXxhORlT+OGCTz4HjIFqzGsmGSg14f2xA4
         f1rJMK8IfM+WGsNFRTj6yvwQbh6MxtHHR2oRwXvOYh/mjBqDtuVJ21NQA3Y/cna6S+PX
         j+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HXFMCXkCtgEG+phWKWnvagB67xULZR7CQP4q4jOM2lg=;
        b=KiTEGtdqFuBQ3zewXWqxbRoweaMYTHbLvSlFB7D15Uef3VjO7B+3nAfj3We9WTVQo7
         WebzZFK+xAbxga5zSoKmawAuYZa/xQ6os7T3sAU750G+llubrbkppexaG1D4KQcQ8xMA
         4gT1nvw4rIXsNdUVMiU7A4RxHhfcwYqcH00v28/ereRT5FgxxYl+aJqszfEnZbSkSVlu
         b5aYz/8ZrZdOXHal3gPk4OO0CpuTO5elCvUoSXnaIiToGMMobS3F9e0B88dZuz10xbQM
         xqOKSlMSwkEvZyotLlHzYccIV5zjooyvlCOCGpRRiWrQpQnfyzf5kXNtFQ8vgwdQ2nrF
         NP/Q==
X-Gm-Message-State: APjAAAVilkViJ+7DypaAllTi470oNxeB3EU9RbXx3UNQDLrMuJtuC6gd
        uisrQT9N0BwU+jUDfF3l7Yeqb1tTYPg340gYvx8=
X-Google-Smtp-Source: APXvYqx/G6lkczbgxRbBrMfO1lTyeZ8rYfNgMb4Goyvp+DE8ofSpIn/ML1AxRs4KH9j8OpYdQvtoKsTTtn0m8C6r4YA=
X-Received: by 2002:ae9:e714:: with SMTP id m20mr14346568qka.72.1566797821536;
 Sun, 25 Aug 2019 22:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190824020028.6242-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190824020028.6242-1-jakub.kicinski@netronome.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sun, 25 Aug 2019 22:36:50 -0700
Message-ID: <CAPhsuW7_dSEPJOdKApQFU-aVmEXgOwmqLS7S1FC4JtnzjR6OiQ@mail.gmail.com>
Subject: Re: [PATCH bpf] nfp: bpf: fix latency bug when updating stack index register
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 7:04 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> From: Jiong Wang <jiong.wang@netronome.com>
>
> NFP is using Local Memory to model stack. LM_addr could be used as base of
> a 16 32-bit word region of Local Memory. Then, if the stack offset is
> beyond the current region, the local index needs to be updated. The update
> needs at least three cycles to take effect, therefore the sequence normally
> looks like:
>
>   local_csr_wr[ActLMAddr3, gprB_5]
>   nop
>   nop
>   nop
>
> If the local index switch happens on a narrow loads, then the instruction
> preparing value to zero high 32-bit of the destination register could be
> counted as one cycle, the sequence then could be something like:
>
>   local_csr_wr[ActLMAddr3, gprB_5]
>   nop
>   nop
>   immed[gprB_5, 0]
>
> However, we have zero extension optimization that zeroing high 32-bit could
> be eliminated, therefore above IMMED insn won't be available for which case
> the first sequence needs to be generated.
>
> Fixes: 0b4de1ff19bf ("nfp: bpf: eliminate zero extension code-gen")
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
I haven't looked into the code yet. But ^^^ should be

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

right?
