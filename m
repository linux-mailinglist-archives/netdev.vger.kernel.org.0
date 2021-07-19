Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089213CF03B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386343AbhGSXHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbhGSWH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 18:07:29 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F714C08EA7C;
        Mon, 19 Jul 2021 15:31:53 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id a16so30104324ybt.8;
        Mon, 19 Jul 2021 15:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a6nTlCczBubJeeLJwO3JRXwlA8aijOD64z9YKs0Er54=;
        b=AtX3Zf/A/mRdVqiH/xpmUxXSLXCxsg2c0XnnlhBVvcZLyaexTvcxfFxmU+X5pAZZpP
         nPGEWwAeoaj29NczvYVJqhUINAXpuNES4Ld4dLVRsYowzCU5iTi9ltxF3U7kubgIeyK5
         lWeHs3teLXJsFzh4I760t8DblXIFEtURtx21jotZcKnNhlI/QIpXlL/lRG064727KyLm
         YX9P+9yQZnO6rp1332PKortf0kX0SGdmL3r0jsddxM78Mk9D7sGcK368QkMIIKXiEKPw
         7wAV813MGz72fARDRZQf14yHWiX7CKT9zt2qjKcaCepGZzpwNffB4kbsb8b2/3I5B8Xy
         X15A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a6nTlCczBubJeeLJwO3JRXwlA8aijOD64z9YKs0Er54=;
        b=ow2j4jMsQK+/2v1wLdMJifz5WarTbb9c+pdQW1D5KrurJcAtI+6aSx96+ov8LiljlB
         jLCJ5335ydjejtxaWE1GX/jHdkHsFWqwJYBeq+Cz2DK4OE2mZQEw1oZMnlHPysOrUPU7
         Ok4tnYGfNj24u+MASHWiLnAPrtlh9+VU2RfsVJaC9sMmNLMx3WJDrMxVafwlFMtRPcyR
         8I9gdderE69sO5+Gpzy1hECKDfyOOA8DZhAIevAEY/9u0LU/1Y2YzQq8Mbonl/+rfDWK
         7yf/ZiX6ehWZrAWbnHicK4/dh0nEzMCeuvYfRz52uL8XfhSinW/vYmrTxH1doq3IIsZz
         0yhw==
X-Gm-Message-State: AOAM531nRwXLT3T9zRHwMEnXqqwqUugt3NHM4slg0pmqkMdl8muvkf2c
        Z8MUWiCPqsMNWccECuNK0D84JCNxh/Eh7iqgRUI=
X-Google-Smtp-Source: ABdhPJyZ09xgWNlI7GKlcY7SDDD63Th6GjQ/3rv9Oha/WRGv4dadKPuK+QRqy9QW794nt0VUhpvQbO4j9AYcUzC0+B8=
X-Received: by 2002:a25:9942:: with SMTP id n2mr35195752ybo.230.1626733912580;
 Mon, 19 Jul 2021 15:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210719085134.43325-1-lmb@cloudflare.com>
In-Reply-To: <20210719085134.43325-1-lmb@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 19 Jul 2021 15:31:41 -0700
Message-ID: <CAEf4Bza-Zy-ichEEPUaLgNCW5-HoRW-w7-Na7VyGrdbvi=fGzw@mail.gmail.com>
Subject: Re: [PATCH bpf v2 0/1] bpf: fix OOB read when printing XDP link fdinfo
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 1:51 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> See the first patch message for details. Same fix as before, except that the
> macro invocation is guarded by CONFIG_NET now.
>
> Lorenz Bauer (1):
>   bpf: fix OOB read when printing XDP link fdinfo
>

Applied to bpf tree, thanks. There is no need to send a cover letter
for a single patch, though, and it didn't contribute much to the
description in this case, so I dropped it.

>  include/linux/bpf_types.h | 1 +
>  1 file changed, 1 insertion(+)
>
> --
> 2.30.2
>
