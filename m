Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8E76A489C
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjB0Rwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjB0Rw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:52:29 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932D824132;
        Mon, 27 Feb 2023 09:52:25 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id i34so29186281eda.7;
        Mon, 27 Feb 2023 09:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q+m561GjnwLywUwkepYfU/MdfZ1CXkQKnKdDtJywkI8=;
        b=ltpdtgzT23k4uFI6PYBQUEA0hCHAz0hIumrZNrV+5VKRvBavjgHoBoaOoD73z+nk51
         gEWQ8yhwuMr7UvJ5JyVzl666k93kS4WqgHqNM3vJrsM1S3xx1Nglp9Hf9nod6yYwJOTX
         banb6FkfRnyBTT+hcDbMtyRc2WmrbYr9g9sI/IfcPXUR6W7R8OFyAZesnwJsPB5W1j+G
         WdXSQ4mt64mUgeFhWEZZmVjkk4A4MgrZ7CIAZLut+jVhX+vdgPIiix4iXxdEyhB+eXTV
         gLHnEyiEIOGXwXeFz7+jzU9ia3QEUYLen338aM0Kn57kH+egTuj2mZrDw2583gE2WHw6
         +dCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q+m561GjnwLywUwkepYfU/MdfZ1CXkQKnKdDtJywkI8=;
        b=GV7+I8daCwdHVI1fcfyKnCMSJ7ecCow5o6vo9bLks4xmOq41A3IO5Rp3fvDWc2f8hc
         8jf+uabyD/Yg+MiQlCuHsugUEvZ7DGVTs5K2MRFC1nQKSF9mdLMDBEBhMRylBNXM8nNq
         c3gqsdMUng6TTmLdEqdq4AQl1ViEiNPgPCHZLxxqBHqZibu1FmBWXHMGN1vovdZOTJGh
         WwBN6NwxC1Ph2M/mffYYKOID16c8wW22KXjk3PCw/jYZghBO8rTkTnLdp52kiWXNxDlg
         SEVHowyNL41kfzC8W9PfCL9qCkOjMf7/BetEkNja/mXilV4GSK9UUoeKZktdYj6QQULM
         goQw==
X-Gm-Message-State: AO0yUKWAjOZg9h2C3uRo0B2pf4V2bB3VUHaIvQ1/DznqVdUm9VxVC6nN
        byL2WKBLi/3up8vSv0qmflc8h/9Jtn6O65EcXfc=
X-Google-Smtp-Source: AK7set+/jAOhi0epDgw8SI+J88+YH5lnM5u0QZmWlUJbyb5pt9B+evszzgZJMjGkdV72JkK8aUtSqcIuHpkqXCfjrC0=
X-Received: by 2002:a05:6402:3216:b0:4ad:7bb2:eefb with SMTP id
 g22-20020a056402321600b004ad7bb2eefbmr6860832eda.3.1677520343875; Mon, 27 Feb
 2023 09:52:23 -0800 (PST)
MIME-Version: 1.0
References: <20230223030717.58668-1-alexei.starovoitov@gmail.com> <20230223030717.58668-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20230223030717.58668-3-alexei.starovoitov@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 27 Feb 2023 09:52:10 -0800
Message-ID: <CAADnVQ+zGtr-3SKygs-bHfSf=+Oq93U8tV3WN6ywb0GfFv853g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: Introduce kptr_rcu.
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        David Vernet <void@manifault.com>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 7:07=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 7d12d3e620cc..affc0997f937 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -176,6 +176,7 @@ enum libbpf_tristate {
>  #define __ksym __attribute__((section(".ksyms")))
>  #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")))
>  #define __kptr __attribute__((btf_type_tag("kptr")))
> +#define __kptr_rcu __attribute__((btf_type_tag("kptr_rcu")))

Realized that the mechanism can work without requiring bpf prog
to use this new tag.
The kernel can determine whether __kptr is RCU or not
via rcu_protected_object().
So BPF_KPTR_RCU vs BPF_KPTR_REF will be kernel internal distinction.
Eventually all __kptr kernel objects will be RCU anyway.
I'll respin.
