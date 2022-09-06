Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9025AF7A2
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 00:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiIFWHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 18:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIFWHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 18:07:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28156E887;
        Tue,  6 Sep 2022 15:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A1FA615BB;
        Tue,  6 Sep 2022 22:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16DFC4347C;
        Tue,  6 Sep 2022 22:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662502036;
        bh=ggBXNpbprbbjS+tHbwc/iRG/UM2KC8UOk0AZEUifhqk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rDpSG2kA7vs8fAsaE6Xqe/+Q44EwBBrPZbQ+qJslk3bQqpII6EdhGqOXw54hSIZcn
         d1yapkHDXKYHylEUxzGEfXz2jY6zj3eq0j8ybDMRDwV7uaoNhhiuHs9AfSpxEcC1cb
         Bod3s4v7IY2WXL2Q+DZN4AdN2KmL68UiEtz7kWD1FmT+qbPsKgEIYTjnBMsrfpPbGW
         0oJv/5YkWlXFvaNJz6ghEllZ7qqfUmU5nav9eCxON2KReVo6XJvhMpBCCo6qONQyyC
         Z6PJHFTwknnoLstAgxg2QKrpxP8idfSzdz9r/KofRqKyxZiajcQ6WtEIGkJ8Xj4i5O
         HPEfRaojI4Cug==
Received: by mail-ot1-f46.google.com with SMTP id h20-20020a056830165400b00638ac7ddba5so9014863otr.4;
        Tue, 06 Sep 2022 15:07:15 -0700 (PDT)
X-Gm-Message-State: ACgBeo34GgT0UYeQnB2CXF6sS5gEgzE616cz8+BkGjx30mo9BTmT7Wlc
        /Uj4C7ekg47JZQhAx75xxvpg7yKvFsm2FVwLLxE=
X-Google-Smtp-Source: AA6agR5iLz+d4dflDQEnkd22ERc4VQyxcQxSSl+JiGq7Q1igXFXtVFY3F5yQ6aHbLp1d+Bp97nAc2Fk8bSiBPlTF4Q8=
X-Received: by 2002:a9d:7c94:0:b0:636:f74b:2364 with SMTP id
 q20-20020a9d7c94000000b00636f74b2364mr248408otn.165.1662502035160; Tue, 06
 Sep 2022 15:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220905193359.969347-1-toke@redhat.com> <20220905193359.969347-4-toke@redhat.com>
In-Reply-To: <20220905193359.969347-4-toke@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Sep 2022 15:07:04 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Aui-DquaZQGM0EgJXei9UCweB8bqv7KOhegVJR-fKZA@mail.gmail.com>
Message-ID: <CAPhsuW5Aui-DquaZQGM0EgJXei9UCweB8bqv7KOhegVJR-fKZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] bpf: Use 64-bit return value for bpf_prog_run
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 12:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> BPF ABI always uses 64-bit return value, but so far __bpf_prog_run and
> higher level wrappers always truncated the return value to 32-bit. We wan=
t
> to be able to introduce a new BPF program type that returns a PTR_TO_BTF_=
ID
> or NULL from the BPF program to the caller context in the kernel. To be
> able to use this returned pointer value, the bpf_prog_run invocation need=
s
> to be able to return a 64-bit value, so update the definitions to allow
> this.
>
> To avoid code churn in the whole kernel, we let the compiler handle
> truncation normally, and allow new call sites to utilize the 64-bit
> return value, by receiving the return value as a u64.
>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Song Liu <song@kernel.org>
