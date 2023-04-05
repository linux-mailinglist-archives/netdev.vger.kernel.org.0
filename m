Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5D66D7117
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjDEACt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbjDEACr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:02:47 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576574225;
        Tue,  4 Apr 2023 17:02:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so136952214ede.8;
        Tue, 04 Apr 2023 17:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680652961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sajaxmMahmXJsqBBidZXJtFL+zJtBXJ0j2OvCE7uZXQ=;
        b=kBSRVNMf8stDpKpnB2IbLzb9rAupVEjZ0NeQkFfvRsJ4vqSmLMSRRpKa5k1ujKZR2J
         rDoLZ/ZfJ0JH+J51uKeFcgTnbsR0ZW0sn+QT6fa33s0z+8SD3I7NaWihPw7RzPthPYbs
         J91pi2+JXfiY8j4cdHpLv8qfPZ2vdyLN13RuS9o+Jy8Mil36UE1H/pCS5MAk1YafAjYN
         +Q92rFoFnoggauCs6uVOhSgfy6M5V1zhrzcZTmqjv9wWEnZxK6QQ3ywQzXxPd8EmtZPM
         v1sGA1O63yMo6bEnpGmbGly9x1g5CE0NU4h8KOk1mMQ4WY23zCIZGzLiJ4uX9OoTGwND
         +2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680652961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sajaxmMahmXJsqBBidZXJtFL+zJtBXJ0j2OvCE7uZXQ=;
        b=wVJOc8XUJzyX3ZKoy7IoJ5FE5d6+xrtgQXj1igCmwwXr4fJNBJBdb74PHVIKcX5O6V
         RZ/61ZkYhYaDLmwcuGE3O1NM3fZoizM9amrGvUbjdUvhpfzZ0H6y3DDsY8ZkuatPA3ps
         0Eku/KCFWEyzVq+nOwkaFWUQd65g5JMzTrIw9IorFXPYz640Y9tv/A0QTiRyNPP35mar
         tQXM+koQADLYmDdGUiV+aiSyzapr3SdJwu1Q05wjPSi7JbIP0WY0jTtTsfxeijrp7LUe
         1DNWxPyqK2gh/8H90snSnVC6neFwW9J31fxQojo4lpgSjfSmmx1lhoJVyxAPxvRyHz2h
         k94g==
X-Gm-Message-State: AAQBX9cixUySW5MyeESrvET6HcFe6V1sf6g5RBibXurtPie+C2gw8boD
        d01yFM4TlL3a5H4NYYGaiZUQLxe9Scl4EWILj0M=
X-Google-Smtp-Source: AKy350aUupLMnziCVWDpLtzONYiliywjFtW0gweshuvMpDMV6WC+b3jxqeWB2CQGMUvVHD8pOlWp1E5BNCrlnPP5HWQ=
X-Received: by 2002:a17:906:fada:b0:932:38d5:ff86 with SMTP id
 lu26-20020a170906fada00b0093238d5ff86mr722684ejb.5.1680652960642; Tue, 04 Apr
 2023 17:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com> <20230404145131.GB3896@maniforge>
In-Reply-To: <20230404145131.GB3896@maniforge>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Apr 2023 17:02:28 -0700
Message-ID: <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the verifier.
To:     David Vernet <void@manifault.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 7:51=E2=80=AFAM David Vernet <void@manifault.com> wr=
ote:
>
> On Mon, Apr 03, 2023 at 09:50:21PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > The patch set is addressing a fallout from
> > commit 6fcd486b3a0a ("bpf: Refactor RCU enforcement in the verifier.")
> > It was too aggressive with PTR_UNTRUSTED marks.
> > Patches 1-6 are cleanup and adding verifier smartness to address real
> > use cases in bpf programs that broke with too aggressive PTR_UNTRUSTED.
> > The partial revert is done in patch 7 anyway.
> >
> > Alexei Starovoitov (8):
> >   bpf: Invoke btf_struct_access() callback only for writes.
> >   bpf: Remove unused arguments from btf_struct_access().
> >   bpf: Refactor btf_nested_type_is_trusted().
> >   bpf: Teach verifier that certain helpers accept NULL pointer.
> >   bpf: Refactor NULL-ness check in check_reg_type().
> >   bpf: Allowlist few fields similar to __rcu tag.
> >   bpf: Undo strict enforcement for walking untagged fields.
> >   selftests/bpf: Add tracing tests for walking skb and req.
>
> For whole series:
>
> Acked-by: David Vernet <void@manifault.com>

Added David's acks manually (we really need to teach pw-apply to do
this automatically...) and applied. I've added a single sentence to
patch #1 with why (I think) btf_struct_access() callback
simplification was done, I didn't want to hold the patch set just due
to that, as the rest looked good. But please do consider renaming the
callback to more write-access implying name as a follow up, as current
situation with the same name but different semantics is confusing.

Applied to bpf-next, thanks.

>
> I left one comment on 4/8 in [0], but it's not a blocker and everything
> else LGTM.
>
> [0]: https://lore.kernel.org/all/20230404144652.GA3896@maniforge/
