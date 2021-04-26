Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A64636AF7A
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhDZIKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 04:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbhDZIIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 04:08:49 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A74CC061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 01:08:08 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id r128so59936119lff.4
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 01:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5NsG9mqD3X1aAKJzc66v8dsrFLWvkG6sC5U1QqeHF8A=;
        b=X/P3ycOi6YyAIEma+DpmbuS961EpLUuf66D2tSQtRgpQOSdwIFIoadsn7myNCHrtod
         SzfFK8FWV9kIIIvDg3aU3fWbQ3gdzAw9dmh5owX6VeM16ko2u2SSibQQZs2q+WCSp2n1
         ZXmqUY3S7UiTjlvwXtjUh9IxLJbMti7ZnpTz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5NsG9mqD3X1aAKJzc66v8dsrFLWvkG6sC5U1QqeHF8A=;
        b=g6ZqcLVvtUy2uoPMZHnktnp+9xweVEaOdf538Y5Vw/iLSPiBBY+S1LqHNNOF2qgbZF
         tlvD2QNSV32Ibq3SKJIXe/NEG2TW7C5i1baz6WX3aZHKFjkUf+XI8o5Otp51wzGa/kQh
         lPOdQrhCCD+R5DOjGARqB/oYGDM78GL6pBr/2b5QbQn5BFeYu0seBQXjhzUa+yJUIELr
         dLC4jhP7YYcp4a4p6EvFkShOFqjzSBa/GPuFq4r2OVe5qJY/qsO7w7J4+5Pk0r5VbNMJ
         kOGwhp6jpSF+MbkNvHa/OcLjiaEQpk3ajRVhlv+5rJ2Ii9WwoMp5rlh/lGglRLEEjHnG
         0cwQ==
X-Gm-Message-State: AOAM533sM9aYcUAWi+wDtdfTBxfyVEMpV8pjtKipmLYpIPe0k1dZW6jA
        utT6ncADjK0nPo1ZTa783wYDeUgt4HWx0ThH5/is5Q==
X-Google-Smtp-Source: ABdhPJycPSZBuGHFfbjDvbQyVEsIGAR4uEIbmsfd8KJWJltBxS9hup6Ltdr+bha/XhIIiQ49ersqJ/GopBNBAzoKcJU=
X-Received: by 2002:ac2:4d08:: with SMTP id r8mr11629565lfi.97.1619424486692;
 Mon, 26 Apr 2021 01:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210423233058.3386115-1-andrii@kernel.org> <20210423233058.3386115-3-andrii@kernel.org>
In-Reply-To: <20210423233058.3386115-3-andrii@kernel.org>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 26 Apr 2021 09:07:55 +0100
Message-ID: <CACAyw9_Ge8TirBZ8qs+y5cBw3cosFb0cAOvBpg58Oo7j5BpvbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: support BTF_KIND_FLOAT during type
 compatibility checks in CO-RE
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Apr 2021 at 00:36, Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Add BTF_KIND_FLOAT support when doing CO-RE field type compatibility check.
> Without this, relocations against float/double fields will fail.
>
> Also adjust one error message to emit instruction index instead of less
> convenient instruction byte offset.
>
> Fixes: 22541a9eeb0d ("libbpf: Add BTF_KIND_FLOAT support")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index a1cddd17af7d..ff54ffef433a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5141,6 +5141,7 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
>
>         switch (btf_kind(local_type)) {
>         case BTF_KIND_PTR:
> +       case BTF_KIND_FLOAT:

Nit: update the function comment as well?

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
