Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EB81BF25C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgD3INd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgD3INd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:13:33 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32E4C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 01:13:31 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so5695307wrt.5
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 01:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=S26iDR5wiFrSlBw+/Sqtg08lFgjLtyBozvtbShjn61Y=;
        b=pTvelUQ+zdPy9VKa02LtKHv3qmi3+WZYYOUBtJB+GxiRulqGC7PbCYETbq1Y6bLGyO
         IVHO2Bar5whefojm2f+DZ5OymKBa2qS3gDxuNKlX820aNuTJai9zLENWVTXVaKskUiCc
         zH/JduLJfFZU74TVWC72WISGslKVUDt5Fq5kY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=S26iDR5wiFrSlBw+/Sqtg08lFgjLtyBozvtbShjn61Y=;
        b=N2TolFOlC4/67O3cCbTQ+OyG1X0eV17/dZpBurCoLXrqXPhJwGW321qrvUNlUDPcaG
         L6gca5bzdrtS5fdYyCviTJqhaBBRhUmsprmQuqzhCVSG1fjlvpF9izTRhDJ0CE97eqb2
         h4ZMclVlQSP5BDznkj/k0PpNN8Iokp36ez+88FUykMw5sfmpZCVSLDcK5NTuBMofZxD8
         DZnMfNh9s2xtBSgzYHorxBqtsIQgfoM4vKJO1SiONy1CZsLgurhpoB8CkJCLQcgHREym
         GsgeM8n1VaOuWTFqqQ23dDO/PRcDHCrsUFc3yMGhIMPWCCziNPPfLVdAUzQ/J8zZwWoj
         xCNw==
X-Gm-Message-State: AGi0PuZF/XSbs3PQELx2H8jwMyl7FnesUOhatEvX1GvvAj23scb5ULIV
        6uPq0PTij4KJ557aqvufGRVh8w==
X-Google-Smtp-Source: APiQypLvst+AtmPsyQgU2WZy0y3Y0J8quxpfpb0fOzCKml+3rJRIiOzy/41XYMewpzXoV1FZ57ZFYA==
X-Received: by 2002:a5d:6b8a:: with SMTP id n10mr2607952wrx.36.1588234410414;
        Thu, 30 Apr 2020 01:13:30 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v1sm2992098wrv.19.2020.04.30.01.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 01:13:29 -0700 (PDT)
References: <20200430021436.1522502-1-andriin@fb.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next] libbpf: fix false uninitialized variable warning
In-reply-to: <20200430021436.1522502-1-andriin@fb.com>
Date:   Thu, 30 Apr 2020 10:13:28 +0200
Message-ID: <87imhhv1av.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 04:14 AM CEST, Andrii Nakryiko wrote:
> Some versions of GCC falsely detect that vi might not be initialized. That's
> not true, but let's silence it with NULL initialization.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index d86ff8214b96..977add1b73e2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5003,8 +5003,8 @@ static int bpf_object__collect_map_relos(struct bpf_object *obj,
>  					 GElf_Shdr *shdr, Elf_Data *data)
>  {
>  	int i, j, nrels, new_sz, ptr_sz = sizeof(void *);
> +	const struct btf_var_secinfo *vi = NULL;
>  	const struct btf_type *sec, *var, *def;
> -	const struct btf_var_secinfo *vi;
>  	const struct btf_member *member;
>  	struct bpf_map *map, *targ_map;
>  	const char *name, *mname;

Alternatively we could borrow the kernel uninitialized_var macro:

include/linux/compiler-clang.h:#define uninitialized_var(x) x = *(&(x))
include/linux/compiler-gcc.h:#define uninitialized_var(x) x = x
