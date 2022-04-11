Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EB04FB254
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 05:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244548AbiDKD3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 23:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244544AbiDKD3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 23:29:00 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F30D2D1FC;
        Sun, 10 Apr 2022 20:26:47 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id b17so3511528ilq.5;
        Sun, 10 Apr 2022 20:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BahJNSgLJq4kBzMY612L60h5U5MFfugKor4rsSKasAw=;
        b=EIMJkhLVokFQbg6IzhxACU9edRQhLI4daftgPVPkJLSu/xi+sCqkPYB6qGrjJYPHmr
         ykx7lwsvkHpEHrpzwY6UsS3LjzrtrNw3e62IXARbo+2wRKl6azPjaYq+Oth25qNZRiFr
         lkVcELKavGUcRMJvakNgO7/TxZtgHv4Dds0HrQeqpdgOX5zI5g8L4Z/NXcpBqrv5B11+
         z3aRVKjDRVh9nUms09U1AoW5C7C3OniImX3mBoqrIPEP7ZKO/DgOoONgPuH0oX6fbJ4F
         AS1+aixwSCV5RyCeyw6WlBL4YBdgN18KwVQbvoTZ1/ylCeW8XqvRMp7YPVGk/fNZkHgi
         KIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BahJNSgLJq4kBzMY612L60h5U5MFfugKor4rsSKasAw=;
        b=lck9kFaEnNMcfdffqJzG9R48N98/nw2aO3d/ksF578PCqGxIckNrOOsvB0NQugwpOo
         gWS3ydCcUVv/AVNBBOR15O/b1p612m3RVV1mpO9LxaOPH10d/61T/ixnpZaBoSzApNK8
         XpehniHWfsfSFwF7x86LjI/wxaYiocCFkpc+e0kHNrrRxZFG7QohJydvt5c9bQsTucGM
         hdRKi07xG4OZva8OE+pbeBGUGCSwGrXFjxlbityCIBTY/2AhFCNvZv2ooIclZFKQeaiA
         d989rFemyV5k/hYE6w22RN/u15afsnQvpPsf6rnzdTV+vX1Y7HMigCMLiCyXd89KxO3t
         CSOQ==
X-Gm-Message-State: AOAM531zj4yvUvR+lDf0eOI/bgHUKhdtnb6OTdu4jAfSCJBaiEP8mj9O
        H59LlYmAPCw5uGGK84tjFzpyj86RjkWCw/3AgXE=
X-Google-Smtp-Source: ABdhPJx9K11eWCNLWXW4MYteIQ9E2MfVkekq2TWExNGjhWfhgDyyFxAXTAPMK1Es9tAyGN3WkqXIH7Kcmf/4E5a0f64=
X-Received: by 2002:a92:cd8a:0:b0:2ca:9337:2f47 with SMTP id
 r10-20020a92cd8a000000b002ca93372f47mr4487574ilb.252.1649647607050; Sun, 10
 Apr 2022 20:26:47 -0700 (PDT)
MIME-Version: 1.0
References: <1649458366-25288-1-git-send-email-alan.maguire@oracle.com> <1649458366-25288-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1649458366-25288-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 10 Apr 2022 20:26:36 -0700
Message-ID: <CAEf4BzaDXhwApr=DrGj3a9mG-efTn_kuROWGNRSCWa3SFA8+mg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: usdt: factor out common USDT arg handling
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 8, 2022 at 3:53 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Common code to initialize a struct usdt_arg_spec can be factored out
> from arch-specific flavours of parse_usdt_arg(); signed size,
> bitshift handling etc.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

I understand that there is a bit of repetition between multiple
architectures, but I think this init_usdt_arg_spec() helper is
actually hindering understand. Can you please drop this refactoring
for now? It's just a few lines of code that you'll need to copy/paste
for argument bit shift handling, not a big deal, right?

>  tools/lib/bpf/usdt.c | 90 ++++++++++++++++++++++++----------------------------
>  1 file changed, 41 insertions(+), 49 deletions(-)
>

[...]
