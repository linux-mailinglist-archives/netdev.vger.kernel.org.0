Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA830108159
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKXBYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:24:47 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34682 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXBYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:24:47 -0500
Received: by mail-lj1-f194.google.com with SMTP id m6so4266502ljc.1;
        Sat, 23 Nov 2019 17:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hd3coW9C+3sh8klk/Rw3EaJsQ0yjraDdfwBO9Z6KvV8=;
        b=qxyHwA2XX1zE93uv3H1C8aaqPTEiOSxghf9wrV90gF8Q4/CgWSnwwrRt/yFYMCBiHz
         ZZEDKnf8ZUTF1bI10rA6PUS3RN16BfwFG6EiruM3mlbgvzJq+q7Z09RVwbxvCEJygJ8q
         xuPDAPIZXNHBLopkssyDzw4PJUlu73XnluJCP6JxO5QityiUHDLusaqkCszLwjguSo3p
         zgL+GCOMkpQJZtC1VbrJCm4rks/ox8+7qB/RDNd9x3c/cBaHyureu5Ftq4g74yUg8dvR
         R3xDGqed4xUFF2vbgG+/ocJBNFRM0ji6gsaCRJNc6BGd/PQgW1lhi1+zHmgdvAAUGIlx
         u/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hd3coW9C+3sh8klk/Rw3EaJsQ0yjraDdfwBO9Z6KvV8=;
        b=gpqJMJyKflMdLG8EBQUhHe3ZLxMaFN6NqUOUyRyOwjSICYs5FGk4SXiFOMt+xnf8aP
         vu+qYEKoZH342/Ubuv+lAbAGZMF5hwYpmSEoJdvL60x08fr3GsziJ1h5iDd5ONocDfvL
         RDI99NiUTtjoGM+FLeWyBNHlqc9gQsmfMpJKyl6zKS72E+doxGEk/38ezFyJyfeVX16k
         4va5+oFrN9QmgWlqGuQlTtU7jjCLXeeuUDS0LpDg9G18AZkWWtyLGrwJ+gMoYvOw09/5
         UCpmlc/paYKbgEjuyKl4SuQBd/XOjjP6EpZWBoB1lWR374p4yBdQXY6TRuMym72HiiL/
         yOGQ==
X-Gm-Message-State: APjAAAWPEr/00D709icgd3pY3hzPxTFgoEazP2SJ4ORuv4isiwtn5Qgj
        bnr29PQRORPedbvNTgj9ptTzvWS90+N2iSOcjVA=
X-Google-Smtp-Source: APXvYqwJnF6eBHVguMMFSxhGLsWhcxFJMtOuu4LMQULLCxlyRq548AQb1a6ZT+hbT0MWFf7g/vDuQzHQUxy45iavmYE=
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr17175073ljj.243.1574558685015;
 Sat, 23 Nov 2019 17:24:45 -0800 (PST)
MIME-Version: 1.0
References: <fcb00a2b0b288d6c73de4ef58116a821c8fe8f2f.1574555798.git.daniel@iogearbox.net>
In-Reply-To: <fcb00a2b0b288d6c73de4ef58116a821c8fe8f2f.1574555798.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 23 Nov 2019 17:24:32 -0800
Message-ID: <CAADnVQ+oH6MsP=TKU2kStj0SPqeXf1D=+MpMqrnuqGWdMPS70Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: simplify __bpf_arch_text_poke poke type handling
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 4:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Given that we have BPF_MOD_NOP_TO_{CALL,JUMP}, BPF_MOD_{CALL,JUMP}_TO_NOP
> and BPF_MOD_{CALL,JUMP}_TO_{CALL,JUMP} poke types and that we also pass in
> old_addr as well as new_addr, it's a bit redundant and unnecessarily
> complicates __bpf_arch_text_poke() itself since we can derive the same from
> the *_addr that were passed in. Hence simplify and use BPF_MOD_{CALL,JUMP}
> as types which also allows to clean up call-sites.
>
> In addition to that, __bpf_arch_text_poke() currently verifies that text
> matches expected old_insn before we invoke text_poke_bp(). Also add a check
> on new_insn and skip rewrite if it already matches. Reason why this is rather
> useful is that it avoids making any special casing in prog_array_map_poke_run()
> when old and new prog were NULL and has the benefit that also for this case
> we perform a check on text whether it really matches our expectations.
>
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Applied. Thanks
